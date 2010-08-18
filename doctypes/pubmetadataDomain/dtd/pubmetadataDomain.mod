<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= 

     DITA for Publishers Publication Metadata Map Domain
     
     Copyright (c) 2010 DITA for Publishers

     =============================================================
-->

<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!-- ph types: -->

<!ENTITY % completed "completed" >
<!ENTITY % day "day" >
<!ENTITY % month "month" >
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



<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->



<!--                    LONG NAME: pub Metadata                   -->
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
<!-- Allows unspecialized data as an escape. -->
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
                         (%maintainer;)?,
                         (data*))"
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


 
<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!-- ph types: -->

<!ATTLIST completed    %global-atts; class CDATA "+ topic/ph pubmeta-d/completed ">
<!ATTLIST day          %global-atts; class CDATA "+ topic/ph pubmeta-d/day ">
<!ATTLIST month        %global-atts; class CDATA "+ topic/ph pubmeta-d/month ">
<!ATTLIST revisionid   %global-atts; class CDATA "+ topic/ph pubmeta-d/revisionid ">
<!ATTLIST started      %global-atts; class CDATA "+ topic/ph pubmeta-d/started ">
<!ATTLIST summary      %global-atts; class CDATA "+ topic/ph pubmeta-d/summary ">
<!ATTLIST year         %global-atts; class CDATA "+ topic/ph pubmeta-d/year ">

<!-- topicmeta types: -->

<!ATTLIST pubmeta      %global-atts; class CDATA "+ map/topicmeta pubmeta-d/pubmeta ">

<!-- publisher types: -->

<!ATTLIST publisherinformation %global-atts; class CDATA "+ topic/publisher pubmeta-d/publisherinformation ">

<!-- data types: -->

<!ATTLIST approved         %global-atts; class CDATA "+ topic/data pubmeta-d/approved ">
<!ATTLIST copyrfirst       %global-atts; class CDATA "+ topic/data pubmeta-d/copyrfirst ">
<!ATTLIST copyrlast        %global-atts; class CDATA "+ topic/data pubmeta-d/copyrlast ">
<!ATTLIST edited           %global-atts; class CDATA "+ topic/data pubmeta-d/edited ">
<!ATTLIST edition          %global-atts; class CDATA "+ topic/data pubmeta-d/edition ">
<!ATTLIST doi              %global-atts; class CDATA "+ topic/data pubmeta-d/doi ">
<!ATTLIST isbn             %global-atts; class CDATA "+ topic/data pubmeta-d/isbn ">
<!ATTLIST isbn-10          %global-atts; class CDATA "+ topic/data pubmeta-d/isbn-10 ">
<!ATTLIST isbn-13          %global-atts; class CDATA "+ topic/data pubmeta-d/isbn-13 ">
<!ATTLIST issn             %global-atts; class CDATA "+ topic/data pubmeta-d/issn ">
<!ATTLIST issn-13          %global-atts; class CDATA "+ topic/data pubmeta-d/issn-13 ">
<!ATTLIST issn-10          %global-atts; class CDATA "+ topic/data pubmeta-d/issn-13 ">
<!ATTLIST issue            %global-atts; class CDATA "+ topic/data pubmeta-d/issue ">
<!ATTLIST locnumber        %global-atts; class CDATA "+ topic/data pubmeta-d/locnumber ">
<!ATTLIST maintainer       %global-atts; class CDATA "+ topic/data pubmeta-d/maintainer ">
<!ATTLIST organization     %global-atts; class CDATA "+ topic/data pubmeta-d/organization ">
<!ATTLIST person           %global-atts; class CDATA "+ topic/data pubmeta-d/person ">
<!ATTLIST printlocation    %global-atts; class CDATA "+ topic/data pubmeta-d/printlocation ">
<!ATTLIST pubchangehistory %global-atts; class CDATA "+ topic/data pubmeta-d/pubchangehistory ">
<!ATTLIST pubevent         %global-atts; class CDATA "+ topic/data pubmeta-d/pubevent ">
<!ATTLIST pubeventtype     %global-atts; class CDATA "+ topic/data pubmeta-d/pubeventtype ">
<!ATTLIST pubid            %global-atts; class CDATA "+ topic/data pubmeta-d/pubid ">
<!ATTLIST pubnumber        %global-atts; class CDATA "+ topic/data pubmeta-d/pubnumber ">
<!ATTLIST pubowner         %global-atts; class CDATA "+ topic/data pubmeta-d/pubowner ">
<!ATTLIST pubpartno        %global-atts; class CDATA "+ topic/data pubmeta-d/pubpartno ">
<!ATTLIST pubrestriction   %global-atts; class CDATA "+ topic/data pubmeta-d/pubrestriction ">
<!ATTLIST publicense       %global-atts; class CDATA "+ topic/data pubmeta-d/publicense ">
<!ATTLIST pubrights        %global-atts; class CDATA "+ topic/data pubmeta-d/pubrights ">
<!ATTLIST published        %global-atts; class CDATA "+ topic/data pubmeta-d/published ">
<!ATTLIST publishtype      %global-atts; class CDATA "+ topic/data pubmeta-d/publishtype ">
<!ATTLIST reviewed         %global-atts; class CDATA "+ topic/data pubmeta-d/reviewed ">
<!ATTLIST tested           %global-atts; class CDATA "+ topic/data pubmeta-d/tested ">
<!ATTLIST volume           %global-atts; class CDATA "+ topic/data pubmeta-d/volume ">

<!-- ================== End pub map domain ============================= -->