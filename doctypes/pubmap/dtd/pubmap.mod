<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!--  MODULE:    DITA Pubmap                                       -->
<!--  VERSION:   1.2                                               -->
<!--  DATE:      May 2009                                          -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "urn:pubid:dita4publishers.sourceforge.net/modules/dtd/pubmap" 
      Delivered as file "pubmap.mod"                               -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Define elements and specialization atttributes    -->
<!--             for Publication Maps                              -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->

<!-- default namespace prefix for DITAArchVersion attribute can be
     overridden through predefinition in the document type shell   -->
<!ENTITY % DITAArchNSPrefix
  "ditaarch" 
>

<!-- must be instanced on each topic type                          -->
<!ENTITY % arch-atts 
             "xmlns:%DITAArchNSPrefix; 
                         CDATA 
                                  #FIXED 'http://dita.oasis-open.org/architecture/2005/'
              %DITAArchNSPrefix;:DITAArchVersion
                         CDATA
                                  '1.2'
  "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 
<!ENTITY % pubmap         "pubmap"                                 >

<!ENTITY % abbrevlist      "abbrevlist"                              >
<!ENTITY % pubabstract    "pubabstract"                            >
<!ENTITY % amendments      "amendments"                              >
<!ENTITY % appendix        "appendix"                                >
<!ENTITY % appendixes      "appendixes"                              >
<!ENTITY % approved        "approved"                                >
<!ENTITY % backmatter      "backmatter"                              >
<!ENTITY % bibliolist      "bibliolist"                              >
<!ENTITY % pubchangehistory "pubchangehistory"                     >
<!ENTITY % pubevent       "pubevent"                               >
<!ENTITY % pubeventtype   "pubeventtype"                           >
<!ENTITY % pubid          "pubid"                                  >
<!ENTITY % publibrary     "publibrary"                             >
<!ENTITY % publist        "publist"                                >
<!ENTITY % publists       "publists"                               >
<!ENTITY % pubmeta        "pubmeta"                                >
<!ENTITY % pubnumber      "pubnumber"                              >
<!ENTITY % pubowner       "pubowner"                               >
<!ENTITY % pubpartno      "pubpartno"                              >
<!ENTITY % pubrestriction "pubrestriction"                         >
<!ENTITY % publicense     "publicense"                             >
<!ENTITY % pubrights      "pubrights"                              >
<!ENTITY % pubtitle       "pubtitle"                               >
<!ENTITY % pubtitlealt    "pubtitlealt"                            >

