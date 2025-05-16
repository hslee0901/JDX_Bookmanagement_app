<%@ page
	import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL, 
	java.net.URLEncoder"%>
<%@ page
	import="com.fasterxml.jackson.databind.ObjectMapper, java.util.Map, java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="header.jsp"%>
<!-- 헤더 포함 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 검색</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<script src="https://kit.fontawesome.com/f10167bfad.js"
	crossorigin="anonymous"></script>

<link rel="stylesheet" href="./css/search.css">
<link rel="stylesheet" href="./css/header_footer.css">

<script src="./js/search.js"></script>

</head>
<body>
	<main>
		<h2>도서 검색</h2>
		<!-- 검색 폼 -->
		<form method="get" action="search.jsp">
			<div class="form-group text-center">
				<div class="input-group" style="max-width: 600px; margin: 0 auto;">
					<!-- 검색 유형 선택 -->
					<div class="input-group-prepend">
						<select id="searchType" name="searchType" class="custom-select">
							<option value="title"
								<%="title".equals(request.getParameter("searchType")) ? "selected" : ""%>>제목</option>
							<option value="author"
								<%="author".equals(request.getParameter("searchType")) ? "selected" : ""%>>작가</option>
						</select>
					</div>
					<!-- 검색어 입력 -->
					<input type="text" id="query" name="query" class="form-control"
						placeholder="검색어를 입력하세요"
						value="<%=request.getParameter("query")%>">
					<div class="input-group-append">
						<button type="submit" class="btn btn-primary">검색</button>
					</div>
				</div>
			</div>
		</form>

		<hr>

		<h2>도서 검색 결과</h2>

		<%
		// 검색 파라미터 수집
		String query = request.getParameter("query");
		String searchType = request.getParameter("searchType"); // 제목 또는 작가

		int startIndex = 0; // 기본값
		int maxResults = 20; // 한 페이지에 표시할 결과 수
		int maxTotalResults = maxResults * 3; // 전체 결과 제한

		String pageIndexParam = request.getParameter("startIndex");
		if (pageIndexParam != null && !pageIndexParam.isEmpty()) {
			startIndex = Integer.parseInt(pageIndexParam); // 현재 페이지의 시작 인덱스
		}

		if (query != null && !query.isEmpty()) {
			try {
				// 검색어를 URL 인코딩
				String encodedQuery = URLEncoder.encode(query, "UTF-8");

				// Google Books API 요청 URL 생성
				StringBuilder apiUrlBuilder = new StringBuilder("https://www.googleapis.com/books/v1/volumes?q=");
				if ("author".equals(searchType)) {
			apiUrlBuilder.append("inauthor:").append(encodedQuery); // 작가 검색
				} else {
			apiUrlBuilder.append(encodedQuery); // 기본 제목 검색
				}
				apiUrlBuilder.append("&startIndex=").append(startIndex).append("&maxResults=").append(maxResults)
				.append("&key=").append("api키를 넣는 곳"); // API 키 ================================================================api키=====

				String apiUrl = apiUrlBuilder.toString();
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
				Map<String, Object> jsonMap = objectMapper.readValue(jsonResponse.toString(), Map.class);

				List<Map<String, Object>> items = (List<Map<String, Object>>) jsonMap.get("items");
				int totalResults = (int) jsonMap.get("totalItems");

				// totalResults를 maxTotalResults로 제한
				if (totalResults > maxTotalResults) {
			totalResults = maxTotalResults;
				}

				int totalPages = (int) Math.ceil(totalResults / (double) maxResults);

				if (items != null) {
			for (Map<String, Object> item : items) {
				Map<String, Object> volumeInfo = (Map<String, Object>) item.get("volumeInfo");

				String title = (String) volumeInfo.getOrDefault("title", "제목 없음");
				String subtitle = (String) volumeInfo.getOrDefault("subtitle", "");
				String publisher = (String) volumeInfo.getOrDefault("publisher", "출판사 정보 없음");
				String publishedDate = (String) volumeInfo.getOrDefault("publishedDate", "출판일 정보 없음");
				String bookId = (String) item.get("id");

				// 책 표지 이미지 URL 가져오기
				Map<String, Object> imageLinks = (Map<String, Object>) volumeInfo.get("imageLinks");
				String thumbnail = (imageLinks != null)
						? (String) imageLinks.get("thumbnail")
						: "./images/no-image.png"; // 기본 이미지 제공

				List<String> authors = (List<String>) volumeInfo.get("authors");
				String authorNames = (authors != null) ? String.join(", ", authors) : "작가 정보 없음";
		%>
		<a href="BookDetail.jsp?bookId=<%=bookId%>" class="search-result">
    <div class="container my-4 p-3 border rounded d-flex align-items-center">
        <!-- 책 표지 -->
        <img src="<%=thumbnail%>" alt="<%=title%>" class="mr-3">
        <!-- 책 정보 -->
        <div>
            <h3><%=title%></h3>
            <p><%=subtitle%></p>
            <p>작가: <%=authorNames%></p>
            <p>출판사: <%=publisher%>&nbsp; &nbsp; 출판일: <%=publishedDate%></p>

            <!-- 즐겨찾기 추가 폼 -->
            <!--<form action="favorite" method="post" style="display:inline;">
                    <input type="hidden" name="book_id" value="<%= bookId %>">
                    <button type="submit" class="btn btn-primary">즐겨찾기</button>
                </form>-->
            <% if (username != null) { 
            	
            %>  
  				<button type="button" class="btn btn-primary add-to-favorite" data-book-id="<%= bookId %>">
  			 	 즐겨찾기
				</button>
     		<%
            }
     		%>
        </div>
    </div>
</a>

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

		<hr>
		<%
		}
		} else {
		out.println("<p>검색 결과가 없습니다.</p>");
		}

		// 페이지네이션 표시
		int prevPageStartIndex = startIndex - maxResults;
		int nextPageStartIndex = startIndex + maxResults;
		%>
		<div class="pagination-wrapper">
			<nav aria-label="Page navigation">
				<ul class="pagination justify-content-center">
					<%
					// 전체 페이지 수 계산
					int currentPage = (startIndex / maxResults) + 1;
					int startPage = Math.max(1, currentPage - 2); // 시작 페이지
					int endPage = Math.min(totalPages, currentPage + 2); // 종료 페이지

					// 이전 페이지 버튼
					if (currentPage > 1) {
					%>
					<li class="page-item"><a class="page-link"
						href="search.jsp?query=<%=query%>&searchType=<%=searchType%>&startIndex=<%=startIndex - maxResults%>"
						aria-label="Previous">&laquo; 이전</a></li>
					<%
					} else {
					%>
					<li class="page-item disabled"><span class="page-link">&laquo;
							이전</span></li>
					<%
					}

					// 페이지 번호 표시
					for (int i = startPage; i <= endPage; i++) {
					int pageStartIndex = (i - 1) * maxResults;
					%>
					<li class="page-item <%=(i == currentPage) ? "active" : ""%>">
						<a class="page-link"
						href="search.jsp?query=<%=query%>&searchType=<%=searchType%>&startIndex=<%=pageStartIndex%>">
							<%=i%>
					</a>
					</li>
					<%
					}

					// 다음 페이지 버튼
					if (currentPage < totalPages) {
					%>
					<li class="page-item"><a class="page-link"
						href="search.jsp?query=<%=query%>&searchType=<%=searchType%>&startIndex=<%=startIndex + maxResults%>"
						aria-label="Next">다음 &raquo;</a></li>
					<%
					} else {
					%>
					<li class="page-item disabled"><span class="page-link">다음
							&raquo;</span></li>
					<%
					}
					%>
				</ul>
			</nav>
		</div>

		<%
		} catch (Exception e) {
		out.println("<p>도서 검색 중 오류가 발생했습니다: " + e.getMessage() + "</p>");
		}
		} else {
		out.println("<p>검색어를 입력하세요.</p>");
		}
		%>
	</main>
	<%@ include file="footer.jsp"%>
	<!-- 푸터 포함 -->
