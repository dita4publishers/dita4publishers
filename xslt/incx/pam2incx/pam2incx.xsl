<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:RSUITE="http://www.reallysi.com" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:idsc="http://www.reallysi.com/namespaces/indesign_style_catalog"
  xmlns:local="http://www.reallysi.com/functions/local"
  xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
  xmlns:xmp-x="adobe:ns:meta/"
  xmlns:pam="http://prismstandard.org/namespaces/pam/1.0/"
  xmlns:prism="http://prismstandard.org/namespaces/basic/1.2/"
  xmlns:pim="http://prismstandard.org/namespaces/pim/1.2/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="RSUITE xs idsc local ditaarch xmp-x pam prism dc pim xhtml"
  >
  <!-- =======================================================================
    
       Platts Gas Daily Proof Of Concept
       
       PAM 2 INCX Transform
       
       This transform takes PRISM/PAM XML and generates Adobe InCopy INCX
       XML for editing in InCopy. The generated INCX reflects Platts-specific
       paragraph and character styles.
       
       There is an inverse to this transform that converts INCX XML into PRISM/PAM
       XML for storage in RSuite.
       
       Copyright (c) 2008 Platts.
       
       $Revision: 1.20 $
    
    ======================================================================= -->
  
  <xsl:output indent="no" 
    cdata-section-elements="GrPr" />
  
  <xsl:strip-space elements="*"/>
  
  
  <xsl:template match="/">
    <xsl:text>&#x0a;</xsl:text>
    <xsl:processing-instruction name="aid">style="33" type="snippet" DOMVersion="5.0" readerVersion="4.0" featureSet="513" product="5.0(640)"</xsl:processing-instruction>
    <xsl:text>&#x0a;</xsl:text>
    <xsl:processing-instruction name="aid">SnippetType="InCopyInterchange"</xsl:processing-instruction>
    <xsl:text>&#x0a;</xsl:text>
    <xsl:variable name="metadataTagnameList" as="xs:string" select="string-join(/*/xhtml:head/*/name(), ' ')"/>
    
    <xsl:message> + [DEBUG] metatdataTagnameList="<xsl:sequence select="$metadataTagnameList"/>"</xsl:message>
    <SnippetRoot><xsl:text>&#x0a;</xsl:text>
      <!-- Paragraph and character style definitions go here -->
      <xsl:apply-templates select="$styleCatalog/*" mode="generateStyles"/>
      <xsl:text>&#x0a;</xsl:text>
      <xsl:variable name="rsuiteMetadataLabels" select="local:makeMetadataLabels(/*[1])" as="xs:string*"/>
      <xsl:variable name="entryCount" select="local:dec2hex(1 + count($rsuiteMetadataLabels))" as="xs:string"/>
      <cflo Self="rc_ub0" ptag="x_{$entryCount}_x_2_c_Label_c_{$metadataTagnameList}_{string-join($rsuiteMetadataLabels, '_')}"><xsl:text>&#x0a;</xsl:text>
        
        <!-- include XMP -->
        <cMep Self="{ concat('rc_',generate-id()) }">
          <pcnt>
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:apply-templates mode="XMP" select="/*"/>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
          </pcnt>
        </cMep>
        <xsl:apply-templates/>        
        <xsl:apply-templates select="//xhtml:table" mode="tables"/>
        <xsl:apply-templates select="//processing-instruction(chngtrk-Chng)" mode="makeChngNotes"/>
        <xsl:apply-templates select="//processing-instruction(notes-Note)" mode="makeNotes"/>
      </cflo><xsl:text>&#x0a;</xsl:text>
    </SnippetRoot>
  </xsl:template>
  
  <xsl:template match="pam:article">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="xhtml:head"/><!-- Suppress in default mode -->
  
  <xsl:template match="xhtml:body">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xhtml:body/text()"/> <!-- Suppress white space outside of block containers -->
    
  <xsl:template match="xhtml:h1">
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" select="local:getStyleName(.,'Head')" tunnel="yes" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="xhtml:h2">
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" select="local:getStyleName(.,'Head')" tunnel="yes" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="xhtml:p">
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" select="local:getStyleName(.,'Body')" tunnel="yes" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="xhtml:p[@class = 'byline']">
    <!-- FIXME: This is a bit of a hack for now. The byline is presented inline in the InCopy but
         is tagged as a separate paragraph in the XML.
      -->
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" select="local:getStyleName(.,'Body')" tunnel="yes" as="xs:string"/>
      <xsl:with-param name="cStyle" select="'Byline'" tunnel="yes" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>
  
  <!--
  <xsl:template match="xhtml:table">
    <txsr><xsl:text>&#x0a;</xsl:text>
      <pcnt>c_<xsl:processing-instruction name="aid">Char="16" Self="rc_<xsl:value-of select="generate-id()"/>marker"</xsl:processing-instruction></pcnt><xsl:text>&#x0a;</xsl:text>      
    </txsr><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  -->
  
  <xsl:template match="xhtml:table"/>
  
  
  <xsl:template match="pam:article" mode="XMP" xmlns="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <xsl:processing-instruction name="xpacket">begin="&#xfeff;" id="W5M0MpCehiHzreSzNTczkc9d"</xsl:processing-instruction>
    <x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 4.0-c006 1.236519, Wed Jun 14 2006 08:31:24">
      <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
        <rdf:Description rdf:about=""
          xmlns:xap="http://ns.adobe.com/xap/1.0/"
          xmlns:xapGImg="http://ns.adobe.com/xap/1.0/g/img/">
          <xap:CreatorTool>Adobe InCopy 5.0</xap:CreatorTool>
        </rdf:Description>
        <rdf:Description rdf:about=""
          xmlns:dc="http://purl.org/dc/elements/1.1/">
          <dc:format>application/x-incopy</dc:format>
          <xsl:apply-templates select="xhtml:head/dc:*" mode="XMP"/>
        </rdf:Description>
        <rdf:Description rdf:about=""
          xmlns:prism="http://prismstandard.org/namespaces/basic/1.2/">
          <xsl:apply-templates select="xhtml:head/prism:*" mode="XMP"/>
        </rdf:Description>
      </rdf:RDF>
    </x:xmpmeta>
    <xsl:processing-instruction name="xpacket">end="r"</xsl:processing-instruction>
  </xsl:template>
  
  <xsl:template match="dc:subject[1]" mode="XMP" priority="10">
    <!-- All the subjects need to be grouped together in a single
         ref:Bag element.
    -->
    <xsl:text>&#x0a;</xsl:text><dc:subject>
    <rdf:Bag xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><xsl:text>&#x0a;</xsl:text>
      <xsl:apply-templates select="self::* | self::*/following-sibling::dc:subject" mode="rdf-bag"/>
    </rdf:Bag><xsl:text>&#x0a;</xsl:text>
    </dc:subject>
  </xsl:template>
  
  <xsl:template match="dc:subject" mode="rdf-bag" priority="10">
    <rdf:li  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><xsl:apply-templates/></rdf:li><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="dc:subject" mode="XMP" priority="9"/><!-- All but first subject in doc -->
  
  
  <xsl:template match="dc:* | prism:*" mode="XMP">
    <xsl:sequence select="."/><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="*" mode="XMP" priority="-1">
    <xsl:message> + WARNING: MODE "XMP": Unhandled element type: <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:template match="RSUITE:*"/>
  
  
  <xsl:template match="*" priority="-1">
    <xsl:message> + WARNING: Unhandled element type: <xsl:sequence select="name(..)"/>/<xsl:sequence select="name(.)"/></xsl:message>
    <xsl:call-template name="makeBlock-cont">
      <xsl:with-param name="pStyle" select="local:getStyleName(.,'Body')" tunnel="yes" as="xs:string"/>
    </xsl:call-template>
  </xsl:template>
  
  <!-- pass through table marker PIs, which aren't wrapped in <p>s in PAM XML -->
  
  <xsl:template match="processing-instruction(aid)" priority="-1">
    <xsl:param name="pStyle" select="'[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="cStyle" select="'[No character style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="txsrAtts" tunnel="yes" as="attribute()*"/>
    <xsl:variable name="pStyleObjId" select="local:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
    <xsl:variable name="cStyleObjId" select="local:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
    <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <xsl:sequence select="$txsrAtts"/>
      <pcnt>c_<xsl:sequence select="."/>&#x2029;</pcnt>
    </txsr>
  </xsl:template>
  
  <xsl:template name="makeBlock-cont">
    <xsl:param name="pStyle" select="'[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="cStyle" select="'[No character style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="txsrAtts" tunnel="yes" as="attribute()*"/>
    <xsl:variable name="pStyleObjId" select="local:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
    <xsl:variable name="cStyleObjId" select="local:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
    <!-- 
    <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <xsl:sequence select="$txsrAtts"/>
      <xsl:text>&#x0a;</xsl:text>
      <pcnt>c_<xsl:apply-templates select="text()|ticker|processing-instruction()" mode="cont"/></pcnt><xsl:text>&#x0a;</xsl:text>
    </txsr><xsl:text>&#x0a;</xsl:text>
    <txsr><xsl:text>&#x0a;</xsl:text>
      <pcnt>c_<xsl:text>&#x2029;</xsl:text></pcnt><xsl:text>&#x0a;</xsl:text>
    </txsr><xsl:text>&#x0a;</xsl:text>
    -->
    <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <xsl:sequence select="$txsrAtts"/>
      <pcnt>c_<xsl:apply-templates select="text()|ticker|processing-instruction()" mode="cont"/>
        <!-- add para character if not present in text() -->
      <xsl:if test="not(matches(.,'&#x2029;$'))">&#x2029;</xsl:if>
      </pcnt>
    </txsr>
  </xsl:template>
  
  <xsl:template match="idsc:InDesign_Style_Catalog" mode="generateStyles">
    <xsl:message> + [DEBUG] processing InDesign_Style_Catalog</xsl:message>
    <xsl:apply-templates select="idsc:CharacterStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:ParagraphStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:TableStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:ObjectStyles" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="idsc:ParagraphStyles | idsc:CharacterStyles | idsc:TableStyles | idsc:ObjectStyles  " mode="generateStyles">
    <xsl:message> + [DEBUG] Context node=<xsl:sequence select="name(.)"/></xsl:message>
    
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:cStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'csty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template name="makeStyleElement">
    <xsl:param name="tagName" select="xs:string"/>
    <xsl:message> + [DEBUG] makeStyleElement: tagName=<xsl:sequence select="$tagName"/></xsl:message>
    <xsl:element name="{$tagName}">
      <xsl:attribute name="pnam" select="concat('k_', @name)"/>
      <xsl:attribute name="Self" select="concat('rc_', generate-id())"/>
      <xsl:sequence select="@*[not(contains('^base^name^', concat('^', name(.), '^')))]"/>
      <xsl:if test="@base != ''">
        <xsl:attribute name="basd" select="concat('k_', @base)"/>
      </xsl:if>
    </xsl:element>
    
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:pStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'psty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:tStyle">
    <xsl:message> + [DEBUG] processing idsc:tStyle</xsl:message>
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'tsty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:objStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'ObSt'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:function name="local:getObjectIdForParaStyle" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
<!--    <xsl:message> + [DEBUG] getObjectIdForParaStyle(): styleName="<xsl:sequence select="$styleName"/>"</xsl:message>-->
    <xsl:variable name="targetStyle" select="$styleCatalog/*/idsc:ParagraphStyles/idsc:pStyle[@name = $styleName]" as="element()?"/>
    <xsl:variable name="styleId" 
      select="if ($targetStyle) 
      then generate-id($targetStyle)
      else 'styleNotFound'"
      as="xs:string"
    />