<!ENTITY % keydefs         "keydefs"                                 >
<!ENTITY % keydef-group    "keydef-group"                            >
<!ENTITY % pubbody         "pubbody"                                 >
<!ENTITY % chapter         "chapter"                                 >
<!ENTITY % covers          "covers"                                 >
<!ENTITY % front-cover     "front-cover"                                 >
<!ENTITY % back-cover      "back-cover"                                 >
<!ENTITY % wrap-cover      "wrap-cover"                                 >
<!ENTITY % front-flap      "front-flap"                                 >
<!ENTITY % back-flap       "back-flap"                                 >
<!ENTITY % spine           "spine"                                 >
<!ENTITY % inside-front-cover "inside-front-cover"                                 >
<!ENTITY % page            "page"                                 >
<!ENTITY % article         "article"                                 >
<!ENTITY % department      "department"                              >
<!ENTITY % subsection      "subsection"                              >
<!ENTITY % sidebar         "sidebar"                                 >
<!ENTITY % glossary        "glossary"                              >
<!ENTITY % glossary-group  "glossary-group"                           >
<!ENTITY % glossentry      "glossentry"                              >
<!ENTITY % bibliography    "bibliography"                              >
<!ENTITY % colophon        "colophon"                                >
<!ENTITY % completed       "completed"                               >
<!ENTITY % copyrfirst      "copyrfirst"                              >
<!ENTITY % copyrlast       "copyrlast"                               >
<!ENTITY % day             "day"                                     >
<!ENTITY % dedication      "dedication"                              >
<!ENTITY % draftintro      "draftintro"                              >
<!ENTITY % edited          "edited"                                  >
<!ENTITY % edition         "edition"                                 >
<!ENTITY % figurelist      "figurelist"                              >
<!ENTITY % frontmatter     "frontmatter"                             >
<!ENTITY % glossarylist    "glossarylist"                            >
<!ENTITY % indexlist       "indexlist"                               >
<!ENTITY % isbn            "isbn"                                    >
<!ENTITY % isbn-10         "isbn-10"                                >
<!ENTITY % isbn-13         "isbn-13" >
<!ENTITY % issn            "issn"                                    >
<!ENTITY % issn-10         "issn-10"                                >
<!ENTITY % issn-13         "issn-13"                                >
<!ENTITY % mainpubtitle    "mainpubtitle"                           >
<!ENTITY % maintainer      "maintainer"                              >
<!ENTITY % month           "month"                                   >
<!ENTITY % notices         "notices"                                 >
<!ENTITY % organization    "organization"                            >
<!ENTITY % part            "part"                                    >
<!ENTITY % person          "person"                                  >
<!ENTITY % preface         "preface"                                 >
<!ENTITY % printlocation   "printlocation"                           >
<!ENTITY % published       "published"                               >
<!ENTITY % publisherinformation "publisherinformation"               >
<!ENTITY % publishtype     "publishtype"                             >
<!ENTITY % reviewed        "reviewed"                                >
<!ENTITY % revisionid      "revisionid"                              >
<!ENTITY % started         "started"                                 >
<!ENTITY % summary         "summary"                                 >
<!ENTITY % tablelist       "tablelist"                               >
<!ENTITY % tested          "tested"                                  >
<!ENTITY % trademarklist   "trademarklist"                           >
<!ENTITY % toc             "toc"                                     >
<!ENTITY % issue           "issue"                                  >
<!ENTITY % volume          "volume"                                  >
<!ENTITY % year            "year"                                    >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>

<!-- ============================================================= -->
<!--                    COMMON ATTLIST SETS                        -->
<!-- ============================================================= -->

<!-- Currently: same as topicref, minus @query -->
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
              %topicref-atts;
              %univ-atts;' 
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!--                    LONG NAME: pub Map                        -->
<!ENTITY % pubmap.content
  "(((%title;) | 
     (%pubtitle;))?,
   (%pubmeta;)?, 
   (%keydefs;)?,
   (%covers;)?,
   (%colophon;)?, 
   ((%frontmatter;) |
    (%department;) |
    (%page;))*,
   ((%pubbody;)), 
   ((%appendixes;) |
    (%appendix;) |
    (%backmatter;) |
    (%page;) |
    (%department;) |
    (%colophon;))*,
   (%reltable;)*)"
>
<!ENTITY % pubmap.attributes
             "id 
                        ID 
                                  #IMPLIED
              %conref-atts;
              anchorref 
                        CDATA 
                                  #IMPLIED
              outputclass 
                        CDATA 
                                  #IMPLIED
              %localization-atts;
              %topicref-atts;
              %select-atts;"
>
<!ELEMENT pubmap    %pubmap.content;>
<!ATTLIST pubmap    
              %pubmap.attributes;
              %arch-atts;
              domains 
                        CDATA 
                                  '&included-domains;'
>

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
 "(%pubabstract; | 
   %publists; | 
   %colophon; | 
   %dedication; | 
   %draftintro; | 
   %notices; | 
   %preface; | 
   %topicref; |
   %subsection; |
   %department; |
   %page; |
   %article;)*"
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
              %topicref-atts;
              %univ-atts;"
>
<!ELEMENT frontmatter    %frontmatter.content;>
<!ATTLIST frontmatter    %frontmatter.attributes;>

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


