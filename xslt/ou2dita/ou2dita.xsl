<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="http://local-functions"
      exclude-result-prefixes="xs local"
      version="2.0">
  
  <!-- Transform to generate DITA content from Open University XML
    
       Author: W. Eliot Kimber
       Copyright (c) DITA for Publishers Project, dita4publishers.sourceforge.net
       
       Materials licensed for unstricted use.
       
  -->
  
  <xsl:output 
    doctype-public="urn:pubid:dita4publishers.sourceforge.net/doctypes/dita/learningMap"
    doctype-system="learningMap.dtd"
    method="xml"
    indent="yes"
  />
  
  <!-- FIXME: create local shells for learning-specific topic types -->
  <xsl:output 
    name="learningContent"
    doctype-public="-//OASIS//DTD DITA Learning Content//EN"
    doctype-system="learningContent.dtd"
    method="xml"
    indent="yes"
  />
  
  <xsl:template match="/">
    <xsl:if test="not(/Item)">
      <xsl:message terminate="yes"> + [ERROR] Expected Item as root element. Cannot continue.</xsl:message>
    </xsl:if>
    
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="Item">
    <map>
      <xsl:apply-templates select="CourseTitle" mode="title"/>
      <topicmeta>
        <xsl:apply-templates mode="topicmeta"/>
      </topicmeta>
      <xsl:apply-templates/>
    </map>
  </xsl:template>
  
  <xsl:template mode="title" match="CourseTitle">
     <title><xsl:apply-templates/></title>
  </xsl:template>
  
  <xsl:template mode="topicmeta" match="Title">
    <navtitle><xsl:apply-templates/></navtitle>
  </xsl:template>
  
  <xsl:template mode="topictitle" match="Title">
    <title><xsl:apply-templates/></title>
  </xsl:template>
  
  <xsl:template 
    match="
      ByLine |
      ItemID | 
      ItemTitle | 
      CourseCode" 
    mode="topicmeta">
    <data name="{name(.)}"><xsl:apply-templates/></data>
  </xsl:template>
  
  <xsl:template mode="topicmeta" 
     match="
       FrontMatter | 
       Unit | 
       CourseTitle |
       Section
       "
       /><!-- Ignore for topicmeta -->
  
  <xsl:template match="FrontMatter">
    <topichead>
      <topicmeta>
        <navtitle>Frontmatter</navtitle>
      </topicmeta>
      <xsl:apply-templates/>
    </topichead>
  </xsl:template>
  
  <xsl:template match="Unit">
    <topicref keys="{string(UnitID)}">
      <topicmeta>
        <navtitle><xsl:apply-templates select="UnitTitle" mode="topicmeta"/></navtitle>
        <xsl:apply-templates mode="topicmeta" select="ByLine"/>
      </topicmeta>
      <xsl:apply-templates mode="topicrefs"/>
    </topicref>
  </xsl:template>
  
  <xsl:template match="UnitTitle" mode="topicmeta">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="Session" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}">
      <topicmeta>
        <xsl:apply-templates mode="topicmeta" select="Title"/>
      </topicmeta>
      <xsl:apply-templates mode="topicrefs"/>
    </topicref>    
  </xsl:template>
  
  <xsl:template match="Section" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}">
      <topicmeta>
        <xsl:apply-templates mode="topicmeta" select="Title"/>
      </topicmeta>
      <xsl:apply-templates mode="topicrefs" select="SubSection"/>
    </topicref>    
    <xsl:result-document href="{$topicUrl}" format="learningContent">
      <learningContent id="{@id}">
        <xsl:apply-templates select="Title" mode="topictitle"/>
        <learningContentbody>
          <section>
            <xsl:apply-templates/>
          </section>
        </learningContentbody>
      </learningContent>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="SubSection" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}">
      <topicmeta>
        <xsl:apply-templates mode="topicmeta" select="Title"/>
      </topicmeta>
    </topicref>    
    <xsl:result-document href="{$topicUrl}" format="learningContent">
      <learningContent id="{@id}">
        <xsl:apply-templates select="Title" mode="topictitle"/>
        <learningContentbody>
          <section>
            <xsl:apply-templates/>
          </section>
        </learningContentbody>
      </learningContent>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="Acknowledgements" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}">
      <topicmeta>
        <xsl:apply-templates mode="topicmeta" select="Title"/>
      </topicmeta>
    </topicref>    
  </xsl:template>
  
  <xsl:template match="BackMatter" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}">
      <topicmeta>
        <xsl:apply-templates mode="topicmeta" select="Title"/>
      </topicmeta>
      <xsl:apply-templates mode="topicrefs"/>
    </topicref>    
  </xsl:template>
  
  <xsl:template match="Paragraph">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="Figure">
    <fig>
      <xsl:apply-templates select="Caption"/>
      <xsl:apply-templates select="*[not(self::Caption)]"/>
    </fig>
  </xsl:template>
  
  <xsl:template match="Caption">
    <title><xsl:apply-templates/></title>
  </xsl:template>
  
  <xsl:template match="Figure/Description">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="InlineEquation">
    <ph outputclass="{name(.)}"><xsl:apply-templates/></ph>
  </xsl:template>
  
  <xsl:template match="Equation | Box">
    <fig outputclass="{name(.)}">
      <xsl:apply-templates/>
    </fig>
  </xsl:template>
  
  <xsl:template match="NumberedList">
    <ol>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>
  
  <xsl:template match="BulletedList">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  
  <xsl:template match="ListItem">
    <li><xsl:apply-templates/></li>
  </xsl:template>
  
  <xsl:template match="Heading">
    <p outputclass="Heading"><b><xsl:apply-templates/></b></p>
  </xsl:template>
  
  <xsl:template match="CrossRef">
    <!-- FIXME: Need function to convert incoming idref into proper
                topic-id/element-id pair.
      -->
    <xref href="#{@idref}"><xsl:apply-templates/></xref>
  </xsl:template>
  
  <xsl:template match="a">
    <xref href="{@href}"
        scope="external"
        format="html"><xsl:apply-templates/></xref>
  </xsl:template>
  
  <xsl:template match="Image">
    <image href="{@src}">
      <xsl:apply-templates/>
    </image>
  </xsl:template>
  
  <xsl:template match="i | b | sub | sup">
    <xsl:element name="{name(.)}"><xsl:apply-templates/></xsl:element>
  </xsl:template>
  
  <xsl:template mode="topicrefs"
    match="
       UnitID |
       UnitTitle |
       ByLine |
       Title
    "
  />
  
  <xsl:template 
    mode="#default"
    match="
     UnitID |
     ByLine |
     CourseTitle |
     CourseCode |
     ItemID |
     ItemTitle |
     UnitTitle |
     Title |
     SubSection
     "/>
  
  <xsl:template match="*" priority="-1">
    <xsl:message> + [WARNING] Default mode: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>

  <xsl:template match="*" priority="-1" mode="topicmeta">
    <xsl:message> + [WARNING] Mode topicmeta: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:template match="*" priority="-1" mode="topicrefs">
    <xsl:message> + [WARNING] Mode topicrefs: Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:function name="local:getTopicUrl" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="sessionDir" as="xs:string"
      select="concat('sessions/', 
        if ($context/self::Session) 
           then string($context/@id)
           else string($context/ancestor::Session/@id), 
        '/')"
      />
    <xsl:choose>
      <xsl:when test="$context/self::Session">
        <xsl:sequence select="concat($sessionDir,  'session_', string($context/@id), '.xml')"/>
      </xsl:when>
      <xsl:when test="$context/self::Section">
        <xsl:sequence select="concat($sessionDir, string($context/@id), '/', 'section_', string($context/@id), '.xml')"/>        
      </xsl:when>
      <xsl:when test="$context/self::SubSection">
        <xsl:sequence select="concat($sessionDir, string($context/ancestor::Section/@id), '/', 'subsection_', string($context/@id), '.xml')"/>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + [WARNING] getTopicUrl(): Unrecognized element type <xsl:sequence select="name($context)"/>.</xsl:message>
        <xsl:sequence select="concat('topics/', 'topic_', generate-id($context), '.xml')"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:function>
  
  
</xsl:stylesheet>
