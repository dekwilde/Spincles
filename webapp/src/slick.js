$(document).ready(function() {

    $('#frame').slick({
        dots: false,
        infinite: true,
        speed: 300,
        slidesToShow: 4,
        slidesToScroll: 2,
		touchThreshold:10,
		//swipe:false,
		//swipeToSlide:true,
		//rtl:true,
		vertical:true
		
		//swipeToSlide:true
    });
 
});