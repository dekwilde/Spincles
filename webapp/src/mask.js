$(document).ready(function() {

	$("input").blur(function() {
       // $("#info").html("Unmasked value: " + $(this).mask());
    }).dblclick(function() {
        $(this).unmask();
    });


	
	//Email
	$("input[name='email']").focusout(function(){
		//var regex = new RegExp("^([0-9a-zA-Z]+([_.-]?[0-9a-zA-Z]+)*@[0-9a-zA-Z]+[0-9,a-z,A-Z,.,-]+(.){2}[a-zA-Z]{2,4})+$");
		var regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		
		if(!$(this).val().match(regex)){
		    alert("Email invalido");
		    $(this).val("");
		    //$(this).focus();
		}
	});

	
	//Nome
	$("input[name='nome']").focusout(function(){
        if(nomeComposto($(this).val())){
           alert("Nome incompleto! Digite o nome e sobrenome");
            $(this).val("");
			//$(this).focus();
           //$("input[name='nome']").focus();

        }
	});
	function nomeComposto(nome) {
        var qt = nome.split(' ');
        if(qt.length < 2) {
           var msg = "Nome incompleto";
           return msg;
        } else
            var msg = null;
            return msg;
    }



	//CELULAR
	$("input[name='fone']").mask("(99) 9999?9-9999");

	/*
	 Quem encontrar problemas com o "target", utilize esta alternativa
	 Enviado por: Irineu <irineujunior@gmail.com>
	*/
	$("input[name='fone']").focusout(function(){
	    var phone, element;
	    element = $(this);
	    element.unmask();
	    phone = element.val().replace(/\D/g, '');
	    if(phone.length > 10) {
	        element.mask("(99) 99999-999?9");
	    } else {
	        element.mask("(99) 9999-9999?9");
	    }
	}).trigger('focusout');
	
	
	$("input[name='nascimento']").mask("99/99/9999");
	$("input[name='cpf']").mask("999.999.999-99");
	$("input[name='cep']").mask("99999-999");
	
});
 
