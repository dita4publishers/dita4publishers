<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:local="http://www.example.com/functions/local"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="local xs df"
  >
  
  <!--  ====================================================
  
        Given an initial map or topic, constructs a single
        map instance with all map references resolved. If
        the initial element is a topic, synthesizes a map
        with a single topicref to that topic.
        
        Annotates the topic refs with information that 
        describes their hierarchical structure:
        
        @headLevel: The effective heading level, where 1 is
        the highest heading (e.g., chapter title), 2 
        is next highest (e.g., section), etc.
        
        @isSidebar: If 'true", the reference topic is
        to be treated as an out-of-line sidebar that
        should be presented as a float or pop-up window.
         
        Implements mode "resolve-map"
        
        Copyright (c) 2009 DITA For Publishers
        
        Developed by Really Strategies, Inc.
        www.reallysi.com
        ==================================================== -->
 
  <xsl:import href="dita-support-lib.xsl"/>
  
  <xsl:template match="/*[df:class(., 'map/map')]" mode="resolve-map">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="resolve-map" match="@*">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template mode="resolve-map" match="*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="*[(df:isTopicHead(.))]" mode="resolve-map">
    <xsl:param name="parentHeadLevel" as="xs:integer" tunnel="yes"/>
    // If topichead is processing-role is resource only then set
    // head level to -1 to indicate we're not in the main hierarchy.
    <xsl:variable name="myHeadLevel" 
      select="
      if (not(@processing-role = 'resource-only'))
          then $parentHeadLevel + 1
          else -1
      "
      />
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:if test="$myHeadLevel != $parentHeadLevel">
        <xsl:attribute name="headLevel" select="$myHeadLevel"/>
      </xsl:if>
      <xsl:apply-templates select="node()" mode="#current">
        <xsl:with-param name="parentHeadLevel" select="$myHeadLevel" tunnel="yes" as="xs:integer"/>
      </xsl:apply-templates>
    </xsl:copy>    
  </xsl:template>
  
  <xsl:template match="*[ df:isTopicGroup(.)]" mode="resolve-map">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:copy>    
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.)]" mode="resolve-map">
    <xsl:param name="parentHeadLevel" as="xs:integer" tunnel="yes"/>
    <xsl:variable name="refTarget" select="df:resolveTopicRef(.)" as="element()?"/>
    <!-- FIXME: This is kind of weak. Need a way to involve referenced topic in determination
                 of head level. This approach assumes that any non-resource-only topicref
                 contributes to the hierarchy.
                 
                 Not sure how to use modes to let referenced topics contribute to the head level
                 calculation.
                 
                 For specialized topicrefs, template overrides can handle that case, e.g.,
                 sidebars.
      -->
    <xsl:variable name="myHeadLevel" 
      select="$parentHeadLevel + 1"
      >
    </xsl:variable>
      <xsl:choose>
        <xsl:when test="@type = 'ditamap'">
          <!-- Reference to subordinate map -->
          <!-- FIXME: Implement metadata and attribute propogation from
               map to map per 1.2 spec.
          -->
          <xsl:if test="not(df:class($refTarget, 'map/map'))">
            <xsl:message> + [WARNING] Topicref with format='ditamap' did not resolve to a map, got <xsl:sequence select="name($refTarget)"/> (class=<xsl:sequence select="$refTarget/@class"/>)</xsl:message>
            <xsl:copy>
              <xsl:apply-templates select="@* | node()">
                <xsl:with-param name="parentHeadLevel" select="$myHeadLevel"/>
              </xsl:apply-templates>
            </xsl:copy>
          </xsl:if>
          <!-- Process the direct-child topicrefs and reltables in the referenced map -->
          <xsl:apply-templates select="$refTarget/*[df:class(., 'map/topicref') or *[df:class(., 'map/reltable')]]"
            mode="#current">
            <xsl:with-param name="parentHeadLevel" select="$myHeadLevel" tunnel="yes" as="xs:integer"/>            
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:if test="$myHeadLevel != $parentHeadLevel">
              <xsl:attribute name="headLevel" select="$myHeadLevel"/>
            </xsl:if>
            <xsl:apply-templates select="node()" mode="#current">
              <xsl:with-param name="parentHeadLevel" select="$myHeadLevel" tunnel="yes" as="xs:integer"/>
            </xsl:apply-templates>
          </xsl:copy>    
        </xsl:otherwise>
      </xsl:choose>      
  </xsl:template>
  
</xsl:stylesheet>
