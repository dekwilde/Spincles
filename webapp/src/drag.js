$(function(){
	Number.prototype.deg = function() { return this * 57.295779513; }
	Number.prototype.rad = function() { return this / 57.295779513; }
	Number.prototype.limit = function(min, max) { return this > max ? max : this < min ? min : this ; }
	Number.prototype.wrap = function(min, max) { return (this < min ? max : min) + (this - min) % (max - min); }

	// FUNCTIONS
	
	// Converts cartesian [x, y] to polar [distance, angle] coordinates,
	// downward, anti-clockwise, angle in radians.
	
	var pi = Math.PI,
			pi2 = pi * 2;
	
	function toPolar(cart) {
		var x = cart[0],
				y = cart[1];
		
		// Detect quadrant and work out vector
		if (y === 0) 	{ return x === 0 ? [0, 0] : x > 0 ? [x, 0.5 * pi] : [-x, 1.5 * pi] ; }
		if (y < 0) 		{ return x === 0 ? [-y, pi] : [Math.sqrt(x*x + y*y), Math.atan(x/y) + pi] ; }
		if (y > 0) 		{ return x === 0 ? [y, 0] : [Math.sqrt(x*x + y*y), (x > 0) ? Math.atan(x/y) : pi2 + Math.atan(x/y)] ; }
	}
	
	// Converts [distance, angle] vector to cartesian [x, y] coordinates.
	
	function toCartesian(vect) {
		var d = vect[0],
				a = vect[1];
		
		// Work out cartesian coordinates
		return [ Math.sin(a) * d, Math.cos(a) * d ];
	}
	
	// log event objects
	
	function logEvent(e){ window.console && console.log(e.type, e); }
	
	jQuery(document)
	//.bind('mousedown mouseup', logEvent)
	.ready(function(){
		var start,
				box = jQuery('.drag-box'),
				photo = jQuery('.photo-box'),
				resize = jQuery('.resize'),
				rotate = jQuery('.rotate'),
				centreMark = jQuery('.centre_mark'),
				originMark = jQuery('.origin_mark');
		
		// Test setup and teardown with multiple binds and unbinds...
		
		box
		.bind('movestart move moveend', logEvent)
		.unbind('movestart')
		.unbind('move')
		.unbind('moveend')
		//.bind('movestart move moveend', logEvent)
		.bind('movestart', function(e){
			// Only listen to one finger
			if (e.targetTouches && e.targetTouches.length > 1) {
				e.preventDefault();
				return;
			}

			if (e.target == e.currentTarget) {
				start = {
				  x: parseInt(box.css('left')),
				  y: parseInt(box.css('top'))
				};
			}
		})
		.bind('move', function(e){
			if (e.target == e.currentTarget) {
				box.css({
					left: start.x + e.distX,
					top: start.y + e.distY
				});
				
				// Guides
				
				originMark.css({
					left: start.x + e.distX,
					top: start.y + e.distY
				});
				
				centreMark.css({
					left: start.x + e.distX + box.width()/2,
					top: start.y + e.distY + box.height()/2
				});
			}
		});
		
		(function(){
			// Test for correct deltaX and deltaY values
			
			var distX = 0, distY = 0, pageX = 0, pageY = 0;
			
			box
			.bind('movestart', function(e) {
				distX = e.distX;
				distY = e.distY;
				pageX = e.pageX;
				pageY = e.pageY;
			})
			.bind('move', function(e){
				// All these statements should be true
				console.log(e.deltaX === e.distX - distX,
				            e.deltaY === e.distY - distY,
				            e.deltaX === e.pageX - pageX,
				            e.deltaY === e.pageY - pageY);
				
				if ((e.deltaX === e.distX - distX) +
				    (e.deltaY === e.distY - distY) +
				    (e.deltaX === e.pageX - pageX) +
				    (e.deltaY === e.pageY - pageY) !== 4) {
					console.log('X', distX, e.distX, pageX, e.pageX, e.deltaX);
					console.log('Y', distY, e.distY, pageY, e.pageY, e.deltaY);
				}
				
				distY = e.distY;
				distX = e.distX;
				pageX = e.pageX;
				pageY = e.pageY;
				
				var stl = box.attr('style');
			  	photo.attr('style', stl);
				
				
			});
		})();
		
		var rotation = 90;
		
		(function(){
			var start, rotatedOrigin, distX, distY;
			
			resize
			.bind('movestart', function(e){
				var polarOrigin;
				
				start = {
					left: parseInt(box.css('left')),
					top: parseInt(box.css('top')),
				  width: box.width(),
				  height: box.height()
				};
			})
			.bind('move', function(e){
				var polarDelta = toPolar([e.distX, e.distY]),
						normalisedDelta, originDelta, width, height;
				
				// Comments are useless. I can't describe what's going
				// on here without a pencil and paper. Sorry, but basically,
				// we're undoing the rotate transform to work out where
				// the rotated origin lies.
				polarDelta[1] += rotation.rad();
				normalisedDelta = toCartesian(polarDelta);
				
				width = start.width + normalisedDelta[0];
				height = start.height + normalisedDelta[1];
				
				width = width >= 0 ? width : 0;
				height = height >= 0 ? height : 0;
				
				originDelta = [
					e.distX/2 - (width === 0 ? -start.width/2 : normalisedDelta[0]/2),
					e.distY/2 - (height === 0 ? -start.height/2 : normalisedDelta[1]/2)
				];
				
				box.css({
					left: start.left + originDelta[0],
					top: start.top + originDelta[1],
					width: width,
					height: height
				});
				
				// Guides
				
				originMark.css({
					left: start.left + originDelta[0],
					top: start.top + originDelta[1]
				});
				
				centreMark.css({
					left: start.left + originDelta[0] + width/2,
					top: start.top + originDelta[1] + height/2
				})
			});
		})();
		
		(function(){
			var centre, startRotate, startAngle, positionParent, offset;
			
			rotate
			.bind('movestart', function(e){
				
				positionParent = box.parent();
				offset = positionParent.offset();
				
				centre = {
				  x: parseInt(box.css('left')) + box.width()/2,
				  y: parseInt(box.css('top')) + box.height()/2
				};
				
				startRotate = rotation;
				startAngle = toPolar([e.pageX - offset.left - centre.x, e.pageY - offset.top - centre.y])[1];
				
				// Guides
				
				originMark.css({
					left: box.css('left'),
					top: box.css('top')
				});
				
				centreMark.css({
					left: centre.x,
					top: centre.y
				});
			})
			.bind('move', function(e){
				var nowAngle = toPolar([e.pageX - offset.left - centre.x, e.pageY - offset.top - centre.y])[1],
						deltaRotate = nowAngle - startAngle,
						transform;
				
				rotation = parseInt(startRotate - deltaRotate.deg());
				transform = 'rotate(' + rotation + 'deg)';
				
				box.css({
					transform: transform,
					WebkitTransform: transform,
					MozTransform: transform
				});
			});
		})();
	});
});