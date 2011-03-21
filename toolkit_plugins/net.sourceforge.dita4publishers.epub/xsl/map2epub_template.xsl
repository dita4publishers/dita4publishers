<!-- Convert a DITA map to an EPUB data set. 

     The main style sheet, map2epubImpl.xsl, includes separate modules that
     handle generating the content.opf file, the toc.ncx file, and all the
     HTML content files, each in distinct modes.
          
     Extensions to this transform can override or extend any of those modes.

Notes:

If map/topicmeta element has author, publisher, and copyright elements,
they will be added to the epub file as Dublin Core metadata.

-->
<xsl:stylesheet version="2.0"
                xmlns:opf="http://www.idpf.org/2007/opf"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <dita:extension id="xsl.transtype-epub" 
    behavior="org.dita.dost.platform.ImportXSLAction" 
    xmlns:dita="http://dita-ot.sourceforge.net"/>

 <xsl:include href="map2epubImpl.xsl"/>

</xsl:stylesheet>
