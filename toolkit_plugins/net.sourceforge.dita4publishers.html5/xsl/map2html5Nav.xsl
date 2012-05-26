<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
                xmlns:index-terms="http://dita4publishers.org/index-terms"
                xmlns:glossdata="http://dita4publishers.org/glossdata"
                xmlns:mapdriven="http://dita4publishers.org/mapdriven"
                xmlns:enum="http://dita4publishers.org/enumerables"
                xmlns:local="urn:functions:local"
                exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms mapdriven glossdata enum"
  >
  <!-- =============================================================

    DITA Map to HTML5 Transformation

    HTML5 navigation structure generation.

    Copyright (c) 2012 DITA For Publishers

    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.

    This transform requires XSLT 2.
    ================================================================= -->
<!--
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/dita-support-lib.xsl"/>
  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/relpath_util.xsl"/>

  <xsl:import href="../../net.sourceforge.dita4publishers.common.xslt/xsl/lib/html-generation-utils.xsl"/>
-->
  <xsl:output indent="yes" name="javascript" method="text"/>


  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-html5-nav">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>


      <xsl:message> + [INFO] Generating HTML5 navigation structure...</xsl:message>

      <xsl:apply-templates mode="generate-html5-nav"/>

      <xsl:message> + [INFO] HTML5 navigation generation done.</xsl:message>
  </xsl:template>

  <xsl:template mode="generate-html5-nav-page-markup" match="*[df:class(., 'map/map')]">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>

      <nav id="left-navigation" role="navigation" class="grid_6" aria-label="Main navigation">
        <div class="nav-pub-title"><xsl:apply-templates select="*[df:class(., 'topic/title')]" mode="generate-html5-nav-page-markup"/></div>
        <xsl:variable name="listItems" as="node()*">
          <xsl:apply-templates mode="generate-html5-nav"
            select=".
            except (
            *[df:class(., 'topic/title')],
            *[df:class(., 'map/topicmeta')],
            *[df:class(., 'map/reltable')]
            )"
          />
        </xsl:variable>
        <xsl:if test="$listItems">
          <ul>
            <xsl:sequence select="$listItems"/>
          </ul>
        </xsl:if>
      </nav>


  </xsl:template>

  <xsl:template mode="generate-html5-nav-page-markup" match="*[df:class(., 'topic/title')]">
    <h2 class="nav-pub-title"><xsl:apply-templates/></h2>
  </xsl:template>

  <xsl:template mode="generate-html5-nav" match="*[df:class(., 'topic/title')]"/>

  <!-- Convert each topicref to a ToC entry. -->
  <xsl:template match="*[df:isTopicRef(.)]" mode="generate-html5-nav">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>

    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
      <xsl:choose>
        <xsl:when test="not($topic)">
          <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="targetUri" 
            select="htmlutil:getTopicResultUrl($outdir, root($topic), $rootMapDocUrl)" 
            as="xs:string"/>
          <xsl:variable name="relativeUri" 
            select="relpath:getRelativePath($outdir, $targetUri)" 
            as="xs:string"/>
          <xsl:variable name="enumeration" as="xs:string?">
            <xsl:apply-templates select="." mode="enumeration"/>
          </xsl:variable>
          <xsl:variable name="self" select="generate-id(.)" as="xs:string"/>

          <!-- Use UL for navigation structure -->

          <li><a
            href="{$relativeUri}"
            target="{$contenttarget}">
            <xsl:if test="$enumeration and $enumeration != ''">
              <span class="enumeration enumeration{$tocDepth}"><xsl:sequence select="$enumeration"/></span>
            </xsl:if>
            <xsl:apply-templates select="." mode="nav-point-title"/></a>
          <xsl:if test="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
            <xsl:variable name="listItems" as="node()*">
              <!-- Any subordinate topics in the currently-referenced topic are
              reflected in the ToC before any subordinate topicrefs.
            -->
              <xsl:apply-templates mode="#current"
                select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
                <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
                  select="$tocDepth + 1"
                />
              </xsl:apply-templates>
            </xsl:variable>
            <xsl:if test="$listItems">
              <ul>
                <xsl:sequence select="$listItems"/>
              </ul>
            </xsl:if>
          </xsl:if>
          </li>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mapdriven:collected-data" mode="generate-html5-nav">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="enum:enumerables" mode="generate-html5-nav">
    <!-- Nothing to do with enumerables in this context -->
  </xsl:template>

  <xsl:template match="glossdata:glossary-entries" mode="generate-html5-nav">
    <xsl:message> + [INFO] dynamic ToC generation: glossary entry processing not yet implemented.</xsl:message>
  </xsl:template>

  <xsl:template match="index-terms:index-terms" mode="generate-html5-nav">
    <xsl:apply-templates select="index-terms:grouped-and-sorted" mode="#current"/>
  </xsl:template>

  <xsl:template mode="nav-point-title" match="*[df:isTopicRef(.)] | *[df:isTopicHead(.)]">
    <xsl:variable name="navPointTitleString" select="df:getNavtitleForTopicref(.)"/>
    <xsl:sequence select="$navPointTitleString"/>
  </xsl:template>

  <xsl:template match="*[df:isTopicGroup(.)]" priority="20" mode="generate-html5-nav">
    <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current"/>
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/topic')]" mode="generate-html5-nav">
    <!-- Non-root topics generate ToC entries if they are within the ToC depth -->
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <!-- FIXME: Handle nested topics here. -->
    </xsl:if>
  </xsl:template>

  <xsl:template mode="#all" match="*[df:class(., 'map/topicref') and (@processing-role = 'resource-only')]" priority="30"/>


  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template match="*[df:isTopicHead(.)]" mode="generate-html5-nav">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>

    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="navPointId" as="xs:string"
        select="generate-id(.)"/>
      <li id="{$navPointId}">
        <xsl:sequence select="df:getNavtitleForTopicref(.)"/>
        <xsl:variable name="listItems" as="node()*">
          <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current">
            <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
              select="$tocDepth + 1"
            />
          </xsl:apply-templates>
        </xsl:variable>
        <xsl:if test="$listItems">
          <ul>
            <xsl:sequence select="$listItems"/>
          </ul>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[df:isTopicGroup(.)]" mode="nav-point-title">
    <!-- Per the 1.2 spec, topic group navtitles are always ignored -->
  </xsl:template>

