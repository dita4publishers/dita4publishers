<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Content Domain
     
     Specializations of topic content elements that provide common
     publication components that are semantic and not strictly
     formatting.
     
     Copyright (c) 2009, 2012 DITA For Publishers
     
     ============================================================= -->

<!-- From: http://www.wsu.edu/~brians/errors/epigram.html 

An epigram is a pithy saying, usually humorous. 

An epigraph is a brief quotation used to introduce a piece of writing 
 (see http://www.wsu.edu/~brians/errors/callsfor.html#epigraph) 
 or the inscription on a statue or building.

-->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!ENTITY % body-pullquote        "body-pullquote" >
<!ENTITY % epigram               "epigram" >
<!ENTITY % epigraph              "epigraph"                      >
<!ENTITY % epigraph-attribution  "epigraph-attribution"          >
<!ENTITY % section-pullquote     "section-pullquote" >
<!ENTITY % d4pAttributedQuote    "d4pAttributedQuote" >
<!ENTITY % d4pQuoteAttribution   "d4pQuoteAttribution" >
<!ENTITY % d4pAssetSource        "d4pAssetSource" >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!-- Epigram: Quote used to introduce a chapter or section. -->
<!ENTITY % epigram.content
 "(%para.cnt;)*"
>
<!ENTITY % epigram.attributes
 '
 '
>
<!ELEMENT epigram %epigram.content; >
<!ATTLIST epigram %epigram.attributes; >

<!-- An epigram is a pithy saying, usually humorous. -->
<!ENTITY % epigraph.content
  "((%body.cnt;)+,
    (%epigraph-attribution; |
     %d4pQuoteAttribution;)?)"
>
<!ENTITY % epigraph.attributes
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
<!ELEMENT epigraph    %epigraph.content;>
<!ATTLIST epigraph    %epigraph.attributes;>

<!ENTITY % epigraph-attribution.content
  "(%para.cnt;)*"
>
<!ENTITY % epigraph-attribution.attributes
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
<!ELEMENT epigraph-attribution    %epigraph-attribution.content;>
<!ATTLIST epigraph-attribution    %epigraph-attribution.attributes;>

<!ENTITY % body-pullquote.content
  "(%bodydiv.cnt;)*"
>
<!ENTITY % body-pullquote.attributes
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
<!ELEMENT body-pullquote    %body-pullquote.content;>
<!ATTLIST body-pullquote    %body-pullquote.attributes;>

<!ENTITY % section-pullquote.content
  "(%sectiondiv.cnt;)*"
>
<!ENTITY % section-pullquote.attributes
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
<!ELEMENT section-pullquote    %section-pullquote.content;>
<!ATTLIST section-pullquote    %section-pullquote.attributes;>

<!-- A long quote that has an attribution. -->
<!-- NOTE Content model copies definition from %longquote.cnt;.

     For reasons I haven't yet determined, referencing %longquote.cnt;
     here does not work. Must be an issue with order of inclusion or
     reference or a non-obvious coding error on my part.

-->
<!ENTITY % d4pAttributedQuote.content 
  "((p|
     ul|
     ol
     )+,
    (%d4pQuoteAttribution;))
  "
>
<!ENTITY % d4pAttributedQuote.attributes
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
<!ELEMENT d4pAttributedQuote    %d4pAttributedQuote.content;>
<!ATTLIST d4pAttributedQuote    %d4pAttributedQuote.attributes;>

<!ENTITY % d4pQuoteAttribution.content
  "(%para.cnt;)*"
>
<!ENTITY % d4pQuoteAttribution.attributes
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
<!ELEMENT d4pQuoteAttribution    %d4pQuoteAttribution.content;>
<!ATTLIST d4pQuoteAttribution    %d4pQuoteAttribution.attributes;>

<!-- Describes the source of an asset (quote, graphic, photo,
     media object, etc.) -->
<!ENTITY % d4pAssetSource.content
  "(%para.cnt;)*"
>
<!ENTITY % d4pAssetSource.attributes
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
<!ELEMENT d4pAssetSource    %d4pAssetSource.content;>
<!ATTLIST d4pAssetSource    %d4pAssetSource.attributes;>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST epigram                %global-atts;  class CDATA "+ topic/p          d4p-pubcontent-d/epigram ">

<!ATTLIST body-pullquote         %global-atts;  class CDATA "+ topic/bodydiv    d4p-pubcontent-d/body-pullquote ">
<!ATTLIST section-pullquote      %global-atts;  class CDATA "+ topic/sectiondiv d4p-pubcontent-d/section-pullquote ">

<!ATTLIST epigraph               %global-atts;  class CDATA "+ topic/bodydiv    d4p-pubcontent-d/epigraph ">
<!ATTLIST epigraph-attribution   %global-atts;  class CDATA "+ topic/p          d4p-pubcontent-d/epigraph-attribution ">
<!ATTLIST epigram                %global-atts;  class CDATA "+ topic/bodydiv    d4p-pubcontent-d/epigram ">
<!ATTLIST epigram-attribution    %global-atts;  class CDATA "+ topic/p          d4p-pubcontent-d/epigram-attribution ">


<!ATTLIST d4pAttributedQuote     %global-atts;  class CDATA "+ topic/lq         d4p-pubcontent-d/d4pAttributedQuote ">
<!ATTLIST d4pQuoteAttribution    %global-atts;  class CDATA "+ topic/p          d4p-pubcontent-d/d4pQuoteAttribution ">
<!ATTLIST d4pAssetSource         %global-atts;  class CDATA "+ topic/p          d4p-pubcontent-d/d4pAssetSource ">

<!-- ================== End Content Domain ==================== -->