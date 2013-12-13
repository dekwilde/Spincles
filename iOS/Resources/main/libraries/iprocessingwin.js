/*
 
 iProcessing http://iprocessing.org enables native iPhone apps to be developed using the Processing language.
 Developed and maintained by Tom Hulbert http://tomhulbert.com at Luckybite http://www.luckybite.com
 iProcessing is an Xcode project template that integrates processing.js (modified to create iprocessing.js and 
 iprocessing.lib) with the Titanium iPhone JavaScript framework.  
 
*/


// Window setup ********************************************************
var mainView =  Titanium.UI.createView();
var overlay = null;
function dispose() {
    'use strict';
    mainView.remove(overlay);
    overlay = null;
}

var webview = Titanium.UI.createWebView({url:'../main.html'});
webview.backgroundColor = '#FFCC00'; 
webview.addEventListener('load', init);
mainView.add(webview);

var keyboardCapture = Titanium.UI.createTextField({left:0,top:480});
mainView.add(keyboardCapture);
keyboardCapture.value = "±";
keyboardCapture.hide();
Titanium.UI.currentWindow.add(mainView); 



function p(code) {
	webview.evalJS(code);
}

// Initialise ***********************************************************

function init(e) {
	// initialise iPhone
	Titanium.Geolocation.purpose = "Spincles Location";
	Titanium.Geolocation.accuracy = Titanium.Geolocation.ACCURACY_BEST;
	
	// initialise iProcessing
	var values = 													
	Titanium.Platform.username										+';'+
	Titanium.Platform.model												+';'+
	Titanium.Platform.name												+';'+
	Titanium.Platform.version											+';'+
	Titanium.Platform.id													+';'+
	Titanium.Media.volume													+';'+
	Titanium.App.proximityState										+';'+
	Titanium.Gesture.orientation									+';'+
	Titanium.Network.online												+';'+
	Titanium.Network.networkType									+';'+
	Titanium.Platform.address											+';'+
	Titanium.App.Properties.getString('appState')		;
	p(
		'init("' + values + '");'
	);
}

// iPhone events/functions *********************************************

Titanium.Media.addEventListener('volume', volumeChange);
Titanium.App.addEventListener('proximity', proximityChange);
Titanium.Gesture.addEventListener('orientationchange', orientationChange);
Titanium.Gesture.addEventListener('shake', shake);
Titanium.Network.addEventListener('change', networkChange);
keyboardCapture.addEventListener('change', keyboardChange);
keyboardCapture.addEventListener('return', keyboardReturn);

// sound -------------------------------------------------------

function volumeChange(e) {
	p(
		'volumeChanged(' + e.volume + ');'
	);
}

function updateMicMonitor() {
	p(
		'updateMicLevel(' + Titanium.Media.averageMicrophonePower + ');'
	);
}

// proximity ---------------------------------------------------

function proximityChange(e) {
	p(
		'proximityChanged(' + e.state + ');'
	);
}

// orientation -------------------------------------------------

function orientationChange(e) {
	p(
		'orientationChanged(' + e.orientation + ');'
	);
}

// accelerometer -----------------------------------------------

function shake(e) {	
	p(
		'shakeEvent();'
	);	
}

function accelerometerUpdate(e) {
	p(
		'updateAcceleration(' + e.x + ',' + e.y + ',' + e.z + ');'
	);
}

// location ----------------------------------------------------

function locationUpdate(e) {
	if (e.error) {
		return;
	}
	p(
		'updateLocation(' + e.coords.latitude + ',' + e.coords.longitude + ',' + e.coords.altitude + ',' + e.coords.heading + ',' + e.coords.speed + ');'
	);
}

function currentLocation(e) {
	if (e.error) {
		return;
	}
	p(
		'updateLocation(' + e.coords.latitude + ',' + e.coords.longitude + ',' + e.coords.altitude + ',' + e.coords.heading + ',' + e.coords.speed + ');'
	);	
}

// compass -----------------------------------------------------

function compassUpdate(e) {
	if (e.error) {
		return;
	}
	p(
		'updateCompass(' + e.heading.magneticHeading + ',' + e.heading.trueHeading + ');'
	);
}

// network info ------------------------------------------------

function networkChange(e) {
	var values = 													
	Titanium.Network.online												+';'+
	Titanium.Network.networkType									+';'+
	Titanium.Platform.address												;
	p(
		'updateNetwork("' + values + '");'
	);
}

