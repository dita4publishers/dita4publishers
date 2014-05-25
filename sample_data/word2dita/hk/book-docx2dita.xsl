<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="urn:local-functions"
      
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      
      exclude-result-prefixes="xs rsiwp stylemap local relpath"
      version="2.0">

  <!--==========================================
    RSI Simple Word Processing XML to Human Kinetics DITA XML
    
    Copyright (c) 2011 Human Kinetics

    Transforms a DOCX document.xml file into a book-component topic.
    
    =========================================== -->
   
  <xsl:import href="../../../toolkit_plugins/net.sourceforge.dita4publishers.word2dita/xsl/docx2dita.xsl"/>
  
  <xsl:output 
    doctype-public="urn:pubid:humankinetics.com:doctypes:dita:chapter"
    doctype-system="chapter.dtd"
    indent="yes"/>
  
  <xsl:template match="tab" mode="#all"/>

  <xsl:template mode="simpleWpDoc-fixup" 
  match="rsiwp:p[following-sibling::rsiwp:p[@style = 'ct' or @style = 'pt']]" 
  priority="10">
    <!-- Suppress any paragraphs that precede the CHD paragraph. -->
  </xsl:template>

  <xsl:template mode="simpleWpDoc-fixup" match="rsiwp:p[@style = 'ct' or @style = 'pt']" priority="10">
    <xsl:sequence select="."/>
<!--    <xsl:message> + [DEBUG] chapter-docx2dita.xsl: Moving elements before ct para to after it...</xsl:message>-->
    <xsl:sequence select="preceding-sibling::rsiwp:p"/>
  </xsl:template>
  
  <xsl:template mode="simpleWpDoc-fixup" 
    match="rsiwp:p[contains(., '\INSERT')][following-sibling::rsiwp:p[1][@style = 'fc']] " 
    priority="10">
    <!-- Suppress and move after the fc paragraph. -->
  </xsl:template>
  
  <xsl:template mode="simpleWpDoc-fixup" match="rsiwp:p[@style = 'fc']" priority="10">
    <xsl:sequence select="."/>
    <xsl:variable name="insert" as="element()?" select="preceding-sibling::rsiwp:p[1][contains(., '\INSERT')]"/>
    <!-- If there's an \INSERT paragraph before the figure caption, move it after. -->
    <xsl:sequence select="$insert"/>
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="sl[not(sli)] | ul[not(li)] | ol[not(li)]">
    <!-- suppress empty list elements -->
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="term/term">
    <xsl:apply-templates mode="#current"/><!-- Unwrap double terms -->
  </xsl:template>
  
  <xsl:template  mode="final-fixup" match="title[parent::fig[following-sibling::fn]]">
    <!-- WEK: For some reason, this results in the comment for the FN being output, not
      the separately-copied fn element. No idea why.
      -->
    <xsl:copy>
      <xsl:sequence select="@*"/>
      <xsl:apply-templates mode="#current"/>
      <xsl:variable name="fn" select="../following-sibling::fn" as="element()*"/>
      <ph><xsl:apply-templates select="$fn" mode="copy-root"/></ph>      
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="copy-root" match="*">
    <xsl:message> + [DEBUG] In copy-root, elem=&lt;<xsl:sequence select="name(.)"/>&gt;</xsl:message>
    <xsl:copy>
      <xsl:apply-templates select="@*,node()" mode="final-fixup"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="copy-root" match="text() | @*">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="fn">
    <xsl:comment>Footnote was here: <xsl:sequence select="."/></xsl:comment>
  </xsl:template>

  <!-- FIXME: Right now there's no way to get two levels of wrapping around
              the generated question.
    -->
  
  
  <xsl:template mode="final-fixup" 
  match="
  lcSingleSelect/lcQuestion | 
  lcTrueFalse/lcQuestion |
  lcSingleSelect2/lcQuestion2 | 
  lcTrueFalse2/lcQuestion2">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:attribute name="id" select="generate-id(.)"/>
      <xsl:apply-templates mode="#current" select="node() except (lcAnswerOptionGroup, lcAnswerOptionGroup2)"/>
    </xsl:copy>
    <xsl:apply-templates mode="#current" select="lcAnswerOptionGroup | lcAnswerOptionGroup2"/>
  </xsl:template>
  
  <xsl:template mode="final-fixup" 
  match="lcAnswerContent[@outputclass = 'lcCorrectResponse'] |
  lcAnswerContent2[@outputclass = 'lcCorrectResponse']">
    <xsl:next-match/>
    <lcCorrectResponse/>    
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="@outputclass[. = 'lcCorrectResponse']">
    <!-- Filter out -->
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="image">
    <xsl:variable name="content" as="xs:string" select="."/>
    <xsl:variable name="imageId" as="xs:string?">
      <xsl:analyze-string select="$content" regex="ID# ([^,]+)">
        <xsl:matching-substring>
          <xsl:sequence select="regex-group(1)"/>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:variable name="imageUrl" as="xs:string?"
      select="$imageId"
    />
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:attribute name="href" select="$imageUrl"/>
      <xsl:if test="not(alt)">
        <alt>
          <xsl:apply-templates mode="#current"/>
        </alt>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="fig">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:apply-templates select="title" mode="#current"/>
      <xsl:apply-templates select="node() except title, art" mode="#current"/>
      <xsl:apply-templates select="(following-sibling::*)[1][self::art]" mode="copy-root"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="art[preceding-sibling::*[1][self::fig]]">
    <!-- Suppress here -->
  </xsl:template>
  
  <xsl:template mode="final-fixup" match="draft-comment[matches(., 'new question', 'i')]">
    <!-- Suppress in output. This comment is a hack to get around the limitation that you can't
         turn off grouping within common container elements in the mapping configuration.
      -->
  </xsl:template>
  
</xsl:stylesheet>
 