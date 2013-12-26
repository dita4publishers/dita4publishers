<?xml version="1.0" encoding="utf-8"?>
<!--
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
-->

<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:glossdata="http://dita4publishers.org/glossdata"
  xmlns:mapdriven="http://dita4publishers.org/mapdriven"
  xmlns:enum="http://dita4publishers.org/enumerables"
  xmlns:local="urn:functions:local"
  exclude-result-prefixes="local xs df xsl relpath htmlutil index-terms mapdriven glossdata enum">

  <!--
    choose navigation markup type
    will be used later to offer alternate markup for navigation
   -->
  <xsl:template match="*" mode="choose-html5-nav-markup">
    <xsl:message> + [INFO] Generating HTML5 <xsl:value-of select="$NAVIGATIONMARKUP"/> navigation</xsl:message>

    <xsl:choose>
      <!--
          Experimental
        -->
      <xsl:when test="$NAVIGATIONMARKUP='navigation-tabbed'">
        <xsl:message> + [WARNING] This code is experimental !</xsl:message>
        <xsl:apply-templates select="." mode="generate-html5-nav-tabbed-markup"/>
      </xsl:when>

      <xsl:when test="$NAVIGATIONMARKUP='navigation-ico'">
        <xsl:message> + [WARNING] This code is experimental !</xsl:message>
        <xsl:apply-templates select="." mode="generate-html5-nav-ico-markup"/>
      </xsl:when>

      <xsl:when test="$NAVIGATIONMARKUP='navigation-whole-page'">
        <xsl:message> + [WARNING] This code is experimental !</xsl:message>
        <xsl:apply-templates select="." mode="generate-html5-nav-whole-page"/>
      </xsl:when>

      <xsl:otherwise>
        <!-- This mode generates the navigation structure (ToC) on the
                index.html page, that is, the main navigation structure.
             -->
        <xsl:apply-templates select="." mode="generate-html5-nav-page-markup"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-html5-nav">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>

    <xsl:message> + [INFO] Generating HTML5 navigation structure...</xsl:message>

    <xsl:apply-templates mode="generate-html5-nav"/>

    <xsl:if test="$generateIndexBoolean">
      <xsl:apply-templates mode="generate-html5-nav" select="$collected-data">
        <xsl:with-param name="parentId" select="'root'" as="xs:string" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:if>

    <xsl:message> + [INFO] HTML5 navigation generation done.</xsl:message>
  </xsl:template>

  <xsl:template mode="generate-html5-nav-page-markup" match="*[df:class(., 'map/map')]">
    <xsl:param name="collected-data" as="element()" tunnel="yes"/>
    <xsl:param name="documentation-title" tunnel="yes" />

    <nav class="mobile-nav">
      <ul>
        <li class="toggle-topbar menu-icon">
          <a id="toggle-nav-content" href="#{$IDLOCALNAV}">
              <xsl:call-template name="getString">
                <xsl:with-param name="stringName" select="'menu'"/>
              </xsl:call-template>
          </a>
        </li>
      </ul>

      <section class="nav-pub-title">
        <xsl:value-of select="$documentation-title" />
      </section>
    </nav>

    <nav id="{$IDLOCALNAV}" role="navigation" aria-label="Main navigation">
      <xsl:attribute name="class" select="$CLASSNAVIGATION"/>

      <div id="nav-content">

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
      </div>
    </nav>
  </xsl:template>

  <xsl:template mode="generate-html5-nav-page-markup" match="*[df:class(., 'topic/title')][not(@toc = 'no')]">
    <h2 class="nav-pub-title">
      <xsl:apply-templates/>
    </h2>
  </xsl:template>

  <xsl:template mode="generate-html5-nav" match="*[df:class(., 'topic/title')][not(@toc = 'no')]"/>

  <!-- Convert each topicref to a ToC entry. -->
  <xsl:template match="*[df:isTopicRef(.)][not(@toc = 'no')]" mode="generate-html5-nav">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:param name="rootMapDocUrl" as="xs:string" tunnel="yes"/>

    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
      <xsl:choose>
        <xsl:when test="not($topic)">
          <xsl:message> + [WARNING] generate-html5-nav: Failed to resolve topic reference to href
              "<xsl:sequence select="string(@href)"/>"</xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="targetUri"
            select="htmlutil:getTopicResultUrl($outdir, root($topic), $rootMapDocUrl)"
            as="xs:string"/>
          <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)"
            as="xs:string"/>
          <xsl:variable name="enumeration" as="xs:string?">
            <xsl:apply-templates select="." mode="enumeration"/>
          </xsl:variable>
          <xsl:variable name="self" select="generate-id(.)" as="xs:string"/>

          <!-- Use UL for navigation structure -->

          <li>
            <a href="{$relativeUri}">
              <!-- target="{$contenttarget}" -->
              <xsl:if test="$enumeration and $enumeration != ''">
                <span class="enumeration enumeration{$tocDepth}">
                  <xsl:sequence select="$enumeration"/>
                </span>
              </xsl:if>
              <xsl:apply-templates select="." mode="nav-point-title"/>
            </a>
            <xsl:if test="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
              <xsl:variable name="listItems" as="node()*">
                <!-- Any subordinate topics in the currently-referenced topic are
              reflected in the ToC before any subordinate topicrefs.
            -->
                <xsl:apply-templates mode="#current"
                  select="$topic/*[df:class(., 'topic/topic')], *[df:class(., 'map/topicref')]">
                  <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes"
                    select="$tocDepth + 1"/>
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

  <xsl:template mode="#all"
    match="*[df:class(., 'map/topicref') and (@processing-role = 'resource-only')]" priority="30"/>


  <!-- topichead elements get a navPoint, but don't actually point to
       anything.  Same with topicref that has no @href. -->
  <xsl:template match="*[df:isTopicHead(.)][not(@toc = 'no')]" mode="generate-html5-nav">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>

    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="navPointId" as="xs:string" select="generate-id(.)"/>
      <li id="{$navPointId}">
        <xsl:sequence select="df:getNavtitleForTopicref(.)"/>
        <xsl:variable name="listItems" as="node()*">
          <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current">
            <xsl:with-param name="tocDepth" as="xs:integer" tunnel="yes" select="$tocDepth + 1"/>
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





  <xsl:template match="*[df:class(., 'topic/tm')]" mode="generate-html5-nav">
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

  <xsl:template
    match="
    *[df:class(., 'topic/topicmeta')] |
    *[df:class(., 'map/navtitle')] |
    *[df:class(., 'topic/ph')] |
    *[df:class(., 'topic/cite')] |
    *[df:class(., 'topic/image')] |
    *[df:class(., 'topic/keyword')] |
    *[df:class(., 'topic/term')]
    "
    mode="generate-html5-nav">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="*[df:class(., 'topic/title')]//text()" mode="generate-html5-nav">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="*[df:class(., 'map/map')]" mode="generate-html5-nav-script-includes"/>

  <xsl:template match="text()" mode="generate-html5-nav"/>

  <xsl:template match="@*|node()" mode="fix-navigation-href">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="fix-navigation-href"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="li" mode="fix-navigation-href">
    <xsl:param name="topicRelativeUri" as="xs:string" select="''" tunnel="yes"/>
    <xsl:variable name="isActiveTrail" select="descendant-or-self::*[@href=$topicRelativeUri]"/>
    <xsl:variable name="hasChild" select="descendant::li"/>

    <xsl:variable name="hasChildClass">
      <xsl:choose>
        <xsl:when test="$hasChild">
          <xsl:value-of select="'collapsible'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'no-child'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="activeTrailClass">
      <xsl:choose>
        <xsl:when test="$isActiveTrail">
          <xsl:value-of select="' active'"/>
        </xsl:when>
        <xsl:when test="not($isActiveTrail) and $hasChild">
          <xsl:value-of select="' collapsed'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <li>
      <xsl:attribute name="class" select="concat(@class, $hasChildClass, $activeTrailClass)"/>
      <xsl:if test="text()[1]">
        <span class="navtitle">
        <xsl:value-of select="text()[1]" />
        </span>
      </xsl:if>
      <xsl:apply-templates select="*" mode="fix-navigation-href"/>
    </li>
  </xsl:template>


  <xsl:template match="a" mode="fix-navigation-href">
   <xsl:param name="topicRelativeUri" as="xs:string" select="''" tunnel="yes"/>
    <xsl:param name="relativePath" as="xs:string" select="''" tunnel="yes"/>

   <xsl:variable name="isSelected" select="@href=$topicRelativeUri"/>

    <xsl:variable name="prefix">
      <xsl:choose>
        <xsl:when test="substring(@href, 1, 1) = '#'">
          <xsl:value-of select="''"/>
        </xsl:when>
        <xsl:when test="substring(@href, 1, 1) = '/'">
          <xsl:value-of select="''"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$relativePath"/>
        </xsl:otherwise>

      </xsl:choose>
    </xsl:variable>
  <a>
    <xsl:if test="$isSelected">
      <xsl:attribute name="class" select="'selected'" />
    </xsl:if>
      <xsl:attribute name="href" select="concat($prefix, @href)"/>
      <xsl:value-of select="text()" />
    </a>
  </xsl:template>

  <xsl:template match="mapdriven:collected-data" mode="generate-html5-nav">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="enum:enumerables" mode="generate-html5-nav">
    <!-- Nothing to do with enumerables in this context -->
  </xsl:template>

  <xsl:template match="glossdata:glossary-entries" mode="generate-html5-nav">
    <xsl:message> + [INFO] dynamic ToC generation: glossary entry processing not yet
      implemented.</xsl:message>
  </xsl:template>

  <xsl:template match="index-terms:index-terms" mode="generate-html5-nav">
    <xsl:param name="has-index" as="xs:boolean" tunnel="yes" />
    <xsl:if test="$has-index">
      <li>
        <a href="generated-index.html">Index</a>
      </li>
      <xsl:apply-templates select="index-terms:grouped-and-sorted" mode="#current"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="index-terms:grouped-and-sorted" mode="generate-html5-nav">
    <xsl:param name="parentId" as="xs:string" tunnel="yes"/>

    <xsl:apply-templates
      select="index-terms:index-term |
              index-terms:index-group |
              index-terms:targets |
              index-terms:see-alsos |
              index-terms:sees
              "
      mode="#current">
      <xsl:with-param name="parentId" as="xs:string" tunnel="yes" select="generate-id(.)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="index-terms:index-group |
           index-terms:index-term"
    mode="generate-html5-nav">
    <xsl:param name="parentId" as="xs:string" tunnel="yes"/>
    <xsl:call-template name="construct-tree-item-for-group-or-term">
      <xsl:with-param name="parentId" select="$parentId" as="xs:string"/>
    </xsl:call-template>
    <xsl:apply-templates select="index-terms:* except index-terms:label " mode="#current">
      <xsl:with-param name="parentId" as="xs:string" tunnel="yes" select="generate-id(.)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="index-terms:see-also" mode="generate-html5-nav">
    <xsl:param name="parentId" as="xs:string" tunnel="yes"/>
    <xsl:call-template name="construct-tree-item-for-group-or-term">
      <xsl:with-param name="parentId" select="$parentId" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="index-terms:see-also/index-terms:label"
    mode="generate-index-term-link-text-dynamic-toc">
    <xsl:text>See also: </xsl:text>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="index-terms:see" mode="generate-dynamic-toc">
    <xsl:param name="parentId" as="xs:string" tunnel="yes"/>
    <xsl:call-template name="construct-tree-item-for-group-or-term">
      <xsl:with-param name="parentId" select="$parentId" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="index-terms:see/index-terms:label"
    mode="generate-index-term-link-text-dynamic-toc">
    <xsl:text>See: </xsl:text>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="index-terms:sub-terms" mode="generate-dynamic-toc">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="index-terms:target" mode="generate-html5-nav">
    <xsl:param name="parentId" as="xs:string" tunnel="yes"/>
    <xsl:param name="rootMapDocUrl" tunnel="yes" as="xs:string"/>
    <xsl:message> + [DEBUG] index-terms:target: @source-uri="<xsl:sequence
        select="string(@source-uri)"/>"</xsl:message>
    <xsl:variable name="topic" select="document(relpath:getResourcePartOfUri(@source-uri))"
      as="document-node()"/>

    <xsl:variable name="targetUri"
      select="htmlutil:getTopicResultUrl($outdir, $topic, $rootMapDocUrl)" as="xs:string"/>

    <xsl:variable name="relativeUri" select="relpath:getRelativePath($outdir, $targetUri)"
      as="xs:string"/>

    <xsl:variable name="self" select="generate-id(.)" as="xs:string"/>

    <xsl:call-template name="makeJsTextNode">
      <xsl:with-param name="linkObjId" select="$self"/>
      <xsl:with-param name="parentId" select="$parentId" tunnel="yes"/>
    </xsl:call-template>

    <xsl:apply-templates select="index-terms:index-term" mode="#current">
      <xsl:with-param name="parentId" as="xs:string" tunnel="yes" select="generate-id(.)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="generate-index-term-link-text-dynamic-toc" match="index-terms:target">
    <xsl:variable name="sourceUri" as="xs:string" select="@source-uri"/>
    <xsl:variable name="targetTopic" as="element()?" select="df:resolveTopicUri(., $sourceUri)"/>
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] generate-index-term-link-text-dynamic-toc: targetTopic="<xsl:sequence
          select="string($targetTopic/@id)"/></xsl:message>
    </xsl:if>
    <!--xsl:choose>
      <xsl:when test="$targetTopic">
        <xsl:sequence select="local:escapeStringforJavaScript(df:getNavtitleForTopic($targetTopic))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number count="index-terms:target" format="1"/>
      </xsl:otherwise>
    </xsl:choose-->

  </xsl:template>

  <xsl:template mode="generate-dynamic-toc" match="index-terms:original-markup"/>

  <xsl:template mode="generate-dynamic-toc" match="index-terms:label">
    <xsl:variable name="labelString">
      <xsl:apply-templates mode="dynamic-toc-index-term-label"/>
    </xsl:variable>
    <xsl:sequence select="$labelString"/>
  </xsl:template>


  <xsl:template name="construct-tree-item-for-group-or-term">
    <xsl:param name="parentId" as="xs:string" tunnel="yes"/>
    <xsl:param name="linkText">
      <xsl:apply-templates select="index-terms:label"
        mode="generate-index-term-link-text-dynamic-toc"/>
    </xsl:param>
    <xsl:if test="false()">
      <xsl:message> + [DEBUG] for <xsl:sequence select="name(.)"/>, linkText="<xsl:sequence
          select="$linkText"/>"</xsl:message>
    </xsl:if>
  </xsl:template>

  <xsl:template name="makeJsTextNode">
    <xsl:param name="linkObjId" as="xs:string"/>
    <xsl:param name="parentId" as="xs:string" tunnel="yes"/>
  </xsl:template>



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
        <xsl:sequence select="normalize-space(string-join($navPointTitle, ' ')) != ''"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>


</xsl:stylesheet>
