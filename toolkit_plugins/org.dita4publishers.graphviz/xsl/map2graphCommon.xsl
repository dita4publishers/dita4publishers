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
  
  <!-- =============================
    generate-nodes mode
    
    Generic code for constructing node
    declarations from elements (e.g., topicrefs,
    topics, etc.)
    
    Note that the general DOT organization approach
    is to generate all the node declarations and
    then to separately define the edges between nodes.

    ============================= -->
  
  
  <xsl:template mode="generate-nodes" match="*[df:isTopicHead(.)]">
    <xsl:variable name="label" select="df:getNavtitleForTopicref(.)" as="xs:string"/>    
    
    <xsl:message> + [INFO] generate-nodes: Topic head - <xsl:sequence select="$label"/></xsl:message>
    
    <xsl:sequence select="gv:makeNodeDecl(gv:getNodeId(.), $label, ('color', 'green'))"/>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="generate-nodes" match="*[df:isTopicRef(.)]">
    <xsl:variable name="label" select="df:getNavtitleForTopicref(.)" as="xs:string"/>    
    
    <xsl:message> + [INFO] generate-nodes: Topic ref - <xsl:sequence select="$label"/></xsl:message>
    
    <xsl:sequence select="gv:makeNodeDecl(gv:getNodeId(.), $label, ('color', 'blue'))"/>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
    
  <xsl:template mode="generate-nodes" match="*" priority="-1">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <!-- =============================
    generate-edges mode
    
    Generic code for constructing edges (node-to-node
    links) from elements (e.g., topicrefs,
    topics, etc.)
    
    Note that the general DOT organization approach
    is to generate all the node declarations and
    then to separately define the edges between nodes.
    
    ============================= -->
  
  <xsl:template mode="generate-edges" match="*[df:isTopicHead(.)] | *[df:isTopicRef(.)]" >
    <xsl:variable name="myNodeId" select="gv:getNodeId(.)"/>    
    
    <xsl:sequence select="$myNodeId"/>
    <xsl:text> -> {      
    </xsl:text>
    <xsl:apply-templates mode="link-one-level">
      <xsl:with-param name="start-node-id" as="xs:string" tunnel="yes" select="$myNodeId"/>
    </xsl:apply-templates>
    <xsl:text>
}      
    </xsl:text>
    
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template mode="link-one-level" match="*[df:isTopicHead(.)] | *[df:isTopicRef(.)]" >
    <xsl:param name="start-node-id" as="xs:string" tunnel="yes"/>
    <xsl:sequence select="gv:getNodeId(.)"/>
  </xsl:template>
    
  <xsl:template mode="link-one-level generate-edges generate-nodes" match="text()"/>
  
  <xsl:template mode="generate-edges link-one-level" match="*" priority="-1">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <!-- =============================
       Get map title mode
       
       Processes a map to construct
       the appropriate title string.
       
       ============================= -->
  <xsl:template name="generateMapTitle" mode="getMapTitle" match="/*[df:class(., 'map/map')]">
    <xsl:apply-templates select="if (not(*[df:class(., 'map/title')])) then (@title, *) else  (*)" mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="getMapTitle" match="@title">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/title')]" mode="getMapTitle">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="getMapTitle" match="*[df:class(., 'topic/title')]//*" priority="10">
    <!-- By default, just echo the tags out. -->
    <xsl:copy><xsl:apply-templates mode="#current"/></xsl:copy>
  </xsl:template>
  
  <xsl:template mode="getMapTitle" match="*" priority="-1">
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