var slider, onSlide = false;  

$(document).ready(function(){
	slider = $('.bxslider').bxSlider({
				autoStart: true,
				autoControls:false,
				auto: true,
				pause: 30000,
				autoDelay: 180000,
				adaptiveHeight: true,
				//slideWidth: 800,
				infiniteLoop:true,
				hideControlOnEnd:true,
				video: true,
				//useCSS: false,
				mode: 'horizontal',
				easing: 'ease-in-out',
				captions: true,
				//controls:false,
				preloadImages: 'all',
				pager: false,
				nextSelector: '.bxslider-next',
				prevSelector: '.bxslider-prev',
				nextText: '',
				prevText: '',
				onSlideAfter: function(Index, oldIndex, newIndex){
		            var newSlide = $('.bxslider li').eq(newIndex);
					var oldSlide = $('.bxslider li').eq(oldIndex);
					var setSlide = Index;
		            // if (newSlide.find('video').length !== 0) {
		            //     newSlide.find('video').get(0).pause();
		            // }
		            // if (oldSlide.find('video').length !== 0) {
		            //     oldSlide.find('video').get(0).pause();
		            // }
					stopVideos();
		            if (setSlide.find('video').length !== 0) {
		                stopSlide();
						setSlide.find('video').get(0).play();
		            }

			    }
			});
});

function slidePrev() {
	slider.goToPrevSlide();
	slider.stopAuto();
}
function slideNext() {
	slider.goToNextSlide();
	slider.stopAuto();
}
function reloadSlide() {
	slider.reloadSlider();
}
function goSlide(id) {
	slider.goToSlide(id);
}
function stopSlide() {
	slider.stopAuto();	
}  


function openSlide(id) {
	onSlide = true;
	$("#slide").show();
	$("#bxslider-container").css("opacity", "0.0");
	$("#slide").animate({opacity: '1.0'}, 2000,'easeInOutExpo', 
	function() {	
		reloadSlide();
		goSlide(id);
		$("#bxslider-container").delay(1000).animate({opacity: '1.0'}, 1500,'easeInOutExpo');
		
	});
}
function closeSlide() {
	onSlide = false;
	stopVideos();
	$("#slide").animate({opacity: '0.0'}, 1500,'easeInOutExpo', 
	function() {	
		$("#slide").hide();  
	});
}
  

function stopVideos() {
	var videos = document.getElementsByTagName('video');
    for(var i = 0, len = videos.length; i < len;i++){
        videos[i].pause();
		videos[i].load();
    }
}


