<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper, java.util.Map, java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="header.jsp" %> <!-- 헤더 포함 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gamja+Flower&family=Kaisei+Opti&display=swap" rel="stylesheet">
<main>
<div class="container mt-5">
    <%
        String bookId = request.getParameter("bookId");
        if (bookId != null && !bookId.isEmpty()) {
            try {
                String apiKey = "apikey";  // API 키를 설정하세요.
                String apiUrl = "https://www.googleapis.com/books/v1/volumes/" + bookId + "?key=" + apiKey;

                URL url = new URL(apiUrl);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");

                BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder jsonResponse = new StringBuilder(); 
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonResponse.append(line);
                    
                }
                reader.close();

                ObjectMapper objectMapper = new ObjectMapper();
                Map<String, Object> item = objectMapper.readValue(jsonResponse.toString(), Map.class);
                Map<String, Object> volumeInfo = (Map<String, Object>) item.get("volumeInfo");

                String title = (String) volumeInfo.getOrDefault("title", "제목 없음");
                String subtitle = (String) volumeInfo.getOrDefault("subtitle", "");
                String publisher = (String) volumeInfo.getOrDefault("publisher", "출판사 정보 없음");
                String publishedDate = (String) volumeInfo.getOrDefault("publishedDate", "출판일 정보 없음");
                
                // 도서 설명
                String description = (String) volumeInfo.getOrDefault("description", "도서 설명 없음");

                List<Map<String, String>> identifiers = (List<Map<String, String>>) volumeInfo.get("industryIdentifiers");
                StringBuilder identifierStr = new StringBuilder();
                if (identifiers != null) {
                    for (Map<String, String> identifier : identifiers) {
                        identifierStr.append(identifier.get("type")).append(": ")
                                     .append(identifier.get("identifier")).append("<br>");
                    }
                } else {
                    identifierStr.append("식별 번호 정보 없음");
                }

                // 평점 정보
                double averageRating = volumeInfo.containsKey("averageRating") && volumeInfo.get("averageRating") instanceof Number 
                       ? ((Number) volumeInfo.get("averageRating")).doubleValue() : 0.0;
                int ratingsCount = volumeInfo.containsKey("ratingsCount") ? (int) volumeInfo.get("ratingsCount") : 0;

                // 이미지 링크
                Map<String, String> imageLinks = (Map<String, String>) volumeInfo.get("imageLinks");
                String imageLink = imageLinks != null ? imageLinks.getOrDefault("thumbnail", "") : "";
    %>

    <!-- 도서 표지 -->
    <div class="row mb-4" >
        <div class="col-md-4">
            <% if (!imageLink.isEmpty()) { %>
          <img src="<%= imageLink %>" class="img-fluid" alt="도서 표지 이미지" style="width: auto; height: 300px;">
            <% } else { %>
                <p>이미지 없음</p>
            <% } %>
        </div>

        <!-- 도서 정보 -->
		<div class="col-md-8" style="font-size: 1.56vw;">
            <h2 class="text-primary"><%= title %></h2>
            <p class="text-secondary"><%= subtitle %></p>
            <p><strong>식별 번호:</strong><br> <%= identifierStr.toString() %></p>
            <p><strong>출판사:</strong> <%= publisher %>&nbsp &nbsp <strong>출판일:</strong> <%= publishedDate %></p>
            <p><strong>평균 평점:</strong> <%= averageRating %> (평점 수: <%= ratingsCount %>)</p>

            <h5 class="mt-4" style="font-size: 1.56vw;">책 소개</h5>
            <p><%= description %></p>
            <%   
            if (username != null) { 
            	
            %>
            <button type="button" class="btn btn-primary add-to-favorite" data-book-id="<%= bookId %>">
  			  즐겨찾기
			</button>
		<% 
            } 
        %>
        
        </div>
    </div>

    <% } catch (Exception e) {
        out.println("<p>도서 정보를 불러오는 중 오류가 발생했습니다: " + e.getMessage() + "</p>");
    }
    } else {
        out.println("<p>유효한 도서 ID가 필요합니다.</p>");
    }
    %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
	$('.add-to-favorite').off('click').on('click', function(e) {
    	 console.log('Button clicked!'); // 버튼 클릭 로그
        e.preventDefault(); // 기본 동작 방지
        const bookId = $(this).data('book-id'); // 버튼의 book_id 값 가져오기
     
        
        // AJAX 요청
        $.ajax({
            url: 'favorite', // 서블릿 매핑 URL
            method: 'POST',
            data: { book_id: bookId }, // 서버로 전송할 데이터
            dataType: 'json', // 서버 응답을 JSON으로 처리
            success: function(response) {
                alert(response.message); // 서버에서 반환한 메시지 출력
            },
            error: function(xhr, status, error) {
                const errorMessage = xhr.responseJSON?.message || '오류가 발생했습니다.';
                alert('즐겨찾기 추가 실패: ' + errorMessage);
            }
        });
    });
});
</script>

</div>
</main>
<%@ include file="footer.jsp" %> <!-- 푸터 포함 -->
