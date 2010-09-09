<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Generic Subsection Topic Type Module
     
     Represents a subsection within a publication. May be nested as
     needed.
     
     Specializes from topic.
     
     Copyright (c) 2009, 2010 DITA For Publishers.

     ============================================================= -->

<!-- =============================================================
     Non-DITA Namespace declarations: 
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->


<!ENTITY % subsection-info-types 
  "%info-types; |
   subsection
  "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % subsection     "subsection"                           >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ENTITY % subsection.content "       
  ((%title;), 
   (%titlealts;)?,
   (%abstract; | 
    %shortdesc;)?, 
   (%prolog;)?, 
   (%body;)?, 
   (%related-links;)?,
   (%subsection-info-types;)* )                   
">
<!ENTITY % subsection.attributes '        
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
<!ELEMENT subsection %subsection.content; >
<!ATTLIST subsection %subsection.attributes; >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST subsection     %global-atts;  class CDATA "- topic/topic subsection/subsection ">

<!-- ================== End subsection  ======================== -->