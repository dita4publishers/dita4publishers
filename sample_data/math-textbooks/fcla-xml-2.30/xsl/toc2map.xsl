<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="xs xd html m xlink"
  version="2.0">
  
  <!-- Generates a DITA map from the HTML ToC page -->
  
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="html:html">
    <xsl:apply-templates select="html:body"/>
  </xsl:template>
  
  <xsl:template match="html:body">
    <map>
      <keydefs>
        <xsl:apply-templates select="html:div[@class = 'tableofcontents']" mode="make-keydefs"/>
      </keydefs>
      <topicgroup>
        <xsl:apply-templates select="html:div[@class = 'tableofcontents']"/>
      </topicgroup>
    </map>
  </xsl:template>
  
  <xsl:template match="html:div" mode="make-keydefs">
    <xsl:apply-templates select=".//html:a" mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="make-keydefs" match="html:a[@href]">
    <xsl:variable name="targetUrl" select="@href" as="xs:string"/>
    <xsl:variable name="filepart" select="tokenize($targetUrl, '#')[1]" as="xs:string"/>
    <xsl:variable name="key" select="substring-before($filepart, '.xml')" as="xs:string"/>
    <keydef keys="{$key}"
      href="topics/{$key}.dita"
     />
    
  </xsl:template>
  
  <xsl:template match="html:div">
    <xsl:for-each-group select="*" group-starting-with="html:span[@class = 'likepartToc']">
      <xsl:choose>
        <xsl:when test="self::html:span[@class = 'likepartToc']">
          <xsl:variable name="targetUrl" select="html:a/@href" as="xs:string"/>
          <xsl:variable name="filepart" select="tokenize($targetUrl, '#')[1]" as="xs:string"/>
          <xsl:variable name="key" select="substring-before($filepart, '.xml')" as="xs:string"/>
          <part keyref="{$key}">
            <xsl:for-each-group select="current-group()[position() > 1]" group-starting-with="html:span[@class = 'likechapterToc']">
              <xsl:choose>
                <xsl:when test="self::html:span[@class = 'likechapterToc']">
                  <xsl:variable name="targetUrl" select="./html:a/@href" as="xs:string"/>
                  <xsl:variable name="filepart" select="tokenize($targetUrl, '#')[1]" as="xs:string"/>
                  <xsl:variable name="key" select="substring-before($filepart, '.xml')" as="xs:string"/>
                  <chapter keyref="{$key}">
                    <xsl:apply-templates select="current-group()[position() > 1]"/>
                  </chapter>              
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="current-group()"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each-group>
          </part>
        </xsl:when>
        <xsl:when test="self::html:span[@class = 'likechapterToc']">
          <xsl:for-each-group select="current-group()" group-starting-with="html:span[@class = 'likechapterToc']">
            <xsl:choose>
              <xsl:when test="self::html:span[@class = 'likechapterToc']">
                <xsl:variable name="targetUrl" select="./html:a/@href" as="xs:string"/>
                <xsl:variable name="filepart" select="tokenize($targetUrl, '#')[1]" as="xs:string"/>
                <xsl:variable name="key" select="substring-before($filepart, '.xml')" as="xs:string"/>
                <chapter keyref="{$key}">
                  <xsl:apply-templates select="current-group()[position() > 1]"/>
                </chapter>              
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="current-group()"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:otherwise>
          <!-- Ignore it -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="html:span[@class = 'likesectionToc'] | html:span[@class = 'sectionToc']">
    <xsl:variable name="targetUrl" select="html:a/@href" as="xs:string"/>
    <xsl:variable name="filepart" select="tokenize($targetUrl, '#')[1]" as="xs:string"/>
    <xsl:variable name="key" select="substring-before($filepart, '.xml')" as="xs:string"/>
    <subsection keyref="{$key}"/>    
  </xsl:template>
  
  
  <xsl:template match="html:br"/>

  <xsl:template match="*" >
    <xsl:message> - [WARN] Unhandled element <xsl:sequence select="concat(name(..), '/', '{', namespace-uri(.), '}',name(.))"/>, @class="<xsl:value-of select="@class"/>": <xsl:sequence select="substring(., 1, 40)"/></xsl:message>
  </xsl:template>
</xsl:stylesheet>