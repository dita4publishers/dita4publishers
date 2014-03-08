<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:idsc="http://www.reallysi.com/namespaces/indesign_style_catalog"
      xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
      xmlns:xmp-x="adobe:ns:meta/"
      xmlns:pam="http://prismstandard.org/namespaces/pam/1.0/"
      xmlns:prism="http://prismstandard.org/namespaces/basic/1.2/"
      xmlns:pim="http://prismstandard.org/namespaces/pim/1.2/"
      xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:xhtml="http://www.w3.org/1999/xhtml"
      xmlns:incxgen="http//dita2indesign.org/functions/incx-generation"
      xmlns:df="http://dita2indesign.org/dita/functions"
      exclude-result-prefixes="xs idsc incxgen ditaarch xmp-x pam prism dc pim xhtml df"
      version="2.0">
  <!-- =================================================
       Adobe InCopy Markup Language (ICML) generation utilities.
       
       Copyright (c) 2011, 2014 DITA for Publishers.
       
       ================================================= -->
  
  <!-- URL (relative to the stylesheet document if not absolute)
       of the InDesign style catalog to use in generating 
       the result InCopy articles.
    -->
  <xsl:param name="styleCatalogUri" select="''" as="xs:string"/>
  
  <xsl:variable name="defaultStyleCatalogUri"
    select="'default-dita-indesign-style-catalog.xml'"
    as="xs:string"
  />

  <xsl:template name="makeBlock-cont">
    <xsl:param name="pStyle" select="'ID$/[No paragraph style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="cStyle" select="'ID$/[No character style]'" as="xs:string" tunnel="yes"/>
    <xsl:param name="txsrAtts" tunnel="yes" as="attribute()*"/>
    <xsl:param name="content" as="node()*"/>
    <xsl:param name="markerType" as="xs:string" select="'para'"/>
    
    <xsl:variable name="pStyleEscaped" as="xs:string" select="incxgen:escapeStyleName($pStyle)"/>
    <xsl:variable name="cStyleEscaped" as="xs:string" select="incxgen:escapeStyleName($cStyle)"/>
    
<!--    <xsl:message> + [DEBUG] makeBlock-cont: pStyle="<xsl:sequence select="$pStyle"/>", cStyle="<xsl:sequence select="$cStyle"/>"</xsl:message>-->
    
    <xsl:variable name="pcntContent" as="node()*">
      <xsl:choose>
        <xsl:when test="count($content) gt 0">
          <xsl:apply-templates select="$content" mode="block-children"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="text()|*|processing-instruction()" mode="block-children"/>
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>
    
    <xsl:sequence select="$pcntContent"/>
    <xsl:choose>
      <xsl:when test="$markerType = 'framebreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyleEscaped}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" ParagraphBreakType="NextFrame">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'columnbreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyleEscaped}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" ParagraphBreakType="NextColumn">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'linebreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyleEscaped}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
            <Content><xsl:text>&#x2028;</xsl:text></Content>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'pagebreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyleEscaped}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" ParagraphBreakType="NextPage">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'oddpagebreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyleEscaped}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" ParagraphBreakType="NextOddPage">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'evenpagebreak'">
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyleEscaped}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" ParagraphBreakType="NextEvenPage">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:when>
      <xsl:when test="$markerType = 'none'"/>
      <xsl:otherwise>
        <ParagraphStyleRange
          AppliedParagraphStyle="ParagraphStyle/{$pStyleEscaped}">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
            <Br/>
          </CharacterStyleRange>
        </ParagraphStyleRange>  
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:cStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'csty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template name="makeStyleElement">
    <xsl:param name="tagName" select="xs:string"/>
    <xsl:element name="{$tagName}">
      <xsl:sequence select="@*[not(contains('^base^name^', concat('^', name(.), '^')))]"/>
      <xsl:attribute name="pnam" select="concat('k_', @name)"/>
      <xsl:attribute name="Self" select="concat('rc_', generate-id())"/>
      <xsl:if test="@base != ''">
        <xsl:variable name="baseStyleName" as="xs:string">
          <xsl:choose>
            <xsl:when test="$tagName = 'csty'">
              <xsl:sequence select="incxgen:getObjectIdForCharacterStyle(string(@base))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="incxgen:getObjectIdForParaStyle(string(@base))"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:attribute name="basd" select="concat('k_', $baseStyleName)"/>
      </xsl:if>
    </xsl:element>
    
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:pStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'psty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template mode="generateStyles" match="idsc:tStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'tsty'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:template match="idsc:InDesign_Style_Catalog" mode="generateStyles">
    <xsl:apply-templates select="idsc:CharacterStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:ParagraphStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:TableStyles" mode="#current"/>
    <xsl:apply-templates select="idsc:ObjectStyles" mode="#current"/>
  </xsl:template>
  
  <xsl:template match="idsc:ParagraphStyles | idsc:CharacterStyles | idsc:TableStyles | idsc:ObjectStyles  " mode="generateStyles">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  <xsl:template mode="generateStyles" match="idsc:objStyle">
    <xsl:call-template name="makeStyleElement">
      <xsl:with-param name="tagName" select="'ObSt'"/>
    </xsl:call-template>  
  </xsl:template>
  
  <xsl:function name="incxgen:getObjectIdForParaStyle" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
