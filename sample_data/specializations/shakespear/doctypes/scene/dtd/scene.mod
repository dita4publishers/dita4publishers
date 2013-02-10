<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Scene Topic Type Module
     
     Represents a scene within a Shakespear play.
     
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


<!ENTITY % scene-info-types 
  "no-topic-nesting
  "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % scene      "scene"                           >
<!ENTITY % scene-body "scene-body"                       >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ELEMENT scene       
  ((%title;), 
   (%titlealts;)?,
   (%abstract;)?, 
   (%scene-body;),
   (%prolog;)?, 
   (%related-links;)?,
   (%scene-info-types;)* )                   
>
<!ATTLIST scene        
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

<!ENTITY %  scene-body.content 
  "(%speech; | 
    %stagedir; | 
    %subhead;)*"
>
<!ENTITY %  scene-body.attributes 
  "
  %univ-atts;
  "
>
<!ELEMENT scene-body %scene-body.content; >
<!ATTLIST scene-body %scene-body.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST scene      %global-atts;  class CDATA "- topic/topic play-component/play-component scene/scene ">
<!ATTLIST scene-body %global-atts;  class CDATA "- topic/body  play-component/body           scene/scene-body ">

<!-- ================== End Declaration Set  ===================== -->