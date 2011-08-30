<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:dita-ot-pdf="http://net.sf.dita-ot/transforms/pdf"
  exclude-result-prefixes="xs xd df dita-ot-pdf"
  version="2.0">

<!--    <xsl:variable name="d4pTopicEnumerationStyle" 
    as="xs:string"
    select="'toplevel-only'" 
  />
-->
<!--  <xsl:variable
    name="d4pTopicEnumerationStyle"
    as="xs:string"
    select="'military'"/>
    
    <xsl:variable
    name="d4pTopicEnumerationStyle"
    as="xs:string"
    select="'outline'"/>
-->
  <xsl:variable
    name="d4pTopicEnumerationStyle"
    as="xs:string"
    select="'military'"/>
  
  <!-- Templates for handling titles. 
    
       Overrides mode getTitle
       
    -->
  <xsl:template
    match="*[df:class(., 'topic/title')]"
    mode="enumeration"
    >
    <xsl:param name="pubRegion" as="xs:string" tunnel="yes" select="'not-set'"/>
<!--    <xsl:message>+ [DEBUG] Mode enumeration, catch-all: pubRegion=<xsl:sequence select="$pubRegion"/></xsl:message>-->
<!--    <xsl:message>+ [DEBUG] Mode enumeration: topic <xsl:sequence select="string(../@id)"/> not in body or appendices region.</xsl:message>-->
  </xsl:template>
  
  <xsl:template
    match="*[$d4pTopicEnumerationStyle != 'toplevel-only']
             [df:class(., 'topic/title')]
             [not(dita-ot-pdf:determineTopicType(.) = 
                    ('topicPart', 'topicChapter',  'topicAppendix'))]
             [dita-ot-pdf:getPublicationRegion(..) = ('body', 'appendices')]"
    priority="10"
    mode="enumeration">
    <xsl:param name="pubRegion" as="xs:string" tunnel="yes" select="'not-set'"/>
    
    <xsl:variable name="numberSeparator">
      <xsl:call-template name="titleNumberSeparator"/>              
    </xsl:variable>
    
    <xsl:variable name="chapterNumberFormat" as="xs:string"
      select="
      if ($pubRegion = 'appendices')
         then 'A'
         else '1'
      "
    />
    
    <xsl:variable name="chapterNumber" as="xs:string">
      <xsl:number select=".."
        level="any"
        count="*[df:class(., 'topic/topic')][dita-ot-pdf:determineTopicType(.) = 
        ('topicChapter', 'topicAppendix')][dita-ot-pdf:getPublicationRegion(.) = $pubRegion]"
        format="{$chapterNumberFormat}"
      />
    </xsl:variable>
    
<!--    <xsl:message>+ [DEBUG] Mode enumeration: pubRegion = body: <xsl:sequence select="string(../@id)"/></xsl:message>-->
<!--    <xsl:message>+ [DEBUG] Mode enumeration: pubRegion=<xsl:sequence select="$pubRegion"/></xsl:message>-->
    
    <!-- NOTE: The numbering doesn't count part-topic ancestors. -->
    
    <xsl:variable
      name="number"
      as="xs:string?">
      <xsl:choose>
        <xsl:when
          test="$d4pTopicEnumerationStyle = 'military'">
          <xsl:variable name="formatSpec" as="xs:string"
            select="'.1.1.1'"
          />
          <xsl:variable name="nonChapterNumbers" as="xs:string">
            <xsl:number
              level="multiple"
              count="*[df:class(., 'topic/topic')][not(dita-ot-pdf:determineTopicType(.) = 
              ('topicPart', 'topicChapter', 'topicAppendix'))][dita-ot-pdf:getPublicationRegion(.) = $pubRegion]"
              select=".."
              format="{$formatSpec}"/>
          </xsl:variable>
          <xsl:sequence select="concat($chapterNumber, $nonChapterNumbers)"/>
        </xsl:when>
        <xsl:when
          test="$d4pTopicEnumerationStyle = 'outline'">
          <xsl:variable name="formatSpec" as="xs:string"
            select="'I.A.1.a.i.1'"
          />
          <xsl:number
            level="multiple"
            count="*[df:class(., 'topic/topic')][not(dita-ot-pdf:determineTopicType(.) = 
            ('topicPart'))][dita-ot-pdf:getPublicationRegion(.) =  $pubRegion]"
            select=".."
            format="{$formatSpec}"/>
        </xsl:when>
        <xsl:when
          test="$d4pTopicEnumerationStyle = 'toplevel-only'">
          <!-- Nothing to do as parts and chapter numbering is handled separately.
          --> 
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>- [WARN] Mode
            'enumeration': Unrecoganized
            d4pTopicEnumerationStyle
            value "<xsl:sequence
            select="$d4pTopicEnumerationStyle"/>"</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
   <xsl:message>+ [DEBUG] $number="<xsl:sequence select="$number"/>"</xsl:message>

   <!-- The numbering code can generate numbers of the form "..", so
        easier to just suppress those then to try to fix the
        number string generation.
     -->
    <xsl:if test="$number and not(matches($number, '\\.+'))">
      <fo:inline xsl:use-attribute-sets="topic-number-inline"
        ><xsl:sequence select="concat($number, $numberSeparator)"/>
      </fo:inline>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="titleNumberSeparator">
    <!-- Override this template to get a different
         separator after generated numbers in titles.
      -->
    <xsl:sequence select="'. '"/>
  </xsl:template>

  <xsl:template
    mode="enumeration"
    match="text()"/>

</xsl:stylesheet>
