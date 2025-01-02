// 요소 선택
const players1 = document.querySelector('.players1');
const players2 = document.querySelector('.players2');
const prevBtn = document.getElementById('prevBtn');
const nextBtn = document.getElementById('nextBtn');

// 초기 상태 설정
players1.classList.add('active');
players2.style.display = "none";

// 애니메이션 전환 함수
function switchPlayers(show, hide, direction) {

    hide.classList.remove('active');
    hide.classList.add(direction === 'left' ? 'left-hidden' : 'right-hidden');
    
    show.classList.remove(direction === 'left' ? 'left-hidden' : 'right-hidden')
	show.classList.add(direction === 'left' ? 'right-hidden' : 'left-hidden');
    
    setTimeout(() => {
        hide.style.display = 'none';
        show.style.display = 'flex';
        
        setTimeout(() => {
            show.classList.remove('right-hidden', 'left-hidden');
            show.classList.add('active');
        }, 10);
    }, 500);
}

// 다음 버튼 (next)
nextBtn.addEventListener('click', () => {
    if (players1.classList.contains('active')) {
        switchPlayers(players2, players1, 'right');
    } else {
        switchPlayers(players1, players2, 'right');
    }
});

// 이전 버튼 (prev)
prevBtn.addEventListener('click', () => {
    if (players1.classList.contains('active')) {
        switchPlayers(players2, players1, 'left');
    } else {
        switchPlayers(players1, players2, 'left');
    }
});
