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
  
  <xsl:param name="debug" select="'false'"/>
  <xsl:variable name="debugBoolean" select="if ($debug = 'true') then true() else false()" as="xs:boolean"/>
  

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:apply-templates select="*/*[df:class(., 'topic/title')]" mode="head"/></title>
        <LINK REL="stylesheet" TYPE="text/css" 
          HREF="/rsuite/rest/v1/content/alias/course-preview.css"/>
        
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
  
 <xsl:key name="topicsById" match="*[df:class(., 'topic/topic')]" use="@id"/>
  
  
  <!-- List of base types that are inherently blocks. Include %basic.block as 
       well as other elements that are also normally or always presented as 
       blocks (e.g., shortdesc) -->
  <xsl:variable name="baseBlockTypes"
    select="'^dl^fig^image^lines^lq^note^object^ol^p^pre^simpletable^sl^table^ul^shortdesc^'"
  />

  <xsl:template name="resolve-mapref">
    <xsl:variable name="mapUri" select="@href" as="xs:string"/>
    <xsl:variable name="mapDoc" select="document($mapUri, .)"/>
    <!-- FIXME: factor out common resolution error checking -->
    <!-- FIXME: Need rewrite URIs to reflect new path in resolved context (that is, relative to
                the base URI of the top-level map.
    -->
    <xsl:message terminate="yes"> - Error: Support for subordinate maps not yet implemented. </xsl:message>
    <xsl:message> +   Resolving map reference to map "<xsl:sequence select="$mapUri"/>"...</xsl:message>
    <xsl:apply-templates select="$mapDoc/*/*[df:class(., 'map/topicref') or df:class(., 'map/reltable')]" mode="#current"/>
  </xsl:template>
  
  <xsl:function name="df:idForTopic" as="xs:string">
    <xsl:param name="topicDoc" as="document-node()"/>
    <xsl:param name="topic" as="element()"/>
    
    <xsl:sequence select="concat(df:hashUri(base-uri($topicDoc)), generate-id($topic))"/>
  </xsl:function>
  
  <xsl:function name="df:hashUri" as="xs:string">
    <xsl:param name="uri" as="xs:string"/>
    <xsl:sequence select="escape-html-uri($uri)"/>
  </xsl:function>
  
  <xsl:function name="df:idForTopicheadTopic" as="xs:string">
    <!-- Generates an ID for a topic generated from a topichead element -->
    <xsl:param name="context" as="element()"/>
    <xsl:sequence select="concat('topichead-', generate-id($context))"/>
  </xsl:function>
  
  <xsl:function name="df:getNavtitleForTopicref" as="xs:string">
    <xsl:param name="topicref" as="element()"/>
    <xsl:choose>
      <xsl:when test="$topicref/@navtitle != ''">
        <xsl:value-of select="$topicref/@navtitle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="targetTopic" select="df:resolveTopicRef($topicref)"/>
        <xsl:if test="$debugBoolean">
        <xsl:message> + DEBUG: df:getNavtitleForTopicref(): targetTopic is <xsl:sequence select="concat(name($targetTopic), ': ', normalize-space($targetTopic/*[df:class(., 'topic/title')]))"/></xsl:message>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$targetTopic/*[df:class(., 'topic/titlealts')]/*[df:class(., 'topic/navtitle')]">
            <xsl:if test="$debugBoolean">
            <xsl:message> + DEBUG: df:getNavtitleForTopicref(): target topic has a titlealts/navtitle element</xsl:message>
            <xsl:message> +                                           value is: "<xsl:sequence select="normalize-space($targetTopic/*[df:class(., 'topic/titlealts')]/*[df:class(., 'topic/navtitle')])"/>"</xsl:message>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$debugBoolean">
            <xsl:message> + DEBUG: df:getNavtitleForTopicref(): target topic does not have a titlealts/navtitle element</xsl:message>
            <xsl:message> +                                    title is: "<xsl:sequence select="normalize-space($targetTopic/*[df:class(., 'topic/title')])"/>"</xsl:message>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        
        <xsl:variable name="navTitle" 
          select="if ($targetTopic/*[df:class(., 'topic/titlealts')]/*[df:class(., 'topic/navtitle')])
                     then normalize-space($targetTopic/*[df:class(., 'topic/titlealts')]/*[df:class(., 'topic/navtitle')])
                     else normalize-space($targetTopic/*[df:class(., 'topic/title')])
                     "/>
        <xsl:if test="$debugBoolean">
        <xsl:message> + DEBUG: df:getNavtitleForTopicref(): returning "<xsl:sequence select="$navTitle"/>"</xsl:message>
        </xsl:if>
        <xsl:sequence select="$navTitle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="df:resolveTopicRef" as="element()?">
    <!-- Resolves a topicref to its target topic element, if it can be resolved -->
    <xsl:param name="context" as="element()"/><!-- Topicref element -->
    <xsl:choose>
      <xsl:when test="not(df:class($context, 'map/topicref'))">
        <xsl:message> - ERROR: df:resolveTopicRef(): context element is not of class 'map/topicref', class is <xsl:sequence select="$context/@class"/></xsl:message>
        <xsl:sequence select="/.."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$debugBoolean">
        <xsl:message> + DEBUG: df:resolveTopicRef(): context is a topicref.</xsl:message>
        </xsl:if>
        <xsl:variable name="topicUri" as="xs:string" 
        select="if (contains($context/@href, '#')) then substring-before($context/@href, '#') else normalize-space($context/@href)"/>
        <xsl:if test="$debugBoolean">
        <xsl:message> + DEBUG: df:resolveTopicRef(): topicUri="<xsl:sequence select="$topicUri"/>"</xsl:message>
        </xsl:if>
        <xsl:variable name="topicFragId" as="xs:string" 
        select="if (contains($context/@href, '#')) then substring-after($context/@href, '#') else ''"/>
        <xsl:if test="$debugBoolean">
        <xsl:message> + DEBUG: df:resolveTopicRef(): topicFragId="<xsl:sequence select="$topicFragId"/>"</xsl:message>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$topicUri = ''">
            <xsl:if test="$debugBoolean">
            <xsl:message> + DEBUG: df:resolveTopicRef(): topicUri is '', return empty list.</xsl:message>
            </xsl:if>
            <xsl:sequence select="/.."/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$debugBoolean">
            <xsl:message> + DEBUG: df:resolveTopicRef(): topicUri is a string, trying to resolve...</xsl:message>
            </xsl:if>
            <xsl:variable name="baseUri" as="xs:anyURI"
              select="base-uri($context)"
            />
            <xsl:choose>
              <!--<xsl:when test="doc-available(resolve-uri($topicUri, $baseUri))">-->
                <xsl:when test="true()">
                <xsl:if test="$debugBoolean">
                  <xsl:message> + DEBUG: df:resolveTopicRef(): target document is available.</xsl:message>
                </xsl:if>
                <xsl:variable name="topicDoc" select="document($topicUri, $context)"/>
                <xsl:if test="$debugBoolean">
                  <xsl:message> + DEBUG: df:resolveTopicRef(): target document resolved: <xsl:sequence select="count($topicDoc) > 0"/></xsl:message>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="$topicFragId = ''">
                    <xsl:if test="$debugBoolean">
                    <xsl:message> + DEBUG: df:resolveTopicRef(): No explicit fragment identifier, select first topic in document in document order</xsl:message>
                    </xsl:if>
                    <!-- No explicit fragment identifier, select first topic in document in document order -->
                    <xsl:choose>
                      <xsl:when test="$topicDoc/*[df:class(., 'topic/topic')]">
                        <xsl:if test="$debugBoolean">
                        <xsl:message> + DEBUG: df:resolveTopicRef(): root of topicDoc is a topic, returning root element.</xsl:message>
                        </xsl:if>
                        <xsl:sequence select="$topicDoc/*[1]"/>
                      </xsl:when>
                      <xsl:when test="$topicDoc/*/*[df:class(., 'topic/topic')]">
                        <xsl:if test="$debugBoolean">
                        <xsl:message> + DEBUG: df:resolveTopicRef(): child root of topicDoc is a topic, returning first child topic.</xsl:message>
                        </xsl:if>
                        <xsl:sequence select="$topicDoc/*/*[df:class(., 'topic/topic')][1]"/>
                        <xsl:message> -     Info: Using first child topic <xsl:sequence select="$topicDoc/*/*[df:class(., 'topic/topic')][1]/@id"/> of document "<xsl:sequence select="$topicUri"/>".</xsl:message>
                      </xsl:when>
                      <xsl:when test="$topicDoc/*[df:class(., 'map/map')] and $context/@format = 'ditamap'">
                        <xsl:if test="$debugBoolean">
                          <xsl:message> + DEBUG: df:resolveTopicRef(): Root element is a map and format=ditamap, returning map element.</xsl:message>
                        </xsl:if>
                        <xsl:sequence select="$topicDoc/*[1]"/>                        
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:message> -     Warning: document "<xsl:sequence select="$topicUri"/>" not a topic or does not contain a topic as its first child.</xsl:message>
                        <xsl:sequence select="/.."/>
                      </xsl:otherwise>
                    </xsl:choose>    
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- Explicit fragment ID, try to resolve it -->
                    <xsl:if test="$debugBoolean">
                    <xsl:message> + DEBUG: df:resolveTopicRef(): Explicit fragment identifier, resolving it.</xsl:message>
                    </xsl:if>
                    <xsl:variable name="topicsWithId" select="key('topicsById', $topicFragId, $topicDoc)"/>
                    <xsl:choose>
                      <xsl:when test="count($topicsWithId) = 0">
                        <xsl:message> - Error: df:resolveTopicRef(): Failed to find topic with fragment identifier "<xsl:sequence select="$topicFragId"/>" in topic document "<xsl:sequence select="base-uri($topicDoc)"/>"</xsl:message>
                        <xsl:sequence select="/.."/>
                      </xsl:when>
                      <xsl:when test="count($topicsWithId) > 1">
                        <xsl:message> - Warning: df:resolveTopicRef(): found multiple topics with fragment identifier "<xsl:sequence select="$topicFragId"/>", using first one found.</xsl:message>
                        <xsl:sequence select="$topicsWithId[1]"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:sequence select="$topicsWithId[1]"/>
                      </xsl:otherwise>
                    </xsl:choose>                    
                  </xsl:otherwise>
                </xsl:choose>                
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="$debugBoolean">
                <xsl:message> + DEBUG: df:resolveTopicRef(): document at uri "<xsl:sequence select="resolve-uri($topicUri, base-uri($context))"/>" is not available, returning empty list</xsl:message>
                </xsl:if>
                <xsl:sequence select="/.."/>
              </xsl:otherwise>
            </xsl:choose>            
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
    
  <xsl:function name="df:getListLevel" as="xs:integer">
    <xsl:param name="context" as="element()"/><!-- Must be a list item within a list -->
    <xsl:if test="not(df:class($context, 'topic/li'))">
      <xsl:message terminate="yes"> - ERROR: df:getListLevel(<xsl:value-of select="name($context)"/>): context element is not a list item.</xsl:message>
    </xsl:if>
    <xsl:variable name="listClass" select="substring-before(substring($context/../@class, 3), ' ')" as="xs:string"/>
    <xsl:variable name="level" select="count(df:sameListClass($context/.., $listClass))" as="xs:integer"/>
    <xsl:sequence select="$level"/>
  </xsl:function>
  
  <xsl:function name="df:sameListClass" as="element()*">
    <xsl:param name="n" as="element()"/>
    <xsl:param name="listClass" as="xs:string"/>
    
    <xsl:sequence select="$n,$n/ancestor::*[df:isList(.)][1][df:class(., $listClass)]/df:sameListClass(., $listClass)"/>
  </xsl:function>
  
  <xsl:function name="df:isList" as="xs:boolean">
    <xsl:param name="context" as="element()"/><!-- if li, then check type of parent, if list type then check nearest ancestor that is a list type -->
    <xsl:sequence select="df:class($context, 'topic/ul') or df:class($context, 'topic/ol')"/>
  </xsl:function>
  
  <xsl:function name="df:isInListOfType" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:param name="listClass" as="xs:string"/>
    <xsl:sequence select="df:isInListOfType($context/(ancestor::*[df:isList(.)])[1], $listClass)"/>
  </xsl:function>
  
  <xsl:function name="df:class" as="xs:boolean">
    <xsl:param name="elem" as="element()"/>
    <xsl:param name="classSpec" as="xs:string"/>
    <!--
    <xsl:message> + Debug: df:class(): classSpec="<xsl:sequence select="$classSpec"/>", <xsl:sequence select="$elem/@class"/></xsl:message>
    -->
    <!-- Workaround for bug in MarkLogic 3.x and common user error, where trailing space in class= attribute
         is dropped.
      -->
    <xsl:variable name="result" 
      select="
          if (contains($elem/@class, concat(' ', $classSpec, ' ')))
             then true()
             else ends-with($elem/@class, concat(' ', $classSpec))
        " 
     as="xs:boolean"/>
    <!--
    <xsl:message> + Debug:   returning <xsl:sequence select="$result"/></xsl:message>
    -->
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="df:hasSpecifiedNavtitle" as="xs:boolean">
    <xsl:param name="topicref" as="element()"/>
    <xsl:sequence select="($topicref/@navtitle) or 
      $topicref/*[df:class(.,'map/topicmeta')]/*[df:class(.,'topic/navtitle')]"/>
  </xsl:function>
  
  <xsl:function name="df:hasBlockChildren" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:sequence select="boolean($context[
      *[df:class(., 'topic/p')] |
      *[df:class(., 'topic/ol')] |
      *[df:class(., 'topic/ul')] |
      *[df:class(., 'topic/sl')] |
      *[df:class(., 'topic/example')] |
      *[df:class(., 'topic/fig')] |
      *[df:class(., 'topic/figgroup')] |
      *[df:class(., 'topic/lines')] |
      *[df:class(., 'topic/note')] |
      *[df:class(., 'topic/pre')] |
      *[df:class(., 'topic/simpletable')] |
      *[df:class(., 'topic/table')]
      ])"/>
  </xsl:function>
  
  <xsl:function name="df:isBlock" as="xs:boolean">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="result" as="xs:boolean">
      <xsl:choose>
          <xsl:when test="contains($context/@class, ' topic/')">
            <xsl:variable name="baseType"
              select="substring-after(tokenize($context/@class, ' ')[2], '/')"
            />
            <xsl:sequence 
              select="contains($baseBlockTypes, concat('^',$baseType, '^'))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="false()"/>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>  
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="df:getBaseClass" as="xs:string">
    <!-- Gets the base class name of the context element, e.g. "topic/p" -->
    <xsl:param name="context" as="element()"/>
    <!-- @class value is always "- foo/bar fred/baz " or "+ foo/bar fred/baz " -->
    <xsl:variable name="result" as="xs:string"
      select="normalize-space(tokenize($context/@class, ' ')[2])"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="df:getHtmlClass" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:sequence 
      select="
      if ($context/@outputclass)
        then string($context/@outputclass)
        else name($context)
        "/>
  </xsl:function>
  
  <xsl:function name="df:format-atts" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="att-strings">
    <xsl:for-each select="$context/@*">
      <xsl:sequence select="name(.)"/>="<xsl:sequence select="string(.)"/><xsl:text>" </xsl:text>
    </xsl:for-each>
    </xsl:variable>
    <xsl:sequence select="string-join($att-strings, ' ')"/>
  </xsl:function>
  
  <xsl:function name="df:reportTopicref" as="node()*">
    <xsl:param name="topicref" as="element()*"/>
    <xsl:text>&#x0a;</xsl:text>
    <xsl:apply-templates select="$topicref" mode="topicref-report"/>
  </xsl:function>
  
  <xsl:template mode="topicref-report" match="*[df:class(., 'map/topicref')]">
    <xsl:text>&#x0a;</xsl:text>
    <xsl:copy copy-namespaces="no">
      <xsl:sequence select="@href | @chunk | @navtitle"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="topicref-report" match="*" priority="-1">
    <xsl:text>&#x0a;</xsl:text>
    <xsl:copy>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>

  
  <xsl:template match="@*" priority="-1" mode="#all">
    <xsl:sequence select="."/>
  </xsl:template>

   
</xsl:stylesheet>
