//GLOBAL VARIABLES
var endSessionTime;
var engage = false;
var found  = false;
$(document).ready(function(){    

	
	///////////////////////////////////////////////////////// INIT ///////////////////////////////////////////////////////////		                                                                                                     
    var cursorX = 0, cursorY = 0;
	var cX = 0, cY = 0;
	var rX = 0, rY = 0, rAngle = 0, rdX = 0, rdY = 0;
	var lX = 0, lY = 0, lAngle = 0, ldX = 0, ldY = 0;
	
	var delayRate = 10;
	var HandsSteadyActive = -80
	var handsSteady = false;
	var degreesHands = 0, distanceHands = 0;
	
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

	//$(this).unbind('mouseover').unbind('mouseout');
	//$(this).click(function(e){ e.preventDefault(); });
	$("#container").css("opacity", 0.0);
	$("#user_control").hide();
	$("#slide").hide();
	$("#slide").css('opacity', 0.0);
	cd.style.display = 'none';
	handR.style.display = 'none'; 
	handL.style.display = 'none'; 
	$("*").css("cursor", "none");       
	
	//$("#player").hide();
	
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
	
	
	/////////////////////////////////////////////////////////// VIDEO /////////////////////////////////////////////////////// 

	var player, timePlay = 60000;   
	
	player = document.getElementById("player");    
	
	player.onended = function(e) {
	      disableVideo();
		  videoLoop();
	};


	document.addEventListener('play', function(e){
	    var videos = document.getElementsByTagName('video');
	    for(var i = 0, len = videos.length; i < len;i++){
	        if(videos[i] != e.target){
	            videos[i].pause();
	        }
	    }
	}, true);

	function videoLoop() {
		setTimeout(enableVideo, timePlay);
	}
	function Pause() { 
		player.pause();
	}
	function Play() {
		player.play();
	}

	function disableVideo() {  
		player.load();
		Pause(); 	
	}
	function enableVideo() {
		if(!engage) {
			player.load();
			Play();  
	   	}
	}

	 
	
	/////////////////////////////////////////////////////// Control Panel ///////////////////////////////////////////////////
	$("#bt_user_control").hide();
	var openControl = false;
	$("#bt_user_control").click(function() {
		controlShow();
	});  
	$("#user_control").click(function() {
		controlHide();
	});


	$(document).keydown(function(e) {
	  if(e.keyCode == 32) { // char "g"				
		if(!openControl) {
			controlShow();	
		} else {
			controlHide();
		}
	  }
	});

	
	
	
	function controlShow() {
		openControl = true;
	    $("#user_control").show();
		$("#user_control").animate({opacity: '1.0'}, 1000,'easeInOutExpo', 
		function() {	
			//
		});  
	}
	function controlHide() {
		openControl = false;
		$("#user_control").animate({opacity: '0.0'}, 1500,'easeInOutExpo', 
		function() {	
			$("#user_control").hide();
		});
		
	}

	///////////////////////////////////////////////////////// NAVIGATION //////////////////////////////////////////////////////
		
	function sessionEnd() {
        //controlShow();
	}
	function sessionStart() {
		disableVideo(); 
		//controlHide();

	} 
	
	function userEngage() {
		engage = true;
		$("#handR").show();
		$("#handL").show();
		$("#circle").show();
		disableVideo();
		enableLoop();
		$("#container").animate({opacity: '1.0'}, 1500,'easeInOutExpo', 
		function() {	
			sessionEnd(); //inverte os bagulho mesmo!!!
		}); 
	}	
	function userDisengage() {
		engage = false;
		$("#handR").hide();
		$("#handL").hide();
		$("#circle").hide();
		sessionStart();
		disableLoop();
		closeSlide(); //GLOBAL inverte os bagulho mesmo!!!		
		$("#container").delay(2000).animate({opacity: '0.0'}, 1000,'easeInOutExpo', 
		function() {	
			videoLoop();
		});
		 
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
			handsUpdate(user); // or this
			onLoop();
	  	}); 
	      
		//handSession(user);   // or this
	    //dragClick(); //quando tiver drag eu faço isso 
		
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
				sessionStart(); 
				console.log("sessionstart");
			},  
			onsessionend : function(user) {
				timeSession = setTimeout(sessionEnd, endSessionTime);   
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
		rdX += (rX - rdX) / 10;
	   	rdY += (rY - rdY) / 10;
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
			cursorX = rdX + window.innerWidth/2; 
			cursorY = -rdY + window.innerHeight/2;
			handL.style.display = 	"none";
			handR.style.display = 	"block";
		}

		//Left Hand Steady
		if (ldY > rdY) {
			cursorX = ldX + window.innerWidth/2; 
			cursorY = -ldY + window.innerHeight/2;
			handR.style.display = 	"none";
			handL.style.display = 	"block";
		}

		//All HandsSteady
		if(rdY > HandsSteadyActive && ldY > HandsSteadyActive) {
			handsSteady = true;
			hcX = (rdX + ldX)/2;
			hcY = (rdY + ldY)/2;
			hpX = (rdX - ldX);
			hpY = (rdY - ldY);
			distanceHands = Math.sqrt(hpX * hpX + hpY * hpY)
			theta = Math.atan2(-hpY, hpX);

			/*
			// If you need nonnegative numbers
			if (theta < 0) {
			   theta += 2 * Math.PI;
			}
			*/


			degreesHands = theta * 180/Math.PI


			cursorX = hcX + window.innerWidth/2;
			cursorY = -hcY + window.innerHeight/2;
			handL.style.display = 	"block";
			handR.style.display = 	"block";
		} else {
			handsSteady = false;
		}

	}          




	
	/////////////////////////////////////////////////// HAND SESSION - Cursor ////////////////////////////////////////////
	   
	// 2. move the cursor element on cursor move
	c.addEventListener('move', function(cursor) {
		cursorX = c.x * window.innerWidth;
        cursorY = c.y * window.innerHeight; 				    	
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
		var el = getElementFromPoint(cX, cY);
		$(el).trigger('click'); 
		console.log(el + " clicked"); 
	});
	*/
 

	//////////////////////////////////////////////////////// PUSH ////////////////////////////////////////////////
	function dragClick() {
		var pushDetector = zig.controls.PushDetector();
		//pushDetector.numberOfpushs = 3;
		pushDetector.addEventListener('push', function(pd) {
			cc.classList.add('pushed');
			var el = getElementFromPoint(cX, cY);
			drag_el = el;
			loopDrag = setInterval(onLoopDrag, 10);
			console.log(el + ' pushDetector: push');
		});
		pushDetector.addEventListener('click', function(pd) {
			var el = getElementFromPoint(cX, cY);
			$(el).trigger('click'); 
			console.log(el + ' pushDetector: click');
			
		});
		pushDetector.addEventListener('release', function(pd) {
		  	cc.classList.remove('pushed');
			clearInterval(loopDrag);
			console.log('pushDetector: release');
		});
		
		zig.singleUserSession.addListener(pushDetector);
	}

   
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
			loopScroll = setInterval(onLoopScroll, 10);
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
		onLoopScroll();
		onLoopOver();
		//onLoopOut();
	}  
		
	function onLoopMouse() {
		// Delay cursor track
		cX += (cursorX - cX) / delayRate;
		cY += (cursorY - cY) / delayRate;

		cd.style.left = (cX - (cd.offsetWidth / 2)) + "px";
		cd.style.top = (cY - (cd.offsetHeight / 2)) + "px";
		cd.style.display = 'block';
	}
	 
	function onLoopScroll() {
        if(!onSlide) {
			$("body").scrollLeft(function(i, v) {
		        var w = $(window).width();
		        var x = cX - w / 2;
		        return v + x * 0.10;
		    }); 
		}

	}

    function onLoopOver() {
		var el = getElementFromPoint(cX, cY);
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
		var el = getElementFromPoint(cX, cY);
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
				cX += (cursorX - cX) / delayRate;
			   	cY += (cursorY - cY) / delayRate;
				cd.style.left = cX + "px"; 
				cd.style.top = 	cY + "px";
				cd.style.display = 'block';

			}		
			$(document).keydown(function(e) {
			  if(e.keyCode == 37) { // left
				cursorX -= 50;
			  }
			  else if(e.keyCode == 39) { // right
				cursorX += 50;
			  }
			  else if(e.keyCode == 38) { // top
				cursorY -= 50;
			  }
			  else if(e.keyCode == 40) { // bottom
				cursorY += 50;
			  }  
			});
			enableLoop();
			userEngage();
			sessionStart(); 
		} else {
			videoLoop(); // GLOBAL function   
		}
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
			slideNext();
			swipe = false;
			setTimeout(swipeDelay, swipeTime);
		}
	});
	swipeDetector.addEventListener('swiperight', function(pd) {
		if(swipe) {
			console.log('Swipe Right');
			slidePrev();
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
	/*
	var f = zig.controls.Fader(zig.Orientation.X);
	f.addEventListener('valuechange', function (f) {
		console.log('Fader value: ' + (f.value * 100));
	})
	zig.singleUserSession.addListener(f);
	*/                         
});  
 