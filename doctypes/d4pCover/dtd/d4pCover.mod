<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Cover Topic Type Module
     
     Represents a cover within a publication.
     
     Specializes from topic
     
     Copyright (c) 2010 DITA For Publishers

     ============================================================= -->

<!-- =============================================================
     Non-DITA Namespace declarations: 
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
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->


<!ENTITY % d4pCover-info-types 
  ""
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % d4pCover     "d4pCover"                           >
<!ENTITY % d4pCoverTitle "d4pCoverTitle"                           >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % d4pCover.content 
 "((%d4pCoverTitle;), 
   (%titlealts;)?,
   (%abstract; |
    %shortdesc;)?, 
   (%prolog;)?, 
   (%body;)?, 
   (%related-links;)?,
   (%d4pCover-info-types;)* )
 ">
 <!ENTITY % d4pCover.attributes
 '  id         
    ID                               
    #REQUIRED
  conref     
    CDATA                            
    #IMPLIED
  %select-atts;
  %localization-atts;
  %arch-atts;
  outputclass 
    CDATA                            
    #IMPLIED
  domains    
    CDATA                
    "&included-domains;"    
'>
<!ELEMENT d4pCover %d4pCover.content; > 
<!ATTLIST d4pCover %d4pCover.attributes;>


<!-- The d4pCoverTitle element is empty, signifying that covers
     do not have display titles in the main body of the publication
     but may have navigation and search titles.
  -->
<!ENTITY % d4pCoverTitle.content
  "EMPTY"
>
<!ENTITY % d4pCoverTitle.attributes
  " %univ-atts;"
>

<!ELEMENT d4pCoverTitle %d4pCoverTitle.content; >
<!ATTLIST d4pCoverTitle %d4pCoverTitle.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST d4pCover      %global-atts;  class CDATA "- topic/topic d4pCover/d4pCover ">
<!ATTLIST d4pCoverTitle %global-atts;  class CDATA "- topic/title d4pCover/d4pCoverTitle ">

<!-- ================== End Declaration Set  ===================== -->