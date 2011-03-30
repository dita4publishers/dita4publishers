<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nl "<xsl:text>&#x0a;</xsl:text>">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:idsc="http://www.reallysi.com/namespaces/indesign_style_catalog"
  xmlns:local="http://www.reallysi.com/functions/local"
  xmlns:stmm="http://www.reallysi.com/namespaces/styleToMarkupMap"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:xmp-x="adobe:ns:meta/"
  xmlns:xmp-rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:xmp-custom="reallysi/custom/"
  exclude-result-prefixes="xs idsc local stmm saxon xmp-x xmp-rdf xmp-custom"
  extension-element-prefixes="saxon">
  
  <xsl:param name="fileName" select="document-uri(.)"/>

  <xsl:key name="objectsById" match="*[@Self]" use="substring-after(@Self, '_')"/>
  <xsl:key name="anchor2ObjectMap" match="*[@STof]" use="substring-after(@STof, '_')"/>
  <xsl:key name="style2TopicTypeMap" match="stmm:topicItem" use="string(@styleName)"/>
  <xsl:key name="style2BlockTypeMap" match="stmm:blockItem" use="@styleName"/>
  <xsl:key name="style2InlineTypeMap" match="stmm:inlineItem" use="@styleName"/>
  
<!--
  <xsl:param name="styleToMarkupMap" select="'resources/style2markup_map.xml'" as="xs:string"/>
  
  <xsl:variable name="styleToMarkupMapDoc" select="document($styleToMarkupMap)" as="document-node()"/>
