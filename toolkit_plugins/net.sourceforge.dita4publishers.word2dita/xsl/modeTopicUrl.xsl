<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="urn:local-functions"
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:m="http://www.w3.org/1998/Math/MathML"
      
      exclude-result-prefixes="xs rsiwp stylemap local relpath xsi"
  version="2.0">
  <!-- =========================================
       Word to DITA Framework
       
       Copyright (c) 2014 DITA for Publishers
       
       Base implementation for the "topic-url" mode,
       which constructs the result URLs for 
       generated topics.
       
       Override these templates to implement your
       own map filenaming conventions.
       ========================================= -->
  <xsl:template match="rsiwp:topic" mode="topic-url">   
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:param name="topicrefType" as="xs:string"/>
    <xsl:param name="topicName" as="xs:string"/>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] rsiwp:topic, mode=topic-url: topicName=<xsl:sequence select="$topicName"/></xsl:message>
    </xsl:if>

    <xsl:variable name="finalTopicName" as="xs:string">
      <xsl:choose>
        <xsl:when test="$topicName = ''">
          <xsl:apply-templates mode="topic-name" select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$topicName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] rsiwp:topic, mode=topic-url: finalTopicName=<xsl:sequence select="$finalTopicName"/></xsl:message>
    </xsl:if>
    
    <xsl:variable name="result" select="concat('topics/', $topicName, $topicExtension)"/>
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] rsiwp:topic, mode=topic-url: result="<xsl:sequence select="$result"/>"</xsl:message>
    </xsl:if>
    <xsl:sequence select="$result"/>
  </xsl:template>
  
  <xsl:template match="rsiwp:topic" mode="topic-name">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <!-- Generates the name for a topic, which can then be
         used in IDs and filenames.
      -->
    <xsl:variable name="treePosString" as="xs:string">
      <!-- This numbering numbers the topics sequentially through the map
        
           - The root topic (if there is no map)
           - Each topicref
           - Each non-document-root topic           
      
      -->
      <xsl:number count="
        rsiwp:topicref |
        rsiwp:body/rsiwp:topic |
        rsiwp:topic[parent::rsiwp:topic]" format="_01_01"
        from="/"
        level="any"
      />
    </xsl:variable>
    
    <xsl:variable name="result" select="concat($fileNamePrefix, 'topic', string-join($treePosString, ''))"/>
    <xsl:sequence select="$result"/>
    
  </xsl:template>  
 
  <xsl:template match="text()" mode="topic-url"/>   
  
 
  <xsl:template match="rsiwp:*" mode="topic-url">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <xsl:message> - [WARNING] Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/> in mode 'topic-url'</xsl:message>
    <xsl:variable name="topicTitleFragment">
      <xsl:choose>
        <xsl:when test="contains(.,' ')">
          <xsl:value-of select="replace(substring-before(.,' '),'[\p{P}\p{Z}\p{C}]','')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="replace(.,'[\p{P}\p{Z}\p{C}]','')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="concat('topics/topic_', $topicTitleFragment, '_', generate-id(.),format-time(current-time(),'[h][m][s]'), '.dita')"/>
  </xsl:template>
  
</xsl:stylesheet>