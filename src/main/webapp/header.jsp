<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>도서 관리 시스템</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
<!-- 부트스트랩 -->

<link href="<c:url value='/webjars/bootstrap/5.3.3.1/css/bootstrap.min.css'/>" rel="stylesheet">
<link href="<c:url value='/webjars/bootstrap-icons/1.10.0/font/bootstrap-icons.css'/>" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gamja+Flower&family=Kaisei+Opti&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gamja+Flower&family=Kaisei+Opti&display=swap" rel="stylesheet">


<script src="https://kit.fontawesome.com/f10167bfad.js"
	crossorigin="anonymous"></script>
<!-- 아이콘 -->
<link rel="stylesheet" href="./css/header_footer.css">
<script src="./js/header_footer.js"></script>
</head>

<body>
	<div id="welcomeModal" class="modal">
		<div class="modal-content">
			<h3 id="welcomeMessage"></h3>
			<button onclick="closeModal()">닫기</button>
		</div>
	</div>
	<% 
    String username = (String) session.getAttribute("userName");
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");

    if (username != null && Boolean.TRUE.equals(isLoggedIn)) { 
    %>
    <script>
        showModal("<%= username %>");
    </script>
    <%
    // 모달을 표시한 후 isLoggedIn 속성을 제거하여 새로고침 시 모달이 다시 표시되지 않도록 함
    session.removeAttribute("isLoggedIn");
}
%> 

	<header>
		<div class="index-logo">
			<a href="index.jsp"> <img src="./images/jdxlogo1.png" alt="로고">
			</a>
		
			<h1>도서 관리 시스템</h1>
			
		</div>
		<div class="head-button">
			<div class="header-i">
				<a href="index.jsp"> <i class="fa-solid fa-house gradient-icon"></i>

				</a>
			</div>
			<% 
            if (username != null) { 
            // 로그인 되었을때만 보이게 설정 	수정패치1-------------------------------------------------------
        %>
			<button type="button" class="btn custom-logout"
				style="background-color: #00ff9c;"
				onclick="location.href='logout.jsp'">로그아웃</button>
			<button type="button" class="btn custom-search"
				style="background-color: #b6ffa1;"
				onclick="location.href='favorite'">즐겨찾기</button>
			<% 
            } else { 
            	// 로그인x
        %>
			<button type="button" class="btn custom-login"
				style="background-color: #00ff9c;"
				onclick="location.href='login.jsp'">로그인</button>
			<!-- 로그인 했을때는 로그인 페이지로 이동-> 로그인은 로그아웃으로 변환 ->수정완료 수정패치1--------------------------------------------------------->
			<button type="button" class="btn custom-signup"
				style="background-color: #b6ffa1;"
				onclick="location.href='signup.jsp'">회원가입</button>


			<% 
            } 
        %>
			<nav>
				<div class="menu">

					<button type="button" class="btn custom-favorite"
						style="background-color: #fff278;">MENU</button>
					<!-- 메뉴 버튼 눌렀을때도 햄버거 애니메이션+드롭다운 기능 가능하도록 수정하기  ★-->
					<div class="dropdown">
						<% if (username != null) { %>
						<!-- 로그인o ★-->
						<a href="favorite" class="dropdown-item">즐겨찾기</a> <a
							href="teamintroduce.jsp" class="dropdown-item">제작자</a> <a
							href="logout.jsp" class="dropdown-item">로그아웃</a> <a
							href="withdraw.jsp" class="dropdown-item">회원탈퇴</a>
						<% } else { %>
						<!-- 로그인x ★-->
						<a href="login.jsp" class="dropdown-item">로그인</a> <a
							href="signup.jsp" class="dropdown-item">회원가입</a> <a
							href="teamintroduce.jsp" class="dropdown-item">제작자</a>
						<% } %>
					</div>
				</div>
				<div class="burger">
					<div class="line1"></div>
					<div class="line2"></div>
					<div class="line3"></div>
				</div>
			</nav>
		</div>

	</header>