<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:local="http://local/functions"
  xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
  xmlns:dita-ot-pdf="http://net.sf.dita-ot/transforms/pdf"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:df="http://dita2indesign.org/dita/functions"
  xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n 
  opentopic-func xs xd relpath df local dita-ot-pdf ot-placeholder"
  version="2.0">

  <!--================================
    
      Page sequence construction
      
      These templates manage the construction
      of the result FO page sequences from
      the merged map and topics.
      ================================-->

  <xsl:template name="constructNavTreePageSequences">
    <!-- Template to manage construction of the page sequences
         that reflect the navigation tree defined in the
         input map.
    -->
    <xsl:param name="frontCoverTopics"  as="element()*" select="()"/>
    <xsl:param name="backCoverTopics"  as="element()*" select="()"/>
    

    <xsl:apply-templates mode="constructNavTreePageSequences" select="/">
        <xsl:with-param name="frontCoverTopics" as="element()*" 
          select="$frontCoverTopics"
          tunnel="yes"
        />
        <xsl:with-param name="backCoverTopics" as="element()*" 
          select="$backCoverTopics"
          tunnel="yes"
        />
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template mode="constructNavTreePageSequences" match="text()"/>

  <xsl:template mode="constructNavTreePageSequences" match="/">
    <xsl:param name="frontCoverTopics"  as="element()*" tunnel="yes"/>
    <xsl:param name="backCoverTopics"  as="element()*"  tunnel="yes"/>
     
     <!-- FIXME: Need a general way to handle book lists or automatic
          generation of the book lists when not specified.
     -->
    
    <!-- Get a flat list of all the top-level topics or topicrefs: -->
    <xsl:variable name="topLevelTopics" as="element()*">      
      <xsl:apply-templates mode="getTopLevelTopics" 
        select="/*/opentopic:map/*[contains(@class, ' map/topicref ')] |
                /*/ot-placeholder:*"/>
    </xsl:variable>
    
    <xsl:if test="true()">
      <xsl:message>+ [DEBUG] constructNavTreePageSequences: topLevelTopics=<xsl:sequence 
        select="for $e in $topLevelTopics return concat('&#x0A;', name($e), ' [id=', $e/@id, ', type=', dita-ot-pdf:determineTopicType($e), ']')"/></xsl:message>
    </xsl:if>
     
    <!-- The challenge now is to group the topics into the major regions of the document:
         
         - frontmatter  - everything between the cover and the first body topic)
         - body         - The main content topics
         - appendixes   - Appendix chapters
         - backmatter   - Everything between body/appendixes and the back cover (if any)
         
         Usually the frontmatter has to be at least one page sequence in order to get
         lowercase roman page numbers.
         
         The body must be at least one page sequence to get arabic page numbers, but may
         be more page sequences, especially if folio-by-chapter numbering is used.
         
         The appendixes will need a different page sequence if they are numbered differently
         or if they have different page geometry.
         
         The backmatter sections usually require distinct page sequences because they will
         have different page designs (e.g., glossary vs. index vs. bibliography).
         
         In general, page breaks should be created using break-before on the initial blocks 
         generated from topics, not by creating new page sequences. However, some FO engines
         may benefit from having shorted page sequences (e.g., FOP), so it's not necessarily
         wrong to have each top-level topic or generated section start a new page sequence,
         but it's not a requirement either.
         
         We use a function, getPublicationRegion(), to return the publication region name
         and then use group-adjacent to construct new page sequences for each region. The
         getPublicationRegion() function uses the getPublicationRegion mode to map topics and
         topicrefs to their region. You can implement templates in that mode to determine
         how specific topics or topicrefs map to page sequences.
         
    -->
     
<!--     <xsl:message>+ [DEBUG] page-sequences: Generating page sequence constructors...</xsl:message>-->
     <xsl:for-each-group select="$topLevelTopics except $frontCoverTopics | $backCoverTopics" group-adjacent="local:getPublicationRegion(.)">
       <xsl:variable name="pubRegion" select="local:getPublicationRegion(.)"/>
<!--       <xsl:message>+ [DEBUG]   pubRegion="<xsl:sequence select="$pubRegion"/></xsl:message>-->
       <xsl:variable name="pageSequenceGenerator">
         <dita-ot-pdf:pageSequence pubRegion="{$pubRegion}"/>         
       </xsl:variable>       
       <xsl:apply-templates mode="constructPageSequence" select="$pageSequenceGenerator">
         <xsl:with-param name="pubRegion" select="string(@pubRegion)" as="xs:string" tunnel="yes"/>
         <xsl:with-param name="topics" as="element()*" tunnel="yes">
           <xsl:sequence select="current-group()"/>
         </xsl:with-param>
       </xsl:apply-templates>       
     </xsl:for-each-group>    
   </xsl:template>
  
  <!-- ====================================
       Page sequence construction templates
       
       Because of the use of attribute sets and the fact that
       fo:page-sequence isn't that complicated, it's
       easiest to just repeat the literal page sequence
       construction rather than trying to parameterize
       it through a generic page sequence construction
       template.
       
       Implement templates in the mode constructPageSequence
       to implement custom pub region values or to
       otherwise customize how page sequences are constructed.
       ==================================== -->

  <xsl:template mode="constructPageSequence" match="dita-ot-pdf:pageSequence[@pubRegion = 'frontmatter']" priority="10">
    <xsl:call-template name="doPageSequenceConstruction">
      <xsl:with-param name="pageSequenceMasterName" select="'front-matter-sequence'"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="doPageSequenceConstruction">
    <!-- Context item is a dita-ot-pdf:pageSequence element -->
    <xsl:param name="pageSequenceMasterName" as="xs:string"/>
    <xsl:param name="topics" as="element()*" tunnel="yes"/>
    
<!--    <xsl:message>+ [DEBUG] doPageSequenceConstruction: constructing page sequence for region <xsl:sequence select="string(@pubRegion)"/>, master <xsl:sequence select="$pageSequenceMasterName"/>...</xsl:message>-->

    <fo:page-sequence master-reference="{$pageSequenceMasterName}" 
      xsl:use-attribute-sets="__force__page__count">
      <xsl:apply-templates select="." mode="setInitialPageNumber"/>      
      <xsl:apply-templates select="." mode="constructStaticContent"/>
      
      <fo:flow flow-name="xsl-region-body">
        <!-- Process each topic in the page sequence. -->
        <xsl:for-each select="$topics">
          <!-- Topic handling is done via match templates
               that select on the value of determineTopicType()
               so that any topic can act as a page-breaking topic
               or not. No need to presume that the direct child
               topics of the flow will act as "top-level"
               topics, e.g., chapters.
          -->
          <xsl:choose>
            <xsl:when test="self::ot-placeholder:figurelist | self::ot-placeholder:tablelist">
              <xsl:message>+ [DEBUG]  Skipping placeholder <xsl:sequence select="name(.)"/></xsl:message>
            </xsl:when>
            <xsl:otherwise>
<!--              <xsl:message>+ [DEBUG] doPageSequenceConstruction:   Applying templates to <xsl:sequence select="concat(name(..), '/', name(.))"/>.</xsl:message>-->
                <xsl:apply-templates select="."/>              
<!--              <xsl:message>+ [DEBUG] doPageSequenceConstruction:   Templates applied. </xsl:message>-->
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </fo:flow>
    </fo:page-sequence>
    
  </xsl:template>
  
  <xsl:template mode="constructStaticContent" match="*">
      <xsl:call-template name="insertBodyStaticContents"/>    
  </xsl:template>
  
  <xsl:template mode="setInitialPageNumber" match="*">
    <!-- Override this mode to set the initial-page-number
         attribute to the appropriate value for the page
         sequence.
         
         By default, the first page sequence with the
         pub region whose name starts with "body" resets
         the initial page number to 1.
         
         You would need to override this behavior if you 
         want the pages numbered sequentially from the first
         physical page (no numbering reset) or to 
         get folio-by-chapter numbering (reset with each
         new chapter).ß
      -->
    <!-- 
      <xsl:attribute name="initial-page-number"
        select="1"
      />
    -->
    
  </xsl:template>
  
  <xsl:template mode="setInitialPageNumber" 
    match="dita-ot-pdf:pageSequence[starts-with(@pubRegion, 'body')][1]">
      <xsl:attribute name="initial-page-number"
        select="1"
      />
  </xsl:template>
  
  <xsl:template mode="constructStaticContent" match="dita-ot-pdf:pageSequence[starts-with(@pubRegion, 'frontmatter')]">
      <xsl:call-template name="insertFrontMatterStaticContents"/>    
  </xsl:template>
  
  
  <!-- ==========================================
       Page sequence construction templates
       
       ========================================== -->
  
  <!-- NOTE: the match is redundant but want to make it clear that the default pubRegion is body -->
  <xsl:template mode="constructPageSequence" match="dita-ot-pdf:pageSequence[starts-with(@pubRegion, 'body')] | *">
    <xsl:call-template name="doPageSequenceConstruction">
      <xsl:with-param name="pageSequenceMasterName" select="'body-sequence'"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template mode="constructPageSequence" match="dita-ot-pdf:pageSequence[@pubRegion = 'appendices']" priority="10">
    <xsl:call-template name="doPageSequenceConstruction">
      <xsl:with-param name="pageSequenceMasterName" select="'body-sequence'"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template mode="constructPageSequence" match="dita-ot-pdf:pageSequence[@pubRegion = 'glossary']" priority="10">
    <xsl:call-template name="doPageSequenceConstruction">
      <xsl:with-param name="pageSequenceMasterName" select="'body-sequence'"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template mode="constructNavTreePageSequences" match="*[df:class(., 'topic/topic')]">
    <xsl:apply-templates select="."/><!-- Apply normal mode processing -->
  </xsl:template>
  
  <xsl:template mode="constructNavTreePageSequences" match="ot-placeholder:*">
    <xsl:message>+ [WARNING] Matched on <xsl:sequence select="name(.)"/> in mode constructNavTreePageSequences</xsl:message>
    <fo:block>Placeholder for generated stuff: <xsl:sequence select="name(.)"/>
    </fo:block>
  </xsl:template>
  
</xsl:stylesheet>
