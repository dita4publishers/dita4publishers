<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!--  MODULE:    DITA Pubmap  Domain                               -->
<!--  VERSION:   1.2                                               -->
<!--  DATE:      July 2009                                         -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "urn:pubid:dita4publishers.sourceforge.net:modules:dtd:pubmapDomain" 
      Delivered as file "pubmapDomain.mod"                               -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Define elements and specialization attributes     -->
<!--             for use in maps that represent print-focused      -->
<!--             publications.                                     -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!-- Topicref types: -->

<!ENTITY % abbrevlist "abbrevlist" >
<!ENTITY % amendments "amendments" >
<!ENTITY % appendix "appendix" >
<!ENTITY % appendixes "appendixes" >
<!ENTITY % article "article" >
<!ENTITY % back-cover "back-cover" >
<!ENTITY % back-flap "back-flap" >
<!ENTITY % backmatter "backmatter" >
<!ENTITY % bibliolist "bibliolist" >
<!ENTITY % book-jacket "book-jacket" >
<!ENTITY % chapter "chapter" >
<!ENTITY % colophon "colophon" >
<!ENTITY % copyright-page "copyright-page" >
<!ENTITY % covers "covers" >
<!ENTITY % dedication "dedication" >
<!ENTITY % department "department" >
<!ENTITY % draftintro "draftintro" >
<!ENTITY % division  "division" >
<!ENTITY % epub-cover-graphic "epub-cover-graphic" >
<!ENTITY % epub-cover "epub-cover" >
<!ENTITY % figurelist "figurelist" >
<!ENTITY % forward "forward" >
<!ENTITY % front-cover "front-cover" >
<!ENTITY % front-flap "front-flap" >
<!ENTITY % frontmatter "frontmatter" >
<!ENTITY % glossary "glossary" >
<!ENTITY % glossentry "glossentry" >
<!ENTITY % glossary-group "glossary-group" >
<!ENTITY % glossarylist "glossarylist" >
<!ENTITY % indexlist "indexlist" >
<!ENTITY % inside-front-cover "inside-front-cover" >
<!ENTITY % keydefs "keydefs" >
<!ENTITY % keydef-group "keydef-group" >
<!ENTITY % notices "notices" >
<!ENTITY % page "page" >
<!ENTITY % part "part" >
<!ENTITY % partsection "partsection" >
<!ENTITY % preface "preface" >
<!ENTITY % pubabstract "pubabstract" >
<!ENTITY % publist "publist" >
<!ENTITY % publists "publists" >
<!ENTITY % pubbody "pubbody" >
<!ENTITY % publication "publication" >
<!ENTITY % subsection "subsection" >
<!ENTITY % sidebar "sidebar" >
<!ENTITY % spine "spine" >
<!ENTITY % tablelist "tablelist" >
<!ENTITY % toc "toc" >
<!ENTITY % trademarklist "trademarklist" >
<!ENTITY % wrap-cover "wrap-cover" >

<!-- title types: -->

<!ENTITY % pubtitle  "pubtitle" >

<!-- ph types: -->

<!ENTITY % completed "completed" >
<!ENTITY % day "day" >
<!ENTITY % mainpubtitle "mainpubtitle" >
<!ENTITY % subtitle "subtitle" >
<!ENTITY % month "month" >
<!ENTITY % publibrary "publibrary" >
<!ENTITY % pubtitlealt "pubtitlealt" >
<!ENTITY % revisionid "revisionid" >
<!ENTITY % started "started" >
<!ENTITY % summary "summary" >
<!ENTITY % year "year" >

<!-- topicmeta types: -->



<!-- ============================================================= -->
<!--                    COMMON ATTLIST SETS                        -->
<!-- ============================================================= -->

<!-- Currently: same as topicref, sets collection-type to 'sequence' -->

