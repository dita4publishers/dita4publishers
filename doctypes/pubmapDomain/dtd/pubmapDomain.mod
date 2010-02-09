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
PUBLIC "urn:pubid:dita4publishers.sourceforge.net/modules/dtd/pubmapDomain" 
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
<!ENTITY % appendix-mapref "appendix-mapref" >
<!ENTITY % appendixes "appendixes" >
<!ENTITY % appendixes-mapref "appendixes-mapref" >
<!ENTITY % article "article" >
<!ENTITY % article-mapref "article-mapref" >
<!ENTITY % back-cover "back-cover" >
<!ENTITY % back-flap "back-flap" >
<!ENTITY % backmatter "backmatter" >
<!ENTITY % backmatter-mapref "backmatter-mapref" >
<!ENTITY % bibliolist "bibliolist" >
<!ENTITY % bibliolist-mapref "bibliolist-map" >
<!ENTITY % book-jacket "book-jacket" >
<!ENTITY % chapter "chapter" >
<!ENTITY % chapter-mapref "chapter-mapref" >
<!ENTITY % colophon "colophon" >
<!ENTITY % copyright-page "copyright-page" >
<!ENTITY % covers "covers" >
<!ENTITY % covers-mapref "covers-mapref" >
<!ENTITY % dedication "dedication" >
<!ENTITY % department "department" >
<!ENTITY % department-mapref "department-mapref" >
<!ENTITY % draftintro "draftintro" >
<!ENTITY % figurelist "figurelist" >
<!ENTITY % forward "forward" >
<!ENTITY % forward-mapref "forward-mapref" >
<!ENTITY % front-cover "front-cover" >
<!ENTITY % front-flap "front-flap" >
<!ENTITY % frontmatter "frontmatter" >
<!ENTITY % frontmatter-mapref "frontmatter-mapref" >
<!ENTITY % glossary "glossary" >
<!ENTITY % glossary-mapref "glossary-mapref" >
<!ENTITY % glossentry "glossentry" >
<!ENTITY % glossary-group "glossary-group" >
<!ENTITY % glossary-group-mapref "glossary-group-mapref" >
<!ENTITY % glossarylist "glossarylist" >
<!ENTITY % glossarylist-mapref "glossarylist-mapref" >
<!ENTITY % indexlist "indexlist" >
<!ENTITY % keydefs "keydefs" >
<!ENTITY % keydefs-mapref "keydefs-mapref" >
<!ENTITY % keydef-group "keydef-group" >
<!ENTITY % keydef-group-mapref "keydef-group-mapref" >
<!ENTITY % notices "notices" >
<!ENTITY % page "page" >
<!ENTITY % part "part" >
<!ENTITY % part-mapref "part-mapref" >
<!ENTITY % preface "preface" >
<!ENTITY % pubabstract "pubabstract" >
<!ENTITY % publist "publist" >
<!ENTITY % publists "publists" >
<!ENTITY % pubbody "pubbody" >
<!ENTITY % pubbody-mapref "pubbody-mapref" >
<!ENTITY % publication "publication" >
<!ENTITY % publication-mapref "publication-mapref" >
<!ENTITY % subsection "subsection" >
<!ENTITY % subsection-mapref "subsection-mapref" >
<!ENTITY % sidebar "sidebar" >
<!ENTITY % sidebar-mapref "sidebar-mapref" >
<!ENTITY % spine "spine" >
<!ENTITY % tablelist "tablelist" >
<!ENTITY % toc "toc" >
<!ENTITY % trademarklist "trademarklist" >
<!ENTITY % wrap-cover "wrap-cover" >
<!ENTITY % wrap-cover-mapref "wrap-cover-mapref" >

<!-- title types: -->

<!ENTITY %  pubtitle  "pubtitle" >

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

<!ENTITY % pubmeta "pubmeta" >

<!-- publisher types: -->

<!ENTITY % publisherinformation "publisherinformation" >

<!-- data types: -->

<!ENTITY % approved "approved" >
<!ENTITY % copyrfirst "copyrfirst" >
<!ENTITY % copyrlast "copyrlast" >
<!ENTITY % edited "edited" >
<!ENTITY % edition "edition" >
<!ENTITY % doi "doi" >
<!ENTITY % isbn "isbn" >
<!ENTITY % isbn-10 "isbn-10" >
<!ENTITY % isbn-13 "isbn-13" >
<!ENTITY % issn "issn" >
<!ENTITY % issn-13 "issn-13" >
<!ENTITY % issn-10 "issn-10" >
<!ENTITY % issue "issue" >
<!ENTITY % locnumber "locnumber" >
<!ENTITY % maintainer "maintainer" >
<!ENTITY % organization "organization" >
<!ENTITY % person "person" >
<!ENTITY % printlocation "printlocation" >
<!ENTITY % pubchangehistory "pubchangehistory" >
<!ENTITY % pubevent "pubevent" >
<!ENTITY % pubeventtype "pubeventtype" >
<!ENTITY % pubid "pubid" >
<!ENTITY % pubnumber "pubnumber" >
<!ENTITY % pubowner "pubowner" >
<!ENTITY % pubpartno "pubpartno" >
<!ENTITY % pubrestriction "pubrestriction" >
<!ENTITY % publicense "publicense" >
<!ENTITY % pubrights "pubrights" >
<!ENTITY % published "published" >
<!ENTITY % publishtype "publishtype" >
<!ENTITY % reviewed "reviewed" >
<!ENTITY % tested "tested" >
<!ENTITY % volume "volume" >



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



