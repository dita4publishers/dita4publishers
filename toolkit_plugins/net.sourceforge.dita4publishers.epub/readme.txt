Unzip this so that the epub subdirectory is a child of the DITA-OT demo directory (e.g. C:\DITA-OT1.4.3\demo\epub), and you should be ready to go. For example, after unzipping, issuing the following commands from your DITA directory to create epub version of the indicated books, which are included with the DITA-OT distribution:

java -jar lib\dost.jar /i:doc\DITA-readme.ditamap /transtype:epub

java -jar lib\dost.jar /i:doc\userguide\DITA-userguide.ditamap /transtype:epub
