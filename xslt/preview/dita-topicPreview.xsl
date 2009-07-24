<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
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
  
  <xsl:import href="../lib/dita-support-lib.xsl"/>
  <xsl:import href="../lib/resolve-map.xsl"/>
  
  <xsl:param name="debug" select="'false'"/>
  <xsl:variable name="debugBoolean" select="if ($debug = 'true') then true() else false()" as="xs:boolean"/>
  
  <xsl:template match="/*" mode="head">
    <LINK REL="stylesheet" TYPE="text/css" 
      HREF="/rsuite/rest/v1/content/alias/dita-preview.css?skey={$rsuite.sessionkey}"/>    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]">
    <xsl:param name="topicref" as="element()?" tunnel="no"/>
    <xsl:param name="subtopicContent" as="node()*" tunnel="yes"/>
    <xsl:message> + [DEBUG] dita-topicPreview: **** in base topic/topic template: subtopicContent=<xsl:sequence select="name($subtopicContent[1])"/></xsl:message>
    <!-- FIXME: Use the topicref to determine our topic nesting -->
    <div class="{df:getHtmlClass(.)}">
      <a id="{@id}" name="{@id}"/>
      <xsl:apply-templates/>
      <xsl:apply-templates select="$topicref/*">
        <xsl:with-param name="subtopicContent" select="()" tunnel="yes" as="node()*"/>
      </xsl:apply-templates>
      <xsl:sequence select="$subtopicContent"/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/keyword')]">
    <span class="{df:getHtmlClass(.)}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/ph')]">
    <span class="{df:getHtmlClass(.)}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/cite')]">
    <i class="{df:getHtmlClass(.)}"><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/body')]">
    <div class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/bodydiv')]">
    <div class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/fig')]">
    <div class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/desc')]">
    <p class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]/*[df:class(., 'topic/title')]">
    <h2><xsl:apply-templates/></h2>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/sectiondiv')]">
    <div class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/section')]/*[df:class(., 'topic/title')]
    ">
    <h3><xsl:apply-templates/></h3>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/section')]">
    <div class="{df:getHtmlClass(.)}">
      <xsl:if test="@spectitle">
        <h3><xsl:sequence select="string(@spectitle)"/></h3>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/ul')]">
    <ul class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
    
  <xsl:template match="*[df:class(., 'topic/ol')]">
    <ol class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </ol>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/li')]">
    <li class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/p')]">
    <p class="{df:getHtmlClass(.)}"><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/lines')]">
    <p class="{df:getHtmlClass(.)}" style="white-space: pre;"><xsl:apply-templates/></p>
  </xsl:template>
 
  <xsl:template match="*[df:class(., 'topic/lq')]">
    <blockquote class="{df:getHtmlClass(.)}"><xsl:apply-templates/></blockquote>
  </xsl:template>
  
  <xsl:template match="/*[df:class(., 'map/map')]/*[df:class(., 'topic/title')]">
    <h1>
      <xsl:apply-templates/>
    </h1>      
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/note')]">
    <p class="{df:getHtmlClass(.)}"><b>
      <xsl:sequence select="if (@type = 'other') then string(@othertype) else string(@type)"/>: </b>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <!-- ============================================
       Metadata elements
       ============================================ --> 
  
  <xsl:template match="*[df:class(., 'map/topicmeta')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/shortdesc')] | *[df:class(., 'topic/shortdesc')]">
    <p class="map_shortdesc"><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/abstract')]">
    <div class="{df:getHtmlClass(.)}">
     <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/author')]">
    <p class="map_author"><b>Author: </b><xsl:apply-templates/></p>
  </xsl:template>
  
  
  <!-- ============================================
    Multimedia elements
    ============================================ --> 
  
  <xsl:template match="*[df:class(., 'topic/image')]">
    <img src="{@href}" class="{df:getHtmlClass(.)}">
      <xsl:attribute name="alt">
        <xsl:apply-templates mode="text-only"/>
      </xsl:attribute>
    </img>
  </xsl:template>  
  
  <xsl:template match="*[df:class(., 'topic/xref')]">
    <xsl:variable name="targetUri" as="xs:string?"
       select="@href"
    />
    <a href="{$targetUri}">
      <xsl:choose>
        <xsl:when test="@scope = 'external'">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="normalize-space(.) != ''">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <!-- FIXME: Implement target resolution and link text generation -->
              <span class="{df:getHtmlClass(.)}">[Xref to target URI "<xsl:sequence select="$targetUri"/>]</span>
            </xsl:otherwise>
          </xsl:choose>
          
        </xsl:otherwise>
      </xsl:choose>
    </a>
    
  </xsl:template>  
  
  <xsl:template mode="text-only" match="*">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/table')]">
    <table class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </table>
  </xsl:template> 
  
  <xsl:template match="*[df:class(., 'topic/table')]/*[df:class(., 'topic/title')]">
    <p class="{df:getHtmlClass(.)}">
      <xsl:text>Table </xsl:text><xsl:number 
        count="*[df:class(., 'topic/table')]"
        level="any"
        format="1."
      /><xsl:text> </xsl:text><xsl:apply-templates/>
    </p>
  </xsl:template> 
  
  <xsl:template match="*[df:class(., 'topic/tgroup')]">
    <xsl:apply-templates select="*[df:class(., 'topic/colspec')]"/>
    <xsl:apply-templates select="*[df:class(., 'topic/thead')]"/>
    <xsl:apply-templates select="*[df:class(., 'topic/tbody')]"/>
  </xsl:template> 
  
  <xsl:template match="*[df:class(., 'topic/colspec')]">
    <!-- FIXME: Implement colspec mapping -->
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/thead')]">
    <thead class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </thead>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/tbody')]">
    <tbody class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </tbody>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/row')]">
    <tr class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/thead')]/*[df:class(., 'topic/entry')]">
    <th class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </th>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/entry')]">
    <td class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/simpletable')]">
    <table class="{df:getHtmlClass(.)}">
      <tbody>
        <xsl:apply-templates/>
      </tbody>      
    </table>
  </xsl:template> 
  
  <xsl:template match="*[df:class(., 'topic/strow')]">
    <tr class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/stentry')]">
    <td class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <!-- ============================================
       Map elements
       
       Because we resolve the map before processing,
       there should normally only be one map
       element to be processed.
       ============================================ --> 
  
  <xsl:template match="*[df:class(., 'map/map')]">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Suppress in default mode -->
  <xsl:template 
    match="
    *[df:class(., 'topic/navtitle')] |
    *[df:class(., 'topic/titlealts')] |
    *[df:class(., 'topic/prolog')]
    "/>
  
  <xsl:template match="*[df:isTopicGroup(.)]">
    <xsl:if test="$debugBoolean or true()">
      <xsl:message> + [DEBUG] dita-topicPreview: Handling topic group <xsl:sequence select="name(.)"/></xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicHead(.)]">
    <xsl:if test="$debugBoolean or true()">
      <xsl:message> + [DEBUG] dita-topicPreview: Handling topichead <xsl:sequence select="name(.)"/></xsl:message>
    </xsl:if>
    <div class="{df:getHtmlClass(.)}">
      <xsl:element name="h{@headLevel}">
        <xsl:sequence select="df:getNavtitleForTopicref(.)"/>
      </xsl:element>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.) and @format = 'ditamap']">
    <!-- NOTE: This would only happen for peer and external scope maps -->
    <xsl:if test="true()">
      <xsl:message> + [DEBUG] dita-topicPreview: Handling topicref to map: <xsl:sequence select="string(@href)"/></xsl:message>
    </xsl:if>
    <xsl:variable name="target"
      select="df:resolveTopicRef(.)"
    />
    <xsl:apply-templates select="$target/*[df:class(., 'map/topicref')]">
      <xsl:with-param name="topicref" select="." as="element()" tunnel="no"/>      
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.) and not(@format = 'ditamap')]">
    <xsl:if test="true()">
      <xsl:message> + [DEBUG] dita-topicPreview: Handling topicref to non-map resource: <xsl:sequence select="df:reportTopicref(.)"/></xsl:message>
    </xsl:if>
    <xsl:variable name="target" as="element()?"
       select="df:resolveTopicRef(.)"
    />
    <xsl:if test="true()">
      <xsl:message> + [DEBUG] dita-topicPreview:   target element=<xsl:sequence select="name($target)"/>[class=<xsl:sequence select="string($target/@class)"/>]</xsl:message>
    </xsl:if>
    
    <xsl:if test="true()">
      <xsl:message> + [DEBUG] dita-topicPreview:  constructing subtopicContent by applying templates to <xsl:sequence select="./*"/> </xsl:message>
    </xsl:if>
    <xsl:variable name="subtopicContent" as="node()*">
      <xsl:apply-templates/>      
    </xsl:variable>
    
    <!-- NOTE: subordinate topicrefs are handled in the template for the referenced topic. -->
    <xsl:apply-templates select="$target">
      <xsl:with-param name="topicref" select="." as="element()" tunnel="no"/>
      <xsl:with-param name="subtopicContent" as="node()*" select="$subtopicContent" tunnel="yes"/>      
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref')]" priority="-0.5">
    <xsl:message> + [ERROR] dita-topicPreview:  unhandled topicref: <xsl:sequence select="df:reportTopicref(.)"/></xsl:message>
  </xsl:template>
  
  <!-- ===========================
       Catch-all templates
       =========================== -->
    
  <xsl:template match="RSUITE:*"/><!-- Suppress RSUITE elements by default -->
  
  <xsl:template match="*" mode="head" priority="-1"/><!-- Suppress by default in head mode -->
  
  <xsl:template mode="text-only" match="*">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*" mode="#default" priority="-1">    
    <div style="margin-left: 1em;">
      <span style="color: green;">[<xsl:value-of select="@class"/>{</span><xsl:apply-templates/><span style="color: green;">}]</span>
    </div>
  </xsl:template>
  
   
</xsl:stylesheet>