<!--    <xsl:message> + [DEBUG] getObjectIdForParaStyle(): styleId="<xsl:sequence select="$styleId"/>"</xsl:message>-->
    <xsl:value-of select="$styleId"/>
  </xsl:function>
  
  <xsl:function name="local:getStyleName" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:param name="baseStyleName" as="xs:string"/>
    <xsl:variable name="section" as="xs:string" 
    select="lower-case(string(root($context)/*/RSUITE:METADATA/RSUITE:LAYERED/RSUITE:DATA[@RSUITE:NAME = 'prism-section']))"/>
    <xsl:choose>
      <xsl:when test="$section = 'briefs'">
        <xsl:sequence select="concat('Brief_', $baseStyleName)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="$baseStyleName"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
  
  <xsl:function name="local:getObjectIdForTableStyle" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <!--    <xsl:message> + [DEBUG] getObjectIdForTableStyle(): styleName="<xsl:sequence select="$styleName"/>"</xsl:message>-->
    <xsl:variable name="targetStyle" select="$styleCatalog/*/idsc:TableStyles/idsc:tStyle[@name = $styleName]" as="element()?"/>
    <xsl:variable name="styleId" 
      select="if ($targetStyle) 
      then generate-id($targetStyle)
      else 'styleNotFound'"
      as="xs:string"
    />
    <!--    <xsl:message> + [DEBUG] getObjectIdForTableStyle(): styleId="<xsl:sequence select="$styleId"/>"</xsl:message>-->
    <xsl:value-of select="$styleId"/>
  </xsl:function>
  
  <xsl:function name="local:getObjectIdForCharacterStyle" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <xsl:variable name="targetStyle" select="$styleCatalog/*/idsc:CharacterStyles/idsc:cStyle[@name = $styleName]" as="element()?"/>
    <xsl:variable name="styleId" 
      select="if ($targetStyle) 
      then generate-id($targetStyle)
      else 'styleNotFound'"
      as="xs:string"
    />
    <xsl:value-of select="$styleId"/>
  </xsl:function>
  
  <xsl:function name="local:normalizeText" as="xs:string">
    <xsl:param name="inString" as="xs:string"/>
    <xsl:variable name="noBreaks" select="replace($inString, '[&#x2029;&#x0A;]', '')" as="xs:string"/>
    <xsl:variable name="outString" select="replace($noBreaks, '[ ]+', ' ')" as="xs:string"/>
    <xsl:value-of select="$outString"/>
  </xsl:function>
  
  <xsl:function name="local:makeMetadataLabels" as="xs:string*">
    <!-- Produces a sequence two-item arrays reflecting the RSUITE metadata. -->
    <xsl:param name="elem" as="element()"/>
    <xsl:variable name="result" as="xs:string*">
      <xsl:for-each select="$elem/RSUITE:METADATA/RSUITE:SYSTEM/*">
        <xsl:sequence select="concat('x_2_c_', name(.), '_c_', string(.))"/>
      </xsl:for-each>
      <xsl:for-each select="$elem/RSUITE:METADATA/RSUITE:LAYERED/*">
        <xsl:variable name="name" select="string(./@RSUITE:NAME)"></xsl:variable>
        <xsl:variable name="id" select="string(./@RSUITE:ID)"></xsl:variable>
        <xsl:sequence select="concat('x_2_c_', $name, '_c_', replace(string(.), '_', '~sep~'))"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:dec2hex" as="xs:string">
    <xsl:param name="dec" as="xs:integer"/>
