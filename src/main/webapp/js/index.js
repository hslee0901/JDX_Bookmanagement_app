function showModal(username) {
	if (username) {
		document.getElementById("welcomeModal").style.display = "flex";
		document.getElementById("welcomeMessage").innerText = "환영합니다, " + username + "님!";
	}
}
function closeModal() {
	document.getElementById("welcomeModal").style.display = "none";
}