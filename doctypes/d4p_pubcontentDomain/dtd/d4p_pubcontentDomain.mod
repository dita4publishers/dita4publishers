<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Content Domain
     
     Specializations of topic content elements that provide common
     publication components that are semantic and not strictly
     formatting.
     
     Copyright (c) 2009 DITA For Publishers
     
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


<!ENTITY % epigram "epigram" >
<!ENTITY % epigraph              "epigraph"                      >
<!ENTITY % epigraph-attribution  "epigraph-attribution"          >


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

<!ENTITY % epigraph.content
  "((%body.cnt;)+,
    (%epigraph-attribution;)?)"
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



<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST epigram                %global-atts;  class CDATA "+ topic/p    d4p-pubcontent-d/epigram ">

<!ATTLIST epigraph               %global-atts;  class CDATA "- topic/bodydiv d4p-pubcontent-d/epigraph ">
<!ATTLIST epigraph-attribution   %global-atts;  class CDATA "- topic/p       d4p-pubcontent-d/epigraph-attribution ">

<!-- ================== End Content Domain ==================== -->