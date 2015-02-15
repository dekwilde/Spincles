<!-- CURSOR -->

	<div id="delaycursor">
		<div id="circle"></div>
	</div>

	<!-- HANDS --> 
	<img src="img/handR.png" id="handR" /> 
	<img src="img/handL.png" id="handL" /> 

	<!-- CONTROL -->
	<div id="user_control">
		<div id="radar"></div>   
	    <div id="drawCan"><canvas id='depth' width='160' height='120'></canvas></div>    	
	    <div id="drawCan"><canvas id='labelMap' width='160' height='120'></canvas></div>
		<div id="drawCan"><canvas id='image' width='160' height='120'></canvas></div>    
	</div>   

	<!-- ZIGFU START -->
	<div id="pluginContainer">
	  <object id="ZigPlugin" type="application/x-zig" width="0" height="0">
	    <param name="onload" value="ZigPluginLoaded" />
	  </object>
	</div>   
  
<!-- ZIGFU END -->