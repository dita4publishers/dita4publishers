<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!--  MODULE:    Play Map                                          -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      May 2009                                          -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "urn:pubid:dita4publishers.sourceforge.net/modules/dtd/playmap" 
      Delivered as file "playmap.mod"                               -->

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
 
<!ENTITY % playmap           "playmap"                                 >
<!ENTITY % playmeta          "playmeta"                                >
<!ENTITY % playmetadata      "playmetadata"                            >
<!ENTITY % acts          "acts"                                >
<!ENTITY % scene-description "scene-description"                       >
<!ENTITY % act               "act"                                     >
<!ENTITY % epilog            "epilog"                                  >
<!ENTITY % induct            "induct"                                  >
<!ENTITY % prolog            "prolog"                                  >
<!ENTITY % scene             "scene"                                   >
<!ENTITY % personae          "personae"                                >


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
<!ENTITY % play-component-atts 
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
<!ENTITY % playmap.content
  "(((%title;) | 
     (%pubtitle;))?,
   (%playmeta;)?, 
   (%keydefs;)?,
   (%covers;)?,
   (%colophon;)?, 
   ((%personae;) |
    (%page;))*,
   ((%acts;)), 
   ((%page;) |
    (%colophon;))*,
   (%reltable;)*)"
>
<!ENTITY % playmap.attributes
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
<!ELEMENT playmap    %playmap.content;>
<!ATTLIST playmap    
              %playmap.attributes;
              %arch-atts;
              domains 
                        CDATA 
                                  '&included-domains;'
>

<!ENTITY % playmeta.content
 "((%linktext;)?, 
   (%searchtitle;)?, 
   (%shortdesc;)?, 
   (%author;)*, 
   (%source;)?, 
   (%publisherinformation;)*,
   (%critdates;)?, 
   (%permissions;)?, 
   (%metadata; |
    %playmetadata;)*, 
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
<!ENTITY % playmeta.attributes
             "lockmeta 
                        (no | 
                         yes | 
                         -dita-use-conref-target)
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT playmeta    %playmeta.content;>
<!ATTLIST playmeta    %playmeta.attributes;>

<!ENTITY % playmetadata.content
 "(scene-description?)"
>
<!ENTITY % playmetadata.attributes
             "%univ-atts; 
              mapkeyref 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT playmetadata    %playmetadata.content;>
<!ATTLIST playmetadata    %playmetadata.attributes;>

<!--                    LONG NAME: pubbody                         -->
<!ENTITY % acts.content
                       "((%topicmeta;)?, 
                         (%personae;)?,
                         (%induct;)?,
                         (%prolog;)?,
                         (%act;)+,
                         (%epilog;)?)"
>

<!-- Sets collection-type to sequence by default -->
<!ENTITY % acts.attributes
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
<!ELEMENT acts    %acts.content;>
<!ATTLIST acts    %acts.attributes;>


<!ENTITY % scene-description.content
 "%data.content;" 
>
<!ENTITY % scene-description.attributes
             "name
                   CDATA    'scene-description'              
              %univ-atts;"
>
<!ELEMENT scene-description  %scene-description.content; >
<!ATTLIST scene-description  %scene-description.attributes;>

<!ENTITY % act.content
 "((%topicmeta;)?, 
   (%scene; |
    %topicref;)*)"
>
<!ENTITY % act.attributes
 "%play-component-atts;"
>
<!ELEMENT act    %act.content;>
<!ATTLIST act    %act.attributes;>

<!ENTITY % personae.content
 "((%topicmeta;)?, 
   (%topicref;)*)"
>
<!ENTITY % personae.attributes
 "%play-component-atts;"
>
<!ELEMENT personae    %personae.content;>
<!ATTLIST personae    %personae.attributes;>

<!ENTITY % epilog.content
 "((%topicmeta;)?, 
   (%scene; |
    %topicref;)*)"
>
<!ENTITY % epilog.attributes
 "%play-component-atts;"
>
<!ELEMENT epilog    %epilog.content;>
<!ATTLIST epilog    %epilog.attributes;>

<!ENTITY % induct.content
 "((%topicmeta;)?, 
   (%scene; |
    %topicref;)*)"
>
<!ENTITY % induct.attributes
 "%play-component-atts;"
>
<!ELEMENT induct    %induct.content;>
<!ATTLIST induct    %induct.attributes;>

<!ENTITY % prolog.content
 "((%topicmeta;)?, 
   (%scene; |
    %topicref;)*)"
>
<!ENTITY % prolog.attributes
 "%play-component-atts;"
>
<!ELEMENT prolog    %prolog.content;>
<!ATTLIST prolog    %prolog.attributes;>

<!ENTITY % scene.content
 "((%topicmeta;)?, 
   (%topicref;)*)"
>
<!ENTITY % scene.attributes
 "%play-component-atts;"
>
<!ELEMENT scene    %scene.content;>
<!ATTLIST scene    %scene.attributes;>


<!ATTLIST playmap     %global-atts; class CDATA "- map/map      pubmap/pubmap       playmap/playmap ">
<!ATTLIST playmeta    %global-atts; class CDATA "- map/topicmeta pubmap/topicmeta   playmap/playmeta ">
<!ATTLIST playmetadata %global-atts; class CDATA "- map/metadata pubmap/metadata   playmap/playmetadata ">
<!ATTLIST acts        %global-atts; class CDATA "- map/topicref pubmap/pubbody      playmap/acts ">
<!ATTLIST act         %global-atts; class CDATA "- map/topicref playmap/topicref    playmap/act ">
<!ATTLIST prolog      %global-atts; class CDATA "- map/topicref playmap/topicref    playmap/prolog ">
<!ATTLIST epilog      %global-atts; class CDATA "- map/topicref playmap/topicref    playmap/epilog ">
<!ATTLIST induct      %global-atts; class CDATA "- map/topicref playmap/topicref    playmap/induct ">
<!ATTLIST scene       %global-atts; class CDATA "- map/topicref playmap/topicref    playmap/scene ">
<!ATTLIST scene-description %global-atts; class CDATA "- map/data   playmap/data        playmap/scene-description ">
<!ATTLIST personae    %global-atts; class CDATA "- map/topicref playmap/topicref    playmap/personae ">


<!-- ================== End pub map ============================= -->