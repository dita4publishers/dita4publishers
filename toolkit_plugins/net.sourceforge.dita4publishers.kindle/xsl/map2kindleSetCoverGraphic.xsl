<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"

  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:kindleutil="http://dita4publishers.org/functions/kindleutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:gmap="http://dita4publishers/namespaces/graphic-input-to-output-map"
  
  xmlns:local="urn:functions:local"
  
  xmlns="http://www.w3.org/1999/xhtml"
  
  exclude-result-prefixes="local xs df xsl relpath kindleutil index-terms gmap">

  <xsl:template match="*[df:class(., 'map/map')]" mode="additional-graphic-refs">
    <xsl:variable name="coverGraphicUri" select="local:getKindleCoverGraphicSourceUri(.)" as="xs:string"/>
    <gmap:graphic-ref href="{$coverGraphicUri}" filename="{relpath:getName($coverGraphicUri)}"/>
  </xsl:template>
     
  <xsl:template match="*[df:class(., 'map/map')]" mode="get-cover-graphic-path">
    <xsl:variable name="coverGraphicUri" select="local:getKindleCoverGraphicSourceUri(.)" as="xs:string"/>
    <xsl:sequence select="concat($imagesOutputDir, '/', relpath:getName($coverGraphicUri))"></xsl:sequence>
  </xsl:template>     
  
  <xsl:function name="local:getKindleCoverGraphicSourceUri" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <!-- FIXME: For now just using the placeholder graphic filename.
      
      In full implementation need to look in all the appropriate places.
    --> 
      <xsl:variable name="effectiveCoverGraphicUri" as="xs:string">
        <xsl:apply-templates select="$context" mode="get-cover-graphic-uri"/>
      </xsl:variable>
      
    <xsl:variable name="absoluteUrl" 
      select="
      if ($effectiveCoverGraphicUri != '')
         then $effectiveCoverGraphicUri
         else string(resolve-uri($placeholderCoverGraphicUri))" 
      as="xs:string"/>
    <xsl:sequence select="$absoluteUrl"/>
  </xsl:function>

</xsl:stylesheet>
