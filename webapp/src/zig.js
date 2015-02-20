$(document).ready(function(){    

	
	///////////////////////////////////////////////////////// INIT ///////////////////////////////////////////////////////////		                                                                                                     
	//GLOBAL VARIABLES
	var endSessionTime;
	var engage = false;
	var found  = false; 
	var engager;
	var zigX = 0, zigY = 0;
	var rX = 0, rY = 0, rZ = 0, rAngle = 0, rdX = 0, rdY = 0, rdZ = 0;
	var lX = 0, lY = 0, lZ = 0, lAngle = 0, ldX = 0, ldY = 0, ldZ = 0;  
	var hX = 0, hZ = 0, hdX = 0, hdZ = 0;
	
	var delayRate = 10;
	var HandsSteadyActive = -150 
	var pushActive = 400;
	var handsSteady = false;
	var degreesHandsStart = 0, degreesHandsEnd = 0, distanceHandsStart = 0, distanceHandsEnd = 0;
	
	var loop, loopMouse, loopScroll, loopOver, loopOut, loopDrag;
	var drag_el, degree_el = 0;
	var activeTime = 0;
	var timeSession;
	endSessionTime = 3000;
	// CURSORS
	var c = zig.controls.Cursor();
	var cd = document.getElementById('delaycursor');
	var cc = document.getElementById('circle');
	var handR = document.getElementById('handR');
	var handL = document.getElementById('handL');
		
	console.log("Browser plugin installed: " + zig.pluginInstalled);
	console.log("Browser plugin version: " + zig.pluginVersion); 
	console.log("Sensor connected: " + zig.sensorConnected); 
	console.log("Zig.js version: " + zig.version);   
	
	zig.addEventListener('statuschange', function() {
		console.log("Sensor connected: " + zig.sensorConnected);
	});
	
		
    setTimeout(noZigFu, 2000); // if not playvideo 

	$("#user_control").hide();
	$("#handR").hide();
	$("#handL").hide();
	$("#circle").hide();
	$("delaycursor").hide();
		
	/////////////////////////////////////////////////////// Control Panel ///////////////////////////////////////////////////
	var openControl = false
	$(document).keydown(function(e) {
	  if(e.keyCode == 32) { // SPACE				
		if(!openControl) {
			openControl = true;
		    $("#user_control").show();	
		} else {
			openControl = false;
			$("#user_control").hide();
		}
	  }
	});

	
	///////////////////////////////////////////////////////// NAVIGATION //////////////////////////////////////////////////////
		
	function userEngage() {
		engage = true;
		enableLoop();
	}	
	function userDisengage() {
		engage = false;
		disableLoop();		 
	}
	
	
 	var lost, lostTime = 200;
	function userFound() {
		if(!found) {
			console.log("User Center Found");
			clearTimeout(lost);
		}
		found = true;
	}
	function userLost(user) {
		if(found) {
			console.log("User Center Lost");
			lost = setTimeout(function() {
				engager.onuserlost(user); 
				engager.engagedUsers = [];  
				console.log("force desingaged"); 
			}, lostTime); 	
		} 
		found = false;      
	}   

	
	  

	
	////////////////////////////////////////////////////// User engaged ZigFu /////////////////////////////////////////////////////	
  
   	
	function zigEngage() {  
		
		engager = zig.EngageUsersWithSkeleton(1);

		engager.addEventListener('userengaged', function(user) {

			console.log('Engaged: ' + user.id);
			userEngage();  

			user.addEventListener('userupdate', function(user) { 			
				//radarUpdate(user);
				if(zig.sensorConnected) {
					skeletonUpdate(user); // or this
					onLoop();
				}
		  	}); 

		    //zigClick(); //quando tiver drag eu faço isso 

		});

		engager.addEventListener('userdisengaged', function(user) {
			console.log('Disengaged: ' + user.id);		
			userDisengage();		
		});
		
		zig.addListener(engager);	
	}
	
	
 


	//////////////////////////////////////////////////////// SKELETON //////////////////////////////////////////// 
	function skeletonUpdate(user) {  
		hX = user.skeleton[zig.Joint.Head].position[0];
		hZ = user.skeleton[zig.Joint.Head].position[2];
		hdX += (hX - hdX) / delayRate;
	   	hdZ += (hZ - hdZ) / delayRate;
		
		
		rX = user.skeleton[zig.Joint.RightHand].position[0];
		rY = user.skeleton[zig.Joint.RightHand].position[1];
		rZ = user.skeleton[zig.Joint.RightHand].position[2];
		rdX += (rX - rdX) / delayRate;
	   	rdY += (rY - rdY) / delayRate;
		rdZ += (rZ - rdZ) / delayRate;
		rAngle = Math.round(rdX/8);



		lX = user.skeleton[zig.Joint.LeftHand].position[0];
		lY = user.skeleton[zig.Joint.LeftHand].position[1];
		lZ = user.skeleton[zig.Joint.LeftHand].position[2];
		ldX += (lX - ldX) / delayRate;
	   	ldY += (lY - ldY) / delayRate;
		ldZ += (lZ - ldZ) / delayRate;
		lAngle = Math.round(ldX/8);


       	handR.style.left = 	(rdX + window.innerWidth/2 	- (handR.offsetWidth / 2)) + "px";
	   	handR.style.top = 	(-rdY + window.innerHeight/2	- (handR.offsetHeight / 2)) + "px";
		handR.style.webkitTransform = 'rotate('+rAngle+'deg)'; 
		handR.style.mozTransform    = 'rotate('+rAngle+'deg)'; 
		handR.style.msTransform     = 'rotate('+rAngle+'deg)'; 
		handR.style.oTransform      = 'rotate('+rAngle+'deg)'; 
		handR.style.transform       = 'rotate('+rAngle+'deg)';     

	   	handL.style.left = 	(ldX + window.innerWidth/2 	- (handL.offsetWidth / 2)) + "px";
	   	handL.style.top = 	(-ldY + window.innerHeight/2	- (handL.offsetHeight / 2)) + "px";
		handL.style.webkitTransform = 'rotate('+lAngle+'deg)'; 
		handL.style.mozTransform    = 'rotate('+lAngle+'deg)'; 
		handL.style.msTransform     = 'rotate('+lAngle+'deg)'; 
		handL.style.oTransform      = 'rotate('+lAngle+'deg)'; 
		handL.style.transform       = 'rotate('+lAngle+'deg)';	

		//Right Hand Steady
		if (rdY > ldY) {
			pushDistance = Math.abs(rdZ-hdZ);
			zigX = rdX + window.innerWidth/2; 
			zigY = -rdY + window.innerHeight/2;
			handL.style.display = 	"none";
			handR.style.display = 	"block";
			//console.log("pushDistance: " +pushDistance);
		}

		//Left Hand Steady
		if (ldY > rdY) {
			pushDistance = Math.abs(ldZ-hdZ);
			zigX = ldX + window.innerWidth/2; 
			zigY = -ldY + window.innerHeight/2;
			handR.style.display = 	"none";
			handL.style.display = 	"block"; 
		} 
		
		
		if(pushDistance>pushActive) {
			zigPush = true;
			zigDrag = true;
			cc.classList.add('pushed');
			//var el = getElementFromPoint(zigCursorX, zigCursorY);
			//$(el).trigger('click');
			//$(el).trigger('mouseover');
		} else {
			zigPush = false;
			zigDrag = false;
		  	cc.classList.remove('pushed');
			//var el = getElementFromPoint(zigCursorX, zigCursorY);
			//$(el).trigger('mouseup');
		} 
		
		
		
		
		//All HandsSteady
		if(rdY > HandsSteadyActive && ldY > HandsSteadyActive) {
			hcX = (rdX + ldX)/2;
			hcY = (rdY + ldY)/2;
			hpX = (rdX - ldX);
			hpY = (rdY - ldY);	
					
			if(!handsSteady) {
				degreesHandsStart = degreesHandsEnd;
				distanceHandsStart = Math.sqrt(hpX * hpX + hpY * hpY);
			}
			
			//Scale
			distanceHandsEnd = Math.sqrt(hpX * hpX + hpY * hpY);
			zigScale = distanceHandsEnd/distanceHandsStart;
			
			//Degrees
			theta = Math.atan2(-hpY, hpX);
			degreesHandsEnd = theta * 180/Math.PI
			zigDegrees = degreesHandsStart + degreesHandsEnd;
			
			zigX = hcX + window.innerWidth/2;
			zigY = -hcY + window.innerHeight/2;
			handL.style.display = 	"block";
			handR.style.display = 	"block";
			
			handsSteady = true;
			
		} else {
			handsSteady = false;
		}
		
	}          



	
	
	//////////////////////////////////////////////////////  RADAR  /////////////////////////////////////////////////////	 
	
	function radarUpdate(user) {
	    var radarDistance = 900;
		var radarWidth = 200;
		var radarHeight = 300;
		var userCenterX = user.position[0];
		var userCenterY = user.position[2];
		console.log(userCenterX + " " + userCenterY);
		
		if(Math.abs(userCenterX)>radarWidth || userCenterY>radarHeight+radarDistance || userCenterY<radarDistance) {
			userLost(user);  // enable or disable
		} else {
		   	userFound();  // enable or disable 
		}	
	}
 	
	
	function usersRadar(parentElement) {
		// physical dimensions of radar in room. Lets use 4m x 4m
		this.radarWidth = 2000;
		this.radarHeight = 2000;
		var radarCenter = 0.5
		var radarRange = 0.2;

		this.onuserfound = function(user) {
			// create a new element for this user, add to dom
			var el = document.createElement('div');
			el.classList.add('user');
			parentElement.appendChild(el);
			// we can simply add the newly created element to the tracked user object
			// for later
			user.radarElement = el;


			// move the element every frame
			var that = this;
			user.addEventListener('userupdate', function(user) {
				
				// we need to convert [user.x, user.z] to [screen.x, screen.y]
				// first get normalized user position
				var userCenterX = (user.position[0] / that.radarWidth) + radarCenter; // 0 for x is actually the center of the depthmap
				var userCenterY = (user.position[2] / that.radarHeight);
				

				// convert normalized position to fit into our radar element
				var el = user.radarElement;
				el.style.left = userCenterX * parentElement.offsetWidth - (el.offsetWidth / 2) + "px";
				el.style.top  = userCenterY * parentElement.offsetHeight - (el.offsetHeight / 2) + "px";
			});
		}

		this.onuserlost = function(user) {
			// remove the element we created from the dom and ZDK user object
			parentElement.removeChild(user.radarElement);
			delete user.radarElement;

		}
	}

	// make sure you add <div id='radar'></div> to your html body
	var radar = new usersRadar(document.getElementById('radar'));
	zig.addListener(radar);  ///////////////////// disable or enable this method
	
	



	//////////////////////////////////////////////////////// PUSH ////////////////////////////////////////////////
	function zigClick() {
		var pushDetector = zig.controls.PushDetector();
		//pushDetector.numberOfpushs = 3;
		pushDetector.addEventListener('push', function(pd) {
			zigPush = true;
			zigDrag = true;
			cc.classList.add('pushed');
			var el = getElementFromPoint(zigCursorX, zigCursorY);
			//$(el).trigger('click');
			$(el).trigger('mouseover');
			drag_el = el;
			//loopDrag = setInterval(onLoopDrag, 10);
			console.log(el + ' pushDetector: push');
		});
		pushDetector.addEventListener('click', function(pd) {
			zigPush = true;
			var el = getElementFromPoint(zigCursorX, zigCursorY);
			//$(el).trigger('click'); 
			$(el).trigger('mousedown');
			console.log(el + ' pushDetector: click');
			
		});
		pushDetector.addEventListener('release', function(pd) {
			zigPush = false;
			zigDrag = false;
		  	cc.classList.remove('pushed');
			var el = getElementFromPoint(zigCursorX, zigCursorY);
			$(el).trigger('mouseup');
			//clearInterval(loopDrag);
			console.log(el + 'pushDetector: release');
		});
		
		//zig.singleUserSession.addListener(pushDetector);
	}


	/////////////////////////////////////////////////////////// SWIPE ////////////////////////////////////////////////////////
	var swipe = true;
	var swipeTime = 1000;
	var swipeDetector = zig.controls.SwipeDetector(1000);
	
	
	function swipeDelay() {
		swipe = true;
	}

	swipeDetector.addEventListener('swipeleft', function(pd) {
		if(swipe) {
			console.log('Swipe Left'); 
			swipe = false;
			setTimeout(swipeDelay, swipeTime);
		}
	});
	swipeDetector.addEventListener('swiperight', function(pd) {
		if(swipe) {
			console.log('Swipe Right');
			swipe = false;
			swipeTimer = setTimeout(swipeDelay, swipeTime);
		}
	});
	
	//zig.singleUserSession.addListener(swipeDetector);	 //descomentar se quiser habilitar
    


	/////////////////////////////////////////////////////////// Steady //////////////////////////////////////////////////////// 
	
	var steadyDetector = zig.controls.SteadyDetector();
	steadyDetector.addEventListener('steady', function(sd) {
		console.log('SteadyDetector: Steady');
	});
	steadyDetector.addEventListener('unsteady', function(sd) {
		console.log('SteadyDetector: Unsteady');
	});
	//zig.singleUserSession.addListener(steadyDetector);


	/////////////////////////////////////////////////////////// FADER ////////////////////////////////////////////////////////
	var f = zig.controls.Fader(zig.Orientation.X);
	f.addEventListener('valuechange', function (f) {
		console.log('Fader value: ' + (f.value * 100));
	})
	//zig.singleUserSession.addListener(f);
	
	
    /////////////////////////////////////////////////////////// LOOP ///////////////////////////////////////////////////////
	function enableLoop() {
		if(!zig.sensorConnected) {
			loopMouse = setInterval(onLoopPosition, 10); 
		} 
	}   
	function disableLoop() {
		if(!zig.sensorConnected) {
			clearInterval(loopMouse);
		} 
	}
	function onLoop() {
		onLoopPosition();
	}  
		
	function onLoopPosition() {
		// Delay cursor track
		zigCursorX += (zigX - zigCursorX) / delayRate;
		zigCursorY += (zigY - zigCursorY) / delayRate;

		cd.style.left = (zigCursorX - (cd.offsetWidth / 2)) + "px";
		cd.style.top = (zigCursorY - (cd.offsetHeight / 2)) + "px";
		cd.style.display = 'block';
	}

	/////////////////////////////////////////////////NO ZIG //////////////////////////////////////////////////////

	
	
	function noZigFu() {
		if(zig.pluginInstalled) {
			$("img[alt='Powered by Zigfu']").css("width", "1px");
		}
		if(!zig.sensorConnected) {  
			/*
			console.log("Sensor connected: " + zig.sensorConnected); 
			var loopMouseDEBUG = setInterval(loopMouseDEBUG, 10); 
		    function loopMouseDEBUG() {
				zigCursorX += (zigX - zigCursorX) / delayRate;
			   	zigCursorY += (zigY - zigCursorY) / delayRate;
				cd.style.left = zigCursorX + "px"; 
				cd.style.top = 	zigCursorY + "px";
				cd.style.display = 'block';
			}		
			$(document).keydown(function(e) {
			  if(e.keyCode == 37) { // left
				zigX -= 50;
				$("#circle").show();
			  }
			  else if(e.keyCode == 39) { // right
				zigX += 50;
				$("#circle").show();
			  }
			  else if(e.keyCode == 38) { // top
				zigY -= 50;
				$("#circle").show();
			  }
			  else if(e.keyCode == 40) { // bottom
				zigY += 50;
				$("#circle").show();
			  }  
			});
			
			$(document).keyup(function(e) {
			  $("#circle").hide()
			});
			enableLoop();
			userEngage();  
			*/  		
		} else { 
			console.log("Sensor connected: " + zig.sensorConnected); 
			$("*").css("cursor", "none");
			$("#circle").show();
			zigDevice = true;    
			zigEngage();
		}
		
	} 

	                        
});  
 
