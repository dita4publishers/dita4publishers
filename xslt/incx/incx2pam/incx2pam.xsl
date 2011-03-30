<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:idsc="http://www.reallysi.com/namespaces/indesign_style_catalog"
  xmlns:local="http://www.reallysi.com/functions/local"
  xmlns:stmm="http://www.reallysi.com/namespaces/styleToMarkupMap"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:xmp-x="adobe:ns:meta/"
  xmlns:xmp-rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:xmp-custom="reallysi/custom/"
  xmlns:pam="http://prismstandard.org/namespaces/pam/1.0/"
  xmlns:prism="http://prismstandard.org/namespaces/basic/1.2/"
  xmlns:pim="http://prismstandard.org/namespaces/pim/1.2/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"  
  xmlns:i2x="http://www.reallysi.com/incx2xml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
  xmlns:x="adobe:ns:meta/"
  xmlns:functions="http://www.reallysi.com/functions/local"  
  exclude-result-prefixes="xs idsc local stmm saxon xmp-x xmp-rdf xmp-custom i2x xhtml dc pam prism pim rdf x"
  extension-element-prefixes="saxon">
  <!-- =======================================================================
    
       INCX 2 PAM Transform
       
       This transform takes Adobe InCopy INCX XML and generates PRISM/PAM XML.
       
       There is an inverse to this transform that converts PRISM/PAM
       XML into INCX XML for editing in InCopy.
    
    ======================================================================= -->
 
  <xsl:output
    method="xml"
    doctype-public="-//PRISMstandard.org//DTD Aggregation with XHTML v1.0//EN"
    doctype-system="pam1_2.dtd"
  />
 
  
  <xsl:strip-space
    elements="*"/>
  <xsl:preserve-space
    elements="pcnt"/>

  <xsl:param
    name="inxDoc"
    select="."
    as="document-node()*"
    />
 
  <xsl:key
    name="inxObjectsById"
    match="*[@Self]"
    use="substring-after(@Self, '_')"/>

  <!-- grab all notes for later processing  -->
  <xsl:key
    name="inxAnchor2NoteMap"
    match="Note[@STof]"
    use="substring-after(@STof, '_')"/>
  
  <!-- grab all changes for later processing  -->
  <xsl:key
    name="inxAnchor2ChngMap"
    match="Chng[@STof]"
    use="substring-after(@STof, '_')"/>

  <!-- normalize space to facilitate matching of font name + suffix combos -->
  <xsl:key
    name="style2tag"
    match="tag"
    use="normalize-space(@styleSuffix)"/>

  <xsl:key
    name="font2tag"
    match="tag"
    use="normalize-space(@styleSuffix)"/>

  <xsl:key
    name="scriptLabels"
    match="cflo"
    use="@ptag"/>

  <xsl:variable name="style2tagMap" as="document-node()">
    <xsl:document>
      <map>
        <tag
          styleSuffix="Head">h1</tag>
        <tag
          styleSuffix="Subhead">h2</tag>
        <tag
          styleSuffix="Body">p</tag>
        <tag
          styleSuffix="Byline">byline</tag>
        <tag
          styleSuffix="Title">p</tag>
      </map>
    </xsl:document>
  </xsl:variable>
  
  <xsl:variable name="xmp">
    <xsl:apply-templates select="/*/cflo/cMep/pcnt" mode="XMP"/>
  </xsl:variable>
  
  <xsl:template
    match="SnippetRoot">
    <xsl:call-template
      name="constructDocument"/>
  </xsl:template>

  <!-- 
    The constructDocument template makes a hierarchical structure out of the input inx flat structure.
    
    1) First it breaks up text runs (<txsr>), ensuring that a particular run contains at most one paragraph break (u2029). 
    
    2) Then it groups the resulting text runs so that each group contains - and ends with - only one paragraph break.
    Groups are wrapped in structural elements, as determined by the the style to tag mapping.
    
    3) Then, via multi-level grouping, txsrs are grouped by embedded style, font, and finally character style. 
    
    4) Then font styles applied directly to txsrs are resolved.
    
    -->

  <xsl:template
    name="constructDocument">
    <xsl:variable
      name="normalizedTextRuns">
      <xsl:apply-templates
        select="/*/cflo"
        mode="normalizeTextRuns">
        <!-- <xsl:with-param name="inxDoc" select="." as="node()" tunnel="yes"/> -->
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable
      name="stories">
      <xsl:apply-templates
        select="$normalizedTextRuns"
        mode="makeParas">
        <xsl:with-param
          name="inxDoc"
          select="."
          as="node()"
          tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:variable>