// keyboard ----------------------------------------------------

var keys = " !" + "\"" + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[" + "\\" + "]^_'abcdefghijklmnopqrstuvwxyz{|}~";
function keyboardChange(e) {
	if (keyboardCapture.value.length < 1) {
		var keyCode = 8;
		//var key = String.fromCharCode(keyCode);
		var key = "BACKSPACE";
		p(
			'keyPressed("' + key + '",' + keyCode + ');'
		);
	} else if (keyboardCapture.value.length > 1) {
		var key = keyboardCapture.value.charAt(1);
		var keyCode = 32 + keys.indexOf(key);
		p(
			'keyPressed("' + key + '",' + keyCode + ');'
		);
	}
	keyboardCapture.value = "±";
}

function keyboardReturn(e) {
	keyboardCapture.blur();
	p(
		'keyboardReturned();'
	);
}

// iProcessing events/functions *****************************************

Titanium.App.addEventListener('link', link);
Titanium.App.addEventListener('beep', beep); 
Titanium.App.addEventListener('vibrate', vibrate);
Titanium.App.addEventListener('openSMS', openSMS);
Titanium.App.addEventListener('openPhone', openPhone);
Titanium.App.addEventListener('startLocation', startLocation); 
Titanium.App.addEventListener('stopLocation', stopLocation);
Titanium.App.addEventListener('getCurrentLocation', getCurrentLocation);
Titanium.App.addEventListener('startAccelerometer', startAccelerometer); 
Titanium.App.addEventListener('stopAccelerometer', stopAccelerometer);
Titanium.App.addEventListener('saveState', saveState);
Titanium.App.addEventListener('createSound', createSound);
Titanium.App.addEventListener('playSound', playSound);
Titanium.App.addEventListener('loopSound', loopSound);
Titanium.App.addEventListener('pauseSound', pauseSound);
Titanium.App.addEventListener('stopSound', stopSound);
Titanium.App.addEventListener('rewindSound', rewindSound);
Titanium.App.addEventListener('setVolumeSound', setVolumeSound);
Titanium.App.addEventListener('closeSound', closeSound);
Titanium.App.addEventListener('startMicMonitor', startMicMonitor);
Titanium.App.addEventListener('stopMicMonitor', stopMicMonitor);
Titanium.App.addEventListener('startCompass', startCompass);
Titanium.App.addEventListener('stopCompass', stopCompass);
Titanium.App.addEventListener('openPhotos', openPhotos);
Titanium.App.addEventListener('openCamera', openCamera);
Titanium.App.addEventListener('openKeyboard', openKeyboard);

function link(e) {
	Titanium.Platform.openURL(e.data);
}

// system notifications ----------------------------------------

function beep(e) {
	Titanium.Media.beep();
}

function vibrate(e) {
	Titanium.Media.vibrate();
}

// SMS/phone ---------------------------------------------------

function openSMS(e) {
	Titanium.Platform.openURL("sms:" + e.data);
}

function openPhone(e) {
	Titanium.Platform.openURL("tel:" + e.data);
}

// location ----------------------------------------------------

function startLocation(e) {
	if (Titanium.Geolocation.locationServicesEnabled == false) {
		Titanium.UI.createAlertDialog({title:'Warning!', message:'Your device has location services turned off'}).show();
	} else {
		Titanium.Geolocation.distanceFilter = e.data;
		Titanium.Geolocation.addEventListener('location', locationUpdate);
	}
}

function stopLocation(e) {
	Titanium.Geolocation.removeEventListener('location', locationUpdate);
}

function getCurrentLocation(e) {
	Titanium.Geolocation.getCurrentPosition(currentLocation);
}

// compass -----------------------------------------------------

function startCompass(e) {
	Titanium.Geolocation.addEventListener('heading', compassUpdate);
}

function stopCompass(e) {
	Titanium.Geolocation.removeEventListener('heading', compassUpdate);
}

// accelerometer -----------------------------------------------

function startAccelerometer(e) {
	Titanium.Accelerometer.addEventListener('update', accelerometerUpdate);
}

function stopAccelerometer(e) {
	Titanium.Accelerometer.removeEventListener('update', accelerometerUpdate);
}

// state saving ------------------------------------------------

function saveState(e) {
	Titanium.App.Properties.setString('appState',e.data);
}

// sound -------------------------------------------------------

