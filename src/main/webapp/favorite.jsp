<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper, java.util.Map, java.util.List, java.util.ArrayList, java.util.HashMap" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<link rel="stylesheet" href="./css/favorite.css">

<%@ include file="header.jsp" %> <!-- 헤더 포함 -->

<main>
    <h1> <%= username %>님의 즐겨찾기</h1>
    <%
        List<Map<String, String>> books = (List<Map<String, String>>) request.getAttribute("books");
        if (books == null || books.isEmpty()) {
    %>
        <p>즐겨찾기 항목이 없습니다.</p>
    <%
        } else {
    %>
    
              <ul>
            
            <% for (Map<String, String> book : books) { %>
              <a href="BookDetail.jsp?bookId=<%=book.get("id")%>" class="search-result">
                <li class="book-item">
                    <img src="<%= book.get("thumbnail") %>" alt="책 이미지">
                    <div class="book-info">
                        <h2><%= book.get("title") %></h2>
                        <div class="book-detail">
                            <p>저자: <%= book.get("authors") %><br> 출판사: <%= book.get("publisher") %> | 출판일: <%= book.get("publishedDate") %></p>
                        </div>
                    </div>
                    <form action="favorite" method="get" class="delete-form">
                        <input type="hidden" name="book_id" value="<%= book.get("id") %>">
                        <button type="submit" class="delete-button">삭제</button>
                    </form>
                </li>
               </a>
            <% } %>
           
        </ul>
    <% } %>
</main>

<%@ include file="footer.jsp" %> <!-- 푸터 포함 -->

<!-- Bootstrap JS 추가 -->
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>



</body>
</html>