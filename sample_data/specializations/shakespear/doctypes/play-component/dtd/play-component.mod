<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Play Component Topic Type Module
     
     Base topic types for components of Shakespear plays (act,
     scene, etc.)
     
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


<!ENTITY % play-component-info-types 
  "play-component
     "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % play-component      "play-component"                      >
<!ENTITY % play-component-body "play-component-body"                 >
<!ENTITY % speaker             "speaker"                             >
<!ENTITY % line                "line"                                >
<!ENTITY % speech              "speech"                              >
<!ENTITY % subhead             "subhead"                             >
<!ENTITY % stagedir            "stagedir"                            >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!ELEMENT play-component       
  ((%title;), 
   (%titlealts;)?,
   (%abstract;)?, 
   (%prolog;)?, 
   (%play-component-body;)?, 
   (%related-links;)?,
   (%play-component-info-types;)* )                   
>
<!ATTLIST play-component        
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

<!ENTITY %  play-component-body.content 
  "(%speech; | 
    %stagedir; | 
    %subhead;)*"
>
<!ENTITY %  play-component-body.attributes 
  "
  %univ-atts;
  "
>
<!ELEMENT play-component-body %play-component-body.content; >
<!ATTLIST play-component-body %play-component-body.attributes; >

<!ENTITY %  speech.content 
  "((%speaker;)+, 
    (%line; | 
     %stagedir; | 
     %subhead;)*)"
>
<!ENTITY %  speech.attributes 
  "
  %univ-atts;
  "
>
<!ELEMENT speech %speech.content; >
<!ATTLIST speech %speech.attributes; >

<!ENTITY %  subhead.content 
  "%title.content;"
>
<!ENTITY %  subhead.attributes 
  "
  %univ-atts;
  "
>
<!ELEMENT subhead %subhead.content; >
<!ATTLIST subhead %subhead.attributes; >

<!ENTITY %  speaker.content 
  "%title.content;"
>
<!ENTITY %  speaker.attributes 
  "
  %univ-atts;
  "
>
<!ELEMENT speaker %speaker.content; >
<!ATTLIST speaker %speaker.attributes; >

<!ENTITY %  line.content 
  "(#PCDATA | 
    %stagedir;)*"
>
<!ENTITY %  line.attributes 
  "
  %univ-atts;
  "
>
<!ELEMENT line %line.content; >
<!ATTLIST line %line.attributes; >

<!ENTITY %  stagedir.content 
  "(#PCDATA)*"
>
<!ENTITY %  stagedir.attributes 
  "
  %univ-atts;
  "
>
<!ELEMENT stagedir %stagedir.content; >
<!ATTLIST stagedir %stagedir.attributes; >

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST play-component      %global-atts;  class CDATA "- topic/topic    play-component/play-component ">
<!ATTLIST play-component-body %global-atts;  class CDATA "- topic/body     play-component/play-component-body ">
<!ATTLIST speech              %global-atts;  class CDATA "- topic/section  play-component/speech ">
<!ATTLIST speaker             %global-atts;  class CDATA "- topic/title    play-component/speaker ">
<!ATTLIST subhead             %global-atts;  class CDATA "- topic/title    play-component/subhead ">
<!ATTLIST line                %global-atts;  class CDATA "- topic/ph       play-component/line ">
<!ATTLIST stagedir            %global-atts;  class CDATA "- topic/ph       play-component/stagedir ">

<!-- ================== End Declaration Set  ===================== -->