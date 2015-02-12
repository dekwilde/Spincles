/**
 *  Processing.Mobile Library for Processing.js
 *
 *  This library adds a number of mobile device related APIs to Processing.
 *  These are non-standard, and are done in this library only for demonstration
 *  purposes.
 *
 *  Additional Processing APIs:
 *
 *  orientation: (object) device tilt information in degrees along x, y, z
 *             alpha: the direction the device is facing according to the compass
 *             beta: the angle in degrees the device is tilted front-to-back
 *             gamma the angle in degrees the device is tilted left-to-right.
 *             compassAccuracy the iOS 5 compass accuracy (or -1)
 *             compassHeading the iOS 5 cCompass heading in degrees or -1
 *
 *  acceleration: (object) acceleration data for device along x, y, and z axes:
 *             x: (float) device acceleration in m/s^2 along the X axis (-1.0 to 1.0)
 *             y: (float) device acceleration in m/s^2 along the Y axis (-1.0 to 1.0)
 *             z: (float) device acceleration in m/s^2 along the Z axis (-1.0 to 1.0)
 *
 *  coords: (object) geolocation data for the device, obtained at the start of the
 *          program (i.e., not updated during the lifetime of the program).  The
 *          properties of coords incude:
 *
 *             latitude: (float) current latitude in decimal degrees (or 0 if unknown)
 *             longitude: (float) current longitude in decimal degrees (or 0 if unknown)
 *             altitude: (float) current height in meters above the ellipsoid (or 0 if unknown)
 *             accuracy: (float) accuracy in meters of longitude and latitude
 *             altitudeAccuracy: (float) accurace of the altitude value in meters (or 0 if unknown)
 *             heading: (float) direction of travel, specified in degrees 0-360 (or -1 if unknown)
 *             speed: (float) speed in meters per second (or -1 if unknown)
 *
 *  Updates for coords are available when the locationChanged() callback is fired.
 *
 *  Additional Reading:
 *   http://www.html5rocks.com/en/tutorials/device/orientation/
 *   dev.w3.org/geo/api/spec-source.html
 **/

