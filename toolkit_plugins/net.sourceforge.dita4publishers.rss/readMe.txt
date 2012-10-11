Unzip this so that the net.sourceforge.dita4publishers.rss subdirectory 
is a child of the DITA-OT plugins or demo directory (e.g. C:\DITA-OT1.5\plugins\), and 
you should be ready to go. For example, after unzipping, issuing the following 
commands from your DITA directory to create ePub version of the indicated books, 
which are included with the DITA-OT distribution:

In order to use this plugin, you have to provide the domain property from which the rss will be served. This is a minimal requirement.

You might create a customization plugin and add the following properties

property="rss.link" value="http://www.example.com/"
property="rss.doc.dir" value="my/dir/"

Do not forgot to add the trailing slash !

<antcall target="dita2rss">
	<param name="rss.link" value="http://www.example.com/"></param>
	<param name="rss.doc.dir" value="my/dir/"></param>
</antcall>


java -jar lib/dost.jar /i:do/DITA-readme.ditamap /transtype:rss

java -jar lib/dost.jar /i:doc/userguide/DITA-userguide.ditamap /transtype:rss
