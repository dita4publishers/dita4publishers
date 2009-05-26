<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Scene Topic Type Module
     
     Represents a induct within a Shakespear play.
     
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


<!ENTITY % induct-info-types 
  "scene
  "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % induct      "induct"                           >
<!ENTITY % induct-body "induct-body"                       >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ELEMENT induct       
  ((%title;), 
   (%titlealts;)?,
   (%abstract;)?, 
   (%induct-body;)?,
   (%related-links;)?,
   (%induct-info-types;)* )                   
>
<!ATTLIST induct        
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

<!ENTITY %  induct-body.content 
  "(%speech; | 
    %stagedir; | 
    %subhead;)*"
>
<!ENTITY %  induct-body.attributes 
  "
  %univ-atts;
  "
>
<!ELEMENT induct-body %induct-body.content; >
<!ATTLIST induct-body %induct-body.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST induct      %global-atts;  class CDATA "- topic/topic play-component/play-component induct/induct ">
<!ATTLIST induct-body %global-atts;  class CDATA "- topic/body  play-component/play-component-body induct/induct-body ">

<!-- ================== End Declaration Set  ===================== -->