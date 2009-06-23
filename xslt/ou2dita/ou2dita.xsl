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
  
  <xsl:output 
    name="learningPlan"
    doctype-public="-//OASIS//DTD DITA Learning Plan//EN"
    doctype-system="learningPlan.dtd"
    method="xml"
    indent="yes"
  />
  
  <xsl:output 
    name="topic"
    doctype-public="-//OASIS//DTD DITA Topic//EN"
    doctype-system="topic.dtd"
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
       BackMatter | 
       Unit | 
       CourseTitle |
       Section |
       Heading
       "
       /><!-- Ignore for topicmeta -->
  
  <xsl:template match="FrontMatter">
    <topichead collection-type="sequence">
      <topicmeta>
        <navtitle>Frontmatter</navtitle>
      </topicmeta>
      <xsl:apply-templates mode="topicrefs"/>
    </topichead>
  </xsl:template>
  
  <xsl:template match="BackMatter">
    <topichead collection-type="sequence">
      <topicmeta>
        <navtitle>Backmatter</navtitle>
      </topicmeta>
      <xsl:apply-templates mode="topicrefs"/>
    </topichead>
  </xsl:template>
  
  <xsl:template match="Unit">
    <topicref keys="{string(UnitID)}" collection-type="sequence">
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
    <topicref href="{$topicUrl}" collection-type="sequence">
      <topicmeta>
        <xsl:apply-templates mode="topicmeta" select="Title"/>
      </topicmeta>
      <xsl:apply-templates mode="topicrefs"/>
    </topicref>    
    <xsl:result-document href="{$topicUrl}" format="learningContent">
      <learningContent id="{@id}">
        <xsl:apply-templates select="Title" mode="topictitle"/>
        <!-- Session never has any direct untitled content -->
        <learningContentbody/>
      </learningContent>
    </xsl:result-document>
    
  </xsl:template>
  
  <xsl:template match="Section" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}"  collection-type="sequence">
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
    <topicref href="{$topicUrl}" collection-type="sequence">
      <topicmeta>
        <xsl:apply-templates mode="topicmeta" select="Title"/>
      </topicmeta>
      <xsl:apply-templates mode="topicrefs" select="SubSubSection"/>
    </topicref>    
    <xsl:variable name="idValue" as="xs:string"
      select="if (@id)
        then string(@id)
        else generate-id(.)"
    />
    <xsl:result-document href="{$topicUrl}" format="learningContent">
      <learningContent id="{$idValue}">
        <xsl:apply-templates select="Title" mode="topictitle"/>
        <learningContentbody>
          <section>
            <xsl:apply-templates/>
          </section>
        </learningContentbody>
      </learningContent>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="SubSubSection" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}" collection-type="sequence">
      <topicmeta>
        <xsl:apply-templates mode="topicmeta" select="Heading[1]"/>
      </topicmeta>
    </topicref>    
    <xsl:variable name="idValue" as="xs:string"
      select="if (@id)
      then string(@id)
      else generate-id(.)"
    />
    <xsl:result-document href="{$topicUrl}" format="learningContent">
      <learningContent id="{$idValue}">
        <xsl:apply-templates select="Heading[1]" mode="topictitle"/>
        <learningContentbody>
          <section>
            <xsl:apply-templates/>
          </section>
        </learningContentbody>
      </learningContent>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="Imprint" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}" collection-type="sequence">
    </topicref>    
    <xsl:result-document href="{$topicUrl}" format="topic">
      <topic id="imprint">
        <title>Imprint</title>
        <body>
            <xsl:apply-templates/>
        </body>
      </topic>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="Introduction" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}" collection-type="sequence">
    </topicref>    
    <xsl:result-document href="{$topicUrl}" format="topic">
      <topic id="introduction">
        <xsl:apply-templates select="Title" mode="topictitle"/>
        <body>
          <xsl:apply-templates/>
        </body>
      </topic>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="LearningOutcomes" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}" collection-type="sequence">
    </topicref>    
    <xsl:result-document href="{$topicUrl}" format="learningContent">
      <learningContent id="learningOutcomes">
        <title>Learning Outcomes</title>
        <learningContentbody>
          <lcObjectives>
            <xsl:apply-templates select="Paragraph"/>
            <lcObjectivesGroup>
              <xsl:apply-templates select="LearningOutcome"/>
            </lcObjectivesGroup>
          </lcObjectives>
        </learningContentbody>
      </learningContent>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="Acknowledgements" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}" collection-type="sequence">
    </topicref>    
    <xsl:result-document href="{$topicUrl}" format="topic">
      <topic id="acknowledgements">
        <xsl:apply-templates select="Heading[1]" mode="topictitle"/>
        <body>
          <xsl:apply-templates/>
        </body>
      </topic>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="Acknowledgements/Heading[1]" mode="#default"/>
  
  <xsl:template match="SubSubSection/Heading[1]" mode="#default"/>
  
  <xsl:template match="Acknowledgements/Heading[1] | SubSubSection/Heading[1]" mode="topictitle">
    <title><xsl:apply-templates/></title>
  </xsl:template>
  
  <xsl:template match="LearningOutcomes/Paragraph">
    <lcObjectivesStem><xsl:apply-templates/></lcObjectivesStem>
  </xsl:template>
  
  <xsl:template match="LearningOutcome">
    <lcObjective><xsl:apply-templates/></lcObjective>
  </xsl:template>
  
  <xsl:template match="Preface" mode="topicrefs">
    <xsl:variable name="topicUrl" select="local:getTopicUrl(.)"/>
    <topicref href="{$topicUrl}" collection-type="sequence">
    </topicref>    
    <xsl:result-document href="{$topicUrl}" format="topic">
      <topic id="preface">
        <title>Preface</title>
        <body>
          <xsl:apply-templates/>
        </body>
      </topic>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="Standard">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="GeneralInfo | FirstPublished | Copyright | Rights | Edited | Typeset | Printed | ISBN | Edition
    ">
    <section spectitle="{name(.)}">
      <xsl:apply-templates/>
    </section>
  </xsl:template>
  
  <xsl:template match="Address">
     <section spectitle="Address">
       <lines>
         <xsl:apply-templates/>
       </lines>
     </section> 
  </xsl:template>
  
  <xsl:template match="Verse">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="Example">
    <sectiondiv outputclass="Example">
      <xsl:apply-templates/>
    </sectiondiv>
  </xsl:template>
  
  <xsl:template match="Answer">
    <sectiondiv outputclass="Answer">
      <xsl:apply-templates/>
    </sectiondiv>
  </xsl:template>
  
  <xsl:template match="AddressLine">
    <xsl:apply-templates/><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="BackMatter" mode="topicrefs">
    <xsl:apply-templates mode="topicrefs"/>
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
  
  <xsl:template match="InlineEquation/Description">
    <ph outputclass="inlineequation-description"><xsl:apply-templates/></ph>
  </xsl:template>
  
  <xsl:template match="Equation/Description">
    <p outputclass="equation-description"><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="Equation | Box">
    <fig outputclass="{name(.)}">
      <xsl:apply-templates/>
    </fig>
  </xsl:template>
  
  <xsl:template match="NumberedList | NumberedSubsidiaryList">
    <ol>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>
  
  <xsl:template match="BulletedList | UnNumberedList | UnNumberedSubsidiaryList | BulletedSubsidiaryList">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  
  <xsl:template match="ListItem | SubListItem">
    <li><xsl:apply-templates/></li>
  </xsl:template>
  
  <xsl:template match="Heading">
    <p outputclass="Heading"><b><xsl:apply-templates/></b></p>
  </xsl:template>
  
  <xsl:template match="SubHeading">
    <p outputclass="SubHeading"><b><xsl:apply-templates/></b></p>
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
    <image href="{concat('../../media/', @src)}">
      <xsl:apply-templates/>
    </image>
  </xsl:template>
  
  <xsl:template match="Description">
    <alt><xsl:apply-templates/></alt>
  </xsl:template>
  
  <xsl:template match="SourceReference">
    <p outputclass="{name(.)}">
      <xsl:text>Source: </xsl:text><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="ItemRights | OwnerRef | ItemRef | ItemAcknowledgement">
    <data name="{name(.)}">
      <xsl:apply-templates/>
    </data>
  </xsl:template>
  
  
  
  <xsl:template match="SAQ">
    <sectiondiv outputclass="SAQ">
      <xsl:apply-templates/>
    </sectiondiv>
  </xsl:template>
  
  <xsl:template match="Activity">
    <sectiondiv outputclass="Activity">
      <xsl:apply-templates/>
    </sectiondiv>
  </xsl:template>
  
  <xsl:template match="SAQ/Question">
    <sectiondiv outputclass="saq.question">
      <xsl:apply-templates/>
    </sectiondiv>
  </xsl:template>
  
  <xsl:template match="Activity/Question">
    <sectiondiv outputclass="activity.question">
      <xsl:apply-templates/>
    </sectiondiv>
  </xsl:template>
  
  <xsl:template match="SAQ/Answer">
    <sectiondiv outputclass="saq.answer">
      <xsl:apply-templates/>
    </sectiondiv>
  </xsl:template>
  
  <xsl:template match="Table">
    <xsl:apply-templates select="*[not(self::TableHead)]"/>
  </xsl:template>

  <xsl:template match="TableHead">
      <title><xsl:apply-templates/></title>
  </xsl:template>
  
  <xsl:template match="TableBody">
    <table>
      <xsl:apply-templates select="../TableHead"/>
      <xsl:apply-templates select="table"/>
    </table>
  </xsl:template>
  
  <xsl:template match="table">
    <tgroup cols="{count(tr[1]/(td | th))}">
      <tbody>
        <xsl:apply-templates/>
      </tbody>
    </tgroup>
  </xsl:template>
  
  <xsl:template match="tr">
    <row>
      <xsl:apply-templates/>
    </row>
  </xsl:template>
  
  <xsl:template match="td">
    <entry><xsl:apply-templates/></entry>
  </xsl:template>
  
  <xsl:template match="th">
    <entry outputclass="th"><b><xsl:apply-templates/></b></entry>
  </xsl:template>
  
  <xsl:template match="MediaContent">
    <image href="{concat('../../media/', @src, '.', @type)}">
      <xsl:apply-templates/>
    </image>
  </xsl:template>
  
  <xsl:template match="i | b | sub | sup | u">
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
     SubSection |
     SubSubSection
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
    <xsl:variable name="idValue" as="xs:string"
      select="
        if ($context/@id) 
           then string($context/@id)
           else generate-id($context)
      "
    />
    <xsl:choose>
      <xsl:when test="$context/self::Session">
        <xsl:sequence select="concat($sessionDir,  'session_', $idValue, '.xml')"/>
      </xsl:when>
      <xsl:when test="$context/self::Section">
        <xsl:sequence select="concat($sessionDir, $idValue, '/', 'section_', $idValue, '.xml')"/>        
      </xsl:when>
      <xsl:when test="$context/self::SubSection">
        <xsl:sequence select="concat($sessionDir, string($context/ancestor::Section/@id), '/', 'subsection_', $idValue, '.xml')"/>        
      </xsl:when>
      <xsl:when test="$context/self::SubSubSection">
        <xsl:sequence select="concat($sessionDir, string($context/ancestor::Section/@id), '/', 'subsubsection_', $idValue, '.xml')"/>        
      </xsl:when>
      <xsl:when test="$context/self::Imprint">
        <xsl:sequence select="concat('frontmatter', '/', 'topic_', 'imprint', '.xml')"/>        
      </xsl:when>
      <xsl:when test="$context/self::Preface">
        <xsl:sequence select="concat('frontmatter', '/', 'topic_', 'preface', '.xml')"/>        
      </xsl:when>
      <xsl:when test="$context/self::Introduction">
        <xsl:sequence select="concat('frontmatter', '/', 'topic_', 'introduction', '.xml')"/>        
      </xsl:when>
      <xsl:when test="$context/self::LearningOutcomes">
        <xsl:sequence select="concat('frontmatter', '/', 'topic_', 'outcomes', '.xml')"/>        
      </xsl:when>
      <xsl:when test="$context/self::Acknowledgements">
        <xsl:sequence select="concat('backmatter', '/', 'topic_', 'acknowledgements', '.xml')"/>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + [WARNING] getTopicUrl(): Unrecognized element type <xsl:sequence select="name($context)"/>.</xsl:message>
        <xsl:sequence select="concat('topics/', 'topic_', generate-id($context), '.xml')"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:function>
  
  
</xsl:stylesheet>
