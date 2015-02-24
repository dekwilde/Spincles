var orientationMode, activePage;
var textEmktHeader, textEmktFooter;  

////////////////////////////////////// Facebook Config //////////////////////////////////////////////
var FBauthToken;
var FBuser_name, FBuser_gender, Fbuser_email, FBuser_hometown, FBuser_location;

//var FBappID = "502589149844503";
//var FBsecretID = "2dc7f4ef6d9e621e276068c7e79bc3b1"; 

var FBappID = "125881397465373";
var FBsecretID = "eabb70384052a7c475db747553dd4526";

var FBpageID = "642045525916945";

var FBhost = "https://renault.dekwilde.com.br/";
var FBredirect_uri = window.location;
var FBscope = "publish_actions, publish_stream, photo_upload, publish_checkins, email";
var FBplace_id = "129793527037644";
var FBlatitude = "-23.516016449899";
var FBlongitude = "-46.636754669443";
var FBmessage = "Mensagem padrão";    


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
	}  
	deviceZigFu(); 
	loadPDE(); 
}
 
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