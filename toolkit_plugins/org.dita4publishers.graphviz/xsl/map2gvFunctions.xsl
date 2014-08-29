<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:gv="http://dita4publishers.sf.net/functions/graphviz"
  exclude-result-prefixes="xs xd"
  version="2.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Apr 22, 2011</xd:p>
      <xd:p><xd:b>Author:</xd:b> ekimber</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:function name="gv:makeProperty" as="xs:string">
    <xsl:param name="propName" as="xs:string"/>
    <xsl:param name="value"/>
    <xsl:sequence 
      select="
      if ($value != '')
         then concat($propName, '=', gv:quoteString(string-join($value, '')), ',')
         else ''"/>
    
  </xsl:function>
  
  <xsl:function name="gv:getNodeId" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:sequence 
      select="gv:quoteString(
      concat('node_', 
             local-name($context), 
             '_', 
             generate-id($context)))"
    /> 
    
  </xsl:function>

  <xsl:function name="gv:quoteString" as="xs:string">
    <xsl:param name="inString" as="xs:string?"/>
    <xsl:variable name="escapedQuote" select='concat("\\", """")' as="xs:string"/>
    <xsl:variable name="result1" as="xs:string"
      select='
      if ($inString) 
         then concat("""", replace($inString, """", $escapedQuote), """") 
         else ""'
    />
    <xsl:variable name="result2" as="xs:string"
      select="replace($result1, '&lt;', '&amp;lt;')"
    />
    <xsl:variable name="result3" as="xs:string"
      select="replace($result2, '&gt;', '&amp;gt;')"
    />
    <xsl:sequence select="normalize-space($result3)"/>
  </xsl:function>
    
  <xsl:function name="gv:makeNodeDecl" as="xs:string*">
    <xsl:param name="nodeId" as="xs:string"/>
    <xsl:param name="label"/>
    <xsl:param name="properties" as="xs:string*"/>
 
 
<xsl:if test="false()">    
  <xsl:message> + [DEBUG] makeNodeDecl(): label="<xsl:sequence select="$label"/>"</xsl:message>
</xsl:if>    
    <!-- properties parameter must be either an empty sequence or
         have an even number of items.
    -->
    <xsl:if test="count($properties) gt 0 and count($properties) mod 2 != 0">
      <xsl:message terminate="yes"> - [ERROR] gv:makeNodeDecl(): Got an odd number of values in the 'properties' parameter.
      The value must be a sequence of name/value pair, e.g., ('color', 'blue', 'label', 'The label')</xsl:message>
    </xsl:if>
    
    <xsl:sequence select="gv:quoteString($nodeId)"/> 
    <xsl:text>[
    </xsl:text>
    <xsl:sequence select="gv:makeProperties(('label', $label, $properties))"/>
    <xsl:text>
      ]
    </xsl:text>
    
  </xsl:function>
  
  <xsl:function name="gv:makeProperties">
    <xsl:param name="properties" as="xs:string*"/>

    <xsl:if test="count($properties) gt 0 and count($properties) mod 2 != 0">
      <xsl:message terminate="yes"> - [ERROR] gv:makeProperties(): Got an odd number of values in the 'properties' parameter.
        The value must be a sequence of name/value pair, e.g., ('color', 'blue', 'label', 'The label')</xsl:message>
    </xsl:if>

    <xsl:for-each select="$properties">
      <xsl:variable name="pos" select="position()" as="xs:integer"/>
      <xsl:if test="position() mod 2 != 0">
        <xsl:sequence 
          select="gv:makeProperty($properties[$pos], 
          $properties[$pos + 1])"/>
        <xsl:text>&#x0a;</xsl:text>
      </xsl:if>
    </xsl:for-each>    
    
  </xsl:function>
  
</xsl:stylesheet>