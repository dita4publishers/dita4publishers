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
  xmlns:dita-ot="http://net.sf.dita-ot"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  xmlns:df="http://dita2indesign.org/dita/functions"
  exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func xs xd relpath df local dita-ot"
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
      <xsl:apply-templates mode="getTopLevelTopics" select="/*/opentopic:map/*[contains(@class, ' map/topicref ')]"/>
    </xsl:variable>
     
    <xsl:if test="true()">
      <xsl:message>+ [DEBUG] constructNavTreePageSequences: topLevelTopics=<xsl:sequence 
        select="for $e in $topLevelTopics return concat('&#x0A;', name($e), ' [id=', $e/@id, ']')"/></xsl:message>
    </xsl:if>
     
    <!-- Construct an XML structure that maps each topic or topicref to its semantic topic
         type. This map is then used to assign topics and topicrefs to specific page sequences. 
       -->
    <xsl:variable name="topicToTypeMap" as="element()*">
      <xsl:apply-templates mode="mapTopicsToType"
        select="$topLevelTopics except $frontCoverTopics | $backCoverTopics" 
      />
    </xsl:variable>
    
    <xsl:if test="true()">
      <xsl:message>+ [DEBUG] Topic to type map:</xsl:message>
      <xsl:for-each select="$topicToTypeMap">
        <xsl:message>+ [DEBUG]  <xsl:sequence select="concat('topicType=', @topicType, ', topicId=', @topicId)"/></xsl:message>
      </xsl:for-each>
      <xsl:message>+ [DEBUG] -----------------
      </xsl:message>
    </xsl:if>
     
    <!-- Now we know what the topic type is for each top-level topic or topicref. 
      
         The challenge now is to group the topics into the major regions of the document:
         
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
     
     <xsl:for-each-group select="$topicToTypeMap" group-adjacent="local:getPublicationRegion($mergedDoc, .)">
       <xsl:variable name="pubRegion" select="local:getPublicationRegion($mergedDoc, .)"/>
       <xsl:variable name="pageSequenceGenerator">
          <dita-ot:pageSequence pubRegion="{$pubRegion}">
           <xsl:for-each select="current-group()">
             <xsl:variable name="topicRefId" select="@topicId" as="xs:string"/>
             <xsl:variable name="topic" as="element()?"
               select="key('topicsById', $topicRefId, $mergedDoc)[1]"
             />
             <xsl:sequence select="$topic"/>
           </xsl:for-each>
         </dita-ot:pageSequence>
       </xsl:variable>       
       <xsl:apply-templates mode="constructPageSequence" select="$pageSequenceGenerator"/>       
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

  <xsl:template mode="constructPageSequence" match="dita-ot:pageSequence[@pubRegion = 'frontmatter']" priority="10">
    <xsl:call-template name="doPageSequenceConstruction">
      <xsl:with-param name="pageSequenceMasterName" select="'front-matter-sequence'"/>
      <xsl:with-param name="pubRegion" select="string(@pubRegion)" as="xs:string" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="doPageSequenceConstruction">
    <!-- Context item is a dita-ot:pageSequence element -->
    <xsl:param name="pageSequenceMasterName" as="xs:string"/>

    <fo:page-sequence master-reference="{$pageSequenceMasterName}" 
      xsl:use-attribute-sets="__force__page__count">
      <xsl:apply-templates select="." mode="setInitialPageNumber"/>      
      <xsl:apply-templates select="." mode="constructStaticContent"/>
      
      <fo:flow flow-name="xsl-region-body">
        <!-- Process each topic in the page sequence. -->
        <xsl:for-each select="*">
          <xsl:variable name="topicType">
            <xsl:call-template name="determineTopicType"/>
          </xsl:variable>
          <xsl:call-template name="processTopLevelTopic">
            <xsl:with-param name="topicType" select="$topicType" as="xs:string" tunnel="yes"/>
          </xsl:call-template>
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
    match="dita-ot:pageSequence[starts-with(@pubRegion, 'body')][1]">
      <xsl:attribute name="initial-page-number"
        select="1"
      />
  </xsl:template>
  
  <xsl:template mode="constructStaticContent" match="dita-ot:pageSequence[starts-with(@pubRegion, 'frontmatter')]">
      <xsl:call-template name="insertFrontMatterStaticContents"/>    
  </xsl:template>
  
  
  <!-- ==========================================
       Page sequence construction templates
       
       ========================================== -->
  
  <!-- NOTE: the match is redundant but want to make it clear that the default pubRegion is body -->
  <xsl:template mode="constructPageSequence" match="dita-ot:pageSequence[starts-with(@pubRegion, 'body')] | *">
    <xsl:call-template name="doPageSequenceConstruction">
      <xsl:with-param name="pageSequenceMasterName" select="'body-sequence'"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template mode="constructPageSequence" match="dita-ot:pageSequence[@pubRegion = 'appendices']" priority="10">
    <xsl:call-template name="doPageSequenceConstruction">
      <xsl:with-param name="pageSequenceMasterName" select="'body-sequence'"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template mode="constructPageSequence" match="dita-ot:pageSequence[@pubRegion = 'glossary']" priority="10">
    <xsl:call-template name="doPageSequenceConstruction">
      <xsl:with-param name="pageSequenceMasterName" select="'body-sequence'"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template mode="constructNavTreePageSequences" match="*[df:class(., 'topic/topic')]">
    <xsl:apply-templates select="."/><!-- Apply normal mode processing -->
  </xsl:template>
  
  <xsl:template mode="constructNavTreePageSequences" match="*[df:isTopicRef(.)]">
    <!-- Do list generation here -->
  </xsl:template>
  
  
</xsl:stylesheet>
