Titanium.UI.setBackgroundColor('#FFCC00');
var window = Titanium.UI.createWindow({url:'main/libraries/iprocessingwin.js'});

window.fullscreen = true;
window.autorotate = false;

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