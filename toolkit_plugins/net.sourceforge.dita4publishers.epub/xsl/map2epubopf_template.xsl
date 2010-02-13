<!-- Convert a DITA map to an EPUB content.opf file. 

Notes:

If map/topicmeta element has author, publisher, and copyright elements,
they will be added to the epub file as Dublin Core metadata.

-->
<xsl:stylesheet version="2.0"
                xmlns:opf="http://www.idpf.org/2007/opf"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:include href="map2epubopfImpl.xsl"/>

  <dita:extension id="xsl.transtype-epub.opf" 
    behavior="org.dita.dost.platform.ImportXSLAction" 
    xmlns:dita="http://dita-ot.sourceforge.net"/>
</xsl:stylesheet>
