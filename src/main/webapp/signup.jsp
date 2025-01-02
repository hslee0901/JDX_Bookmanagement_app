<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gamja+Flower&family=Kaisei+Opti&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="./css/signup.css">
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
            <h2>회원가입</h2>
            <%
                // 회원가입 서블릿에서의 에러 메시지 출력
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
            <div class="alert alert-danger" role="alert">
                <%= errorMessage %>
            </div>
            <%
                }
            %>
            <form id="signupForm" action="register" method="post">
                <div class="form-group">
                    <label for="id">아이디</label>
                    <input type="text" class="form-control" id="id" name="id" placeholder="ID" required>
                    <small id="idFeedback" class="form-text text-muted"></small>
                </div>
                <div class="form-group">
                    <label for="userName">이름</label>
                    <input type="text" class="form-control" id="userName" name="user_name" placeholder="USER NAME" required>
                </div>
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="PASSWORD" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">비밀번호 확인</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="PASSWORD CONFIRM" required>
                    <small id="passwordFeedback" class="form-text text-muted"></small>
                </div>
                <button type="submit" class="btn btn-primary">가입하기</button>
                <button type="button" class="btn custom-signup" 
       			 style="background-color: #4CAF50; margin-top: 10px;" 
       			 onclick="location.href='login.jsp'">로그인</button>
            </form>
        </div>
    </main>

    <footer class="text-center py-3" style="background-color: #352d5f;">
        <div class="foot-i-school">
            <i class="fa-regular fa-circle-user" style="color: #00ff9c"></i>
            <p>부산외국어대학교 일본어융합학부</p>
        </div>
        <div class="foot-i-circle">
            <i class="fa-regular fa-copyright" style="color: #b6ffa1"></i>
            <p>2024 J-DX. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script>
        $(document).ready(function() {
            // 아이디 중복 체크
            $('#id').on('blur', function() {
                var id = $(this).val();
                if (id) {
                    $.ajax({
                        url: 'checkId', // 아이디 중복 체크를 위한 서블릿 URL
                        type: 'POST',
                        data: { id: id },
                        success: function(response) {
                            if (response === 'exists') {
                                $('#idFeedback').text('이미 사용 중인 아이디입니다.').css('color', 'red');
                            } else {
                                $('#idFeedback').text('사용 가능한 아이디입니다.').css('color', 'green');
                            }
                        },
                        error: function() {
                            $('#idFeedback').text('서버 오류가 발생했습니다.').css('color', 'red');
                        }
                    });
                } else {
                    $('#idFeedback').text('');
                }
            });

            // 비밀번호 확인
            $('#signupForm').on('submit', function(event) {
                var password = $('#password').val();
                var confirmPassword = $('#confirmPassword').val();
                if (password !== confirmPassword) {
                    event.preventDefault(); // 폼 제출 방지
                    $('#passwordFeedback').text('비밀번호가 일치하지 않습니다.').css('color', 'red');
                } else {
                    $('#passwordFeedback').text('');
                }
            });
        });
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</body>
</html>