<!--                    LONG NAME: Back Matter                     -->
<!ENTITY % backmatter.content
 "(%amendments; | 
   %publists; | 
   %colophon; | 
   %dedication; | 
   %notices; | 
   %topicref; |
   %subsection; |
   %article; | 
   %chapter; |
   %page;)*"
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
              %topicref-atts;
              %univ-atts;"
>
<!ELEMENT backmatter    %backmatter.content;>
<!ATTLIST backmatter    %backmatter.attributes;>


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
                         (%isbn;)*, 
                         (%isbn-10;)*, 
                         (%isbn-13;)*, 
                         (%issn;)*, 
                         (%issn-10;)*, 
                         (%issn-13;)*, 
                         (%pubnumber;)?, 
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


<!--                    LONG NAME: ISBN Number                     -->
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

<!--                    LONG NAME: ISBN 13 Number                     -->
<!ENTITY % issn-13.content
                       "(#PCDATA |
                         %keyword;)*"
>
<!ENTITY % issn-13.attributes
             "%data-element-atts;"
>
<!ELEMENT issn-13    %issn-13.content;>
<!ATTLIST issn-13    %issn-13.attributes;>


<!--                    LONG NAME: pub Number                     -->
<!ENTITY % pubnumber.content
                       "(%words.cnt;)*"
>
<!ENTITY % pubnumber.attributes
             "%data-element-atts;"
>
<!ELEMENT pubnumber    %pubnumber.content;>
<!ATTLIST pubnumber    %pubnumber.attributes;>


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

<!--                    LONG NAME: pubbody                         -->
<!ENTITY % pubbody.content
                       "((%topicmeta;)?, 
                         ((%appendix;) |
                          (%chapter;) |
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
                          %page; |
                          %topicref;)*)"
>
<!ENTITY % sidebar.attributes
             "%chapter-atts;"
>
<!ELEMENT sidebar    %sidebar.content;>
<!ATTLIST sidebar    %sidebar.attributes;>


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
                          (%page;) |
                          (%topicref;))* )"
>
<!ENTITY % part.attributes
             "%chapter-atts;"
>
<!ELEMENT part    %part.content;>
<!ATTLIST part    %part.attributes;>

<!--                    LONG NAME: Department                            -->
<!ENTITY % department.content
                       "((%topicmeta;)?,
                         ((%chapter;) | 
                          (%article;) |
                          (%page;) |
                          (%topicref;))* )"
>
<!ENTITY % department.attributes
             "%chapter-atts;"
>
<!ELEMENT department    %department.content;>
<!ATTLIST department    %department.attributes;>


<!--                    LONG NAME: Appendixes                        -->
<!ENTITY % appendixes.content
                       "((%topicmeta;)?, 
                         ((%appendix;) |
                          (%chapter;) |
                          (%topicref;)*))"
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
                       "EMPTY"
>
<!ENTITY % toc.attributes
             "%chapter-atts;"
>
<!ELEMENT toc    %toc.content;>
<!ATTLIST toc    %toc.attributes;>


<!--                    LONG NAME: Figure List                     -->
<!ENTITY % figurelist.content
                       "EMPTY"
>
<!ENTITY % figurelist.attributes
             "%chapter-atts;"
>
<!ELEMENT figurelist    %figurelist.content;>
<!ATTLIST figurelist    %figurelist.attributes;>


<!--                    LONG NAME: Table List                      -->
<!ENTITY % tablelist.content
                       "EMPTY"
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
                          (%glossentry;) |
                          (%topicref;))*)"
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
                          (%glossentry;) |
                          (%topicref;))*)"
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
                       "EMPTY"
>
<!ENTITY % publist.attributes
             "%chapter-atts;"
