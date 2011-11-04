<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Scene Topic Type Module
     
     Represents a epilogue within a Shakespear play.
     
     Specializes from play-component
     
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


<!ENTITY % epilogue-info-types 
  "no-topic-nesting
  "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % epilogue      "epilogue"                           >
<!ENTITY % epilogue-body "epilogue-body"                       >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ELEMENT epilogue       
  ((%title;), 
   (%titlealts;)?,
   (%abstract;)?, 
   (%epilogue-body;),
   (%prolog;)?, 
   (%related-links;)?,
   (%epilogue-info-types;)* )                   
>
<!ATTLIST epilogue        
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

<!ENTITY %  epilogue-body.content 
  "(%speech; | 
    %stagedir; | 
    %subhead;)*"
>
<!ENTITY %  epilogue-body.attributes 
  "
  %univ-atts;
  "
>
<!ELEMENT epilogue-body %epilogue-body.content; >
<!ATTLIST epilogue-body %epilogue-body.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST epilogue      %global-atts;  class CDATA "- topic/topic play-component/play-component epilogue/epilogue ">
<!ATTLIST epilogue-body %global-atts;  class CDATA "- topic/body play-component/play-component-body epilogue/epilogue-body ">

<!-- ================== End Declaration Set  ===================== -->