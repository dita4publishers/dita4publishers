<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">
 <!-- Attribute sets for controlling page breaks for topics
      and other elements that might reasonably break to new
      pages.
 -->
  
  <xsl:attribute-set name="topic-first-block-topLevel">
    <!-- Break topic to new odd (right-hand) page -->
    <xsl:attribute name="break-before" select="'odd-page'"/>    
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-newPage">
    <!-- Break topic to new page -->
    <xsl:attribute name="break-before" select="'page'"/>    
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-index"
    use-attribute-sets="topic-first-block-topLevel"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-toc"
    use-attribute-sets="topic-first-block-topLevel"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-part"
    use-attribute-sets="topic-first-block-topLevel"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-chapter"
    use-attribute-sets="topic-first-block-topLevel"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-frontmatterTopic"
    use-attribute-sets="topic-first-block-newPage"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-appendixes"
    use-attribute-sets="topic-first-block-topLevel"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-appendix"
    use-attribute-sets="topic-first-block-topLevel"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-glossary"
    use-attribute-sets="topic-first-block-topLevel"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-bibliography"
    use-attribute-sets="topic-first-block-topLevel"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-refentry"
    use-attribute-sets="topic-first-block-newPage"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-task"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-tablelist"
    use-attribute-sets="topic-first-block-newPage"
    >
  </xsl:attribute-set>
  
  <xsl:attribute-set name="topic-first-block-figurelist"
    use-attribute-sets="topic-first-block-newPage"
    >
  </xsl:attribute-set>

  <xsl:attribute-set name="topic-first-block-examplelist"
    use-attribute-sets="topic-first-block-newPage"
    >
  </xsl:attribute-set>
  
</xsl:stylesheet>
