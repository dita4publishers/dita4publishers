<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Article Topic Type Module
     
     Represents an article within a serial publication.
     
     Specializes from topic
     
     Copyright (c) 2009 DITA For Publishers

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


<!ENTITY % article-info-types 
  "subsection
     "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % article      "article"                           >
<!ENTITY % deck         "deck" >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ELEMENT article       
  ((%title;), 
   (%titlealts;)?,
   (%abstract; | 
    %deck;)?, 
   (%prolog;)?, 
   (%body;)?, 
   (%related-links;)?,
   (%article-info-types;)* )                   
>
<!ATTLIST article        
  id         
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
>

<!ELEMENT deck
 (%title.cnt; |
  %draft-comment;)*
>
<!ATTLIST deck
  %univ-atts;
>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST article      %global-atts;  class CDATA "- topic/topic article/article ">
<!ATTLIST deck         %global-atts;  class CDATA "- topic/shortdesc article/deck ">

<!-- ================== End Declaration Set  ===================== -->