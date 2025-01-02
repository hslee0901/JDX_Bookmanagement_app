<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %> <!-- 헤더 포함 -->
<link rel="stylesheet" href="./css/index.css">

	<main>

		<div class="search">
			<form class="search-box" action="search.jsp" method="get">
				<input class="search-txt" type="text" name="query"
					placeholder="책 이름 혹은 저자를 입력하세요.">
				<button class="search-btn" type="submit">
					<i class="fa-solid fa-magnifying-glass"></i>
				</button>
			</form>
		</div>
		<div class="recommend">
		<%@ include file="recommend.jsp" %> <!-- 추천도서 포함 -->
		</div>
	</main>
<%@ include file="footer.jsp" %> <!-- 푸터 포함 -->	