<!--                    LONG NAME: pub Metadata                   -->
<!-- FIXME: extend pubmeta as needed to add e.g., issn, isbn-10, isbn-13 -->
<!ENTITY % pubmeta.content
 "((%linktext;)?, 
   (%searchtitle;)?, 
   (%shortdesc;)?, 
   (%author;)*, 
   (%source;)?, 
   (%publisherinformation;)*,
   (%critdates;)?, 
   (%permissions;)?, 
   (%metadata;)*, 
   (%audience;)*, 
   (%category;)*, 
   (%keywords;)*, 
   (%prodinfo;)*, 
   (%othermeta;)*, 
   (%resourceid;)*, 
   (%pubid;)?,
   (%pubchangehistory;)*,
   (%pubrights;)*,
   (%data;)*)"
>
<!ENTITY % pubmeta.attributes
             "lockmeta 
                        (no | 
                         yes | 
                         -dita-use-conref-target)
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT pubmeta    %pubmeta.content;>
<!ATTLIST pubmeta    %pubmeta.attributes;>


<!--                    LONG NAME: Front Matter                    -->
<!ENTITY % frontmatter.content
 "(%article; |
   %chapter; |
   %colophon; | 
   %copyright-page; | 
   %dedication; | 
   %department; |
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

<!ENTITY % frontmatter-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % frontmatter-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT frontmatter-mapref    %frontmatter-mapref.content;>
<!ATTLIST frontmatter-mapref    %frontmatter-mapref.attributes;>


<!--                    LONG NAME: Key Definitions                    -->
<!ENTITY % keydefs.content
 "((%topicmeta;)?,
   ((%keydef;) |
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
               %topicref-atts;
              %univ-atts;"
>
<!ELEMENT keydefs    %keydefs.content;>
<!ATTLIST keydefs    %keydefs.attributes;>

<!ENTITY % keydefs-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % keydefs-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT keydefs-mapref    %keydefs-mapref.content;>
<!ATTLIST keydefs-mapref    %keydefs-mapref.attributes;>

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
              %topicref-atts;
              %univ-atts;"
>
<!ELEMENT keydef-group    %keydef-group.content;>
<!ATTLIST keydef-group    %keydef-group.attributes;>

<!ENTITY % keydef-group-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % keydef-group-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT keydef-group-mapref    %keydef-group-mapref.content;>
<!ATTLIST keydef-group-mapref    %keydef-group-mapref.attributes;>

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

<!ENTITY % backmatter-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % backmatter-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT backmatter-mapref    %backmatter-mapref.content;>
<!ATTLIST backmatter-mapref    %backmatter-mapref.attributes;>

<!--                    LONG NAME: Publisher Information           -->
<!ENTITY % publisherinformation.content
                       "(((%person;) | 
                          (%organization;))*, 
                         (%printlocation;)*, 
                         (%published;)*, 
                         (%data;)*)"
>
<!ENTITY % publisherinformation.attributes
             "href 
                        CDATA 
                                  #IMPLIED
              format 
                        CDATA 
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
              keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT publisherinformation    %publisherinformation.content;>
<!ATTLIST publisherinformation    %publisherinformation.attributes;>


<!--                    LONG NAME: Person                          -->
<!ENTITY % person.content
                       "(%words.cnt;)*"
>
<!ENTITY % person.attributes
             "%data-element-atts;"
>
<!ELEMENT person    %person.content;>
<!ATTLIST person    %person.attributes;>


<!--                    LONG NAME: Organization                    -->
<!ENTITY % organization.content
                       "(%words.cnt;)*"
>
<!ENTITY % organization.attributes
             "%data-element-atts;"
>
<!ELEMENT organization    %organization.content;>
<!ATTLIST organization    %organization.attributes;>


<!--                    LONG NAME: pub Change History             -->
<!ENTITY % pubchangehistory.content
                       "((%reviewed;)*, 
                         (%edited;)*, 
                         (%tested;)*, 
                         (%approved;)*, 
                         (%pubevent;)*)"
>
<!ENTITY % pubchangehistory.attributes
             "%data-element-atts;"
>
<!ELEMENT pubchangehistory    %pubchangehistory.content;>
<!ATTLIST pubchangehistory    %pubchangehistory.attributes;>


<!--                    LONG NAME: pub ID                         -->
<!ENTITY % pubid.content
                       "((%pubpartno;)*, 
                         (%edition;)?, 
                         (%doi;)*, 
                         (%isbn;)*, 
                         (%isbn-10;)*, 
                         (%isbn-13;)*, 
                         (%issn;)*, 
                         (%issn-10;)*, 
                         (%issn-13;)*, 
                         (%pubnumber;)*, 
                         (%locnumber;)*, 
                         (%issue;)*, 
                         (%volume;)*, 
                         (%maintainer;)?)"
>
<!ENTITY % pubid.attributes
             "%data-element-atts;"
>
<!ELEMENT pubid    %pubid.content;>
<!ATTLIST pubid    %pubid.attributes;>


<!--                    LONG NAME: Summary                         -->
<!ENTITY % summary.content
                       "(%words.cnt;)*"
>
<!ENTITY % summary.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT summary    %summary.content;>
<!ATTLIST summary    %summary.attributes;>


<!--                    LONG NAME: Print Location                  -->
<!ENTITY % printlocation.content
                       "(%words.cnt;)*"
>
<!ENTITY % printlocation.attributes
             "%data-element-atts;"
>
<!ELEMENT printlocation    %printlocation.content;>
<!ATTLIST printlocation    %printlocation.attributes;>


<!--                    LONG NAME: Published                       -->
<!ENTITY % published.content
                       "(((%person;) | 
                          (%organization;))*,
                         (%publishtype;)?, 
                         (%revisionid;)?,
                         (%started;)?, 
                         (%completed;)?, 
                         (%summary;)?, 
                         (%data;)*)"
