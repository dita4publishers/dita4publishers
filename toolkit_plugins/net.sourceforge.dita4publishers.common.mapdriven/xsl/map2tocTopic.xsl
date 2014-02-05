<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
  Generates a generic topic that represents the table of contents as
  a set of nested lists and xrefs.
  

-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:df="http://dita2indesign.org/dita/functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:relpath="http://dita2indesign/functions/relpath"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                xmlns:saxon="http://icl.com/saxon"
                extension-element-prefixes="saxon"
                xmlns:java="org.dita.dost.util.StringUtils"
                exclude-result-prefixes="java dita-ot ditamsg"
                >

<xsl:param name="tocTopicClassSpec"
  as="xs:string"
  select="'- topic/topic '"
/>

<xsl:template match="*[df:class(., 'map/map')]" mode="generate-toc-topic">
  <xsl:param name="tocTopicUri" 
    as="xs:string" 
   />

<xsl:message> + [INFO] Generating generic Table of Contents topic "<xsl:sequence select="$tocTopicUri"/>"...</xsl:message>

  <xsl:document>    
    <topic id="generated-toc"
      xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
      ditaarch:DITAArchVersion="1.2"
      domains="(topic topic)"
    >
      <xsl:attribute name="class"
        select="$tocTopicClassSpec"
      />
      <!-- FIXME: Need to parameterize/enable override -->
      <title class="- topic/title ">Table of Contents</title>
      <body class="- topic/body ">
        <ul class="- topic/ul ">
        <xsl:apply-templates mode="#current">
          <xsl:with-param name="tocDepth" as="xs:integer"  tunnel="yes" select="1"/>
          <xsl:with-param name="tocTopicUri" as="xs:string" tunnel="yes" select="$tocTopicUri"/>
        </xsl:apply-templates>
        </ul>
      </body>
    </topic>
  </xsl:document>
</xsl:template>
  
  <xsl:template mode="generate-toc-topic" match="*[df:isTopicRef(.)]">
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:param name="tocTopicUri" as="xs:string" tunnel="yes"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="topic" select="df:resolveTopicRef(.)" as="element()*"/>
      <xsl:choose>
        <xsl:when test="$topic">
          <xsl:variable name="topicUri" select="string(document-uri(root($topic)))" as="xs:string"/>
          <xsl:variable name="relativeUri" select="relpath:getRelativePath($tocTopicUri, $topicUri)"/>
          <li class="- topic/li "><xref href="{$relativeUri}" class="- topic/xref "/>
            <xsl:if test="($tocDepth lt $maxTocDepthInt) and *[df:class(., 'map/topicref')]">
              <ul class="- topic/ul ">
                <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current">
                  <xsl:with-param name="tocDepth" as="xs:integer"  tunnel="yes" 
                    select="$tocDepth + 1"/>
                </xsl:apply-templates>
              </ul>
            </xsl:if>
          </li>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="generate-toc-topic" match="*[df:isTopicHead(.)]" >
    <xsl:param name="tocDepth" as="xs:integer" tunnel="yes" select="0"/>
    <xsl:if test="$tocDepth le $maxTocDepthInt">
      <xsl:variable name="xrefText" as="node()*"
      >
      <xsl:choose>
        <xsl:when test="(*[df:class(., 'map/topicmeta')]/*[df:class(., 'map/navtitle')])">
          <xsl:sequence select="*[df:class(., 'map/topicmeta')]/*[df:class(., 'map/navtitle')]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@navtitle"/>
        </xsl:otherwise>
      </xsl:choose>  
      </xsl:variable>
          <li class="- topic/li "><xsl:sequence select="$xrefText"/>
            <xsl:if test="($tocDepth lt $maxTocDepthInt) and *[df:class(., 'map/topicref')]">
              <ul class="- topic/ul ">
                <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current">
                  <xsl:with-param name="tocDepth" as="xs:integer"  tunnel="yes" 
                    select="$tocDepth + 1"/>
                </xsl:apply-templates>
              </ul>
            </xsl:if>
          </li>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="generate-toc-topic" match="*[df:isTopicGroup(.)]">
    <xsl:apply-templates select="*[df:class(., 'map/topicref')]" mode="#current"/>
  </xsl:template>

</xsl:stylesheet>
