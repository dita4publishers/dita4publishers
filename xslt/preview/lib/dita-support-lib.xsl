<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  exclude-result-prefixes="relpath df dita-ot"
  >
  <!-- =====================================================================
       DITA Community: DITA Support Library

    Copyright (c) 2008, 2011 DITA2InDesign Project
    Copyright (c) 2011, 2014 DITA for Publishers
    Copyright (c) 2014 DITA Community Project

    NOTE: This module depends on the companion relpath_util XSLT module,
          part of the same Open Toolkit plugin.

          This module has no dependencies on the DITA Open Toolkit itself.
          It may be used by any XSLT 2 or XSLT 3 transform.

    Author: W. Eliot Kimber, drmacro@yahoo.com

    =====================================================================-->

<!--

  Depends on this module:

  <xsl:import href="relpath_util.xsl"/>

-->


  <xsl:key name="topicsById" match="*[df:class(., 'topic/topic')]" use="@id"/>

  <xsl:param name="debug" select="'false'"/>
  <xsl:variable name="debugBoolean" select="if ($debug = 'true') then true() else false()" as="xs:boolean"/>

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

  <xsl:template name="resolve-topicref">
    <xsl:param name="subordinateTopicRefs" as="element()*"/>
    <xsl:variable name="topicUri" select="@href" as="xs:string"/>
    <xsl:variable name="topicDoc" select="document($topicUri, .)"/>
    <!-- FIXME: factor out common resolution error checking -->
    <!-- FIXME: implement type= checking -->
    <!-- FIXME: handle case where there is an explicit topic ID. Right now we assume ref is to a single-topic document -->
    <xsl:message> +   Resolving topic "<xsl:sequence select="$topicUri"/>"...</xsl:message>
    <!-- Logic for when there is no topic ID on the URL: -->
    <xsl:variable name="targetTopic" as="element()?">
      <xsl:choose>
        <xsl:when test="$topicDoc/*[df:class(., 'topic/topic')]">
          <xsl:sequence select="$topicDoc/*[1]"/>
        </xsl:when>
        <xsl:when test="$topicDoc/*/*[df:class(., 'topic/topic')]">
          <xsl:sequence select="$topicDoc/*/*[df:class(., 'topic/topic')][1]"/>
            <xsl:if test="$debugBoolean">
              <xsl:message> + [DEBUG] Using first child topic <xsl:sequence select="string($topicDoc/*/*[df:class(., 'topic/topic')][1]/@id)"/> of document "<xsl:sequence select="$topicUri"/>".</xsl:message>
            </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message> - [WARNING] Document "<xsl:sequence select="$topicUri"/>" not a topic or does not contain a topic as its first child.</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$targetTopic">
       <xsl:element name="{name($targetTopic)}">
         <xsl:apply-templates select="$targetTopic/@*[name(.) != 'id']"/>
         <xsl:attribute name="id" select="df:idForTopic($topicDoc, $targetTopic)"/>
         <xsl:apply-templates select="$targetTopic/*" mode="#default"/>
         <xsl:apply-templates select="$subordinateTopicRefs" mode="pull-topics"/>
       </xsl:element>
    </xsl:if>
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

  <xsl:function name="df:getNavtitleForTopic" as="xs:string">
    <xsl:param name="topic" as="element()"/>
    <xsl:variable name="navTitle">
      <xsl:choose>
        <xsl:when test="$topic/*[df:class(., 'topic/titlealts')]/*[df:class(., 'topic/navtitle')]">
          <xsl:apply-templates select="$topic/*[df:class(., 'topic/titlealts')]/*[df:class(., 'topic/navtitle')]" mode="dita-ot:text-only"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$topic/*[df:class(., 'topic/title')]" mode="dita-ot:text-only"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] df:getNavtitleForTopicref(): returning "<xsl:sequence select="$navTitle"/>"</xsl:message>
    </xsl:if>
    <xsl:sequence select="$navTitle"/>
  </xsl:function>

  <!-- Return the navigation title for a topicref, applying the DITA-defined
       rules for getting the navigation title from any referenced topic:

       - If the topicref addresses a map:

         - The topicref does not contribute to navigation and there is
           no navigation title (submap titles are not used in normal output processing).

       - If the topicref does not address a topic:

         - Use the topicref's navtitle element or @navtitle attribute (prefer navtitle element)

         - If the topicref does not specify a navtitle, then there is no navtitle.

       - If the topicref does address a topic:

         - If @locktitle is "yes" and there is a navtitle element or @navtitle attribute,
           then use that as the navititle
         - Otherwise, use the topic's navigation title, that is, the result of calling
           getNavigationTitleForTopic() on the referenced topic.

       The navigation title is returned as a single string.

    -->
  <xsl:function name="df:getNavtitleForTopicref" as="xs:string">
    <xsl:param name="topicref" as="element()"/>

    <xsl:variable name="isLockTitle" as="xs:boolean" select="$topicref/@locktitle = ('yes')"/>
    <xsl:variable name="directNavtitle" as="xs:string" select="df:getDirectNavtitleForTopicref($topicref)"/>

    <xsl:choose>
      <!-- No navigation titles for submaps or topicgroups -->
      <xsl:when test="($topicref/@format = 'ditamap' and not($topicref/@scope = ('peer', 'external'))) or 
                      df:isTopicGroup($topicref)">
        <xsl:sequence select="''"/>
      </xsl:when>
      <!-- Topicheads must have navigation titles -->
      <xsl:when test="df:isTopicHead($topicref)">
        <xsl:sequence select="$directNavtitle"/>
      </xsl:when>
      <!-- If locktitle is yes and there's a navtitle, use it: -->
      <xsl:when test="$isLockTitle and not($directNavtitle = '')">
        <xsl:sequence select="$directNavtitle"/>
      </xsl:when>
      <!-- If resource is not a topic, then use the direct topicref: -->
      <xsl:when test="$topicref/@format and not($topicref/@format = 'dita')">
        <xsl:sequence select="$directNavtitle"/>
      </xsl:when>
      <!-- There must be a topic resource and @locktitle is "no" -->
      <xsl:otherwise>
        <xsl:variable name="targetTopic" select="df:resolveTopicRef($topicref)"/>
        <xsl:if test="$debugBoolean">
        <xsl:message> + [DEBUG] df:getNavtitleForTopicref(): targetTopic is <xsl:sequence select="concat(name($targetTopic), ': ', normalize-space($targetTopic/*[df:class(., 'topic/title')]))"/></xsl:message>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$targetTopic">
            <xsl:sequence select="df:getNavtitleForTopic($targetTopic)"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Should never get here, but just in case. -->
            <xsl:sequence select="''"/>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- Get the navigation title directly specified on a topicref, if any.

       Returns an empty string (rather than an empty sequence) if there
       is no navigation title.
    -->
  <xsl:function name="df:getDirectNavtitleForTopicref" as="xs:string">
    <xsl:param name="topicref" as="element()"/>

    <xsl:variable name="text">
      <xsl:apply-templates select="($topicref/*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/navtitle')], $topicref/@navtitle)[1]" mode="dita-ot:text-only"/>
    </xsl:variable>
    <xsl:sequence select="normalize-space($text)"/>
  </xsl:function>

  <xsl:template mode="dita-ot:text-only" match="@navtitle">
    <xsl:sequence select="string(.)"/>
  </xsl:template>

  <xsl:function name="df:getDocumentThatContainsRefTarget" as="document-node()?">
    <!-- Resolve a reference to the document that contains the ultimate reference target. -->
    <xsl:param name="context" as="element()"/>
    <xsl:sequence select="df:getDocumentThatContainsRefTarget($context, $context/@href)"/>
  </xsl:function>

  <xsl:function name="df:getDocumentThatContainsRefTarget" as="document-node()?">
    <!-- Resolve a reference to the document that contains the ultimate reference target. -->
    <xsl:param name="context" as="element()"/>
    <xsl:param name="targetUri" as="xs:string"/>

    <xsl:variable name="resourcePart" as="xs:string"
      select="
      if (contains($targetUri, '#'))
      then substring-before($targetUri, '#')
      else normalize-space($targetUri)"
    />
    <xsl:choose>
      <xsl:when test="$resourcePart = ''">
        <xsl:sequence select="root($context)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="targetDoc" select="document($resourcePart, $context)" as="document-node()?"/>
        <xsl:sequence select="$targetDoc"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="df:resolveTopicRef" as="element()?">
    <!-- Resolves a topicref to its target topic or map element, if it can be resolved -->
    <xsl:param name="context" as="element()"/><!-- Topicref element -->
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] resolveTopicRef(): base-uri($context)="<xsl:sequence select="base-uri($context)"/>"</xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="not(df:class($context, 'map/topicref'))">
        <xsl:message> - [ERROR] df:resolveTopicRef(): context element is not of class 'map/topicref', class is <xsl:sequence select="$context/@class"/></xsl:message>
        <xsl:sequence select="/.."/>
      </xsl:when>
      <xsl:when test="$context/@format and not($context/@format = 'dita') and not($context/@format = 'ditamap')">
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] df:resolveTopicRef(): Format is <xsl:value-of select="$context/@format"/>, skipping.</xsl:message>
        </xsl:if>
        <xsl:sequence select="()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] df:resolveTopicRef(): context is a topicref.</xsl:message>
          <xsl:message> + [DEBUG] df:resolveTopicRef(): href="<xsl:value-of select="$context/@href"/>"</xsl:message>
        </xsl:if>
        <xsl:variable name="topicUri" as="xs:string"
          select="df:getEffectiveTopicUri($context)"/>
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] df:resolveTopicRef(): topicUri="<xsl:sequence select="$topicUri"/>"</xsl:message>
        </xsl:if>
        <xsl:variable name="topicFragId" as="xs:string"
           select="if (contains($context/@href, '#')) then substring-after($context/@href, '#') else ''"/>
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] df:resolveTopicRef(): topicFragId="<xsl:sequence select="$topicFragId"/>"</xsl:message>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$topicUri = '' and $topicFragId = ''">
            <xsl:if test="$debugBoolean">
            <xsl:message> + [DEBUG] df:resolveTopicRef(): topicUri is '', return empty list.</xsl:message>
            </xsl:if>
            <xsl:sequence select="/.."/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$debugBoolean">
            <xsl:message> + [DEBUG] df:resolveTopicRef(): topicUri is a string, trying to resolve...</xsl:message>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="true()"><!-- doc-available does not appear to be reliable function -->
<!--                <xsl:when test="doc-available(resolve-uri($topicUri, base-uri($context)))">-->
                <xsl:if test="$debugBoolean">
                  <xsl:message> + [DEBUG] df:resolveTopicRef(): target document is available.</xsl:message>
                </xsl:if>
                <xsl:sequence select="df:resolveTopicUri($context, $topicUri)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="$debugBoolean">
                  <xsl:message> + [DEBUG] df:resolveTopicRef(): document at uri "<xsl:sequence select="resolve-uri($topicUri, base-uri($context))"/>" is not available, returning empty list</xsl:message>
                </xsl:if>
                <xsl:sequence select="/.."/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="df:resolveTopicUri" as="element()?">
    <!-- Resolves a URI reference to a topic. -->
    <xsl:param name="context" as="element()"/>
    <xsl:param name="topicUri" as="xs:string"/>

    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] df:resolveTopicUri(): topicUri: <xsl:sequence select="$topicUri"/></xsl:message>
    </xsl:if>

    <xsl:variable name="topicResourcePart" as="xs:string"
      select="if (contains($topicUri, '#')) then substring-before($topicUri, '#') else $topicUri"/>
    <xsl:variable name="topicFragId" as="xs:string"
      select="if (contains($topicUri, '#')) then substring-after($topicUri, '#') else ''"/>

    <xsl:variable name="topicDoc"
      select="if ($topicResourcePart != '')
      then document($topicResourcePart, $context)
      else root($context)"/>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] df:resolveTopicUri(): target document resolved: <xsl:sequence select="count($topicDoc) > 0"/></xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$topicFragId = ''">
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] df:resolveTopicUri(): No explicit fragment identifier, select first topic in document in document order</xsl:message>
        </xsl:if>
        <!-- No explicit fragment identifier, select first topic in document in document order -->
        <xsl:choose>
          <xsl:when test="$topicDoc/*[df:class(., 'topic/topic')]">
            <xsl:if test="$debugBoolean">
              <xsl:message> + [DEBUG] df:resolveTopicUri(): root of topicDoc is a topic, returning root element.</xsl:message>
            </xsl:if>
            <xsl:sequence select="$topicDoc/*[1]"/>
          </xsl:when>
          <xsl:when test="$topicDoc/*/*[df:class(., 'topic/topic')]">
            <xsl:if test="$debugBoolean">
              <xsl:message> + [DEBUG] df:resolveTopicUri(): child root of topicDoc is a topic, returning first child topic.</xsl:message>
            </xsl:if>
            <xsl:sequence select="$topicDoc/*/*[df:class(., 'topic/topic')][1]"/>
            <xsl:if test="$debugBoolean">
              <xsl:message> + [INFO] Using first child topic <xsl:sequence select="string($topicDoc/*/*[df:class(., 'topic/topic')][1]/@id)"/> of document "<xsl:sequence select="$topicUri"/>".</xsl:message>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$topicDoc/*[df:class(., 'map/map')]">
            <xsl:if test="$debugBoolean">
              <xsl:message> + [DEBUG] df:resolveTopicUri(): root of topicDoc is a map, returning root element.</xsl:message>
            </xsl:if>
            <xsl:sequence select="$topicDoc/*[1]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message> - [WARNING] Document "<xsl:sequence select="$topicUri"/>" not a topic or map or does not contain a topic as its first child.</xsl:message>
            <xsl:sequence select="/.."/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- Explicit fragment ID, try to resolve it -->
        <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] df:resolveTopicUri(): Explicit fragment identifier, resolving it.</xsl:message>
        </xsl:if>
        <xsl:variable name="topicsWithId" select="key('topicsById', $topicFragId, $topicDoc)"/>
        <xsl:choose>
          <xsl:when test="count($topicsWithId) = 0">
            <xsl:message> - [ERROR] df:resolveTopicUri(): Failed to find topic with fragment identifier "<xsl:sequence select="$topicFragId"/>" in topic document "<xsl:sequence select="base-uri($topicDoc)"/>"</xsl:message>
            <xsl:sequence select="/.."/>
          </xsl:when>
          <xsl:when test="count($topicsWithId) > 1">
            <xsl:message> - [WARNING] df:resolveTopicUri(): found multiple topics with fragment identifier "<xsl:sequence select="$topicFragId"/>", using first one found.</xsl:message>
            <xsl:sequence select="$topicsWithId[1]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="resultTopic" as="element()" select="$topicsWithId[1]"/>
            <xsl:if test="$debugBoolean">
              <xsl:message>+ [DEBUG] df:resolveTopicUri(): fragment identifier addressed topic:
<xsl:sequence select="$resultTopic"/>
</xsl:message>
            </xsl:if>
            <xsl:sequence select="$resultTopic"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>

  <xsl:function name="df:resolveTopicElementRef">
    <!-- Resolves an href to an element within a topic. -->
    <xsl:param name="context" as="element()"/><!-- Referencing element -->
    <xsl:param name="uri" as="xs:string"/><!-- The URI to be resolved -->
    <xsl:variable name="resourcePart"
      select="if (contains($uri, '#'))
        then substring-before($uri, '#')
        else $uri
        "/>
    <xsl:variable name="fragmentId"
      select="if (contains($uri, '#'))
      then substring-after($uri, '#')
      else $uri
      "/>
    <xsl:variable name="containingDoc"
      as="document-node()?"
      select="if ($resourcePart = '')
      then root($context)
      else document($resourcePart, $context)
      "
    />
    <xsl:choose>
      <xsl:when test="not($containingDoc)">
        <xsl:message> - [ERROR] Failed to resolve URI "<xsl:sequence select="$uri"/>" to a topic.</xsl:message>
        <xsl:sequence select="()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="topicId" as="xs:string"
          select="if (contains($fragmentId, '/'))
          then substring-before($fragmentId, '/')
          else $fragmentId"
        />
        <xsl:variable name="elemId" as="xs:string"
          select="substring-after($fragmentId, '/')"
        />
        <xsl:variable name="targetTopic" as="element()?"
          select="key('topicsById', $topicId, $containingDoc)"
        />
         <xsl:if test="$debugBoolean">
          <xsl:message> + [DEBUG] resolveTopicElementRef():
              +        $context="<xsl:sequence select="$context"/>"
              +        $resourcePart="<xsl:sequence select="$resourcePart"/>"
              +        $fragmentId="<xsl:sequence select="$fragmentId"/>"
              +        $topicId="<xsl:sequence select="$topicId "/>"
              +        $elemId="<xsl:sequence select="$elemId "/>"
              +        $targetTopic="<xsl:sequence select="$targetTopic/@id"/>"
            </xsl:message>
         </xsl:if>
        <xsl:choose>
          <xsl:when test="$targetTopic">
            <xsl:choose>
              <xsl:when test="$elemId != ''">
                <xsl:variable name="targetElement" as="element()?"
                  select="$targetTopic//*[@id = $elemId][count($targetTopic|./ancestor::*[df:class(., 'topic/topic')][1]) = 1]"
                />
                <xsl:sequence select="$targetElement"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:sequence select="$targetTopic"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message> - [ERROR] Failed to resolve URI "<xsl:sequence select="$uri"/>" to a topic.</xsl:message>
            <xsl:sequence select="()"/>
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

      <!-- '\$" in the regex is a workaround for a bug in MarkLogic 3.x and for a common user
         error, where trailing space in class= attribute is dropped.
      -->
    <xsl:variable name="normalizedClassSpec" as="xs:string" select="normalize-space($classSpec)"/>
    <xsl:variable name="result"
       select="matches($elem/@class,
                       concat(' ', $normalizedClassSpec, ' | ', $normalizedClassSpec, '$'))"
       as="xs:boolean"/>

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

  <xsl:function name="df:isTopicHead" as="xs:boolean">
    <!-- Returns true if the topicref has a navtitle but no href or keyref -->
    <xsl:param name="context" as="element()"/>

<!--    <xsl:message>+ [DEBUG] isTopicHead(): @class=<xsl:sequence select="string($context/@class)"/></xsl:message>-->
    <xsl:variable name="result"  as="xs:boolean"
      select="df:class($context, 'map/topicref') and
              (not($context/@href) or $context/@href = '') and
              (not($context/@keyref) or $context/@keyref = '') and
              ($context/@navtitle != '' or
               $context/*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/navtitle')])"/>
<!--    <xsl:message>+ [DEBUG] isTopicHead(): returning <xsl:sequence select="$result"/></xsl:message>-->
    <xsl:sequence select="$result"/>
  </xsl:function>

  <xsl:function name="df:isTopicGroup" as="xs:boolean">
    <!-- Returns true if the topicref has no navititle and no href or keyref -->
    <xsl:param name="context" as="element()"/>

    <xsl:variable name="classIsTopicgroup" as="xs:boolean"
      select="df:class($context, 'mapgroup-d/topicgroup')"
    />

    <xsl:variable name="classIsTopicrefOrTopichead" as="xs:boolean"
      select="df:class($context, 'map/topicref') or
              df:class($context, 'mapgroup-d/topichead')"
    />
    <xsl:variable name="noHrefOrKeyref" as="xs:boolean"
      select="
       ((not($context/@href) or
        ($context/@href = '')) and
        (not($context/@keyref) or
         ($context/@keyref = '')))"
    />
    <xsl:variable name="noNavtitleAtt" as="xs:boolean"
      select="($context/@navtitle = '') or not($context/@navtitle)"
    />
    <xsl:variable name="noNavtitleElem" as="xs:boolean"
      select="not($context/*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')])"/>
<!-- <xsl:message>+ [DEBUG]   isTopicGroup(): noNavtitleElem=<xsl:sequence select="$noNavtitleElem"/></xsl:message>-->

    <xsl:variable name="result" as="xs:boolean"
      select="$classIsTopicgroup or
      ($classIsTopicrefOrTopichead and
       $noHrefOrKeyref and
       $noNavtitleAtt and
       $noNavtitleElem)"/>
<!--    <xsl:message>+ [DEBUG]   isTopicGroup(): returning=<xsl:sequence select="$result"/></xsl:message>-->
    <xsl:sequence select="$result"/>
  </xsl:function>

  <xsl:function name="df:isTopicRef" as="xs:boolean">
    <!-- Returns true if the topicref points to something -->
    <xsl:param name="context" as="element()"/>
<!--    <xsl:message>+ [DEBUG] isTopicRef(): context=<xsl:sequence select="name($context), ', id=', string($context/@id)"/></xsl:message>-->

    <xsl:variable name="result"
      select="df:class($context, 'map/topicref') and
      (($context/@href and $context/@href != '') or
       ($context/@keyref and $context/@keyref != ''))"/>

<!--        <xsl:message>+ [DEBUG]   isTopicRef(): returning=<xsl:sequence select="$result"/></xsl:message>-->
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

  <xsl:function name="df:getEffectiveTopicUri">
    <xsl:param name="context" as="element()"/>
    <xsl:sequence
      select="df:getEffectiveTopicUri(root($context)/*, $context)"/>
  </xsl:function>

  <xsl:function name="df:getEffectiveTopicUri">
    <!-- Returns the URI, including fragment identifier,
         for the resource ultimately addressed by
         a topicref. Redirects through key references
         if necessary.
      -->
    <xsl:param name="rootmap" as="element()"/>
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="effectiveUri" as="xs:string"
      select="if ($context/@keyref != '')
      then df:getEffectiveUriForKeyref($rootmap, $context)
      else string($context/@href)
      "
    />
    <xsl:variable name="baseUri" as="xs:string"
       select="relpath:getResourcePartOfUri($effectiveUri)
    "/>
    <xsl:variable name="fragmentId" as="xs:string"
      select="relpath:getFragmentId($effectiveUri)"
    />
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] df:getEffectiveTopicUri(): baseUri="<xsl:value-of select="$baseUri"/>"</xsl:message>
    </xsl:if>

    <xsl:variable name="resultBase" as="xs:string">
      <xsl:choose>
        <xsl:when test="string($context/@copy-to) != '' and not(df:inChunk($context))">
          <!-- If copy-to is in effect, then we have to replace the filename part of the
               base URI with the value specified in the @copy-to attribute.

               But only if we are not already within a chunk.

            -->
          <xsl:variable name="copyTo" select="$context/@copy-to" as="xs:string"/>
          <xsl:variable name="fullUri" select="string(resolve-uri($copyTo, base-uri($context)))" as="xs:string"/>
          <xsl:sequence select="relpath:getRelativePath(relpath:getParent(base-uri($context)), $fullUri)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$baseUri"/>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:variable>
    <xsl:variable name="result" as="xs:string"
      select="if ($fragmentId = '')
      then $resultBase
      else concat($resultBase, '#', $fragmentId)
      "
    />
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] df:getEffectiveTopicUri(): result="<xsl:value-of select="$result"/>"</xsl:message>
    </xsl:if>
    <xsl:sequence select="$result"/>
  </xsl:function>

  <xsl:function name="df:getEffectiveUriForKeyref" as="xs:string">
    <!-- Given an element with a @keyref attribute, returns
         the URI of the ultimate resource bound to the referenced
         key, as defined in the specified root map (note, the map
         needs to be a resolved map).
      -->
    <xsl:param name="rootmap" as="element()"/>
    <xsl:param name="context" as="element()"/>

    <xsl:variable name="keyref"
      select="string($context/@keyref)"
      as="xs:string"/>
    <!-- A keyref may be keyref="keyname" or keyref="keyname/elementId" -->
    <xsl:variable name="keyname" as="xs:string"
      select="if (contains($keyref, '/'))
      then tokenize($keyref, '/')[1]
      else $keyref"
    />

    <!-- Now lookup key definition in the map -->
    <xsl:variable name="keyMatchRegex" as="xs:string"
        select="concat('^', $keyname, '$', '|', '^', $keyname, ' ', '|', ' ', $keyname, '$')"
    />
    <!-- First definition in map wins -->
    <xsl:variable name="keydef" as="element()?"
      select="($rootmap//*[df:class(., 'map/topicref')][matches(@keys, $keyMatchRegex)])[1]"
    />
    <xsl:choose>
      <xsl:when test="$keydef">
        <xsl:choose>
          <xsl:when test="$keydef/@keyref != ''">
            <xsl:sequence select="df:getEffectiveUriForKeyref($rootmap, $keydef)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="string($keydef/@href)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- If there's no keydef for the key, return the @href value, if any.
          -->
        <xsl:sequence select="string($context/@href)"/>
      </xsl:otherwise>
    </xsl:choose>

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

  <!-- Given a (resolved) map, constructs the sequence of references
       to unique documents (not necessarily unique topics since
       multiple topics may be chunked into a single document).
    -->
  <xsl:function name="df:getUniqueTopicrefs" as="element()*">
    <xsl:param name="map" as="element()"/>
    <xsl:variable name="result" as="element()*">
      <!-- Exclude resource-only topicrefs and topicrefs
           subordinate to topicrefs with @chunk='to-content'
        -->
      <xsl:for-each-group
        select="$map//*[df:isTopicRef(.) and
                        not(@processing-role = 'resource-only') and
                        not(df:topicrefIsInChunk(.))
                        ]"
        group-by="base-uri(df:resolveTopicRef(.))"
        >

        <xsl:if test="false()">
          <xsl:message> + [DEBUG] topicref: grouping-key="<xsl:sequence select="current-grouping-key()"/>", href="<xsl:sequence select="string(current-group()[1]/@href)"/>"
          </xsl:message>
        </xsl:if>
        <xsl:sequence select="current-group()[1]"/>
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="df:topicrefIsInChunk" as="xs:boolean">
    <!-- Returns true if the topicref is a direct descendant of a topicref
         that establishes a to-content chunk and is not itself a to-content
         chunking topicref.
      -->
    <xsl:param name="topicref" as="element()"/>
    <!-- The only options for chunking are to-content and to-navigation,
         so if any ancestor specifies to-content for @chunk we are in a chunk
         unless we start our own chunk. The to-navigation value has no effect
         on content chunking.
         
         Likewise, the various select values have no effect on whether or not
         the referenced topic is in a chunk (I think).
      -->
    <xsl:variable name="result" as="xs:boolean"
      select="$topicref/ancestor::*[contains(@chunk, 'to-content')] and 
              not(contains($topicref/@chunk, 'to-content'))"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>

   <!-- Given a (resolved) map, constructs the sequence of references
       to unique documents (not necessarily unique topics since
       multiple topics may be chunked into a single document).
    -->
  <xsl:function name="df:getUniqueTopicrefsFromChunkedMap" as="element()*">
    <xsl:param name="map" as="element()"/>
    <xsl:variable name="result" as="element()*">
      <!-- Exclude resource-only topicrefs and topicrefs
           subordinate to topicrefs with @chunk='to-content'
        -->
      <xsl:for-each-group
        select="$map//*[df:isTopicRef(.) and
                        not(@processing-role = 'resource-only')
                        ]"
        group-by="base-uri(df:resolveTopicRef(.))"
        >

        <xsl:if test="false()">
          <xsl:message> + [DEBUG] topicref: grouping-key="<xsl:sequence select="current-grouping-key()"/>", href="<xsl:sequence select="string(current-group()[1]/@href)"/>"
          </xsl:message>
        </xsl:if>
        <xsl:sequence select="current-group()[1]"/>
      </xsl:for-each-group>
    </xsl:variable>
    <xsl:sequence select="$result"/>
  </xsl:function>

  <!-- Given a (resolved) map, constructs the sequence of references
       to unique documents (not necessarily unique topics since
       multiple topics may be chunked into a single document).
    -->
  <xsl:function name="df:mapIsChunkToContent" as="xs:boolean">
    <xsl:param name="map" as="element()"/>
    <xsl:value-of select="if ($map[contains(@chunk, 'to-content')]) then true() else false()" />
  </xsl:function>

  <xsl:template match="*" priority="-1" mode="used-topics resolve-maprefs ">
    <!-- Copy elements that are unstyled or that do not establish paragraph contexts -->
    <xsl:call-template name="copy-element"/>
  </xsl:template>

  <xsl:template name="copy-element">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="copy-element" match="text()">
    <xsl:copy/>
  </xsl:template>

  <xsl:function name="df:reportTopicref" as="node()*">
    <xsl:param name="topicref" as="element()*"/>
    <xsl:text>&#x0a;</xsl:text>
    <xsl:apply-templates select="$topicref" mode="topicref-report"/>
  </xsl:function>

  <xsl:function name="df:generate-dita-id" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <!-- Constructs an ID that should be unique within the context
         of the root map. However, without a topicref to provide
         unambiguous context there may be cases where two elements
         happen to produce the same ID value.
      -->
    <xsl:sequence select="df:generate-dita-id($context, ())"/>
  </xsl:function>

  <xsl:function name="df:generate-dita-id" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:param name="topicref" as="element()?"/>
    <!-- NOTE: The two-parameter form of this method requires that all
               users pass in the same topicref in order to get the same
               ID.
      -->
    <!-- Generates an ID that should be unique within the scope
         of the root map.

         This transform assumes that the input map is a single-document
         resolved map, e.g., as produced by the Open Toolkit preprocessing.

         NOTE: If the topicref parameter is not specified there is a chance
               that the generated ID may not be unique if the containing
               topic is used multiple times in the map.
      -->
    <xsl:variable name="resultId" as="xs:string">
      <xsl:choose>
        <xsl:when test="df:class(($context/ancestor-or-self::*)[last()], 'map/map')">
          <xsl:sequence select="concat(name($context), '-', count($context/preceding::*) + 1)"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Non-map element -->
          <xsl:variable name="rootIdComponent" as="xs:string">
            <!-- This is the key part of the ID because it ensures that
                 all the other parts will be in a unique context.

                 This ID needs to be globally unique within the root map
                 context. We can get that either by getting the key or
                 generated-id() value for the topicref, or, if there's no
                 topicref, then using the @xtrf and @xtrc values for the
                 root topic, which should be unique (but in the case where the
                 same topic is used multiple times in a map, may not be).
               -->
             <xsl:choose>
               <xsl:when test="$topicref">
                 <!-- If the topicref has an associated key name, use
                      that so that the generated ID is tied to something
                      obvious, otherwise just generate an ID in the usual
                      XPath way.
                   -->
                 <xsl:sequence select="
                   if ($topicref/@keys)
                      then (tokenize(string($topicref/@keys), ' ')[1])
                      else generate-id($topicref)"></xsl:sequence>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:choose>
                   <xsl:when test="$context/ancestor-or-self::*[@xtrf]">
                     <xsl:variable name="ancestor" as="element()"
                       select="($context/ancestor-or-self::*[@xtrf])[last()]"
                     />
                     <xsl:sequence select="string(df:checksum(concat($ancestor/@xtrf, $ancestor/@xtrc)))"/>
                   </xsl:when>
                   <xsl:otherwise>
                     <!-- No @xtrf, drop back and punt by hashing the text value of the containing document

                          This is not 100% reliable but it's the best we have at this point.
                     -->
                     <xsl:sequence select="string(df:checksum(string(root($context))))"/>
                   </xsl:otherwise>
                 </xsl:choose>
               </xsl:otherwise>
             </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="df:class($context, 'topic/topic')">
              <xsl:sequence select="concat('id-', $rootIdComponent, '-', string($context/@id))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="topicId" as="xs:string?"
                select="($context/ancestor::*[df:class(.,'topic/topic')]/@id)[last()]"
              />
              <!-- Must be an element within a topic or a topicref -->
              <xsl:sequence select="
                concat('id-', $rootIdComponent, '-',
                  if ($topicId) then concat($topicId, '-') else '',
                  if ($context/@id) then concat('-',string($context/@id))
                  else
                  '-',
                  name($context), '-',
                  count($context/preceding::*) + 1,
                  '-',
                  count($context/following::*),
                  '-',
                  string-length(string($context))
                )"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] generate-dita-id(): returning "<xsl:sequence select="$resultId"/>" for element <xsl:sequence select="name($context)"/></xsl:message>
    </xsl:if>
    <xsl:sequence select="$resultId"/>
  </xsl:function>

  <xsl:function name="df:getIdForElement" as="xs:string">
    <xsl:param name="context" as="element()"/>

    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="$context/@id">
          <xsl:value-of select="normalize-space($context/@id)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id($context)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <!-- type is topicref -->
      <xsl:when test="df:class($context, 'map/topicref')">
        <!--
          the id in that case is aways the topic ID
          We might consider adding a random number to prevent conflict
          in case an id has been used twice.
        -->
        <xsl:value-of select="substring-after($context/@href, '#')"/>
      </xsl:when>

      <!-- type is topic/topic with no ancestors -->
      <xsl:when test="df:class($context, 'topic/topic')">
        <xsl:value-of select="$id" />
      </xsl:when>

       <!-- type is topic/topic with ancestors -->
      <xsl:otherwise>
        <xsl:value-of select="concat($context/ancestor::*[contains(@class, 'topic/body ')]/parent::*/@id, '-', $id)"/>
      </xsl:otherwise>

    </xsl:choose>

  </xsl:function>

  <xsl:function name="df:getSectionId" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <!-- Given an element, return the id that should be used to reference it.

         This function is used mostly for getting IDs for sections to be
         referenced by generated links (e.g., mini ToCs that need to include
         sections (even though, per the DITA spec, sections should not be
         included in navigation).
      -->

    <!-- NOTE: The rules for ID reference as defined in the DITA spec are that
           when an ID is duplicated within a topic, the first occurence of that
           ID is the one you get. For DITA 1.3 this is clarified as also applying
           to this-topic fragment IDs and IDs included via conref.

           Therefore, there's no need to worry about duplicate explicit IDs
           on sections.
  -->


    <xsl:variable name="suffixId" as="xs:string" select="if ($context/@id) then $context/@id else generate-id($context)" />

    <!-- NOTE: This matches the base logic for combining topic and element IDs, namely two underscores between them. -->
    <xsl:variable name="sectionId" select="if (df:class($context, 'topic/topic'))
                 then $context/@id
                 else concat(normalize-space($context/ancestor::*[df:class(., 'topic/topic')][1]/@id), 
                             '__', 
                             normalize-space($suffixId))"
    />
    <xsl:value-of select="$sectionId"/>
  </xsl:function>

  <xsl:function name="df:getContainingTopic" as="element()?">
    <xsl:param name="context" as="element()"/>
    <!-- Given an element, returns the topic element that contains it, if any.
      If the element is a topic element, returns its parent topic or nothing
      if the element is a root topic. -->
    <xsl:variable name="result" as="element()?"
      select="$context/ancestor::*[df:class(., 'topic/topic')][1]"
    />

    <xsl:sequence select="$result"/>
  </xsl:function>

  <xsl:function name="df:isResourceOnly" as="xs:boolean">
    <xsl:param name="topicrefElem" as="element()"/>
    <!-- Returns true() if the element is a resource-only topicref -->
    <xsl:variable name="result" select="$topicrefElem/@processing-role = 'resource-only'" as="xs:boolean"/>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] df:isResourceOnly(): &lt;<xsl:sequence select="name($topicrefElem)"/> processing-role=<xsl:sequence select="string($topicrefElem/@processing-role)"/>&gt;</xsl:message>
    </xsl:if>
    <xsl:sequence select="$result"/>
  </xsl:function>

    <!-- NOTE: The checksum and fletcher16 functions developed by LarsH
         as posted on StackOverflow here:

         http://stackoverflow.com/questions/6753343/using-xsl-to-make-a-hash-of-xml-file

      -->
    <xsl:function name="df:checksum" as="xs:integer">
        <xsl:param name="str" as="xs:string"/>
        <xsl:variable name="codepoints" select="string-to-codepoints($str)"/>
        <xsl:value-of select="df:fletcher16($codepoints, count($codepoints), 1, 0, 0)"/>
    </xsl:function>

    <xsl:function name="df:fletcher16">
        <xsl:param name="str" as="xs:integer*"/>
        <xsl:param name="len" as="xs:integer" />
        <xsl:param name="index" as="xs:integer" />
        <xsl:param name="sum1" as="xs:integer" />
        <xsl:param name="sum2" as="xs:integer"/>
        <xsl:choose>
            <xsl:when test="$index ge $len">
                <xsl:sequence select="$sum2 * 256 + $sum1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="newSum1" as="xs:integer"
                    select="($sum1 + $str[$index]) mod 255"/>
                <xsl:sequence select="df:fletcher16($str, $len, $index + 1, $newSum1,
                        ($sum2 + $newSum1) mod 255)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

   <xsl:function name="df:isInline" as="xs:boolean">
      <xsl:param name="elem"/>
      <xsl:variable name="result" as="xs:boolean">
         <xsl:choose>
            <!-- Don't treat task/cmd as an inline even though it is a specializtion
             of topic/ph. Add other such exceptions here, as needed. -->
            <xsl:when test="df:class($elem, 'task/cmd')">
               <xsl:value-of select="false()"/>
            </xsl:when>
            <!-- Classes that are more likely to occur have been put near the front
            so that the XSLT processor can exit the test sooner. Note that this function
            will also match an element that is a specialization of any of these classes
            (except for <cmd>). -->
            <xsl:when
               test="df:class($elem, 'topic/ph')
               or df:class($elem, 'topic/indexterm')
               or df:class($elem, 'topic/keyword')
               or df:class($elem, 'topic/xref')
               or df:class($elem, 'topic/alt')
               or df:class($elem, 'topic/boolean')
               or df:class($elem, 'topic/cite')
               or df:class($elem, 'topic/data')
               or df:class($elem, 'topic/data-about')
               or df:class($elem, 'topic/draft-comment')
               or df:class($elem, 'topic/fn')
               or df:class($elem, 'topic/foreign')
               or df:class($elem, 'topic/image')
               or df:class($elem, 'topic/index-base')
               or df:class($elem, 'topic/indextermref')
               or df:class($elem, 'topic/q')
               or df:class($elem, 'topic/required-cleanup')
               or df:class($elem, 'topic/state')
               or df:class($elem, 'topic/term')
               or df:class($elem, 'topic/text')
               or df:class($elem, 'topic/tm')
               or df:class($elem, 'topic/unknown')">
               <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="false()"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:sequence select="$result"/>
   </xsl:function>


   <!-- RESTRICTION: These elements must allow <p> as a child element. -->
   <!-- Note that this function will also match an element that is a
        specialization of any of these classes -->
   <xsl:function name="df:isWrapMixed" as="xs:boolean">
      <xsl:param name="elem"/>
      <xsl:variable name="result"
         select="
         df:class($elem, 'topic/abstract') or
         df:class($elem, 'topic/bodydiv') or
         df:class($elem, 'topic/dd') or
         df:class($elem, 'topic/entry') or
         df:class($elem, 'topic/example') or
         df:class($elem, 'topic/itemgroup') or
         df:class($elem, 'topic/li') or
         df:class($elem, 'topic/lines') or
         df:class($elem, 'topic/lq') or
         df:class($elem, 'topic/note') or
         df:class($elem, 'topic/section') or
         df:class($elem, 'topic/sectiondiv') or
         df:class($elem, 'topic/stentry')
         "
         as="xs:boolean"/>
      <xsl:sequence select="$result"/>
   </xsl:function>


  <xsl:function name="df:inChunk" as="xs:boolean">
    <!-- Returns true if the context topicref is within
         the context of a topicref that generates a new content
         chunk (e.g., chunk="to-content select-branch").

       -->
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="nearestChunkSpecifier" as="element()?"
      select="$context/ancestor::*[@chunk != ''][1]"
    />
    <xsl:variable name="chunkSpec" as="xs:string?"
      select="$nearestChunkSpecifier/@chunk"
    />
    <xsl:variable name="result" as="xs:boolean"
      select="contains($chunkSpec, 'to-content') and
              (contains($chunkSpec, 'select-branch') or
               contains($chunkSpec, 'select-document'))"
    />
    <xsl:sequence select="$result"/>
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

</xsl:stylesheet>
