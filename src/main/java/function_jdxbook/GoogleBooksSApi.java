package function_jdxbook;

//이 페이지는 gson을 활용한 google books api를 호출하는 연습 페이지입니다 본 프로젝트에 적용되는 기능은 jackson입니다.
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpTimeoutException;
import java.util.List;
import java.util.Scanner;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

public class GoogleBooksSApi {
    private static final String API_KEY = ""; // 여기에 발급받은 API 키를 입력하세요
    private static final String BASE_URL = "https://www.googleapis.com/books/v1/volumes?q=";

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("책 제목 또는 저자를 입력하세요: ");
        String query = scanner.nextLine();
        
        try {
            String url = BASE_URL + query + "&key=" + API_KEY + "&maxResults=10"; // 최대 10개 결과
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .build();
          //윗 부분, 아랫부분
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                System.out.println("결과: ");
                Gson gson = new Gson();
                JsonObject jsonResponse = gson.fromJson(response.body(), JsonObject.class);
              //윗 부분, 아랫부분
                JsonArray items = jsonResponse.getAsJsonArray("items");

                if (items != null) {
                    for (int i = 0; i < items.size(); i++) {
                        JsonObject item = items.get(i).getAsJsonObject();
                        JsonObject volumeInfo = item.getAsJsonObject("volumeInfo");
                        String title = volumeInfo.has("title") ? volumeInfo.get("title").getAsString() : "제목 없음";
                        String authors = volumeInfo.has("authors") ? volumeInfo.getAsJsonArray("authors").toString() : "저자 없음";
                      //title은 문자열이고 authors 배열이기 때문에 string으로 받는 작업을 해줌

                        // JSON 배열을 문자열로 변환
                        List<String> authorList = gson.fromJson(authors, List.class);
                        String authorNames = authorList != null ? String.join(", ", authorList) : "저자 없음";
                      //윗 부분, 아랫부분
                        System.out.println((i + 1) + ". 제목: " + title + ", 저자: " + authorNames);
                    }
                } else {
                    System.out.println("검색 결과가 없습니다.");
                }
            } else {
                System.out.println("오류 발생: " + response.statusCode());
            }
        } catch (HttpTimeoutException e) {
            System.out.println("요청이 시간 초과되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            scanner.close();
        }
    }
}
