<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:java="org.dita.dost.util.ImgUtils"
  xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"  
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="xs xd relpath java dita2html df"
  version="2.0">
  
  <!-- Common overrides to the base HTML transforms. Used by HTML2, EPUB
       Kindle, etc.
       
       Note: this file must be explicitly included by transforms from other
       plugins, it is not directly integrated into the base transforms as
       it would disturb normal HTML transformation processing.
  -->

  <!-- This is an override of the same template from dita2htmlmpl.xsl. It 
       uses xtrf rather than $OUTPUTDIR to provide the location of the
       graphic as authored, not as output.
    -->
  <xsl:template match="*[contains(@class,' topic/image ')]/@scale">
    
    <xsl:variable name="xtrf" as="xs:string" select="../@xtrf"/>
    <xsl:variable name="baseUri" as="xs:string" 
      select="relpath:getParent($xtrf)"/>
    <xsl:message> + [DEBUG] topic/image/@scale: baseUri="<xsl:sequence select="$baseUri"/>"</xsl:message>
    <xsl:message> + [DEBUG] topic/image/@scale: @href="<xsl:sequence select="../@origHref"/>"</xsl:message>
    
    <xsl:variable name="width">
      <xsl:choose>
        <xsl:when test="not(contains(../@href,'://'))">
          <xsl:value-of select="java:getWidth($baseUri, string(../@origHref))"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="height">
      <xsl:choose>
        <xsl:when test="not(contains(../@href,'://'))">
          <xsl:value-of select="java:getHeight($baseUri, string(../@origHref))"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="not(../@width) and not(../@height)">
      <xsl:attribute name="height">
        <xsl:value-of select="floor(number($height) * number(.) div 100)"/>
      </xsl:attribute>
      <xsl:attribute name="width">
        <xsl:value-of select="floor(number($width) * number(.) div 100)"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  
    <!-- Add for bodydiv  and sectiondiv-->
  <xsl:template match="*[contains(@class,' topic/bodydiv ') or contains(@class, ' topic/sectiondiv ')]">
    <div>
      <xsl:apply-templates select="." mode="set-output-class"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/fig ')]" mode="fig-fmt">
    <xsl:variable name="default-fig-class">
      <xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
    </xsl:variable>
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <xsl:call-template name="start-flagit">
      <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>     
    </xsl:call-template>
    <xsl:call-template name="start-revflag">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
    <div>
      <xsl:if test="$default-fig-class!=''">
        <xsl:attribute name="class"><xsl:value-of select="$default-fig-class"/></xsl:attribute>
      </xsl:if>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$default-fig-class"/>
      </xsl:call-template>
      <xsl:message> + [DEBUG] topic/fig override: @id="<xsl:sequence select="@id"/>"</xsl:message>
      <xsl:if test="not(@id)">
        <xsl:attribute name="id" select="df:generate-dita-id(.)"/>
      </xsl:if>
      <xsl:call-template name="gen-style">
        <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="setscale"/>
      <xsl:call-template name="setidaname"/>
      <div class="figbody">
        <xsl:apply-templates select="node() except (*[contains(@class,' topic/title ')], 
          *[contains(@class,' topic/desc ')])
          "/>
      </div>
      <!-- WEK: Put the figure label below the figure content -->
      <xsl:call-template name="place-fig-lbl"/>
    </div>
    <xsl:call-template name="end-revflag">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
    <xsl:call-template name="end-flagit">
      <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param> 
    </xsl:call-template>
    <xsl:value-of select="$newline"/>
  </xsl:template>
  
  
  
  
</xsl:stylesheet>