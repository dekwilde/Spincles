<div data-role="page" data-control-title="Login" data-theme="b" id="login" style="background: url('img/login-bg.jpg'); background-size:cover">
     <div data-role="content" style="padding: 10%">
	  <h1>
	    PREENCHA COM SEUS DADOS PARA PARTICIPAR:
	  </h1>
         <form action="" id="formSign" method="POST" data-ajax="false" data-theme="b" enctype="multipart/form-data" >
             <div data-role="fieldcontain" data-controltype="textinput">
                 <label for="nome">
                     NOME:
                 </label>
                 <input name="nome" id="nome" placeholder="" value="" type="text">
             </div>
             <div data-role="fieldcontain" data-controltype="textinput">
                 <label for="email">
                     E-MAIL:
                 </label>
                 <input name="email" id="email" placeholder="" value="" type="email">
             </div>
 
             <div data-role="fieldcontain" data-controltype="textinput">
                 <label for="cpf">
                     CPF:
                 </label>
                 <input name="cpf" id="cpf" placeholder="" value="" type="tel">
             </div>
             <div data-role="fieldcontain" data-controltype="textinput">
                 <label for="fone">
                     TELEFONE:
                 </label>
                 <input name="fone" id="fone" placeholder="" value="" type="tel">
             </div>
             
          <a data-role="button" href="#" data-theme="a" data-inline="true" data-icon="arrow-r" data-iconpos="right" class="bt-right" id="btSign">
              PROSSEGUIR
          </a>
         </form>
     </div>
 </div>   