<!-- <xsl:message> + [DEBUG] Saving stories to 'stories.xml'...</xsl:message> -->
<!-- <xsl:result-document href="stories.xml">
      <xsl:sequence select="$stories"/> 
      </xsl:result-document> -->
    <xsl:variable name="normalizedStories">
      <xsl:apply-templates select="$stories" mode="styleParas">
        <xsl:with-param name="inxDoc" select="." as="node()*" tunnel="yes"/> 
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:apply-templates
      select="$normalizedStories"
      mode="outputText">
      <xsl:with-param
        name="inxDoc"
        select="."
        as="node()"
        tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- "normalizeTextRuns" mode templates    -->

  <xsl:template
    match="cflo"
    mode="normalizeTextRuns">
    <xsl:variable
      name="cfloAttrs"
      select="."
      as="node()*"/>
    <cflo>
      <xsl:sequence
        select="$cfloAttrs/@*"/>
      <xsl:apply-templates
        select="txsr | ctbl | Chng | Note"
        mode="normalizeTextRuns"/>
    </cflo>
  </xsl:template>

  <!-- Preserve changes and notes for later processing. -->

  <xsl:template
    match="Chng"
    mode="normalizeTextRuns">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template
    match="Note"
    mode="normalizeTextRuns">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- 
    Text style ranges (<txsr>) are tested for paragraph breaks (u2029) and handled accordingly.
    The attributes of the text style ranges are preserved ($txsrAttrs) so as to avoid losing paragraph and character styles and applied fonts.
  -->
  
  <xsl:template match="ctbl" mode="normalizeTextRuns">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template
    match="txsr"
    mode="normalizeTextRuns">
    <xsl:param
      name="txsrAttrs"
      select="."
      as="node()*"
      tunnel="yes"/>
    <xsl:apply-templates
      mode="normalizeTextRuns">
      <xsl:with-param
        name="txsrAttrs"
        select="$txsrAttrs"
        as="node()*"
        tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template
    match="pcnt"
    mode="normalizeTextRuns">
    <xsl:apply-templates
      select="text() | processing-instruction()"
      mode="normalizeTextRuns"/>
  </xsl:template>

  <!-- Must explicitly pass through the PIs. Wrap the PIs in <txsr>s so that they don't get lost in subsequent processing. -->


  <xsl:template
    match="processing-instruction()"
    mode="normalizeTextRuns">
    <xsl:param
      name="txsrAttrs"
      as="node()*"
      tunnel="yes"/>
    <txsr>
      <xsl:sequence
        select="$txsrAttrs/@*"/>
      <xsl:sequence
        select="."/>
    </txsr>
  </xsl:template>

  <xsl:template
    match="text()"
    mode="normalizeTextRuns">
    <xsl:param
      name="txsrAttrs"
      tunnel="yes"
      as="node()*"/>
    <xsl:choose>
      <xsl:when
        test="contains(.,'&#x2029;')">
        <xsl:variable
          name="runs"
          select="tokenize(.,'&#x2029;')"/>
        <xsl:choose>
          <xsl:when
            test="count($runs) = 2 and $runs[2] = ''">
            <txsr>
              <xsl:sequence
                select="$txsrAttrs/@*"/>
              <xsl:sequence
                select="."/>
              <xsl:text>&#x2029;</xsl:text>
            </txsr>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each
              select="$runs">
              <xsl:choose>
                <xsl:when
                  test=". = ''">
                  <txsr>
                    <xsl:sequence
                      select="$txsrAttrs/@*"/>
                    <xsl:sequence
                      select="."/>
                    <xsl:text>&#x2029;</xsl:text>
                  </txsr>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when
                      test="position() = last()">
                      <txsr>
                        <xsl:sequence
                          select="$txsrAttrs/@*"/>
                        <xsl:sequence
                          select="."/>
                      </txsr>
                    </xsl:when>
                    <xsl:otherwise>
                      <txsr>
                        <xsl:sequence
                          select="$txsrAttrs/@*"/>
                        <xsl:sequence
                          select="."/>
                        <xsl:text>&#x2029;</xsl:text>
                      </txsr>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <txsr>
          <xsl:sequence
            select="$txsrAttrs/@*"/>
          <xsl:sequence
            select="."/>
        </txsr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- makeParas mode templates -->

  <xsl:template
    match="cflo"
    mode="makeParas">
    <xsl:param
      name="inxDoc"
      as="node()"
      tunnel="yes"/>

    <xsl:copy>
     <xsl:sequence select="@*"/>
      <xsl:for-each-group
        select="txsr"
        group-ending-with="*[contains(.,'&#x2029;')] | *[contains(.,'e_SFrB')]">
        <xsl:choose>
          <!-- These first two matches test for txsr groups that contain only a paragraph marker and removes them. -->
          <!-- If causes problems, use only "otherwise" match. -->
          <xsl:when
            test="matches(.,'^&#x2029;$')"/>
          <xsl:when
            test="matches(.,'^e_SFrB$')"/>
          <xsl:otherwise>
            <xsl:variable name="tagName" select="functions:getTagName(current-group()[position()=1], $inxDoc)" as="xs:string"/>
