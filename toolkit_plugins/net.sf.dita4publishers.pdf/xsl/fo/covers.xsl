<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd relpath"
  version="2.0">

  <!-- Override of templates from the base root-processing.xsl -->
  
  <!-- NOTE: As of 1.5.4M2 there is no way to set arbitrary XSLT 
             properties for a transform type that extends
             the PDF2 transform type.
    -->
  <!-- URI of the graphic to use for the front cover. -->
  <xsl:param name="d4pFrontCoverGraphicUri" as="xs:string" select="''"/>

  <!-- URI of the graphic to use for the back cover. -->
  <xsl:param name="d4pBackCoverGraphicUri" as="xs:string" select="''"/>

  
  <xsl:template mode="getFrontCoverGraphicUri" match="/*">
    <xsl:choose>
      <xsl:when test="/*/opentopic:map/*[contains(@class, ' map/topicmeta ')]//*[contains(@class, ' topic/data ') and @name = 'd4pFrontCoverGraphic']">
          <xsl:sequence select="string((/*/opentopic:map/*[contains(@class, ' map/topicmeta ')]//*[contains(@class, ' topic/data ') and @name = 'd4pFrontCoverGraphic'])[1]/@value)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$d4pFrontCoverGraphicUri"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="getBackCoverGraphicUri" match="/*">
    <xsl:choose>
      <xsl:when test="/*/opentopic:map/*[contains(@class, ' map/topicmeta ')]//*[contains(@class, ' topic/data ') and @name = 'd4pBackCoverGraphic']">
          <xsl:sequence select="string((/*/opentopic:map/*[contains(@class, ' map/topicmeta ')]//*[contains(@class, ' topic/data ') and @name = 'd4pBackCoverGraphic'])[1]/@value)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$d4pBackCoverGraphicUri"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="createFrontCover">
    <xsl:param name="frontCoverGraphicUri" as="xs:string"/>
    <!-- Template to create the front cover. 
    -->
    <xsl:variable name="coverTopics">
      <xsl:apply-templates select="/*/opentopic:map" mode="getFrontCoverTopics"/>
    </xsl:variable>
    <xsl:message>[DEBUG] createFrontCover: $coverTopics="<xsl:sequence select="$coverTopics"/>"</xsl:message>
    <xsl:choose>
      <xsl:when test="$coverTopics != ''">
        <xsl:message>[DEBUG]   Applying templates to $coverTopics...</xsl:message>
        <xsl:apply-templates select="$coverTopics" mode="constructFrontCover"/>
      </xsl:when>
      <xsl:when test="$frontCoverGraphicUri != ''">
        <xsl:call-template name="constructFrontCoverFromGraphic">
          <xsl:with-param name="frontCoverGraphicUri" 
            select="$frontCoverGraphicUri" 
            as="xs:string"/>
        </xsl:call-template>
     </xsl:when>
      <xsl:otherwise>
        <!-- Construct the title from the publication metadata -->
        <xsl:message>[DEBUG] No cover topics, calling createFrontMatter_1.0 template</xsl:message>
        <xsl:call-template name="createFrontMatter_1.0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="getFrontCoverTopics getBackCoverTopics" match="text()"/>
  
  <xsl:template mode="getFrontCoverTopics" match="*[contains(@class, ' map/topicref ')][@outputclass = 'frontCover']">
    <xsl:message>[DEBUG] getFrontCoverTopics: Context item is <xsl:sequence select="concat(name(.), ' id=', @id)"/></xsl:message>
    <xsl:variable name="targetId" select="string(@id)" as="xs:string"/>
    <xsl:sequence select="(//*[contains(@class, ' topic/topic ')][@id = $targetId])[1]"/>
  </xsl:template>
  
  <xsl:template mode="getBackCoverTopics" match="*[contains(@class, ' map/topicref ') and @outputclass = 'backCover']">
    <xsl:sequence select="(//*[contains(@class, ' topic/topic ') and @id = @id])[1]"/>
  </xsl:template>
  
  <xsl:template mode="constructFrontCover" match="*[contains(@class, ' topic/topic ')]">
    <xsl:call-template name="makeFrontCoverPageSequence">
      <xsl:with-param name="flowContent" as="node()*">
        <fo:block>
        <xsl:apply-templates mode="#current" select="*[contains(@class, ' topic/body ')]"/>
        </fo:block>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template mode="constructFrontCover constructBackCover" 
                match="*[contains(@class, ' topic/body ')]">
    <xsl:message>[DEBUG]constructFrontCover constructBackCover: Handling topic/body...</xsl:message>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="constructFrontCoverFromGraphic">
    <xsl:param name="frontCoverGraphicUri" as="xs:string"/>
    
    <xsl:call-template name="makeFrontCoverPageSequence">
      <xsl:with-param name="flowContent" as="node()*">
        <fo:block>
          <fo:external-graphic xsl:use-attribute-sets="front-cover-graphic"
            src="url('{$d4pFrontCoverGraphicUri}')"
          />
        </fo:block>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="makeFrontCoverPageSequence">
    <xsl:param name="flowContent" as="node()*"/>
    <fo:page-sequence master-reference="front-cover" format="i" xsl:use-attribute-sets="__force__page__count">
      <fo:flow flow-name="xsl-region-body">
        <xsl:sequence select="$flowContent"/>
      </fo:flow>
    </fo:page-sequence>

  </xsl:template>

  <xsl:template mode="constructBackCover" match="*[contains(@class, ' topic/topic ')]">
    <xsl:call-template name="makeBackCoverPageSequence">
      <xsl:with-param name="flowContent" as="node()*">
        <xsl:apply-templates mode="#current" select="*[contains(@class, ' topic/body ')]"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="makeBackCoverPageSequence">
    <xsl:param name="flowContent" as="node()*"/>
    <fo:page-sequence master-reference="back-cover" xsl:use-attribute-sets="__force__page__count">
      <fo:flow flow-name="xsl-region-body">
        <xsl:sequence select="$flowContent"/>
      </fo:flow>
    </fo:page-sequence>

  </xsl:template>

  <xsl:template mode="constructFrontCover" match="*[contains(@class, ' topic/body ')]">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template mode="constructBackCover" match="*[contains(@class, ' topic/body ')]">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="createBackCover">
    <xsl:param name="backCoverGraphicUri" as="xs:string"/>

    <xsl:variable name="coverTopics">
      <xsl:apply-templates select="/*/opentopic:map" mode="getBackCoverTopics"/>
    </xsl:variable>
    <xsl:message>[DEBUG] createBackCover: $coverTopics="<xsl:sequence select="$coverTopics"/>"</xsl:message>
    <xsl:choose>
      <xsl:when test="$coverTopics != ''">
        <xsl:apply-templates select="$coverTopics" mode="constructFrontCover"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="constructBackCover"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="constructBackCover">
    <xsl:apply-templates select="/*/opentopic:map" mode="constructBackCover"/>
  </xsl:template>
  
  <xsl:template mode="constructBackCover" match="opentopic:map">
  </xsl:template>

</xsl:stylesheet>
