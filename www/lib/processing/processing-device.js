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




/*****************************************************

 Processing PhoneGap Device API for Processing.js
 [ http://docs.phonegap.com/en/1.1.0/index.html ]

 This library exposes the PhoneGap API (1.1.0) to Processing code and
 transforms callback and other JavaScript type constructs into Processing
 friendly versions.

 To Use:

 <!doctype html>
   <head>
     <!-- Depends on Processing.js being loaded, and loaded first. -->
     <script src="processing.js"></script>
     <script src="processing-phonegap.js"></script>
   </head>
   ...
 </html>

 NOTE: Create your processing instance with code so that you can wait for
 the deviceready event, afterwhich you should listen for DOMContentLoaded.

 New Processing types, constants methods, callbacks
 --------------------------------------------------

 // These are the currently unexposed apects of PhoneGap API.  All of these
 // can still be  accessed via pure JavaScript calls.  See the PhoneGap API docs.
 // TODO:
 //   Camera
 //   Capture
 //   Contacts
 //   File
 //   Media
 //   Storage

 // Device Strings via global device object
 class Device {
   String name;
   String phonegap;
   String platform;
   String uuid;
   Sevice version;
 }
 Device device;

 //Giroscope type, global variable, and callback
 class Giroscope {
   float x;
   float y;
   float z;
   Date timestamp;
 }
 Giroscope giroscope

 // giroscope Event callback
 void giroscope() {
    // giroscope is ready to be used
 }

 // Geolocation types, global variable, and callback
 class Coords {
   float latitude; // Latitude in decimal degrees.
   float longitude; // Longitude in decimal degrees.
   float altitude; // Height of the position in meters above the ellipsoid.
   float accuracy; // Accuracy level of the latitude and longitude coordinates in meters.
   float altitudeAccuracy; // Accuracy level of the altitude coordinate in meters.
   float heading; // Direction of travel, specified in degrees counting clockwise relative to the true north.
   float speed; // Current ground speed of the device, specified in meters per second.
 }
 class Position {
   Coords coords; // The coords of the current position.
   Date timestamp; // The timestamp of the current position.
 }
 Position position;

 // Geolocation Event callback
 void geolocation() {
   // position is ready to be used
 }

 // Compass
 class Heading {
   float magneticHeading; // The heading in degrees from 0 - 359.99 at a single moment in time.
   float trueHeading; // The heading relative to the geographic North Pole in degrees 0 - 359.99 at a single moment in time.
   float headingAccuracy; // headingAccuracy: The deviation in degrees between the reported heading and the true heading.
   Date timestamp; // The time (ms) at which this heading was determined.
 }
 Heading heading;

 // Compass Event Callback
 void compass() {
   // heading is ready to be used
 }

 // New Global Constants for Connection Type
 UNKNOWN
 ETHERNET
 WIFI
 CELL_2G
 CELL_3G
 CELL_4G
 NONE

 // Current Device Connection Type (one of the constants
 // listed above)
 object connectionType

 // Processing's online variable is mapped to PhoneGap's
 // event state for online/offline)
 boolean online;

 // Device Back Button Event Callback
 void backButtonPressed() {
 }

 // Device Menu Button Event Callback
 void menuButtonPressed() {
 }

 // Device Search Button Event Callback
 void searchButtonPressed() {
 }

 // Device Start Call Button Event Callback
 void startCallButtonPressed() {
 }

 // Device Start Call Button Event Callback
 void endCallButtonPressed() {
 }

 // Device Volume Down Button Event Callback
 void volumeDownButtonPressed() {
 }

 // Device Volume Up Button Event Callback
 void volumeUpButtonPressed() {
 }

 // Beep method causes the device to beep the desired number of times.
 beep(int num);

 // Vibrate method causes the device to vibrate for the desired
 // number of ms
 vibrate(int ms);

*****************************************************/




