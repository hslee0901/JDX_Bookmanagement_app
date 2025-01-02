package movePage;

import function_jdxbook.DBconnection;
import function_jdxbook.User; // User 클래스
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/radiLogin") // 로그인 서블릿 URL 매핑
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("id"); // 사용자 ID
        String password = req.getParameter("password"); // 사용자 비밀번호
        
        DBconnection db = new DBconnection();
        
        // 사용자 인증
        User user = db.validateUser(username, password); // 사용자 정보 가져오기

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("userId", user.getUserId()); // user_id를 세션에 저장
            session.setAttribute("id", username); // 사용자 이름도 세션에 저장
            session.setAttribute("userName", user.getUserName()); // user_name 세션에 저장
            session.setAttribute("isLoggedIn", true);
            resp.sendRedirect("index.jsp"); // 로그인 성공 시 index.jsp로 리다이렉트
        } else {
            req.setAttribute("errorMessage", "아이디 혹은 비밀번호가 올바르지 않습니다.");
            req.getRequestDispatcher("login.jsp").forward(req, resp); // 로그인 실패 시 login.jsp로 리다이렉트
        }
    }
}
