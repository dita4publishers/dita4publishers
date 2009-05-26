<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Scene Topic Type Module
     
     Represents a prologue within a Shakespear play.
     
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


<!ENTITY % prologue-info-types 
  "no-topic-nesting
  "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % prologue      "prologue"                           >
<!ENTITY % prologue-body "prologue-body"                       >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ELEMENT prologue       
  ((%title;), 
   (%titlealts;)?,
   (%abstract;)?, 
   (%prologue-body;),
   (%prolog;)?, 
   (%related-links;)?,
   (%prologue-info-types;)* )                   
>
<!ATTLIST prologue        
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

<!ENTITY %  prologue-body.content 
  "(%speech; | 
    %stagedir; | 
    %subhead;)*"
>
<!ENTITY %  prologue-body.attributes 
  "
  %univ-atts;
  "
>
<!ELEMENT prologue-body %prologue-body.content; >
<!ATTLIST prologue-body %prologue-body.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST prologue      %global-atts;  class CDATA "- topic/topic play-component/play-component prologue/prologue ">
<!ATTLIST prologue-body %global-atts;  class CDATA "- topic/body  play-component/play-component-body prologue/prologue-body ">

<!-- ================== End Declaration Set  ===================== -->