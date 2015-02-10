<div data-role="page" data-control-title="Escolha Foto" data-theme="a" id="crop" style="text-align:center">
    <div data-role="content" style="padding: 0px">
        <div id="renderinput">
			<h1 class="title-box">POSICIONE A FOTO</h1>
			<div class="menucrop">
				<a data-role="button" href="#input_foto" 	data-theme="a" data-inline="true"  	data-icon="arrow-l" data-iconpos="left" 	data-transition="flow" data-direction="reverse">REFAZER</a>
				<a data-role="button" href="#" 				data-theme="a" data-inline="true" 	data-icon="arrow-r" data-iconpos="right" 	id="btinputnext" >CONTINUAR</a>
			</div> 
			
			
			
			
			<div id="menusliderImage" class="ui-grid-a ui-responsive">
				<div class="ui-block-a">
			        <div data-role="fieldcontain" data-controltype="slider">
			            <label for="brilho">
			                Brilho
			            </label>
			            <input id="brilho" type="range" name="brilho" value="50" min="0" max="100"
			            data-highlight="false" data-theme="c" data-track-theme="c" data-mini="false">
			        </div> 
				</div>
				<div class="ui-block-b">
			        <div data-role="fieldcontain" data-controltype="slider">
			            <label for="contraste">
			                Contraste
			            </label>
			            <input id="contraste" type="range" name="contraste" value="0" min="0"
			            max="100" data-highlight="false" data-theme="c" data-track-theme="c" data-mini="false">
			        </div>
				</div>
			</div>
			
			

			
			<div class="drag-box">
				<div class="resize"></div>
				<div class="rotate"></div>
			</div>
			<img src="img/mask.png" class="mask-box">
			<img src="img/crop-mask.png" class="crop-mask">
			<canvas width="640" height="480" class="photo-box" id="photobox" data-caman-id="0"></canvas>
			<div id="renderblank"></div>
		</div>
    </div>
</div>