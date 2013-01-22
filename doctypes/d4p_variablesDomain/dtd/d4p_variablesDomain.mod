<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Variables Domain
     
     Defines elements for defining "variables" and variable references
     that are metadata based.
     
     This domain may be used in maps and topics as all of the elements defined
     in it are sensible in both contexts.
     
     WARNING: This domain is entirely experimental. There is no guarantee
     for ongoing support for this domain. The markup details may change
     without warning.
     
     Copyright (c) 2010 DITA For Publishers
     
     ============================================================= -->
     
 <!ENTITY % d4p-variable-definitions "d4p-variable-definitions" >
 <!ENTITY % d4p-variable-definition  "d4p-variable-definition" >
 <!ENTITY % d4p-variable-definition-fallback  "d4p-variable-definition-fallback" >
 <!ENTITY % d4p-variableref_keyword  "d4p-variableref_keyword" >
 <!ENTITY % d4p-variableref_text     "d4p-variableref_text" >



<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!-- A set of variable definitions. The optional title allows for 
     adding a distinguishing title to the variable set.
  -->
<!ENTITY % d4p-variable-definitions.content
"
  ((%title;)?,
   ((%d4p-variable-definition; |
     %d4p-variable-definition-fallback;)* |
    (%d4p-variable-definitions;)*)
  )
  " 
>
<!ENTITY % d4p-variable-definitions.attributes
 "
   %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass
    CDATA
    #IMPLIED
 "
> 
<!ELEMENT d4p-variable-definitions %d4p-variable-definitions.content; >
<!ATTLIST d4p-variable-definitions %d4p-variable-definitions.attributes; >


<!-- Variable Definition:

     Defines a single variable.

     The value of the @name attribute serves as the variable name,
     by which it is referenced from variable-ref elements.
     
     The value of the variable may be specified using either the @value
     attribute or put in content. If there is both content and a @value
     attribute, the content is ignored and the @value attribute is used.
     
     Variable definitions should not be nested.
     
 -->
<!ENTITY % d4p-variable-definition.content
"
  (%data.cnt;)*
  " 
>
<!ENTITY % d4p-variable-definition.attributes
 "
  name
     CDATA
     #REQUIRED
  value
     CDATA
     #IMPLIED
  %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass
    CDATA
    #IMPLIED
 "
> 
<!ELEMENT d4p-variable-definition %d4p-variable-definition.content; >
<!ATTLIST d4p-variable-definition %d4p-variable-definition.attributes; >

<!-- Variable Definition-fallback:

     Defines a single variable to be used as a fallback value within
     topics when no other value of the variable is declared in a higher
     context. When specified in a topic prolog, it defines the fallback
     value for that topic and all of its descendants. The fallback
     value is used if and only if there is no other in-scope definition
     of the same variable name at the point of reference, including
     declarations that occur in the same scope as the fallbck definition.

     The value of the @name attribute serves as the variable name,
     by which it is referenced from variable-ref elements.
     
     The value of the variable may be specified using either the @value
     attribute or put in content. If there is both content and a @value
     attribute, the content is ignored and the @value attribute is used.
     
     Variable definitions should not be nested.
     
 -->
<!ENTITY % d4p-variable-definition-fallback.content
"
  (%data.cnt;)*
  " 
>
<!ENTITY % d4p-variable-definition-fallback.attributes
 "
  name
     CDATA
     #REQUIRED
  value
     CDATA
     #IMPLIED
  %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass
    CDATA
    #IMPLIED
 "
> 
<!ELEMENT d4p-variable-definition-fallback %d4p-variable-definition-fallback.content; >
<!ATTLIST d4p-variable-definition-fallback %d4p-variable-definition-fallback.attributes; >

<!-- Variable Reference: 

     A reference to a variable as defined by a variable definition
     element.
     
     The content of the element is the name of the variable.
     
     Note: Because <text> and <keyword> are not in all contexts, there are
     two variants of this element one from <keyword> and one 
     from <text>. Their semantics and behavior are identical.
     
  -->
<!ENTITY % d4p-variableref_keyword.content
"
  (#PCDATA)*
  " 
>
<!ENTITY % d4p-variableref_keyword.attributes
 "
  %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass
    CDATA
    #IMPLIED
 "
> 
<!ELEMENT d4p-variableref_keyword %d4p-variableref_keyword.content; >
<!ATTLIST d4p-variableref_keyword %d4p-variableref_keyword.attributes; >

<!ENTITY % d4p-variableref_text.content
"
  (#PCDATA)*
  " 
>
<!ENTITY % d4p-variableref_text.attributes
 "
  %id-atts;
  %localization-atts;
  base       
    CDATA                            
    #IMPLIED
  %base-attribute-extensions;
  outputclass
    CDATA
    #IMPLIED
 "
> 
<!ELEMENT d4p-variableref_text %d4p-variableref_text.content; >
<!ATTLIST d4p-variableref_text %d4p-variableref_text.attributes; >




<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST d4p-variable-definitions %global-atts;  class CDATA "+ topic/data    d4p-variables-d/d4p-variable-definitions ">
<!ATTLIST d4p-variable-definition  %global-atts;  class CDATA "+ topic/data    d4p-variables-d/d4p-variable-definition ">
<!ATTLIST d4p-variable-definition-fallback  %global-atts;  class CDATA "+ topic/data    d4p-variables-d/d4p-variable-definition-fallback ">
<!ATTLIST d4p-variableref_keyword  %global-atts;  class CDATA "+ topic/keyword d4p-variables-d/d4p-variableref_keyword ">
<!ATTLIST d4p-variableref_text     %global-atts;  class CDATA "+ topic/text    d4p-variables-d/d4p-variableref_text ">


<!-- ================== End Variables Domain ==================== -->