>
<!ENTITY % published.attributes
             "%data-element-atts;"
>
<!ELEMENT published    %published.content;>
<!ATTLIST published    %published.attributes;>

<!--                    LONG NAME: Publish Type                    -->
<!ENTITY % publishtype.content
                       "EMPTY"
>
<!-- 20080128: Removed enumeration for @value for DITA 1.2. Previous values:
               beta, general, limited, -dita-use-conref-target
               Matches data-element-atts, but value is required           -->
<!ENTITY % publishtype.attributes
             "%univ-atts;
              name 
                        CDATA 
                                  #IMPLIED
              datatype 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              format 
                        CDATA 
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
              outputclass
                        CDATA 
                                  #IMPLIED
              value 
                        CDATA 
                                  #REQUIRED"
>
<!ELEMENT publishtype    %publishtype.content;>
<!ATTLIST publishtype    %publishtype.attributes;>
 
<!--                    LONG NAME: Revision ID                     -->
<!ENTITY % revisionid.content
                       "(#PCDATA |
                         %keyword;)*
">
<!ENTITY % revisionid.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT revisionid    %revisionid.content;>
<!ATTLIST revisionid    %revisionid.attributes;>

 
<!--                    LONG NAME: Start Date                      -->
<!ENTITY % started.content
                       "(((%year;), 
                          ((%month;), 
                           (%day;)?)?) | 
                         ((%month;), 
                          (%day;)?, 
                          (%year;)) | 
                         ((%day;), 
                          (%month;), 
                          (%year;)))"
>
<!ENTITY % started.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT started    %started.content;>
<!ATTLIST started    %started.attributes;>

 
<!--                    LONG NAME: Completion Date                 -->
<!ENTITY % completed.content
                       "(((%year;), 
                          ((%month;), 
                           (%day;)?)?) | 
                         ((%month;), 
                          (%day;)?, 
                          (%year;)) | 
                         ((%day;), 
                          (%month;), 
                          (%year;)))"
>
<!ENTITY % completed.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT completed    %completed.content;>
<!ATTLIST completed    %completed.attributes;>

 
<!--                    LONG NAME: Year                            -->
<!ENTITY % year.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % year.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT year    %year.content;>
<!ATTLIST year    %year.attributes;>

 
<!--                    LONG NAME: Month                           -->
<!ENTITY % month.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % month.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT month    %month.content;>
<!ATTLIST month    %month.attributes;>

 
<!--                    LONG NAME: Day                             -->
<!ENTITY % day.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % day.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT day    %day.content;>
<!ATTLIST day    %day.attributes;>

 
<!--                    LONG NAME: Reviewed                        -->
<!ENTITY % reviewed.content
                       "(((%organization;) | 
                          (%person;))*, 
                         (%revisionid;)?, 
                         (%started;)?, 
                         (%completed;)?, 
                         (%summary;)?, 
                         (%data;)*)"
>
<!ENTITY % reviewed.attributes
             "%data-element-atts;"
>
<!ELEMENT reviewed    %reviewed.content;>
<!ATTLIST reviewed    %reviewed.attributes;>


<!--                    LONG NAME: Editeded                        -->
<!ENTITY % edited.content
                       "(((%organization;) | 
                          (%person;))*, 
                          (%revisionid;)?, 
                          (%started;)?, 
                          (%completed;)?, 
                          (%summary;)?, 
                          (%data;)*)"
>
<!ENTITY % edited.attributes
             "%data-element-atts;"
>
<!ELEMENT edited    %edited.content;>
<!ATTLIST edited    %edited.attributes;>


<!--                    LONG NAME: Tested                          -->
<!ENTITY % tested.content
                       "(((%organization;) | 
                          (%person;))*, 
                          (%revisionid;)?, 
                          (%started;)?, 
                          (%completed;)?, 
                          (%summary;)?, 
                          (%data;)*)"
>
<!ENTITY % tested.attributes
             "%data-element-atts;"
>
<!ELEMENT tested    %tested.content;>
<!ATTLIST tested    %tested.attributes;>


<!--                    LONG NAME: Approved                        -->
<!ENTITY % approved.content
                       "(((%organization;) | 
                          (%person;))*, 
                          (%revisionid;)?, 
                          (%started;)?, 
                          (%completed;)?, 
                          (%summary;)?, 
                          (%data;)*)"
>
<!ENTITY % approved.attributes
             "%data-element-atts;"
>
<!ELEMENT approved    %approved.content;>
<!ATTLIST approved    %approved.attributes;>


<!--                    LONG NAME: pub Event                      -->
<!ENTITY % pubevent.content
                       "((%pubeventtype;)?, 
                         (((%organization;) | 
                           (%person;))*, 
                          (%revisionid;)?, 
                          (%started;)?, 
                          (%completed;)?, 
                          (%summary;)?, 
                          (%data;)*))"
>
<!ENTITY % pubevent.attributes
             "%data-element-atts;"
>
<!ELEMENT pubevent    %pubevent.content;>
<!ATTLIST pubevent    %pubevent.attributes;>

<!--                    LONG NAME: pub Event Type                 -->
<!ENTITY % pubeventtype.content
                       "EMPTY"
>
<!-- Attributes are the same as data-element-atts except that 
     @name is required                                             -->
<!ENTITY % pubeventtype.attributes
             "name 
                        CDATA 
                                  #REQUIRED 
              datatype 
                        CDATA 
                                  #IMPLIED
              value 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              format 
                        CDATA 
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
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT pubeventtype    %pubeventtype.content;>
<!ATTLIST pubeventtype    %pubeventtype.attributes;>

<!--                    LONG NAME: pub Part Number                -->
<!ENTITY % pubpartno.content
                       "(%words.cnt;)*"
