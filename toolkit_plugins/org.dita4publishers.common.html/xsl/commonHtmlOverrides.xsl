<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:java="org.dita.dost.util.ImgUtils"
  xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"  
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:enum="http://dita4publishers.org/enumerables"
  exclude-result-prefixes="xs xd relpath java dita2html df enum"
  xmlns="http://www.w3.org/1999/xhtml"  
  version="2.0">
  
  <!-- Common overrides to the base HTML transforms. Used by HTML2, EPUB
       Kindle, etc.
       
       Note: this file must be explicitly included by transforms from other
       plugins, it is not directly integrated into the base transforms as
       it would disturb normal HTML transformation processing.
  -->
  
  <xsl:include href="flaggingOverrides.xsl"/>
 

  <!-- This is an override of the same template from dita2htmlmpl.xsl. It 
       uses xtrf rather than $OUTPUTDIR to provide the location of the
       graphic as authored, not as output.
    -->
  <xsl:template match="*[contains(@class,' topic/image ')]/@scale">
    
    <xsl:variable name="xtrf" as="xs:string" select="../@xtrf"/>
    <xsl:variable name="baseUri" as="xs:string" 
      select="relpath:getParent($xtrf)"/>
    
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
<!-- WEK: For 1.7, start-revflag is deprecated. See flag.xsl
      <xsl:call-template name="start-revflag">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
-->    <div>
      <xsl:if test="$default-fig-class!=''">
        <xsl:attribute name="class"><xsl:value-of select="$default-fig-class"/></xsl:attribute>
      </xsl:if>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$default-fig-class"/>
      </xsl:call-template>
      <xsl:if test="not(@id)">
        <xsl:attribute name="id" select="df:generate-dita-id(.)"/>
      </xsl:if>
<!--   WEK: For 1.7, this template is deprecated.
        <xsl:call-template name="gen-style">
        <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>
      </xsl:call-template>
-->      
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
<!-- WEK: end-revflag is deprecated in 1.7
     <xsl:call-template name="end-revflag">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
-->   
    <xsl:call-template name="end-flagit">
      <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param> 
    </xsl:call-template>
    <xsl:value-of select="$newline"/>
  </xsl:template>
  
  <xsl:template name="place-fig-lbl">
    <xsl:param name="stringName"/>
    <xsl:param name="collected-data" as="element()*" tunnel="yes"/>
    
    <!-- FIXME: This override uses the D4P enumeration mode to generate
      the figure label. Need to hook in the localization logic from
      the base version.
      -->
    <!-- Number of fig/title's including this one -->
    <xsl:variable name="ancestorlang">
      <xsl:call-template name="getLowerCaseLang"/>
    </xsl:variable>
    <xsl:choose>
      <!-- title -or- title & desc -->
      <xsl:when test="*[contains(@class,' topic/title ')]">
        <xsl:variable name="sourceId" select="df:generate-dita-id(.)" as="xs:string"/>
        <span class="figcap">
          <xsl:apply-templates select="$collected-data/enum:enumerables//*[@sourceId = $sourceId]"
            mode="enumeration"/>
          <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="figtitle"/>
        </span>
        <xsl:if test="*[contains(@class,' topic/desc ')]">
          <xsl:text>. </xsl:text>
          <span class="figdesc">
            <xsl:for-each select="*[contains(@class,' topic/desc ')]"><xsl:call-template name="commonattributes"/></xsl:for-each>
            <xsl:apply-templates select="*[contains(@class,' topic/desc ')]" mode="figdesc"/>
          </span>
        </xsl:if>
      </xsl:when>
      <!-- desc -->
      <xsl:when test="*[contains(@class, ' topic/desc ')]">
        <span class="figdesc">
          <xsl:for-each select="*[contains(@class,' topic/desc ')]"><xsl:call-template name="commonattributes"/></xsl:for-each>
          <xsl:apply-templates select="*[contains(@class,' topic/desc ')]" mode="figdesc"/>
        </span>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="place-tbl-lbl">
    <xsl:param name="stringName"/>
    <xsl:param name="collected-data" as="element()*" tunnel="yes"/>
    
    <!-- normally: "Table 1. " -->
    <xsl:variable name="ancestorlang">
      <xsl:call-template name="getLowerCaseLang"/>
    </xsl:variable>
    
    <xsl:choose>
      <!-- title -or- title & desc -->
      <xsl:when test="*[contains(@class,' topic/title ')]">
        <caption>
          <span class="tablecap">
            <xsl:variable name="sourceId" select="df:generate-dita-id(.)" as="xs:string"/>
            <span class="tablecap">
              <xsl:apply-templates select="$collected-data/enum:enumerables//*[@sourceId = $sourceId]"
                mode="enumeration"/>
              <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="tabletitle"/>         
            </span>
          </span>
          <xsl:if test="*[contains(@class,' topic/desc ')]"> 
            <xsl:text>. </xsl:text>
            <span class="tabledesc">
              <xsl:for-each select="*[contains(@class,' topic/desc ')]"><xsl:call-template name="commonattributes"/></xsl:for-each>
              <xsl:apply-templates select="*[contains(@class,' topic/desc ')]" mode="tabledesc"/>
            </span>
          </xsl:if>
        </caption>
      </xsl:when>
      <!-- desc -->
      <xsl:when test="*[contains(@class,' topic/desc ')]">
        <span class="tabledesc">
          <xsl:for-each select="*[contains(@class,' topic/desc ')]"><xsl:call-template name="commonattributes"/></xsl:for-each>
          <xsl:apply-templates select="*[contains(@class,' topic/desc ')]" mode="tabledesc"/>
        </span>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/xref')]" mode="get-output-class">
    <!-- Add the link scope to the @class value -->
    <xsl:variable name="classValue"
      select="
      string(@scope)"
    />
    <xsl:sequence select="$classValue"/>
  </xsl:template>
  
  <xsl:template mode="get-output-class" match="*" priority="100">
    <xsl:apply-templates select="@*" mode="#current"/>
    <xsl:apply-imports/>
  </xsl:template>
  
  <xsl:template mode="get-output-class" name="get-output-class-for-simple-select-att"
    match="@audience | @platform | @product | @status | @otherprops | @rev"
    >
    <!-- Construct values of the form 'props_{propname}_{propvalue}' -->
    <xsl:sequence 
      select="for $token in tokenize(., ' ') return concat('props_', name(.), '_', $token, ' ')"
    />
  </xsl:template>
  
  <xsl:template mode="get-output-class" 
    match="@props"
    >
    <xsl:choose>
      <xsl:when test="not(contains(., '('))">
        <xsl:call-template name="get-output-class-for-simple-select-att"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:analyze-string select="normalize-space(.)" regex="\((\w+) (\w+)\)\s*">
          <xsl:matching-substring>
            
            <xsl:variable name="propname" select="regex-group(1)" as="xs:string"/>
            <xsl:variable name="propvalue" select="regex-group(2)" as="xs:string"/>
            <xsl:sequence select="concat('props_', $propname, '_', $propvalue, ' ')"/>
          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <!-- ignore it -->
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template mode="get-output-class" 
    match="@*" priority="-1"
    />
  
  <xsl:template match="*[df:class(., 'learningBase/lcTime')]">
    <div class="lcTime{if(@outputclass) then concat(' ', @outputclass) else ''}"><xsl:apply-templates/></div>
  </xsl:template>
  
  
</xsl:stylesheet>