-->
  
  <xsl:output indent="yes"/>
  
  <!-- Transform to convert Business Week InCopy articles into XML.
    
  -->
  
  <!-- Load XMP -->
  <xsl:variable name="xmp">
    <xsl:apply-templates select="//pcnt" mode="XMP"/>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:if test="not(*[1]/self::SnippetRoot)">
      <xsl:message terminate="yes"> + ERROR: Input document does not appear to be an INCX file, found root element of "<xsl:value-of select="name(/*[1])"/>"</xsl:message>
    </xsl:if>
    <xsl:variable name="normalizedTextRuns">
      
      <xsl:apply-templates select="/*/cflo" mode="normalizeTextRuns"/>
    </xsl:variable>

    <xsl:variable name="stories" as="element()">
      <stories>&nl;
        <xsl:apply-templates select="$normalizedTextRuns" mode="makeParas">
          <xsl:with-param name="origDoc" select="." as="document-node()" tunnel="yes"/>
        </xsl:apply-templates>&nl;
      </stories>
    </xsl:variable>

    <!-- Output stories for diagnostic purposes -->
<!--
    <xsl:result-document href="stories.xml" method="xml" indent="no">
      <xsl:sequence select="$stories"/>
    </xsl:result-document>
-->

    <xsl:apply-templates select="$stories">
      <xsl:with-param name="origDoc" select="." as="document-node()" tunnel="yes"/>
      <xsl:with-param name="cur" select="." as="document-node()" tunnel="yes"/>
      <xsl:with-param name="xmp" select="$xmp" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="cflo" mode="normalizeTextRuns">
    <xsl:copy>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="txsr" mode="normalizeTextRuns">
    <xsl:choose>
      <xsl:when test="contains(./pcnt, '&#x2029;')">
        <xsl:variable name="context" select="." as="element()"/>
        <xsl:variable name="runs" select="tokenize(substring-after(./pcnt, 'c_'), '&#x2029;')" as="xs:string*"/>
        <xsl:choose>
          <xsl:when test="count($runs) = 2 and $runs[2] = ''">
            <!-- Run contains exactly one paragraph mark and ends with it -->
            <xsl:sequence select="."/>
          </xsl:when>
          <xsl:otherwise>
            <!-- FIXME: This will not copy embedded PIs -->
            <xsl:for-each select="$runs[position() &lt; last()]">
              <xsl:element name="txsr">
                <xsl:sequence select="$context/@*"/>
                <pcnt>c_<xsl:value-of select="."/>&#x2029;</pcnt>
              </xsl:element>
            </xsl:for-each>
          </xsl:otherwise>        
        </xsl:choose>
        
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="."/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template match="*" mode="normalizeTextRuns" priority="-1">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="cflo" mode="makeParas">
    <xsl:param name="origDoc" as="document-node()" tunnel="yes"/>
    <story>
      <xsl:for-each-group select="txsr" group-ending-with="*[local:isParaBreak(.)]">
        <para paraStyle="{local:getStyleName($origDoc, current-group()[last()]/@prst)}">&nl;
          <xsl:sequence select="current-group()"/>
        &nl;</para>&nl;
      </xsl:for-each-group>
    </story>
  </xsl:template>
  
  
  <xsl:template match="*" mode="makeParas" priority="-1">
    <xsl:message> + WARNING: Mode 'makrParas': Unhandled element <xsl:value-of select="name(..)"/>/<xsl:value-of select="name(.)"/></xsl:message>
  </xsl:template>
  
  <!-- ==================================
       Default mode: convert the paragraphs to
       Business-Week article elements based on the style names.
       =================================== -->
  
  <!-- XMP processing -->
  <xsl:template match="xmp-rdf:Alt | xmp-rdf:Bag | xmp-rdf:Seq" mode="xmp-value">
    <xsl:apply-templates select="xmp-rdf:li" mode="#current" />
  </xsl:template>

  <xsl:template match="xmp-rdf:Alt/xmp-rdf:li[@xml:lang='x-default']" mode="xmp-value">
    <xsl:apply-templates select="node()" mode="#current"/>
  </xsl:template>

  <xsl:template match="xmp-rdf:li" mode="xmp-value">
    <xsl:apply-templates select="node()" mode="#current"/>
  </xsl:template>

  <xsl:template name="local:xmp-value">
    <xsl:param name='name'/>
    <xsl:variable name="text">
      <xsl:apply-templates select="node()" mode="xmp-value"/>
    </xsl:variable>
    <xsl:element name="{ $name }"><xsl:value-of select="normalize-space(string-join($text,''))"/></xsl:element>
  </xsl:template>
  
  <xsl:template name="local:xmp-values">
    <xsl:param name='root'/>
    <xsl:param name='name'/>
    <xsl:element name="{ $root }">
      <xsl:for-each select="*/*">
	<xsl:call-template name="local:xmp-value">
	  <xsl:with-param name="name" select="$name"/>
	</xsl:call-template>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="xmp-custom:moid" mode="xmp-out">
    <xsl:call-template name="local:xmp-value">
      <xsl:with-param name="name" select="'moid'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xmp-custom:layoutID" mode="xmp-out">
    <xsl:call-template name="local:xmp-value">
      <xsl:with-param name="name" select="'layoutID'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xmp-custom:articleID" mode="xmp-out">
    <xsl:call-template name="local:xmp-value">
      <xsl:with-param name="name" select="'articleID'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xmp-custom:pubdate" mode="xmp-out">
    <xsl:call-template name="local:xmp-value">
      <xsl:with-param name="name" select="'pubdate'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xmp-custom:issue" mode="xmp-out">
    <xsl:call-template name="local:xmp-value">
      <xsl:with-param name="name" select="'issue'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xmp-custom:department" mode="xmp-out">
    <xsl:call-template name="local:xmp-value">
      <xsl:with-param name="name" select="'department'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xmp-custom:editor" mode="xmp-out">
    <xsl:call-template name="local:xmp-value">
      <xsl:with-param name="name" select="'editor'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xmp-custom:description" mode="xmp-out">
    <xsl:call-template name="local:xmp-value">
      <xsl:with-param name="name" select="'description'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xmp-custom:authors" mode="xmp-out">
    <xsl:call-template name="local:xmp-values">
      <xsl:with-param name="root" select="'authors'"/>
      <xsl:with-param name="name" select="'author'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="xmp-custom:keywords" mode="xmp-out">
    <xsl:call-template name="local:xmp-values">
      <xsl:with-param name="root" select="'keywords'"/>
      <xsl:with-param name="name" select="'keyword'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="text()" mode="xmp-out">
  </xsl:template>

  <xsl:template match="stories">

    <bw-article>

      <!-- Maintain specific ordering (better way?) -->
      <xsl:variable name="xmp-data">
	<xsl:apply-templates select="$xmp" mode="xmp-out"/>
	<xsl:if test="$fileName">
	  <filename><xsl:value-of select="$fileName"/></filename>
	</xsl:if>
      </xsl:variable>

      <xsl:for-each select="('moid','layoutID','articleID','filename','pubdate','issue','department','editor','description','authors','keywords')">
	<xsl:variable name="name" select="."/>
	<xsl:copy-of select="$xmp-data/*[local-name() eq $name]"/>
      </xsl:for-each>
<!--
      <headline/>
      <deck/>
-->
      <body>
	<xsl:for-each select=".//para[@paraStyle=tokenize('Text-byline_crea,Text-ragged-XI_body,Text-ragged_body',',')]">
	  <p><xsl:call-template name="handleBlockContent-xml"/></p>
	</xsl:for-each>
      </body>
    </bw-article>
  </xsl:template>
  
  <xsl:template match="story">
    <!-- Probably should only be 1 story, but if more than 1 we will just merge them. -->
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="handleBlockContent-xml">
    <xsl:apply-templates select=".//pcnt"/>
  </xsl:template>
  
<!--
  <xsl:template match="txsr">
    <xsl:param name="origDoc" as="document-node()" tunnel="yes"/>
    <xsl:variable name="charStyle" select="local:getStyleName($origDoc, @crst)" as="xs:string"/>
    <xsl:variable name="outputClass" select="local:constructOutputClassForPhrase(., $charStyle)" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$outputClass != ''"
        ><ph outputclass="{$outputClass}"
          ><xsl:apply-templates select="pcnt"
          /></ph
        ></xsl:when>
      <xsl:otherwise>      
        <xsl:apply-templates select="pcnt"/>
      </xsl:otherwise>    
    </xsl:choose>
  </xsl:template>
-->
  
  <xsl:template match="txsr">
    <xsl:param name="origDoc" as="document-node()" tunnel="yes"/>
    <xsl:variable name="charStyle" select="local:getStyleName($origDoc, @crst)" as="xs:string"/>
    <xsl:variable name="outputClass" select="local:constructOutputClassForPhrase(., $charStyle)" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="false() and $outputClass != ''"
        ><ph outputclass="{$outputClass}"
          ><xsl:apply-templates select="pcnt"
          /></ph
        ></xsl:when>
      <xsl:otherwise>      
        <xsl:apply-templates select="pcnt"/>
      </xsl:otherwise>    
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="pcnt">
    <xsl:choose>
      <xsl:when test="starts-with(., 'c_')">
        <xsl:apply-templates select="text()|processing-instruction()"/>
      </xsl:when>
      <xsl:when test="starts-with(., 'e_')">
        <xsl:sequence select="local:mapSpecialCharacterEnum(substring-after(., 'e_'))"/>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + WARNING: Unhandled type code <xsl:value-of select="substring-before(., '_')"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template match="pcnt/processing-instruction()" priority="0">
    <xsl:message> + DEBUG: Unhandled PI: Name="<xsl:value-of select="name(.)"/>", Value="<xsl:value-of select="."/>"</xsl:message>
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="pcnt/processing-instruction()[name(.) = 'aid'  and contains(string(.), 'Char=')]" priority="5">
    <xsl:param name="origDoc" as="document-node()" tunnel="yes"/>
    <!-- Special character PI, as determined by the character code -->
    <xsl:variable name="charCode" select="substring-before(substring-after(., 'Char=&#x22;'), '&#x22;')" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$charCode = 'fffc'"><!-- Object anchor -->
        <xsl:variable name="objId" select="substring-before(substring-after(., 'Self=&#x22;rc_'), '&#x22;')" as="xs:string"/>
        <xsl:variable name="target" select="key('anchor2ObjectMap', $objId, $origDoc)" as="element()?"/>
        <xsl:choose>
          <xsl:when test="count($target) > 0">
            <xsl:choose>
              <xsl:when test="$target//clnk">
                <!-- FIXME: For now assuming that a given anchored object would have at most
                            one link but I don't know if that's reliable.
                  -->
                <xsl:variable name="linkTargetUrl" as="xs:string"
                  select="local:getUrlForLinkTarget($target//clnk[1])"
                />
                <art><image href="{$linkTargetUrl}">
                     <alt>{<xsl:value-of select="$linkTargetUrl"/>}</alt>
                </image></art>
              </xsl:when>
            </xsl:choose>
            
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$charCode = '16'"><!-- Table anchor -->
        <xsl:variable name="objId" select="substring-before(substring-after(., 'Self=&#x22;rc_'), '&#x22;')" as="xs:string"/>
        <xsl:variable name="target" select="key('anchor2ObjectMap', $objId, $origDoc)" as="element()?"/>
        <xsl:choose>
          <xsl:when test="count($target) > 0">
            <xsl:apply-templates select="$target"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message> + WARNING: Failed to find table for table anchor with ID "<xsl:value-of select="$objId"/>"</xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$charCode = 'feff'"><!-- Note -->
        <xsl:variable name="objId" select="substring-before(substring-after(., 'Self=&#x22;rc_'), '&#x22;')" as="xs:string"/>
        <xsl:variable name="target" select="key('anchor2ObjectMap', $objId, $origDoc)" as="element()?"/>
        <xsl:choose>
          <xsl:when test="count($target) > 0">
            <xsl:apply-templates select="$target"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message> + WARNING: Failed to find table for table anchor with ID "<xsl:value-of select="$objId"/>"</xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> + WARNING: Unrecognized character code in processing instruction: <xsl:copy-of select="."/></xsl:message>
        <xsl:sequence select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="eval-expr">
    <xsl:param name="expr"/>
    <xsl:variable name="start" select="substring-after($expr, '(')"/>
    <xsl:if test="ends-with($start,')')">
      <xsl:variable name="eval" select="substring($start, 1, string-length($start)-1)"/>
      <xsl:copy-of select="saxon:parse($eval)"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Note">
    <xsl:variable name="notec">
      <xsl:apply-templates select="txsr"/>
    </xsl:variable>
    <xsl:variable name="notev" select="string-join($notec/text(),'')"/>
    <xsl:variable name="quot"><xsl:text>'</xsl:text></xsl:variable>
    <xsl:choose>
      <xsl:when test="starts-with($notev, '$TICKER$')">
	<xsl:call-template name="eval-expr">
	  <xsl:with-param name="expr" select="replace($notev,'&#x201d;',$quot)"/>
<!--
	  <xsl:with-param name="expr" select="replace($notev,'&#x201c;&#x201d;','XY')"/>
-->
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$notev"/>
      </xsl:otherwise>
    </xsl:choose>
<!--
    <draft-comment 
      author="{substring-after(@UsrN, '_')}" 
      time="{substring-after(@asmo, '_')}"><xsl:apply-templates select="txsr"/></draft-comment>
-->
  </xsl:template>
  
  <xsl:template match="ctbl">
    <table>
      <tgroup cols="{count(ccol)}">
        <xsl:apply-templates select="ccol"/>
        <tbody>    
      <xsl:for-each-group select="ccel" group-adjacent="substring-after(@pnam, ':')">
        <row>
          <xsl:apply-templates select="current-group()"/>
        </row>
      </xsl:for-each-group>
        </tbody>
      </tgroup>
    </table>
  </xsl:template>
  
  <xsl:template match="crow"/>
  
  <xsl:template match="ccol">
    <colspec colname="c{substring-after(@pnam, '_')}"/>
  </xsl:template>
  
  <xsl:template match="ccel">
    <xsl:variable name="rowSpan" select="xs:integer(substring-after(@RSpn, '_'))" as="xs:integer"/>
    <xsl:variable name="colSpan" select="xs:integer(substring-after(@CSpn, '_'))" as="xs:integer"/>
    <entry>
      <xsl:if test="$rowSpan > 1">
        <xsl:attribute name="rowspan" select="$rowSpan"/>
      </xsl:if>
      <xsl:if test="$colSpan > 1">
        <xsl:variable name="colStart" select="xs:integer(substring-before(substring-after(@pnam, '_'), ':'))" as="xs:integer"/>
        <xsl:variable name="colEnd" select="$colStart + $colSpan" as="xs:integer"/>
        <xsl:attribute name="namest" select="concat('c', $colStart)"/>
        <xsl:attribute name="nameend" select="concat('c', $colEnd)"/>
      </xsl:if>
      <xsl:apply-templates select="txsr"/></entry>    
  </xsl:template>
  
  <xsl:template match="cins"/> <!-- As far as I can tell this is only used for empty cells. -->
    
  
  
  <xsl:template match="pcnt/text()">
    <xsl:variable name="noParaBreak" 
      select="translate(if (starts-with(., 'c_'))
                             then substring-after(., 'c_')
                             else ., '&#x2029;', '')"
      as="xs:string"
    />
    <xsl:choose>
      <xsl:when test="contains($noParaBreak, '&#x09;')">
        <xsl:variable name="tokens" as="xs:string*" select="tokenize($noParaBreak, '&#x09;')"/>
        <xsl:for-each select="$tokens[position() &lt; last()]">
          <xsl:value-of select="."/><tab/>
        </xsl:for-each>
        <xsl:value-of select="$tokens[last()]"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$noParaBreak"/></xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <!-- ==================================
       Functions and utilities
    
       =================================== -->
  
  <xsl:template match="*" mode="#default" priority="-1">
    <xsl:message> + WARNING: Default mode: Unhandled element <xsl:value-of select="name(..)"/>/<xsl:value-of select="name(.)"/></xsl:message>
  </xsl:template>
  
  <xsl:function name="local:getTopicType" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <xsl:variable name="result" select="local:getTopicMapItem($styleName)/@topicType" as="xs:string"/>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:getTopicPubId" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <xsl:variable name="result" select="local:getTopicMapItem($styleName)/@publicId" as="xs:string"/>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:getTopicSystemId" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <xsl:variable name="result" select="local:getTopicMapItem($styleName)/@systemId" as="xs:string"/>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:getTopicBodyType" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <xsl:variable name="result" select="local:getTopicMapItem($styleName)/@bodyType" as="xs:string"/>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:getTopicTitleType" as="xs:string">
    <xsl:param name="styleName" as="xs:string"/>
    <xsl:variable name="result" select="local:getTopicMapItem($styleName)/@titleType" as="xs:string"/>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:getTopicMapItem" as="element()">
    <xsl:param name="styleName" as="xs:string"/>
    <getTopicMapItem publicId="none"/>
