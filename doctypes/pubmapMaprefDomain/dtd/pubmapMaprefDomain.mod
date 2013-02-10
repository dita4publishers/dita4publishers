<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA PubMap Mapref Domain                         -->
<!--  VERSION:   0.9                                               -->
<!--  DATE:      July 2010                                         -->
<!--                                                               -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!-- Topicref types: -->

<!ENTITY % appendix-mapref "appendix-mapref" >
<!ENTITY % appendixes-mapref "appendixes-mapref" >
<!ENTITY % article-mapref "article-mapref" >
<!ENTITY % backmatter-mapref "backmatter-mapref" >
<!ENTITY % chapter-mapref "chapter-mapref" >
<!ENTITY % covers-mapref "covers-mapref" >
<!ENTITY % department-mapref "department-mapref" >
<!ENTITY % forward-mapref "forward-mapref" >
<!ENTITY % frontmatter-mapref "frontmatter-mapref" >
<!ENTITY % glossary-mapref "glossary-mapref" >
<!ENTITY % glossary-group-mapref "glossary-group-mapref" >
<!ENTITY % glossarylist-mapref "glossarylist-mapref" >
<!ENTITY % keydefs-mapref "keydefs-mapref" >
<!ENTITY % keydef-group-mapref "keydef-group-mapref" >
<!ENTITY % part-mapref "part-mapref" >
<!ENTITY % partsection-mapref "partsection-mapref" >
<!ENTITY % pubbody-mapref "pubbody-mapref" >
<!ENTITY % publication-mapref "publication-mapref" >
<!ENTITY % subsection-mapref "subsection-mapref" >
<!ENTITY % sidebar-mapref "sidebar-mapref" >
<!ENTITY % wrap-cover-mapref "wrap-cover-mapref" >


<!-- ============================================================= -->
<!--                    COMMON ATTLIST SETS                        -->
<!-- ============================================================= -->


<!ENTITY % mapref-atts
 'navtitle 
             CDATA 
                       #IMPLIED
  href 
             CDATA 
                       #IMPLIED
              
  keys 
             CDATA 
                       #IMPLIED
  format
             CDATA
                       "ditamap"
  %univ-atts; 
'
 >
 
 <!ENTITY % mapref.cnt
  "((%topicmeta;)?, 
   (%data.elements.incl;)* )
  "
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->




<!ENTITY % frontmatter-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % frontmatter-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT frontmatter-mapref    %frontmatter-mapref.content;>
<!ATTLIST frontmatter-mapref    %frontmatter-mapref.attributes;>


<!ENTITY % keydefs-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % keydefs-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT keydefs-mapref    %keydefs-mapref.content;>
<!ATTLIST keydefs-mapref    %keydefs-mapref.attributes;>


<!ENTITY % keydef-group-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % keydef-group-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT keydef-group-mapref    %keydef-group-mapref.content;>
<!ATTLIST keydef-group-mapref    %keydef-group-mapref.attributes;>


<!ENTITY % backmatter-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % backmatter-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT backmatter-mapref    %backmatter-mapref.content;>
<!ATTLIST backmatter-mapref    %backmatter-mapref.attributes;>



<!ENTITY % forward-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % forward-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT forward-mapref    %forward-mapref.content;>
<!ATTLIST forward-mapref    %forward-mapref.attributes;>

<!ENTITY % publication-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % publication-mapref.attributes
 "%mapref-atts;
 "
>
<!ELEMENT publication-mapref    %publication-mapref.content;>
<!ATTLIST publication-mapref    %publication-mapref.attributes;>


<!ENTITY % pubbody-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % pubbody-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT pubbody-mapref    %pubbody-mapref.content;>
<!ATTLIST pubbody-mapref    %pubbody-mapref.attributes;>


<!ENTITY % chapter-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % chapter-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT chapter-mapref    %chapter-mapref.content;>
<!ATTLIST chapter-mapref    %chapter-mapref.attributes;>

<!ENTITY % article-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % article-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT article-mapref    %article-mapref.content;>
<!ATTLIST article-mapref    %article-mapref.attributes;>

<!ENTITY % subsection-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % subsection-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT subsection-mapref    %subsection-mapref.content;>
<!ATTLIST subsection-mapref    %subsection-mapref.attributes;>

