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
echo "<script src=\"libraries/iprocessing.js\"></script>" >> main.html
echo "<script src=\"libraries/iprocessing.lib\"></script>" >> main.html
echo "</head>" >> main.html
echo "<body style=\"margin:0px;padding:0px;background-color:transparent;-webkit-user-select:none;\">" >> main.html
echo "<canvas id=\"p5js\" style=\"background-color:transparent;\" datasrc=\"$codeList\"></canvas>" >> main.html
 
echo "</body>" >> main.html
echo "</html>" >> main.html