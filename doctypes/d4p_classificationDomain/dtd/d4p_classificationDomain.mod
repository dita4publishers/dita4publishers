<?xml version="1.0" encoding="utf-8"?>
<!-- =============================================================
     DITA For Publishers Classification Domain
     
     Defines specializations of data for classifying components
     of publications (topics, figures, tables, etc.).
     
     Copyright (c) 2009 DITA For Publishers
     
     ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % classification      "classification" >


<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!ELEMENT classification
  (data*,
   keyword*
  )
>
<!ATTLIST classification
  name
    NMTOKEN
    "classification"
>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST classification   %global-atts;  class CDATA "+ topic/data  d4p-classification-d/classification ">


<!-- ================== End Classification Domain ==================== -->