<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:enumerables="http://dita4publishers.org/enumerables"
                xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil"                
                xmlns:local="urn:functions:local"
                xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
                xmlns:index-terms="http://dita4publishers.org/index-terms"
                xmlns="http://dita4publishers.org/enumerables"                
                exclude-result-prefixes="local xs df xsl relpath enumerables htmlutil ditaarch index-terms"
  >
  <!-- =============================================================
    
    DITA Map to HTML Transformation
    
    Enumeration support. This module constructs a full-publication structure
    that allows numbering of numberable things based on their hierarchical
    structure in the publication.
    
    Copyright (c) 2011 DITA For Publishers
    
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
  <xsl:template match="*[df:class(., 'map/map')]" mode="construct-enumerable-structure">
    <!-- At some future time, interpret D4P enumeration metadata to configure enumerable
         processing.
    -->
    <xsl:message> + [INFO] Constructing enumerables structure...</xsl:message>
    <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current"/>
    <xsl:message> + [INFO] Enumerables structure constructed.</xsl:message>
  </xsl:template>
  
  <xsl:template mode="construct-enumerable-structure" match="*[df:isTopicHead(.)]">
    <xsl:element name="{name(.)}" namespace="http://dita4publishers.org/enumerables">
      <xsl:sequence select="@class"/>
      <!-- @sourceId correlates the element in the enumerable structure to the input element 
           it corresponds to.
        -->
      <xsl:attribute name="sourceId" select="df:generate-dita-id(.)"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="construct-enumerable-structure" match="*[df:isTopicGroup(.)]">
    <xsl:apply-templates mode="#current" select="*[df:class(., 'map/topicref')]"/>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure" match="*[df:isTopicRef(.)]">
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    <xsl:choose>
      <xsl:when test="not($topic)">
        <xsl:message> + [WARNING] Failed to resolve topic reference to href "<xsl:sequence select="string(@href)"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <!-- If topicref is unspecialized then use topic's tagname and class, otherwise
             assume tagname of topicref is more significant than tagname
             of target topic. Always remember class of topic, just in case.
          -->
        <xsl:variable name="tagname" as="xs:string"
          select="if (name(.) = 'topicref') then name($topic) else name(.)"
          />
        <xsl:variable name="class" as="xs:string"
          select="if (name(.) = 'topicref') then string($topic/@class) else string(@class)"
        />
        <xsl:element name="{$tagname}" namespace="http://dita4publishers.org/enumerables">
          <xsl:attribute name="sourceId" select="df:generate-dita-id(.)"/>
          <xsl:attribute name="class" select="$class"/>
          <xsl:attribute name="topicClass" select="string($topic/@class)"/>
          <xsl:if test="$topic/@outputclass">
            <xsl:attribute name="topicOutputClass" select="string($topic/@outputclass)"/>
          </xsl:if>
          <!-- Process the topic, then process any subordinate topicrefs: -->
          <xsl:apply-templates mode="#current" select="*[df:class(., 'map/topicmeta')]"/>          
          <xsl:apply-templates mode="#current" select="$topic">
            <xsl:with-param name="topicref" as="element()" select="." tunnel="yes"/>
          </xsl:apply-templates>
          <xsl:apply-templates mode="#current" select="*[df:class(., 'map/topicref')]"/>          
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>        
  </xsl:template>
  
  <xsl:template mode="construct-enumerable-structure" match="*[df:isTopicHead(.)]/*[df:class(., 'map/topicmeta')]">
    <xsl:apply-templates mode="#current" select="*[df:class(., 'topic/navtitle')]"/>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure" 
    match="*[df:class(., 'topic/navtitle')] | *[df:class(., 'topic/title')]">
    <!-- The title text is just for debugging, not for output, so we don't worry about handling
         any markup within the title.
      -->
    <title><xsl:value-of select="."/></title>
  </xsl:template>
  
  <xsl:template mode="construct-enumerable-structure" match="/*[df:class(., 'topic/topic')]" priority="10">
    <!-- Root topics are handled by the topicref topic, where the topicref and topic details are
         merged. -->
    <xsl:apply-templates select="*[df:class(., 'topic/body')], *[df:class(., 'topic/topic')]" 
      mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="construct-enumerable-structure" match="*[df:class(., 'topic/topic')]/*[df:class(., 'topic/topic')]">
    <xsl:element name="{name(.)}" namespace="http://dita4publishers.org/enumerables">
      <xsl:attribute name="sourceId" select="df:generate-dita-id(.)"/>
      <xsl:apply-templates mode="#current"
      select="@*,*[df:class(., 'topic/title')], *[df:class(., 'topic/body')], *[df:class(., 'topic/topic')]"
      />
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="construct-enumerable-structure" priority="10"
    match="*[df:class(., 'topic/section')] | 
    *[df:class(., 'topic/example')] | 
    *[df:class(., 'topic/fig')] | 
    *[df:class(., 'topic/table')] | 
    *[df:class(., 'topic/note')] | 
    *[df:class(., 'topic/bodydiv')] | 
    *[df:class(., 'topic/sectiondiv')]
           "
    >
    <xsl:element name="{name(.)}" namespace="http://dita4publishers.org/enumerables">
      <xsl:attribute name="sourceId" select="df:generate-dita-id(.)"/>
      <xsl:apply-templates select="@*, *" mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="construct-enumerable-structure" priority="10"
    match="@domains | 
    @ditaarch:DITAArchVersion |
    @xtrf |
    @xtrc">
  </xsl:template>
  
  <xsl:template mode="construct-enumerable-structure" match="@*">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template mode="construct-enumerable-structure" match="text()"/>
  
  <xsl:template mode="construct-enumerable-structure" match="*[df:class(., 'topic/body')]//*" priority="-1">
    <!-- Ignore anything within body that isn't explicitly handled. -->
<!--    <xsl:message> + [DEBUG] construct-enumerable-structure: catch all for <xsl:sequence select="name(.)"/></xsl:message>-->
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
</xsl:stylesheet>
