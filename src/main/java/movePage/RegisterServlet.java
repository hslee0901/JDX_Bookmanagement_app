package movePage;

import function_jdxbook.DBconnection; // 데이터베이스 연결 클래스
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/register") // 서블릿 URL 매핑
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 요청 파라미터 가져오기
        String id = req.getParameter("id");
        String password = req.getParameter("password");
        String userName = req.getParameter("user_name");

        // 데이터베이스에 사용자 추가
        DBconnection db = new DBconnection();
        try (Connection conn = db.getConnection()) {
            String sql = "INSERT INTO users (id, password, user_name) VALUES (?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, id);
                pstmt.setString(2, password); // 비밀번호는 해싱하는 것이 좋습니다.
                pstmt.setString(3, userName);
                pstmt.executeUpdate();
            }
            String successMessage = URLEncoder.encode("회원가입 완료!", StandardCharsets.UTF_8.toString());
            resp.sendRedirect("login.jsp?success=" + successMessage);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "회원가입 중 오류가 발생했습니다.");
            req.getRequestDispatcher("signup.jsp").forward(req, resp);
        }
    }
}