<!--
    <xsl:variable name="candItem" select="key('style2TopicTypeMap', $styleName, $styleToMarkupMapDoc)" as="element()?"/>
    <xsl:variable name="mapItem" as="element()?"
      select="if (count($candItem) > 0) 
      then $candItem
      else $styleToMarkupMapDoc/*/stmm:defaultTopicItem"
    />
    <xsl:sequence select="$mapItem"/>
-->
  </xsl:function>
  
  <xsl:function name="local:getStyleName" as="xs:string">
    <xsl:param name="inxDoc" as="document-node()"/>
    <xsl:param name="objRef" as="xs:string"/>
    <xsl:variable name="objId" select="substring-after($objRef, '_')" as="xs:string"/>
    <xsl:variable name="target" select="key('objectsById', $objId, $inxDoc)" as="element()?"/>
    <xsl:variable name="styleName" 
        select="if ($target) 
                   then local:char2string($target/@pnam)
                   else concat('{styleNotFound for objId ', $objId, '}')
                " 
        as="xs:string"/>
    <xsl:value-of select="$styleName"/>
  </xsl:function>
  
  <xsl:function name="local:char2string" as="xs:string">
    <xsl:param name="inString" as="xs:string"/>
    <xsl:variable name="result" as="xs:string"
      select="if (starts-with($inString, 'c_') or starts-with($inString, 'k_')) 
                 then replace(substring-after($inString, '_'), '~sep~', '_')
                 else replace($inString, '~sep~', '_')"
    />
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:isParaBreak" as="xs:boolean">
    <!-- Return true if a txsr element signals a paragraph break -->
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="pcnt" select="string($context/pcnt)" as="xs:string"/>
    <!-- See INX Scripting Reference for meaning of enumeration values (e_*) -->
    <xsl:variable name="result" as="xs:boolean"
      select="contains($pcnt, '&#x2029;') or
              $pcnt = 'e_SFrB'
      "
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:function name="local:constructOutputClassForPhrase" as="xs:string">
    <xsl:param name="txsr" as="element()"/>
    <xsl:param name="charStyle" as="xs:string"/>
    
    <xsl:variable name="sortedAtts" as="attribute()*">
      <xsl:for-each select="$txsr/@*">
        <xsl:sort select="name(.)"/>
        <xsl:if test="not(contains('^crst^prst^IMa1^IMa2^IMsd^', concat('^', name(.), '^')))">
          <xsl:sequence select="."/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="formatOverrides" as="xs:string*">
      <xsl:for-each select="$sortedAtts">
        <xsl:value-of select="concat(name(.), '=', .)"/>
      </xsl:for-each>
    </xsl:variable>    
    <xsl:variable name="result" as="xs:string?" select="if (count($formatOverrides) = 0)
        then ''
        else concat($charStyle, '~sep~', string-join($formatOverrides, '~sep~'))"/>
    <xsl:value-of select="$result"/>
  </xsl:function>
  
  <xsl:template match="@*" mode="constructOutputClass">
    <xsl:param name="rest" as="attribute()*"/>
    <xsl:param name="outputClass" as="xs:string"/>
    <xsl:variable name="newOutputClass" select="concat($outputClass, '+', name(.), '=', string(.))" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="count($rest) > 0">
        <xsl:apply-templates select="$rest[1]" mode="#current">
          <xsl:with-param name="rest" select="$rest[position() > 1]" as="attribute()*"/>
          <xsl:with-param name="outputClass" select="$newOutputClass" as="xs:string"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$newOutputClass"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="constructOutputClass" match="@crst | @prst | @IMa1 | @IMa2 | @IMsd" priority="10">
    <xsl:param name="rest" as="attribute()*"/>
    <xsl:param name="outputClass" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="count($rest) > 0">
        <xsl:apply-templates select="$rest[1]" mode="#current">
          <xsl:with-param name="rest" select="$rest[position() > 1]" as="attribute()*"/>
          <xsl:with-param name="outputClass" select="$outputClass" as="xs:string"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$outputClass"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:function name="local:getUrlForLinkTarget" as="xs:string">
    <xsl:param name="clink" as="element()"/>
    <xsl:variable name="valueTokens" select="tokenize($clink/@LnkI, '_')" as="xs:string*"/>
    <!-- FIXME: This will fail for Windows-based links. Not sure how to know reliably what pattern to
                use in interpreting the values for the clnk element except to know the platform.
                
                Also need more generic function to parse out the array into its components.
      -->
    <xsl:variable name="link" select="$valueTokens[16]" as="xs:string"/><!-- Should be filename of linked file -->
    <xsl:variable name="targetFn" select="substring-after($link, ':')" as="xs:string"/><!-- Hoping first token is always OS identifier -->
    <xsl:variable name="fixedString" select="local:char2string($targetFn)" as="xs:string"/>
    <xsl:value-of select="$fixedString"/>
  </xsl:function>
  
  <xsl:function name="local:mapSpecialCharacterEnum">
    <xsl:param name="enum" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$enum = 'SApn'"><!-- auto page number -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SNpn'"><!-- next page number -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SPpn'"><!-- previous page number -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SsnM'"><!-- section marker -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SBlt'"><!-- bullet character -->
        <xsl:text>&#x2022;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SCrt'"><!-- copyright symbol -->
        <xsl:text>&#xa9;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SDgr'"><!-- degree symbol -->
        <xsl:text>&#xB0;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SLps'"><!-- ellipsis character -->
        <xsl:text>&#x2026;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SFlb'"><!-- forced line break -->
        <xsl:text>&#x2028;</xsl:text><!-- Not sure this is the best match -->
      </xsl:when>
      <xsl:when test="$enum = 'SPar'"><!-- paragraph symbol -->
        <xsl:text>&#xB6;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SRTm'"><!-- registered trademark -->
        <xsl:text>&#xAE;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SsnS'"><!-- section symbol -->
        <xsl:text>&#xA7;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'STmk'"><!-- trademark symbol -->
        <xsl:text>&#x2122;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SRit'"><!-- right indent tab -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SIht'"><!-- indent here tab -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SEmD'"><!-- Em dash -->
        <xsl:text>&#x2014;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SEnD'"><!-- En dash -->
        <xsl:text>&#x2013;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SDHp'"><!-- discretionary hyphen -->
        <xsl:text>&#xAD;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SNbh'"><!-- nonbreaking hyphen -->
        <xsl:text>&#x2011;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SBRS'"><!-- end nested style -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SDLq'"><!-- double left quote -->
        <xsl:text>&#x201c;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SDRq'"><!-- double right quote -->
        <xsl:text>&#x201d;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SSLq'"><!-- single left quote -->
        <xsl:text>&#x2018;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SSRq'"><!-- single right quote -->
        <xsl:text>&#x2019;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SEmS'"><!-- Em space -->
        <xsl:text>&#x2003;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SEnS'"><!-- En space -->
        <xsl:text>&#x2002;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SFlS'"><!-- flush space -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SHrS'"><!-- hair space -->
        <xsl:text>&#x2004;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SNbS'"><!-- nonbreaking space -->
        <xsl:text>&#xA0;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'STnS'"><!-- thin space -->
        <xsl:text>&#x2009;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SFgS'"><!-- figure space -->
        <xsl:text>&#x2007;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SPnS'"><!-- punctuation space -->
        <xsl:text>&#x2008;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SClB'"><!-- column break -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SFrB'"><!-- frame break -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SPgB'"><!-- page break -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SOpB'"><!-- odd page break -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SEpB'"><!-- even page break -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SfnM'"><!-- footnote symbol -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SPtv'"><!-- text variable -->
        <xsl:processing-instruction name="aid"><xsl:value-of select="$enum"/></xsl:processing-instruction>
      </xsl:when>
      <xsl:when test="$enum = 'SSSq'"><!-- single straight quote -->
        <xsl:text>'</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SDSq'"><!-- double straight quote -->
        <xsl:text>"</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SPdL'"><!-- discretionary line break -->
        <xsl:text>&#x200b;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SPnj'"><!-- zero width nonjoiner -->
        <xsl:text>&#x200c;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SThS'"><!-- third space -->
        <xsl:text>&#x2004;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SQuS'"><!-- quarter space -->
        <xsl:text>&#x2005;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'SSiS'"><!-- sixth space -->
        <xsl:text>&#x2006;</xsl:text>
      </xsl:when>
      <xsl:when test="$enum = 'Snnb'"><!-- fixed width nonbreaking space -->
        <xsl:text>&#x202F;</xsl:text><!-- FIXME: Not sure this is right -->
      </xsl:when>          
      <xsl:otherwise>
        <xsl:message> + WARNING: Unrecognized enumeration "<xsl:value-of select="$enum"/>" in pcnt element.</xsl:message>
        <xsl:processing-instruction name="aid">e_<xsl:value-of select="$enum"/></xsl:processing-instruction>
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

</xsl:stylesheet>