<!ENTITY % pub-topicref-atts 
             "collection-type 
                        (choice | 
                         family | 
                         sequence | 
                         unordered |
                         -dita-use-conref-target) 
                                 'sequence'
              type 
                        CDATA 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              scope 
                        (external | 
                         local | 
                         peer | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              locktitle 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              linking 
                        (none | 
                         normal | 
                         sourceonly | 
                         targetonly |
                         -dita-use-conref-target) 
                                  #IMPLIED
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              print 
                        (no | 
                         printonly | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              search 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              chunk 
                        CDATA 
                                  #IMPLIED
  "
>

<!ENTITY % chapter-atts 
             'navtitle 
                         CDATA 
                                   #IMPLIED
              href 
                         CDATA 
                                   #IMPLIED
              keyref 
                         CDATA 
                                   #IMPLIED
              keys 
                         CDATA 
                                   #IMPLIED
              copy-to 
                         CDATA 
                                   #IMPLIED
              outputclass 
                         CDATA 
                                   #IMPLIED
              %pub-topicref-atts;
              %univ-atts;' 
>


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




<!--                    LONG NAME: Front Matter                    -->
<!ENTITY % frontmatter.content
 "(%article; |
   %chapter; |
   %colophon; | 
   %copyright-page; | 
   %dedication; | 
   %department; |
   %division; |
   %draftintro; | 
   %figurelist; |
   %forward; | 
   %glossary; |
   %glossarylist; |
   %notices; | 
   %page; |
   %pubabstract; | 
   %publist; | 
   %publists; |
   %preface; | 
   %topicref; |
   %subsection; |
   %tablelist; |
   %toc;
   )*"
>
<!ENTITY % frontmatter.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              query 
                        CDATA 
                                  #IMPLIED
              outputclass 
                        CDATA 
                                  #IMPLIED
              %pub-topicref-atts;
              %univ-atts;"
>
<!ELEMENT frontmatter    %frontmatter.content;>
<!ATTLIST frontmatter    %frontmatter.attributes;>



<!--                    LONG NAME: Key Definitions                    -->
<!ENTITY % keydefs.content
 "((%topicmeta;)?,
   ((%keydef;) |
    (%mapref;) |
    (%keydef-group;))*)"
>
<!ENTITY % keydefs.attributes
             "outputclass 
                        CDATA 
                                  #IMPLIED
              processing-role
                   CDATA
                   'resource-only'
              navtitle
                   CDATA
                   #IMPLIED
              collection-type 
                        (choice | 
                         family | 
                         sequence | 
                         unordered |
                         -dita-use-conref-target) 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              scope 
                        (external | 
                         local | 
                         peer | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              locktitle 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              linking 
                        (none | 
                         normal | 
                         sourceonly | 
                         targetonly |
                         -dita-use-conref-target) 
                                  #IMPLIED
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              print 
                        (no | 
                         printonly | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              search 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              chunk 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
"
>
<!ELEMENT keydefs    %keydefs.content;>
<!ATTLIST keydefs    %keydefs.attributes;>

<!--                    LONG NAME: Key Definition Group                    -->
<!ENTITY % keydef-group.content
 "((%topicmeta;)?,
   ((%keydef;) |
    (%keydef-group;))*)"
>
<!ENTITY % keydef-group.attributes
             "outputclass 
                        CDATA 
                                  #IMPLIED
              processing-role
                   CDATA
                   'resource-only'
              navtitle
                   CDATA
                   #IMPLIED
              collection-type 
                        (choice | 
                         family | 
                         sequence | 
                         unordered |
                         -dita-use-conref-target) 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              scope 
                        (external | 
                         local | 
                         peer | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              locktitle 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              linking 
                        (none | 
                         normal | 
                         sourceonly | 
                         targetonly |
                         -dita-use-conref-target) 
                                  #IMPLIED
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              print 
                        (no | 
                         printonly | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              search 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              chunk 
                        CDATA 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT keydef-group    %keydef-group.content;>
<!ATTLIST keydef-group    %keydef-group.attributes;>


<!--                    LONG NAME: Back Matter                     -->
<!ENTITY % backmatter.content
 "(%article; | 
   %amendments; | 
   %chapter; |
   %colophon; | 
   %dedication; | 
   %glossary; | 
   %glossarylist; | 
   %notices; |
   %page; | 
   %publist; | 
   %publists; | 
   %subsection; |
   %topicref;)*"
>
<!ENTITY % backmatter.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              query 
                        CDATA 
                                  #IMPLIED
              outputclass 
                        CDATA 
                                  #IMPLIED
              %pub-topicref-atts;
              %univ-atts;"
>
<!ELEMENT backmatter    %backmatter.content;>
<!ATTLIST backmatter    %backmatter.attributes;>


<!--                    LONG NAME: pub Title                      -->
<!ENTITY % pubtitle.content
                       "((%publibrary;)?,
                         (%mainpubtitle;),
                         (%subtitle;)?,
                         (%pubtitlealt;)*)"
>
<!ENTITY % pubtitle.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT pubtitle    %pubtitle.content;>
<!ATTLIST pubtitle    %pubtitle.attributes;>


<!-- The following three elements are specialized from <ph>. They are
     titles, which have a more limited content model than phrases. The
     content model here matches title.cnt; that entity is not reused
     in case it is expanded in the future to include something not
     allowed in a phrase.                                          -->
<!--                    LONG NAME: Library Title                   -->
<!ENTITY % publibrary.content
                       "(#PCDATA | 
                         %basic.ph.noxref; | 
                         %image;)*"
