var soundMagnetic,
	soundScore,
	soundClick,
	soundGlitch,
	soundEnemy,
	soundTouchTimer,
	soundLoopBG,
	soundStart;

window.onload=function(){
	// Go check the great Buzz library for playing sounds in JS.
	// The sounds you hear come frome http://buzz.jaysalvat.com

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
	
    //buzz.all().play();
}
