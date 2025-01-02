<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
	<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gamja+Flower&family=Kaisei+Opti&display=swap" rel="stylesheet">
<link rel="stylesheet" href="./css/signup.css">
<!-- 새로운 로그인 스타일 파일 -->
<script src="https://kit.fontawesome.com/f10167bfad.js"

	crossorigin="anonymous"></script>
</head>
<body>
	<header>
		<div class="index-logo">
			<a href="index.jsp"> <img src="./images/jdxlogo.png" alt="로고"></a>
			<h1>도서 관리 시스템</h1>
		</div>
		<div class="header-i">
			<a href="index.jsp"> <i class="fa-solid fa-house gradient-icon"></i>
			</a>
		</div>


	</header>




	<main>
	
		<div class="login-container">
			<h2>LOGIN</h2>
			<%
            	//로그인서브렛에서의 에러 메세지 나오게 출력 수정완료----------------------------------------------
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
			<div class="alert alert-danger" role="alert">
				<!--부트스트랩 사용-->
				<%= errorMessage %>
				<!-- 에러 메시지 출력 -->
			</div>
			<%
                }
            %>
            
               <%
               String success = request.getParameter("success");
               if (success != null) {
           %>
               <div class="alert alert-success" role="alert">
                   <%= success %>
               </div>
           <%
               }
           %>


			<form action="radiLogin" method="post">
				<input type="text" name="id" placeholder="ID" required> <input
					type="password" name="password" placeholder="PASSWORD" required>
				<button type="submit">로그인</button>
			</form>
			<!-- 회원 가입 버튼 추가 수정패치1------------------------------------------------------- -->
			<div class="signup-btn">
				<button type="button" class="btn custom-signup"
					style="background-color: #4CAF50;"
					onclick="location.href='signup.jsp'">회원가입</button>
			</div>
		</div>
	</main>

	<%@ include file="footer.jsp" %> <!-- 푸터 포함 -->