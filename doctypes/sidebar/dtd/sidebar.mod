<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Sidebar Topic Type Module
     
     Represents a sidebar within a publication.
     
     Specializes from topic.
     
     Copyright (c) 2009 DITA For Publishers.

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


<!ENTITY % sidebar-info-types 
  "%info-types; |
   subsection
  "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % sidebar      "sidebar"                           >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % sidebar.content "       
  ((%title;), 
   (%titlealts;)?,
   (%abstract; | 
    %shortdesc;)?, 
   (%prolog;)?, 
   (%body;)?, 
   (%related-links;)?,
   (%sidebar-info-types;)* )                   
">
<!ENTITY % sidebar.attributes '        
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
'>
<!ELEMENT sidebar %sidebar.content; >
<!ATTLIST sidebar %sidebar.attributes; >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST sidebar      %global-atts;  class CDATA "- topic/topic sidebar/sidebar ">

<!-- ================== End sidebar  ======================== -->