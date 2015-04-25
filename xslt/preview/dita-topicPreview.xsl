<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="RSUITE df xs relpath"
  >
  
  <!-- ===============================================================
       Default DITA HTML preview style sheet for use with RSuite CMS.
       
       Provides good-enough HTML preview of DITA maps and topics. Handles
       topicref resolution, does not currently handle conref resolution.
       
       This style sheet is normally packaged as an RSuite plugin from 
       which it is used by shell transforms that override or extend
       this one in the style of the DITA Open Toolkit.
    
       =============================================================== -->
  
<!--
  <xsl:import href="../lib/dita-support-lib.xsl"/>
  <xsl:import href="../lib/resolve-map.xsl"/>
-->  
  <xsl:param name="rsuite.sessionkey" as="xs:string" select="'unset'"/>
  <xsl:param name="rsuite.serverurl" as="xs:string" select="'urn:unset:/dev/null'"/>
  
  
  <xsl:variable name="debugBoolean" select="true()" as="xs:boolean"/>
  
  <xsl:template match="/">
    <xsl:apply-templates mode="handle-root-element"/>
  </xsl:template>
  
  <xsl:template mode="handle-root-element" match="*[df:class(., 'map/map')] | *[df:class(., 'topic/topic')] " priority="10">
    <xsl:message> + [DEBUG] handle-root-element: class="<xsl:sequence select="@class"/>"</xsl:message>
    <xsl:variable name="resolved-map-uri" as="xs:string?"
      select="if (df:class(., 'topic/topic')) 
      then relpath:newFile(relpath:getParent(base-uri(.)), 'resolved-map.ditamap')
      else base-uri(.)
      "
    />
    <xsl:variable name="authenticatedMapUri" as="xs:string"
      select="if ($rsuite.sessionkey != '')
                 then concat($resolved-map-uri, '?', 'skey=', $rsuite.sessionkey)
                 else $resolved-map-uri
      "
    />
    <xsl:variable name="resolvedMap" as="document-node()">      
      <xsl:document>
        <xsl:apply-templates mode="resolve-map" select=".">
          <xsl:with-param name="map-base-uri" select="$authenticatedMapUri" as="xs:string" tunnel="yes"/>
          <xsl:with-param name="parentHeadLevel" as="xs:integer" select="0" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:document>
    </xsl:variable>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] dita-previewImpl: resolved map:
        <xsl:sequence select="$resolvedMap"/>
      </xsl:message>
    </xsl:if>
     <html>
      <head>
        <title><xsl:apply-templates select="@title, *[df:class(., 'topic/title')]" mode="page-title"/></title>
        <xsl:apply-templates select="$resolvedMap" mode="head"/>
        <xsl:apply-templates select="$resolvedMap" mode="linked-css-stylesheet"/>
        <xsl:apply-templates select="$resolvedMap" mode="embedded-css-stylesheet"/>
      </head>
      <body>
        <!-- resolvedMap is a document node. -->
        <xsl:apply-templates select="$resolvedMap/*"/>
      </body>
    </html>
  </xsl:template>  
  
  <xsl:template match="/*" mode="handle-root-element">
    <!-- Elements that are not maps or topics -->
    <html>
      <head>
        <title><xsl:apply-templates select="." mode="page-title"/></title>
        <xsl:apply-templates select="." mode="head"/>
        <xsl:apply-templates select="." mode="embedded-css-stylesheet"/>
      </head>
      <body>
        <xsl:apply-templates select="."/>
      </body>
    </html>
  </xsl:template>  
  
  <xsl:template mode="page-title" match="text()"/>
  
  <xsl:template mode="page-title" match="@title">
    <xsl:value-of select="."/>
  </xsl:template>  

  <xsl:template mode="page-title" match="title | *[*[df:class(., 'topic/title')]]" priority="10">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template mode="page-title" match="section | *[df:class(., 'topic/section')]" priority="5">
    <!-- section with not title child -->
    <xsl:sequence select="string(@spectitle)"/>
  </xsl:template>
  
  <xsl:template mode="page-title" match="*">
    <!-- Elements without title children: First 60 characters -->
    <xsl:variable name="text" as="text()">
      <xsl:value-of>
        <xsl:apply-templates mode="text-only"/>
      </xsl:value-of>
    </xsl:variable>
    <xsl:sequence select="substring($text, 1, 80)"/>
  </xsl:template>
  
  <xsl:template mode="text-only" match="text()">
    <xsl:sequence select="."/>
  </xsl:template>
  
  
  <xsl:template match="*" mode="embedded-css-stylesheet">
    <!-- Override this template to emit inline CSS stylesheet here if you want. -->
  </xsl:template>
  
  <xsl:template match="*" mode="linked-css-stylesheet">
    <!-- Override this stylesheet to link to a different CSS -->
    <LINK REL="stylesheet" TYPE="text/css" 
      HREF="/rsuite/rest/v1/static/rsuite-dita-support/css/dita-preview.css?skey={$rsuite.sessionkey}"/>
    <!-- WEK: I think the later include overrides the earlier, I'm not 100% sure of that -->    
    <LINK REL="stylesheet" TYPE="text/css" 
      HREF="/rsuite/rest/v1/content/alias/dita-preview-demo-override.css?skey={$rsuite.sessionkey}"/>    
  </xsl:template>
  
  
  <xsl:template match="*[df:class(., 'topic/topic')]">
    <xsl:param name="topicref" as="element()?" tunnel="no"/>
    <xsl:param name="subtopicContent" as="node()*" tunnel="yes"/>
    <!-- FIXME: Use the topicref to determine our topic nesting -->
    <div class="{df:getHtmlClass(.)}">
      <a id="{generate-id(.)}" name="{generate-id(.)}"/>
      <xsl:apply-templates/>
      <xsl:apply-templates select="$topicref/*">
        <xsl:with-param name="subtopicContent" select="()" tunnel="yes" as="node()*"/>
      </xsl:apply-templates>
      <!-- WEK: This was original code. Not sure if it should be here but
        removing it appears to fix the duplicate output bug. -->
      <!--<xsl:sequence select="$subtopicContent"/>-->
    </div>
  </xsl:template>
  
  <xsl:template match="keyword | *[df:class(., 'topic/keyword')]">
    <span class="{df:getHtmlClass(.)}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="ph | *[df:class(., 'topic/ph')]">
    <span class="{df:getHtmlClass(.)}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="text | *[df:class(., 'topic/text')]">
    <span class="{df:getHtmlClass(.)}"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="fn | *[df:class(., 'topic/fn') and not(@id)]">
    <span class="{df:getHtmlClass(.)}"><sup><a href="#{generate-id(.)}"
      ><xsl:number count="*[df:class(., 'topic/fn') and not(@id)] | 
        *[df:class(., 'topic/xref') and @scope = 'local' and @type = 'fn']" format="1" level="any"
      /></a></sup></span>
  </xsl:template>
  
  <xsl:template match="*[(self::fn or df:class(., 'topic/fn')) and @id]">
    <!-- Only rendered if referenced by an xref of type 'fn' -->
  </xsl:template>
  
  <xsl:template match="*[(self::fn or df:class(., 'topic/fn')) and not(@id)]" mode="footnotes" name="render-footnote">
    <div class="{df:getHtmlClass(.)}"><xsl:text>[</xsl:text><a id="{generate-id(.)}" name="{generate-id(.)}"
      ><xsl:number count="*[df:class(., 'topic/fn') and not(@id)] | 
        *[df:class(., 'topic/xref') and @scope = 'local' and @type = 'fn']" format="1" level="any"
      /></a><xsl:text>]</xsl:text>
      <xsl:apply-templates/>
    </div>
  </xsl:template>  
  
  <xsl:template match="boolean | *[df:class(., 'topic/boolean')]">
    <span class="{df:getHtmlClass(.)}">
      <xsl:choose>
        <xsl:when test="@state = 'yes'"><xsl:text>Yes</xsl:text></xsl:when>
        <xsl:when test="@state = 'no'"><xsl:text>No</xsl:text></xsl:when>
        <xsl:otherwise>{Unrecognized value '<xsl:sequence select="string(@state)"/>' for @state on topic/boolean}</xsl:otherwise>
      </xsl:choose>      
    </span>
  </xsl:template>
  
  <xsl:template match="tm | *[df:class(., 'topic/tm')]">
    <span class="{df:getHtmlClass(.)}"><xsl:apply-templates/>
      <xsl:choose>
        <xsl:when test="@tmtype = 'reg'"><xsl:text>®</xsl:text></xsl:when>
        <xsl:when test="@tmtype = 'service'"><xsl:text>℠</xsl:text></xsl:when>
        <xsl:otherwise><sup>TM</sup></xsl:otherwise>
      </xsl:choose>      
    </span>
  </xsl:template>
  
  <xsl:template match="q | *[df:class(., 'topic/q')]">
    <span class="{df:getHtmlClass(.)}"><xsl:text>&#x201c;</xsl:text><xsl:apply-templates/><xsl:text>&#x201d;</xsl:text></span>
  </xsl:template>
  
  <xsl:template match="indexterm | *[df:class(., 'topic/indexterm')]">
    <!-- suppressed in default mode -->
  </xsl:template>
  
  <xsl:template match="cite | *[df:class(., 'topic/cite')]">
    <i class="{df:getHtmlClass(.)}"><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="term | *[df:class(., 'topic/term')]">
    <i class="{df:getHtmlClass(.)}"><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="body | *[df:class(., 'topic/body')]">
    <div class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <!-- NOTE <div> is DITA 1.3 -->
  <xsl:template match="bodydiv | 
                       *[df:class(., 'topic/bodydiv')] | 
                       *[df:class(., 'topic/div')]"
    >
    <div class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="fig/title | *[df:class(., 'topic/fig')]/*[df:class(., 'topic/title')]">
    <div class="{df:getHtmlClass(.)}">
      <xsl:text>Figure </xsl:text>
      <xsl:number count="*[df:class(., 'topic/fig')][*[df:class(., 'topic/title')]]"
        level="any"
        format="1."
      />
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="fig | *[df:class(., 'topic/fig')]">
    <div class="{df:getHtmlClass(.)}">
      <div class="figbody">
        <xsl:apply-templates select="* except (title | *[df:class(., 'topic/title')])"/>
      </div>
      <xsl:apply-templates select="title | *[df:class(., 'topic/title')]"/>
    </div>
  </xsl:template>
  
  <xsl:template match="desc | *[df:class(., 'topic/desc')]">
    <p class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/topic')]/*[df:class(., 'topic/title')]">
    <h2><xsl:apply-templates/></h2>
  </xsl:template>
  
  <xsl:template match="title | *[df:class(., 'topic/title')]" mode="head">
    <xsl:apply-templates mode="text-only"/>
  </xsl:template>
  
  <xsl:template match="sectiondiv | *[df:class(., 'topic/sectiondiv')]">
    <div class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template 
    match="section/title |
    *[df:class(., 'topic/section')]/*[df:class(., 'topic/title')]
    ">
    <h3><xsl:apply-templates/></h3>
  </xsl:template>
  
  <xsl:template match="section | *[df:class(., 'topic/section')]">
    <div class="{df:getHtmlClass(.)}">
      <xsl:if test="@spectitle">
        <h3><xsl:sequence select="string(@spectitle)"/></h3>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="example | *[df:class(., 'topic/example')]">
    <div class="{df:getHtmlClass(.)}">
      <xsl:choose>
        <xsl:when test="@spectitle">
          <h3><xsl:sequence select="string(@spectitle)"/></h3>
        </xsl:when>
        <xsl:otherwise>
          <h3>Example</h3>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="ul | *[df:class(., 'topic/ul')]">
    <ul class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
    
  <xsl:template match="ol | *[df:class(., 'topic/ol')]">
    <ol class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </ol>
  </xsl:template>
  
  <xsl:template match="dl | *[df:class(., 'topic/dl')]">
    <dl class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </dl>
  </xsl:template>
  
  <xsl:template match="dlentry | *[df:class(., 'topic/dlentry')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="dlhead | *[df:class(., 'topic/dlhead')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="dthd | *[df:class(., 'topic/dthd')]">
    <dt class="{df:getHtmlClass(.)}"><b><xsl:apply-templates/></b></dt>
  </xsl:template>
  
  <xsl:template match="ddhd | *[df:class(., 'topic/ddhd')]">
    <dd class="{df:getHtmlClass(.)}"><b><xsl:apply-templates/></b></dd>
  </xsl:template>
  
  <xsl:template match="dt | *[df:class(., 'topic/dt')]">
    <dt class="{df:getHtmlClass(.)}"><b><xsl:apply-templates/></b></dt>
  </xsl:template>
  
  <xsl:template match="dd | *[df:class(., 'topic/dd')]">
    <dd class="{df:getHtmlClass(.)}"><xsl:apply-templates/></dd>
  </xsl:template>
  
  <xsl:template match="sl | *[df:class(., 'topic/sl')]">
    <div class="{df:getHtmlClass(.)}" style="margin-left: 0.5in">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="sli | *[df:class(., 'topic/sli')]">
    <p class="{df:getHtmlClass(.)}" >
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="li | *[df:class(., 'topic/li')]">
    <li class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
  <xsl:template match="p | *[df:class(., 'topic/p')]">
    <p class="{df:getHtmlClass(.)}"><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="draft-comment | *[df:class(., 'topic/draft-comment')]">
    <div class="{df:getHtmlClass(.)}">
      <b>Draft Comment by <span class="draft-comment-author"
        ><xsl:sequence select="if (@author) then string(@author) else 'No Author'"
        />: </span></b> <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="pre | *[df:class(., 'topic/pre')]">
    <pre class="{df:getHtmlClass(.)}"><xsl:apply-templates/></pre>
  </xsl:template>
  
  <xsl:template match="lines | *[df:class(., 'topic/lines')]">
    <p class="{df:getHtmlClass(.)}" style="white-space: pre;"><xsl:apply-templates/></p>
  </xsl:template>
 
  <xsl:template match="lq | *[df:class(., 'topic/lq')]">
    <blockquote class="{df:getHtmlClass(.)}"><xsl:apply-templates/></blockquote>
  </xsl:template>
  
  <xsl:template match="note | *[df:class(., 'topic/note')]">
    <xsl:variable name="label" as="xs:string">
      <xsl:choose>
        <xsl:when test="@type != ''">
          <xsl:choose>
            <xsl:when test="@type = 'other'">
              <xsl:sequence select="string(@othertype)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="@type = 'note'">
                  <xsl:sequence select="'Note'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:sequence select="string(@type)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>          
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="'Note'"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    
    <p class="{df:getHtmlClass(.)}"><b>
      <xsl:sequence select="$label"/>: </b>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <!-- ============================================
       Metadata elements
       ============================================ --> 
  
  <xsl:template match="*[df:class(., 'map/topicmeta')]">
    <div class="map-topicmeta">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="shortdesc | *[df:class(., 'map/shortdesc')] | *[df:class(., 'topic/shortdesc')]">
    <p class="map_shortdesc"><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="abstract | *[df:class(., 'topic/abstract')]">
    <div class="{df:getHtmlClass(.)}">
     <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="author | *[df:class(., 'topic/author')]">
    <p class="map_author"><b>Author: </b><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="data | *[df:class(., 'topic/data')]">
    <!-- Suppress <data> by default -->
  </xsl:template>
  
  <xsl:template match="data | *[df:class(., 'topic/data')]" mode="show-data">
    <xsl:variable name="htmlClass" as="xs:string"
      select="
      if (@outputclass) 
      then string(@outputclass)
      else if (@name)
      then string(@name)
      else name(.)
      "
    />
    <span class="{$htmlClass}"><xsl:apply-templates mode="show-data"/></span>
  </xsl:template>
  
  
  
  <!-- ============================================
    Multimedia elements
    ============================================ --> 
  
  <xsl:template match="image | *[df:class(., 'topic/image')]">
    <img src="{concat(@href, '?skey=',$rsuite.sessionkey)}" class="{df:getHtmlClass(.)}">
      <xsl:attribute name="alt">
        <xsl:apply-templates mode="text-only"/>
      </xsl:attribute>
    </img>
  </xsl:template>  
  
  <xsl:template match="*[(self::xref or df:class(., 'topic/xref')) and @type = 'fn']" mode="footnotes">
    <xsl:variable name="targetUri" as="xs:string?"
      select="@href"
    />
    <xsl:variable name="footnote" as="element()?"
      select="df:resolveTopicElementRef(., @href)"
    />
    <xsl:choose>
      <xsl:when test="$footnote">
        <xsl:for-each select="$footnote">
          <xsl:call-template name="render-footnote"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> - [WARNING] Failed to resolve reference to footnote "<xsl:sequence select="string(@href)"/>"</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>  
  
  <xsl:template match="xref | *[df:class(., 'topic/xref')]">
    <xsl:variable name="targetUri" as="xs:string?"
       select="@href"
    />
    <xsl:variable name="targetElement" as="element()?"
      select="if (@scope = 'local') then df:resolveTopicElementRef(., @href) else ()"
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
            <xsl:when test="@type = 'fn' and @scope = 'local'">
              <span class="{df:getHtmlClass(.)}"><sup><a href="#{generate-id($targetElement)}"
                ><xsl:number count="*[df:class(., 'topic/fn') and not(@id)] | 
                  *[df:class(., 'topic/xref') and @scope = 'local' and @type = 'fn']" 
                  format="1" 
                  level="any"
                /></a></sup></span>
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
  
  <xsl:template match="table | *[df:class(., 'topic/table')]">
    <table class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </table>
  </xsl:template> 
  
  <xsl:template match="table/title | *[df:class(., 'topic/table')]/*[df:class(., 'topic/title')]">
    <p class="{df:getHtmlClass(.)}">
      <xsl:text>Table </xsl:text><xsl:number 
        count="*[df:class(., 'topic/table')]"
        level="any"
        format="1."
      /><xsl:text> </xsl:text><xsl:apply-templates/>
    </p>
  </xsl:template> 
  
  <xsl:template match="tgroup | *[df:class(., 'topic/tgroup')]">
    <xsl:apply-templates select="*[df:class(., 'topic/colspec')]"/>
    <xsl:apply-templates select="*[df:class(., 'topic/thead')]"/>
    <xsl:apply-templates select="*[df:class(., 'topic/tbody')]"/>
  </xsl:template> 
  
  <xsl:template match="colspec | *[df:class(., 'topic/colspec')]">
    <!-- FIXME: Implement colspec mapping -->
  </xsl:template>

  <xsl:template match="thead | *[df:class(., 'topic/thead')]">
    <thead class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </thead>
  </xsl:template>
  
  <xsl:template match="tbody | *[df:class(., 'topic/tbody')]">
    <tbody class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </tbody>
  </xsl:template>
  
  <xsl:template match="row | *[df:class(., 'topic/row')]">
    <tr class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  
  <xsl:template match="thead/entry | *[df:class(., 'topic/thead')]/*[df:class(., 'topic/entry')]">
    <th class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </th>
  </xsl:template>
  
  <xsl:template match="entry | *[df:class(., 'topic/entry')]">
    <td class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  
  <xsl:template match="simpletable | *[df:class(., 'topic/simpletable')]">
    <table class="{df:getHtmlClass(.)}">
      <tbody>
        <xsl:apply-templates/>
      </tbody>      
    </table>
  </xsl:template> 
  
  <xsl:template match="strow | *[df:class(., 'topic/strow')]">
    <tr class="{df:getHtmlClass(.)}">
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  
  <xsl:template match="stentry | *[df:class(., 'topic/stentry')]">
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
    <div class="map-title">
      <xsl:apply-templates select="*[df:class(., 'topic/title')]"/>
    </div>
    <xsl:apply-templates mode="toc" select="."/>
    <div class="main-flow">
      <xsl:apply-templates select="*[not(df:class(., 'topic/title'))]"/>
      <xsl:apply-templates mode="footnotes"/>
    </div>
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/map')]/*[df:class(., 'topic/title')]">
    <h1><xsl:apply-templates/></h1>
  </xsl:template>
  
  
  <!-- Suppress in default mode -->
  <xsl:template 
    match="
    *[df:class(., 'topic/navtitle')] |
    *[df:class(., 'topic/titlealts')] |
    *[df:class(., 'topic/prolog')]
    "/>
  
  <xsl:template match="*[df:isTopicGroup(.)]">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] dita-topicPreview: Handling topic group <xsl:sequence select="name(.)"/></xsl:message>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicHead(.)]">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] dita-topicPreview: Handling topichead <xsl:sequence select="name(.)"/></xsl:message>
    </xsl:if>
    <div class="{df:getHtmlClass(.)}">
      <xsl:element name="h{@headLevel}">
        <xsl:sequence select="df:getNavtitleForTopicref(.)"/>
      </xsl:element>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref') and @processing-role = 'resource-only']" priority="10">
    <!-- Ignore resource-only topicrefs in default mode -->
  </xsl:template>
    
  <xsl:template match="*[df:isTopicRef(.) and @format = 'ditamap']">
    <!-- NOTE: This would only happen for peer and external scope maps -->
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] dita-topicPreview: Handling topicref to map: <xsl:sequence select="string(@href)"/></xsl:message>
    </xsl:if>
    <xsl:variable name="target"
      select="df:resolveTopicRef(.)"
    />
    <xsl:apply-templates select="$target/*[df:class(., 'map/topicref')]">
      <xsl:with-param name="topicref" select="." as="element()" tunnel="no"/>      
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="*[df:isTopicRef(.) and not(@format = 'ditamap')]" mode="#default footnotes">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] dita-topicPreview: Handling topicref to non-map resource: <xsl:sequence select="df:reportTopicref(.)"/></xsl:message>
    </xsl:if>
    <xsl:variable name="target" as="element()?"
       select="df:resolveTopicRef(.)"
    />
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] dita-topicPreview:   target element=<xsl:sequence select="name($target)"/>[class=<xsl:sequence select="string($target/@class)"/>]</xsl:message>
    </xsl:if>
    
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] dita-topicPreview:  constructing subtopicContent by applying templates to <xsl:sequence select="./*"/> </xsl:message>
    </xsl:if>
    <xsl:variable name="subtopicContent" as="node()*">
      <xsl:apply-templates/>      
    </xsl:variable>
    
    <!-- NOTE: subordinate topicrefs are handled in the template for the referenced topic. -->
    <xsl:apply-templates select="$target" mode="#current">
      <xsl:with-param name="topicref" select="." as="element()" tunnel="no"/>
      <xsl:with-param name="subtopicContent" as="node()*" select="$subtopicContent" tunnel="yes"/>      
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref')]" priority="-0.5">
    <xsl:message> + [ERROR] dita-topicPreview:  unhandled topicref: <xsl:sequence select="df:reportTopicref(.)"/></xsl:message>
  </xsl:template>
  
  <!-- ===========================
       Conref resolution
       =========================== -->
  
  <xsl:template match="*[@conref != '']" priority="100">
    <xsl:variable name="hrefValue" select="string(@conref)" as="xs:string"/>
    <xsl:variable name="conrefTarget" as="element()*"
      select="df:resolveTopicElementRef(., $hrefValue)"
    />
    <xsl:choose>
      <xsl:when test="not($conrefTarget)">
        <span class="conref-error">{Failed to resolve content reference to URL "<xsl:value-of select="$hrefValue"/>"}</span>
        <xsl:next-match/>
      </xsl:when>
      <xsl:otherwise>
        <!-- FIXME: This approach won't properly handle attribute merging. Really need to do
             a complete pre-process to do conref resolution before we get here.
             Problem is we can't synthesize a new element with merged attributes without losing 
             the orginal document context.
          -->
        <xsl:apply-templates select="$conrefTarget" mode="#current"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
  <!-- ===========================
       Catch-all templates
       =========================== -->
    
  <xsl:template match="RSUITE:*" priority="2"/><!-- Suppress RSUITE elements by default -->
  
  <xsl:template match="*" mode="head" priority="-1"/><!-- Suppress by default in head mode -->
  
  <xsl:template mode="text-only" match="*">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="footnotes" match="*">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="footnotes" match="text()"/>
  
  <xsl:template match="*" mode="#default">    
     <xsl:if test="$debugBoolean">
       <xsl:message> + [DEBUG] dita-topicPreview: Catch all in #default mode: <xsl:sequence select="name(.)"/>[class=<xsl:sequence select="string(@class)"/>]</xsl:message>
     </xsl:if>
    <div style="margin-left: 1em;">
      <span style="color: green;">[<xsl:value-of select="if (@class) then @class else concat('No Class Value: ', name(.))"/>{</span><xsl:apply-templates/><span style="color: green;">}]</span>
    </div>
  </xsl:template>
  
  
</xsl:stylesheet>
