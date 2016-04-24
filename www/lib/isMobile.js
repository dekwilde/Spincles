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

function requestFullScreen() {

	var el = document.body;
  
	el.addEventListener("click",function() {
		// Supports most browsers and their versions.
		var requestMethod = el.requestFullScreen || el.webkitRequestFullScreen 
		|| el.mozRequestFullScreen || el.msRequestFullScreen;

		if (requestMethod) {

		  // Native full screen.
		  requestMethod.call(el);

		} else if (typeof window.ActiveXObject !== "undefined") {

		  // Older IE.
		  var wscript = new ActiveXObject("WScript.Shell");

		  if (wscript !== null) {
		    wscript.SendKeys("{F11}");
		  }
		}
		
		el.removeEventListener("click", function(){
			//
		});
	}); 

}