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
  
  <xsl:param name="debug" select="'false'"/>
  <xsl:variable name="debugBoolean" select="if ($debug = 'true') then true() else false()" as="xs:boolean"/>
  

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:apply-templates select="*/*[df:class(., 'topic/title')]" mode="head"/></title>
        <LINK REL="stylesheet" TYPE="text/css" 
          HREF="/rsuite/rest/v1/content/alias/dita-preview.css?skey={$rsuite.sessionkey}"/>
        
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]">
    <xsl:param name="topicref" as="element()?" tunnel="no"/>
    <!-- FIXME: Use the topicref to determine our topic nesting -->
    <div class="{df:getHtmlClass(.)}">
      <a id="{@id}" name="{@id}"/>
      <xsl:apply-templates/>
      <xsl:apply-templates select="$topicref/*"/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/keyword')]">
    <span class="{df:getHtmlClass(.)}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/ph')]">
    <span class="{df:getHtmlClass(.)}"><xsl:apply-templates/></span>
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
  
  <xsl:template match="/*[df:class(., 'map/map')]/*[df:class(., 'topic/title')]">
    <h1>
      <xsl:apply-templates/>
    </h1>      
  </xsl:template>
  
  <xsl:template match="title" mode="head">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template 
    match="
       *[df:class(., 'hi-d/i')] | 
       *[df:class(., 'hi-d/b')] | 
       *[df:class(., 'hi-d/u')]
      ">
    <xsl:element name="{name(.)}"><xsl:apply-templates/></xsl:element>
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
  
  <xsl:template match="*[df:class(., 'eduneeringMetadataDomain-d/eduneeringMeta')]">
    
    <table class="map_topicmeta" border="1"
      >
      <thead>
        <tr>
          <th colspan="2"><b>Course Metadata</b></th>
        </tr>
      </thead>
      
      <tbody>
        <xsl:apply-templates/>      
      </tbody>
      
    </table>    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'eduneeringMetadataDomain-d/eduneeringMeta')]/*[df:class(., 'topic/data')]">
    <tr>
      <td><xsl:sequence select="if (@name) then string(@name) else name(.)"/></td>
      <td>
        <xsl:choose>
          <xsl:when test="@value">
            <xsl:sequence select="string(@value)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>            
          </xsl:otherwise>
        </xsl:choose>
        
      </td>
    </tr>
  </xsl:template>
  
  <!-- ============================================
    Multimedia elements
    ============================================ --> 
  
  <xsl:template match="*[df:class(., 'eduneeringBase/animation')]">
    <table width="100%">
      <thead>
        <tr>
          <td>Animation</td>
          <td>Narration</td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <xsl:apply-templates/>
        </tr>
      </tbody>      
    </table>
  </xsl:template>  
  
  <xsl:template match="*[df:class(., 'eduneeringBase/animation')]/*[df:class(., 'topic/sectiondiv')]" priority="10">
    <td valign="top">
      <div class="{df:getHtmlClass(.)}">
        <xsl:apply-templates/>
      </div>
    </td>
  </xsl:template>  
  
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
  
  
  
  <!-- ============================================
    Assessment elements
    ============================================ --> 
  
  
  <xsl:template match="*[df:class(., 'learningBase/lcInteraction')]" priority="10">
    <!-- Format entire interaction as a table -->
    <table class="lcInteraction">
      <col width="2em"/>
      <col width="3em"/>
      <tbody>
        <xsl:apply-templates/>
      </tbody>
    </table>
  </xsl:template>
  
  <xsl:template match="x/*[df:class(., 'learning-d/learning-d/lcMultipleSelect')]" priority="10">
    <tr class="multiselect">
      <td rowspan="{count(child::*)}" valign="top" class="question_number">
        <xsl:number count="*[df:class(., 'topic/fig')]"
          from="*[df:class(., 'learningBase/lcInteraction')]"
          level="single"
          format="1."
        /></td>
    </tr>
    <xsl:apply-templates/>
  </xsl:template>  
  
  <xsl:template match="x/*[df:class(., 'learning-d/lcMultipleSelect')]/*[df:class(., 'learning-d/lcAnswerOptionGroup')]" priority="10">
    <xsl:apply-templates/>        
  </xsl:template>
  
  <xsl:template match="x/*[df:class(., 'learning-d/lcMultipleSelect')]/*[df:class(., 'learning-d/lcAnswerOptionGroup')]/*[df:class(., 'learning-d/lcAnswerOption')]" priority="10">
    <tr>
      <td class="multiselect_dingbat">
        <xsl:number count="*[df:class(., 'learning-d/lcAnswerOption')]"
          from="*[df:class(., 'learning-d/lcAnswerOptionGroup')]"
          level="single"
          format="1"
        />
      </td>
      <td class="{if (*[df:class(., 'learning-d/lcCorrectResponse')]) then 'correct_resp' else 'incorrect_resp'}"><xsl:apply-templates/></td>
    </tr>
  </xsl:template>
  
  
  <xsl:template match="*[df:class(., 'learning-d/lcTrueFalse')]" priority="10">
    <tr class="truefalse">
      <td rowspan="{count(child::*)}" valign="top" class="question_number">
        <xsl:number count="*[df:class(., 'topic/fig')]"
          from="*[df:class(., 'learningBase/lcInteraction')]"
          level="single"
          format="1."
        /></td>
      <xsl:apply-templates/>
    </tr>    
    <tr>
      <td colspan="3" style="background-color: white;">&#xa0;</td>
    </tr>  
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'learning-d/lcTrueFalse')]/*[df:class(., 'learning-d/lcQuestion')]" priority="10">
    <tr class="question">
      <td colspan="2">TRUE OR FALSE: <xsl:apply-templates/></td></tr>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'learning-d/lcTrueFalse')]/*[df:class(., 'learning-d/lcAnswerOptionGroup')]" priority="10">
    <xsl:apply-templates/>        
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'learning-d/lcTrueFalse')]/*[df:class(., 'learning-d/lcAnswerOptionGroup')]/*[df:class(., 'learning-d/lcAnswerOption')]" priority="10">
     <tr>
       <!-- FIXME: Replace the text with graphics -->
       <td class="t_f_button"><xsl:sequence select="if (preceding-sibling::*[df:class(., 'learning-d/lcAnswerOption')]) then 'F' else 'T'"/></td>
       <td class="{if (*[df:class(., 'learning-d/lcCorrectResponse')]) then 'correct_resp' else 'incorrect_resp'}"><xsl:apply-templates/></td>
     </tr>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'learning-d/lcCorrectResponse')]" priority="10"> 
    <!-- Suppress in default mode -->
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'learning-d/lcFeedbackIncorrect')]" priority="10">
    <tr>
      <td colspan="2" class="lcFeedbackIncorrect"><xsl:apply-templates/></td>
    </tr>
  </xsl:template>
  <xsl:template match="*[df:class(., 'learning-d/lcFeedbackCorrect')]" priority="10">
    <tr>
      <td colspan="2" class="lcFeedbackCorrect"><xsl:apply-templates/></td>
    </tr>
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
  
  <xsl:template match="*[df:class(., 'mapgroup-d/topicgroup')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'mapgroup-d/topichead')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="*[df:class(., 'learningmap-d/learningObject')]" priority="5">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref') and @href = '' and not(@navtitle) and 
    not(*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/navtitle')])]">
    <xsl:if test="true()">
      <xsl:message> + [DEBUG] Handling topichead: <xsl:sequence select="df:reportTopicref(.)"/></xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'mapgroup-d/topichead')and not(@navtitle) and 
    not(*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/navtitle')])]">
    <xsl:if test="true()">
      <xsl:message> + [DEBUG] Handling topichead with no navtitle: <xsl:sequence select="df:reportTopicref(.)"/></xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref') and @href = '']
             [(@navtitle or *[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/navtitle')]) ]">
    <xsl:if test="true()">
      <xsl:message> + [DEBUG] Handling topicref with no href and a navigation title: <xsl:sequence select="df:reportTopicref(.)"/></xsl:message>
    </xsl:if>
    <div>
      <h2><xsl:sequence select="df:getNavtitleForTopicref(.)"/></h2>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref') and @href != '' and @format = 'ditamap']">
    <xsl:if test="true()">
      <xsl:message> + [DEBUG] Handling topicref to map: <xsl:sequence select="string(@href)"/></xsl:message>
    </xsl:if>
    <xsl:variable name="target"
      select="df:resolveTopicRef(.)"
    />
    <xsl:apply-templates select="$target/*[df:class(., 'map/topicref')]">
      <xsl:with-param name="topicref" select="." as="element()" tunnel="no"/>      
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref') and @href != '' and not(@format = 'ditamap')]">
    <xsl:if test="true()">
      <xsl:message> + [DEBUG] Handling topicref to non-map resource: <xsl:sequence select="df:reportTopicref(.)"/></xsl:message>
    </xsl:if>
    <xsl:variable name="target"
       select="df:resolveTopicRef(.)"
    />
    <!-- NOTE: subordinate topicrefs are handled in the template for the referenced topic. -->
    <xsl:apply-templates select="$target">
      <xsl:with-param name="topicref" select="." as="element()" tunnel="no"/>
    </xsl:apply-templates>
    
  </xsl:template>
    
  <xsl:template match="RSUITE:*"/><!-- Suppress RSUITE elements by default -->
  
  <xsl:template match="*" mode="#all" priority="-1">
    <div style="margin-left: 1em;">
      <span style="color: green;">[<xsl:value-of select="@class"/>{</span><xsl:apply-templates/><span style="color: green;">}]</span>
    </div>
  </xsl:template>
  
   
</xsl:stylesheet>
