<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
    session.invalidate(); // 세션 종료
    response.sendRedirect("index.jsp"); // 메인 페이지로 리디렉션
    //수정패치1-------------------------------------------------------
%>
<script>
    // 로그아웃 시 sessionStorage의 modalShown 키를 제거 수정패치1-------------------------------------------
    sessionStorage.removeItem("modalShown");
</script>