<!--            <xsl:message> + [DEBUG] tagName="<xsl:sequence select="$tagName"/>"</xsl:message>-->
            <xsl:element
              name="{$tagName}"
              >
              <!-- Get the @alrs from the paragraph style element <psty>. This contains embedded styles, when present. -->
              <!-- Resolve the possible fonts - para, char, txsr - and apply a new font attribute  -->
              <xsl:for-each
                select="current-group()">
                <xsl:element
                  name="txsr">
                  <xsl:sequence
                    select="@*"/>
                  <xsl:attribute
                    name="alrs"
                    select="functions:getEmbeddedStylesList(.,$inxDoc)"/>
                  <xsl:attribute
                    name="rfont"
                    select="functions:resolveFontAttrs(.,$inxDoc)"/>
                  <xsl:if
                    test="boolean(@ptfs) = false()">
                    <xsl:attribute
                      name="ptfs"
                      select="'none'"/>
                  </xsl:if>
                  <xsl:apply-templates
                    select="text() | processing-instruction()"
                    mode="makeParas"/>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
      <!-- added to handle tables -->
      <xsl:apply-templates select="ctbl | Chng | Note" mode="makeParas"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template 
    match="ctbl"
    mode="makeParas">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template
    match="text()"
    mode="makeParas">
    <xsl:copy/>
  </xsl:template>

  <xsl:template
    match="processing-instruction()"
    mode="makeParas">
    <xsl:copy-of
      select="."/>
  </xsl:template>
  
  <xsl:template 
    match="Chng"
    mode="makeParas">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template 
    match="Note"
    mode="makeParas">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <!-- styleParas mode -->
      
    <xsl:template match="cflo" mode="styleParas">
        <xsl:variable name="cfloAttrs" select="." as="node()*"/>
        <cflo>
            <xsl:sequence select="$cfloAttrs/@*"/>
            <xsl:apply-templates mode="styleParas"/>
          <xsl:apply-templates select="ctbl | Chng | Note" mode="makeParas"/>
        </cflo>
    </xsl:template>
    
    <!-- Apply character styles and font styles based on character, paragraph and/or font styles.
            
    This template groups and tags sets of text ranges (<txsr>s) according to the following @ values:
    
    1. character styles
    2. font styles (modes) from paragraph or character styles
    3. font styles (modes) applied directly to text  (<txsr>s)
    
    This is accomplished through several nested multi-level groupings. 
    
    -->
  
    <xsl:template match="cflo/*" mode="styleParas">
        <xsl:param name="inxDoc" as="node()" tunnel="yes"/>
        <xsl:variable name="cfloAttrs" select="." as="node()*"/>
        <xsl:element name="{local-name()}">
                         
                         <!-- group by character styles -->
                         
                    <xsl:for-each-group select="txsr" group-adjacent="@crst">
                        <xsl:variable name="charStyleTag" select="functions:getCharStyleName(current-group()[position()=1],$inxDoc)"/>
                        <xsl:variable name="fontStyleTag" select="functions:getFontStyleName(current-group()[position()=1],$inxDoc)"/>
                        <xsl:choose>
                            <xsl:when test="$charStyleTag != 'none'">
                                <xsl:element name="{$charStyleTag}">
                                    <xsl:choose>
                                        <xsl:when test="$fontStyleTag != 'none'">
                                            <xsl:element name="{$fontStyleTag}">
                                                            <xsl:for-each select="current-group()">
                                                                <xsl:sequence select="."/>
                                                            </xsl:for-each>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                        <xsl:for-each select="current-group()">
                                                            <xsl:sequence select="."/>
                                                        </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$fontStyleTag != 'none'">
                                        <xsl:element name="{$fontStyleTag}">
                                                        <xsl:for-each select="current-group()">
                                                            <xsl:sequence select="."/>
                                                        </xsl:for-each>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                                    <xsl:for-each select="current-group()">
                                                        <xsl:sequence select="."/>
                                                    </xsl:for-each>                                  
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each-group>
        </xsl:element>
    </xsl:template>


  <!-- Output text. -->

  <!-- Must match structural and font style elements applied previously and copy to result tree. -->
  <!-- Names of those elements unpredictable, so use *. -->

  <xsl:template
    match="cflo"
    mode="outputText">
    <xsl:if
      test="@ptag">
      <xsl:copy-of
        select="functions:processLabel(.)"/>
    </xsl:if>
    <pam:article xml:lang="en">
      <xsl:variable name="ptagValue" select="functions:parsePtagValue(@ptag)/label" as="element()*"/>
      <RSUITE:METADATA
        xmlns:RSUITE="http://www.reallysi.com">
        <RSUITE:SYSTEM>
          <xsl:for-each select="$ptagValue">
            <xsl:if test="starts-with(@name, 'RSUITE:')">
              <xsl:choose>
                <xsl:when test="string(@name) = 'RSUITE:DISPLAYNAME'">
                  <RSUITE:DISPLAYNAME RSUITE:AUTOGENERATE="true"><xsl:sequence select="string(.)"/></RSUITE:DISPLAYNAME>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:element name="{@name}"><xsl:sequence select="replace(string(.), '~sep~', '_')"/></xsl:element>
                </xsl:otherwise>
              </xsl:choose>
              
            </xsl:if>
          </xsl:for-each>
        </RSUITE:SYSTEM>
        <RSUITE:LAYERED>
          <xsl:for-each select="$ptagValue">
            <!-- LMD values will never start with 'RSUITE:' -->
            <xsl:if test="not(starts-with(@name, 'RSUITE:')) and not(@name = 'Label')">
              <RSUITE:DATA RSUITE:NAME="{@name}" RSUITE:ID="{generate-id(.)}" ><xsl:sequence select="replace(string(.), '~sep~', '_')"/></RSUITE:DATA>
            </xsl:if>
          </xsl:for-each>
        </RSUITE:LAYERED>
      </RSUITE:METADATA>
      <head xmlns="http://www.w3.org/1999/xhtml">
        <xsl:text>&#x0a;</xsl:text>
        <xsl:call-template name="handleArticleMetadata">
          <xsl:with-param name="context"  select="." as="element()"/>
        </xsl:call-template>
      <xsl:text>&#x0a;</xsl:text></head>
      <xsl:text>&#x0a;</xsl:text>
      <body xmlns="http://www.w3.org/1999/xhtml">
        <xsl:text>&#x0a;</xsl:text>
        <xsl:apply-templates mode="#current"/>
      </body>
      <xsl:text>&#x0a;</xsl:text>
    </pam:article>
  </xsl:template>
  
  <xsl:template name="handleArticleMetadata">
    <xsl:param name="context" as="element()"/>
    <!--<xsl:message> + [DEBUG] xmp: <xsl:sequence select="$xmp"/></xsl:message>-->
    <!--
      Content model for xhtml:head element:
      
      dc:identifier,
      pam:status?,
      prism:hasCorrection?,
      dc:title?,
      dc:creator*,
      prism:publicationName,
      prism:issn?,
      dc:publisher?,
      ((prism:coverDate,
        prism:coverDisplayDate?)|
       prism:coverDisplayDate),
       prism:volume?,
       prism:number?,
       prism:issueName?,
       prism:edition?,
       prism:startingPage?,
       prism:section?,
       prism:subsection1?,
       prism:subsection2?,
       (dc:subject|
        dc:description|
        prism:event|
        prism:location|
        prism:objectTitle|
        prism:organization|
        prism:person)*,
       prism:category*,
       prism:copyright?      
      -->
    
    <xsl:copy-of select="functions:makeReqMetadata($xmp//dc:identifier,'dc:identifier')"/>
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//pam:status"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:hasCorrection"/>    
    <xsl:copy-of select="functions:makeReqMetadata($xmp//dc:title,'dc:title', '{No title specified}')"/>
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//dc:creator"/>    
    <xsl:copy-of select="functions:makeReqMetadata($xmp//prism:publicationName,'prism:publicationName')"/>
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:issn"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//dc:publisher"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:coverDate"/>    
    <xsl:copy-of select="functions:makeReqMetadata($xmp//prism:coverDisplayDate,'prism:coverDisplayDate', 'unpublished')"/>
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:volume"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:number"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:issueName"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:edition"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:startingPage"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:section"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:subsection1"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:subsection2"/>    
    <xsl:apply-templates mode="metadata-generation"  select="
      $xmp//dc:subject|
      $xmp//dc:description|
      $xmp//prism:event|
      $xmp//prism:location|
      $xmp//prism:objectTitle|
      $xmp//prism:organization|
      $xmp//prism:person"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:category"/>    
    <xsl:apply-templates mode="metadata-generation"  select="$xmp//prism:copyright"/>  
  </xsl:template>
  
  <xsl:template mode="metadata-generation" match="dc:subject">
    <!-- In the XMP all the subjects are stored as an RDF bag, where
         each <rdf:li> becomes a separate dc:subject element.
    -->
    <xsl:for-each select="xmp-rdf:Bag/xmp-rdf:li">
      <dc:subject><xsl:sequence select="string(.)"/></dc:subject>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template mode="metadata-generation" match="*">
    <xsl:element name="{name(.)}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
  <xsl:function name="functions:makeReqMetadata">
    <xsl:param name="inputNode" as="element()?"/>
    <xsl:param name="inputName" as="xs:string"/>
    <xsl:sequence select="functions:makeReqMetadata($inputNode, $inputName, '{unset}')"/>
  </xsl:function>
  
  <xsl:function name="functions:makeReqMetadata">
    <xsl:param name="inputNode" as="element()?"/>
    <xsl:param name="inputName" as="xs:string"/>
    <xsl:param name="defaultValue" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$inputNode">
        <xsl:element name="{name($inputNode)}">
          <xsl:apply-templates select="$inputNode"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{$inputName}">
          <xsl:sequence select="$defaultValue"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:function>
  
  <xsl:template match="pcnt" mode="XMP">
    <xsl:variable name="cdata" select="string-join(text(), '')"/>
    <xsl:if test="starts-with($cdata, '&lt;?xpacket begin=')">
      <!-- Unfortunately saxon:try is only available in SA so parse might cause exception -->
      <!-- <xsl:variable name="xmp" select="saxon:try(saxon:parse($cdata), ())"/> -->
      <!-- Root element should be x:xmpmeta -->
      <xsl:variable name="xmp" select="saxon:parse($cdata)"/>
      <xsl:if test="$xmp/xmp-x:xmpmeta">
        <xsl:copy-of select="$xmp/xmp-x:xmpmeta"/>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template
    match="cflo/*"
    mode="outputText" priority="-1"
    >
    <xsl:element
      name="{local-name()}"
      namespace="http://www.w3.org/1999/xhtml"
      >
      <xsl:sequence
        select="@*"/>
      <xsl:apply-templates
            mode="outputText"/>
    </xsl:element><xsl:text>&#x0a;</xsl:text>
    <xsl:apply-templates select="txsr/processing-instruction(aid)[contains(.,'Char=&quot;16&quot;')]" mode="placeTable"/>
  </xsl:template>
  
  <xsl:template match="p[byline]" mode="outputText" priority="2">
    <xsl:choose>
      <xsl:when test="normalize-space(byline/preceding-sibling::text()|byline/preceding-sibling::*) != ''">
        <!-- byline must not be at start of para -->
        <p xmlns="http://www.w3.org/1999/xhtml">
          <xsl:sequence
            select="@*"/>
          <xsl:apply-templates select="byline/preceding-sibling::text()|byline/preceding-sibling::*"
            mode="outputText" />
        </p>
        <p class="byline" xmlns="http://www.w3.org/1999/xhtml">
          <xsl:sequence
            select="@*"/>
          <xsl:apply-templates
            mode="outputText" select="byline"/>
        </p><xsl:text>&#x0a;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- byline is entire paragraph (or at least at start of it) -->
        <p class="byline" xmlns="http://www.w3.org/1999/xhtml">
          <xsl:sequence
            select="@*"/>
          <xsl:apply-templates
            mode="outputText"/>
        </p>
        <xsl:text>&#x0a;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="txsr/processing-instruction(aid)[contains(.,'Char=&quot;16&quot;')]" mode="placeTable"/>
  </xsl:template>
  
  <xsl:template mode="outputText" match="byline">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template
    match="*"
    mode="outputText"
    priority="-2">
    <xsl:element
      name="{local-name()}"
      namespace="http://www.w3.org/1999/xhtml"
      >
      <xsl:sequence
      select="@*"/>
      <xsl:apply-templates
        mode="outputText"/>
    </xsl:element>
  </xsl:template>


  <xsl:template
    match="txsr"
    mode="outputText">
    <xsl:apply-templates
      select="processing-instruction() | text()"
      mode="outputText"/>
  </xsl:template>
  
  <xsl:template match="ctbl" mode="outputText"/>
  
  
  <xsl:template match="ctbl" mode="outputTextTables">
    <xsl:param name="inxDoc" as="element()?" tunnel="yes"/>
    <xsl:variable name="STof" select="@STof"/>
    <xsl:variable name="colCount" select="count(ccol)"/>
    <xsl:variable name="rowCount" select="count(crow)"/>
    <table xmlns="http://www.w3.org/1999/xhtml" id="{$STof}">
      <xsl:for-each-group select="ccel" group-by="substring-after(@pnam, ':')">
        <tr>
          <xsl:for-each select="current-group()">
            <xsl:variable name="styleObjID" select="substring-after(txsr/@prst, 'o_')" as="xs:string"/>
            <xsl:variable name="paraStyleObj" select="key('inxObjectsById', $styleObjID, $inxDoc)" as="element()?"/>
            <xsl:variable name="paraStyle" select="string($paraStyleObj/@pnam)" as="xs:string"/>
            <xsl:variable name="tag">
            <xsl:choose>
              <xsl:when test="matches($paraStyle,'head', 'i')">
                <xsl:value-of select="'th'"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'td'"/>
              </xsl:otherwise>
            </xsl:choose>
            </xsl:variable>
            <xsl:element name="{$tag}">
              <xsl:if test="substring-after(@RSpn,'_') ne '1'">
                <xsl:attribute name="rowspan" select="concat(round(number(number(substring-after(@RSpn,'_')) div $rowCount) * 100),'%')"/>
              </xsl:if>
              <xsl:if test="substring-after(@CSpn,'_') ne '1'">
              <xsl:attribute name="colspan" select="concat(round(number(number(substring-after(@CSpn,'_')) div $colCount) * 100),'%')"/>
              </xsl:if>
            <xsl:apply-templates select="." mode="outputTextTables"/>
            </xsl:element>
          </xsl:for-each>
        </tr>
      </xsl:for-each-group>
    </table>
  </xsl:template>
  
  <xsl:template match="ccel" mode="outputTextTables">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="txsr" mode="outputTextTables">
  <xsl:apply-templates mode="#current"/>
