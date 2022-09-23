*&---------------------------------------------------------------------*
*& Report z01_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_class.

CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_attribute,
             attribute TYPE string,
             value     TYPE string,
           END OF ts_attribute,

           tt_attributes TYPE STANDARD TABLE OF ts_attribute
                        WITH NON-UNIQUE KEY attribute.

    METHODS set_attributes
      IMPORTING
        iv_name      TYPE string
        iv_planetype TYPE saplane-planetype.

    METHODS get_attributes
      RETURNING
        VALUE(rt_attributes) TYPE tt_attributes.

    METHODS get_n_o_airplanes
      RETURNING
        VALUE(rv_number) TYPE i.
  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: mv_name      TYPE string,
          mv_planetype TYPE saplane-planetype.

    CLASS-DATA gv_n_o_airplane TYPE i.



ENDCLASS.

CLASS lcl_airplane IMPLEMENTATION.

  METHOD get_attributes.
    rt_attributes = VALUE #(
        ( attribute = 'NAME' value = mv_name )
        ( attribute = 'PLANETYPE' value = mv_planetype )
    ).
  ENDMETHOD.

  METHOD set_attributes.
    mv_name = iv_name.
    mv_planetype = iv_planetype.

    gv_n_o_airplane += 1.
  ENDMETHOD.

  METHOD get_n_o_airplanes.
    rv_number = gv_n_o_airplane.
  ENDMETHOD.

ENDCLASS.
