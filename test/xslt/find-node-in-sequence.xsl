<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="xs xd"
  version="2.0">
  <xsl:output indent="yes"/>
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Apr 22, 2011</xd:p>
      <xd:p><xd:b>Author:</xd:b> ekimber</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:template match="/">
    <result>
      <xsl:variable name="items" select="/*/*[starts-with(name(.), 'item')]" as="element()*"/>
      <message>
+ items=
       <xsl:sequence select="$items"/>        
      </message>
      <xsl:variable name="item3" select="$items[3]"/>
      <xsl:variable name="indexOf3" select="index-of($item3, $items)[1]" as="xs:integer?"/>
      <message>
+ item3=
        <xsl:sequence select="$item3"/>
      </message>
      <xsl:variable name="indexOf3" select="index-of($items, $item3)[1]" as="xs:integer?"/>
      <message>
        + indexOf3="<xsl:sequence select="$indexOf3"/>"
      </message>
      <xsl:variable name="itemBeforeItem3"
        select="$items[$indexOf3 - 1]"
      />
      <message>
+ item before item 3=<xsl:sequence select="$itemBeforeItem3"/>
      </message>
    </result>
  </xsl:template>
</xsl:stylesheet>