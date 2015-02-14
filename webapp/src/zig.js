var zigCursorX = 0, zigCursorY = 0;
var zigScale = 0, zigDegrees = 0;
var zigPress = false, zigDrag = false;
var zigDevice = false;
$(document).ready(function(){    

	
	///////////////////////////////////////////////////////// INIT ///////////////////////////////////////////////////////////		                                                                                                     
	//GLOBAL VARIABLES
	var endSessionTime;
	var engage = false;
	var found  = false; 
	var zigX = 0, zigY = 0;
	var rX = 0, rY = 0, rAngle = 0, rdX = 0, rdY = 0;
	var lX = 0, lY = 0, lAngle = 0, ldX = 0, ldY = 0;
	
	var delayRate = 10;
	var HandsSteadyActive = -200
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
	console.log("Zig.js version: " + zig.version);
	
		
    setTimeout(noZigFu, 2000); // if not playvideo 

	$("#user_control").hide();
	$("#handR").hide();
	$("#handL").hide();
	$("#circle").hide();
	$("delaycursor").hide();
	
	/////////////////////////////////////////////////////////// NAVEGATION ///////////////////////////////////////////////////////    
	
	
	$("div #over").mouseover(function(){
		$(this).parent().find("#out").removeClass("out-menu").addClass("over-menu");
	});
	$("div #out").mouseout(function(){
		$(this).removeClass("over-menu").addClass("out-menu");
	});
	$("div #out").click(function(){
		window.location = $(this).attr("href");
	});
	
	
	
	/////////////////////////////////////////////////////// Control Panel ///////////////////////////////////////////////////
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

	
	  
	
	
	////////////////////////////////////////////////////// User RADAR ZigFu /////////////////////////////////////////////////////	 
	
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
	
	
	
	
	////////////////////////////////////////////////////// User engaged ZigFu /////////////////////////////////////////////////////	
	var engager = zig.EngageUsersWithSkeleton(1);
	
	engager.addEventListener('userengaged', function(user) {

		console.log('Engaged: ' + user.id);
		userEngage();  
		
		user.addEventListener('userupdate', function(user) { 			
			//radarUpdate(user);
			if(zig.sensorConnected) {
				handsUpdate(user); // or this
				onLoop();
			}
	  	}); 
	      
		//handSession(user);   // or this
	    zigClick(); //quando tiver drag eu faço isso 
		
		// setTimeout(function() {
		// 	engager.onuserlost(user);
		// }, 3000)   
		

         
	});
   
	engager.addEventListener('userdisengaged', function(user) {
		console.log('Disengaged: ' + user.id);		
		userDisengage();		
	});
	zig.addListener(engager);
	
 
	////////////////////////////////////////////////// HAND SESSION - Events ///////////////////////////////////////////////
	function handSession(user) {
		var ControlHandSession = {
			onsessionstart : function(p) {
				clearTimeout(timeSession);
				console.log("sessionstart");
			},  
			onsessionend : function(user) {
				console.log("sessionend");
			},
			onsessionupdate : function(p) { 
				//handsUpdate(user); //orthis
			},
			onattach : function(user) { 
				user.addListener(c); //orthis  
				
			}
		};	
		var hsd = zig.HandSessionDetector();
		hsd.shouldRotateHand = true;
		hsd.startOnWave = true;
		hsd.startOnSteady = true; 
		hsd.shouldSmoothPoints = true;
		hsd.addListener(ControlHandSession);
		user.addListener(hsd); // ADD cursor
	}



	//////////////////////////////////////////////////////// SKELETON hands //////////////////////////////////////////// 
	function handsUpdate(user) {
		rX = user.skeleton[zig.Joint.RightHand].position[0];
		rY = user.skeleton[zig.Joint.RightHand].position[1];
		rdX += (rX - rdX) / delayRate;
	   	rdY += (rY - rdY) / delayRate;
		rAngle = Math.round(rdX/8);



		lX = user.skeleton[zig.Joint.LeftHand].position[0];
		lY = user.skeleton[zig.Joint.LeftHand].position[1];
		ldX += (lX - ldX) / delayRate;
	   	ldY += (lY - ldY) / delayRate;
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
			zigX = rdX + window.innerWidth/2; 
			zigY = -rdY + window.innerHeight/2;
			handL.style.display = 	"none";
			handR.style.display = 	"block";
		}

		//Left Hand Steady
		if (ldY > rdY) {
			zigX = ldX + window.innerWidth/2; 
			zigY = -ldY + window.innerHeight/2;
			handR.style.display = 	"none";
			handL.style.display = 	"block";
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




	
	/////////////////////////////////////////////////// HAND SESSION - Cursor ////////////////////////////////////////////
	   
	// 2. move the cursor element on cursor move
	c.addEventListener('move', function(cursor) {
		zigX = c.x * window.innerWidth;
        zigY = c.y * window.innerHeight; 				    	
	});

	/*
	// 3. Add/remove 'pushed' class on cursor push/release
	c.addEventListener('push', function(c) {
		//ce.classList.add('pushed'); 
		cc.classList.add('pushed'); 
	});
	c.addEventListener('release', function(c) {
		cc.classList.remove('pushed');
	});

	// 4. Simulate mouse click on our virtual cursor
	c.addEventListener('click', function(c) {
		var el = getElementFromPoint(zigCursorX, zigCursorY);
		$(el).trigger('click'); 
		console.log(el + " clicked"); 
	});
	*/
 

	//////////////////////////////////////////////////////// PUSH ////////////////////////////////////////////////
	function zigClick() {
		var pushDetector = zig.controls.PushDetector();
		//pushDetector.numberOfpushs = 3;
		pushDetector.addEventListener('push', function(pd) {
			zigPress = true;
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
			var el = getElementFromPoint(zigCursorX, zigCursorY);
			//$(el).trigger('click'); 
			$(el).trigger('mousedown');
			console.log(el + ' pushDetector: click');
			
		});
		pushDetector.addEventListener('release', function(pd) {
			zigPress = false;
			zigDrag = false;
		  	cc.classList.remove('pushed');
			var el = getElementFromPoint(zigCursorX, zigCursorY);
			$(el).trigger('mouseup');
			//clearInterval(loopDrag);
			console.log(el + 'pushDetector: release');
		});
		
		zig.singleUserSession.addListener(pushDetector);
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
	zig.singleUserSession.addListener(steadyDetector);


	/////////////////////////////////////////////////////////// FADER ////////////////////////////////////////////////////////
	var f = zig.controls.Fader(zig.Orientation.X);
	f.addEventListener('valuechange', function (f) {
		console.log('Fader value: ' + (f.value * 100));
	})
	//zig.singleUserSession.addListener(f);
	
	
	 
  
	////////////////////////////////////////////////// Target Point Element ////////////////////////////////////////////////

	function applyVisibility(vis) {
		//ce.style.visibility = vis; 
		cd.style.visibility = vis;
		handR.style.visibility = vis;
		handL.style.visibility = vis;
		 
	}

	function getElementFromPoint(eX, eY) {
		// hide canvas so it isn't picked up
		applyVisibility('hidden');

		var element = document.elementFromPoint(eX, eY);

		if ( ! element ) {
			applyVisibility('visible');
			return false;
		}

		if ( element.nodeType == 3 )
			element = element.parentNode;

		// show the canvas again, hopefully it didn't blink
		applyVisibility('visible');
		return element;
	};

	
	
	///////////////////////////////////////////////////// TIMER CIRCLE ///////////////////////////////////////////////////// 
	
    var w = 50, // largura do circle
		h = 50, // altura do circle
		r = Raphael("delaycursor", w, h), //id da div
        R = 20, //raio do circulo
		i = 0, // timer
        param = {stroke: "#000", "stroke-width": R/2}; //borda
    // Custom Attribute
    r.customAttributes.arc = function (value, total, R) {
        var alpha = 360 / total * value,
            a = (90 - alpha) * Math.PI / 180,
            x = w/2 + R * Math.cos(a),
            y = h/2 - R * Math.sin(a),
            color = "rgba(0,0,0," + value / total + ")",
            path;
        if (total == value) {
            path = [["M", w/2, h/2 - R], ["A", R, R, 0, 1, 1, (w - 0.01), w - R]];
        } else {
            path = [["M", w/2, h/2 - R], ["A", R, R, 0, +(alpha > 180), 1, x, y]];
        }
        return {path: path, stroke: color};
    };

    var circle = r.path().attr(param).attr({arc: [0, 0, R]});

    function updateCircle(value) {
        //hand.animate({arc: [value, total, R]}, 750, "elastic");
 		circle.attr({arc: [value, 100, R]});
    }


    /////////////////////////////////////////////////////////// LOOP ///////////////////////////////////////////////////////
	function enableLoop() {
		if(!zig.sensorConnected) {
			loopMouse = setInterval(onLoopMouse, 10); 
			loopOver = setInterval(onLoopOver, 100); 
		}
		loopOut = setInterval(onLoopOut, 1000);  
	}   
	function disableLoop() {
		if(!zig.sensorConnected) {
			clearInterval(loopMouse);
			clearInterval(loopScroll);
			clearInterval(loopOver); 
		}
		clearInterval(loopOut); 
	}
	function onLoop() {
		onLoopMouse();
		onLoopOver();
		//onLoopOut();
	}  
		
	function onLoopMouse() {
		// Delay cursor track
		zigCursorX += (zigX - zigCursorX) / delayRate;
		zigCursorY += (zigY - zigCursorY) / delayRate;

		cd.style.left = (zigCursorX - (cd.offsetWidth / 2)) + "px";
		cd.style.top = (zigCursorY - (cd.offsetHeight / 2)) + "px";
		cd.style.display = 'block';
	}


    function onLoopOver() {
		var el = getElementFromPoint(zigCursorX, zigCursorY);
		$(el).trigger("mouseover"); 		
		if (el.id == "out") {
			updateCircle(activeTime); 
			activeTime = activeTime + 2;
			if(activeTime > 100) {
				activeTime = 0;  
				console.log("actived"); 
				$(el).trigger('click');
			}   
		} else {
			activeTime = 0;
		}	
	}
	function onLoopOut() {
		var el = getElementFromPoint(zigCursorX, zigCursorY);
		if (el.id == "out") {
			console.log("over the out");
			$(el).addClass("actived");			
		} else {
			circle.attr({arc: [0, 0, R]});
			$("div #out").trigger('mouseout');
			$("div #out").removeClass("actived");
		}
	}
	function onLoopDrag() {
		drag_el.style.left = 	cd.offsetLeft 	+ cd.offsetWidth/2 	- drag_el.offsetWidth/2 	+ "px";
		drag_el.style.top = 	cd.offsetTop 	+ cd.offsetHeight/2 - drag_el.offsetHeight/2 	+ "px"; 
		if (handsSteady) {
			drag_el.style.webkitTransform = 'rotate(' + degreesHands + 'deg)' + 'scale(' + distanceHands/500 + ')'; 
			drag_el.style.mozTransform    = 'rotate(' + degreesHands + 'deg)' + 'scale(' + distanceHands/500 + ')';  
			drag_el.style.msTransform     = 'rotate(' + degreesHands + 'deg)' + 'scale(' + distanceHands/500 + ')';  
			drag_el.style.oTransform      = 'rotate(' + degreesHands + 'deg)' + 'scale(' + distanceHands/500 + ')';  
			drag_el.style.transform       = 'rotate(' + degreesHands + 'deg)' + 'scale(' + distanceHands/500 + ')';    
		} else {
			
			// Get Angle from Element and Math the matrix to degrees
			var st = window.getComputedStyle(drag_el, null);
			var tr = 	st.getPropertyValue("-webkit-transform") ||
			         	st.getPropertyValue("-moz-transform") ||
			         	st.getPropertyValue("-ms-transform") ||
			         	st.getPropertyValue("-o-transform") ||
			         	st.getPropertyValue("transform") ||
			         	0;
			var vtr = tr.split('(')[1];
			    vtr = vtr.split(')')[0];
			    vtr = vtr.split(',');
			var vtr_a = vtr[0];
			var vtr_b = vtr[1];
			var vtr_c = vtr[2];
			var vtr_d = vtr[3];
			
			
			theta = Math.atan2(vtr_b, vtr_a);
			
			
			// If you need nonnegative numbers
			// if (theta > 180) {
			//    theta -= 2 * Math.PI;
			// }
			

			degree_el = theta * 180/Math.PI;
									
			console.log(degree_el);
			
			
		}

		
	}

	
	/////////////////////////////////////////////////NO ZIG - MOUSE DEBUG //////////////////////////////////////////////////////

	
	
	function noZigFu() {
		if(zig.pluginInstalled) {
			$("img[alt='Powered by Zigfu']").css("width", "1px");
		}
		if(!zig.sensorConnected) {
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
		} else {
			$("*").css("cursor", "none");
			$("#circle").show();
			zigDevice = true;
		}
		
	} 

	                        
});  
 
