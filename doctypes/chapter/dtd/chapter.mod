<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Chapter Topic Type Module
     
     Represents a chapter within a book.
     
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


<!ENTITY % chapter-info-types 
  "no-topic-nesting
     "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % chapter      "chapter"                           >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ELEMENT chapter       
  ((%title;), 
   (%titlealts;)?,
   (%abstract; | 
    %shortdesc;)?, 
   (%prolog;)?, 
   (%body;)?, 
   (%related-links;)?,
   (%chapter-info-types;)* )                   
>
<!ATTLIST chapter        
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



<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST chapter      %global-atts;  class CDATA "- topic/topic chapter/chapter ">

<!-- ================== End Declaration Set  ===================== -->