<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:local="http://www.example.com/functions/local"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="local xs df relpath"
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
        
        Copyright (c) 2009, 2015 DITA For Publishers
        
        ==================================================== -->
 
<!--
  <xsl:import href="dita-support-lib.xsl"/>
  <xsl:import href="relpath_util.xsl"/>
-->
 <xsl:template match="/*" mode="resolve-map">
   <xsl:message> + [INFO] Root element in mode resolve-map was not a map, got <xsl:sequence select="name(.)"/>[class=<xsl:sequence select="string(@class)"/></xsl:message>
   <map class="- map/map " xml:base="{base-uri(.)}"> 
     <topicref class="- map/topicref "
        href="{base-uri(.)}"/>
   </map>
 </xsl:template>
  
  <xsl:template match="/*[df:class(., 'map/map')]" mode="resolve-map" priority="10">
    <xsl:param name="map-base-uri" as="xs:string" tunnel="yes"/>
    <xsl:message> + [INFO] resolve-map(): Constructing resolved map...</xsl:message>
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] resove-map(): base-uri(.)="<xsl:sequence select="base-uri(.)"/></xsl:message>
    </xsl:if>    
      <xsl:copy copy-namespaces="no">
        <xsl:attribute name="xml:base" select="$map-base-uri"/>
        <xsl:apply-templates select="node() | @*" mode="#current">
          <xsl:with-param name="resolvedMapBaseUri" select="base-uri(.)" as="xs:string" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:copy>
    <xsl:message> + [INFO]</xsl:message>
    <xsl:message> + [INFO] resolve-map(): Resolved map constructed.</xsl:message>
    <xsl:message> + [INFO]</xsl:message>
  </xsl:template>
  
  <xsl:template mode="resolve-map" match="@*">
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG]   Default attribute handling: <xsl:sequence select="name(..)"/>/@<xsl:sequence select="name(.)"/>="<xsl:sequence select="string(.)"/>"</xsl:message>
    </xsl:if>
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template mode="resolve-map" match="*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'map/topicref') and @processing-role = 'resource-only']" mode="resolve-map"
    priority="10"
    >
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>    
  </xsl:template>
  
  <xsl:template match="*[(df:isTopicHead(.))]" mode="resolve-map">
    <xsl:param name="parentHeadLevel" as="xs:integer" tunnel="yes"/>
    <!-- If topichead's processing-role is resource only then set
         head level to -1 to indicate we're not in the main hierarchy.
       -->
    <xsl:variable name="myHeadLevel" 
      select="
      if (not(@processing-role = 'resource-only'))
          then $parentHeadLevel + 1
          else -1
      "
    />
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] resolve-map():  ** For topic head "<xsl:sequence select="name(.)"/>", parentHeadLevel=<xsl:sequence select="$parentHeadLevel"/>, myHeadLevel=<xsl:sequence select="$myHeadLevel"/></xsl:message>
    </xsl:if>
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
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] resolve-map(): ** Processing topic group "<xsl:sequence select="name(.)"/>"</xsl:message>
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="#current"/>
    </xsl:copy>    
  </xsl:template>
  
  <xsl:template match="@href" priority="10" mode="resolve-map">
    <!-- @href[../*[df:class(., 'map/topicref')]] -->
    <xsl:param name="resolvedMapBaseUri" as="xs:string" tunnel="yes"/>
    <xsl:variable name="baseUri" select="base-uri(.)"/>
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] resolve-map: @href, baseUri="<xsl:sequence select="$baseUri"/>"</xsl:message>
    </xsl:if>
    <xsl:variable name="originalUri"  as="xs:string"
      select="relpath:newFile(relpath:getParent($baseUri), string(.))"
    />
    <!-- resolvedMapBaseUri is the URI of the document itself, not its containing directory. -->
    <xsl:variable name="newHrefValue" as="xs:string"
      select="relpath:getRelativePath(relpath:getParent($resolvedMapBaseUri), $originalUri)"
    />
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] resolve-map():  ** Handling topicref/@href. Original href="<xsl:sequence select="string(.)"/>"</xsl:message>
      <xsl:message> + [DEBUG]     resolvedMapBaseUri="<xsl:sequence select="$resolvedMapBaseUri"/>"</xsl:message>
      <xsl:message> + [DEBUG]     baseUri=           "<xsl:sequence select="$baseUri"/>"</xsl:message>
      <xsl:message> + [DEBUG]     originalUri=       "<xsl:sequence select="$originalUri"/>"</xsl:message>
      <xsl:message> + [DEBUG]     newHrefValue=      "<xsl:sequence select="$newHrefValue"/>"</xsl:message>
    </xsl:if>
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] resolve-map: Setting @href to "<xsl:value-of select="$newHrefValue"/>"</xsl:message>
    </xsl:if>
    <xsl:attribute name="{name(.)}" select="$newHrefValue"/>
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
    <xsl:if test="false() and $debugBoolean">
      <xsl:message> + [DEBUG] resolve-map(): ** Processing topic ref "<xsl:sequence select="name(.)"/>"</xsl:message>
      <xsl:choose>      
       <xsl:when test="$refTarget">
         <xsl:message> + [DEBUG] resolve-map():  refTarget type="<xsl:sequence select="name($refTarget[1])"/>"</xsl:message>
       </xsl:when>
       <xsl:otherwise>
         <xsl:message> + [DEBUG] resolve-map(): failed to resolve reference: <xsl:sequence select="df:reportTopicref(.)"/></xsl:message>
       </xsl:otherwise>
     </xsl:choose>
    </xsl:if>
      <xsl:choose>
        <xsl:when test="not($refTarget)">
          <xsl:message> + [WARN] Failed to resolve topicref to a resource: <xsl:sequence select="df:reportTopicref(.)"/></xsl:message>
        </xsl:when>
        <xsl:when test="@format = 'ditamap'">
          <xsl:if test="false() and $debugBoolean">
            <xsl:message> + [DEBUG] resolve-map(): Reference is to a subordinate map.</xsl:message>
          </xsl:if>
          <!-- Reference to subordinate map -->
          <!-- FIXME: Implement metadata and attribute propogation from
               map to map per 1.2 spec.
          -->
          <xsl:if test="not(df:class($refTarget, 'map/map'))">
            <xsl:message> + [WARNING] resolve-map(): Topicref with format='ditamap' did not resolve to a map, got <xsl:sequence select="name($refTarget)"/> (class=<xsl:sequence select="$refTarget/@class"/>)</xsl:message>
            <xsl:copy>
              <xsl:apply-templates select="@* | node()"/>           
            </xsl:copy>
          </xsl:if>
          <!-- Process the direct-child topicrefs and reltables in the referenced map -->
          <xsl:apply-templates select="$refTarget/*[df:class(., 'map/topicref') or *[df:class(., 'map/reltable')]]"
            mode="#current">
          </xsl:apply-templates>      
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="false() and $debugBoolean">
            <xsl:message> + [DEBUG] resolve-map(): Reference is to a non-map resource</xsl:message>
          </xsl:if>
          <xsl:variable name="myHeadLevel" 
            select="$parentHeadLevel + 1"
          />
          <xsl:copy>
            <xsl:if test="false() and $debugBoolean">
              <xsl:message> + [DEBUG] resolve-map(): Applying templates to all attributes: <xsl:sequence select="@*"/>...</xsl:message>
            </xsl:if>
            <xsl:apply-templates select="@*" mode="#current"/>
            <xsl:if test="$myHeadLevel != $parentHeadLevel">
              <xsl:attribute name="headLevel" select="$myHeadLevel"/>
            </xsl:if>
            <xsl:if test="false() and $debugBoolean">
              <xsl:message> + [DEBUG] resolve-map(): Applying templates to children of the topicref...</xsl:message>
            </xsl:if>
            <xsl:apply-templates select="node()" mode="#current">
              <xsl:with-param name="parentHeadLevel" select="$myHeadLevel" tunnel="yes" as="xs:integer"/>
            </xsl:apply-templates>
          </xsl:copy>    
          
        </xsl:otherwise>
      </xsl:choose>      
  </xsl:template>
  
</xsl:stylesheet>