<!--  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/title')]" priority="10">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
-->

  <xsl:template mode="nav-point-title" match="*[df:class(., 'topic/fn')]" priority="10">
    <!-- Suppress footnotes in titles -->
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/tm')]" mode="generate-html5-nav nav-point-title">
    <xsl:apply-templates mode="#current"/>
    <xsl:choose>
      <xsl:when test="@type = 'reg'">
        <xsl:text>[reg]</xsl:text>
      </xsl:when>
      <xsl:when test="@type = 'sm'">
        <xsl:text>[sm]</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>[tm]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template match="
    *[df:class(., 'topic/topicmeta')] |
    *[df:class(., 'map/navtitle')] |
    *[df:class(., 'topic/ph')] |
    *[df:class(., 'topic/cite')] |
    *[df:class(., 'topic/image')] |
    *[df:class(., 'topic/keyword')] |
    *[df:class(., 'topic/term')]
    " mode="generate-html5-nav">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/title')]//text()" mode="generate-html5-nav">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-html5-nav-script-includes">
      <!-- FIXME: Put includes of supporting javascript here. -->
      <script type="text/javascript" src="xxxx.js" >&#xa0;</script><xsl:sequence select="'&#x0a;'"/>
  </xsl:template>

  <xsl:template match="text()" mode="generate-html5-nav"/>

  <xsl:function name="local:isNavPoint" as="xs:boolean">
    <!-- FIXME: Factor this out to a common function library. It's also
         in HTML2 and EPUB code.
      -->
    <xsl:param name="context" as="element()"/>
    <xsl:choose>
      <xsl:when test="$context/@processing-role = 'resource-only'">
        <xsl:sequence select="false()"/>
      </xsl:when>
      <xsl:when test="df:isTopicRef($context) or df:isTopicHead($context)">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:when test="df:isTopicGroup($context)">
        <xsl:variable name="navPointTitle" as="xs:string*">
          <xsl:apply-templates select="$context" mode="nav-point-title"/>
        </xsl:variable>
        <!-- If topic head has a title (e.g., a generated title), then it
             acts as a navigation point.
          -->
        <xsl:sequence
           select="normalize-space(string-join($navPointTitle, ' ')) != ''"
        />
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>


</xsl:stylesheet>