>
<!ENTITY % pubpartno.attributes
             "%data-element-atts;"
>
<!ELEMENT pubpartno    %pubpartno.content;>
<!ATTLIST pubpartno    %pubpartno.attributes;>


<!--                    LONG NAME: Edition                         -->
<!ENTITY % edition.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % edition.attributes
             "%data-element-atts;"
>
<!ELEMENT edition    %edition.content;>
<!ATTLIST edition    %edition.attributes;>


<!--                    LONG NAME: Digital object identifier          -->
<!ENTITY % doi.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % doi.attributes
             "%data-element-atts;"
>
<!ELEMENT doi    %doi.content;>
<!ATTLIST doi    %doi.attributes;>

<!ENTITY % isbn.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % isbn.attributes
             "%data-element-atts;"
>
<!ELEMENT isbn    %isbn.content;>
<!ATTLIST isbn    %isbn.attributes;>

<!--                    LONG NAME: ISBN 10 Number                     -->
<!ENTITY % isbn-10.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % isbn-10.attributes
             "%data-element-atts;"
>
<!ELEMENT isbn-10    %isbn-10.content;>
<!ATTLIST isbn-10    %isbn-10.attributes;>

<!--                    LONG NAME: ISBN 13 Number                     -->
<!ENTITY % isbn-13.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % isbn-13.attributes
             "%data-element-atts;"
>
<!ELEMENT isbn-13    %isbn-13.content;>
<!ATTLIST isbn-13    %isbn-13.attributes;>

<!--                    LONG NAME: ISSN Number                     -->
<!ENTITY % issn.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % issn.attributes
             "%data-element-atts;"
>
<!ELEMENT issn    %isbn.content;>
<!ATTLIST issn    %isbn.attributes;>

<!--                    LONG NAME: ISBN 10 Number                     -->
<!ENTITY % issn-10.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % issn-10.attributes
             "%data-element-atts;"
>
<!ELEMENT issn-10    %issn-10.content;>
<!ATTLIST issn-10    %issn-10.attributes;>

<!--                    LONG NAME: ISSN 13 Number                     -->
<!ENTITY % issn-13.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % issn-13.attributes
             "%data-element-atts;"
>
<!ELEMENT issn-13    %issn-13.content;>
<!ATTLIST issn-13    %issn-13.attributes;>

<!--                    LONG NAME: ISSN Number                     -->
<!ENTITY % issue.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % issue.attributes
             "%data-element-atts;"
>
<!ELEMENT issue    %issue.content;>
<!ATTLIST issue    %issue.attributes;>


<!--                    LONG NAME: pub Number                     -->
<!ENTITY % pubnumber.content
                       "(%words.cnt;)*"
>
<!ENTITY % pubnumber.attributes
             "%data-element-atts;"
>
<!ELEMENT pubnumber    %pubnumber.content;>
<!ATTLIST pubnumber    %pubnumber.attributes;>

<!--                    LONG NAME: Library of Congress Number                     -->
<!ENTITY % locnumber.content
                       "(%words.cnt;)*"
>
<!ENTITY % locnumber.attributes
             "%data-element-atts;"
>
<!ELEMENT locnumber    %locnumber.content;>
<!ATTLIST locnumber    %locnumber.attributes;>

<!--                    LONG NAME: Volume                          -->
<!ENTITY % volume.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % volume.attributes
             "%data-element-atts;"
>
<!ELEMENT volume    %volume.content;>
<!ATTLIST volume    %volume.attributes;>


<!--                    LONG NAME: Maintainer                      -->
<!ENTITY % maintainer.content
                       "(((%person;) | 
                          (%organization;))*, 
                         (%data;)*)
">
<!ENTITY % maintainer.attributes
             "%data-element-atts;"
>
<!ELEMENT maintainer    %maintainer.content;>
<!ATTLIST maintainer    %maintainer.attributes;>


<!--                    LONG NAME: pub Rights                     -->
<!ENTITY % pubrights.content
                       "((%copyrfirst;)?, 
                         (%copyrlast;)?,
                         (%pubowner;)?, 
                         (%pubrestriction;)?,
                         (%publicense;)?,
                         (%summary;)?,
                         (%data; |
                          %data-about;)*)"
>
<!ENTITY % pubrights.attributes
             "%data-element-atts;"
>
<!ELEMENT pubrights    %pubrights.content;>
<!ATTLIST pubrights    %pubrights.attributes;>


<!-- LONG NAME: Publication License -->
<!-- Intended to hold license statements for
     documents that are in the public domain
     or otherwise not owned or not under a traditional
     copyright.
  -->
<!ENTITY % publicense.content
  "(%data.cnt;)*"
>
<!ENTITY % publicense.attributes
             "%data-element-atts;"
>
<!ELEMENT publicense    %publicense.content;>
<!ATTLIST publicense    %publicense.attributes;>

<!--                    LONG NAME: First Copyright                 -->
<!ENTITY % copyrfirst.content
                       "(%year;)"
>
<!ENTITY % copyrfirst.attributes
             "%data-element-atts;"
>
<!ELEMENT copyrfirst    %copyrfirst.content;>
<!ATTLIST copyrfirst    %copyrfirst.attributes;>

 
<!--                    LONG NAME: Last Copyright                  -->
<!ENTITY % copyrlast.content
                       "(%year;)"
>
<!ENTITY % copyrlast.attributes
             "%data-element-atts;"
>
<!ELEMENT copyrlast    %copyrlast.content;>
<!ATTLIST copyrlast    %copyrlast.attributes;>


<!--                    LONG NAME: pub Owner                      -->
<!ENTITY % pubowner.content
                       "((%organization;) | 
                         (%person;))* 
 ">
