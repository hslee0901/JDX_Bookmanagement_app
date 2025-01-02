package movePage;

import function_jdxbook.User; // User 클래스
import function_jdxbook.DBconnection; // DBconnection 클래스
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import org.json.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;

@WebServlet("/favorite")
public class FavoriteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("FavoriteServlet doGet 호출됨");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId;
        String username;
        try {
            userId = Integer.parseInt((String) session.getAttribute("userId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user session.");
            return;
        }

        DBconnection db = new DBconnection();

        // Retrieve username
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT user_name FROM users WHERE user_id = ?")) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    username = rs.getString("user_name");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found.");
                    return;
                }
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to retrieve user information.");
            return;
        }
        request.setAttribute("username", username);
        
        String bookIdToDelete = request.getParameter("book_id");
        if (bookIdToDelete != null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                // 예외 처리
            }
            try (
                Connection conn = db.getConnection();
                PreparedStatement stmt = conn.prepareStatement("DELETE FROM favorites WHERE user_id = ? AND book_id = ?")) {
                stmt.setInt(1, userId);
                stmt.setString(2, bookIdToDelete);
                stmt.executeUpdate();

                System.out.println("Database connected: " + conn.getMetaData().getURL()); // 연결된 DB URL 출력
                System.out.println("Database user: " + conn.getMetaData().getUserName()); // 연결된 DB 사용자 출력

            } catch (SQLException e) {
                e.printStackTrace();
            }
            response.sendRedirect("/JDX_BOOK_SYS/favorite"); // 즐겨찾기 페이지 새로고침
            return;
        }
        // Retrieve books from favorites
        List<Map<String, String>> books = new ArrayList<>();
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT book_id FROM favorites WHERE user_id = ?")) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String bookId = rs.getString("book_id");
                    String apiUrl = "https://www.googleapis.com/books/v1/volumes/" + bookId;
                    books.add(fetchBookInfo(apiUrl, bookId));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("Books retrieved: " + books);
        request.setAttribute("books", books);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/favorite.jsp");
        dispatcher.forward(request, response);
    }
    
    

    private Map<String, String> fetchBookInfo(String apiUrl, String bookId) {
        Map<String, String> bookInfo = new HashMap<>();
        try {
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                StringBuilder content = new StringBuilder();
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    content.append(inputLine);
                }

                JSONObject bookJson = new JSONObject(content.toString());
                JSONObject volumeInfo = bookJson.optJSONObject("volumeInfo");
                bookInfo.put("id", String.valueOf(bookId));
                bookInfo.put("title", volumeInfo.optString("title", "정보없음"));
                bookInfo.put("authors", volumeInfo.optJSONArray("authors").join(", ").replace("\"", ""));
                bookInfo.put("thumbnail", volumeInfo.optJSONObject("imageLinks").optString("thumbnail", "이미지 없음"));
                bookInfo.put("publisher", volumeInfo.optString("publisher", "정보없음"));
                bookInfo.put("publishedDate", volumeInfo.optString("publishedDate", "정보없음"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookInfo;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt((String) session.getAttribute("userId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user session.");
            return;
        }

        String bookId = request.getParameter("book_id");
        if (bookId == null || bookId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Book ID is missing.");
            return;
        }

        DBconnection db = new DBconnection();
        try (Connection conn = db.getConnection()) {
            // 중복된 book_id가 있는지 확인
            String checkSql = "SELECT COUNT(*) FROM favorites WHERE user_id = ? AND book_id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, userId);
                checkStmt.setString(2, bookId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        // 중복된 항목이 있는 경우
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        response.getWriter().write("{\"success\": false, \"message\": \"이미 즐겨찾기에 등록된 책입니다.\"}");
                        return;
                    }
                }
            }

            // 중복된 book_id가 없는 경우 새로운 항목 추가
            String insertSql = "INSERT INTO favorites (user_id, book_id) VALUES (?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                stmt.setInt(1, userId);
                stmt.setString(2, bookId);
                int rowsInserted = stmt.executeUpdate();

                if (rowsInserted == 0) {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "즐겨찾기에 책 추가 실패.");
                    return;
                } else {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": true, \"message\": \"즐겨찾기에 추가되었습니다!\"}");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터베이스 오류가 발생했습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류가 발생했습니다.");
        }
    }


}
