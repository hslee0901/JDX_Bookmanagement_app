<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="./css/withdraw.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gamja+Flower&family=Kaisei+Opti&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/f10167bfad.js" crossorigin="anonymous"></script>
</head>
<body>
    <header>
        <div class="index-logo">
            <a href="index.jsp"><img src="./images/jdxlogo.png" alt="로고"></a>
            <h1>도서 관리 시스템</h1>
        </div>
        <div class="header-i">
            <a href="index.jsp"><i class="fa-solid fa-house gradient-icon"></i></a>
        </div>
    </header>

    <main>
        <div class="login-container">

            <h2>회원탈퇴</h2>
        <p>정말로 회원탈퇴를 하시겠습니까?</p>
        <form action="withdraw" method="post">
            <button type="submit" class="btn btn-danger">탈퇴하기</button>
                   
                <button type="button" class="btn custom-signup" 
       			 style="background-color: #4CAF50; margin-top: 10px;" 
       			 onclick="location.href='index.jsp'">취소</button>
        </form>
        </div>
    </main>

  <%@ include file="footer.jsp" %> <!-- 푸터 포함 -->