<!ENTITY % pubowner.attributes
             "%data-element-atts;"
>
<!ELEMENT pubowner    %pubowner.content;>
<!ATTLIST pubowner    %pubowner.attributes;>

<!--                    LONG NAME: pub Restriction                -->
<!ENTITY % pubrestriction.content
                       "EMPTY"
>
<!-- Same attributes as data-element-atts, except for @value -->
<!-- 20080128: Removed enumeration for @value for DITA 1.2. Previous values:
               confidential, licensed, restricted, 
               unclassified, -dita-use-conref-target               -->
<!ENTITY % pubrestriction.attributes
             "%univ-atts;
              name 
                        CDATA 
                                  #IMPLIED
              datatype 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              format 
                        CDATA 
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
              outputclass
                        CDATA 
                                  #IMPLIED
              value 
                        CDATA 
                                  #REQUIRED"
>
<!ELEMENT pubrestriction    %pubrestriction.content;>
<!ATTLIST pubrestriction    %pubrestriction.attributes;>

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
                       "(%subsection;)*"
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

<!ENTITY % forward-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % forward-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT forward-mapref    %forward-mapref.content;>
<!ATTLIST forward-mapref    %forward-mapref.attributes;>



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


<!ENTITY % publication-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % publication-mapref.attributes
 "%mapref-atts;
 "
>
<!ELEMENT publication-mapref    %publication-mapref.content;>
<!ATTLIST publication-mapref    %publication-mapref.attributes;>

<!--                    LONG NAME: pubbody                         -->
<!ENTITY % pubbody.content
                       "((%topicmeta;)?, 
                         ((%appendix;) |
                          (%appendix-mapref;) |
                          (%article;) |
                          (%article-mapref;) |
                          (%chapter;) |
                          (%chapter-mapref;) |
                          (%glossary;) |
                          (%glossary-mapref;) |
                          (%part;) |
                          (%part-mapref;) |
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

<!ENTITY % pubbody-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % pubbody-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT pubbody-mapref    %pubbody-mapref.content;>
<!ATTLIST pubbody-mapref    %pubbody-mapref.attributes;>

<!--                    LONG NAME: Chapter                         -->
<!ENTITY % chapter.content
                       "((%topicmeta;)?, 
                         (%subsection; |
                          %sidebar; |
                          %page; |
                          %topicref;)*)"
>
<!ENTITY % chapter.attributes
             "%chapter-atts;"
>
<!ELEMENT chapter    %chapter.content;>
<!ATTLIST chapter    %chapter.attributes;>

<!ENTITY % chapter-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % chapter-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT chapter-mapref    %chapter-mapref.content;>
<!ATTLIST chapter-mapref    %chapter-mapref.attributes;>



<!--                    LONG NAME: Article                      -->
<!ENTITY % article.content
                       "%chapter.content;"
>
<!ENTITY % article.attributes
             "%chapter-atts;"
>
<!ELEMENT article    %article.content;>
<!ATTLIST article    %article.attributes;>

<!ENTITY % article-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % article-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT article-mapref    %article-mapref.content;>
<!ATTLIST article-mapref    %article-mapref.attributes;>

<!--                    LONG NAME: Subsection                      -->
<!ENTITY % subsection.content
                       "((%topicmeta;)?, 
                         (%subsection; |
                          %sidebar; |
                          %page; |
                          %topicref;)*)"
>
<!ENTITY % subsection.attributes
             "%chapter-atts;"
>
<!ELEMENT subsection    %subsection.content;>
<!ATTLIST subsection    %subsection.attributes;>

<!ENTITY % subsection-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % subsection-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT subsection-mapref    %subsection-mapref.content;>
<!ATTLIST subsection-mapref    %subsection-mapref.attributes;>

<!--                    LONG NAME: Sidebar                      -->
<!ENTITY % sidebar.content
                       "((%topicmeta;)?, 
                         (%subsection; |
                          %page; |
                          topicref)*)"
>
<!ENTITY % sidebar.attributes
             "%chapter-atts;"
>
<!ELEMENT sidebar    %sidebar.content;>
<!ATTLIST sidebar    %sidebar.attributes;>

<!ENTITY % sidebar-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % sidebar-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT sidebar-mapref    %sidebar-mapref.content;>
<!ATTLIST sidebar-mapref    %sidebar-mapref.attributes;>


<!--                    LONG NAME: Covers                      -->
<!ENTITY % covers.content
                       "(front-cover?,
                         inside-front-cover?,
                         back-cover?,
                         book-jacket?)"
>                         
<!-- FIXME: should be a topic group -->                         
<!ENTITY % covers.attributes
             "%chapter-atts;"
>
<!ELEMENT covers    %covers.content;>
<!ATTLIST covers    %covers.attributes;>

<!ENTITY % covers-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % covers-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT covers-mapref    %covers-mapref.content;>
<!ATTLIST covers-mapref    %covers-mapref.attributes;>

<!--                    LONG NAME: front-cover                      -->
<!ENTITY % front-cover.content
                       "(%topicmeta;)?"            
>
<!ENTITY % front-cover.attributes
             "%chapter-atts;"
>
<!ELEMENT front-cover    %front-cover.content;>
<!ATTLIST front-cover    %front-cover.attributes;>

<!--                    LONG NAME: inside front cover                      -->
<!ENTITY % inside-front-cover.content
                       "(%topicmeta;)?"            
>
<!ENTITY % inside-front-cover.attributes
             "%chapter-atts;"
>
<!ELEMENT inside-front-cover    %inside-front-cover.content;>
<!ATTLIST inside-front-cover    %inside-front-cover.attributes;>

<!--                    LONG NAME: back cover                      -->
<!ENTITY % back-cover.content
                       "(%topicmeta;)?"            
