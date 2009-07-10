<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= 
     Style to Tag Mapping 
     
     Describes documents that define a mapping from word processing
     styleset to DITA result markup.
     
     Copyright (c) 2009 DITA For Publishers

     ============================================================= -->

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
 
<!ENTITY % style2tagmap         "style2tagmap"                       >
<!ENTITY % documentation        "documentation"                      >
<!ENTITY % outputs              "outputs"                            >
<!ENTITY % output               "output"                             >
<!ENTITY % outputdef            "outputdef"                          >
<!ENTITY % styleset             "styleset"                           >
<!ENTITY % style                "style"                              >
<!ENTITY % styledef             "styledef"                           >

<!ENTITY % doctype-system "doctype-system" >
<!ENTITY % doctype-public "doctype-public" >

<!ENTITY % baseClass "baseClass" >
<!ENTITY % bodyType "bodyType" >
<!ENTITY % chunk "chunk" >
<!ENTITY % containerOutputclass "containerOutputclass" >
<!ENTITY % containerType "containerType" >
<!ENTITY % containingTopic "containingTopic" >
<!ENTITY % dataName "dataName" >
<!ENTITY % format "format" >
<!ENTITY % initialSectionType "initialSectionType" >
<!ENTITY % level "level" >
<!ENTITY % mapType "mapType" >
<!ENTITY % outputclass "outputclass" >
<!ENTITY % prologType "prologType" >
<!ENTITY % putValueIn "putValueIn" >
<!ENTITY % sectionType "sectionType" >
<!ENTITY % structureType "structureType" >
<!ENTITY % tagName "tagName" >
<!ENTITY % topicDoc "topicDoc" >
<!ENTITY % topicrefType "topicrefType" >
<!ENTITY % topicType "topicType" >
<!ENTITY % topicZone "topicZone" >
<!ENTITY % topicOutputclass "topicOutputclass" >
<!ENTITY % useAsTitle "useAsTitle" >
<!ENTITY % useContent "useContent" >

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>

<!-- ============================================================= -->
<!--                    COMMON ATTLIST SETS                        -->
<!-- ============================================================= -->

<!ENTITY % required-keys-att
  "keys
      NMTOKENS
      #REQUIRED
  "
>

<!ENTITY % optional-keys-att
  "keys
      NMTOKENS
      #IMPLIED
  "
>



<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!--                    LONG NAME: pub Map                        -->
<!ENTITY % style2tagmap.content
  "((%title;),
    (%documentation;)?,
    (%outputs;)?,
    (%styleset;)
    )"
>
<!ENTITY % style2tagmap.attributes
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
<!ELEMENT style2tagmap    %style2tagmap.content;>
<!ATTLIST style2tagmap    
              %style2tagmap.attributes;
              %arch-atts;
              domains 
                        CDATA 
                                  '&included-domains;'
>

<!ENTITY %  documentation.content
  "((%topicmeta;)?,
   (%topicref;)*)
  "
>
<!ENTITY % documentation.attributes
             "id 
                        ID 
                                  #IMPLIED
              %optional-keys-att;
              %conref-atts;
              anchorref 
                        CDATA 
                                  #IMPLIED
              outputclass 
                        CDATA 
                                  #IMPLIED
              %localization-atts;
              %select-atts;"
>
<!ELEMENT documentation %documentation.content; >
<!ATTLIST documentation
  %documentation.attributes;
>

<!ENTITY %  outputs.content
  "((%topicmeta;)?,
    (%documentation;)?,
    (%output;)*)
  "
>
<!ENTITY % outputs.attributes
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
              %select-atts;"
>
<!ELEMENT outputs %outputs.content; >
<!ATTLIST outputs
  %outputs.attributes;
>

<!ENTITY %  output.content
  "((%outputdef;),
    (%documentation;)?
  )
  "
>
<!ENTITY % output.attributes
             "id 
                        ID 
                                  #IMPLIED
              %required-keys-att;
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
<!ELEMENT output %output.content; >
<!ATTLIST output
  %output.attributes;
>

<!ENTITY %  outputdef.content
  "((%doctype-public;)?,
    (%doctype-system;)?,
    (%documentation;)?
   )
  "
>
<!ENTITY % outputdef.attributes
             "id 
                        ID 
                                  #IMPLIED
              %conref-atts;
              %localization-atts;
              %select-atts;"
>
<!ELEMENT outputdef %outputdef.content; >
<!ATTLIST outputdef
  %outputdef.attributes;
>

<!ENTITY %  styleset.content
  "((%topicmeta;)?,
    (%documentation;)?,
    ((%style;)* |
     (%styleset;)*))
  "
