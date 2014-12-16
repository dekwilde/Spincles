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

echo "<html>" > main.html
echo "<head>" >> main.html
echo "<script src=\"libraries/iprocessing.1.4.8.js\"></script>" >> main.html
echo "<script src=\"libraries/iprocessing.lib.js\"></script>" >> main.html

echo "<meta name=\"viewport\" content=\"width=device-width, height=device-height, initial-scale=1.0, user-scalable=no\">" >> main.html
echo "</head>" >> main.html
echo "<body style=\"margin:0;padding:0;background-color:transparent;-webkit-user-select:none;\">" >> main.html
echo "<canvas id=\"pde\" style=\"position:absolute; top:0; left:0; width:100%; height:100%; background-color:transparent;\" data-processing-sources=\"$codeList\"></canvas>" >> main.html
 
echo "</body>" >> main.html
echo "</html>" >> main.html