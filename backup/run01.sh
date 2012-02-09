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
echo "<link rel=\"stylesheet\" href=\"libraries/jqtouch.css\" type=\"text/css\"/>
<link rel=\"stylesheet\" href=\"libraries/fontface.css\" type=\"text/css\"/>
<script src=\"libraries/zepto.min.js\"></script>
<script src=\"libraries/jqtouch.min.js\"></script>
<script src=\"libraries/jqt_setup.js\"></script>

        <style type=\"text/css\">
			.gestureicon {
				float:left;
				width:120px;
				height:120px;
				border-radius:10px;
				box-shadow: inset 0px 1px 5px #000;
				background-color: rgba(60, 60, 60, 0.4);
				margin-bottom:10px;
				margin-right:10px;		
			}
			.gestureinfo {
				font: normal 12px "Helvetica Neue", Helvetica;
			}
			.about {
				padding-top:20px;
				padding-bottom:10px;
				padding-left:10px;
				padding-right:10px;
				text-align:center;
				font: normal 14px "Helvetica Neue", Helvetica;
				color:#fff;
				text-shadow: rgba(0, 0, 0, 0.8) 0 1px 0;
				
			}
			#iconic {
			  font-family: IconicStrokeRegular;
			  font-size:36px;
			  position:absolute;
			  bottom:10px;
			  right:10px;
			  z-index:1;
			  color: #000;
			  text-decoration: none;
			  text-shadow: rgba(0,0,0,0.1) -1px 0, rgba(0,0,0,0.1) 0 -1px,
             rgba(255,255,255,0.1) 1px 0, rgba(255,255,255,0.1) 0 1px,
             rgba(0,0,0,0.1) -1px -1px, rgba(255,255,255,0.1) 1px 1px; 
			}

			
			
        </style>" >> main.html
echo "</head>" >> main.html
echo "<body style=\"margin:0px;padding:0px;background-color:#000000;-webkit-user-select:none;\">" >> main.html

echo "<div id=\"jqt\">
                  <div id=\"about\" class=\"selectable\">
                                <div class=\"toolbar\">
                                    <h1>Informations</h1>
                                    <a class=\"back\" href=\"#\">Back</a>
                                </div>
                                <div class=\"scroll\">
                                    <div class=\"about\">
                                        <p>Add this page to your home screen to view the custom icon, startup screen, and full screen mode.</p>
                                    </div>
                                	<h2>Instrucitons</h2>
                                    <ul class=\"rounded\">
                                        <li class=\"arrow\">
                                        	<div class=\"gestureicon\"></div>
                                            <h4>User Interface</h4>
                                            <p class=\"gestureinfo\">Bla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi aBla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi a</p>
                                        </li>
                                        <li class=\"arrow\">
                                        	<div class=\"gestureicon\"></div>
                                            <h4>User Interface</h4>
                                            <p class=\"gestureinfo\">Bla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi a</p>
                                        </li>
                                        <li class=\"arrow\">
                                        	<div class=\"gestureicon\"></div>
                                            <h4>User Interface</h4>
                                            <p class=\"gestureinfo\">Bla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi a</p>
                                        </li>
                                        <li class=\"arrow\">
                                        	<div class=\"gestureicon\"></div>
                                            <h4>User Interface</h4>
                                            <p class=\"gestureinfo\">Bla lamlanlanponaoinoai oi oai oia oi aoi oai oi aoi oai oi a</p>
                                        </li>
                                    </ul>
                                    <h2>Thanks for:</h2>
                                    <ul class=\"rounded\">
                                        <li class=\"forward\"><a target=\"_blank\" href=\"http://www.jqtouch.com/\">JQTouch</a></li>
                                        <li class=\"forward\"><a target=\"_blank\" href=\"http://www.twitter.com/jqtouch\">iProcessing</a></li>
                                        <li class=\"forward\"><a target=\"_blank\" href=\"http://code.google.com/p/jqtouch/w/list\">Processing.org</a></li>
                                    </ul>
                                    <ul class=\"individual\">
                                        <li><a href=\"&#109;&#097;&#105;&#108;&#116;&#111;:&#100;&#107;&#064;&#109;&#111;&#114;&#102;&#117;&#110;&#107;&#046;&#099;&#111;&#109;\">Email</a></li>
                                        <li><a target=\"_blank\" href=\"http://tinyurl.com/support-jqt\">Support</a></li>
                                    </ul>
                                </div>
                  </div>
            
            
            
       
      
            
            <div id=\"home\" class=\"current\" style=\"background-color:#FFCC00\">
                
                <a class=\"slideup\" id=\"iconic\" href=\"#about\" >w</a>" >> main.html 

echo "          <canvas id=\"canvas\" data-processing-sources=\"$codeList\"></canvas>" >> main.html 
echo "      </div>
        </div>
    </body>" >> main.html
echo "</html>" >> main.html