<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.net.HttpURLConnection, java.net.URL, java.io.InputStream" %>
<%@ page import="com.fasterxml.jackson.databind.JsonNode, com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.util.Random, java.util.ArrayList, java.util.List, java.util.HashSet, java.util.Set" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./css/recommend.css">
</head>
<body>

<div class="recommend-container">
	<span class="recommend-title">추천 도서</span>
		
    
    <%
        // Google Books API에 다운로드 가능한 도서 중 무작위로 검색
        String apiUrl = "https://www.googleapis.com/books/v1/volumes?q=downloadable:true&langRestrict=ko&maxResults=40&key=apikey"; //key= 뒤에 api키를 넣어주세요
        URL url = new URL(apiUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");

        ObjectMapper mapper = new ObjectMapper();
     // 기본값으로 빈 JsonNode를 설정하여 초기화
        JsonNode searchResults = mapper.createObjectNode();

        try (InputStream inputStream = connection.getInputStream()) {
            searchResults = mapper.readTree(inputStream);
        } catch (IOException e) {
            if (e.getMessage().contains("HTTP response code: 429")) {
                out.println("<p>API 요청이 너무 많습니다. 잠시 후 다시 시도해 주세요.</p>");
            } else {
                searchResults = mapper.createObjectNode();
                throw new ServletException("API 요청 중 오류가 발생했습니다: " + e.getMessage(), e);
            }
        }


        // 검색 결과를 리스트에 저장 (표지가 있는 책만 필터링)
    List<JsonNode> books = new ArrayList<>();
    for (JsonNode item : searchResults.path("items")) {
        String thumbnailUrl = item.path("volumeInfo").path("imageLinks").path("thumbnail").asText("");
        if (!thumbnailUrl.isEmpty()) {
            books.add(item); // 썸네일이 있는 책만 추가
        }
    }
        
     // 중복 방지를 위해 선택한 책을 추적할 세트 사용
        Set<Integer> selectedIndexes = new HashSet<>();
        Random random = new Random();
        int numRecommendations = Math.min(5, books.size()); // 최대 5개 도서 추천
    %>

    <div class="book-container">
        <%
            int recommendationsCount = 0;
            while (recommendationsCount < numRecommendations) {
                int randomIndex = random.nextInt(books.size());
                
                // 이미 선택된 인덱스인지 확인
                if (selectedIndexes.contains(randomIndex)) {
                    continue; // 중복이면 건너뜀
                }

                // 새로운 책 선택
                selectedIndexes.add(randomIndex);
                JsonNode book = books.get(randomIndex);
                String bookId = book.path("id").asText();
                String title = book.path("volumeInfo").path("title").asText();
                String thumbnailUrl = book.path("volumeInfo").path("imageLinks").path("thumbnail").asText(""); // 썸네일 이미지

                recommendationsCount++;
        %>
        
        <div class="book-item">
      			<a href="BookDetail.jsp?bookId=<%= bookId %>"> 
                <%
                    if (!thumbnailUrl.isEmpty()) {
                %>
                <img src="<%= thumbnailUrl %>" alt="<%= title %>"><br>
                <%
                    }
                %>
                <span><%= title %></span>
            </a>
        </div>
        
        <%
            }
        %>
        </div>

</body>
</html>