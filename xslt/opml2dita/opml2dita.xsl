<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="urn:functions:local"
  exclude-result-prefixes="xs local"
  version="2.0">
  <xd:doc
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Jan 30, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> ekimber</xd:p>
      <xd:p>OPML outline XML to DITA 1.2 subjectScheme map and topics.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:param name="outputdir" as="xs:string" select="''"/>
  <xsl:param name="subjectTopicPublicId" select="'-//OASIS//ELEMENTS DITA Topic//EN'" as="xs:string"/>
  <xsl:param name="subjectTopicSystemId" select="'topic.dtd'" as="xs:string"/>
  <xsl:param name="subjectTopicType" select="'topic'" as="xs:string"/>
  <xsl:param name="subjectTopicTitleTagname" select="'title'" as="xs:string"/>
  <xsl:param name="subjectTopicBodyTagname" select="'body'" as="xs:string"/>
  <xsl:param name="subjectDefinitionMapUri" select="concat($outputdir, 'subjectDefinitions.ditamap')" as="xs:string"/>

  <xsl:param name="subjectSchemeMapPublicId" select="'-//OASIS//DTD DITA Subject Scheme Map//EN'" as="xs:string"/>
  <xsl:param name="subjectSchemeMapSystemId" select="'subjectScheme.dtd'" as="xs:string"/>

  <xsl:param name="subjectNavigationMapType" select="'map'" as="xs:string"/>
  <xsl:param name="subjectNavigationMapTitleTagname" select="'title'" as="xs:string"/>
  <xsl:param name="subjectNavigationMapTopicrefTagname" select="'topicref'" as="xs:string"/>
  
  <xsl:param name="keyPrefix" select="'SUBJECT'" as="xs:string"/>
  
  <xsl:output
    doctype-public="-//OASIS//ELEMENTS DITA Map//EN"
    doctype-system="map.dtd"
    indent="yes"
  />
  
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="/">
    <!-- First generate the subject scheme map: -->
    <xsl:result-document href="{$subjectDefinitionMapUri}"
      doctype-public="{$subjectSchemeMapPublicId}"
      doctype-system="{$subjectSchemeMapSystemId}"
      indent="yes"
      >
      <subjectScheme>
        <xsl:apply-templates/>
      </subjectScheme>
    </xsl:result-document>
    
    <xsl:element name="{$subjectNavigationMapType}">
      <xsl:apply-templates select="/*/head/title" mode="subject-navigation-map"/>
      <topicref href="{$subjectDefinitionMapUri}" format="ditamap"/>
      <xsl:apply-templates mode="subject-navigation-map"
        select="/*/body"
      />
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="opml | head | body" mode="#all">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="title">
    <title><xsl:apply-templates/></title>
  </xsl:template>
  
  <xsl:template match="title" mode="subject-navigation-map">
    <xsl:element name="{$subjectNavigationMapTitleTagname}"><xsl:apply-templates/></xsl:element>
  </xsl:template>
  
  <xsl:template match="outline" mode="subject-navigation-map">
    <xsl:variable name="subjectKey" select="local:constructSubjectKey(.)" as="xs:string"/>
    <xsl:element name="{$subjectNavigationMapTopicrefTagname}">
      <xsl:attribute name="keyref" select="$subjectKey"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:element> 
  </xsl:template>
  
  <xsl:template match="outline">
    <xsl:variable name="subjectKey" select="local:constructSubjectKey(.)" as="xs:string"/>
    <xsl:variable name="topicUri" select="local:constructTopicUri(.)"/>
    <subjectdef keys="{$subjectKey}" navtitle="{string(@text)}" 
      href="{$topicUri}">
      <xsl:apply-templates/>
    </subjectdef>
    <xsl:result-document href="{$topicUri}" 
      doctype-public="{$subjectTopicPublicId}"
      doctype-system="{$subjectTopicSystemId}"
      >
      <xsl:element name="{$subjectTopicType}">
        <xsl:attribute name="id" select="$subjectKey"/>
        <xsl:element name="{$subjectTopicTitleTagname}">
          <xsl:sequence select="string(@text)"/>
        </xsl:element>
        <xsl:element name="{$subjectTopicBodyTagname}">
          <p>Subject description goes here.</p>
        </xsl:element>
      </xsl:element>
      
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="expansionState" mode="#all"
  />
  
  <xsl:function name="local:constructSubjectKey" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="subjectKey" as="xs:string">
      <xsl:apply-templates select="$context" mode="construct-subject-key"/>
    </xsl:variable>
    <xsl:sequence select="$subjectKey"/>
  </xsl:function>
  
  <xsl:template mode="construct-subject-key" match="outline">
    <xsl:variable name="itemNumber" as="xs:string">
      <xsl:number count="outline" level="any" format="000001"/>
    </xsl:variable>
    <xsl:variable name="keyValue" select="concat($keyPrefix, $itemNumber)" as="xs:string"/>
    <xsl:sequence select="$keyValue"/>
  </xsl:template>
  
  <xsl:function name="local:constructTopicUri" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="subjectKey" select="local:constructSubjectKey($context)" as="xs:string"/>
    <xsl:sequence select="concat($outputdir, 'subjects/', 'subject_', $subjectKey, '.dita')"/>
  </xsl:function>
  
  <xsl:template match="*" priority="-1">
    <xsl:message> - [WARNING] Unhandled element type <xsl:sequence select="concat(name(..), '/', name(.))"/></xsl:message>
  </xsl:template>

  <xsl:template match="*" priority="-1" mode="subject-navigation-map">
    <xsl:message> - [WARNING] mode subject-navigation-map: Unhandled element type <xsl:sequence select="concat(name(..), '/', name(.))"/></xsl:message>
  </xsl:template>
</xsl:stylesheet>