(function(Processing, window, navigator, device) {


  // Make sure we have Processing
  if (!window.Processing) {
    throw "Processing.js PhoneGap Error: Processing not loaded.";
  }

  // Make sure we're running on PhoneGap
  /*
  if (!(window.device && window.device.phonegap)) {
    throw "Processing.js PhoneGap Error: PhoneGap device API not found.";
  }
  */ 
  

  ///////////////////////////////////// init //////////////////// 
  // Cache Processing ctor
  var P5 = Processing,
      Pp = Processing.prototype,
	  log = (console && console.log) ? console.log : function(){};

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
	},
	// The global device object
    device: device,

    // Whether or not the device is connected to the Internet
    online: false,

    // If we don't have support for giroscope events, use -1 for these.
    giroscope: {
      x: -1,
      y: -1,
      z: -1,
      timestamp: Date.now()
    },

    // If we don't have support for compass events, use -1 for these.
    heading: {
      magneticHeading: -1,
      trueHeading: -1,
      headingAccuracy: -1,
      timestamp: Date.now()
    },

    // Defaults for geolocation data
    position: {
      coords: {
        latitude: 0,
        longitude: 0,
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: -1,
        speed: -1
      },
      timestamp: Date.now()
    },
	plugin: {
		miclevel: 0
	}
  };


  
  // Expose connection type constants via PConstants
  var PConstants = Pp.PConstants;
  if ((window.device && window.device.phonegap)) { 
	  PConstants.UNKNOWN  = Connection.UNKNOWN;
	  PConstants.ETHERNET = Connection.ETHERNET;
	  PConstants.WIFI     = Connection.WIFI;
	  PConstants.CELL_2G  = Connection.CELL_2G;
	  PConstants.CELL_3G  = Connection.CELL_3G;
	  PConstants.CELL_4G  = Connection.CELL_4G;
	  PConstants.NONE     = Connection.NONE;  
  }


  // Expose connection type (shared for all instances)
  Pp.__defineGetter__('connectionType', function() {
    return navigator.network.connection.type;
  });


  // Expose beep method
  Pp.beep = function(n) {
    n = n || 1;
	if (navigator.notification) {
    	navigator.notification.beep(n);  
	}
  }

  // Expose vibrate method
  Pp.vibrate = function(ms) {
    ms = ms || 1000;
	if (navigator.notification) {
		alert(ms); 
		navigator.notification.vibrate(ms); 
	}
  }   


	var max_level_L = 0;
	var old_level_L = 0;
	var mMedia = mobile.media; 
	window.AudioContext = window.AudioContext || window.webkitAudioContext;
	navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;
	var audioContext = new AudioContext();  
	Pp.startUserMediaMic = function() {
		if (navigator.getUserMedia) {
			navigator.getUserMedia(
				{audio:true, video:false}, 
				function(stream){    
					console.log("startUserMediaMic");

					var mic = audioContext.createMediaStreamSource(stream);
					var javascriptNode = audioContext.createScriptProcessor(256, 1, 1);
					mic.connect(javascriptNode);
					javascriptNode.connect(audioContext.destination); 

					
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

						mMedia.miclevel = instant_L/max_level_L; 
					}
				},
				function(e){ console.log(e); }
			);
		} else {   
			setInterval(function() {
				if(!phonegap) {
					mMedia.miclevel = 0.1*Math.random(); 
				} else {
					mMedia.miclevel = micLevelPluginPhoneGap;
				}
			},200);
		}
	}



  // Extend the Processing ctor.
  window.Processing = function() {
    var p5 = P5.apply(this, arguments),
      aWatchID,
      cWatchID,
      gWatchID;

    // Do we have an accelerometer callback? If so, start a watch
    if (p5.giroscope) {
      aWatchID = navigator.accelerometer.watchAcceleration(
        function(giroscope) {
          mobile.giroscope = giroscope;
          p5.giroscope();
        },
        function() {
          log('Processing.js PhoneGap Error: Unable to get giroscope data.');
        }
      );
    }

    // Do we have a compass callback? If so, start a watch
    if (p5.compass) {
      cWatchID = navigator.compass.watchHeading(
        function(heading) {
          mobile.heading = heading;
          p5.compass();
        },
        function() {
          log('Processing.js PhoneGap Error: Unable to get compass data.');
        }
      );
    }

    // Do we have a geolocation callback? If so, start a watch
    if (p5.geolocation) {
      gWatchId = navigator.geolocation.watchPosition(
        function(position) {
          mobile.position = position;
          p5.geolocation();
        },
        function() {
          log('Processing.js PhoneGap Error: Unable to get geolocation data.');
        }
      );
    }

    // Do we have a startCallButtonPressed callback?
    if (p5.startCallButtonPressed) {
      document.addEventListener("startcallbutton", function() {
        p5.startCallButtonPressed();
      }, false);
    }

    // Do we have an endCallButtonPressed callback?
    if (p5.endCallButtonPressed) {
      document.addEventListener("endcallbutton", function() {
        p5.endCallButtonPressed();
      }, false);
    }

    // Do we have a searchButtonPressed callback?
    if (p5.searchButtonPressed) {
      document.addEventListener("searchbutton", function() {
        p5.searchButtonPressed();
      }, false);
    }

    // Do we have a backButtonPressed callback?
    if (p5.backButtonPressed) {
      document.addEventListener("backbutton", function() {
        p5.backButtonPressed();
      }, false);
    }

    // Do we have a menuButtonPressed callback?
    if (p5.menuButtonPressed) {
      document.addEventListener("menubutton", function() {
        p5.menuButtonPressed();
      }, false);
    }

    // Do we have a volumeDownButtonPressed callback?
    if (p5.volumeDownButtonPressed) {
      document.addEventListener("volumedownbutton", function() {
        p5.volumeDownButtonPressed();
      }, false);
    }

    // Do we have a volumeUpButtonPressed callback?
    if (p5.volumeUpButtonPressed) {
      document.addEventListener("volumeupbutton", function() {
        p5.volumeUpButtonPressed();
      }, false);
    }

    // When the app gets paused/resumed (put into background)
    // stop/start our draw loop
    document.addEventListener('pause', function() {
      p5.noLoop();
    }, false);
    document.addEventListener('resume', function() {
      p5.loop();
    }, false);

    // When the device's network state changes (connection to
    // the Internet), change the value of Processing's online variable
    document.addEventListener('online', function() {
      mobile.online = true;
    }, false);
    document.addEventListener('offline', function() {
      mobile.online = false;
    }, false);

    // Need to override the instance's default 'online' getter
    delete p5.online;
    p5.__defineGetter__('online', function() {
      return mobile.online;
    });

    // Grab a reference to the existing exit method so we can extend it.
    var exitFunc = p5.exit;

    p5.exit = function() {
      // Kill any running watches
      if (aWatchID) {
        navigator.accelerometer.clearWatch(aWatchID);
        aWatchID = null;
      }
      if (cWatchID) {
        navigator.compass.clearWatch(cWatchID);
        cWatchID = null;
      }
      if (gWatchID) {
        navigator.geolocation.clearWatch(gWatchID);
        gWatchID = null;
      }

      // TODO: should clean up all the listeners we've attached...

      // Do a proper clean-up using the original exit() method
      exitFunc.apply(p5);
    }; 

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


  ////////////////////////////////////////////////////////// COMPASS  and ORIENTATION ////////////////////////////////////////////////////////
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


	var orientationMode = "portrait", orientationX = 1, orientationY = 1;
	function doOnOrientationChange() {
		switch(window.orientation) {  
			case -90:
				orientationMode = "landleft";
				orientationX = 1;
				orientationY = -1;
			break;
			case 90:
				orientationMode = "landright";
				orientationX = -1;
				orientationY = 1;
			break; 
			case 0:
				orientationMode = "portrait";
				orientationX = 1;
				orientationY = 1;
			break; 
			case 180:
				orientationMode = "inverse";
				orientationX = -1;
				orientationY = -1;
			break;   
		}     
	}
	window.addEventListener('orientationchange', doOnOrientationChange);

	if (typeof window.orientation !== 'undefined') {
        doOnOrientationChange();
    }



/////////////////////////////////////////////////////// acceleration //////////////////////////////////////////////////////// 

  window.addEventListener('devicemotion', function(event) {
    var direction = 0;
	var acceleration = event.accelerationIncludingGravity || event.acceleration,
    mAcceleration = mobile.acceleration;

   	if(orientationMode == "landleft" || orientationMode == "landright") {
	    mAcceleration.x = orientationX*acceleration.y; // inverse
	    mAcceleration.y = orientationY*acceleration.x; // inverse
	} else {
		mAcceleration.x = orientationX*acceleration.x;
	    mAcceleration.y = orientationY*acceleration.y;	
	}      
	
	if(isMobile.Android()) {
	    mAcceleration.x = mAcceleration.x * -1;
		mAcceleration.y = mAcceleration.y * -1;  
	}

    mAcceleration.z = acceleration.z;
  }, false);





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

/////////////////////////////////////////////////////////////// end /////////////////////////////////////////////////////////// 
  ['orientation', 'acceleration', 'coords', 'gesture', 'media','giroscope', 'heading', 'position', 'plugin'].forEach(function(objName) {
    Pp.__defineGetter__(objName, function() {
      return mobile[objName];
    });
  });

}(Processing, window, window.navigator, window.device));
