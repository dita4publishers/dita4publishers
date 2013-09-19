<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="relpath df"
  >
  
  <!-- =====================================================================
    DITA2InDesign: Map 2 Importable XML for InDesign
    
    Copyright (c) 2008, 2011 DITA2InDesign Project
    
    =====================================================================-->
  
<!-- Users of this module must also import this module:  
  
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
          <xsl:apply-templates select="$topic/*[df:class(., 'topic/titlealts')]/*[df:class(., 'topic/navtitle')]" mode="text-only"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$topic/*[df:class(., 'topic/title')]" mode="text-only"/>
        </xsl:otherwise>
      </xsl:choose>          
    </xsl:variable>
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] df:getNavtitleForTopicref(): returning "<xsl:sequence select="$navTitle"/>"</xsl:message>
    </xsl:if>
    <xsl:sequence select="$navTitle"/>
  </xsl:function>
  
  <xsl:function name="df:getNavtitleForTopicref" as="xs:string">
    <xsl:param name="topicref" as="element()"/>
    <xsl:choose>
      <xsl:when test="$topicref/@navtitle != ''">
        <xsl:value-of select="$topicref/@navtitle"/>
      </xsl:when>
      <xsl:when test="$topicref/@format and not(starts-with(string($topicref/@format), 'dita'))">
        <!-- FIXME: This is a quick hack. Need to use the best mode for constructing the navtitle. -->
        <xsl:variable name="text">
          <xsl:apply-templates select="$topicref/*[df:class(., 'map/topicmeta')]/*[df:class(., 'map/navtitle')]" mode="text-only"/>            
        </xsl:variable>
        <xsl:sequence select="normalize-space($text)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="targetTopic" select="df:resolveTopicRef($topicref)"/>
        <xsl:if test="$debugBoolean">
        <xsl:message> + [DEBUG] df:getNavtitleForTopicref(): targetTopic is <xsl:sequence select="concat(name($targetTopic), ': ', normalize-space($targetTopic/*[df:class(., 'topic/title')]))"/></xsl:message>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$targetTopic/*[df:class(., 'topic/titlealts')]/*[df:class(., 'topic/navtitle')]">
            <xsl:if test="$debugBoolean">
            <xsl:message> + [DEBUG] df:getNavtitleForTopicref(): target topic has a titlealts/navtitle element</xsl:message>
            <xsl:message> +                                           value is: "<xsl:sequence select="normalize-space($targetTopic/*[df:class(., 'topic/titlealts')]/*[df:class(., 'topic/navtitle')])"/>"</xsl:message>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$debugBoolean">
            <xsl:message> + [DEBUG] df:getNavtitleForTopicref(): target topic does not have a titlealts/navtitle element</xsl:message>
            <xsl:message> +                                    title is: "<xsl:sequence select="normalize-space($targetTopic/*[df:class(., 'topic/title')])"/>"</xsl:message>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$targetTopic">
            <xsl:sequence select="df:getNavtitleForTopic($targetTopic)"/>  
          </xsl:when>
          <xsl:when test="$topicref/*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/navtitle')]">
            <!-- FIXME: This is a quick hack. Need to use the best mode for constructing the navtitle. -->
            <xsl:variable name="text">
              <xsl:apply-templates select="$topicref/*[df:class(., 'map/topicmeta')]/*[df:class(., 'topic/navtitle')]" mode="text-only"/>
            </xsl:variable>
            <xsl:sequence select="normalize-space($text)"/>
          </xsl:when>          
          <xsl:otherwise>
            <xsl:sequence select="'{Failed to get navtitle for topicref}'"/>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
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
            <xsl:sequence select="$topicsWithId[1]"/>
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
      as="document-node()"
      select="if ($resourcePart = '') 
      then root($context) 
      else document($resourcePart, $context)
      "
    />
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
    <xsl:message> + [DEBUG] df:class(): classSpec="<xsl:sequence select="$classSpec"/>", <xsl:sequence select="$elem/@class"/></xsl:message>
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
    <xsl:message> + [DEBUG]   returning <xsl:sequence select="$result"/></xsl:message>
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
    <xsl:param name="rootmap" as="element()"/>
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="effectiveUri" as="xs:string"
      select="if ($context/@keyref != '')
      then df:getEffectiveUriForKeyref($rootmap, $context)
      else string($context/@href)
      "
    />
    <xsl:variable name="baseUri" as="xs:string"
       select="
    if (contains($effectiveUri, '#')) 
        then substring-before($effectiveUri, '#') 
        else normalize-space($effectiveUri)
    "/>    
    <xsl:message> + [DEBUG] df:getEffectiveTopicUri(): baseUri="<xsl:value-of select="$baseUri"/>"</xsl:message>
    <xsl:variable name="result" as="xs:string">
      <xsl:choose>
        <xsl:when test="string($context/@copy-to) != ''">
          <xsl:variable name="copyTo" select="$context/@copy-to" as="xs:string"/>
          <xsl:variable name="fullUri" select="string(resolve-uri($copyTo, base-uri($context)))" as="xs:string"/>
          <xsl:sequence select="relpath:getRelativePath(relpath:getParent(base-uri($context)), $fullUri)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$baseUri"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:variable>
    <xsl:message> + [DEBUG] df:getEffectiveTopicUri(): result="<xsl:value-of select="$result"/>"</xsl:message>
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
                        not(ancestor::*[contains(@chunk, 'to-content')])
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
    <xsl:variable name="resultId" as="xs:string">
      <xsl:choose>
        <xsl:when test="df:class(($context/ancestor-or-self::*)[last()], 'map/map')">
          <xsl:sequence select="concat(name($context), '-', count($context/preceding::*) + 1)"/>
        </xsl:when>
        <xsl:when test="df:class($context, 'topic/topic')">
          <xsl:sequence select="string($context/@id)"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Must be an element within a topic -->
          <xsl:sequence select="            
            concat(
              string-join($context/ancestor::*[df:class(.,'topic/topic')]/@id, '-'),
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
    </xsl:variable>
    <xsl:if test="$debugBoolean">    
      <xsl:message> + [DEBUG] generate-dita-id(): returning "<xsl:sequence select="$resultId"/>" for element <xsl:sequence select="name($context)"/></xsl:message>
    </xsl:if>    
    <xsl:sequence select="$resultId"/>  
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
