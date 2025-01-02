package function_jdxbook;


import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;


public class BookDetailsServlet extends HttpServlet {
    private static final String GOOGLE_BOOKS_API_URL = "https://www.googleapis.com/books/v1/volumes/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookId = request.getParameter("bookId");
        if (bookId == null || bookId.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Book ID is missing.");
            return;
        }

        String apiUrl = GOOGLE_BOOKS_API_URL + bookId;
        HttpURLConnection connection = (HttpURLConnection) new URL(apiUrl).openConnection();
        connection.setRequestMethod("GET");

        ObjectMapper mapper = new ObjectMapper();
        JsonNode bookInfo;

        try (InputStream inputStream = connection.getInputStream()) {
            bookInfo = mapper.readTree(inputStream);
        }

        // 도서 정보 파싱
        String title = bookInfo.path("volumeInfo").path("title").asText();
        String authors = bookInfo.path("volumeInfo").path("authors").toString();
        String description = bookInfo.path("volumeInfo").path("description").asText();
        String thumbnail = bookInfo.path("volumeInfo").path("imageLinks").path("thumbnail").asText();

        // 도서 정보 request에 설정하여 JSP로 전달
        request.setAttribute("title", title);
        request.setAttribute("authors", authors);
        request.setAttribute("description", description);
        request.setAttribute("thumbnail", thumbnail);

        request.getRequestDispatcher("/BookDetail.jsp").forward(request, response);
    }
}