>
<!ELEMENT publist    %publist.content;>
<!ATTLIST publist    %publist.attributes;>


 
<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST abbrevlist  %global-atts; class CDATA "- map/topicref pubmap/abbrevlist ">
<!ATTLIST amendments  %global-atts; class CDATA "- map/topicref pubmap/amendments ">
<!ATTLIST appendix    %global-atts; class CDATA "- map/topicref pubmap/appendix ">
<!ATTLIST approved    %global-atts; class CDATA "- topic/data pubmap/approved ">
<!ATTLIST article     %global-atts; class CDATA "- map/topicref pubmap/article ">
<!ATTLIST back-cover  %global-atts; class CDATA "- map/topicref pubmap/back-cover ">
<!ATTLIST back-flap   %global-atts; class CDATA "- map/topicref pubmap/back-flap ">
<!ATTLIST book-jacket %global-atts; class CDATA "- map/topicref pubmap/book-jacket ">
<!ATTLIST backmatter  %global-atts; class CDATA "- map/topicref pubmap/backmatter ">
<!ATTLIST bibliolist  %global-atts; class CDATA "- map/topicref pubmap/bibliolist ">
<!ATTLIST chapter     %global-atts; class CDATA "- map/topicref pubmap/chapter ">
<!ATTLIST colophon    %global-atts; class CDATA "- map/topicref pubmap/colophon ">
<!ATTLIST completed   %global-atts; class CDATA "- topic/ph pubmap/completed ">
<!ATTLIST copyrfirst  %global-atts; class CDATA "- topic/data pubmap/copyrfirst ">
<!ATTLIST copyrlast   %global-atts; class CDATA "- topic/data pubmap/copyrlast ">
<!ATTLIST covers      %global-atts; class CDATA "- map/topicref pubmap/covers ">
<!ATTLIST day         %global-atts; class CDATA "- topic/ph pubmap/day ">
<!ATTLIST dedication  %global-atts; class CDATA "- map/topicref pubmap/dedication ">
<!ATTLIST draftintro  %global-atts; class CDATA "- map/topicref pubmap/draftintro ">
<!ATTLIST edited      %global-atts; class CDATA "- topic/data pubmap/edited ">
<!ATTLIST edition     %global-atts; class CDATA "- topic/data pubmap/edition ">
<!ATTLIST figurelist  %global-atts; class CDATA "- map/topicref pubmap/figurelist ">
<!ATTLIST front-cover %global-atts; class CDATA "- map/topicref pubmap/front-cover ">
<!ATTLIST front-flap  %global-atts; class CDATA "- map/topicref pubmap/front-flap ">
<!ATTLIST frontmatter %global-atts; class CDATA "- map/topicref pubmap/frontmatter ">
<!ATTLIST glossarylist %global-atts; class CDATA "- map/topicref pubmap/glossarylist ">
<!ATTLIST indexlist   %global-atts; class CDATA "- map/topicref pubmap/indexlist ">
<!ATTLIST keydefs     %global-atts; class CDATA "- topic/topicref pubmap/keydefs ">
<!ATTLIST keydef-group %global-atts; class CDATA "- topic/topicref pubmap/keydef-group ">
<!ATTLIST mainpubtitle %global-atts;  class CDATA "- topic/ph pubmap/mainpubtitle ">
<!ATTLIST maintainer  %global-atts; class CDATA "- topic/data pubmap/maintainer ">
<!ATTLIST month       %global-atts; class CDATA "- topic/ph pubmap/month ">
<!ATTLIST notices     %global-atts; class CDATA "- map/topicref pubmap/notices ">
<!ATTLIST organization %global-atts; class CDATA "- topic/data pubmap/organization ">
<!ATTLIST page        %global-atts; class CDATA "- map/topicref pubmap/page ">
<!ATTLIST part        %global-atts; class CDATA "- map/topicref pubmap/part ">
<!ATTLIST person      %global-atts; class CDATA "- topic/data pubmap/person ">
<!ATTLIST preface     %global-atts; class CDATA "- map/topicref pubmap/preface ">
<!ATTLIST printlocation %global-atts; class CDATA "- topic/data pubmap/printlocation ">
<!ATTLIST pubabstract %global-atts; class CDATA "- map/topicref pubmap/pubabstract ">
<!ATTLIST pubchangehistory %global-atts; class CDATA "- topic/data pubmap/pubchangehistory ">
<!ATTLIST pubevent   %global-atts; class CDATA "- topic/data pubmap/pubevent ">
<!ATTLIST pubeventtype %global-atts; class CDATA "- topic/data pubmap/pubeventtype ">
<!ATTLIST pubid      %global-atts; class CDATA "- topic/data pubmap/pubid ">
<!ATTLIST publibrary %global-atts;  class CDATA "- topic/ph pubmap/publibrary ">
<!ATTLIST publist    %global-atts; class CDATA "- map/topicref pubmap/publist ">
<!ATTLIST publists   %global-atts; class CDATA "- map/topicref pubmap/publists ">
<!ATTLIST pubmap     %global-atts; class CDATA "- map/map pubmap/pubmap ">
<!ATTLIST pubmeta    %global-atts; class CDATA "- map/topicmeta pubmap/pubmeta ">
<!ATTLIST pubnumber  %global-atts; class CDATA "- topic/data pubmap/pubnumber ">
<!ATTLIST pubowner   %global-atts; class CDATA "- topic/data pubmap/pubowner ">
<!ATTLIST pubpartno  %global-atts; class CDATA "- topic/data pubmap/pubpartno ">
<!ATTLIST pubrestriction %global-atts; class CDATA "- topic/data pubmap/pubrestriction ">
<!ATTLIST publicense %global-atts; class CDATA "- topic/data pubmap/publicense ">
<!ATTLIST pubrights  %global-atts; class CDATA "- topic/data pubmap/pubrights ">
<!ATTLIST pubtitle   %global-atts;  class CDATA "- topic/title pubmap/pubtitle ">
<!ATTLIST pubtitlealt %global-atts;  class CDATA "- topic/ph pubmap/pubtitlealt ">
<!ATTLIST pubbody     %global-atts; class CDATA "- map/topicref pubmap/pubbody ">
<!ATTLIST published   %global-atts; class CDATA "- topic/data pubmap/published ">
<!ATTLIST publisherinformation %global-atts; class CDATA "- topic/publisher pubmap/publisherinformation ">
<!ATTLIST publishtype %global-atts; class CDATA "- topic/data pubmap/publishtype ">
<!ATTLIST reviewed    %global-atts; class CDATA "- topic/data pubmap/reviewed ">
<!ATTLIST revisionid  %global-atts; class CDATA "- topic/ph pubmap/revisionid ">
<!ATTLIST sidebar     %global-atts; class CDATA "- map/topicref pubmap/sidebar ">
<!ATTLIST spine       %global-atts; class CDATA "- map/topicref pubmap/spine ">
<!ATTLIST started     %global-atts; class CDATA "- topic/ph pubmap/started ">
<!ATTLIST subsection  %global-atts; class CDATA "- map/topicref pubmap/subsection ">
<!ATTLIST summary     %global-atts; class CDATA "- topic/ph pubmap/summary ">
<!ATTLIST tablelist   %global-atts; class CDATA "- map/topicref pubmap/tablelist ">
<!ATTLIST tested      %global-atts; class CDATA "- topic/data pubmap/tested ">
<!ATTLIST toc         %global-atts; class CDATA "- map/topicref pubmap/toc ">
<!ATTLIST trademarklist %global-atts; class CDATA "- map/topicref pubmap/trademarklist ">
<!ATTLIST volume      %global-atts; class CDATA "- topic/data pubmap/volume ">
<!ATTLIST wrap-cover  %global-atts; class CDATA "- map/topicref pubmap/wrap-cover ">
<!ATTLIST year        %global-atts; class CDATA "- topic/ph pubmap/year ">

<!-- ================== End pub map ============================= -->