<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"

  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:kindleutil="http://dita4publishers.org/functions/kindleutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:gmap="http://dita4publishers/namespaces/graphic-input-to-output-map"
  
  xmlns:local="urn:functions:local"
  
  xmlns="http://www.w3.org/1999/xhtml"
  
  exclude-result-prefixes="local xs df xsl relpath kindleutil index-terms gmap">

  <xsl:template match="*[df:class(., 'map/map')]" mode="additional-graphic-refs" priority="10">
    <xsl:param name="effectiveCoverGraphicUri" select="''" as="xs:string" tunnel="yes"/>
    <xsl:if test="$effectiveCoverGraphicUri != ''">
      <gmap:graphic-ref 
        id="{$coverImageId}"
        href="{$effectiveCoverGraphicUri}" 
        filename="{relpath:getName($effectiveCoverGraphicUri)}"/>
    </xsl:if>
  </xsl:template>
     
  <xsl:template match="/*[df:class(., 'map/map')]" mode="get-cover-graphic-uri">
    <!-- NOTE: override this template in order to implement different business logic
      for determining the cover graphic.
    -->
    <xsl:variable name="baseGraphicUri" as="xs:string">
      <xsl:choose>
        <xsl:when test="//*[df:class(., 'pubmap-d/epub-cover-graphic')]">
          <xsl:variable name="targetUri" as="xs:string"
            select="df:getEffectiveTopicUri((//*[df:class(., 'pubmap-d/epub-cover-graphic')])[1])"
          />
          <xsl:sequence select="$targetUri"/>
        </xsl:when>
        <xsl:when test="*[df:class(., 'map/topicmeta')]//*[df:class(., 'topic/data') and @name = 'covergraphic']">
          <xsl:variable name="elem" select="(*[df:class(., 'map/topicmeta')]//*[df:class(., 'topic/data') and @name = 'covergraphic'])[1]" as="element()"/>
          <xsl:choose>
            <xsl:when test="$elem/@value">
              <xsl:sequence select="string($elem/@value)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="string($elem)"/>
            </xsl:otherwise>
          </xsl:choose>          
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$coverGraphicUri"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    <xsl:variable name="docUri" select="relpath:toUrl(@xtrf)" as="xs:string"/>
    <xsl:variable name="finalUri" as="xs:string"
      select="
      if ($baseGraphicUri = '')
      then ''
      else relpath:newFile(relpath:getParent($docUri), $baseGraphicUri)
      " 
    />
    <xsl:sequence select="$finalUri"/>
  </xsl:template>  
  
</xsl:stylesheet>