(function(Processing, window, navigator) {
   

  ///////////////////////////////////// init //////////////////// 
  // Cache Processing ctor
  var P5 = Processing,
      Pp = Processing.prototype;

  var mobile = {
    // If we don't have support for devicemotion events, use 0 for these.
    acceleration: {
      x: 0,
      y: 0,
      z: 0
    },

    // Defaults for geolocation data
    coords: {
      latitude: 0,
      longitude: 0,
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: -1,
      speed: -1
    },

    // Defaults for orientation data
    orientation: {
      alpha: 0,
      beta: 0,
      gamma: 0,
      compassAccuracy: -1,
      compassHeading: -1
    },
    // Defaults for gesture data
    gesture: {
      scale: 0,
      rotation: 0
    },
	media: {
		miclevel: 0
	}
  };


  //////////////////////////////////////////////////// location ///////////////////////////////////////////////////////// 
  function attachLocationCallback(p) {
    // Start a geolocation watch timeout if a locationChanged callback is provided.
    if (p.locationChanged &&
        typeof p.locationChanged === "function" &&
        navigator.geolocation) {

      navigator.geolocation.watchPosition(
        function success(position) {
          var posCoords = position.coords,
            mCoords = mobile.coords;

          mCoords.latitude = posCoords.latitude;
          mCoords.longitude = posCoords.longitude;
          mCoords.altitude = posCoords.altitude || 0; // can be null,
          mCoords.accuracy = posCoords.accuracy;
          mCoords.altitudeAccuracy = posCoords.altitudeAccuracy || 0; // can be null
          mCoords.heading = posCoords.heading || -1; // can be null
          mCoords.speed = posCoords.speed || -1; // can be null

          p.locationChanged();
        },
        function error(e) {
          // Ignore and use defaults already set for coords
          console.log('Unable to get geolocation position data: ' + e);
        }
      );
    }
  }

  // Extend Processing with locationChanged() callback logic.
  window.Processing = function() {
    var p5 = P5.apply(this, arguments);
    attachLocationCallback(p5);
    return p5;
  };
  window.Processing.prototype = Pp;

  // Copy static properties onto new Processing
  for (var prop in P5) {
    if (!P5.hasOwnProperty(prop)) {
      continue;
    }
    window.Processing[prop] = P5[prop];
  }

  // Extend any existing Processing instances with location callback, too.
  document.addEventListener('DOMContentLoaded', function() {
    Processing.instances.forEach(function(instance) {
      attachLocationCallback(instance);
    });
  }, false);
  


  /////////////////////////////////////////////////////// acceleration //////////////////////////////////////////////////////// 
  window.addEventListener('devicemotion', function(event) {
    var acceleration = event.accelerationIncludingGravity || event.acceleration,
    mAcceleration = mobile.acceleration;

    // Values are in m/s^2
    mAcceleration.x = acceleration.x;
    mAcceleration.y = acceleration.y;
    mAcceleration.z = acceleration.z;
  }, false);
  


  ////////////////////////////////////////////////////////// COMPASS ////////////////////////////////////////////////////////
  function orientationhandler(e) {
    
	// For FF3.6+
    if (!e.gamma && !e.beta) {
      e.gamma = -(e.x * (180 / Math.PI));
      e.beta = -(e.y * (180 / Math.PI));
    }
	
	var dir = 0, ref = 0;
	var direction, delta, heading;
	
	if (typeof e.webkitCompassHeading !== 'undefined') {
        direction = e.webkitCompassHeading;
        if (typeof window.orientation !== 'undefined') {
            direction += window.orientation;
        }
    } else {
        direction = 360 - e.alpha;
    }

    delta = Math.round(direction) - ref;
    ref = Math.round(direction);
    if (delta < -180)
        delta += 360;
    if (delta > 180)
        delta -= 360;
    dir += delta;

    heading = direction;
    while (heading >= 360) {
        heading -= 360;
    }
    while (heading < 0) {
        heading += 360;
    }

    var mOrientation = mobile.orientation;
    mOrientation.alpha = e.alpha;
    mOrientation.beta = e.beta;
    mOrientation.gamma = e.gamma;
    mOrientation.compassAccuracy = e.webkitCompassAccuracy ? e.webkitCompassAccuracy : -1;
    //mOrientation.compassHeading = e.webkitCompassHeading ? e.webkitCompassHeading + window.orientation : -1;
	//mOrientation.compassHeading = e.webkitCompassHeading ? e.webkitCompassHeading + window.orientation : 360 - e.alpha;
	mOrientation.compassHeading = heading;
  }

  window.addEventListener('deviceorientation',  orientationhandler, false);
  window.addEventListener('MozOrientation',     orientationhandler, false);
  

  ////////////////////////////////////////////////////// GESTURE //////////////////////////////////////////////////////////////////////// 
	var pgestureScale = 0;	
	var pgestureRotation = 0;																													
	var gestureScale = 0;	
	var gestureRotation = 0;
	var p = null; 

	window.addEventListener("gesturestart", function(e) {
		var mGesture = mobile.gesture; 
		p = Processing.getInstanceById("pde");
		pgestureScale = mGesture.scale;	
		pgestureRotation = mGesture.rotation;
		mGesture.scale = e.scale;
		mGesture.rotation = e.rotation;

		if(p) {
			if ( typeof p.gestureStarted == "function" ) {
				p.gestureStarted();
			} else {
				p.gestureStarted = true;
			}			
		}
	}, false);	


	window.addEventListener("gesturechange", function(e) {
		var mGesture = mobile.gesture;

		pgestureScale = mGesture.scale;	
		pgestureRotation = mGesture.rotation;	
		mGesture.scale = e.scale;
		mGesture.rotation = e.rotation;   
        if(p) {
			if ( p.gestureChanged ) {
				p.gestureChanged();
			}
		}

	}, false);

	window.addEventListener("gestureend", function(e) {
		var mGesture = mobile.gesture;

		pgestureScale = mGesture.scale;	
		pgestureRotation = mGesture.rotation;

		if(p) {
			if ( typeof p.gestureStarted != "function" ) {
				p.gestureStarted = false;
			}

			if ( p.gestureStopped ) {
				p.gestureStopped();
			}			
		}

        p = null;
		mGesture.scale = null;		
		mGesture.rotation = null;
	}, false);        



/////////////////////////////////////////////// MICROPHONE LEVEL ////////////////////////////////////////////////////////////
 	var max_level_L = 0;
	var old_level_L = 0;
	window.AudioContext = window.AudioContext || window.webkitAudioContext;
	navigator.getUserMedia = navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

	var audioContext = new AudioContext();

	navigator.getUserMedia(
		{audio:true, video:false}, 
		function(stream){    
		
			
			var mic = audioContext.createMediaStreamSource(stream);
			var javascriptNode = audioContext.createScriptProcessor(1024, 1, 1);
			mic.connect(javascriptNode);
			javascriptNode.connect(audioContext.destination); 
			
			console.log("micStart");
			javascriptNode.onaudioprocess = function(event){

				var inpt_L = event.inputBuffer.getChannelData(0);
				var instant_L = 0.0;

				var sum_L = 0.0;
				for(var i = 0; i < inpt_L.length; ++i) {
					sum_L += inpt_L[i] * inpt_L[i];
				}
				instant_L = Math.sqrt(sum_L / inpt_L.length);
				max_level_L = Math.max(max_level_L, instant_L);				
				instant_L = Math.max( instant_L, old_level_L -0.008 );
				old_level_L = instant_L;  
			    
				mMedia = mobile.media;
				mMedia.miclevel = instant_L/max_level_L;	
			}
		},
		function(e){ console.log(e); }
	);
                  


/////////////////////////////////////////////////////////////// end ///////////////////////////////////////////////////////////
  ['orientation', 'acceleration', 'coords', 'gesture', 'media'].forEach(function(objName) {
    Pp.__defineGetter__(objName, function() {
      return mobile[objName];
    });
  });

}(Processing, window, window.navigator));