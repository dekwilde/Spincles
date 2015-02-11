var soundMagnetic,
	soundScore,
	soundClick,
	soundGlitch,
	soundEnemy,
	soundTouchTimer,
	soundLoopBG,
	soundStart;




	var baseURL = "data/";
	var soundProps = {
	    formats: ["ogg", "mp3"]
	};
	
	soundMagnetic = new buzz.sound(baseURL + "energy", soundProps);
	soundScore = 	new buzz.sound(baseURL + "score", soundProps);
	soundClick =	new buzz.sound(baseURL + "click", soundProps); 
	soundGlitch = 	new buzz.sound(baseURL + "glitch", soundProps);
	soundEnemy = 	new buzz.sound(baseURL + "enemy", soundProps);
	soundTouchTimer = new buzz.sound(baseURL + "glitch", soundProps)
	soundLoopBG =  	new buzz.sound(baseURL + "loop1", soundProps);
	soundStart =  	new buzz.sound(baseURL + "loopstart", soundProps);   







document.addEventListener("touchstart", handleSound, false);
function handleSound(e) {
	document.removeEventListener("touchstart", handleSound, false);
	/*		
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
	*/
	
	buzz.all().load();
	
	buzz.all().bind("canplaythrough", function(e) {
		buzz.all().play();
	})
	//buzz.all().play();
	//buzz.all().stop();
}


	
    

