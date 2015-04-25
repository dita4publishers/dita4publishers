<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="RSUITE df xs"
  >
  
  <!-- ===============================================================
       Default DITA HTML preview style sheet for use with RSuite CMS.
       
       Provides good-enough HTML preview of DITA maps and topics. Handles
       topicref resolution, does not currently handle conref resolution.
       
       This style sheet is normally packaged as an RSuite plugin from 
       which it is used by shell transforms that override or extend
       this one in the style of the DITA Open Toolkit.
    
       =============================================================== -->
  
  <xsl:import href="lib/dita-support-lib.xsl"/>
  <xsl:import href="lib/relpath_util.xsl"/>
  <xsl:import href="lib/resolve-map.xsl"/>
  <xsl:import href="dita-topicPreview.xsl"/>
  <xsl:import href="dita-tocModePreview.xsl"/>
  <xsl:import href="dita-hi-dPreview.xsl"/>
  <xsl:import href="dita-learning-dPreview.xsl"/>
  <xsl:import href="dita-sw-dPreview.xsl"/>
  <xsl:import href="dita-pr-dPreview.xsl"/>
  <xsl:import href="dita-ui-dPreview.xsl"/>
  <xsl:import href="dita-xml-dPreview.xsl"/>
  <xsl:import href="dita-pubmap-dPreview.xsl"/>
  <xsl:import href="dita-rsuiteMetadataPreview.xsl"/>
  <xsl:import href="dita-mathPreview.xsl"/>
  <xsl:import href="dita-d4p_formatting-dPreview.xsl"/>
  
  <xsl:param name="debug" select="'false'"/>
  <xsl:variable name="debugBoolean" select="if ($debug = 'true') then true() else false()" as="xs:boolean"/>
  
  <!-- NOTE: This is an override the function from the D4P dita-support-lib.xsl.
       It adds support for adding the RSuite-specific skey query parameter. 
  -->
  <xsl:function name="df:getEffectiveTopicUri">
    <xsl:param name="rootmap" as="element()"/>
    <xsl:param name="context" as="element()"/>
    
    <xsl:variable name="effectiveUri" as="xs:string"
      select="if ($context/@keyref != '')
      then df:getEffectiveUriForKeyref($rootmap, $context)
      else string($context/@href)
      "
    />
    <xsl:variable name="baseUri" as="xs:string"
       select="
    if (contains($effectiveUri, '#')) 
        then substring-before($effectiveUri, '#') 
        else normalize-space($effectiveUri)
    "/>    
    <xsl:variable name="result" as="xs:string">
      <xsl:choose>
        <xsl:when test="string($context/@copy-to) != ''">
          <xsl:variable name="copyTo" select="$context/@copy-to" as="xs:string"/>
          <xsl:variable name="fullUri" select="string(resolve-uri($copyTo, base-uri($context)))" as="xs:string"/>
          <xsl:sequence select="relpath:getRelativePath(relpath:getParent(base-uri($context)), $fullUri)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$baseUri"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:variable>
    <xsl:variable name="rsuiteSchemaParams" as="xs:string"
      select="'includeSchema=true&amp;schemaShouldResolve=false'"
    />
    <xsl:variable name="authenticatedResult" as="xs:string"
      select="if ($rsuite.sessionkey != '') 
                 then concat($result, '?', 'skey=', $rsuite.sessionkey)
                 else $result"
    />
    <xsl:sequence select="$authenticatedResult"/>
  </xsl:function>

  

</xsl:stylesheet>
