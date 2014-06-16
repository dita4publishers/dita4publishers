<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:df="http://dita2indesign.org/dita/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:relpath="http://dita2indesign/functions/relpath" xmlns:enum="http://dita4publishers.org/enumerables"
  xmlns:htmlutil="http://dita4publishers.org/functions/htmlutil" xmlns:local="urn:functions:local"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  xmlns:index-terms="http://dita4publishers.org/index-terms" xmlns="http://dita4publishers.org/enumerables"
  exclude-result-prefixes="local xs df xsl relpath enum htmlutil ditaarch index-terms">
  <!-- =============================================================
    
    DITA Map to HTML Transformation
    
    Enumeration support. This module constructs a full-publication structure
    that allows numbering of numberable things based on their hierarchical
    structure in the publication.
    
    Copyright (c) 2011, 2014 DITA For Publishers
    
    Licensed under Common Public License v1.0 or the Apache Software Foundation License v2.0.
    The intent of this license is for this material to be licensed in a way that is
    consistent with and compatible with the license of the DITA Open Toolkit.
    
    This transform requires XSLT 2.
    ================================================================= -->

  <xsl:template match="*[df:class(., 'map/map')]" mode="construct-enumerable-structure">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <!-- At some future time, interpret D4P enumeration metadata to configure enumerable
         processing.
    -->
    <xsl:message> + [INFO] Constructing enumerables structure...</xsl:message>
    <!-- NOTE: This should avoid getting any topicrefs from within reltables. -->
    <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current">
      <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
    </xsl:apply-templates>    
    <xsl:message> + [INFO] Enumerables structure constructed.</xsl:message>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure"
    match="*[df:isTopicHead(.)]">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <xsl:call-template name="construct-enumerated-element">
    	<xsl:with-param name="additional-attributes" as="attribute()*">
            <xsl:if test="@id">
              <xsl:attribute name="topicID" select="string(@id)"/>
            </xsl:if>
        </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="construct-enumerated-element">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <xsl:param name="content" as="node()*"/>
    <xsl:param name="additional-attributes" as="attribute()*"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] construct-enumerated-element(): <xsl:value-of select="concat(name(..), '/', name(.))"/></xsl:message>
    </xsl:if>
    <xsl:element name="{name(.)}" namespace="http://dita4publishers.org/enumerables">
      <xsl:sequence select="@class"/>
      <xsl:attribute name="sourceId" select="df:generate-dita-id(.)"/>
      <xsl:if test="./@id">
        <xsl:attribute name="origId" select="@id"/>
      </xsl:if>
      <xsl:attribute name="xml:lang">
        <xsl:call-template name="getLowerCaseLang"/>
      </xsl:attribute>

      <xsl:if test="./@xtrc">
        <xsl:attribute name="xtrc" select="@xtrc"/>
      </xsl:if>
      <xsl:attribute name="docUri" select="base-uri(root(.))"/>
      <xsl:sequence select="$additional-attributes"/>
      <xsl:choose>
        <xsl:when test="$content">
          <xsl:if test="$doDebug">
            <xsl:message> + [DEBUG]     using $content...</xsl:message>
          </xsl:if>
          <xsl:sequence select="$content"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="$doDebug">
            <xsl:message> + [DEBUG]     applying templates to child nodes...</xsl:message>
          </xsl:if>
          <xsl:apply-templates select="node()" mode="#current"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure" priority="100"
    match="*[df:class(., 'map/topicref')][@processing-role = 'resource-only']"
  >
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <!-- Resource-only topicrefs and their descendants
         cannot contribute to the navigation tree -->
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure" match="*[df:isTopicGroup(.)]" priority="10">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <xsl:apply-templates mode="#current" select="*[df:class(., 'map/topicref')]"/>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure"
    match="*[df:isTopicRef(.)]">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] construct-enumerable-structure: topicref: <xsl:value-of select="@href"/></xsl:message>
    </xsl:if>
    <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
    <xsl:choose>
      <xsl:when test="not($topic)">
        <xsl:message> + [WARNING] construct-enumerable-structure: Failed to resolve topic reference to href
            "<xsl:sequence select="string(@href)"/>"</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$doDebug">
          <xsl:message> + [DEBUG] construct-enumerable-structure:   resolved topicref, processing the topic...</xsl:message>
        </xsl:if>
        <!-- If topicref is unspecialized then use topic's tagname and class, otherwise
             assume tagname of topicref is more significant than tagname
             of target topic. Always remember class of topic, just in case.
          -->
        <xsl:variable name="tagname" as="xs:string" select="if (name(.) = 'topicref') then name($topic) else name(.)"/>
        <xsl:variable name="class" as="xs:string"
          select="if (name(.) = 'topicref') then string($topic/@class) else string(@class)"/>
        <xsl:if test="$doDebug">
          <xsl:message> + [DEBUG] construct-enumerable-structure:   Calling template "construct-enumerated-element"...</xsl:message>
        </xsl:if>
        <xsl:call-template name="construct-enumerated-element">
          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
          <xsl:with-param name="additional-attributes" as="attribute()*">
            <xsl:if test="$topic/@outputclass">
              <xsl:attribute name="topicOutputClass" select="string($topic/@outputclass)"/>
            </xsl:if>
            <xsl:if test="$topic/@id">
              <xsl:attribute name="topicID" select="string($topic/@id)"/>
            </xsl:if>
          </xsl:with-param>
          <xsl:with-param name="content" as="node()*">
            <xsl:if test="$doDebug">
              <xsl:message> + [DEBUG] construct-enumerable-structure:     Constructing value of "content" parameter...</xsl:message>
            </xsl:if>
            <xsl:if test="$doDebug">
              <xsl:message> + [DEBUG] construct-enumerable-structure:       Applying templates to map/topicmeta in mode construct-enumerable-structure...</xsl:message>
            </xsl:if>
            <xsl:apply-templates mode="#current" select="*[df:class(., 'map/topicmeta')]">
              <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            </xsl:apply-templates>
            <xsl:if test="$doDebug">
              <xsl:message> + [DEBUG] construct-enumerable-structure:       Applying templates to $topic in mode construct-enumerable-structure...</xsl:message>
            </xsl:if>
            <xsl:apply-templates mode="#current" select="$topic">
              <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
              <xsl:with-param name="topicref" as="element()" select="." tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:if test="$doDebug">
              <xsl:message> + [DEBUG] construct-enumerable-structure:       Applying templates to child topicrefs in mode construct-enumerable-structure...</xsl:message>
            </xsl:if>
            <xsl:if test="not(contains(@chunk, 'to-content'))">
              <!-- If the topicref specifies chunk="to-content" then we don't need to
                   process any subordinate topicrefs because all the content will have
                   been in the chunk referenced by this topicrefs. Any subordinate 
                   topicrefs will be only for navigation purposes.
                -->
              <xsl:apply-templates mode="#current" select="*[df:class(., 'map/topicref')]">
                <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
              </xsl:apply-templates>
            </xsl:if>
            <xsl:if test="$doDebug">
              <xsl:message> + [DEBUG] construct-enumerable-structure:    Done constructing "content" param.</xsl:message>
            </xsl:if>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure"
    match="*[df:isTopicHead(.)][not(@processing-role = 'resource-only')]/*[df:class(., 'map/topicmeta')]">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <xsl:apply-templates mode="#current" select="*[df:class(., 'topic/navtitle')]"/>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure"
    match="*[df:class(., 'topic/navtitle')] | 
           *[df:class(., 'topic/title')]"
    >
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <!-- The title text is just for debugging, not for output, so we don't worry about handling
         any markup within the title.
      -->
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] construct-enumerable-structure: <xsl:value-of select="concat(name(..), '/', name(.))"/>: <xsl:value-of select="."/></xsl:message>
    </xsl:if>
    <title>
      <xsl:value-of select="."/>
    </title>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure"  priority="10"
    match="/*[df:class(., 'topic/topic')] | 
           /dita/*[df:class(., 'topic/topic')]"
    >
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <!-- Root topics are handled by the topicref topic, where the topicref and topic details are
         merged. -->
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] construct-enumerable-structure: /*[df:class(., 'topic/topic')]: <xsl:value-of select="*[df:class(., 'topic/title')]"/></xsl:message>
    </xsl:if>
    <xsl:apply-templates select="*[df:class(., 'topic/body')], *[df:class(., 'topic/topic')]" mode="#current"/>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure"
    match="*[df:class(., 'topic/topic')]/*[df:class(., 'topic/topic')]">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] construct-enumerable-structure: topic/topic: <xsl:value-of select="*[df:class(., 'topic/title')]"/></xsl:message>
    </xsl:if>
    <xsl:call-template name="construct-enumerated-element">
      <xsl:with-param name="content" as="node()*">
        <xsl:apply-templates mode="#current"
          select="*[df:class(., 'topic/title')], 
                  *[df:class(., 'topic/body')], 
                  *[df:class(., 'topic/topic')]"
        />
      </xsl:with-param>
      <xsl:with-param name="additional-attributes" as="attribute()*">
        <xsl:apply-templates mode="#current" select="@*"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure" priority="10"
    match="*[df:class(., 'topic/section')] | 
    *[df:class(., 'topic/example')] | 
    *[df:class(., 'topic/fig')] | 
    *[df:class(., 'topic/table')] | 
    *[df:class(., 'topic/note')] | 
    *[df:class(., 'topic/bodydiv')] | 
    *[df:class(., 'topic/sectiondiv')]
    ">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <xsl:call-template name="construct-enumerated-element">
      <xsl:with-param name="content" as="node()*">
        <xsl:apply-templates mode="#current"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates mode="construct-enumerable-structure"/>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure" priority="10"
    match="@domains | 
    @ditaarch:DITAArchVersion |
    @xtrf |
    @xtrc"> 
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure" match="@*">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <xsl:sequence select="."/>
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure" match="text()">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
  </xsl:template>

  <xsl:template mode="construct-enumerable-structure" match="*[df:class(., 'topic/body')]//*" priority="-1">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/> 
    <!-- Ignore anything within body that isn't explicitly handled. -->
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] construct-enumerable-structure: catch all for <xsl:sequence select="name(.)"/></xsl:message>
    </xsl:if>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

</xsl:stylesheet>
