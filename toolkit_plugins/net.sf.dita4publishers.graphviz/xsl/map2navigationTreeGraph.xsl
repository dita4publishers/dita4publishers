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
    <xsl:variable name="rootNodeId" as="xs:string" select="gv:getNodeId(.)"/>

    <xsl:message> + [INFO] Generating navigation tree graph...</xsl:message>

    <xsl:text> 
    digraph map_navigation_tree {
    
    // Graph properties:
    </xsl:text>

    <!-- NOTE: In this context, each property is a separate statement, so no trailing
         comma 
    -->
    
    <xsl:text>rankdir=TB;</xsl:text>
    
    <xsl:text>label=</xsl:text><xsl:sequence select="gv:quoteString(string-join(('Map navigation tree: ', $mapTitle), ''))"/>
    <xsl:text>;&#x0a;</xsl:text>
  
    node [shape="record"]
   
    <xsl:sequence select="$rootNodeId"/>
    <xsl:text> [</xsl:text>
    <xsl:sequence select="gv:makeProperty('label', $mapTitle)"/>
    <xsl:text>]
    </xsl:text>
    
    <xsl:message> + [INFO] Generating graph node declarations...</xsl:message>

    <!-- Now process all the topicrefs to generate nodes -->
    <xsl:apply-templates mode="generate-nodes"/>

    <xsl:text>
// Start of navigation hierarchy:

    </xsl:text>

    <xsl:sequence select="$rootNodeId"/>
    <xsl:text> -> {      
</xsl:text>    

    <xsl:message> + [INFO] Generating graph edge (link) declarations...</xsl:message>
    
    <!-- Now process all the topicrefs to generate edges (links) -->
    <xsl:apply-templates mode="link-one-level">
      <xsl:with-param name="start-node-id" select="'rootmap'" tunnel="yes"/>
    </xsl:apply-templates>
<xsl:text>
 }
</xsl:text>    
    
    <xsl:apply-templates mode="generate-edges"/>
    
<xsl:text>
// End of navigation hierarchy 
</xsl:text>    

<!-- Set the properties for just the root node: -->
    
    <xsl:sequence select="$rootNodeId"/>
    <xsl:text> [
    </xsl:text>
    <xsl:sequence select="gv:makeProperties(
      ('shape', 'record', 
       'color', 'blue',
       'style', 'filled',
       'fillcolor', 'yellow'))"/>
    <xsl:text> ]
    </xsl:text>

    <xsl:text>
}</xsl:text>
    
    <xsl:message> + [INFO] Navigation tree graph generated.</xsl:message>
    
    
  </xsl:template>
  
  <xsl:template mode="generate-navigation-tree-graph" 
    match="text()">
    <!-- Suppress all text by default. -->
  </xsl:template>
</xsl:stylesheet>