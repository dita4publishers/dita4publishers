Unzip this so that the net.sourceforge.dita4publishers.html2 subdirectory 
is a child of the DITA-OT plugins or demo directory (e.g. C:\DITA-OT1.5\plugins\), and 
you should be ready to go. For example, after unzipping, issuing the following 
commands from your DITA directory to create ePub version of the indicated books, 
which are included with the DITA-OT distribution:

java -jar lib\dost.jar /i:doc\DITA-readme.ditamap /transtype:html2

java -jar lib\dost.jar /i:doc\userguide\DITA-userguide.ditamap /transtype:html2
