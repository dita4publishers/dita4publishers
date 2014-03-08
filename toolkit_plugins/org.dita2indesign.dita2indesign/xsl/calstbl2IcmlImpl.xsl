<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:df="http://dita2indesign.org/dita/functions"
      xmlns:ctbl="http//dita2indesign.org/functions/cals-table-to-inx-mapping"
      xmlns:incxgen="http//dita2indesign.org/functions/incx-generation"
      xmlns:e2s="http//dita2indesign.org/functions/element-to-style-mapping"
      exclude-result-prefixes="xs df ctbl incxgen e2s"
      version="2.0">
  
  <!-- CALS table to IDML table 
    
    Generates InDesign IDML tables from DITA CALS tables.
    Implements the "tables" mode.
    
    Copyright (c) 2011 DITA for Publishers
    
  -->
 
 
<!-- 
  Required modules: 
  <xsl:import href="lib/icml_generation_util.xsl"/>
  <xsl:import href="elem2styleMapper.xsl"/>
  -->
  <xsl:template match="*[df:class(.,'topic/table')]" priority="20">
    <xsl:text>&#x0a;</xsl:text>
    <xsl:if test="*[df:class(., 'topic/title')]">
      <xsl:call-template name="makeTableCaption">
        <xsl:with-param name="caption" select="*[df:class(., 'topic/title')]" as="node()*"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates select="*[df:class(., 'topic/tgroup')]"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/tgroup')]">
    <xsl:variable name="colCounts" as="xs:integer*">
      <xsl:apply-templates mode="calcRowEntryCounts" select="*/*[df:class(., 'topic/row')]/*[df:class(., 'topic/entry')]"/>
    </xsl:variable>
    
    <xsl:variable name="numBodyRows"  as="xs:integer"
      select="count(*[df:class(., 'topic/tbody')]/*[df:class(., 'topic/row')])"
    />
    <xsl:variable name="numHeaderRows"  as="xs:integer"
      select="count(*[df:class(., 'topic/thead')]/*[df:class(., 'topic/row')])"
    />
    <xsl:variable name="numCols" select="max($colCounts)" as="xs:integer"/>
    <xsl:variable name="tableID" select="generate-id(.)"/>
    <xsl:variable name="tStyle" select="e2s:getTStyleForElement(.)" as="xs:string"/>
    <xsl:if test="$numCols != count(*[df:class(., 'topic/colspec')])">
      <xsl:message> + [WARN] Table <xsl:value-of select="../*[df:class(., 'topic/title')]"/>:</xsl:message>
      <xsl:message> + [WARN]   Maximum column count (<xsl:value-of select="$numCols"/>) not equal to number of colspec elements (<xsl:value-of select="count(*[df:class(., 'colspec')])"/>).</xsl:message>
    </xsl:if>
     <Table 
      AppliedTableStyle="TableStyle/$ID/{$tStyle}" 
      TableDirection="LeftToRightDirection"
      HeaderRowCount="{$numHeaderRows}" 
      FooterRowCount="0" 
      BodyRowCount="{$numBodyRows}" 
      ColumnCount="{$numCols}" 
      Self="rc_{generate-id()}"><xsl:text>&#x0a;</xsl:text>
      <xsl:apply-templates select="." mode="crow"/>
      <!-- replace this apply templates with function to generate ccol elements.
        This apply-templates generates a ccol for every cell; just need one ccol for each column
        <xsl:apply-templates select="row" mode="ccol"/> -->
      <xsl:sequence 
        select="incxgen:makeColumnElems(
                 *[df:class(., 'topic/colspec')], 
                 $numCols,
                 $tableID)"
      />
      <xsl:apply-templates>
        <xsl:with-param name="colCount" select="$numCols" as="xs:integer" tunnel="yes"/>
        <xsl:with-param name="rowCount" select="$numHeaderRows + $numBodyRows" as="xs:integer" tunnel="yes"/>
      </xsl:apply-templates>
    </Table><xsl:text>&#x0a;</xsl:text>    
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/tgroup')]" mode="crow">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/colspec')]" mode="crow #default">
    <!-- Ignored in this mode -->
  </xsl:template>
  
  <xsl:template 
    match="
    *[df:class(., 'topic/tbody')] |
    *[df:class(., 'topic/thead')]
    " 
    mode="crow #default">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/row')]" mode="crow">
    <!-- In InDesign tables, the header and body rows are indexed together
      -->
    <xsl:variable name="rowIndex"  as="xs:integer"
      select="if (parent::*[df:class(., 'topic/tbody')])
      then count(../../*[df:class(., 'topic/thead')]/*[df:class(., 'topic/row')]) +
           count(preceding-sibling::*[self::row or df:class(., 'topic/row')])
      else count(preceding-sibling::*[self::row or df:class(., 'topic/row')])
      "/>
    <Row 
      Name="{$rowIndex}" 
      SingleRowHeight="1" 
      Self="{generate-id(..)}crow{$rowIndex}"/><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/row')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[df:class(., 'topic/entry')]">
    <xsl:param name="colCount" as="xs:integer" tunnel="yes"/>
    <xsl:param name="rowCount" as="xs:integer" tunnel="yes"/>
    <xsl:param name="articleType" as="xs:string" tunnel="yes"/>
    <xsl:param name="cellStyle" as="xs:string" tunnel="yes" select="'[None]'"/>
    <xsl:param name="colspecElems" as="element()*" tunnel="yes" />
    
    <xsl:variable name="rowNumber" 
      select="if (../parent::*[df:class(., 'topic/tbody')])
      then count(../../../*[df:class(., 'topic/thead')]/*[df:class(., 'topic/row')]) +
           count(../preceding-sibling::*[self::row or df:class(., 'topic/row')])
      else count(../preceding-sibling::*[self::row or df:class(., 'topic/row')])" as="xs:integer"/>
    <xsl:variable name="colNumber" as="xs:integer"><xsl:call-template name="current-cell-position"/></xsl:variable>
    
    <!-- InCopy/IDML cell position indices begin at 0; instead of altering the current-cell-position value, 
         we decrement by 1; also useful for debugging current-cell-position errors -->
    <xsl:variable name="colNumber" select="$colNumber - 1" as="xs:integer"/>
    
    <xsl:variable name="colspan">
      <xsl:choose>
        <xsl:when test="incxgen:isColSpan(.,$colspecElems)">
          <xsl:value-of select="incxgen:numberColsSpanned(.,$colspecElems)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rowspan">
      <xsl:choose>
        <xsl:when test="@morerows">
          <xsl:value-of select="number(@morerows)+1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="colSpan" select="incxgen:makeCSpnAttr($colspan,$colCount)"/>
    <xsl:variable name="rowSpan" select="incxgen:makeRSpnAttr($rowspan,$rowCount)"/>
    <!-- <xsl:message select="concat('[DEBUG: r: ',$colSpan,' c: ',$rowSpan)"/> -->
    <xsl:text> </xsl:text><Cell 
      Name="{$colNumber}:{$rowNumber}" 
      RowSpan="{$rowSpan}" 
      ColumnSpan="{$colSpan}" 
      AppliedCellStyle="CellStyle/$ID/${cellStyle}" 
      ppcs="l_0" 
      Self="rc_{generate-id()}"><xsl:text>&#x0a;</xsl:text>
      <!-- must wrap cell contents in txsr and pcnt -->
      <xsl:variable name="pStyle" as="xs:string">
        <xsl:choose>
          <xsl:when test="ancestor::*[df:class(., 'topic/thead')]">
            <xsl:value-of select="'Columnhead'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'Body Table Cell'"></xsl:value-of>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="cStyle" select="'$ID/[No character style]'" as="xs:string"/>
      <xsl:variable name="pStyleObjId" select="incxgen:getObjectIdForParaStyle($pStyle)" as="xs:string"/>
      <xsl:variable name="cStyleObjId" select="incxgen:getObjectIdForCharacterStyle($cStyle)" as="xs:string"/>
      <xsl:choose>
        <xsl:when test="df:hasBlockChildren(.)">
          <!-- FIXME: handle non-empty text before first block element -->
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="makeBlock-cont">
            <xsl:with-param name="pStyle" tunnel="yes" select="e2s:getPStyleForElement(., $articleType)"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text></Cell><xsl:text>&#x0a;</xsl:text>
  </xsl:template>
  
  <xsl:template name="makeTableCaption">
    <xsl:param name="caption" as="node()*"/>
    <xsl:variable name="pStyle" select="'tableCaption'" as="xs:string"/>
    <xsl:variable name="cStyle" select="'$ID/[No character style]'" as="xs:string"/>
    <xsl:variable name="pStyleEscaped" as="xs:string" select="incxgen:escapeStyleName($pStyle)"/>
    <xsl:variable name="cStyleEscaped" as="xs:string" select="incxgen:escapeStyleName($cStyle)"/>
    
    <ParagraphStyleRange
      AppliedParagraphStyle="ParagraphStyle/{$pStyleEscaped}"><xsl:text>&#x0a;</xsl:text>
      <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/{$cStyleEscaped}" ParagraphBreakType="NextFrame"
        ><xsl:value-of select="$caption"/></CharacterStyleRange><xsl:text>&#x0a;</xsl:text>
    </ParagraphStyleRange><xsl:text>&#x0a;</xsl:text>  
  </xsl:template>
  
  <!-- This mode calculates the entry number for each entry; a later variable 
       in the calling code uses the max function to find the highest numbered 
       entry, which is the total number of columns -->
  <xsl:template mode="calcRowEntryCounts" match="*[df:class(.,'topic/entry')]">
    <xsl:call-template name="current-cell-position"/>
  </xsl:template>
  
  <xsl:template match="text()" mode="calcRowEntryCounts"/>
  
  <xsl:template mode="crow" match="*" priority="-1">
    <xsl:message> + [WARNING] (crow mode): Unhandled element <xsl:sequence select="name(..)"/>/<xsl:sequence 
      select="concat(name(.), ' [', normalize-space(@class), ']')"/></xsl:message>
  </xsl:template>
  
  <!-- The following templates construct a matrix representation of the CALS table, 
       needed for determining the row:col coordinates for a cell, which is used for 
       the <cell>'s @name. It is taken from the h2d plugin and is modified only as necessary. -->
  
  <!-- Determine which column the current entry sits in. Count the current entry,
     plus every entry before it; take spanned rows and columns into account.
     If any entries in this table span rows, we must examine the entire table to
     be sure of the current column. Use mode="find-matrix-column".
     Otherwise, we just need to examine the current row. Use mode="count-cells". -->
  <xsl:template name="current-cell-position" as="xs:integer">
    <xsl:variable name="cellCount">
      <xsl:choose>
        <xsl:when test="parent::*[self::row or df:class(., 'topic/row')]/parent::*[self::thead or df:class(., 'topic/thead')]">
          <xsl:apply-templates select="(ancestor::*[self::tgroup | self::*[df:class(., 'topic/tgroup')]][1]/thead/row/*[1])[1]"
            mode="find-matrix-column">
            <xsl:with-param name="stop-id" select="generate-id(.)"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="ancestor::*[self::table or df:class(., 'topic/table')][1]//*[@morerows][1]">
          <xsl:apply-templates mode="find-matrix-column"
            select="(
            ancestor::*[self::table or df:class(., 'topic/table')][1]/
              *[self::tgroup or df:class(., 'topic/tgroup')]/
              *[self::tbody or df:class(., 'topic/tbody')]/
              *[self::row or df:class(., 'topic/row')]/
              *[1]|ancestor::*[self::table or df:class(., 'topic/table')][1]/
              *[self::row or df:class(., 'topic/row')]/*[1])[1]"
            >
            <xsl:with-param name="stop-id" select="generate-id(.)"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="not(preceding-sibling::*[self::entry or df:class(., 'topic/entry')])">1</xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="(preceding-sibling::*[self::entry or df:class(., 'topic/entry')])[last()]" mode="count-cells"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="if ($cellCount eq '') then 0 else $cellCount"/>
  </xsl:template>
  
  <!-- Count the number of cells in the current row. Move backwards from the test cell. Add one
     for each entry, plus the number of spanned columns. -->
  <xsl:template match="*" mode="count-cells">
    <xsl:param name="current-count" select="1" as="xs:integer"/>
    <xsl:param name="colspecElems" as="element()*" tunnel="yes" />
    <xsl:variable name="new-count">
      <xsl:choose>
        <xsl:when test="incxgen:isColSpan(.,$colspecElems)">
          <xsl:sequence select="$current-count + number(incxgen:numberColsSpanned(.,$colspecElems))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$current-count + 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not(preceding-sibling::*[self::entry or df:class(., 'topic/entry')])">
        <xsl:value-of select="$new-count"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="(preceding-sibling::*[self::entry or df:class(., 'topic/entry')])[last()]" mode="count-cells">
          <xsl:with-param name="current-count" select="$new-count"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Set up a pseudo-matrix to find the column of the current entry. Start with the first entry
     in the first row. Progress to the end of the row, then start the next row; go until we find
     the test cell (with id=$stop-id).
     If an entry spans rows, add the cells that will be covered to $matrix.
     If we get to an entry and its position is already filled in $matrix, then the entry is pushed
     to the side. Add one to the column count and re-try the entry. -->
  <xsl:template match="*" mode="find-matrix-column">
    <xsl:param name="stop-id"/>
    <xsl:param name="matrix" as="xs:string" select="''"/>
    <xsl:param name="row-count" select="1" as="xs:integer"/>
    <xsl:param name="col-count" select="1" as="xs:integer"/>
    <xsl:param name="colspecElems" as="element()*" tunnel="yes" />
    <!-- $current-position has the format [1:3] for row 1, col 3. Use to test if this cell is covered. -->
    <xsl:variable name="current-position" select="concat('[', $row-count, ':', $col-count, ']')"/>
    
    <xsl:choose>
      <!-- If the current value is already covered, increment the column number and try again. -->
      <xsl:when test="contains($matrix,$current-position)">
        <xsl:apply-templates select="." mode="find-matrix-column">
          <xsl:with-param name="stop-id" select="$stop-id"/>
          <xsl:with-param name="matrix" select="$matrix" as="xs:string"/>
          <xsl:with-param name="row-count" select="$row-count" as="xs:integer"/>
          <xsl:with-param name="col-count" select="$col-count + 1" as="xs:integer"/>
        </xsl:apply-templates>
      </xsl:when>
      <!-- If this is the cell we are testing, return the current column number. -->
      <xsl:when test="generate-id(.)=$stop-id">
        <xsl:sequence select="$col-count"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Figure out what the next column value will be. -->
        <xsl:variable name="next-col-count" as="xs:integer">
          <xsl:choose>
            <xsl:when test="not(following-sibling::*[self::entry or df:class(., 'topic/entry')])">1</xsl:when>
            <xsl:when test="incxgen:isColSpan(.,$colspecElems)">
              <xsl:sequence select="$col-count + incxgen:numberColsSpanned(.,$colspecElems) - 1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="$col-count + 1"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- Determine any values that need to be added to the matrix, if this entry spans rows. -->
        <xsl:variable name="new-matrix-values">
          <xsl:if test="@morerows">
            <xsl:variable name="morerows" select="@morerows" as="xs:integer"/>
            <xsl:call-template name="add-to-matrix">
              <xsl:with-param name="start-row" select="$row-count" as="xs:integer"/>
              <xsl:with-param name="end-row" select="$row-count + $morerows"  as="xs:integer"/>
              <xsl:with-param name="start-col" select="$col-count" as="xs:integer"/>
              <xsl:with-param name="end-col" as="xs:integer">
                <xsl:choose>
                  <xsl:when test="incxgen:isColSpan(.,$colspecElems)">
                    <xsl:sequence select="$col-count + incxgen:numberColsSpanned(.,$colspecElems) - 1"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:sequence select="$col-count"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:variable>
        <xsl:choose>
          <!-- If there are more entries in this row, move to the next one. -->
          <xsl:when test="following-sibling::entry">
            <xsl:apply-templates mode="find-matrix-column" 
              select="following-sibling::*[self::entry or df:class(., 'topic/entry')][1]">
              <xsl:with-param name="stop-id" select="$stop-id"/>
              <xsl:with-param name="matrix" select="concat($matrix, $new-matrix-values)" as="xs:string"/>
              <xsl:with-param name="row-count" select="$row-count" as="xs:integer"/>
              <xsl:with-param name="col-count" select="$next-col-count" as="xs:integer"/>
            </xsl:apply-templates>
          </xsl:when>
          <!-- Otherwise, move to the first entry in the next row. -->
          <xsl:otherwise>
            <xsl:apply-templates mode="find-matrix-column" 
              select="../following-sibling::*[self::row or df:class(., 'topic/row')][1]/
              *[self::entry or df:class(., 'topic/entry')][1]">
              <xsl:with-param name="stop-id" select="$stop-id"/>
              <xsl:with-param name="matrix" select="concat($matrix, $new-matrix-values)" as="xs:string"/>
              <xsl:with-param name="row-count" select="$row-count + 1" as="xs:integer"/>
              <xsl:with-param name="col-count" select="1" as="xs:integer"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- This template returns values that must be added to the table matrix. Every cell in the box determined
     by start-row, end-row, start-col, and end-col will be added. First add every value from the first
     column. When past $end-row, move to the next column. When past $end-col, every value is added. -->
  <xsl:template name="add-to-matrix">
    <xsl:param name="start-row" as="xs:integer"/>       
    <xsl:param name="end-row" as="xs:integer"/>
    <xsl:param name="current-row" select="$start-row" as="xs:integer"/>
    <xsl:param name="start-col" as="xs:integer"/>
    <xsl:param name="end-col" as="xs:integer"/>
    <xsl:param name="current-col" select="$start-col" as="xs:integer"/>
    <xsl:choose>
      <xsl:when test="$current-col > $end-col"/>   <!-- Out of the box; every value has been added -->
      <xsl:when test="$current-row > $end-row">    <!-- Finished with this column; move to next -->
        <xsl:call-template name="add-to-matrix">
          <xsl:with-param name="start-row"  select="$start-row" as="xs:integer"/>
          <xsl:with-param name="end-row" select="$end-row" as="xs:integer"/>
          <xsl:with-param name="current-row" select="$start-row" as="xs:integer"/>
          <xsl:with-param name="start-col" select="$start-col" as="xs:integer"/>
          <xsl:with-param name="end-col" select="$end-col" as="xs:integer"/>
          <xsl:with-param name="current-col" select="$current-col + 1" as="xs:integer"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- Output the value for the current entry -->
        <xsl:sequence select="concat('[', $current-row, ':', $current-col, ']')"/>
        <!-- Move to the next row, in the same column. -->
        <xsl:call-template name="add-to-matrix">
          <xsl:with-param name="start-row" select="$start-row" as="xs:integer"/>
          <xsl:with-param name="end-row" select="$end-row" as="xs:integer"/>
          <xsl:with-param name="current-row" select="$current-row + 1" as="xs:integer"/>
          <xsl:with-param name="start-col" select="$start-col" as="xs:integer"/>
          <xsl:with-param name="end-col" select="$end-col" as="xs:integer"/>
          <xsl:with-param name="current-col" select="$current-col" as="xs:integer"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:function name="incxgen:isColSpan" as="xs:boolean">
    <xsl:param name="elem" as="element()"/>
    <xsl:param name="colspecElems" as="element()*"/>
    <xsl:variable name="namest" select="if ($elem/@namest) then $elem/@namest else ''" as="xs:string" />
    <xsl:variable name="nameend" select="if ($elem/@nameend) then $elem/@nameend else ''" as="xs:string" />
    <xsl:variable name="isColSpan" select="
      if ($namest ne '' and $nameend ne '') then
      (if ($namest ne $nameend) then 
      (if ($colspecElems/*[@colname=$namest] and $colspecElems/*[@colname=$nameend]) then true()
      else false())
      else false ())
      else false ()"
      as="xs:boolean" />
    <xsl:sequence select="$isColSpan"/>
  </xsl:function>
  
  <xsl:function name="incxgen:numberColsSpanned" as="xs:integer">
    <xsl:param name="elem" as="element()"/>
    <xsl:param name="colspecElems" as="element()*"/>
    <xsl:variable name="namest" select="if ($elem/@namest) then $elem/@namest else ''" as="xs:string" />
    <xsl:variable name="nameend" select="if ($elem/@nameend) then $elem/@nameend else ''" as="xs:string" />
    <xsl:variable name="numColsBeforeStartColSpan" select="count($colspecElems/*[@colname=$namest]/preceding::*[self::colspec or df:class(.,'topic/colspec')])" as="xs:integer" />
    <xsl:variable name="numColsBeforeEndColSpan" select="count($colspecElems/*[@colname=$nameend]/preceding::*[self::colspec or df:class(.,'topic/colspec')])" as="xs:integer" />
    <xsl:sequence select="$numColsBeforeEndColSpan - $numColsBeforeStartColSpan + 1"/>    
  </xsl:function>
  
  
  
  
</xsl:stylesheet>
