
//드롭다운
function toggleDropdown() {
    const dropdown = document.querySelector('.dropdown');
    dropdown.classList.toggle('show');
}

document.addEventListener('DOMContentLoaded', () => {
    const burger = document.querySelector('.burger');
    const dropdown = document.querySelector('.dropdown');

    burger.addEventListener('click', (event) => {
        event.stopPropagation(); // 클릭 이벤트 전파 방지
        burger.classList.toggle('toggle');
        toggleDropdown(); // 드롭다운 보여주기/숨기기
    });

    // 다른 영역 클릭 시 드롭다운 닫기
    document.addEventListener('click', () => {
        if (burger.classList.contains('toggle')) {
            burger.classList.remove('toggle');
            dropdown.classList.remove('show');
        }
    });
});


// 위로 스크롤 할 때 헤더 보이게 하는 기능
document.addEventListener("DOMContentLoaded", function () {
    const header = document.querySelector("header");
    let lastScrollY = window.scrollY;

    // 페이지를 로드할 때 헤더를 보이게 설정
    header.classList.add("show");

    window.addEventListener("scroll", function () {
        if (window.scrollY > lastScrollY && window.scrollY > 0) {
            // 스크롤 다운
            header.classList.remove("show");
        } else if (window.scrollY < lastScrollY) {
            // 스크롤 업
            header.classList.add("show");
        }
        lastScrollY = window.scrollY;
    });
});
function showModal(username) {
	if (username) {
		document.getElementById("welcomeModal").style.display = "flex";
		document.getElementById("welcomeMessage").innerText = "환영합니다, " + username + "님!";
	}
}
function closeModal() {
	document.getElementById("welcomeModal").style.display = "none";
}