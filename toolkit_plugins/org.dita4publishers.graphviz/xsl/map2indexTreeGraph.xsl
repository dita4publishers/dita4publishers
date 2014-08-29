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

  <xsl:template mode="generate-index-tree-graph" match="*[df:class(., 'map/map')]">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    
    <xsl:variable name="mapTitle" as="node()*" select="df:getMapTitle(.)"/>
    <xsl:variable name="rootNodeId" as="xs:string" select="gv:getNodeId(.)"/>
    
    <xsl:message> + [INFO] Generating index tree graph...</xsl:message>
    
    <xsl:text> 
    digraph map_index_tree {
    
    // Graph properties:
    </xsl:text>
    
    <!-- NOTE: In this context, each property is a separate statement, so no trailing
      comma 
    -->
    
    <xsl:text>rankdir=LR;</xsl:text>
    <xsl:text>ordering=out;</xsl:text><!-- Makes sure the nodes are in sorted order -->
    
    <xsl:text>label=</xsl:text><xsl:sequence select="gv:quoteString(string-join(('Map index tree: ', $mapTitle), ''))"/>
    <xsl:text>;&#x0a;</xsl:text>
    
    node [shape="record"]
    
    <xsl:sequence select="$rootNodeId"/>
    <xsl:text> [</xsl:text>
    <xsl:sequence select="gv:makeProperty('label', 'Index')"/>
    <xsl:text>]
    </xsl:text>
    
    <xsl:message> + [INFO] Generating graph node declarations for index...</xsl:message>
    
    <!-- Now process all the topicrefs to generate nodes -->
    <xsl:apply-templates mode="generate-nodes" 
      select="$collected-data/index-terms:index-terms/index-terms:grouped-and-sorted"/>
    
    <xsl:text>
// Start of index hierarchy:

    </xsl:text>
    
    <xsl:sequence select="$rootNodeId"/>
    <xsl:text> -> {      
</xsl:text>    
    
    <xsl:message> + [INFO] Generating graph edge (link) declarations...</xsl:message>
    
    <!-- Now process all the topicrefs to generate edges (links) -->
    <xsl:apply-templates mode="link-one-level" select="$collected-data/index-terms:index-terms/index-terms:grouped-and-sorted/index-terms:index-group">
      <xsl:with-param name="start-node-id" select="'rootmap'" tunnel="yes"/>
    </xsl:apply-templates>
    <xsl:text>
 }
</xsl:text>    
    
    <xsl:apply-templates mode="generate-edges" 
      select="$collected-data"/>
    
    <xsl:text>
// End of index hierarchy 
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
    
    <xsl:message> + [INFO] Index tree graph generated.</xsl:message>
    
    
  </xsl:template>
  
  <xsl:template match="index-terms:ungrouped" mode="generate-nodes generate-edges" priority="10">
    <xsl:message> + [INFO] Skipping index-terms:ungrouped</xsl:message>
  </xsl:template>
  
  <xsl:template match="index-terms:grouped-and-sorted" mode="generate-nodes" priority="10">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="index-terms:grouped-and-sorted" mode="generate-edges" priority="10">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="index-terms:index-group" mode="generate-nodes" priority="10">
    <xsl:sequence 
      select="gv:makeNodeDecl(
      string(index-terms:label), 
      string(index-terms:label), 
      ('color', 'red',
       'shape', 'record'))"></xsl:sequence>
    
    <xsl:apply-templates select="index-terms:sub-terms" mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="generate-nodes" match="index-terms:sub-terms" priority="10">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template mode="generate-nodes" match="index-terms:index-term" priority="10">
    <xsl:sequence 
      select="gv:makeNodeDecl(
      string(index-terms:label), 
      string(index-terms:label), 
      ('color', 'blue',
      'shape', 'ellipse'))"/>
    
    <xsl:apply-templates select="index-terms:sub-terms" mode="#current"/>    
  </xsl:template>


  <xsl:template mode="link-one-level" match="index-terms:index-group | index-terms:index-term">
    <xsl:sequence select="gv:quoteString(string(index-terms:label))"/>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

  <xsl:template mode="generate-edges" match="index-terms:index-group | index-terms:index-term">
    <xsl:variable name="myNodeId" select="string(index-terms:label)"/>    
    
    <xsl:sequence select="gv:quoteString($myNodeId)"/>
    <xsl:text> -> {      
    </xsl:text>
    <xsl:apply-templates mode="link-one-level" select="index-terms:sub-terms">
      <xsl:with-param name="start-node-id" as="xs:string" tunnel="yes" select="$myNodeId"/>
    </xsl:apply-templates>
    <xsl:text>
}      
    </xsl:text>
    
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="generate-index-tree-graph" match="text()"/>
</xsl:stylesheet>