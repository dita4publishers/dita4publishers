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


<!ENTITY % ruby.content
"
  ((%rb;) |
   (%rp;) |
   (%rt;)
  )*
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
    'ruby'    
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
    'ruby'    
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
    'ruby'    
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