>
<!ENTITY % styleset.attributes
             "id 
                        ID 
                                  #IMPLIED
              %optional-keys-att;
              %conref-atts;
              anchorref 
                        CDATA 
                                  #IMPLIED
              stylesetclass 
                        CDATA 
                                  #IMPLIED
              %localization-atts;
              %select-atts;"
>
<!ELEMENT styleset %styleset.content; >
<!ATTLIST styleset
  %styleset.attributes;
>

<!ENTITY %  style.content
  "((%styledef;),
    (%documentation;)?
   )
  "
>
<!ENTITY % style.attributes
             "id 
                        ID 
                                  #IMPLIED
              %optional-keys-att;
              %conref-atts;
              anchorref 
                        CDATA 
                                  #IMPLIED
              stylesetclass 
                        CDATA 
                                  #IMPLIED
              %localization-atts;
              %topicref-atts;
              %select-atts;"
>
<!ELEMENT style %style.content; >
<!ATTLIST style
  %style.attributes;
>

<!ENTITY %  styledef.content
  "((%baseClass;)?,
    (%bodyType;)?,
    (%chunk;)?,
    (%containerOutputclass;)?,
    (%containerType;)?,
    (%containingTopic;)?,
    (%dataName;)?,
    (%format;)?,
    (%initialSectionType;)?,
    (%level;)?,
    (%mapType;)?,
    (%outputclass;)?,
    (%prologType;)?,
    (%putValueIn;)?,
    (%sectionType;)?,
    (%structureType;)?,
    (%tagName;)?,
    (%topicDoc;)?,
    (%topicrefType;)?,
    (%topicType;)?,
    (%topicZone;)?,
    (%topicOutputclass;)?,
    (%useAsTitle;)?,
    (%useContent;)?

   )
  "
>
<!ENTITY % styledef.attributes
             "id 
                        ID 
                                  #IMPLIED
              %conref-atts;
              %localization-atts;
              %select-atts;"
>
<!ELEMENT styledef %styledef.content; >
<!ATTLIST styledef
  %outputdef.attributes;
>



<!ENTITY % doctype-system.content
 "(#PCDATA)*"
>
<!ENTITY % doctype-system.attributes
  "name  NMTOKEN #FIXED 'doctype-system'"
>
<!ELEMENT doctype-system %doctype-system.content; >
<!ATTLIST doctype-system
  %doctype-system.attributes;
>

<!ENTITY % doctype-public.content
 "(#PCDATA)*"
>
<!ENTITY % doctype-public.attributes
  "name  NMTOKEN #FIXED 'doctype-public'"
>
<!ELEMENT doctype-public %doctype-public.content; >
<!ATTLIST doctype-public
  %doctype-public.attributes;
>

<!ENTITY % styleId.content
 "(#PCDATA)*"
>
<!ENTITY % styleId.attributes
  "name  NMTOKEN #FIXED 'styleId'"
>
<!ELEMENT styleId %styleId.content; >
<!ATTLIST styleId
  %styleId.attributes;
>

<!ENTITY % structureType.content
 "(#PCDATA)*"
>
<!ENTITY % structureType.attributes
  "name  NMTOKEN #FIXED 'structureType'"
>
<!ELEMENT structureType %structureType.content; >
<!ATTLIST structureType
  %structureType.attributes;
>

<!ENTITY % tagName.content
 "(#PCDATA)*"
>
<!ENTITY % tagName.attributes
  "name  NMTOKEN #FIXED 'tagName'"
>
<!ELEMENT tagName %tagName.content; >
<!ATTLIST tagName
  %tagName.attributes;
>

<!ENTITY % format.content
 "(#PCDATA)*"
>
<!ENTITY % format.attributes
  "name  NMTOKEN #FIXED 'format'"
>
<!ELEMENT format %format.content; >
<!ATTLIST format
  %format.attributes;
>

<!ENTITY % mapType.content
 "(#PCDATA)*"
>
<!ENTITY % mapType.attributes
  "name  NMTOKEN #FIXED 'mapType'"
>
<!ELEMENT mapType %mapType.content; >
<!ATTLIST mapType
  %mapType.attributes;
>

<!ENTITY % prologType.content
 "(#PCDATA)*"
>
<!ENTITY % prologType.attributes
  "name  NMTOKEN #FIXED 'prologType'"
>
<!ELEMENT prologType %prologType.content; >
<!ATTLIST prologType
  %prologType.attributes;
>

<!ENTITY % level.content
 "(#PCDATA)*"
>
<!ENTITY % level.attributes
  "name  NMTOKEN #FIXED 'level'"
>
<!ELEMENT level %level.content; >
<!ATTLIST level
  %level.attributes;
>

<!ENTITY % baseClass.content
 "(#PCDATA)*"
