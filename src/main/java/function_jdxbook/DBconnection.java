package function_jdxbook;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBconnection {

    private String url = "jdbc:mysql://localhost:3306/jdx_bookmanagement_db?useUnicode=true&characterEncoding=UTF-8"; //SQL 스키마 이름과 주소 
    private String user = "root";//여기에 SQL계정을 넣어주세요
    private String password = "021001"; //SQL 계정 비밀번호 

    public DBconnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("JDBC 드라이버 로드 오류: " + e.getMessage());
        }
    }

    public Connection getConnection() {
        try {
            return DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            System.out.println("데이터베이스 연결 오류: " + e.getMessage());
            return null;
        }
    }

    public void close() {
        // 이 메서드는 필요하지 않게 됨. Connection은 try-with-resources로 관리
    }

    public User validateUser(String id, String password) {
        String SQL = "SELECT user_id, id, user_name, password FROM users WHERE id = ?";
        try (Connection con = getConnection(); 
             PreparedStatement pstmt = con.prepareStatement(SQL)) {
            pstmt.setString(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (storedPassword.equals(password)) {
                    // 비밀번호가 일치하면 User 객체 반환
                    return new User(rs.getString("user_id"), rs.getString("id"), rs.getString("user_name"));
                }
            } else {
                System.out.println("사용자가 없거나 비밀번호가 틀렸습니다.");
            }
        } catch (Exception e) {
            System.out.println("데이터베이스 검색 오류: " + e.getMessage());
        }
        return null; // 인증 실패 시 null 반환
    }

    public boolean deleteUser(String userId) {
        String SQL = "DELETE FROM users WHERE user_id = ?";
        try (Connection con = getConnection(); 
             PreparedStatement pstmt = con.prepareStatement(SQL)) {
            pstmt.setString(1, userId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0; // 삭제가 성공하면 true 반환
        } catch (Exception e) {
            System.out.println("회원탈퇴 중 오류 발생: " + e.getMessage());
        }
        return false; // 삭제 실패 시 false 반환
    }
}

/* 

db 테이블 생성 명령어 

스키마 생성하고 실행 

CREATE TABLE IF NOT EXISTS users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id VARCHAR(100) NOT NULL UNIQUE, -- 아이디는 유니크 제약조건 추가
    password VARCHAR(255) NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; -- 문자 집합 및 정렬 규칙 설정

CREATE TABLE IF NOT EXISTS favorites (
    favorite_id BIGINT AUTO_INCREMENT PRIMARY KEY, 
    user_id BIGINT, -- user_id의 타입을 BIGINT로 변경
    book_id VARCHAR(255) NOT NULL, 
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE -- 외래 키 설정 및 삭제 시 연쇄 삭제
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; -- 문자 집합 및 정렬 규칙 설정


*/