document.addEventListener("DOMContentLoaded", function () {
    const favoriteButtons = document.querySelectorAll(".add-to-favorite");
    favoriteButtons.forEach(button => {
        button.addEventListener("click", function () {
            const bookId = this.getAttribute("data-book-id");

            // AJAX로 즐겨찾기 추가 요청
			fetch("/JDX_BOOK_SYS/favorite", {  // Favorites 서블릿의 매핑 경로로 수정
			    method: "POST",
			    headers: {
			        "Content-Type": "application/x-www-form-urlencoded"
			    },
			    body: `book_id=${bookId}`  // 보내는 데이터가 'book_id'로 일치하도록 수정
			})
			.then(response => response.json())  // 서버가 JSON 응답을 보내는 형식이라 가정
			.then(data => {
			    alert(data.message); // 서버에서 반환한 메시지 표시
			})
			.catch(error => {
			    console.error("AJAX 요청 중 오류 발생:", error);  // 콘솔에 에러 로그 출력
			    alert("오류가 발생했습니다."); // 오류 메시지 표시
            });
        });
    });
});