>
<!ENTITY % baseClass.attributes
  "name  NMTOKEN #FIXED 'baseClass'"
>
<!ELEMENT baseClass %baseClass.content; >
<!ATTLIST baseClass
  %baseClass.attributes;
>

<!ENTITY % containingTopic.content
 "(#PCDATA)*"
>
<!ENTITY % containingTopic.attributes
  "name  NMTOKEN #FIXED 'containingTopic'"
>
<!ELEMENT containingTopic %containingTopic.content; >
<!ATTLIST containingTopic
  %containingTopic.attributes;
>

<!ENTITY % topicZone.content
 "(#PCDATA)*"
>
<!ENTITY % topicZone.attributes
  "name  NMTOKEN #FIXED 'topicZone'"
>
<!ELEMENT topicZone %topicZone.content; >
<!ATTLIST topicZone
  %topicZone.attributes;
>

<!ENTITY % putValueIn.content
 "(#PCDATA)*"
>
<!ENTITY % putValueIn.attributes
  "name  NMTOKEN #FIXED 'putValueIn'"
>
<!ELEMENT putValueIn %putValueIn.content; >
<!ATTLIST putValueIn
  %putValueIn.attributes;
>

<!ENTITY % bodyType.content
 "(#PCDATA)*"
>
<!ENTITY % bodyType.attributes
  "name  NMTOKEN #FIXED 'bodyType'"
>
<!ELEMENT bodyType %bodyType.content; >
<!ATTLIST bodyType
  %bodyType.attributes;
>

<!ENTITY % chunk.content
 "(#PCDATA)*"
>
<!ENTITY % chunk.attributes
  "name  NMTOKEN #FIXED 'chunk'"
>
<!ELEMENT chunk %chunk.content; >
<!ATTLIST chunk
  %chunk.attributes;
>

<!ENTITY % topicDoc.content
 "(#PCDATA)*"
>
<!ENTITY % topicDoc.attributes
  "name  NMTOKEN #FIXED 'topicDoc'"
>
<!ELEMENT topicDoc %topicDoc.content; >
<!ATTLIST topicDoc
  %topicDoc.attributes;
>

<!ENTITY % topicType.content
 "(#PCDATA)*"
>
<!ENTITY % topicType.attributes
  "name  NMTOKEN #FIXED 'topicType'"
>
<!ELEMENT topicType %topicType.content; >
<!ATTLIST topicType
  %topicType.attributes;
>

<!ENTITY % topicrefType.content
 "(#PCDATA)*"
>
<!ENTITY % topicrefType.attributes
  "name  NMTOKEN #FIXED 'topicrefType'"
>
<!ELEMENT topicrefType %topicrefType.content; >
<!ATTLIST topicrefType
  %topicrefType.attributes;
>

<!ENTITY % dataName.content
 "(#PCDATA)*"
>
<!ENTITY % dataName.attributes
  "name  NMTOKEN #FIXED 'dataName'"
>
<!ELEMENT dataName %dataName.content; >
<!ATTLIST dataName
  %dataName.attributes;
>

<!ENTITY % initialSectionType.content
 "(#PCDATA)*"
>
<!ENTITY % initialSectionType.attributes
  "name  NMTOKEN #FIXED 'initialSectionType'"
>
<!ELEMENT initialSectionType %initialSectionType.content; >
<!ATTLIST initialSectionType
  %initialSectionType.attributes;
>

<!ENTITY % outputclass.content
 "(#PCDATA)*"
>
<!ENTITY % outputclass.attributes
  "name  NMTOKEN #FIXED 'outputclass'"
>
<!ELEMENT outputclass %outputclass.content; >
<!ATTLIST outputclass
  %outputclass.attributes;
>

<!ENTITY % topicOutputclass.content
 "(#PCDATA)*"
>
<!ENTITY % topicOutputclass.attributes
  "name  NMTOKEN #FIXED 'topicOutputclass'"
>
<!ELEMENT topicOutputclass %topicOutputclass.content; >
<!ATTLIST topicOutputclass
  %topicOutputclass.attributes;
>

<!ENTITY % sectionType.content
 "(#PCDATA)*"
>
<!ENTITY % sectionType.attributes
  "name  NMTOKEN #FIXED 'sectionType'"
>
<!ELEMENT sectionType %sectionType.content; >
<!ATTLIST sectionType
  %sectionType.attributes;
>

<!ENTITY % useAsTitle.content
 "(#PCDATA)*"
>
<!ENTITY % useAsTitle.attributes
  "name  NMTOKEN #FIXED 'useAsTitle'"
>
<!ELEMENT useAsTitle %useAsTitle.content; >
<!ATTLIST useAsTitle
  %useAsTitle.attributes;
