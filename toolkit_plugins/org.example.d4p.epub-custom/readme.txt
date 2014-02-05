This is an example plugin that shows how you can extend the D4P epub plugin with your 
own customization and call that plugin through a custom transtype. It also provides
comments explaining various parts, which may be helpful to a new DITA-OT developer.

Customizing through a plugin with a custom transtype has the added benefit of allowing
more convenient multiple customizations (e.g., you may want to generate different structural
epubs depending on your content).

Unzip this so that the org.example.d4p.epub-custom subdirectory 
is a child of the DITA-OT plugins directory (e.g. C:\DITA-OT\plugins\), and 
you should be ready to go. To get maximal value from this you'll want to update the
"epub-custom" references throughout the enclosed files so that they reflect your custom
transtype (along with renaming the subdirectory to something that identifies it as yours
- the name should be a Java-style reverse Internet domain name). 

Because there is a _template.xml file you need to run the Integrator.

For example, after unzipping, issuing the following 
commands from your DITA directory to create ePub version of the indicated books, 
which are included with the DITA-OT distribution:

java -jar lib\dost.jar /i:doc\DITA-readme.ditamap /transtype:epub-custom

java -jar lib\dost.jar /i:doc\userguide\DITA-userguide.ditamap /transtype:epub-custom