>
<!ENTITY % back-cover.attributes
             "%chapter-atts;"
>
<!ELEMENT back-cover    %back-cover.content;>
<!ATTLIST back-cover    %back-cover.attributes;>

<!--                    LONG NAME: wrap cover                      -->
<!ENTITY % wrap-cover.content
                       "(%topicmeta;)?"            
>
<!ENTITY % wrap-cover.attributes
             "%chapter-atts;"
>
<!ELEMENT wrap-cover    %wrap-cover.content;>
<!ATTLIST wrap-cover    %wrap-cover.attributes;>

<!ENTITY % wrap-cover-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % wrap-cover-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT wrap-cover-mapref    %wrap-cover-mapref.content;>
<!ATTLIST wrap-cover-mapref    %wrap-cover-mapref.attributes;>

<!--                    LONG NAME: front flap                      -->
<!ENTITY % front-flap.content
                       "(%topicmeta;)?"            
>
<!ENTITY % front-flap.attributes
             "%chapter-atts;"
>
<!ELEMENT front-flap    %front-flap.content;>
<!ATTLIST front-flap    %front-flap.attributes;>

<!--                    LONG NAME: back flap                      -->
<!ENTITY % back-flap.content
                       "(%topicmeta;)?"            
>
<!ENTITY % back-flap.attributes
             "%chapter-atts;"
>
<!ELEMENT back-flap    %back-flap.content;>
<!ATTLIST back-flap    %back-flap.attributes;>

<!--                    LONG NAME: spine                      -->
<!ENTITY % spine.content
                       "(%topicmeta;)?"            
>
<!ENTITY % spine.attributes
             "%chapter-atts;"
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
             "%chapter-atts;"
>
<!ELEMENT book-jacket    %book-jacket.content;>
<!ATTLIST book-jacket    %book-jacket.attributes;>


<!--                    LONG NAME: Part                            -->
<!ENTITY % part.content
                       "((%topicmeta;)?,
                         ((%chapter;) | 
                          (%article;) |
                          (%department;) |
                          (%figurelist;) |
                          (%glossarylist;) |
                          (%publist;) |
                          (%publists;) |
                          (%page;) |
                          (%tablelist;) |
                          (%toc;) |
                          topicref)* )"
>
<!ENTITY % part.attributes
             "%chapter-atts;"
>
<!ELEMENT part    %part.content;>
<!ATTLIST part    %part.attributes;>

<!ENTITY % part-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % part-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT part-mapref    %part-mapref.content;>
<!ATTLIST part-mapref    %part-mapref.attributes;>


<!--                    LONG NAME: Department                            -->
<!ENTITY % department.content
                       "((%topicmeta;)?,
                         ((%chapter;) | 
                          (%article;) |
                          (%department;) |
                          (%subsection;) |
                          (%page;))* )"
>
<!ENTITY % department.attributes
             "%chapter-atts;"
>
<!ELEMENT department    %department.content;>
<!ATTLIST department    %department.attributes;>

<!ENTITY % department-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % department-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT department-mapref    %department-mapref.content;>
<!ATTLIST department-mapref    %department-mapref.attributes;>



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

<!ENTITY % appendixes-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % appendixes-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT appendixes-mapref    %appendixes-mapref.content;>
<!ATTLIST appendixes-mapref    %appendixes-mapref.attributes;>

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

<!ENTITY % appendix-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % appendix-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT appendix-mapref    %appendix-mapref.content;>
<!ATTLIST appendix-mapref    %appendix-mapref.attributes;>


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

<!ENTITY % bibliolist-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % bibliolist-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT bibliolist-mapref    %bibliolist-mapref.content;>
<!ATTLIST bibliolist-mapref    %bibliolist-mapref.attributes;>



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

<!ENTITY % glossarylist-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % glossarylist-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT glossarylist-mapref    %glossarylist-mapref.content;>
<!ATTLIST glossarylist-mapref    %glossarylist-mapref.attributes;>

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

<!ENTITY % glossary-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % glossary-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT glossary-mapref    %glossary-mapref.content;>
<!ATTLIST glossary-mapref    %glossary-mapref.attributes;>


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

<!ENTITY % glossary-group-mapref.content
 "%mapref.cnt;"
>
<!ENTITY % glossary-group-mapref.attributes
 "%mapref-atts;"
