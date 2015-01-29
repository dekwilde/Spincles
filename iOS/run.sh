#!/bin/sh

IFS="$(echo -e "\n\r")"
projectPath=`dirname $0`
codePath=$projectPath/Resources/main
dataPath=$codePath/data

cd $codePath

codeList="main.pde"
for file in *.pde
do
	 if [ $file != "main.pde" ] ; then
		codeList="$codeList"" ""$file"
	 fi
done

echo "<html>
<head>
<script src=\"libraries/iprocessing.1.4.8.js\"></script>
<script src=\"libraries/iprocessing.lib.js\"></script>
<meta name=\"viewport\" content=\"width=device-width, height=device-height, initial-scale=1.0, user-scalable=no\">
</head>
<body style=\"
margin:0;
padding:0;
background-color:transparent;
-webkit-user-select:none; 
mix-blend-mode: overlay;
background-image: url(data/glitch.gif); 
background-size: 100% 100%; 
background-repeat: no-repeat;\">" > main.html    


echo "<canvas id=\"pde\" style=\"
float:left; 
min-width:320px; 
min-height:480px; 
width:100%; 
height:100%; 
margin:0;
padding:0; 
background-color:transparent; 
mix-blend-mode: screen;\" 
data-processing-sources=\"$codeList\"></canvas>" >> main.html
echo "</body>
</html>" >> main.html