>
<!ENTITY % publibrary.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT publibrary    %publibrary.content;>
<!ATTLIST publibrary    %publibrary.attributes;>

 
<!--                    LONG NAME: Main pub Title                 -->
<!ENTITY % mainpubtitle.content
                       "(#PCDATA | 
                         %basic.ph.noxref; | 
                         %image;)*"
>
<!ENTITY % mainpubtitle.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT mainpubtitle    %mainpubtitle.content;>
<!ATTLIST mainpubtitle    %mainpubtitle.attributes;>

<!--                    LONG NAME: Subtitle                 -->
<!ENTITY % subtitle.content
                       "(#PCDATA | 
                         %basic.ph.noxref; | 
                         %image;)*"
>
<!ENTITY % subtitle.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT subtitle    %subtitle.content;>
<!ATTLIST subtitle    %subtitle.attributes;>

 
<!--                    LONG NAME: Alternate pub Title            -->
<!ENTITY % pubtitlealt.content
                       "(#PCDATA | 
                         %basic.ph.noxref; | 
                         %image;)*"
>
<!ENTITY % pubtitlealt.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT pubtitlealt    %pubtitlealt.content;>
<!ATTLIST pubtitlealt    %pubtitlealt.attributes;>


<!--                    LONG NAME: Draft Introduction              -->
<!ENTITY % draftintro.content
                       "((%topicmeta;)?, 
                         (%topicref;)*)"
>
<!ENTITY % draftintro.attributes
             "%chapter-atts;"
>
<!ELEMENT draftintro    %draftintro.content;>
<!ATTLIST draftintro    %draftintro.attributes;>


<!--                    LONG NAME: pub Abstract                   -->
<!ENTITY % pubabstract.content
                       "EMPTY"
>
<!ENTITY % pubabstract.attributes
             "%chapter-atts;"
>
<!ELEMENT pubabstract    %pubabstract.content;>
<!ATTLIST pubabstract    %pubabstract.attributes;>


<!--                    LONG NAME: Dedication                      -->
<!ENTITY % dedication.content
                       "(%subsection; |
                         %division;
                        )*"
>
<!ENTITY % dedication.attributes
             "%chapter-atts;"
>
<!ELEMENT dedication    %dedication.content;>
<!ATTLIST dedication    %dedication.attributes;>


<!--                    LONG NAME: Page                      -->
<!ENTITY % page.content
                       "EMPTY"
>
<!ENTITY % page.attributes
             "%chapter-atts;"
>
<!ELEMENT page    %page.content;>
<!ATTLIST page    %page.attributes;>


<!--                    LONG NAME: Forward                         -->
<!ENTITY % forward.content
                       "((%topicmeta;)?, 
                         (%topicref;)*)"
>
<!ENTITY % forward.attributes
             "%chapter-atts;"
>
<!ELEMENT forward    %forward.content;>
<!ATTLIST forward    %forward.attributes;>

<!--                    LONG NAME: Preface                         -->
<!ENTITY % preface.content
                       "((%topicmeta;)?, 
                         (%topicref;)*)"
>
<!ENTITY % preface.attributes
             "%chapter-atts;"
>
<!ELEMENT preface    %preface.content;>
<!ATTLIST preface    %preface.attributes;>
<!--                    LONG NAME: publication                         -->
<!ENTITY % publication.content
                       "((%topicref;)*) 
                        "
>

<!ENTITY % publication.attributes
             '%chapter-atts;' 
>
<!ELEMENT publication    %publication.content;>
<!ATTLIST publication    %publication.attributes;>


<!--                    LONG NAME: pubbody                         -->
<!ENTITY % pubbody.content
                       "((%topicmeta;)?, 
                         ((%appendix;) |
                          (%article;) |
                          (%chapter;) |
                          (%glossary;) |
                          (%part;) |
                          (%page;) |
                          (%topicref;))*)"
>