>
<!ELEMENT glossary-group-mapref    %glossary-group-mapref.content;>
<!ATTLIST glossary-group-mapref    %glossary-group-mapref.attributes;>

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
<!ATTLIST abbrevlist    %global-atts; class CDATA "- map/topicref pubmap-d/abbrevlist ">
<!ATTLIST amendments    %global-atts; class CDATA "- map/topicref pubmap-d/amendments ">
<!ATTLIST appendix      %global-atts; class CDATA "- map/topicref pubmap-d/appendix ">
<!ATTLIST appendix-mapref %global-atts; class CDATA "- map/topicref pubmap-d/appendix-mapref ">
<!ATTLIST appendixes    %global-atts; class CDATA "- map/topicref pubmap-d/appendixes ">
<!ATTLIST appendixes-mapref %global-atts; class CDATA "- map/topicref pubmap-d/appendixes-mapref ">
<!ATTLIST article       %global-atts; class CDATA "- map/topicref pubmap-d/article ">
<!ATTLIST article-mapref %global-atts; class CDATA "- map/topicref pubmap-d/article-mapref ">
<!ATTLIST back-cover    %global-atts; class CDATA "- map/topicref pubmap-d/back-cover ">
<!ATTLIST back-flap     %global-atts; class CDATA "- map/topicref pubmap-d/back-flap ">
<!ATTLIST backmatter    %global-atts; class CDATA "- map/topicref pubmap-d/backmatter ">
<!ATTLIST backmatter-mapref %global-atts; class CDATA "- map/topicref pubmap-d/backmatter-mapref ">
<!ATTLIST book-jacket   %global-atts; class CDATA "- map/topicref pubmap-d/book-jacket ">
<!ATTLIST bibliolist    %global-atts; class CDATA "- map/topicref pubmap-d/bibliolist ">
<!ATTLIST bibliolist-mapref %global-atts; class CDATA "- map/topicref pubmap-d/bibliolist-mapref ">
<!ATTLIST chapter       %global-atts; class CDATA "- map/topicref pubmap-d/chapter ">
<!ATTLIST chapter-mapref %global-atts; class CDATA "- map/topicref pubmap-d/chapter-mapref ">
<!ATTLIST colophon      %global-atts; class CDATA "- map/topicref pubmap-d/colophon ">
<!ATTLIST copyright-page %global-atts; class CDATA "- map/topicref pubmap-d/copyright-page ">
<!ATTLIST covers        %global-atts; class CDATA "- map/topicref pubmap-d/covers ">
<!ATTLIST dedication    %global-atts; class CDATA "- map/topicref pubmap-d/dedication ">
<!ATTLIST department    %global-atts; class CDATA "- map/topicref pubmap-d/department ">
<!ATTLIST department-mapref %global-atts; class CDATA "- map/topicref pubmap-d/department-mapref ">
<!ATTLIST draftintro    %global-atts; class CDATA "- map/topicref pubmap-d/draftintro ">
<!ATTLIST figurelist    %global-atts; class CDATA "- map/topicref pubmap-d/figurelist ">
<!ATTLIST forward       %global-atts; class CDATA "- map/topicref pubmap-d/forward ">
<!ATTLIST front-cover   %global-atts; class CDATA "- map/topicref pubmap-d/front-cover ">
<!ATTLIST front-flap    %global-atts; class CDATA "- map/topicref pubmap-d/front-flap ">
<!ATTLIST frontmatter   %global-atts; class CDATA "- map/topicref pubmap-d/frontmatter ">
<!ATTLIST frontmatter-mapref %global-atts; class CDATA "- map/topicref pubmap-d/frontmatter-mapref ">
<!ATTLIST glossary       %global-atts; class CDATA "- map/topicref pubmap-d/glossary ">
<!ATTLIST glossary-mapref %global-atts; class CDATA "- map/topicref pubmap-d/glossary-mapref ">
<!ATTLIST glossentry    %global-atts; class CDATA "- map/topicref pubmap-d/glossentry ">
<!ATTLIST glossary-group  %global-atts; class CDATA "- map/topicref pubmap-d/glossary-group ">
<!ATTLIST glossary-group-mapref %global-atts; class CDATA "- map/topicref pubmap-d/glossary-group-mapref ">
<!ATTLIST glossarylist  %global-atts; class CDATA "- map/topicref pubmap-d/glossarylist ">
<!ATTLIST indexlist     %global-atts; class CDATA "- map/topicref pubmap-d/indexlist ">
<!ATTLIST keydefs       %global-atts; class CDATA "- map/topicref pubmap-d/keydefs ">
<!ATTLIST keydefs-mapref %global-atts; class CDATA "- map/topicref pubmap-d/keydefs-mapref ">
<!ATTLIST keydef-group  %global-atts; class CDATA "- map/topicref pubmap-d/keydef-group ">
<!ATTLIST keydef-mapref %global-atts; class CDATA "- map/topicref pubmap-d/keydef-mapref ">
<!ATTLIST notices       %global-atts; class CDATA "- map/topicref pubmap-d/notices ">
<!ATTLIST page          %global-atts; class CDATA "- map/topicref pubmap-d/page ">
<!ATTLIST part          %global-atts; class CDATA "- map/topicref pubmap-d/part ">
<!ATTLIST part-mapref %global-atts; class CDATA "- map/topicref pubmap-d/part-mapref ">
<!ATTLIST preface       %global-atts; class CDATA "- map/topicref pubmap-d/preface ">
<!ATTLIST pubabstract   %global-atts; class CDATA "- map/topicref pubmap-d/pubabstract ">
<!ATTLIST publist       %global-atts; class CDATA "- map/topicref pubmap-d/publist ">
<!ATTLIST publists      %global-atts; class CDATA "- map/topicref pubmap-d/publists ">
<!ATTLIST pubbody       %global-atts; class CDATA "- map/topicref pubmap-d/pubbody ">
<!ATTLIST pubbody-mapref %global-atts; class CDATA "- map/topicref pubmap-d/pubbody-mapref ">
<!ATTLIST publication   %global-atts; class CDATA "- map/topicref pubmap-d/publication ">
<!ATTLIST publication-mapref %global-atts; class CDATA "- map/topicref pubmap-d/publication-mapref ">
<!ATTLIST subsection    %global-atts; class CDATA "- map/topicref pubmap-d/subsection ">
<!ATTLIST subsection-mapref %global-atts; class CDATA "- map/topicref pubmap-d/subsection-mapref ">
<!ATTLIST sidebar       %global-atts; class CDATA "- map/topicref pubmap-d/sidebar ">
<!ATTLIST sidebar-mapref %global-atts; class CDATA "- map/topicref pubmap-d/sidebar-mapref ">
<!ATTLIST spine         %global-atts; class CDATA "- map/topicref pubmap-d/spine ">
<!ATTLIST tablelist     %global-atts; class CDATA "- map/topicref pubmap-d/tablelist ">
<!ATTLIST toc           %global-atts; class CDATA "- map/topicref pubmap-d/toc ">
<!ATTLIST trademarklist %global-atts; class CDATA "- map/topicref pubmap-d/trademarklist ">
<!ATTLIST wrap-cover    %global-atts; class CDATA "- map/topicref pubmap-d/wrap-cover ">
<!ATTLIST wrap-cover-mapref %global-atts; class CDATA "- map/topicref pubmap-d/wrap-cover-mapref ">

