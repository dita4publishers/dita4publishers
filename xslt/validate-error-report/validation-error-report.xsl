<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:saxon="http://saxon.sf.net/"
  exclude-result-prefixes="xs saxon"
  version="2.0">
  
  <xsl:param name="lineNumbers" as="xs:string"/>
  <xsl:param name="columnNumbers" as="xs:string"/>


  <xsl:output indent="yes"/>
  <xsl:template match="/">
      
    <xsl:variable name="lineNums" select="tokenize($lineNumbers, ',')" as="xs:string*"/>
    <xsl:variable name="colNums" select="tokenize($columnNumbers, ',')" as="xs:string*"/>
    <xsl:variable name="context" select="." as="node()"/>
    
    <xsl:call-template name="reportLineAndColumns"/>
    
    <validationReport>
      <xsl:for-each select="$lineNumbers">
      <xsl:variable name="lineNum" select="xs:integer(.)" as="xs:integer"/>
      <xsl:variable name="colNum" select="xs:integer($colNums[position()])" as="xs:integer"/>
      <xsl:message> + [DEBUG] line: <xsl:value-of select="$lineNum"/>, col: <xsl:value-of select="$colNum"/></xsl:message>
      <xsl:variable name="errorNode" select="($context//*[saxon:column-number() = $colNum and saxon:line-number() = $lineNum])[1]" as="element()?"/>
      <error>
        <context linenum="{$lineNum}" col="{$colNum}">
          <xsl:sequence select="$errorNode"/>
        </context>
      </error>
    </xsl:for-each>
    </validationReport>
  </xsl:template>
  
  <xsl:template name="reportLineAndColumns">
    <xsl:apply-templates mode="linesNumbers"/>
  </xsl:template>
  
  <xsl:template mode="linesNumbers" match="*">
    <xsl:message> + <xsl:sequence select="name(.)"/>: <xsl:sequence select="concat(saxon:line-number(), ':', saxon:column-number())"></xsl:sequence></xsl:message>
    <xsl:apply-templates mode="#current"/>      
  </xsl:template>
  
  <xsl:template mode="linesNumbers" match="text()"/>
</xsl:stylesheet>
