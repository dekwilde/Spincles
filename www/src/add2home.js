$(document).ready(function(){  	
	var config_add2home = {
		autostart:true,
		startDelay: 2000,
		mandatory:true,
		lifespan:1000000,
		maxDisplayCount:10,
		message:"Bem Vindo. Instale este aplicativo em seu aparelho: aperte %icon e selecione <strong>'Adicionar à Tela Inicio'</strong>."
	}
	addToHomescreen(config_add2home);
});