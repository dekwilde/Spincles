Titanium.UI.iPhone.hideStatusBar();
Titanium.UI.setBackgroundColor('#FFCC00');
var window = Titanium.UI.createWindow({url:'main/libraries/iprocessingwin.js'});
 
window.navBarHidden = true;
window.fullscreen = true;
window.autorotate = false;
window.top = 0;
window.left = 0;

if (window.autorotate) {
	window.orientationModes = [
	Titanium.UI.PORTRAIT,
	Titanium.UI.UPSIDE_PORTRAIT,
	Titanium.UI.LANDSCAPE_LEFT,
	Titanium.UI.LANDSCAPE_RIGHT
	];
} else {
	window.orientationModes = [
	Titanium.UI.PORTRAIT
	];
}
window.open();