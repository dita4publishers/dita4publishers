<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="xs xd html m xlink"
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
  
  <xsl:template match="html:head">
    
  </xsl:template>
  
  <xsl:template match="html:body[html:h2]">
    <topic>
      <xsl:apply-templates select="html:h2/html:a" mode="make-id-att"/>
      <xsl:apply-templates select="html:h2"/>
      <body>
        <xsl:apply-templates select="* except html:h2"/>
      </body>
    </topic>
  </xsl:template>
  
  <xsl:template match="html:body[html:h1]">
    <topic>
      <xsl:apply-templates select="html:h1/html:a" mode="make-id-att"/>
      <xsl:apply-templates select="html:h1"/>
      <body>
        <xsl:apply-templates select="* except html:h1"/>
      </body>
    </topic>
  </xsl:template>
  
  <xsl:template match="html:body[html:h3]">
    <xsl:for-each-group select="*" group-starting-with="html:h3">
      <xsl:choose>
        <xsl:when test="not(self::html:h3)">
          <!-- Ignore first group -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="handle-h3-group">
            <xsl:with-param name="group" select="current-group()"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template name="handle-h3-group">
    <xsl:param name="group" as="node()*"/>
    <topic id="{generate-id($group[1])}">
      <xsl:apply-templates select="$group[1]"/>
      <xsl:for-each-group select="$group[position() > 1]" group-starting-with="html:h4">
        <xsl:choose>
          <xsl:when test=".[self::html:h4]">
            <xsl:call-template name="handle-h4-group">
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
 
  <xsl:template name="handle-h4-group">
    <xsl:param name="group" as="node()*"/>
    <topic id="{generate-id($group[1])}">
      <xsl:apply-templates select="$group[1]"/>
      <body>
        <xsl:apply-templates select="$group[position() > 1]"/>
      </body>
    </topic>    
  </xsl:template>
  
  
  
  <xsl:template match="html:h1 | html:h2 | html:h3 | html:h4">
    <title><xsl:apply-templates/></title>
  </xsl:template>
  
  <xsl:template match="html:a[string(.) = '']"/>
  
  <xsl:template match="html:a[string(.) != ''][@href]">
    <xref href="{@href}">
      <xsl:if test="starts-with(@href, 'http:')">
        <xsl:attribute name="scope" select="'external'"/>
        <xsl:attribute name="format" select="'html'"/>
      </xsl:if>
      <xsl:apply-templates/></xref>
  </xsl:template>
  
  <xsl:template match="html:a[string(.) != ''][not(@href)]">
    <xsl:apply-templates>
      <xsl:with-param name="id" select="string(@id)" as="xs:string" tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template mode="make-id-att" match="html:a[@id]">
    <xsl:attribute name="id" select="string(@id)"/>
  </xsl:template>
  
  <xsl:template mode="make-outputclass-att" match="@class">
    <xsl:attribute name="outputclass" select="string(.)"/>
  </xsl:template>
  
  <xsl:template match="html:p[normalize-space(.) = '']">
  </xsl:template>
  
  <xsl:template match="html:p[normalize-space(.) != '']">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="text()" mode="make-id-att"/>
  
  <xsl:template match="html:p/m:math[@display = 'inline']" priority="10">
    <d4p_eqn_inline>
      <d4p_MathML>
        <m:math xmlns:m="http://www.w3.org/1998/Math/MathML">
          <xsl:apply-templates mode="copy-math" select="@*,node()"/>
        </m:math>
      </d4p_MathML>
    </d4p_eqn_inline>
  </xsl:template>
  
  <xsl:template match="@xlink:*" mode="copy-math">
    <xsl:processing-instruction name="xlink"><xsl:sequence select="local-name(.)"/>=<xsl:value-of select="."/></xsl:processing-instruction>
  </xsl:template>

  <xsl:template match="m:math[@display = 'inline']">
    <d4p_eqn_block>
      <d4p_MathML>
        <m:math xmlns:m="http://www.w3.org/1998/Math/MathML">
          <xsl:apply-templates mode="copy-math" select="@* except @xlink:*, @xlink:*,node()"/>
        </m:math>
      </d4p_MathML>
    </d4p_eqn_block>
  </xsl:template>
  
  <xsl:template match="m:math[@display = 'block']">
    <d4p_eqn_block>
      <d4p_MathML>
        <m:math xmlns:m="http://www.w3.org/1998/Math/MathML">
          <xsl:apply-templates mode="copy-math" select="@* except @xlink:*, @xlink:*,node()"/>
        </m:math>
      </d4p_MathML>
    </d4p_eqn_block>
  </xsl:template>
  
  <xsl:template mode="copy-math" match="*">
    <xsl:element name="m:{name(.)}">
      <xsl:apply-templates mode="#current" select="@* except @xlink:*, @xlink:*,node()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="copy-math" match="text() | @*">
    <xsl:sequence select="."/>
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
  
  
  
  <xsl:template match="html:span">
    <xsl:param name="id" as="xs:string" select="''"/>
    <ph>
      <xsl:if test="$id != ''">
        <xsl:attribute name="id" select="$id"/>
      </xsl:if>
      <xsl:apply-templates select="@class" mode="make-outputclass-att"/>
      <xsl:apply-templates>
        <xsl:with-param name="id" select="''" tunnel="yes"/>
      </xsl:apply-templates>
    </ph>
  </xsl:template>
  
  <xsl:template match="html:br">
    <br/>
  </xsl:template>
  
  <xsl:template match="
    html:div[@class = 'crosslinks'] |
    html:div[@class = 'likesectionTOCS']
    ">
    <!-- Suppress -->
  </xsl:template>
  
  
  <xsl:template match="*" >
    <xsl:message> - [WARN] Unhandled element <xsl:sequence select="concat(name(..), '/', '{', namespace-uri(.), '}',name(.))"/>: <xsl:sequence select="substring(., 1, 40)"/></xsl:message>
  </xsl:template>
  
</xsl:stylesheet>