<!-- Sets collection-type to sequence by default -->
<!ENTITY % pubbody.attributes
             'outputclass 
                         CDATA 
                                   #IMPLIED

             collection-type 
                        (choice | 
                         family | 
                         sequence | 
                         unordered |
                         -dita-use-conref-target) 
                         "sequence"
              type 
                        CDATA 
                                  #IMPLIED
              scope 
                        (external | 
                         local | 
                         peer | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              locktitle 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              linking 
                        (none | 
                         normal | 
                         sourceonly | 
                         targetonly |
                         -dita-use-conref-target) 
                                  #IMPLIED
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              print 
                        (no | 
                         printonly | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              search 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              chunk 
                        CDATA 
                                  #IMPLIED

              %univ-atts;' 
>
<!ELEMENT pubbody    %pubbody.content;>
<!ATTLIST pubbody    %pubbody.attributes;>

<!--                    LONG NAME: Chapter                         -->
<!ENTITY % chapter.content
                       "((%topicmeta;)?, 
                         (%subsection; |
                          %division; |
                          %sidebar; |
                          %page; |
                          %topicref;)*)"
>
<!ENTITY % chapter.attributes
             "%chapter-atts;"
>
<!ELEMENT chapter    %chapter.content;>
<!ATTLIST chapter    %chapter.attributes;>

<!--                    LONG NAME: Article                      -->
<!ENTITY % article.content
                       "%chapter.content;"
>
<!ENTITY % article.attributes
             "%chapter-atts;"
>
<!ELEMENT article    %article.content;>
<!ATTLIST article    %article.attributes;>

<!--                    LONG NAME: Subsection                      -->
<!ENTITY % subsection.content
                       "((%topicmeta;)?, 
                         (%subsection; |
                          %division; |
                          %sidebar; |
                          %page; |
                          %topicref;)*)"
>
<!ENTITY % subsection.attributes
             "%chapter-atts;"
>
<!ELEMENT subsection    %subsection.content;>
<!ATTLIST subsection    %subsection.attributes;>

<!--                    LONG NAME: Sidebar                      -->
<!ENTITY % sidebar.content
                       "((%topicmeta;)?, 
                         (%subsection; |
                          %division; |
                          %page; |
                          topicref)*)"
>
<!ENTITY % sidebar.attributes
             "%chapter-atts;"
>
<!ELEMENT sidebar    %sidebar.content;>
<!ATTLIST sidebar    %sidebar.attributes;>

<!--                    LONG NAME: Covers                      -->
<!ENTITY % covers.content
                       "((%epub-cover-graphic;)*,
                         (%epub-cover;)*,
                         (%front-cover;)*,
                         (%inside-front-cover;)*,
                         (%back-cover;)*,
                         (%book-jacket;)*)"
>                         
<!-- FIXME: should be a topic group -->                         
<!ENTITY % covers.attributes
             "%chapter-atts;"
>
<!ELEMENT covers    %covers.content;>
<!ATTLIST covers    %covers.attributes;>

<!--                    LONG NAME: epub-cover                      -->
<!ENTITY % epub-cover.content
                       "(%topicmeta;)?"            
>
<!ENTITY % epub-cover.attributes
             "%chapter-atts;"
>
<!ELEMENT epub-cover    %epub-cover.content;>
<!ATTLIST epub-cover    %epub-cover.attributes;>

<!--                    LONG NAME: epub-cover-graphic               -->
<!-- Points to a graphic to use for EPUB covers (e.g., for iBooks) -->
<!ENTITY % epub-cover-graphic.content
                       "(%topicmeta;)?"            
>
<!ENTITY % epub-cover-graphic.attributes "
              processing-role
                        (resource-only)
                                   'resource-only'
              scope 
                        (local) 
                                  'local'
              format 
                        (jpg | 
                         png |
                         gif |
                         svg)
                        #REQUIRED                         
              href
                  CDATA
                  #IMPLIED
              keyref
                  CDATA
                  #IMPLIED
              keys
                  NMTOKENS
                  #IMPLIED   
              navtitle
                  CDATA
                    #IMPLIED
              %univ-atts;        

">
<!ELEMENT epub-cover-graphic    %epub-cover-graphic.content;>
<!ATTLIST epub-cover-graphic    %epub-cover-graphic.attributes;>

<!--                    LONG NAME: front-cover                      -->
<!ENTITY % front-cover.content
                       "(%topicmeta;)?"            
>
<!ENTITY % front-cover.attributes
             "%chapter-atts;
              navtitle
                  CDATA
                    #IMPLIED
             "
>
<!ELEMENT front-cover    %front-cover.content;>
<!ATTLIST front-cover    %front-cover.attributes;>

<!--                    LONG NAME: inside front cover                      -->
<!ENTITY % inside-front-cover.content
                       "(%topicmeta;)?"            
>
<!ENTITY % inside-front-cover.attributes
             "%chapter-atts;
              navtitle
                  CDATA
                    #IMPLIED
             "
