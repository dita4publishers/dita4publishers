<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  exclude-result-prefixes="xs xd html m"
  version="2.0">
  

  <xsl:output doctype-public="urn:pubid:dita4publishers.sourceforge.net:doctypes:dita:topic" 
    doctype-system="topic.dtd"
  />
  
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="html:html">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="html:body[html:h1]" priority="20">
    <xsl:for-each-group select="*" group-starting-with="html:h1 | html:table">
      <xsl:choose>
        <xsl:when test="self::html:table"/><!-- ignore the group -->
        <xsl:otherwise>
          <xsl:call-template name="handle-h1-group">
            <xsl:with-param name="group" select="current-group()"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template match="html:body[html:h2 and not(html:h1)]" priority="10">
    <xsl:for-each-group select="*" group-starting-with="html:h2">
      <xsl:choose>
        <xsl:when test="self::html:table">
          <!-- Ignore first table -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="handle-h2-group">
            <xsl:with-param name="group" select="current-group()"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template name="handle-h1-group">
    <xsl:param name="group" as="node()*"/>
    <topic id="{generate-id($group[1])}">
      <xsl:apply-templates select="$group[1]"/>
      <xsl:for-each-group select="$group[position() > 1]" group-starting-with="html:h2">
        <xsl:choose>
          <xsl:when test=".[self::html:h2]">
            <xsl:call-template name="handle-h2-group">
              <xsl:with-param name="group" select="current-group()"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <body>
              <xsl:apply-templates select="current-group()"/>
            </body>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </topic>    
  </xsl:template>
  
  <xsl:template name="handle-h2-group">
    <xsl:param name="group" as="node()*"/>
    <xsl:choose>
      <xsl:when test="normalize-space($group[1]) = 'Topics'">
        <!-- Ignore it -->
      </xsl:when>
      <xsl:otherwise>
        <topic id="{generate-id($group[1])}">
          <xsl:apply-templates select="$group[1]"/>
          <body>
            <xsl:apply-templates select="$group[position() > 1]"/>
          </body>
        </topic>    
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="html:h1 | html:h2">
    <title><xsl:apply-templates/></title>
  </xsl:template>
  
  <xsl:template match="html:p">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="html:strong">
    <b><xsl:apply-templates/></b>
  </xsl:template>
  
  <xsl:template match="html:strong[html:img]" priority="10">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="html:em">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="html:br">
    <br/>
  </xsl:template>
  
  <xsl:template match="html:table[.//html:td[@class = 'navbar']]" priority="10">
    <!-- suppress -->
  </xsl:template>
  
  <xsl:template match="html:table[.//html:table]" priority="10">
    <bodydiv outputclass="table">
      <xsl:apply-templates/>
    </bodydiv>
  </xsl:template>
  
  <xsl:template match="html:tr[.//html:table]" priority="10">
    <bodydiv outputclass="tr">
      <xsl:apply-templates/>
    </bodydiv>
  </xsl:template>
  
  <xsl:template match="html:tr[.//html:table]/html:td" priority="10">
    <bodydiv outputclass="td">
      <xsl:apply-templates/>
    </bodydiv>
  </xsl:template>
  
  <xsl:template match="html:table">
    <table>
      <tgroup cols="{count(html:tr[1]/html:td)}">
        <tbody>
          <xsl:apply-templates/>
        </tbody>
      </tgroup>
    </table>
  </xsl:template>
  
  <xsl:template match="html:tr">
    <row>
      <xsl:apply-templates/>
    </row>
  </xsl:template>
  
  <xsl:template match="html:td">
    <entry>
      <xsl:apply-templates/>
    </entry>
  </xsl:template>
  
  <xsl:template match="html:span[starts-with(@class, 'math-inline')]">
    <d4p_eqn_inline><xsl:apply-templates/></d4p_eqn_inline>
  </xsl:template>
  
  <xsl:template match="m:math">
    <d4p_MathML>
      <m:math xmlns:m="http://www.w3.org/1998/Math/MathML">
        <xsl:apply-templates mode="copy-map" select="@*,node()"/>
      </m:math>
    </d4p_MathML>
  </xsl:template>
  
  <xsl:template match="html:div[@class = 'math-block-normal']">
    <d4p_eqn_block>
      <xsl:apply-templates/>
    </d4p_eqn_block>
  </xsl:template>
  
  <xsl:template mode="copy-map" match="*">
    <xsl:element name="m:{name(.)}">
      <xsl:apply-templates mode="#current" select="@*,node()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="copy-map" match="text() | @*">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="html:object">
    <object>
      <xsl:apply-templates select="@*, node()" mode="copy"/>
    </object>
  </xsl:template>
  
  <xsl:template mode="copy" match="*">
    <xsl:element name="{name(.)}">
      <xsl:apply-templates mode="#current" select="@*,node()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="copy" match="text() | @*">
    <xsl:sequence select="."/>
  </xsl:template>
  
  <xsl:template match="html:img">
    <image href="{@src}">
      <xsl:sequence select="@width | @height"/>
      <alt><xsl:value-of select="@alt"/></alt>
    </image>
  </xsl:template>
  
  <xsl:template match="html:a">
    <ph outputclass="a"><xsl:apply-templates/></ph>
  </xsl:template>
  
  <xsl:template match="html:head"
  />
 
  
  <xsl:template match="*" >
    <xsl:message> - [WARN] Unhandled element <xsl:sequence select="concat(name(..), '/', '{', namespace-uri(.), '}',name(.))"/></xsl:message>
  </xsl:template>
  
</xsl:stylesheet>