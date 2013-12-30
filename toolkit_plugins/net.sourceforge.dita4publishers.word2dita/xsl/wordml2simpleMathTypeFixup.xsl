<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:mv="urn:schemas-microsoft-com:mac:vml"
      xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main"
      xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
      xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
      xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
      xmlns:v="urn:schemas-microsoft-com:vml"
      xmlns:w10="urn:schemas-microsoft-com:office:word"
      xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
      xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
      xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
      xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
      xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
      xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships"
      xmlns:mathml="http://www.w3.org/1998/Math/MathML"
      
      xmlns:local="urn:local-functions"
      
      xmlns:saxon="http://saxon.sf.net/"
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      
      exclude-result-prefixes="a pic xs mv mo ve o r m v w10 w wne wp local relpath saxon"
      version="2.0">
  <!-- MathType fixup. This is mode "simpleWpDoc-MathTypeFixup -->
  
  <xsl:template match="/" mode="simpleWpDoc-MathTypeFixup">
    <!-- Process the paragraphs in groups, grouping paragraphs that 
         start with "" and end with "" together, converting such 
         groups to single paragraphs with literal MathML markup.
      -->
    <xsl:apply-templates select="node()" mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="simpleWpDoc-MathTypeFixup"
    match="rsiwp:body">
    <xsl:copy>
      <xsl:for-each-group select="*" group-adjacent="local:isMathTypeContent(.)">
        <xsl:choose>
          <xsl:when test="current-grouping-key() = 'true'">
           <rsiwp:p>
             <!-- Get the attributes for the first paragraph of the group so we get its style,
                  Word location, etc.
               -->
             <xsl:apply-templates select="current-group()[1]/@*" mode="#current"/>
             <xsl:comment> MathML Generated from MathType-generated MathML markup. </xsl:comment>
             <xsl:apply-templates select="local:makeMathMLMarkup(current-group())" mode="handleMathMLMarkup"/>
           </rsiwp:p>
          </xsl:when>
          <xsl:otherwise>
            <!-- Not MathType, just echo to the output -->
            <xsl:apply-templates select="current-group()" mode="#current"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:copy>
  </xsl:template>
  
  <xsl:function name="local:makeMathMLMarkup" as="node()*">
    <xsl:param name="inputNodes" as="node()*"/>
    <xsl:variable name="rawData" as="xs:string"
      select="
      concat('&lt;root xmlns:m=&quot;http://www.w3.org/1998/Math/MathML&quot;>', 
      string-join($inputNodes, ''), 
      '&lt;/root>')"
    />
    <xsl:variable name="result" as="node()*"
      select="saxon:parse($rawData)"
    />
    <xsl:sequence select="$result"/>
  </xsl:function>
  
  <xsl:template mode="mathType2MathML" match="*" priority="-1">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="mathType2MathML" match="rsiwp:run">
    <xsl:choose>
      <xsl:when test="starts-with(.,'&lt;!--')">
        <!-- Found a comment -->
        <xsl:comment><xsl:sequence select="substring(., 5, string-length(.) - 5)"/></xsl:comment>
      </xsl:when>
      <xsl:otherwise>
        <!-- Must be one or more elements. It appears that the MathType converter always
             puts complete tags within a single run.
          -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="handleMathMLMarkup" match="root">
    <xsl:apply-templates mode="#current" select="node()"/>
  </xsl:template>
  
  <xsl:template mode="handleMathMLMarkup" match="mathml:*">
    <xsl:copy>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:copy>
    
  </xsl:template>
  
  <xsl:template mode="handleMathMLMarkup" match="text() | @* | processing-instruction()">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template mode="handleMathMLMarkup" match="*" priority="-1">
    <xsl:copy></xsl:copy>
  </xsl:template>
  
  <xsl:function name="local:isMathTypeContent" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:variable name="result" as="xs:boolean"
      select="if ($context/rsiwp:run[@style = 'MTConvertedEquation']) then true() else false()"
    />
    <xsl:sequence select="string($result)"/>
  </xsl:function>
  
  <xsl:template mode="simpleWpDoc-MathTypeFixup" priority="-1"
    match="*">
    <xsl:copy>
      <xsl:apply-templates mode="#current" select="@*, node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="simpleWpDoc-MathTypeFixup" priority="-1"
    match="@* | text() | processing-instruction() | comment()" 
    >
    <xsl:sequence select="."/>
  </xsl:template>
  
</xsl:stylesheet>