>
<!ELEMENT inside-front-cover    %inside-front-cover.content;>
<!ATTLIST inside-front-cover    %inside-front-cover.attributes;>

<!--                    LONG NAME: back cover                      -->
<!ENTITY % back-cover.content
                       "(%topicmeta;)?"            
>
<!ENTITY % back-cover.attributes
             "%chapter-atts;
              navtitle
                  CDATA
                    #IMPLIED
             "
>
<!ELEMENT back-cover    %back-cover.content;>
<!ATTLIST back-cover    %back-cover.attributes;>

<!--                    LONG NAME: wrap cover                      -->
<!ENTITY % wrap-cover.content
                       "(%topicmeta;)?"            
>
<!ENTITY % wrap-cover.attributes
             "%chapter-atts;
              navtitle
                  CDATA
                    #IMPLIED
             "
>
<!ELEMENT wrap-cover    %wrap-cover.content;>
<!ATTLIST wrap-cover    %wrap-cover.attributes;>

<!--                    LONG NAME: front flap                      -->
<!ENTITY % front-flap.content
                       "(%topicmeta;)?"            
>
<!ENTITY % front-flap.attributes
             "%chapter-atts;
              navtitle
                  CDATA
                    #IMPLIED
             "
>
<!ELEMENT front-flap    %front-flap.content;>
<!ATTLIST front-flap    %front-flap.attributes;>

<!--                    LONG NAME: back flap                      -->
<!ENTITY % back-flap.content
                       "(%topicmeta;)?"            
>
<!ENTITY % back-flap.attributes
             "%chapter-atts;
              navtitle
                  CDATA
                    #IMPLIED
             "
>
<!ELEMENT back-flap    %back-flap.content;>
<!ATTLIST back-flap    %back-flap.attributes;>

<!--                    LONG NAME: spine                      -->
<!ENTITY % spine.content
                       "(%topicmeta;)?"            
>
<!ENTITY % spine.attributes
             "%chapter-atts;
              navtitle
                  CDATA
                    #IMPLIED
             "
>
<!ELEMENT spine    %spine.content;>
<!ATTLIST spine    %spine.attributes;>

<!--                    LONG NAME: book jacket                      -->
<!ENTITY % book-jacket.content
                       "((%topicmeta;)?,
                         ((%front-flap;)?,
                          (%back-flap;)?,
                          (%spine;)?,
                          ((%wrap-cover;) |
                           ((%front-cover;)?,
                            (%back-cover;)?))?))
                       "            
>
<!ENTITY % book-jacket.attributes
             "%chapter-atts;
              navtitle
                  CDATA
                    #IMPLIED
             "
>
<!ELEMENT book-jacket    %book-jacket.content;>
<!ATTLIST book-jacket    %book-jacket.attributes;>


<!--                    LONG NAME: Part                            -->
<!ENTITY % part.content
                       "((%topicmeta;)?,
                         ((%keydefs;)?,
                          ((%chapter;) | 
                           (%article;) |
                           (%department;) |
                           (%division;) |
                           (%figurelist;) |
                           (%glossarylist;) |
                           (%partsection;) |
                           (%publist;) |
                           (%publists;) |
                           (%page;) |
                           (%tablelist;) |
                           (%toc;) |
                           topicref))* )"
>
<!ENTITY % part.attributes
             "%chapter-atts;"
>
<!ELEMENT part    %part.content;>
<!ATTLIST part    %part.attributes;>

<!ENTITY % partsection.content
                       "((%topicmeta;)?,
                         ((%chapter;) | 
                          (%article;) |
                          (%department;) |
                          (%division;) |
                          (%figurelist;) |
                          (%glossarylist;) |
                          (%partsection;) |
                          (%publist;) |
                          (%publists;) |
                          (%page;) |
                          (%tablelist;) |
                          (%toc;) |
                          topicref)* )"
>
<!ENTITY % partsection.attributes
             "%chapter-atts;"
>
<!ELEMENT partsection    %partsection.content;>
<!ATTLIST partsection    %partsection.attributes;>

<!--                    LONG NAME: Department                            -->
<!ENTITY % department.content
                       "((%topicmeta;)?,
                         ((%chapter;) | 
                          (%article;) |
                          (%department;) |
                          (%division;) |
                          (%subsection;) |
                          (%page;))* )"
>
<!ENTITY % department.attributes
             "%chapter-atts;"
>
<!ELEMENT department    %department.content;>
<!ATTLIST department    %department.attributes;>

