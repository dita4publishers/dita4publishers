<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="urn:local-functions"
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:m="http://www.w3.org/1998/Math/MathML"
      
      exclude-result-prefixes="xs rsiwp stylemap local relpath xsi"
  version="2.0">
  <!-- =========================================
       Word to DITA Framework
       
       Copyright (c) 2014 DITA for Publishers
       
       Base implementation for the "map-url" mode,
       which constructs the result URLs for 
       generated maps.
       
       Override these templates to implement your
       own map filenaming conventions.
       ========================================= -->
  
  <xsl:template match="rsiwp:map" mode="map-url">   
    <!-- Constructs the relative part of the URL for the map,
         e.g., containing directory and map filename.
      -->
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    
    <xsl:variable name="treePosString" as="xs:string">
      <xsl:number count="rsiwp:map" format="1_"
        level="multiple"
      />
    </xsl:variable>

    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] rsiwp:map, mode=map-url: treePosString=<xsl:sequence select="$treePosString"/></xsl:message>
    </xsl:if>
    
    
    <xsl:variable name="submapName" as="xs:string" select="concat($fileNamePrefix, $submapNamePrefix, $treePosString)"/>
    
    <xsl:variable name="result" select="concat($submapName, '/', $submapName, '.ditamap')"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] rsiwp:map, mode="map-url": result=<xsl:value-of select="$result"/></xsl:message>
    </xsl:if>
    <xsl:sequence select="$result"/>
  </xsl:template>
  
  <xsl:template match="rsiwp:*" mode="map-url">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:message> - [WARNING] Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/> in mode 'map-url'</xsl:message>
    <xsl:variable name="mapTitleFragment">
      <xsl:choose>
        <xsl:when test="contains(.,' ')">
          <xsl:value-of select="replace(substring-before(.,' '),'[\p{P}\p{Z}\p{C}]','')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="replace(.,'[\p{P}\p{Z}\p{C}]','')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="concat('maps/map_', $mapTitleFragment, '_', generate-id(.), '.ditamap')"/>
  </xsl:template>
  

</xsl:stylesheet>