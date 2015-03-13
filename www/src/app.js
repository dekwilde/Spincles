var orientationMode, activePage;
///////////////////////////////////////// MOBILE OR DESKTOP ///////////////////////////////////////////////// 
var isMobile = {
    Android: function() {
        return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function() {
        return navigator.userAgent.match(/BlackBerry/i);
    },
    iOS: function() {
        return navigator.userAgent.match(/iPhone|iPad|iPod/i);
    },
    Opera: function() {
        return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function() {
        return navigator.userAgent.match(/IEMobile/i);
    },
    any: function() {
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
    }
};

	
///////////////////////////////////////// FUNCTIONS /////////////////////////////////////////////////   
function showPageLoadingMsg(th, txt) {
	$.mobile.loading( "show", {
	  text: txt,
	  textVisible: true,
	  theme: th,
	  html: ""
	});	
} 
function hidePageLoadingMsg() {
	$.mobile.loading( "hide" );
}  

function goPage(page) {
	$.mobile.loading( "hide" );
	$.mobile.navigate(page, { transition : "pop"});
	                   
}

function add2Home() {
	var config_add2home = {
		autostart:true,
		startDelay: 2000,
		mandatory:true,
		lifespan:1000000,
		maxDisplayCount:10,
		message:"Bem Vindo. Instale este aplicativo em seu aparelho: aperte %icon e selecione <strong>'Adicionar à Tela Inicio'</strong>."
	}
	addToHomescreen(config_add2home);
}      

function resizeCanvas() {
    Processing.getInstanceById("pde").size(window.innerWidth, window.innerHeight);
    //Processing.getInstanceById("pde").scale(window.innerWidth, window.innerHeight);
}


function canvas2ImageCrop(x1,y1,w,h) {
	var canvas = document.getElementById("eraser");
		
	var newcanvas = document.createElement('canvas');
	newcanvas.id     = "newcanvas";
	newcanvas.width  = 700;
	newcanvas.height = 700;
	
    var context = newcanvas.getContext('2d');
    var imageObj = new Image();
	imageObj.src = canvas.toDataURL();

    imageObj.onload = function() {
      	// draw cropped image
      	context.drawImage(this, x1, y1, w, h, 0, 0, 700, 700);
		canvasimage = newcanvas.toDataURL();
		cropped = true;
		console.log(canvasimage);
    };
		
}

/////////////////////////////////////////////// Init /////////////////////////////////////////////
function loadPDE() {  		
	//Processing.reload(); 
	
	Processing.loadSketchFromSources('pde', [
		"src/main/main.pde", 
		"src/main/Three.pde", 
		"src/main/Trixel.pde", 
		"src/main/body.pde", 
		"src/main/buttons.pde", 
		"src/main/control.pde", 
		"src/main/device.pde", 
		"src/main/elements.pde", 
		"src/main/functions.pde", 
		"src/main/score.pde"
	]);
}



function init() {
	if(isMobile.any()) {
		app.initialize();
	} else {
		$("#stores").show();
	}
	showPageLoadingMsg("c", "loading"); 
	deviceZigFu(); 
	loadPDE(); 
}


////////////////////////////////////////////////////////////// SOUND HOWLER  ////////////////////////////////////////////////////       
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
        

    

////////////////////////////////////////////////////////////// PHONEGAP ////////////////////////////////////////////////////

var phonegap = false;
function socialShare(msg, sub, img, url) {
	if(phonegap) {
		window.plugins.socialsharing.share(msg, sub, img, url);	
	} else {
		alert("Use the native App to enable it.");
	}
	
}

var micLevelPluginPhoneGap = 0;
var micSuccess = function() {
    //alert("Plugin Start");
}

var micFailure = function() {
    alert("Error calling Plugin");
}


var gameCenterLogin = false;
var gamecenterSuccess = function() {
	console.log("game center success");
	gameCenterLogin = true;
}
var gamecenterFailure = function() {
	console.log("game center failure");
	gameCenterLogin = false;
}

function sendScoreGameCenter(n) {
	if(gameCenterLogin) {
		var data = {
		    score: n,
		    leaderboardId: "board1"
		};
		gamecenter.submitScore(gamecenterSuccess, gamecenterFailure, data);		
	}
}

function showGameCenter() {
	if(gameCenterLogin) {
		var data = {
		    period: "all",
		    leaderboardId: "board1"
		};
		gamecenter.showLeaderboard(gamecenterSuccess, gamecenterFailure, data);	
	} else {
		alert("You must be logged in the Game Center");
	}
}


var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
	    
		phonegap = true;
		StatusBar.hide();
		       
		window.micVolume.start(micSuccess, micFailure);

	    setInterval(function(){
			window.micVolume.read(function(reading){			
				micLevelPluginPhoneGap = reading.volume;    
		    }, micFailure);		
		},100);
		
		//window.micVolume.stop(succesCallback, errorCallback);
		
		
		//GAME CENTER
		gamecenter.auth(gamecenterSuccess, gamecenterFailure);

		   	   	
		console.log("deviceready");  
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {   

        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

////////////////////////////////////////////////////////////// READY ////////////////////////////////////////////////////  
$(document).ready(function(){    


	setTimeout(init, 2000); // if not playvideo   
	

	//////////////////////////////////////////// GLOBAL - orientation /////////////////////////////////////////////
	function doOnOrientationChange() {
		switch(window.orientation) {  
			case -90:
				orientationMode = "landscape";
			break;
			case 90:
				orientationMode = "landscape";
			break; 
			case 0:
				orientationMode = "portrait";
			break; 
			case 180:
				orientationMode = "inverse";
			break;   
		}     
		
		
		console.log(window.orientation);
	}
	window.addEventListener('orientationchange', doOnOrientationChange);
	window.addEventListener("resize", resizeCanvas);
	
	
	///////////////////////////////////////////////////// GLOBAL - pageShow /////////////////////////////////////////////
	$( "div" ).on( 'pageshow',function(event, ui){ 
		activePage = $.mobile.activePage.attr('id');  
    });	
            
});