<!--                    LONG NAME: Division                            -->
<!ENTITY % division.content
                       "((%topicmeta;)?,
                         ((%chapter;) | 
                          (%article;) |
                          (%department;) |
                          (%division;) |
                          (%subsection;) |
                          (%page;))* )"
>
<!ENTITY % division.attributes
             "%chapter-atts;"
>
<!ELEMENT division    %division.content;>
<!ATTLIST division    %division.attributes;>

<!--                    LONG NAME: Appendixes                        -->
<!ENTITY % appendixes.content
                       "((%topicmeta;)?, 
                         ((%appendix;) |
                          (%chapter;))*)"
>
<!ENTITY % appendixes.attributes
             "%chapter-atts;"
>
<!ELEMENT appendixes    %appendixes.content;>
<!ATTLIST appendixes    %appendixes.attributes;>

<!--                    LONG NAME: Appendix                        -->
<!ENTITY % appendix.content
                       "((%topicmeta;)?, 
                         (%topicref;)*)"
>
<!ENTITY % appendix.attributes
             "%chapter-atts;"
>
<!ELEMENT appendix    %appendix.content;>
<!ATTLIST appendix    %appendix.attributes;>

<!--                    LONG NAME: Notices                         -->
<!ENTITY % notices.content
                       "((%topicmeta;)?, 
                         (%topicref;)*)"
>
<!ENTITY % notices.attributes
             "%chapter-atts;"
>
<!ELEMENT notices    %notices.content;>
<!ATTLIST notices    %notices.attributes;>


<!--                    LONG NAME: Amendments                      -->
<!ENTITY % amendments.content
                       "EMPTY"
>
<!ENTITY % amendments.attributes
             "%chapter-atts;"
>
<!ELEMENT amendments    %amendments.content;>
<!ATTLIST amendments    %amendments.attributes;>


<!--                    LONG NAME: Colophon                        -->
<!ENTITY % colophon.content
                       "EMPTY"
>
<!ENTITY % colophon.attributes
             "%chapter-atts;"
>
<!ELEMENT colophon    %colophon.content;>
<!ATTLIST colophon    %colophon.attributes;>

<!--                    LONG NAME: Copyright page                  -->
<!ENTITY % copyright-page.content
                       "EMPTY"
>
<!ENTITY % copyright-page.attributes
             "%chapter-atts;"
>
<!ELEMENT copyright-page    %copyright-page.content;>
<!ATTLIST copyright-page    %copyright-page.attributes;>


<!--                    LONG NAME: pub Lists                      -->
<!ENTITY % publists.content
                       "((%abbrevlist;) |
                         (%bibliolist;) |
                         (%publist;) |
                         (%figurelist;) |
                         (%glossarylist;) |
                         (%indexlist;) |
                         (%tablelist;) |
                         (%trademarklist;) |
                         (%toc;))*"
>
<!ENTITY % publists.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %topicref-atts;
              %id-atts;
              %select-atts;
              %localization-atts;"
>
<!ELEMENT publists    %publists.content;>
<!ATTLIST publists    %publists.attributes;>


<!--                    LONG NAME: Table of Contents               -->
<!ENTITY % toc.content
  "((%topicmeta;)?)"
>
<!ENTITY % toc.attributes
             "%chapter-atts;"
>
<!ELEMENT toc    %toc.content;>
<!ATTLIST toc    %toc.attributes;>


<!--                    LONG NAME: Figure List                     -->
<!ENTITY % figurelist.content
  "((%topicmeta;)?)"
>
<!ENTITY % figurelist.attributes
             "%chapter-atts;"
>
<!ELEMENT figurelist    %figurelist.content;>
<!ATTLIST figurelist    %figurelist.attributes;>


<!--                    LONG NAME: Table List                      -->
<!ENTITY % tablelist.content
  "((%topicmeta;)?)"
>
<!ENTITY % tablelist.attributes
             "%chapter-atts;"
>
<!ELEMENT tablelist    %tablelist.content;>
<!ATTLIST tablelist    %tablelist.attributes;>


<!--                    LONG NAME: Abbreviation List               -->
<!ENTITY % abbrevlist.content
                       "EMPTY"
>
<!ENTITY % abbrevlist.attributes
             "%chapter-atts;"
>
<!ELEMENT abbrevlist    %abbrevlist.content;>
<!ATTLIST abbrevlist    %abbrevlist.attributes;>


<!--                    LONG NAME: Trademark List                  -->
<!ENTITY % trademarklist.content
                       "EMPTY"
>
<!ENTITY % trademarklist.attributes
             "%chapter-atts;"
