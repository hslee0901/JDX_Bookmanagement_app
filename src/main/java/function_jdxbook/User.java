package function_jdxbook;

public class User {
    private String userId;
    private String id;
    private String userName; // 추가

    public User(String userId, String username, String userName) { // 수정된 생성자
        this.userId = userId;		//유저 고유키 (숫자 id)
        this.id = id; //id
        this.userName = userName; //유저이름
    }

    public String getUserId() {
        return userId;
    }

    public String getUsername() {
        return id;
    }

    public String getUserName() { // 추가
        return userName;
    }
}