<!--    <xsl:message> + [DEBUG] getObjectIdForParaStyle(): styleName="<xsl:sequence select="$styleName"/>"</xsl:message>-->
    <xsl:variable name="targetStyle" select="$styleCatalog/*/idsc:ParagraphStyles/idsc:pStyle[@name = $styleName]" as="element()?"/>
    <xsl:variable name="styleId" 
      select="if ($targetStyle) 
      then generate-id($targetStyle)
      else 'styleNotFound'"
      as="xs:string"
    />
    <xsl:if test="$styleId = 'styleNotFound' and not(starts-with($styleName, '['))">
      <xsl:message> + [WARNING] getObjectIdForParaStyle(): No style definition found for style name "<xsl:sequence select="$styleName"/>"</xsl:message>
    </xsl:if>
<!--    <xsl:message> + [DEBUG] getObjectIdForParaStyle(): styleId="<xsl:sequence select="$styleId"/>"</xsl:message>-->
    <xsl:value-of select="$styleId"/>
  </xsl:function>
  
  <xsl:function name="incxgen:getObjectIdForTableStyle" as="xs:string">
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
  
  <xsl:function name="incxgen:getObjectIdForCharacterStyle" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <xsl:variable name="targetStyle" select="$styleCatalog/*/idsc:CharacterStyles/idsc:cStyle[@name = $styleName]" as="element()?"/>
    <xsl:variable name="styleId" 
      select="if ($targetStyle) 
      then generate-id($targetStyle)
      else 'styleNotFound'"
      as="xs:string"
    />
    <xsl:if test="$styleId = 'styleNotFound' and not(starts-with($styleName, '['))">
      <xsl:message> + [WARNING] getObjectIdForCharacterStyle(): No style definition found for style name "<xsl:sequence select="$styleName"/>"</xsl:message>
    </xsl:if>
    <xsl:value-of select="$styleId"/>
  </xsl:function>
  
  <xsl:function name="incxgen:normalizeText" as="xs:string">
    <xsl:param name="inString" as="xs:string"/>
    <xsl:variable name="noBreaks" select="replace($inString, '[&#x2029;&#x0A;]', '')" as="xs:string"/>
    <xsl:variable name="outString" select="replace($noBreaks, '[ ]+', ' ')" as="xs:string"/>
    <xsl:value-of select="$outString"/>
  </xsl:function>
  
  <xsl:function name="incxgen:dec2hex" as="xs:string">
    <xsl:param name="dec" as="xs:integer"/>
<!--    <xsl:message> + [DEBUG] dec2hex(): dec="<xsl:sequence select="$dec"/>"</xsl:message>-->
    <xsl:variable name="hexDigits" select="('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F')" as="xs:string*"/>
    <xsl:variable name="result" as="xs:string">
      <xsl:choose>
        <xsl:when test="$dec &lt; 16">
          <xsl:sequence select="$hexDigits[$dec + 1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="concat(incxgen:dec2hex($dec idiv 16), incxgen:dec2hex($dec mod 16))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