>
<!ELEMENT trademarklist    %trademarklist.content;>
<!ATTLIST trademarklist    %trademarklist.attributes;>


<!--                    LONG NAME: Bibliography List               -->
<!ENTITY % bibliolist.content
                       "EMPTY"
>
<!ENTITY % bibliolist.attributes
             "%chapter-atts;"
>
<!ELEMENT bibliolist    %bibliolist.content;>
<!ATTLIST bibliolist    %bibliolist.attributes;>

<!--                    LONG NAME: Glossary List                   -->
<!ENTITY % glossarylist.content
                       "((%topicmeta;)?, 
                         (%topicref;)*)"
>
<!ENTITY % glossarylist.attributes
             "%chapter-atts;"
>
<!ELEMENT glossarylist    %glossarylist.content;>
<!ATTLIST glossarylist    %glossarylist.attributes;>

<!--                    LONG NAME: Glossary                   -->
<!ENTITY % glossary.content
                       "((%topicmeta;)?, 
                         ((%glossary-group;) |
                          (%glossentry;))*)"
>
<!ENTITY % glossary.attributes
             "%chapter-atts;"
>
<!ELEMENT glossary    %glossarylist.content;>
<!ATTLIST glossary    %glossarylist.attributes;>

<!--                    LONG NAME: Glossary Group                  -->
<!ENTITY % glossary-group.content
                       "((%topicmeta;)?, 
                         ((%glossary-group;) |
                          (%glossentry;))*)"
>
<!ENTITY % glossary-group.attributes
             "%chapter-atts;"
>
<!ELEMENT glossary-group    %glossary-group.content;>
<!ATTLIST glossary-group    %glossary-group.attributes;>

<!--                    LONG NAME: Glossary Entry                  -->
<!ENTITY % glossentry.content
                       "((%topicmeta;)?)"
>
<!ENTITY % glossentry.attributes
             "%chapter-atts;"
>
<!ELEMENT glossentry    %glossary-group.content;>
<!ATTLIST glossentry    %glossary-group.attributes;>


<!--                    LONG NAME: Index List                      -->
<!ENTITY % indexlist.content
                       "EMPTY"
>
<!ENTITY % indexlist.attributes
             "%chapter-atts;"
>
<!ELEMENT indexlist    %indexlist.content;>
<!ATTLIST indexlist    %indexlist.attributes;>


<!--                    LONG NAME: pub List                       -->
<!ENTITY % publist.content
  "((%topicmeta;)?)"
>
<!ENTITY % publist.attributes
             "%chapter-atts;"
