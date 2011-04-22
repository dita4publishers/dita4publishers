<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"  
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:enum="http://dita4publishers.org/enumerables"
  xmlns:glossdata="http://dita4publishers.org/glossdata"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs xd df relpath index-terms"
  version="2.0">
  
  <!-- =============================
       Get map title mode
       
       Processes a map to construct
       the appropriate title string.
       
       ============================= -->
  <xsl:template name="generateMapTitle" mode="getMapTitle" match="/*[df:class(., 'map/map')]">
    <xsl:apply-templates select="if (not(*[df:class(., 'map/title')])) then (@title, *) else  (*)" mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="getMapTitle" match="@title">
    <xsl:sequence select="string(.)"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/title')]" mode="getMapTitle">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="getMapTitle" match="*[df:class(., 'topic/title')]//*" priority="10">
    <!-- By default, just echo the tags out. -->
    <xsl:copy><xsl:apply-templates mode="#current"/></xsl:copy>
  </xsl:template>
  
  <xsl:template mode="getMapTitle" match="*" priority="0">
    <!-- Suppress elements that are not the map title or a descendant of the map title. -->
  </xsl:template>


  <xsl:function name="df:getMapTitle" as="node()*">
    <xsl:param name="map" as="element()"/>
    <!-- Gets the map title as a sequence of nodes appropriate for the
         use context, e.g. as a node or edge label.
      -->
    <xsl:variable name="result" as="node()*">
      <xsl:apply-templates select="$map" mode="getMapTitle"/>
    </xsl:variable>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  
  
</xsl:stylesheet>