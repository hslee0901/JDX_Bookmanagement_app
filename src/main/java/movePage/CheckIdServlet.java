package movePage;

import function_jdxbook.DBconnection; // 데이터베이스 연결 클래스
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/checkId")
public class CheckIdServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        String sql = "SELECT COUNT(*) FROM users WHERE id = ?";

        // DBconnection 인스턴스를 생성하고 연결을 가져옵니다.
        DBconnection db = new DBconnection();
        try (Connection conn = db.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                resp.getWriter().write("exists"); // 이미 존재하는 아이디
            } else {
                resp.getWriter().write("available"); // 사용 가능한 아이디
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류");
        } finally {
            // DBconnection 자원을 적절히 해제합니다 (필요한 경우)
            db.close(); // close 메소드가 DBconnection 클래스에 구현되어 있어야 합니다.
        }
    }
}