>
<!ELEMENT publist    %publist.content;>
<!ATTLIST publist    %publist.attributes;>


 
<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->
<!-- Topicref types: -->
<!ATTLIST abbrevlist    %global-atts; class CDATA "+ map/topicref pubmap-d/abbrevlist ">
<!ATTLIST amendments    %global-atts; class CDATA "+ map/topicref pubmap-d/amendments ">
<!ATTLIST appendix      %global-atts; class CDATA "+ map/topicref pubmap-d/appendix ">
<!ATTLIST appendixes    %global-atts; class CDATA "+ map/topicref pubmap-d/appendixes ">
<!ATTLIST article       %global-atts; class CDATA "+ map/topicref pubmap-d/article ">
<!ATTLIST back-cover    %global-atts; class CDATA "+ map/topicref pubmap-d/back-cover ">
<!ATTLIST back-flap     %global-atts; class CDATA "+ map/topicref pubmap-d/back-flap ">
<!ATTLIST backmatter    %global-atts; class CDATA "+ map/topicref pubmap-d/backmatter ">
<!ATTLIST book-jacket   %global-atts; class CDATA "+ map/topicref pubmap-d/book-jacket ">
<!ATTLIST bibliolist    %global-atts; class CDATA "+ map/topicref pubmap-d/bibliolist ">
<!ATTLIST chapter       %global-atts; class CDATA "+ map/topicref pubmap-d/chapter ">
<!ATTLIST colophon      %global-atts; class CDATA "+ map/topicref pubmap-d/colophon ">
<!ATTLIST copyright-page %global-atts; class CDATA "+ map/topicref pubmap-d/copyright-page ">
<!ATTLIST covers        %global-atts; class CDATA "+ map/topicref pubmap-d/covers ">
<!ATTLIST dedication    %global-atts; class CDATA "+ map/topicref pubmap-d/dedication ">
<!ATTLIST department    %global-atts; class CDATA "+ map/topicref pubmap-d/department ">
<!ATTLIST division      %global-atts; class CDATA "+ map/topicref pubmap-d/division ">
<!ATTLIST draftintro    %global-atts; class CDATA "+ map/topicref pubmap-d/draftintro ">
<!ATTLIST epub-cover    %global-atts; class CDATA "+ map/topicref pubmap-d/epub-cover ">
<!ATTLIST epub-cover-graphic    %global-atts; class CDATA "+ map/topicref pubmap-d/epub-cover-graphic ">
<!ATTLIST figurelist    %global-atts; class CDATA "+ map/topicref pubmap-d/figurelist ">
<!ATTLIST forward       %global-atts; class CDATA "+ map/topicref pubmap-d/forward ">
<!ATTLIST front-cover   %global-atts; class CDATA "+ map/topicref pubmap-d/front-cover ">
<!ATTLIST front-flap    %global-atts; class CDATA "+ map/topicref pubmap-d/front-flap ">
<!ATTLIST frontmatter   %global-atts; class CDATA "+ map/topicref pubmap-d/frontmatter ">
<!ATTLIST glossary       %global-atts; class CDATA "+ map/topicref pubmap-d/glossary ">
<!ATTLIST glossentry    %global-atts; class CDATA "+ map/topicref pubmap-d/glossentry ">
<!ATTLIST glossary-group  %global-atts; class CDATA "+ map/topicref pubmap-d/glossary-group ">
<!ATTLIST glossarylist  %global-atts; class CDATA "+ map/topicref pubmap-d/glossarylist ">
<!ATTLIST indexlist     %global-atts; class CDATA "+ map/topicref pubmap-d/indexlist ">
<!ATTLIST inside-front-cover   %global-atts; class CDATA "+ map/topicref pubmap-d/inside-front-cover ">
<!ATTLIST keydefs       %global-atts; class CDATA "+ map/topicref pubmap-d/keydefs ">
<!ATTLIST keydef-group  %global-atts; class CDATA "+ map/topicref pubmap-d/keydef-group ">
<!ATTLIST notices       %global-atts; class CDATA "+ map/topicref pubmap-d/notices ">
<!ATTLIST page          %global-atts; class CDATA "+ map/topicref pubmap-d/page ">
<!ATTLIST part          %global-atts; class CDATA "+ map/topicref pubmap-d/part ">
<!ATTLIST partsection   %global-atts; class CDATA "+ map/topicref pubmap-d/partsection ">
<!ATTLIST preface       %global-atts; class CDATA "+ map/topicref pubmap-d/preface ">
<!ATTLIST pubabstract   %global-atts; class CDATA "+ map/topicref pubmap-d/pubabstract ">
<!ATTLIST publist       %global-atts; class CDATA "+ map/topicref pubmap-d/publist ">
<!ATTLIST publists      %global-atts; class CDATA "+ map/topicref pubmap-d/publists ">
<!ATTLIST pubbody       %global-atts; class CDATA "+ map/topicref pubmap-d/pubbody ">
<!ATTLIST publication   %global-atts; class CDATA "+ map/topicref pubmap-d/publication ">
<!ATTLIST sidebar       %global-atts; class CDATA "+ map/topicref pubmap-d/sidebar ">
<!ATTLIST spine         %global-atts; class CDATA "+ map/topicref pubmap-d/spine ">
<!ATTLIST subsection    %global-atts; class CDATA "+ map/topicref pubmap-d/subsection ">
<!ATTLIST tablelist     %global-atts; class CDATA "+ map/topicref pubmap-d/tablelist ">
<!ATTLIST toc           %global-atts; class CDATA "+ map/topicref pubmap-d/toc ">
<!ATTLIST trademarklist %global-atts; class CDATA "+ map/topicref pubmap-d/trademarklist ">
<!ATTLIST wrap-cover    %global-atts; class CDATA "+ map/topicref pubmap-d/wrap-cover ">

<!-- title types: -->

<!ATTLIST pubtitle      %global-atts; class CDATA "+ topic/title pubmap-d/pubtitle ">

<!-- ph types: -->

<!ATTLIST mainpubtitle %global-atts; class CDATA "+ topic/ph pubmap-d/mainpubtitle ">
<!ATTLIST subtitle     %global-atts; class CDATA "+ topic/ph pubmap-d/subtitle ">
<!ATTLIST pubtitlealt  %global-atts; class CDATA "+ topic/ph pubmap-d/pubtitlealt ">
<!ATTLIST publibrary   %global-atts; class CDATA "+ topic/ph pubmap-d/publibrary ">


<!-- ================== End pub map domain ============================= -->