var sounds = {};

function createSound(e) {
	var filename = e.data[0];
	var filepath = '../' + e.data[1];
	var sound = Titanium.Media.createSound({url:filepath});
	sounds[filename] = sound;
}

function playSound(e) {
	var filename = e.data;
	var sound = sounds[filename];
	if (sound) {
		sound.play();
	}
}

function loopSound(e) {
	var filename = e.data;
	var sound = sounds[filename];
	if (sound) {
		sound.setLooping(true);
		sound.play();
	}
}

function pauseSound(e) {
	var filename = e.data;
	var sound = sounds[filename];
	if (sound) {
		sound.pause();
	}
}

function stopSound(e) {
	var filename = e.data;
	var sound = sounds[filename];
	if (sound) {
		sound.stop();
		sound.setLooping(false);
	}
}

function rewindSound(e) {
	var filename = e.data;
	var sound = sounds[filename];
	if (sound) {
		sound.reset();
	}
}

function setVolumeSound(e) {
	var filename = e.data[0];
	var vol = e.data[1];
	var sound = sounds[filename];
	if (sound) {
		sound.setVolume(vol);
	}
}

function closeSound(e) {
	var filename = e.data;
	var sound = sounds[filename];
	if (sound) {
		sound.stop();
		sound.release();
		delete sounds[filename];
	}
}

var updateMicMonitorTimer;
function startMicMonitor() {
	if (!updateMicMonitorTimer) {
		updateMicMonitorTimer = setInterval(updateMicMonitor, 100);
		Titanium.Media.startMicrophoneMonitor();
	}
}

function stopMicMonitor() {
	if (updateMicMonitorTimer) {
		clearInterval(updateMicMonitorTimer);
		Titanium.Media.stopMicrophoneMonitor();
		updateMicMonitorTimer = null;
	}
}

// photo gallery -----------------------------------------------

function openPhotos(e) {
	var edit = e.data;
	Titanium.Media.openPhotoGallery({
		success: function(event) {
			var image = event.media;
			var filename = String((new Date()).getTime()).replace(/\D/gi,'')+".png";
			var f = Titanium.Filesystem.getFile(Titanium.Filesystem.resourcesDirectory+"/main/data/"+filename);
			//var filename = "temp.png";
			//var f = Titanium.Filesystem.getFile(filename);
			f.write(image);
			p(
				'photoSelected("' + filename + '");'
			);
		},
		cancel: function() {
		  p(
			  'photoCancelled();'
			);
		},
		error: function(error) {
			//error
		},
		allowImageEditing: edit
	})
}

// camera ------------------------------------------------------

var updateCameraTimer;
function openCamera(e) {
	overlay = Titanium.UI.createView({
				touchEnabled: false,
				visble: false,
				opacity:0.6,
	            //width:Ti.Platform.displayCaps.platformWidth,
	            //height:Ti.Platform.displayCaps.platformHeight  
	            width:36,
	            height:24
	});
	mainView.add(overlay); 
	overlay.hide();
	 	
	Titanium.Media.showCamera({
		success: function(event) {
			var image = event.media;
			var filename = "cam.png";
			var f = Titanium.Filesystem.getFile(Titanium.Filesystem.resourcesDirectory+"/main/data/"+filename);
			f.write(image);
			p(
				'cameraCaptured("' + filename + '");'
			);
			updateCamera();
			Ti.API.debug(event.media);  
			//Titanium.Media.hideCamera();											
		},
		cancel: function() {
			 p(
			 	'cameraCancelled();'
			 );
			 Ti.API.debug("canceled");
			 dispose();
		},
		error: function(error) {
			Ti.API.debug(error); 
			dispose();  									
		},
		overlay:overlay,
		saveToPhotoGallery:false,
		allowEditing:false,
	    showControls:false,  
	    autohide:false,
		animated : false,
		mediaTypes:[Ti.Media.MEDIA_TYPE_PHOTO],
        videoQuality:Titanium.Media.QUALITY_LOW,
		transform:Ti.UI.create2DMatrix().scale(1)	
	});
	Ti.Media.switchCamera(Ti.Media.CAMERA_REAR); 
	updateCameraTimer = setTimeout(updateCamera, 4000);
		
} 
 
function updateCamera() {
	Ti.Media.takePicture();
}


// keyboard ----------------------------------------------------

function openKeyboard(e) {
	keyboardCapture.focus();
}


