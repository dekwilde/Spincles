var soundMagnetic,
	soundScore,
	soundClick,
	soundGlitch,
	soundEnemy,
	soundTouchTimer,
	soundLoopBG,
	soundStart;

    var baseURL = "data/";

	soundMagnetic 	= new Howl({urls: [baseURL+'energy.mp3', baseURL+'energy.ogg', baseURL+'energy.wav']});
	soundScore 		= new Howl({urls: [baseURL+'score.mp3', baseURL+'score.ogg', baseURL+'score.wav']});
	soundClick 		= new Howl({urls: [baseURL+'click.mp3', baseURL+'click.ogg', baseURL+'click.wav']});
	soundGlitch 	= new Howl({urls: [baseURL+'glitch.mp3', baseURL+'glitch.ogg', baseURL+'glitch.wav']});
	soundEnemy 		= new Howl({urls: [baseURL+'enemy.mp3', baseURL+'enemy.ogg', baseURL+'enemy.wav']});
	soundTouchTimer = new Howl({
		urls: [baseURL+'glitch.mp3', baseURL+'glitch.ogg', baseURL+'glitch.wav'],
		loop: true,
		volume: 0.0
	});
	soundLoopBG 	= new Howl({
		urls: [baseURL+'loop1.mp3', baseURL+'loop1.ogg', baseURL+'loop1.wav'],
	  	loop: true
	});
	soundStart 		= new Howl({
		urls: [baseURL+'loopstart.mp3', baseURL+'loopstart.ogg', baseURL+'loopstart.wav'],
		loop: true,
	  	volume: 0.6
	});
        

	var sound = new Howl({
	  urls: ['sound.mp3', 'sound.ogg', 'sound.wav'],
	  autoplay: true,
	  loop: true,
	  volume: 0.5,
	  onend: function() {
	    alert('Finished!');
	  }
	});
