package movePage;

import function_jdxbook.DBconnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/withdraw") // 회원탈퇴 서블릿 URL 매핑
public class WithdrawServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String userId = (String) session.getAttribute("userId"); // 세션에서 user_id 가져오기

        if (userId != null) {
            DBconnection db = new DBconnection();
            try (Connection con = db.getConnection()) {
                String sql = "DELETE FROM users WHERE user_id = ?"; // user_id를 기준으로 삭제
                try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                    pstmt.setString(1, userId); // user_id 설정
                    pstmt.executeUpdate(); // 사용자 삭제 실행
                }
                session.invalidate(); // 세션 무효화
                req.setAttribute("successMessage", "회원탈퇴가 완료되었습니다.");
                resp.sendRedirect("index.jsp"); // 탈퇴 후 index.jsp로 리다이렉트
            } catch (Exception e) {
                e.printStackTrace();
                req.setAttribute("errorMessage", "회원탈퇴 중 오류가 발생했습니다.");
                req.getRequestDispatcher("index.jsp").forward(req, resp); // 오류 발생 시 index.jsp로 리다이렉트
            }
        } else {
            req.setAttribute("errorMessage", "로그인이 필요합니다.");
            req.getRequestDispatcher("login.jsp").forward(req, resp); // 로그인 페이지로 리다이렉트
        }
    }
}
