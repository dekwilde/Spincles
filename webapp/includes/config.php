<?php
	require '../src/php-sdk/facebook.php';
	
	//$appID = "502589149844503";
	//$secretID = "2dc7f4ef6d9e621e276068c7e79bc3b1";
	
	
	$appID = "125881397465373";
	$secretID = "eabb70384052a7c475db747553dd4526";
	
	$config = array();
	$config['appId'] = $appID;
	$config['secret'] = $secretID;
	$config['fileUpload'] = true;
	$config['cookie'] = false;

	$facebook = new Facebook($config);
	$user = $facebook->getUser();
	$token = $facebook->getAccessToken();
	$facebook->setFileUploadSupport(true);
	
	$scope = "publish_stream, photo_upload, publish_checkins, email";
	
	$app_url = "https://apps.facebook.com/renault-salao";
	$tab_url = "";
	$host_url = "https://renault.dekwilde.com.br";
	
	$redirect_uri = $host_url . '/functions/post.php';
	
	// CHECK IN
	$place_id = "129793527037644";
	$latitude = "-23.516016449899";
	$longitude = "-46.636754669443";
	
	//PHOTO
	$album_name = 'Renault Salão do Automóvel';
   	$album_description = 'Renault Salão do Automóvel';

	//POST FEED
	$post_message = "#RENAULTSALAOSP2014";
	$post_name = "#RENAULTSALAOSP2014";
	$post_picture = $host_url . "/img/icon1024.jpg";
	$post_link = $app_url;
	$post_uri = $app_facebook;
	$post_caption = "Aplicativo para a Renault Salão do Automóvel";
	$post_description = "#RENAULTSALAOSP2014";
	

?>