<!--    <xsl:message> + [DEBUG] dec2hex(): result="<xsl:sequence select="$result"/>"</xsl:message>-->
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="incxgen:makeCSpnAttr">
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
  
  <xsl:function name="incxgen:makeRSpnAttr">
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
  
  <xsl:function name="incxgen:makeColumnElems" as="node()*">
    <xsl:param name="colspecs" as="element()*"/><!-- DITA colspec elements for the table -->
    <xsl:param name="numCols" as="xs:integer"/>
    <xsl:param name="tableID" as="xs:string"/>

    <!-- Width of table in points. 
        
         Really need to make this parameterizable, although
         not sure how to do that.
         
         Probably need some way to configure general page
         geometry as input to the transform or to a particular
         output context.
    -->
    <xsl:variable name="tableWidth" as="xs:double" select="540.0"/>
    
    <xsl:variable name="haveColSpecs" as="xs:boolean"
      select="count($colspecs) = $numCols"
    />
    
    <xsl:variable name="availableWidth" as="xs:double"
      select="incxgen:calcAvailableWidth($tableWidth, $colspecs)"
    />
    <xsl:variable name="proportionalColspecs" as="element()*"
      select="$colspecs[ends-with(@colwidth, '*')]"
    />

    <xsl:variable name="result" as="node()*">
      <xsl:for-each select="1 to $numCols">
        <xsl:variable name="curpos" as="xs:integer" select="."/>
        <xsl:variable name="colspec" as="element()?"
          select="if ($haveColSpecs) then $colspecs[$curpos] else ()"
        />
        <xsl:element name="Column">
          <xsl:attribute name="Self" select="concat('rc_', $tableID, 'Column',position()-1)"/>
          <xsl:attribute name="Name" select="position()-1"/>
          <!-- FIXME: Need to try to calculate a useful column width
                      when the colspec provides an explicit width
                      value.
                      
                      When it doesn't we have to just pick a value
                      or divide the available width by the number
                      of columns. The trick is knowing what the
                      the available width is.
           -->
          <xsl:attribute name="SingleColumnWidth"
              select="incxgen:calcColumnWidth(
                         $colspec, 
                         $tableWidth, 
                         $numCols, 
                         $availableWidth,
                         $proportionalColspecs)"
          />          
        </xsl:element>
      </xsl:for-each>
    </xsl:variable>
    <xsl:copy-of select="$result"/>
  </xsl:function>
  
  <xsl:function name="incxgen:calcAvailableWidth" as="xs:double">
    <xsl:param name="tableWidth" as="xs:double"/>
    <xsl:param name="colspecs" as="element()*"/>
    <xsl:variable name="explictWidths" as="xs:double*">
      <xsl:for-each select="$colspecs">
        <xsl:variable name="baseWid" select="@colwidth" as="xs:string?"/>
        <xsl:choose>
          <xsl:when test="ends-with($baseWid, 'pt')">
            <xsl:sequence select="number(substring-before($baseWid, 'pt'))"/>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="explicitWidth" as="xs:double"
      select="if (count($explictWidths) > 0) then sum($explictWidths) else 0.0"
    />
    <xsl:variable name="result" as="xs:double"
      select="$tableWidth - $explicitWidth"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="incxgen:calcColumnWidth" as="xs:double">
    <xsl:param name="colspec" as="element()?"/>
    <xsl:param name="tableWidth" as="xs:double"/>
    <xsl:param name="numCols" as="xs:integer"/>
    <xsl:param name="availableWidth" as="xs:double"/><!-- tableWidth - explicit widths -->
    <xsl:param name="proportionalColspecs" as="element()*"/>
    
    <!-- FIXME: Right now not trying to handle any measurement
         units other than points (which is what we get from Word
         tables) or proportional column widths.
      -->
    <xsl:variable name="result" as="xs:double" >
      <xsl:choose>
        <xsl:when test="boolean($colspec)">
          <xsl:variable name="baseWid" as="xs:string" select="$colspec/@colwidth"/>
          <xsl:choose>
            <xsl:when test="ends-with($baseWid, 'pt')">
              <xsl:sequence select="number(substring-before($baseWid, 'pt'))"/>
            </xsl:when>
            <xsl:when test="ends-with($baseWid, '*')">
              <!-- Proportional width: Divides amount of total width among all proportional columns. 
              240/(1+1.38)*1.38=139.1596
              240/(1+1.38)     =100.8403  //Multiplied by 1 in this case
              
              -->
              <xsl:variable name="totalProportions" as="xs:double"
                select="sum(for $width in $proportionalColspecs/@colwidth 
                                return number(substring-before($width, '*')))"
              />
              <xsl:variable name="proportion" as="xs:double"
                select="number(substring-before($baseWid, '*'))"
              />
              <xsl:sequence select="($availableWidth div $totalProportions) * $proportion"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="$tableWidth div $numCols"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$tableWidth div $numCols"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <!-- Tables: -->
  
  
  <!-- Handle processing instructions. -->
  <!-- Insertion point markers, changes, and notes are all represented as PIs in the PAM XML. -->
  
  <!-- Simply pass through insertion point markers.  -->
  
  <xsl:template match="processing-instruction(aid)" mode="cont">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template match="//processing-instruction(notes-Note)" mode="makeNotes">
    <!-- FIXME: Not sure where to get the data for the attributes. -->
      <Note 
        Collapsed="false" 
        CreationDate="2011-12-19T10:49:41" 
        ModificationDate="2011-12-19T10:49:47" 
        UserName="W. Eliot Kimber" 
        AppliedDocumentUser="dDocumentUser0">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]">
          <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
            <Content><!-- FIXME: Content goes here --></Content>            
          </CharacterStyleRange>
        </ParagraphStyleRange>
      </Note>
  </xsl:template>
  
  <xsl:function name="incxgen:escapeStyleName" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <xsl:variable name="escape1" as="xs:string"
      select="replace($styleName, ':', '%3a')"
    />
    <xsl:variable name="escape2" as="xs:string"
      select="replace($escape1, '&lt;', '%3c')"
    />
    <xsl:sequence select="$escape2"/>
  </xsl:function>
  
  <xsl:function name="incxgen:unescapeStyleID" as="xs:string">
    <xsl:param name="styleID" as="xs:string"/>
    <xsl:variable name="escape1" as="xs:string"
      select="replace($styleID, '%3a', ':')"
    />
    <xsl:variable name="escape2" as="xs:string"
      select="replace($escape1, '%3c', '&lt;')"
    />
    <xsl:sequence select="$escape2"/>
  </xsl:function>
  
  <!-- Style catalog: -->
  
  <xsl:variable name="styleCatalog">
    <xsl:if test="$debugBoolean">
      <xsl:message> + [DEBUG] styleCatalogUri = "<xsl:sequence select="$styleCatalogUri"/>"</xsl:message>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$styleCatalogUri != ''">
        <xsl:variable name="catalogDoc" select="document($styleCatalogUri)" as="document-node()?"/>
        <xsl:if test="not($catalogDoc)">
          <xsl:message terminate="yes"> + [ERROR] Could not load InDesign style catalog "<xsl:sequence select="$styleCatalogUri"/>"</xsl:message>
        </xsl:if>
        <xsl:sequence select="$catalogDoc/*[1]"/>
      </xsl:when>
      <xsl:otherwise>
        <idsc:InDesign_Style_Catalog
  xmlns:idsc="http://www.reallysi.com/namespaces/indesign_style_catalog">
          <idsc:ParagraphStyles>
          </idsc:ParagraphStyles>
          <idsc:CharacterStyles>
          </idsc:CharacterStyles>
          <idsc:TableStyles>
          </idsc:TableStyles>
          <idsc:ObjectStyles>
          </idsc:ObjectStyles>
        </idsc:InDesign_Style_Catalog>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

</xsl:stylesheet>