</xsl:template>

<xsl:template match="pcnt" mode="outputTextTables">
  <xsl:apply-templates
    select="processing-instruction() | text()"
    mode="outputText"/>
</xsl:template>
  
  <!-- Suppress insertion point marker PIs (<?aid ?>). -->

  <xsl:template
    match="processing-instruction(aid)"
    mode="outputText"/>
  
  <!-- Suppress table markers in the output -->
  <xsl:template match="processing-instruction(aid)[contains(.,'Char=&quot;16&quot;')]" mode="outputText" priority="10"/>
  
  <xsl:template match="processing-instruction(aid)" mode="placeTable">
    <xsl:variable name="aidSelf" select="substring-before(substring-after(.,'Self=&quot;rc_'),'&quot;')"/>
    <xsl:apply-templates select="//ctbl[contains(@STof,$aidSelf)]" mode="outputTextTables"/>
  </xsl:template>

<!-- Pass through Adobe special character PIs (<?ACE ?). -->

  <xsl:template
    match="processing-instruction(ACE)"
    mode="outputText"> 
    <xsl:sequence select="."/>
  </xsl:template>

  <!-- Make Change notes and children text ranges into PIs -->
  
  <xsl:template 
    match="Chng"
    mode="outputText">
    <xsl:processing-instruction name="chngtrk-Chng">
      <xsl:for-each select="./attribute::*">
        <xsl:value-of select="local-name(.)"/><xsl:text>=&quot;</xsl:text><xsl:value-of select="."/><xsl:text>&quot; </xsl:text>          
      </xsl:for-each>
    </xsl:processing-instruction>
    <xsl:for-each select="txsr">
      <xsl:processing-instruction name="chngtrk-txsr">
        <xsl:variable name="ChngSelf">
          <xsl:value-of select="parent::Chng/@Self"/>
        </xsl:variable>
        <xsl:for-each select="./attribute::*">
          <xsl:value-of select="local-name(.)"/><xsl:text>=&quot;</xsl:text><xsl:value-of select="."/><xsl:text>&quot; </xsl:text>   
        </xsl:for-each>
        <xsl:text>ChngID=&quot;</xsl:text><xsl:value-of select="$ChngSelf"/><xsl:text>&quot;</xsl:text>
        <xsl:text> Text=&quot;</xsl:text><xsl:value-of select="pcnt"/><xsl:text>&quot;</xsl:text>
      </xsl:processing-instruction>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Make Notes and children text ranges into PIs -->
  
  <xsl:template 
    match="Note"
    mode="outputText">
    <xsl:processing-instruction name="notes-Note">
      <xsl:for-each select="./attribute::*">
        <xsl:value-of select="local-name(.)"/><xsl:text>=&quot;</xsl:text><xsl:value-of select="."/><xsl:text>&quot; </xsl:text>          
      </xsl:for-each>
    </xsl:processing-instruction>
    <xsl:for-each select="txsr">
      <xsl:processing-instruction name="notes-txsr">
        <xsl:variable name="NoteSelf">
          <xsl:value-of select="parent::Note/@Self"/>
        </xsl:variable>
        <xsl:for-each select="./attribute::*">
          <xsl:value-of select="local-name(.)"/><xsl:text>=&quot;</xsl:text><xsl:value-of select="."/><xsl:text>&quot; </xsl:text>   
        </xsl:for-each>
        <xsl:text>NoteID=&quot;</xsl:text><xsl:value-of select="$NoteSelf"/><xsl:text>&quot;</xsl:text>
        <xsl:text> Text=&quot;</xsl:text><xsl:value-of select="pcnt"/><xsl:text>&quot;</xsl:text>
      </xsl:processing-instruction>
    </xsl:for-each>
  </xsl:template>

  <xsl:template
    match="text()"
    mode="outputText">
    <xsl:choose>
      <xsl:when
        test="starts-with(., 'c_')">
        <xsl:sequence
          select="replace(substring-after(., 'c_'), '&#x2029;', '')"/>
      </xsl:when>
      <xsl:when
        test="starts-with(., 'e_')">
        <xsl:message>DEBUG:: Special Character :: <xsl:sequence
            select="."/></xsl:message>
        <xsl:sequence
          select="functions:mapSpecialCharacterEnum(substring-after(.,'e_'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence
          select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- FUNCTIONS -->

  <xsl:function
    name="functions:getTagName"
    as="xs:string">
    <xsl:param
      name="inputNode"
      as="node()"/>
    <xsl:param
      name="inxDoc"
      as="node()"/>
    <xsl:variable
      name="styleObjID"
      select="substring-after($inputNode/@prst, 'o_')"
      as="xs:string"/>
    <xsl:variable
      name="paraStyleObj"
      select="key('inxObjectsById', $styleObjID, $inxDoc)"
      as="element()?"/>
    <xsl:variable
      name="paraStyle"
      select="string($paraStyleObj/@pnam)" as="xs:string"/>
    <!-- Suffix can be used to create general mappings
         for a group of similarly-named styles that
         should all map to the same element type.
    -->
    <xsl:message select="$paraStyle"/>
    <xsl:variable
      name="styleSuffix"
      as="xs:string"
    >
      <xsl:choose>
        <xsl:when test="contains($paraStyle,'~')">
          <xsl:value-of select="tokenize(substring-after($paraStyle, '_'),'~')[last()]"></xsl:value-of>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring-after($paraStyle,'_')"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </xsl:variable>
    <xsl:variable
      name="tag">
      <xsl:choose>
        <xsl:when test="$styleSuffix != ''">
         <xsl:sequence select="key('style2tag', $styleSuffix , $style2tagMap)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="key('style2tag', $paraStyle , $style2tagMap)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>   
    <xsl:if test="$tag = ''">
      <xsl:message> - [WARNING] getTagName(): No tag mapping for paraStyle "<xsl:sequence select="$paraStyle"/>" or suffix "<xsl:sequence select="$styleSuffix"/>", using 'p'.</xsl:message>
    </xsl:if>
    <xsl:sequence
      select="if ($tag = '') 
                 then 'p' 
                 else $tag"/>
  </xsl:function>


  <xsl:function
    name="functions:getFontStyleName"
    as="xs:string">
    <xsl:param
      name="inputNode"
      as="node()"/>
    <xsl:param
      name="inxDoc"
      as="node()"/>
    <!-- get para font style -->
    <xsl:variable
      name="paraStyleNum"
      select="substring-after($inputNode/@prst, 'o_')"
      as="xs:string"/>
    <xsl:variable
      name="paraStyleObj"
      select="key('inxObjectsById', $paraStyleNum, $inxDoc)"
      as="element()?"/>
    <xsl:variable
      name="paraFont"
      select="$paraStyleObj/@ptfs"/>
    <xsl:variable
      name="paraFontSuffix"
      select="substring-after($paraFont,'_')"
      as="xs:string"/>
    <xsl:variable
      name="paraFontStyle"
      select="key('style2tag', $paraFontSuffix , $style2tagMap)"/>
    <!-- get character font style -->
    <xsl:variable
      name="charStyleNum"
      select="substring-after($inputNode/@crst, 'o_')"
      as="xs:string"/>
    <xsl:variable
      name="charStyleObj"
      select="key('inxObjectsById', $charStyleNum, $inxDoc)"
      as="element()?"/>
    <xsl:variable
      name="charFont"
      select="$charStyleObj/@ptfs"/>
    <xsl:variable
      name="charFontSuffix"
      select="substring-after($charFont,'_')"/>
    <xsl:variable
      name="charFontStyle"
      select="key('style2tag', $charFontSuffix , $style2tagMap)"/>
    <!-- determine tag name, if required. $tag = "none" if font style doesn't map to tag. -->
    <xsl:variable
      name="tag">
      <xsl:choose>
        <xsl:when
          test="string(key('style2tag', $charFontSuffix , $style2tagMap)) != ''">
          <xsl:sequence
            select="key('style2tag', $charFontSuffix , $style2tagMap)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when
              test="string(key('style2tag', $paraFontSuffix , $style2tagMap)) != ''">
              <xsl:sequence
                select="key('style2tag', $paraFontSuffix , $style2tagMap)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence
                select="'none'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence
      select="string($tag)"/>
  </xsl:function>

  <xsl:function
    name="functions:getCharStyleName"
    as="xs:string">
    <xsl:param
      name="inputNode"
      as="node()"/>
    <xsl:param
      name="inxDoc"
      as="node()"/>
    <xsl:variable
      name="styleNum"
      select="substring-after($inputNode/@crst, 'o_')"
      as="xs:string"/>
    <xsl:variable
      name="charStyleObj"
      select="key('inxObjectsById', $styleNum, $inxDoc)"
      as="element()?"/>
    <xsl:variable
      name="charStyle"
      select="string($charStyleObj/@pnam)" as="xs:string"/>
    <xsl:variable
      name="styleSuffix"
      select="tokenize($charStyle,'~')[3]"
      as="xs:string?"
    />
    <xsl:variable
      name="tag" as="xs:string">
      <xsl:variable name="mappedTagName" select="string(key('style2tag', $styleSuffix , $style2tagMap))" as="xs:string"/>
      <xsl:choose>
        <xsl:when test="$styleSuffix = '[No character style]'">
          <!-- FIXME: Handle the case of mapping style overrides to tags, if possible, -->
          <xsl:sequence select="'none'"/>
        </xsl:when>
        <xsl:when
          test="$mappedTagName = ''">
          <xsl:sequence
            select="'none'"/>
          <xsl:message>
            <xsl:sequence
              select="concat(' - [WARNING] getCharStyleName(): No match for character style suffix: ', substring-after($charStyle,'k_'))"/>
          </xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence
            select="key('style2tag', $styleSuffix , $style2tagMap)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence
      select="$tag"/>
  </xsl:function>

  <xsl:function
    name="functions:getFont"
    as="xs:string">
    <xsl:param
      name="inputNode"
      as="node()"/>
    <xsl:variable
      name="txsrFont"
      select="normalize-space($inputNode/@rfont)"
      as="xs:string"/>
    <xsl:variable
      name="fontStatus">
      <xsl:choose>
        <xsl:when
          test="key('style2tag', $txsrFont, $style2tagMap) != ''">
          <xsl:sequence
            select="key('style2tag', $txsrFont, $style2tagMap)"/>
          <!-- <xsl:message select="$txsrFont"/> -->
          <!-- <xsl:message select="key('style2tag', $txsrFont, $style2tagMap)"/> -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence
            select="'unknown'"/>
          <!-- <xsl:message select="$txsrFont"/> -->
          <!-- <xsl:message select="key('style2tag', $txsrFont, $style2tagMap)"/> -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence
      select="concat($txsrFont,':',$fontStatus)"/>
  </xsl:function>

  <xsl:function
    name="functions:resolveFontAttrs"
    as="xs:string">
    <xsl:param
      name="inputNode"
      as="node()"/>
    <xsl:param
      name="inxDoc"
      as="node()"/>
    <!-- get name of font applied to character style, if any -->
    <xsl:variable
      name="styleNum"
      select="substring-after($inputNode/@crst, 'o_')"
      as="xs:string"/>
    <xsl:variable
      name="charStyleObj"
      select="key('inxObjectsById', $styleNum, $inxDoc)"
      as="element()?"/>
    <xsl:variable
      name="charFontName"
      select="$charStyleObj/@font"/>
    <xsl:variable
      name="charFontStyle"
      select="$charStyleObj/@ptfs"/>
    <!-- get name of font applied to paragraph style, if any -->
    <xsl:variable
      name="paraStyleNum"
      select="substring-after($inputNode/@prst, 'o_')"
      as="xs:string"/>
    <xsl:variable
      name="paraStyleObj"
      select="key('inxObjectsById', $paraStyleNum, $inxDoc)"
      as="element()?"/>
    <xsl:variable
      name="paraFontName"
      select="$paraStyleObj/@font"/>
    <xsl:variable
      name="paraFontStyle"
      select="$paraStyleObj/@ptfs"/>
    <!-- get inherited paragraph style, if any -->
    <xsl:variable
      name="baseParaStyleNum"
      select="substring-after($paraStyleObj/@basd, 'o_')"
      as="xs:string"/>
    <xsl:variable
      name="baseParaStyleObj"
      select="key('inxObjectsById', $baseParaStyleNum, $inxDoc)"
      as="element()?"/>
    <xsl:variable
      name="baseParaFontName"
      select="$baseParaStyleObj/@font"/>
    <xsl:variable
      name="baseParaFontStyle"
      select="$baseParaStyleObj/@ptfs"/>
    <!-- get name of font applied to txsr, if any -->
    <xsl:variable
      name="txsrFontName"
      select="$inputNode/@font"/>
    <xsl:variable
      name="txsrFontStyle"
      select="$inputNode/@ptfs"/>
    <!-- resolved font names required font name and style  -->
    <xsl:choose>
      <xsl:when
        test="$txsrFontName != ''">
        <xsl:variable
          name="result">
          <xsl:sequence
            select="substring-after($txsrFontName,'c_')"/>
          <xsl:if
            test="$txsrFontStyle != ''">
            <xsl:text> </xsl:text>
            <xsl:sequence
              select="substring-after($txsrFontStyle,'c_')"/>
          </xsl:if>
        </xsl:variable>
        <xsl:sequence
          select="$result"/>
      </xsl:when>
      <xsl:when
        test="$charFontName != ''">
        <xsl:variable
          name="result">
          <xsl:sequence
            select="substring-after($charFontName,'c_')"/>
          <xsl:if
            test="$charFontStyle != ''">
            <xsl:text> </xsl:text>
            <xsl:sequence
              select="substring-after($charFontStyle,'c_')"/>
          </xsl:if>
        </xsl:variable>
        <xsl:sequence
          select="$result"/>
      </xsl:when>
      <xsl:when
        test="$paraFontName != ''">
        <xsl:variable
          name="result">
          <xsl:sequence
            select="substring-after($paraFontName,'c_')"/>
          <xsl:if
            test="$paraFontStyle != ''">
            <xsl:text> </xsl:text>
            <xsl:sequence
              select="substring-after($paraFontStyle,'c_')"/>
          </xsl:if>
        </xsl:variable>
        <xsl:sequence
          select="$result"/>
      </xsl:when>
      <xsl:when
        test="$baseParaFontName != ''">
        <xsl:variable
          name="result">
          <xsl:sequence
            select="substring-after($baseParaFontName,'c_')"/>
          <xsl:if
            test="$baseParaFontStyle != ''">
            <xsl:text> </xsl:text>
            <xsl:sequence
              select="substring-after($baseParaFontStyle,'c_')"/>
          </xsl:if>
        </xsl:variable>
        <xsl:sequence
          select="$result"/>
      </xsl:when>
      <xsl:otherwise>
       <!-- <xsl:message
          select="$inputNode"/>-->
        <xsl:sequence
          select="'noFontApplied'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- embedded styles functions -->

  <xsl:function
    name="functions:getEmbeddedStylesList"
    as="node()">
    <xsl:param
      name="inputNode"
      as="node()"/>
    <xsl:param
      name="inxDoc"
      as="node()*"/>
    <xsl:variable
      name="paraStyleNum"
      select="substring-after($inputNode/@prst, 'o_')"
      as="xs:string"/>
    <xsl:variable
      name="paraStyleObj"
      select="key('inxObjectsById', $paraStyleNum, $inxDoc)"
      as="element()?"/>
    <xsl:variable
      name="alrs"
      select="$paraStyleObj/@alrs"/>
    <xsl:choose>
      <xsl:when
        test="$alrs != ''">
        <xsl:sequence
          select="$alrs"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute
          name="alrs"
          select="'none'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function
    name="functions:getEmbeddedStyleNames"
    as="xs:string">
    <xsl:param
      name="inputNode"
      as="node()"/>
    <xsl:param
      name="inxDoc"
      as="node()*"/>
    <xsl:variable
      name="alrs"
      select="$inputNode/@alrs"
      as="node()"/>
    <xsl:variable
      name="styleNums">
      <xsl:analyze-string
        select="$alrs"
        regex="o_u[\w]*_">
        <xsl:matching-substring>
          <xsl:sequence
            select="substring-after(.,'o_')"/>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:variable
      name="styleNames">
      <xsl:for-each
        select="tokenize($styleNums,'_')">
        <xsl:variable
          name="charStyleObj"
          select="key('inxObjectsById', ., $inxDoc)"
          as="element()?"/>
        <xsl:variable
          name="charStyle"
          select="$charStyleObj/@pnam"/>
        <xsl:variable
          name="styleSuffix"
          select="tokenize($charStyle,'~')[3]"/>
        <xsl:sequence
          select="concat($styleSuffix,',')"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:sequence
      select="$styleNames"/>
  </xsl:function>
  
  <xsl:function name="functions:getObjectLabel" as="xs:string">
    <!-- Given an INX object, returns the value of the specified label, if it exists. -->
    <xsl:param name="object" as="element()"/>
    <xsl:param name="labelName" as="xs:string"/>
    <xsl:variable name="labelData" select="functions:parsePtagValue($object/@ptag)" as="element()"/>
    <xsl:sequence select="string($labelData/label[@name = $labelName])"/> 
  </xsl:function>
  
  <xsl:function name="functions:parsePtagValue" as="element()">
    <!-- Parse a @ptag value into a convenient XML structure -->
    <xsl:param name="ptagAtt" as="attribute()?"/>
    <labels>
      <xsl:if test="count($ptagAtt) > 0">
        <xsl:analyze-string select="$ptagAtt" regex="x_2_c_([^_]+)_c_([^_]+)">
          <xsl:matching-substring>
            <xsl:variable name="label" select="regex-group(1)" as="xs:string"/>
            <xsl:variable name="value" select="regex-group(2)" as="xs:string"/>
            <xsl:message> label="<xsl:sequence select="$label"/>", value="<xsl:sequence select="$value"/>"</xsl:message>
            <label name="{$label}"><xsl:sequence select="$value"/></label>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:if>
    </labels>
  </xsl:function>

  <!-- This function processes script labels. Users apply script labels to text frames in InD, and a JavaScript moves those labels to the appropriate story. -->
  <!-- Labels are separated by semicolons (;) -->
  <!-- Media grouping labels are one or two digits.  -->

  <xsl:function
    name="functions:processLabel">
    <xsl:param
      name="inputNode"
      as="node()*"/>
    <xsl:variable
      name="label"
      select="tokenize($inputNode/@ptag, '_')[last()]"/>
    <xsl:variable
      name="labelTokens"
      select="tokenize($label, ';')"/>
    <xsl:for-each
      select="$labelTokens">
      <xsl:sequence select="()"/>
      <!-- Put label processing logic here -->
    </xsl:for-each>
  </xsl:function>

  <!-- This function retrieves InCopy notes (<Note>), which contain xml element information. -->
  <!-- To be processed, notes must follow the syntax: xmlTag:element;content -->
  <!-- Where "element" is the desired element name and "content" is the desired content of the element -->
  <xsl:function
    name="functions:processNote">
    <xsl:param
      name="inputNode"
      as="node()"/>
    <xsl:param
      name="inxDoc"
      as="node()*"/>
    <!-- get and process the @Self attribute from the PI -->
    <xsl:variable
      name="selfAttrRough"
      select="substring-after(string($inputNode),'rc_')"
      as="xs:string"/>
    <xsl:variable
      name="selfAttrLength"
      select="string-length($selfAttrRough)"/>
    <xsl:variable
      name="selfAttr"
      select="substring($selfAttrRough,1,$selfAttrLength - 1)"
      as="xs:string"/>
    <xsl:variable
      name="noteNode"
      select="key('inxAnchor2NoteMap', $selfAttr, $inxDoc)"
      as="element()?"/>
    <xsl:variable
      name="note"
      select="substring-after(string($noteNode),'c_')"/>
    <xsl:choose>
      <xsl:when
        test="matches($note, '^xmlTag:', 'i')">
        <xsl:variable
          name="xmlElement"
          select="substring-after($note,':')"/>
        <xsl:variable
          name="xmlTag"
          select="normalize-space(substring-before($xmlElement,';'))"/>
        <xsl:variable
          name="xmlContent"
          select="substring-after($xmlElement,';')"/>
        <xsl:element
          name="{$xmlTag}"
          >
          <xsl:value-of
            select="$xmlContent"/>
        </xsl:element>
        <!-- if not a dropcap, add space after element -->
        <xsl:if
          test="$xmlTag != 'dropcap'">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:when>
      <!-- If not an xml element, ignore note -->
      <xsl:otherwise>
        <xsl:sequence
          select="'none'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