<!ENTITY % sidebar-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % sidebar-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT sidebar-mapref    %sidebar-mapref.content;>
<!ATTLIST sidebar-mapref    %sidebar-mapref.attributes;>


<!ENTITY % covers-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % covers-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT covers-mapref    %covers-mapref.content;>
<!ATTLIST covers-mapref    %covers-mapref.attributes;>

<!ENTITY % wrap-cover-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % wrap-cover-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT wrap-cover-mapref    %wrap-cover-mapref.content;>
<!ATTLIST wrap-cover-mapref    %wrap-cover-mapref.attributes;>

<!ENTITY % part-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % part-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT part-mapref    %part-mapref.content;>
<!ATTLIST part-mapref    %part-mapref.attributes;>

<!ENTITY % partsection-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % partsection-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT partsection-mapref    %partsection-mapref.content;>
<!ATTLIST partsection-mapref    %partsection-mapref.attributes;>


<!ENTITY % department-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % department-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT department-mapref    %department-mapref.content;>
<!ATTLIST department-mapref    %department-mapref.attributes;>



<!ENTITY % appendixes-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % appendixes-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT appendixes-mapref    %appendixes-mapref.content;>
<!ATTLIST appendixes-mapref    %appendixes-mapref.attributes;>

<!ENTITY % appendix-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % appendix-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT appendix-mapref    %appendix-mapref.content;>
<!ATTLIST appendix-mapref    %appendix-mapref.attributes;>


<!ENTITY % bibliolist-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % bibliolist-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT bibliolist-mapref    %bibliolist-mapref.content;>
<!ATTLIST bibliolist-mapref    %bibliolist-mapref.attributes;>



<!ENTITY % glossarylist-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % glossarylist-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT glossarylist-mapref    %glossarylist-mapref.content;>
<!ATTLIST glossarylist-mapref    %glossarylist-mapref.attributes;>

<!ENTITY % glossary-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % glossary-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT glossary-mapref    %glossary-mapref.content;>
<!ATTLIST glossary-mapref    %glossary-mapref.attributes;>


<!ENTITY % glossary-group-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % glossary-group-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT glossary-group-mapref    %glossary-group-mapref.content;>
<!ATTLIST glossary-group-mapref    %glossary-group-mapref.attributes;>

 
<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->
<!-- Topicref types: -->
<!ATTLIST appendix-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/appendix pubmapMapref-d/appendix-mapref ">
<!ATTLIST appendixes-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/appendixes pubmapMapref-d/appendixes-mapref ">
<!ATTLIST article-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/article pubmapMapref-d/article-mapref ">
<!ATTLIST backmatter-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/backmatter pubmapMapref-d/backmatter-mapref ">
<!ATTLIST bibliolist-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/bibliolist pubmapMapref-d/bibliolist-mapref ">
<!ATTLIST chapter-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/chapter pubmapMapref-d/chapter-mapref ">
<!ATTLIST department-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/department pubmapMapref-d/department-mapref ">
<!ATTLIST frontmatter-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/frontmatter pubmapMapref-d/frontmatter-mapref ">
<!ATTLIST glossary-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/glossary pubmapMapref-d/glossary-mapref ">
<!ATTLIST glossary-group-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/glossary pubmapMapref-d/glossary-group-mapref ">
<!ATTLIST keydefs-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/keydefs pubmapMapref-d/keydefs-mapref ">
<!ATTLIST keydef-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/keydef pubmapMapref-d/keydef-mapref ">
<!ATTLIST part-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/part pubmapMapref-d/part-mapref ">
<!ATTLIST partsection-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/partsection pubmapMapref-d/partsection-mapref ">
<!ATTLIST pubbody-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/pubbody pubmapMapref-d/pubbody-mapref ">
<!ATTLIST publication-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/publication pubmapMapref-d/publication-mapref ">
<!ATTLIST sidebar-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/sidebar pubmapMapref-d/sidebar-mapref ">
<!ATTLIST subsection-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/subsection pubmapMapref-d/subsection-mapref ">
<!ATTLIST wrap-cover-mapref %global-atts; class CDATA "+ map/topicref pubmap-d/wrap pubmapMapref-d/wrap-cover-mapref ">



<!-- ================== End pub map mapref domain ============================= -->