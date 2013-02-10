<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Ruby Domain
     
     Defines equivalent of HTML ruby elements for marking up
     Japanese language documents.
     
     Copyright (c) 2010 DITA For Publishers
     
     ============================================================= -->
     
 <!ENTITY % ruby           "ruby" >

 <!ENTITY % rb             "rb" >
 <!ENTITY % rp             "rp" >
 <!ENTITY % rt             "rt" >


<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!-- In order to support HTML5, which allows a mix of PCDATA, other phrase-
     level elements, and <rt> and <rp>, the content model must allow
     %ph;, which means that the DTD allows <ruby> within <ruby>. However,
     <ruby> should *not* be used within <ruby>, per the HTML 
     constraints on <ruby>. Likewise, if <rp> is used, it should be
     used as <rp>(</rp><rt>...</rt><rp>)</rp> per the HTML5 spec.
  -->
<!ENTITY % ruby.content
"
  (%ph.cnt; |
   %rb; |
   %rp; |
   %rt;)*
  " 
>
<!ENTITY % ruby.attributes
 "
   %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass 
    CDATA                            
    'ruby'    
 "
> 
<!ELEMENT ruby %ruby.content; >
<!ATTLIST ruby %ruby.attributes; >

<!ENTITY % rb.content
"
  (#PCDATA
  )*
  " 
>
<!ENTITY % rb.attributes
 "
   %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass 
    CDATA                            
    'rb'    
 "
> 
<!ELEMENT rb %rb.content; >
<!ATTLIST rb %rb.attributes; >

<!ENTITY % rp.content
"
  (#PCDATA
  )*
  " 
>
<!ENTITY % rp.attributes
 "
   %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass 
    CDATA                            
    'rp'    
 "
> 
<!ELEMENT rp %rp.content; >
<!ATTLIST rp %rp.attributes; >

<!ENTITY % rt.content
"
  (#PCDATA
  )*
  " 
>
<!ENTITY % rt.attributes
 "
   %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass 
    CDATA                            
    'rt'    
 "
> 
<!ELEMENT rt %rt.content; >
<!ATTLIST rt %rt.attributes; >



<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST ruby              %global-atts;  class CDATA "+ topic/ph    d4p-ruby-d/ruby ">
<!ATTLIST rb                %global-atts;  class CDATA "+ topic/ph    d4p-ruby-d/rb ">
<!ATTLIST rp                %global-atts;  class CDATA "+ topic/ph    d4p-ruby-d/rp ">
<!ATTLIST rt                %global-atts;  class CDATA "+ topic/ph    d4p-ruby-d/rt ">


<!-- ================== End Ruby Domain ==================== -->