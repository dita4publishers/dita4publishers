<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Personae Topic Type Module
     
     Represents the personae section within a Shakespear play.
     
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


<!ENTITY % personae-info-types 
  "scene |
   prolog |
   epilog
  "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % personae      "personae"                           >
<!ENTITY % personae-body "personae-body"                      >
<!ENTITY % persona       "persona"                           >
<!ENTITY % pgroup        "pgroup"                           >
<!ENTITY % grpdescr      "grpdescr"                           >

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ELEMENT personae       
  ((%title;), 
   (%titlealts;)?,
   (%abstract;)?, 
   (%prolog;)?, 
   (%personae-body;),
   (%related-links;)?,
   (%personae-info-types;)* )                   
>
<!ATTLIST personae        
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

<!ENTITY % personae-body.content
  "((%persona;) |
    (%pgroup;))+"
>
<!ENTITY % personae-body.attributes
  "%univ-atts;
  "
  >
<!ELEMENT personae-body %personae-body.content; >
<!ATTLIST personae-body %personae-body.attributes; >

<!ENTITY % persona.content
  "%ph.content;"
>
<!ENTITY % persona.attributes
  "%univ-atts;
  "
  >
<!ELEMENT persona %persona.content; >
<!ATTLIST persona %persona.attributes; >

<!ENTITY % pgroup.content
  "((%persona;)+,
    (%grpdescr;))"
>
<!ENTITY % pgroup.attributes
  "%univ-atts;
  "
  >
<!ELEMENT pgroup %pgroup.content; >
<!ATTLIST pgroup %pgroup.attributes; >

<!ENTITY % grpdescr.content
  "%ph.content;"
>
<!ENTITY % grpdescr.attributes
  "%univ-atts;
  "
  >
<!ELEMENT grpdescr %grpdescr.content; >
<!ATTLIST grpdescr %grpdescr.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST personae      %global-atts;  class CDATA "- topic/topic play-component/play-component personae/personae ">
<!ATTLIST personae-body %global-atts;  class CDATA "- topic/body  play-component/body personae/personae-body ">
<!ATTLIST persona       %global-atts;  class CDATA "- topic/p     play-component/p    personae/persona ">
<!ATTLIST pgroup        %global-atts;  class CDATA "- topic/bodydiv play-component/bodydiv personae/pgroup ">
<!ATTLIST grpdescr      %global-atts;  class CDATA "- topic/p     play-component/p    personae/grpdescr ">

<!-- ================== End Declaration Set  ===================== -->