>

<!ENTITY % containerType.content
 "(#PCDATA)*"
>
<!ENTITY % containerType.attributes
  "name  NMTOKEN #FIXED 'containerType'"
>
<!ELEMENT containerType %containerType.content; >
<!ATTLIST containerType
  %containerType.attributes;
>

<!ENTITY % containerOutputclass.content
 "(#PCDATA)*"
>
<!ENTITY % containerOutputclass.attributes
  "name  NMTOKEN #FIXED 'containerOutputclass'"
>
<!ELEMENT containerOutputclass %containerOutputclass.content; >
<!ATTLIST containerOutputclass
  %containerOutputclass.attributes;
>

<!ENTITY % useContent.content
 "(#PCDATA)*"
>
<!ENTITY % useContent.attributes
  "name  NMTOKEN #FIXED 'useContent'"
>
<!ELEMENT useContent %useContent.content; >
<!ATTLIST useContent
  %useContent.attributes;
>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST style2tagmap  %global-atts; class CDATA "- map/map      style2tagmap/style2tagmap ">
<!ATTLIST documentation %global-atts; class CDATA "- map/topicref style2tagmap/documentation ">
<!ATTLIST outputs       %global-atts; class CDATA "- map/topicref style2tagmap/outputs ">
<!ATTLIST output        %global-atts; class CDATA "- map/topicref style2tagmap/output ">
<!ATTLIST outputdef     %global-atts; class CDATA "- map/topicmeta style2tagmap/outputdef ">
<!ATTLIST styleset      %global-atts; class CDATA "- map/topicref style2tagmap/styleset ">
<!ATTLIST style         %global-atts; class CDATA "- map/topicref style2tagmap/style ">
<!ATTLIST styledef      %global-atts; class CDATA "- map/topicmeta style2tagmap/styledef ">

<!ATTLIST doctype-system %global-atts; class CDATA "- topic/data style2tagmap/doctype-system " >
<!ATTLIST doctype-public %global-atts; class CDATA "- topic/data style2tagmap/doctype-public " >

<!ATTLIST baseClass %global-atts; class CDATA "- topic/data style2tagmap/baseClass " >
<!ATTLIST bodyType %global-atts; class CDATA "- topic/data style2tagmap/bodyType " >
<!ATTLIST chunk %global-atts; class CDATA "- topic/data style2tagmap/chunk " >
<!ATTLIST containerOutputclass %global-atts; class CDATA "- topic/data style2tagmap/containerOutputclass " >
<!ATTLIST containerType %global-atts; class CDATA "- topic/data style2tagmap/containerType " >
<!ATTLIST containingTopic %global-atts; class CDATA "- topic/data style2tagmap/containingTopic " >
<!ATTLIST dataName %global-atts; class CDATA "- topic/data style2tagmap/dataName " >
<!ATTLIST format %global-atts; class CDATA "- topic/data style2tagmap/format " >
<!ATTLIST initialSectionType %global-atts; class CDATA "- topic/data style2tagmap/initialSectionType " >
<!ATTLIST level %global-atts; class CDATA "- topic/data style2tagmap/level " >
<!ATTLIST mapType %global-atts; class CDATA "- topic/data style2tagmap/mapType " >
<!ATTLIST outputclass %global-atts; class CDATA "- topic/data style2tagmap/outputclass " >
<!ATTLIST prologType %global-atts; class CDATA "- topic/data style2tagmap/prologType " >
<!ATTLIST putValueIn %global-atts; class CDATA "- topic/data style2tagmap/putValueIn " >
<!ATTLIST sectionType %global-atts; class CDATA "- topic/data style2tagmap/sectionType " >
<!ATTLIST structureType %global-atts; class CDATA "- topic/data style2tagmap/structureType " >
<!ATTLIST tagName %global-atts; class CDATA "- topic/data style2tagmap/tagName " >
<!ATTLIST topicDoc %global-atts; class CDATA "- topic/data style2tagmap/topicDoc " >
<!ATTLIST topicrefType %global-atts; class CDATA "- topic/data style2tagmap/topicrefType " >
<!ATTLIST topicType %global-atts; class CDATA "- topic/data style2tagmap/topicType " >
<!ATTLIST topicZone %global-atts; class CDATA "- topic/data style2tagmap/topicZone " >
<!ATTLIST topicOutputclass %global-atts; class CDATA "- topic/data style2tagmap/topicOutputclass " >
<!ATTLIST useAsTitle %global-atts; class CDATA "- topic/data style2tagmap/useAsTitle " >
<!ATTLIST useContent %global-atts; class CDATA "- topic/data style2tagmap/useContent " >
<!-- ================== End style2tagmap map ============================= -->
