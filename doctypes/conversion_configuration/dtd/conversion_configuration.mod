<?xml version="1.0" encoding="UTF-8"?>
<!-- =============================================================
     Copyright 2011 DITA for Publishers
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ARCHITECTURE ENTITIES                       -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->


<!ENTITY % conversion_configuration-info-types 
  "%info-types;
  "
>


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->
 

<!ENTITY % conversion_configuration      "conversion_configuration"                            >
<!ENTITY % conversion_configuration_body "conversion_configuration_body"                       >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!--                    LONG NAME: Author Information              -->
<!ENTITY % conversion_configuration.content
                       "((%title;), 
                         (%titlealts;)?,
                         (%abstract; | 
                          %shortdesc;)?, 
                         (%prolog;)?, 
                         (%conversion_configuration_body;)?, 
                         (%related-links;)?,
                         (%conversion_configuration-info-types;)* )"
>
<!ENTITY % conversion_configuration.attributes
             "id 
                        ID 
                                  #REQUIRED
              %conref-atts;
              %select-atts;
              %localization-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT conversion_configuration    %conversion_configuration.content;>
<!ATTLIST conversion_configuration    
              %conversion_configuration.attributes;
              %arch-atts;
              domains 
                        CDATA 
                                  "&included-domains;">



<!--                    LONG NAME: Author Info Body                    -->
<!ENTITY % conversion_configuration_body.content
                       "(section*,
                         word2xmlOptions,
                         xml2InDesignOptions,
                         otherOptions?)"
>
<!ENTITY % conversion_configuration_body.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT conversion_configuration_body    %conversion_configuration_body.content;>
<!ATTLIST conversion_configuration_body    %conversion_configuration_body.attributes;>

<!ENTITY % word2xmlOptions.content
  "(optionSet)"
>
<!ENTITY % word2xmlOptions.attributes
             "spectitle 
                        CDATA 
                                 'Word to XML Options'
              %id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT word2xmlOptions %word2xmlOptions.content; >
<!ATTLIST word2xmlOptions %word2xmlOptions.attributes; >

<!ENTITY % xml2InDesignOptions.content
  "(optionSet)"
>
<!ENTITY % xml2InDesignOptions.attributes
             "spectitle 
                        CDATA 
                                 'XML to InDesign Options'
%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT xml2InDesignOptions %xml2InDesignOptions.content; >
<!ATTLIST xml2InDesignOptions %xml2InDesignOptions.attributes; >

<!ENTITY % otherOptions.content
  "(optionSet)"
>
<!ENTITY % otherOptions.attributes
             "spectitle 
                        CDATA 
                                 'Other Options'
%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT otherOptions %otherOptions.content; >
<!ATTLIST otherOptions %otherOptions.attributes; >

<!ENTITY % optionSet.content
  "(option*)"
>
<!ENTITY % optionSet.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT optionSet %optionSet.content; >
<!ATTLIST optionSet %optionSet.attributes; >

<!ENTITY % option.content
  "(optionName, 
    (optionValue | 
     optionValueMap))"
>
<!ENTITY % option.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT option %option.content; >
<!ATTLIST option %option.attributes; >

<!ENTITY % optionName.content
  "(#PCDATA)"
>
<!ENTITY % optionName.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT optionName %optionName.content; >
<!ATTLIST optionName %optionName.attributes; >

<!ENTITY % optionValue.content
  "(#PCDATA)"
>
<!ENTITY % optionValue.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT optionValue %optionValue.content; >
<!ATTLIST optionValue %optionValue.attributes; >

<!ENTITY % optionValueMap.content
  "(valueMap)"
>
<!ENTITY % optionValueMap.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT optionValueMap %optionValueMap.content; >
<!ATTLIST optionValueMap %optionValueMap.attributes; >

<!ENTITY % valueMap.content
  "(valueMapEntry)*"
>
<!ENTITY % valueMap.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT valueMap %valueMap.content; >
<!ATTLIST valueMap %valueMap.attributes; >

<!ENTITY % valueMapEntry.content
  "(valueKey, 
    (optionValue |
     optionValueMap))"
>
<!ENTITY % valueMapEntry.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT valueMapEntry %valueMapEntry.content; >
<!ATTLIST valueMapEntry %valueMapEntry.attributes; >

<!ENTITY % valueKey.content
  "(#PCDATA)"
>
<!ENTITY % valueKey.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT valueKey %valueKey.content; >
<!ATTLIST valueKey %valueKey.attributes; >


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST conversion_configuration      %global-atts;  class CDATA "- topic/topic conversion_configuration/conversion_configuration ">
<!ATTLIST conversion_configuration_body %global-atts;  class CDATA "- topic/body  conversion_configuration/conversion_configuration_body ">

<!ATTLIST xml2InDesignOptions      %global-atts;  class CDATA "- topic/section conversion_configuration/xml2InDesignOptions ">

<!ATTLIST word2xmlOptions      %global-atts;  class CDATA "- topic/section conversion_configuration/word2xmlOptions ">

<!ATTLIST otherOptions      %global-atts;  class CDATA "- topic/section conversion_configuration/otherOptions ">

<!ATTLIST optionSet      %global-atts;  class CDATA "- topic/dl conversion_configuration/optionSet ">
<!ATTLIST option         %global-atts;  class CDATA "- topic/dlentry conversion_configuration/option ">
<!ATTLIST optionName     %global-atts;  class CDATA "- topic/dt conversion_configuration/optionName ">
<!ATTLIST optionValue    %global-atts;  class CDATA "- topic/dd conversion_configuration/optionValue ">
<!ATTLIST optionValueMap %global-atts;  class CDATA "- topic/dd conversion_configuration/optionValueMap ">

<!ATTLIST valueMap       %global-atts;  class CDATA "- topic/dl conversion_configuration/valueMap ">
<!ATTLIST valueMapEntry  %global-atts;  class CDATA "- topic/dlentry conversion_configuration/valueMapEntry ">
<!ATTLIST valueKey       %global-atts;  class CDATA "- topic/dt conversion_configuration/valueKey ">

<!-- ================== End DITA Conversion Configuration  ======================== -->