<!-- title types: -->

<!ATTLIST pubtitle      %global-atts; class CDATA "- topic/title pubmap-d/pubtitle ">

<!-- ph types: -->

<!ATTLIST completed    %global-atts; class CDATA "- topic/ph pubmap-d/completed ">
<!ATTLIST day          %global-atts; class CDATA "- topic/ph pubmap-d/day ">
<!ATTLIST mainpubtitle %global-atts; class CDATA "- topic/ph pubmap-d/mainpubtitle ">
<!ATTLIST subtitle     %global-atts; class CDATA "- topic/ph pubmap-d/subtitle ">
<!ATTLIST month        %global-atts; class CDATA "- topic/ph pubmap-d/month ">
<!ATTLIST publibrary   %global-atts; class CDATA "- topic/ph pubmap-d/publibrary ">
<!ATTLIST pubtitlealt  %global-atts; class CDATA "- topic/ph pubmap-d/pubtitlealt ">
<!ATTLIST revisionid   %global-atts; class CDATA "- topic/ph pubmap-d/revisionid ">
<!ATTLIST started      %global-atts; class CDATA "- topic/ph pubmap-d/started ">
<!ATTLIST summary      %global-atts; class CDATA "- topic/ph pubmap-d/summary ">
<!ATTLIST year         %global-atts; class CDATA "- topic/ph pubmap-d/year ">

<!-- topicmeta types: -->

<!ATTLIST pubmeta      %global-atts; class CDATA "- map/topicmeta pubmap-d/pubmeta ">

<!-- publisher types: -->

<!ATTLIST publisherinformation %global-atts; class CDATA "- topic/publisher pubmap-d/publisherinformation ">

<!-- data types: -->

<!ATTLIST approved         %global-atts; class CDATA "- topic/data pubmap-d/approved ">
<!ATTLIST copyrfirst       %global-atts; class CDATA "- topic/data pubmap-d/copyrfirst ">
<!ATTLIST copyrlast        %global-atts; class CDATA "- topic/data pubmap-d/copyrlast ">
<!ATTLIST edited           %global-atts; class CDATA "- topic/data pubmap-d/edited ">
<!ATTLIST edition          %global-atts; class CDATA "- topic/data pubmap-d/edition ">
<!ATTLIST doi              %global-atts; class CDATA "- topic/data pubmap-d/doi ">
<!ATTLIST isbn             %global-atts; class CDATA "- topic/data pubmap-d/isbn ">
<!ATTLIST isbn-10          %global-atts; class CDATA "- topic/data pubmap-d/isbn-10 ">
<!ATTLIST isbn-13          %global-atts; class CDATA "- topic/data pubmap-d/isbn-13 ">
<!ATTLIST issn             %global-atts; class CDATA "- topic/data pubmap-d/issn ">
<!ATTLIST issn-13          %global-atts; class CDATA "- topic/data pubmap-d/issn-13 ">
<!ATTLIST issn-10          %global-atts; class CDATA "- topic/data pubmap-d/issn-13 ">
<!ATTLIST issue            %global-atts; class CDATA "- topic/data pubmap-d/issue ">
<!ATTLIST locnumber        %global-atts; class CDATA "- topic/data pubmap-d/locnumber ">
<!ATTLIST maintainer       %global-atts; class CDATA "- topic/data pubmap-d/maintainer ">
<!ATTLIST organization     %global-atts; class CDATA "- topic/data pubmap-d/organization ">
<!ATTLIST person           %global-atts; class CDATA "- topic/data pubmap-d/person ">
<!ATTLIST printlocation    %global-atts; class CDATA "- topic/data pubmap-d/printlocation ">
<!ATTLIST pubchangehistory %global-atts; class CDATA "- topic/data pubmap-d/pubchangehistory ">
<!ATTLIST pubevent         %global-atts; class CDATA "- topic/data pubmap-d/pubevent ">
<!ATTLIST pubeventtype     %global-atts; class CDATA "- topic/data pubmap-d/pubeventtype ">
<!ATTLIST pubid            %global-atts; class CDATA "- topic/data pubmap-d/pubid ">
<!ATTLIST pubnumber        %global-atts; class CDATA "- topic/data pubmap-d/pubnumber ">
<!ATTLIST pubowner         %global-atts; class CDATA "- topic/data pubmap-d/pubowner ">
<!ATTLIST pubpartno        %global-atts; class CDATA "- topic/data pubmap-d/pubpartno ">
<!ATTLIST pubrestriction   %global-atts; class CDATA "- topic/data pubmap-d/pubrestriction ">
<!ATTLIST publicense       %global-atts; class CDATA "- topic/data pubmap-d/publicense ">
<!ATTLIST pubrights        %global-atts; class CDATA "- topic/data pubmap-d/pubrights ">
<!ATTLIST published        %global-atts; class CDATA "- topic/data pubmap-d/published ">
<!ATTLIST publishtype      %global-atts; class CDATA "- topic/data pubmap-d/publishtype ">
<!ATTLIST reviewed         %global-atts; class CDATA "- topic/data pubmap-d/reviewed ">
<!ATTLIST tested           %global-atts; class CDATA "- topic/data pubmap-d/tested ">
<!ATTLIST volume           %global-atts; class CDATA "- topic/data pubmap-d/volume ">

<!-- ================== End pub map domain ============================= -->