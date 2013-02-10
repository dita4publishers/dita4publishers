<?xml version="1.0" encoding="UTF-8" ?>
<!-- ===========================================================
     HTML generation templates for the pubmap DITA domain.
     
     Copyright (c) 2009 DITA For Publishers
     
     =========================================================== -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template match="*[contains(@class, ' map/topicref ')][not(@toc='no')][not(@processing-role='resource-only')]">
    <xsl:param name="pathFromMaplist"/>
    <xsl:variable name="titleBase">
      <xsl:call-template name="navtitle"/>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="contains(@class, ' pubmap/chapter ')]">
          <xsl:sequence select="'Chapter '"/><!-- FIXME: This needs come from localized string database -->
          <xsl:number
            count="*[contains(@class, ' pubmap/chapter ')]"
            level="single"
            from="*[contains(@class, ' pubmap/pubbody ')]"
            format="1. "
          />          
        </xsl:when>
      </xsl:choose>
      <xsl:sequence select="$titleBase"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$title and $title!=''">
        <li>
          <xsl:choose>
            <!-- If there is a reference to a DITA or HTML file, and it is not external: -->
            <xsl:when test="@href and not(@href='')">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:choose>        <!-- What if targeting a nested topic? Need to keep the ID? -->
                    <xsl:when test="contains(@copy-to, $DITAEXT) and not(contains(@chunk, 'to-content'))">
                      <xsl:if test="not(@scope='external')"><xsl:value-of select="$pathFromMaplist"/></xsl:if>
                      <xsl:value-of select="substring-before(@copy-to,$DITAEXT)"/><xsl:value-of select="$OUTEXT"/>
                      <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                        <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                      </xsl:if>
                    </xsl:when>
                    <xsl:when test="contains(@href,$DITAEXT)">
                      <xsl:if test="not(@scope='external')"><xsl:value-of select="$pathFromMaplist"/></xsl:if>
                      <xsl:value-of select="substring-before(@href,$DITAEXT)"/><xsl:value-of select="$OUTEXT"/>
                      <xsl:if test="contains(@href, '#')">
                        <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>  <!-- If non-DITA, keep the href as-is -->
                      <xsl:if test="not(@scope='external')"><xsl:value-of select="$pathFromMaplist"/></xsl:if>
                      <xsl:value-of select="@href"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:if test="@scope='external' or @type='external' or ((@format='PDF' or @format='pdf') and not(@scope='local'))">
                  <xsl:attribute name="target">_blank</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$title"/>
              </xsl:element>
            </xsl:when>
            
            <xsl:otherwise>
              <xsl:value-of select="$title"/>
            </xsl:otherwise>
          </xsl:choose>
          
          <!-- If there are any children that should be in the TOC, process them -->
          <xsl:if test="descendant::*[contains(@class, ' map/topicref ')][not(contains(@toc,'no'))][not(@processing-role='resource-only')]">
            <xsl:value-of select="$newline"/><ul><xsl:value-of select="$newline"/>
              <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
                <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
              </xsl:apply-templates>
            </ul><xsl:value-of select="$newline"/>
          </xsl:if>
        </li><xsl:value-of select="$newline"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- if it is an empty topicref -->
        <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
</xsl:stylesheet>