<!--    <xsl:message> + [DEBUG] dec2hex(): dec="<xsl:sequence select="$dec"/>"</xsl:message>-->
    <xsl:variable name="hexDigits" select="('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F')" as="xs:string*"/>
    <xsl:variable name="result" as="xs:string">
      <xsl:choose>
        <xsl:when test="$dec &lt; 16">
          <xsl:sequence select="$hexDigits[$dec + 1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="concat(local:dec2hex($dec idiv 16), local:dec2hex($dec mod 16))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
<!--    <xsl:message> + [DEBUG] dec2hex(): result="<xsl:sequence select="$result"/>"</xsl:message>-->
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:makeCSpnAttr">
    <xsl:param name="colspan" as="xs:string"/>
    <xsl:param name="colCount" as="xs:integer"/>
    <xsl:choose>
          <!-- test for colspan value expressed as a percentage and process accordingly -->
          <xsl:when test="contains($colspan,'%')">
            <xsl:variable name="colspanValue" select="number(substring-before($colspan,'%'))"/>
            <xsl:variable name="multiplier" select="$colspanValue * .01"/>
            <xsl:variable name="colspan" select="xs:integer(round($colCount * $multiplier))" as="xs:integer"/>
            <xsl:value-of select="$colspan"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- if integer value, take and transfer -->
            <xsl:value-of select="$colspan"/>
          </xsl:otherwise>
        </xsl:choose>       
  </xsl:function>
  
  <!-- Placeholder rowspan function -->
  <!-- This is adapted from the colspan function above -->
  <!-- Haven't seen samples of this to know if it's appropriate, e.g. if rowspan is represented as a percentage like colspan is -->
  
  <xsl:function name="local:makeRSpnAttr">
    <!-- WEK: coded to account for possibility that default attributes aren't available in document being processed -->
    <xsl:param name="rowspanBase" as="xs:string"/>
    <xsl:param name="rowCount" as="xs:integer"/>
    <xsl:variable name="rowspan" select="if ($rowspanBase = '') then '1' else $rowspanBase" as="xs:string"/>
    <xsl:choose>
      <!-- test for rowspan value expressed as a percentage and process accordingly -->
      <xsl:when test="contains($rowspan,'%')">
        <xsl:variable name="rowspanValue" select="number(substring-before($rowspan,'%'))"/>
        <xsl:variable name="multiplier" select="$rowspanValue * .01"/>
        <xsl:variable name="rowspan" select="xs:integer(round($rowCount * $multiplier))" as="xs:integer"/>
        <xsl:message select="$rowspan"/>
        <xsl:value-of select="$rowspan"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- if integer value, take and transfer -->
        <xsl:value-of select="$rowspan"/>
      </xsl:otherwise>
    </xsl:choose>       
  </xsl:function>
  
  <xsl:function name="local:makeCcolElems" as="node()*">
    <xsl:param name="numCols" as="xs:integer"/>
    <xsl:param name="tableID" as="xs:string"/>
    <xsl:variable name="result" as="node()*">
      <xsl:for-each select="1 to $numCols">
        <xsl:element name="ccol">
          <xsl:attribute name="pnam" select="concat('rk_',position()-1)"/>
          <!-- Use default value for 6 column table for now. Should update to divide width of page by number of columns. -->
          <xsl:attribute name="klwd" select="'U_89.83333333333333'"/>
          <xsl:attribute name="Self" select="concat('rc_', $tableID, 'ccol',position()-1)"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:variable>
    <xsl:copy-of select="$result"/>
  </xsl:function>
  
  <!-- Tables: -->
  
  <xsl:template match="xhtml:table" mode="tables">
    <xsl:variable name="STof" select="@id"/>
    <xsl:variable name="colCounts" select="for $row in .//xhtml:tr return count($row/xhtml:td | $row/xhtml:th)" as="xs:integer*"/>
    <xsl:variable name="numRows" select="count(xhtml:tr)" as="xs:integer"/>
    <xsl:variable name="numCols" select="max($colCounts)" as="xs:integer"/>
    <xsl:variable name="tableID" select="generate-id(.)"/>
    <xsl:variable name="tStyle" select="'[Basic Table]'" as="xs:string"/>
    <xsl:variable name="tStyleObjId" select="local:getObjectIdForTableStyle($tStyle)" as="xs:string"/>
    <xsl:text>&#x0a;</xsl:text>
    <xsl:if test="xhtml:caption">
      <xsl:call-template name="makeTableCaption">
        <xsl:with-param name="caption" select="child::xhtml:caption" as="node()*"/>
      </xsl:call-template>
    </xsl:if>
    <ctbl ptzz="o_{$tStyleObjId}" STof="{$STof}" HRCt="l_0" FRCt="l_0" RwCt="l_{$numRows}" colc="l_{$numCols}" Self="rc_{generate-id()}"><xsl:text>&#x0a;</xsl:text>
      <xsl:apply-templates select="xhtml:tr" mode="crow"/>
      <!-- replace this apply templates with function to generate ccol elements.
        This apply-templates generates a ccol for every cell; just need one ccol for each column
      <xsl:apply-templates select="xhtml:tr" mode="ccol"/> -->
      <xsl:copy-of select="local:makeCcolElems($numCols,$tableID)"/>
      <xsl:apply-templates select="xhtml:tr | xhtml:td | xhtml:th">
        <xsl:with-param name="colCount" select="$numCols" as="xs:integer" tunnel="yes"/>
        <xsl:with-param name="rowCount" select="$numRows" as="xs:integer" tunnel="yes"/>
      </xsl:apply-templates>
    </ctbl><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="xhtml:tr" mode="crow">
    <xsl:variable name="rowIndex" select="count(preceding-sibling::xhtml:tr)" as="xs:integer"/>
    <!-- changed MFHO from "17" to "1" -->
    <crow pnam="rk_{$rowIndex}" MFHo="U_1" Self="rc_{generate-id(..)}crow{$rowIndex}"/><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
     
  <xsl:template match="xhtml:tr">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xhtml:td | xhtml:th">
    <xsl:param name="colCount" as="xs:integer" tunnel="yes"/>
    <xsl:param name="rowCount" as="xs:integer" tunnel="yes"/>
    <xsl:variable name="rowNumber" select="count(../preceding-sibling::xhtml:tr)" as="xs:integer"/>
    <xsl:variable name="colNumber" select="count(preceding-sibling::xhtml:td | preceding-sibling::xhtml:th)" as="xs:integer"/>
    <xsl:variable name="colspan">
      <xsl:choose>
        <xsl:when test="@colspan">
          <xsl:value-of select="@colspan"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rowspan">
      <xsl:choose>
        <xsl:when test="@rowspan">
          <xsl:value-of select="@rowspan"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="colSpan" select="local:makeCSpnAttr($colspan,$colCount)"/>
    <xsl:variable name="rowSpan" select="local:makeRSpnAttr($rowspan,$rowCount)"/>
    <!-- <xsl:message select="concat('[DEBUG: r: ',$colSpan,' c: ',$rowSpan)"/> -->
    <xsl:text> </xsl:text><ccel pnam="rk_{$colNumber}:{$rowNumber}" RSpn="l_{$rowSpan}" CSpn="l_{$colSpan}" pcst="o_u75" ppcs="l_0" Self="rc_{generate-id()}"><xsl:text>&#x0a;</xsl:text>
      <!-- must wrap cell contents in txsr and pcnt -->
      <xsl:variable name="pStyle" as="xs:string">
        <xsl:choose>
        <xsl:when test="local-name(.) = 'th'">
          <xsl:value-of select="'Columnhead'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'tableRow'"></xsl:value-of>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="cStyle" select="'[No character style]'" as="xs:string"/>
      <xsl:variable name="pStyleObjId" select="local:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
      <xsl:variable name="cStyleObjId" select="local:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
      <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <pcnt><xsl:text>c_</xsl:text><xsl:apply-templates/></pcnt>
      </txsr>
      <xsl:text> </xsl:text></ccel><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template name="makeTableCaption">
    <xsl:param name="caption" as="node()*"/>
    <xsl:variable name="pStyle" select="'tableCaption'" as="xs:string"/>
    <xsl:variable name="cStyle" select="'[No character style]'" as="xs:string"/>
    <xsl:variable name="pStyleObjId" select="local:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
    <xsl:variable name="cStyleObjId" select="local:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
    <txsr prst="o_{$pStyleObjId}" crst="o_{$cStyleObjId}">
      <pcnt><xsl:text>c_</xsl:text><xsl:value-of select="$caption"/></pcnt>
    </txsr>
  </xsl:template>
  
  <!-- Handle processing instructions. -->
  <!-- Insertion point markers, changes, and notes are all represented as PIs in the PAM XML. -->
  
  <!-- Simply pass through insertion point markers.  -->
  
  <xsl:template match="processing-instruction(aid)" mode="cont">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <!-- Translate Changes and Notes back into respective elements. -->
  
  <xsl:template match="//processing-instruction(chngtrk-Chng)" mode="makeChngNotes">
    <Chng>
      <xsl:variable name="selfAttr" select="substring-before(substring-after(.,'Self=&quot;'),'&quot;')"/>
      <xsl:variable name="PItokens" select="tokenize(.,' ')" as="item()*"/>
      <xsl:for-each select="$PItokens">
        <xsl:if test="contains(.,'=')">
        <xsl:attribute name="{substring-before(.,'=')}" select="substring-before(substring-after(.,'=&quot;'),'&quot;')"/>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="following-sibling::processing-instruction(chngtrk-txsr)">
        <xsl:if test="contains(., concat('ChngID=&quot;',$selfAttr,'&quot;'))">
          <txsr>
            <xsl:variable name="txsrPItokens" select="tokenize(.,' ')" as="item()*"/>
            <xsl:for-each select="$txsrPItokens">
              <xsl:if test="contains(.,'=')">
                <xsl:choose>
                  <xsl:when test="contains(.,'ChngID=')"/>
                  <xsl:when test="contains(.,'Text=')"/>
                  <xsl:otherwise>
                    <xsl:attribute name="{substring-before(.,'=')}" select="substring-before(substring-after(.,'=&quot;'),'&quot;')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
            <pcnt>
              <xsl:variable name="textAttr" select="substring-before(substring-after(.,'Text=&quot;'),'&quot;')"/>
              <xsl:value-of select="$textAttr"/>
            </pcnt>
          </txsr>
        </xsl:if>
      </xsl:for-each>
    </Chng>
  </xsl:template>
  
  <xsl:template match="//processing-instruction(notes-Note)" mode="makeNotes">
    <Note>
      <xsl:variable name="selfAttr" select="substring-before(substring-after(.,'Self=&quot;'),'&quot;')"/>
      <xsl:variable name="PItokens" select="tokenize(.,' ')" as="item()*"/>
      <xsl:for-each select="$PItokens">
        <xsl:if test="contains(.,'=')">
          <xsl:attribute name="{substring-before(.,'=')}" select="substring-before(substring-after(.,'=&quot;'),'&quot;')"/>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="following-sibling::processing-instruction(notes-txsr)">
        <xsl:if test="contains(., concat('NoteID=&quot;',$selfAttr,'&quot;'))">
          <txsr>
            <xsl:variable name="txsrPItokens" select="tokenize(.,' ')" as="item()*"/>
            <xsl:for-each select="$txsrPItokens">
              <xsl:if test="contains(.,'=')">
                <xsl:choose>
                  <xsl:when test="contains(.,'NoteID=')"/>
                  <xsl:when test="contains(.,'Text=')"/>
                  <xsl:otherwise>
                    <xsl:attribute name="{substring-before(.,'=')}" select="substring-before(substring-after(.,'=&quot;'),'&quot;')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
            <pcnt>
              <xsl:variable name="textAttr" select="substring-before(substring-after(.,'Text=&quot;'),'&quot;')"/>
              <xsl:value-of select="$textAttr"/>
            </pcnt>
          </txsr>
        </xsl:if>
      </xsl:for-each>
    </Note>
  </xsl:template>
  
  
  <!-- Style catalog: -->
  
  <xsl:variable name="styleCatalog">
    <idsc:InDesign_Style_Catalog xmlns:idsc="http://www.reallysi.com/namespaces/indesign_style_catalog">
   <idsc:ParagraphStyles>
      <idsc:pStyle base="" name="[No paragraph style]" pnam="k_[No paragraph style]" smpt="b_f"
		   flcl="o_ub"
		   ptfs="c_Regular"
		   ptsz="U_12"
		   phzs="D_100"
		   pakm="k_Metrics"
		   ligt="b_t"
		   lnwt="U_1"
		   trak="D_0"
		   ptce="c_HL Composer"
		   dcca="s_0"
		   dcli="s_0"
		   bshf="U_0"
		   capm="e_norm"
		   lncl="o_ue"
		   hypl="s_3"
		   pvts="D_100"
		   inbl="U_0"
		   inbr="U_0"
		   infl="U_0"
		   alea="D_120"
		   szld="e_atil"
		   plng="k_English: USA"
		   hyph="b_t"
		   mibe="s_2"
		   miaf="s_2"
		   hypc="b_t"
		   swor="s_5"
		   nobk="b_f"
		   hyzo="U_36"
		   spbe="U_0"
		   spaf="U_0"
		   alts="x_0"
		   undr="b_f"
		   font="c_Times"
		   Ofst="e_Dflt"
		   wsde="D_100"
		   wsma="D_133"
		   wsmi="D_80"
		   lsde="D_0"
		   lsma="D_0"
		   lsmi="D_0"
		   gsde="D_100"
		   gsma="D_100"
		   gsmi="D_100"
		   pbbp="e_nbrk"
		   kept="b_f"
		   kwnx="s_0"
		   kfnl="s_2"
		   klnl="s_2"
		   posm="e_norm"
		   strk="b_f"
		   jcal="e_Jact"
		   kepl="b_f"
		   lint="D_-1"
		   filt="D_-1"
		   sovp="b_f"
		   ovpr="b_f"
		   pgsa="D_0"
		   pgfa="D_0"
		   pgsl="D_-1"
		   pgfl="D_-1"
		   pgss="x_2_U_0_U_0"
		   pgst="x_2_U_0_U_0"
		   pskw="D_0"
		   rlac="k_Text Color"
		   pras="D_1"
		   prat="D_-1"
		   paof="U_0"
		   pral="U_0"
		   pair="U_0"
		   rawd="e_Klwd"
		   rlbc="k_Text Color"
		   prbs="D_1"
		   prbt="D_-1"
		   pbop="U_0"
		   prbl="U_0"
		   pbir="U_0"
		   rbwd="e_Klwd"
		   prao="b_f"
		   prbo="b_f"
		   prb2="b_f"
		   prar="b_f"
		   prbr="b_f"
		   inlr="U_0"
		   hylw="b_t"
		   pals="e_full"
		   OTor="b_f"
		   OTfr="b_f"
		   OTdl="b_f"
		   OTti="b_f"
		   patp="o_di5a29"
		   pbtp="o_di5a29"
		   bala="e_BlOf"
		   alrs="x_0"
		   ragc="o_ue"
		   ragt="D_-1"
		   rago="b_f"
		   rbgc="o_ue"
		   rbgt="D_-1"
		   rbgo="b_f"
		   rbg2="b_f"
		   paln="e_left"
		   dcdm="l_0"
		   OTPf="e_none"
		   OTmk="b_t"
		   hypw="s_5"
		   OTlc="b_t"
		   hycf="b_t"
		   prak="b_f"
		   igEA="b_f"
		   OTzr="b_f"
		   OTss="l_0"
		   OThi="b_f"
		   OTca="b_t"
		   ulco="k_Text Color"
		   ulgc="o_ue"
		   upgo="b_f"
		   ulgt="D_-1"
		   ulos="U_-9999"
		   ulop="b_f"
		   ultt="D_-1"
		   ulwt="U_-9999"
		   ultp="o_di5a29"
		   stco="k_Text Color"
		   stgc="o_ue"
		   stgo="b_f"
		   stgt="D_-1"
		   stos="U_-9999"
		   Stvp="b_f"
		   sttt="D_-1"
		   sttp="o_di5a29"
		   stwt="U_-9999"
		   OTsw="b_f"
		   tsum="D_0"
		   jmoj="e_nada"
		   jmbs="D_-1"
		   jmas="D_-1"
		   jkin="e_nada"
		   jkit="e_Jkif"
		   jkht="e_none"
		   jbki="b_t"
		   jpro="b_t"
		   jrfs="D_-1"
		   jral="e_Jrjs"
		   jrtp="e_Jrpc"
		   jrfn="k_"
		   jrft="e_nada"
		   jrsp="e_Jr12"
		   jrwd="D_100"
		   jrpt="D_100"
		   jrxo="D_0"
		   jryo="D_0"
		   jrpz="e_Jkar"
		   jraa="b_t"
		   jrva="e_Jro1"
		   jrov="b_f"
		   jras="b_f"
		   jrsc="D_66"
		   jrfl="k_Text Color"
		   jrti="D_-1"
		   jrof="e_atil"
		   jrsk="k_Text Color"
		   jrst="D_-1"
		   jros="e_atil"
		   jrwt="D_-1"
		   jktp="e_none"
		   jkfz="D_-1"
		   jkfn="k_"
		   jkfs="e_nada"
		   jkcm="D_100"
		   jkpt="D_100"
		   jkpl="D_0"
		   jkal="e_Jknc"
		   jkp2="e_Jkar"
		   jkcc="k_"
		   jset="e_Jchi"
		   jkfc="k_Text Color"
		   jktn="D_-1"
		   jkof="e_atil"
		   jksc="k_Text Color"
		   jkst="D_-1"
		   jkos="e_atil"
		   jkwt="D_-1"
		   jtcy="b_f"
		   jtax="D_0"
		   jtay="D_0"
		   jatc="s_0"
		   jatr="b_f"
		   jjid="s_0"
		   jggy="s_0"
		   jga1="b_f"
		   jgal="e_none"
		   crot="D_0"
		   jro1="b_f"
		   jren="b_t"
		   jshp="D_0"
		   jsha="D_4500"
		   jsht="b_t"
		   jshr="b_f"
		   jwar="b_f"
		   jwli="s_2"
		   jwas="D_50"
		   jwls="D_0"
		   jwal="e_atil"
		   jmbb="s_2"
		   jmab="s_2"
		   hkna="b_f"
		   palt="b_f"
		   ital="b_f"
		   Jled="e_Jlab"
		   jslh="b_f"
		   jpgd="b_f"
		   jgrt="b_f"
		   jgfm="e_none"
		   jrtd="s_0"
		   jrtr="b_f"
		   jrts="b_t"
		   bnlt="e_LTno"
		   bncl="c_Text Color"
		   bnbc="x_2_e_BCuo_l_2022"
		   bnst="l_1"
		   bnsa="l_1"
		   DHnm="k_1, 2, 3, 4..."
		   bnns="k_1, 2, 3, 4..."
		   blfn="k_"
		   blft="e_nada"
		   nmfn="k_"
		   bnnl="o_u3d"
		   bnle="l_1"
		   bncp="b_t"
		   bnar="b_t"
		   bnbr="x_3_e_enap_l_0_l_0"
		   bnbs="o_u68"
		   bnnc="o_u68"
		   bnba="e_left"
		   bnna="e_left"
		   bnne="c_^#.^t"
		   bnta="c_^t"/>
      <idsc:pStyle base="[No paragraph style]" name="NormalParagraphStyle"
		   basd="k_[No paragraph style]"
		   pnam="k_NormalParagraphStyle"
		   smpt="b_f"
		   nxpa="o_u6b"
		   kbsc="x_2_s_0_s_0"/>
     <idsc:pStyle base="[No paragraph style]"    
       name="Head"
       pnam="c_~sep~Head"
       smpt="b_f"
       nxpa="o_u21c"
       kbsc="x_2_s_0_s_0"
       ptfs="c_77 Bold Condensed"
       ptsz="U_16"
       trak="D_-25"
       bshf="U_2"
       spbe="U_14.184000000000001"
       font="c_Helvetica Neue LT Std"
       jgal="e_Jabl"/>
     <idsc:pStyle base="[No paragraph style]"    
       name="Brief_Head"
       pnam="c_~sep~Brief~sep~Head"
       smpt="b_f"
       nxpa="o_u21c"
       kbsc="x_2_s_0_s_0"
       ptfs="c_Franklin Gothic Demi"
       ptsz="U_12"
       trak="D_0"
       bshf="U_2"
       spbe="U_14.184000000000001"
       font="c_Helvetica Neue LT Std"
       jgal="e_Jabl"/>
     <idsc:pStyle base="[No paragraph style]"    
       name="Body"
       basd="k_[No paragraph style]"
       pnam="c_~sep~Body"
       smpt="b_f"
       nxpa="o_u21d"
       kbsc="x_2_s_0_s_0"
       ptfs="c_Medium"
       ptsz="U_8.5"
       infl="U_14.184000000000001"
       szld="U_11"
       font="c_ITC Stone Serif Std"
       jgal="e_Jabl"/>
     <idsc:pStyle base="[No paragraph style]"    
       name="Brief_Body"
       basd="k_[No paragraph style]"
       pnam="c_~sep~Brief~sep~Body"
       smpt="b_f"
       nxpa="o_u21d"
       kbsc="x_2_s_0_s_0"
       ptfs="c_Medium"
       ptsz="U_8"
       infl="U_14.184000000000001"
       szld="U_9.5"
       font="c_ITC Stone Serif Std"
       jgal="e_Jabl"/>
     <idsc:pStyle base="[No paragraph style]"    
       name="Columnhead"
       basd="k_[No paragraph style]" 
       pnam="c_~sep~Table~sep~Columnhead" 
       smpt="b_f" 
       nxpa="o_uc0" 
       kbsc="x_2_s_0_s_0" 
       ptsz="U_7" 
       inbl="U_5.688" 
       inbr="U_5.688" 
       szld="U_9.5" 
       spbe="U_5.688" 
       spaf="U_5.688" 
       alts="x_5_z_4_7473616c_e_cent_74736163_k_._74736c64_k__706f736d_U_97_z_4_7473616c_e_cent_74736163_k_._74736c64_k__706f736d_U_133_z_4_7473616c_e_cent_74736163_k_._74736c64_k__706f736d_U_176_z_4_7473616c_e_cent_74736163_k_._74736c64_k__706f736d_U_208_z_4_7473616c_e_cent_74736163_k_._74736c64_k__706f736d_U_230" 
       font="c_Franklin Gothic Demi" 
       rlbc="o_ua3" 
       prbs="D_0.35" 
       prbt="D_50" 
       pbop="U_2.16"/>
     <idsc:pStyle base="[No paragraph style]"    
       name="tableCaption" 
       basd="k_[No paragraph style]" 
       pnam="c_~sep~GD~sep~Daily~sep~Title" 
       smpt="b_f" 
       nxpa="o_ubb" 
       kbsc="x_2_s_0_s_0" 
       ptfs="c_77 Bold Condensed" 
       ptsz="U_10" 
       inbl="U_5.688" 
       inbr="U_5.688" 
       spaf="U_4.247999999999999" 
       alts="x_5_z_4_7473616c_e_tbac_74736163_k_._74736c64_k__706f736d_U_97_z_4_7473616c_e_tbac_74736163_k_-_74736c64_k__706f736d_U_133_z_4_7473616c_e_tbac_74736163_k_-_74736c64_k__706f736d_U_176_z_4_7473616c_e_rght_74736163_k_._74736c64_k__706f736d_U_215_z_4_7473616c_e_rght_74736163_k_._74736c64_k__706f736d_U_236" 
       font="c_Helvetica Neue LT Std" 
       filt="D_0" 
       rlac="o_ua3" 
       pras="D_16" 
       paof="U_-4.247999999999999" 
       rlbc="o_ua3" 
       prbs="D_16" 
       prbt="D_100" 
       pbop="U_-4.247999999999999" 
       prar="b_t" 
       prak="b_t"/>
     <idsc:pStyle base="[No paragraph style]"
       name="tableRow"
       basd="k_[No paragraph style]" 
       pnam="c_~sep~GD~sep~Daily~sep~Row" 
       smpt="b_f" 
       nxpa="o_ub9" 
       kbsc="x_2_s_0_s_0" 
       ptsz="U_6.8" 
       inbl="U_5.688" 
       inbr="U_5.688" 
       szld="U_9.5" 
       alts="x_5_z_4_7473616c_e_tbac_74736163_k_._74736c64_k__706f736d_U_101_z_4_7473616c_e_tbac_74736163_k_-_74736c64_k__706f736d_U_136_z_4_7473616c_e_tbac_74736163_k_-_74736c64_k__706f736d_U_176_z_4_7473616c_e_rght_74736163_k_._74736c64_k__706f736d_U_215_z_4_7473616c_e_rght_74736163_k_._74736c64_k__706f736d_U_233" 
       font="c_Franklin Gothic Book" 
       rlbc="o_ua3" 
       prbs="D_0.35" 
       prbt="D_50" 
       pbop="U_2.16" 
       prbr="b_t" />
   </idsc:ParagraphStyles>
   <idsc:CharacterStyles>
      <idsc:cStyle base="" name="[No character style]" pnam="k_[No character style]" smpt="b_f"/>
     <idsc:cStyle base="[No character style]"    
       name="Byline"
       basd="k_[No character style]"
       pnam="c_~sep~Byline"
       smpt="b_f"
       kbsc="x_2_s_0_s_0"
       ptfs="c_Medium Italic"/>
   </idsc:CharacterStyles>
   <idsc:TableStyles>
      <idsc:tStyle base="" name="[No table style]" pthr="rl_0" ptfr="rl_0"
                   pnam="k_[No table style]"
                   HdSk="b_f"
                   FtSk="b_f"
                   CFfc="l_0"
                   CFsc="l_0"
                   CFof="b_f"
                   CFtf="D_20"
                   CFcf="o_u68"
                   CFcs="o_u6b"
                   CFts="D_100"
                   CFos="b_f"
                   TBsw="U_1"
                   TBss="o_di5a29"
                   TBsc="o_u68"
                   TBst="D_100"
                   TBso="b_f"
                   LBsw="U_1"
                   LBss="o_di5a29"
                   LBsc="o_u68"
                   LBst="D_100"
                   LBso="b_f"
                   BBsw="U_1"
                   BBss="o_di5a29"
                   BBsc="o_u68"
                   BBst="D_100"
                   BBso="b_f"
                   RBsw="U_1"
                   RBss="o_di5a29"
                   RBsc="o_u68"
                   RBst="D_100"
                   RBso="b_f"
                   RFcf="o_u68"
                   RFfc="l_0"
                   RFtf="D_20"
                   RFof="b_f"
                   RFsc="l_0"
                   RFcs="o_u6b"
                   RFts="D_100"
                   RFos="b_f"
                   TBgc="o_u6c"
                   TBgt="D_100"
                   TBgo="b_f"
                   LBgc="o_u6c"
                   LBgt="D_100"
                   LBgo="b_f"
                   BBgc="o_u6c"
                   BBgt="D_100"
                   BBgo="b_f"
                   RBac="o_u6c"
                   RBat="D_100"
                   RBao="b_f"
                   spbe="U_4"
                   spaf="U_-4"
                   CFPr="b_f"
                   tsdo="e_sbej"
                   CSfc="l_0"
                   CScf="o_u68"
                   CSwf="U_1"
                   CSsf="o_di5a29"
                   CStf="D_100"
                   CSof="b_f"
                   CSsc="l_0"
                   CScs="o_u68"
                   CSws="U_0.25"
                   CSss="o_di5a29"
                   CSts="D_100"
                   CSos="b_f"
                   CSgc="o_u6c"
                   CSgt="D_100"
                   CSgo="b_f"
                   CSgs="o_u6c"
                   CSas="D_100"
                   CSps="b_f"
                   RSfc="l_0"
                   RScf="o_u68"
                   RSwf="U_1"
                   RStf="D_100"
                   RSof="b_f"
                   RSsc="l_0"
                   RScs="o_u68"
                   RSws="U_0.25"
                   RSss="o_di5a29"
                   RSts="D_100"
                   RSos="b_f"
                   RSgc="o_u6c"
                   RSgt="D_100"
                   RSgo="b_f"
                   RSgs="o_u6c"
                   RSas="D_100"
                   RSps="b_f"
                   HdBt="e_IaTc"
                   FtBt="e_IaTc"
                   Sfsr="l_0"
                   Slsr="l_0"
                   Sfsc="l_0"
                   Slsc="l_0"
                   Sffr="l_0"
                   Slfr="l_0"
                   Sffc="l_0"
                   Slfc="l_0"
                   RSsf="o_di5a29"
                   Mnht="U_3"
                   Mxht="U_600"
                   Kwnr="b_f"
                   Strw="e_nbrk"
                   AuGw="b_t"
                   MFHo="U_3"
                   klwd="U_1"
                   NstT="U_4"
                   NstL="U_4"
                   NstB="U_4"
                   NstR="U_4"
                   flcl="o_u6b"
                   filt="D_100"
                   ovpr="b_f"
                   DLTl="b_f"
                   DLTr="b_f"
                   DLib="b_f"
                   DLsw="U_1"
                   DLsy="o_di5a29"
                   DLsc="o_u68"
                   DLst="D_100"
                   DLso="b_f"
                   DLgc="o_u6b"
                   DLgt="D_100"
                   DLgo="b_f"
                   ClcC="b_f"
                   Fbof="e_MAso"
                   VJal="e_top"
                   PSsl="U_0"
                   Fboa="U_0"
                   kang="D_0"
                   Rfst="b_t"
                   BrHd="b_t"
                   BrFt="b_t"
                   BrLc="b_t"
                   BrRc="b_t"
                   RsHd="o_n"
                   RsFt="o_n"
                   RsLc="o_n"
                   RsRc="o_n"
                   RsBr="o_ud2"/>
      <idsc:tStyle base="[No table style]" name="[Basic Table]" pthr="rl_0" ptfr="rl_0"
                   pnam="k_[Basic Table]"
                   basd="k_[No table style]"
                   kbsc="x_2_s_0_s_0"/>
   </idsc:TableStyles>
   <idsc:ObjectStyles>
      <idsc:objStyle base="" name="[None]" pnam="k_[None]" prst="o_uc4" dtos="o_ue0" dfos="o_udf"
                     dffg="o_ue1"
                     pcef="e_none"
                     flcl="o_u6b"
                     filt="D_-1"
                     lnwt="U_0"
                     mitr="D_4"
                     endc="e_bcap"
                     endj="e_mjon"
                     stty="o_di5a29"
                     llen="e_none"
                     rlen="e_none"
                     lncl="o_u6b"
                     lint="D_-1"
                     pcrd="D_12"
                     gapC="o_u6b"
                     gapT="D_-1"
                     strA="e_stAC"
                     nopr="b_f"
                     pgfa="D_0"
                     pgsa="D_0"
                     xpBm="e_norm"
                     xpBo="D_100"
                     xpBk="b_f"
                     xpBi="b_f"
                     xpSm="e_none"
                     xpSb="e_xpMb"
                     xpSx="U_7"
                     xpSy="U_7"
                     xpSr="U_5"
                     xpSc="o_u68"
                     xpSo="D_75"
                     xpSs="D_0"
                     xpSn="D_0"
                     xpVn="D_0"
                     xpVm="e_none"
                     xpVw="U_9"
                     xpVc="e_xpCc"
                     Jang="o_n"
                     pcOp="e_none"/>
      <idsc:objStyle base="[None]" name="[Normal Graphics Frame]" obcc="b_t" basd="k_[None]"
                     pnam="k_[Normal Graphics Frame]"
                     prst="o_uc4"
                     osnp="b_f"
                     obfc="b_t"
                     obsc="b_t"
                     obpc="b_f"
                     obtf="b_f"
                     obbc="b_f"
                     oboc="b_f"
                     obtw="b_f"
                     obao="b_f"
                     dtos="o_ue0"
                     dfos="o_udf"
                     dffg="o_ue1"
                     obtc="b_t"
                     obdc="b_t"
                     pcef="e_none"
                     flcl="o_u6b"
                     filt="D_-1"
                     lnwt="U_1"
                     mitr="D_4"
                     endc="e_bcap"
                     endj="e_mjon"
                     stty="o_di5a29"
                     llen="e_none"
                     rlen="e_none"
                     lncl="o_u68"
                     lint="D_-1"
                     pcrd="D_12"
                     sovp="b_f"
                     gapC="o_u6b"
                     gapT="D_-1"
                     strA="e_stAC"
                     nopr="b_f"
                     pgfa="D_0"
                     pgsa="D_0"
                     xpBm="e_norm"
                     xpBo="D_100"
                     xpBk="b_f"
                     xpBi="b_f"
                     xpSm="e_none"
                     xpSb="e_xpMb"
                     xpSx="U_7"
                     xpSy="U_7"
                     xpSr="U_5"
                     xpSc="o_u68"
                     xpSo="D_75"
                     xpSs="D_0"
                     xpSn="D_0"
                     xpVn="D_0"
                     xpVm="e_none"
                     xpVw="U_9"
                     xpVc="e_xpCc"
                     Jang="o_n"
                     kbsc="x_2_s_0_s_0"
                     obff="b_f"
                     pcOp="e_none"
                     obCc="b_t"/>
      <idsc:objStyle base="[None]" name="[Normal Text Frame]" obcc="b_t" basd="k_[None]"
                     pnam="k_[Normal Text Frame]"
                     prst="o_uc8"
                     osnp="b_f"
                     obfc="b_t"
                     obsc="b_t"
                     obpc="b_f"
                     obtf="b_t"
                     obbc="b_t"
                     oboc="b_f"
                     obtw="b_f"
                     obao="b_f"
                     dtos="o_ue0"
                     dfos="o_udf"
                     dffg="o_ue1"
                     obtc="b_t"
                     obdc="b_t"
                     pcef="e_none"
                     flcl="o_u6b"
                     filt="D_-1"
                     lnwt="U_0"
                     mitr="D_4"
                     endc="e_bcap"
                     endj="e_mjon"
                     stty="o_di5a29"
                     llen="e_none"
                     rlen="e_none"
                     lncl="o_u6b"
                     lint="D_-1"
                     pcrd="D_12"
                     gapC="o_u6b"
                     gapT="D_-1"
                     strA="e_stAC"
                     nopr="b_f"
                     pgfa="D_0"
                     pgsa="D_0"
                     xpBm="e_norm"
                     xpBo="D_100"
                     xpBk="b_f"
                     xpBi="b_f"
                     xpSm="e_none"
                     xpSb="e_xpMb"
                     xpSx="U_7"
                     xpSy="U_7"
                     xpSr="U_5"
                     xpSc="o_u68"
                     xpSo="D_75"
                     xpSs="D_0"
                     xpSn="D_0"
                     xpVn="D_0"
                     xpVm="e_none"
                     xpVw="U_9"
                     xpVc="e_xpCc"
                     Jang="o_n"
                     kbsc="x_2_s_0_s_0"
                     obff="b_f"
                     pcOp="e_none"
                     obCc="b_t"/>
      <idsc:objStyle base="[None]" name="[Normal Grid]" obcc="b_t" basd="k_[None]"
                     pnam="k_[Normal Grid]"
                     prst="o_uc8"
                     osnp="b_f"
                     obfc="b_t"
                     obsc="b_t"
                     obpc="b_f"
                     obtf="b_t"
                     obbc="b_t"
                     oboc="b_t"
                     obtw="b_f"
                     obao="b_f"
                     dtos="o_ue0"
                     dfos="o_udf"
                     dffg="o_ue1"
                     obtc="b_t"
                     obdc="b_t"
                     pcef="e_none"
                     flcl="o_u6b"
                     filt="D_-1"
                     lnwt="U_0"
                     mitr="D_4"
                     endc="e_bcap"
                     endj="e_mjon"
                     stty="o_di5a29"
                     llen="e_none"
                     rlen="e_none"
                     lncl="o_u6b"
                     lint="D_-1"
                     pcrd="D_12"
                     gapC="o_u6b"
                     gapT="D_-1"
                     strA="e_stAC"
                     nopr="b_f"
                     pgfa="D_0"
                     pgsa="D_0"
                     xpBm="e_norm"
                     xpBo="D_100"
                     xpBk="b_f"
                     xpBi="b_f"
                     xpSm="e_none"
                     xpSb="e_xpMb"
                     xpSx="U_7"
                     xpSy="U_7"
                     xpSr="U_5"
                     xpSc="o_u68"
                     xpSo="D_75"
                     xpSs="D_0"
                     xpSn="D_0"
                     xpVn="D_0"
                     xpVm="e_none"
                     xpVw="U_9"
                     xpVc="e_xpCc"
                     Jang="o_n"
                     kbsc="x_2_s_0_s_0"
                     obff="b_f"
                     pcOp="e_none"
                     obCc="b_t"/>
    </idsc:ObjectStyles>
  </idsc:InDesign_Style_Catalog>
  </xsl:variable>

</xsl:stylesheet>