<!-- This function processes Adobe Change notes and their associated insertion points (<?aid Char="0" ?> -->
<xsl:function name="functions:processChange">
  <xsl:param
    name="inputNode"
    as="node()"/>
  <xsl:param
    name="inxDoc"
    as="node()*"/>
  <!-- get attribute nodes from insertion point PI -->
  <xsl:variable 
    name="selfAttr" 
    select="substring-after(substring-before(substring-after($inputNode,'Self=&quot;'),'&quot;'),'rc_')"/>
  <xsl:variable 
    name="ChngNode" select="key('inxAnchor2ChngMap', $selfAttr, $inxDoc)"/>
  <xsl:copy-of select="$ChngNode"/>
</xsl:function>


  <!-- Special Character Mappings -->

  <xsl:function
    name="functions:mapSpecialCharacterEnum">
    <xsl:param
      name="enum"
      as="xs:string"/>
    <xsl:choose>
      <xsl:when
        test="$enum = 'SApn'"><!-- auto page number -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SNpn'"><!-- next page number -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SPpn'"><!-- previous page number -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SsnM'"><!-- section marker -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SBlt'">
        <!-- bullet character -->
        <xsl:text>&#x2022;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SCrt'">
        <!-- copyright symbol -->
        <xsl:text>&#xa9;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SDgr'">
        <!-- degree symbol -->
        <xsl:text>&#xB0;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SLps'">
        <!-- ellipsis character -->
        <xsl:text>&#x2026;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SFlb'"><!-- forced line break -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SPar'">
        <!-- paragraph symbol -->
        <xsl:text>&#xB6;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SRTm'">
        <!-- registered trademark -->
        <xsl:text>&#xAE;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SsnS'">
        <!-- section symbol -->
        <xsl:text>&#xA7;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'STmk'">
        <!-- trademark symbol -->
        <xsl:text>&#x2122;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SRit'"><!-- right indent tab -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SIht'"><!-- indent here tab -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SEmD'">
        <!-- Em dash -->
        <xsl:text>&#x2014;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SEnD'">
        <!-- En dash -->
        <xsl:text>&#x2013;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SDHp'">
        <!-- discretionary hyphen -->
        <xsl:text>&#xAD;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SNbh'">
        <!-- nonbreaking hyphen -->
        <xsl:text>&#x2011;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SBRS'"><!-- end nested style -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SDLq'">
        <!-- double left quote -->
        <xsl:text>&#x201c;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SDRq'">
        <!-- double right quote -->
        <xsl:text>&#x201d;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SSLq'">
        <!-- single left quote -->
        <xsl:text>&#x2018;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SSRq'">
        <!-- single right quote -->
        <xsl:text>&#x2019;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SEmS'">
        <!-- Em space -->
        <xsl:text>&#x2003;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SEnS'">
        <!-- En space -->
        <xsl:text>&#x2002;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SFlS'"><!-- flush space -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SHrS'">
        <!-- hair space -->
        <xsl:text>&#x2004;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SNbS'">
        <!-- nonbreaking space -->
        <xsl:text>&#xA0;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'STnS'">
        <!-- thin space -->
        <xsl:text>&#x2009;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SFgS'">
        <!-- figure space -->
        <xsl:text>&#x2007;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SPnS'">
        <!-- punctuation space -->
        <xsl:text>&#x2008;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SClB'"><!-- column break -->
        <!-- <xsl:processing-instruction name="aid"><xsl:sequence select="$enum"/></xsl:processing-instruction> -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SFrB'"><!-- frame break -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SPgB'"><!-- page break -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SOpB'"><!-- odd page break -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SEpB'"><!-- even page break -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SfnM'"><!-- footnote symbol -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SPtv'"><!-- text variable -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SSSq'">
        <!-- single straight quote -->
        <xsl:text>'</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SDSq'">
        <!-- double straight quote -->
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SPdL'"><!-- discretionary line break -->
        <!-- do not push through -->
      </xsl:when>
      <xsl:when
        test="$enum = 'SPnj'">
        <!-- zero width nonjoiner -->
        <xsl:text>&#x200c;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SThS'">
        <!-- third space -->
        <xsl:text>&#x2004;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SQuS'">
        <!-- quarter space -->
        <xsl:text>&#x2005;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'SSiS'">
        <!-- sixth space -->
        <xsl:text>&#x2006;</xsl:text>
      </xsl:when>
      <xsl:when
        test="$enum = 'Snnb'">
        <!-- fixed width nonbreaking space -->
        <xsl:text>&#x202F;</xsl:text>
        <!-- FIXME: Not sure this is right -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + WARNING: Unrecognized enumeration "<xsl:sequence
            select="$enum"/>" in pcnt element.</xsl:message>
        <xsl:processing-instruction
          name="aid">e_<xsl:sequence
            select="$enum"/></xsl:processing-instruction>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>
