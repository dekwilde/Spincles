var soundMagnetic,
	soundScore,
	soundClick,
	soundGlitch,
	soundEnemy,
	soundTouchTimer,
	soundLoopBG,
	soundStart;

function loadSounds() {                                                         
	soundMagnetic = document.getElementById('soundMagnetic');
	soundScore = document.getElementById('soundScore');
	soundClick = document.getElementById('soundClick');
	soundGlitch = document.getElementById('soundGlitch');
	soundEnemy = document.getElementById('soundEnemy');
	soundTouchTimer = document.getElementById('soundTouchTimer');
	soundLoopBG = document.getElementById('soundLoopBG');
	soundStart = document.getElementById('soundStart'); 
	
};              


document.addEventListener("touchstart", handleSound, false);
function handleSound(e) {
	document.removeEventListener("touchstart", handleSound, false);

	soundMagnetic.load();
	soundScore.load();
	soundClick.load();
	soundGlitch.load();
	soundEnemy.load();
	soundTouchTimer.load();
	soundLoopBG.load();
	soundStart.load();

	soundMagnetic.play();
	soundScore.play();
	soundClick.play();
	soundGlitch.play();
	soundEnemy.play();
	soundTouchTimer.play();
	soundLoopBG.play();
	soundStart.play();
} 




	
    

