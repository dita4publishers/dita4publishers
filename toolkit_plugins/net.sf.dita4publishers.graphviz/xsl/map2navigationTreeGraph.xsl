<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"  
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:enum="http://dita4publishers.org/enumerables"
  xmlns:glossdata="http://dita4publishers.org/glossdata"
  xmlns:relpath="http://dita2indesign/functions/relpath"  
  xmlns:gv="http://dita4publishers.sf.net/functions/graphviz"
  exclude-result-prefixes="xs xd df relpath index-terms gv"
  version="2.0">
  
  <xsl:template match="/" mode="generate-navigation-tree-graph">
    
    <xsl:text>
/**
  * DITA map navigation tree graph. 
  **/
    </xsl:text>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="generate-navigation-tree-graph" match="*[df:class(., 'map/map')]">
    <xsl:variable name="mapTitle" as="node()*" select="df:getMapTitle(.)"/>

    <xsl:text> 
    digraph map_navigation_tree {</xsl:text>
    <xsl:sequence select="gv:makeProperty('label', ('Map navigation tree: ', $mapTitle))"/>
    <xsl:text>&#x0a;</xsl:text>
  
    node [shape="record"]
   
    
    <xsl:text>"rootmap" [</xsl:text>
    <xsl:sequence select="gv:makeProperty('label', $mapTitle)"/>
    <xsl:text>]</xsl:text>
    <xsl:apply-templates mode="#current"/>
    
    <xsl:text>
    "rootmap" [
    shape="circle", 
    color="blue"
    style="filled"
    fillcolor="yellow"
    ]
</xsl:text>    
    <xsl:text>
}</xsl:text>
  </xsl:template>
  
  <xsl:template mode="generate-navigation-tree-graph" match="text()">
    <!-- Suppress all text by default. -->
  </xsl:template>
</xsl:stylesheet>