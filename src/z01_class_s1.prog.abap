*&---------------------------------------------------------------------*
*& Report z01_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_class_s1.

CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_attribute,
             attribute TYPE string,
             value     TYPE string,
           END OF ts_attribute,

           tt_attributes TYPE STANDARD TABLE OF ts_attribute
                        WITH NON-UNIQUE KEY attribute.

    CLASS-METHODS class_constructor.

    METHODS constructor
      IMPORTING
        iv_name      TYPE string
        iv_planetype TYPE saplane-planetype
      RAISING
        cx_s4d400_wrong_plane.

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

    CLASS-DATA gt_planetypes TYPE STANDARD TABLE OF saplane
                             WITH NON-UNIQUE KEY planetype.

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
  ENDMETHOD.

  METHOD get_n_o_airplanes.
    rv_number = gv_n_o_airplane.
  ENDMETHOD.

  METHOD constructor.
    IF NOT line_exists( gt_planetypes[ planetype = iv_planetype ] ).
      RAISE EXCEPTION TYPE cx_s4d400_wrong_plane.
    ENDIF.

    mv_name = iv_name.
    mv_planetype = iv_planetype.

    gv_n_o_airplane += 1.
  ENDMETHOD.

  METHOD class_constructor.
    SELECT
        FROM saplane
        FIELDS *
        INTO TABLE @gt_planetypes.
  ENDMETHOD.

ENDCLASS.

DATA go_airplane TYPE REF TO lcl_airplane.
DATA gt_airplane TYPE TABLE OF REF TO lcl_airplane.

START-OF-SELECTION.

  TRY.
      go_airplane = NEW #(
        iv_name = 'THOMAS'
        iv_planetype = '747-400'
      ).
      gt_airplane = VALUE #( BASE gt_airplane ( go_airplane ) ).

      go_airplane = NEW #(
        iv_name = 'KARL'
        iv_planetype = '747-400'
      ).
      gt_airplane = VALUE #( BASE gt_airplane ( go_airplane ) ).

      go_airplane = NEW #(
        iv_name = 'HEINER'
        iv_planetype = '146-200'
      ).
      gt_airplane = VALUE #( BASE gt_airplane ( go_airplane ) ).

      DATA gt_output TYPE lcl_airplane=>tt_attributes.
      LOOP AT gt_airplane ASSIGNING FIELD-SYMBOL(<airplane>).
        DATA(attributes) = <airplane>->get_attributes( ).

        gt_output = CORRESPONDING #( BASE (  gt_output ) attributes ).
      ENDLOOP.

      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = DATA(alv)
        CHANGING
          t_table      = gt_output
      ).

      alv->display( ).

    CATCH cx_s4d400_wrong_plane INTO DATA(wrong_plane).
      WRITE: / |Wrong plane type|.
    CATCH cx_salv_msg INTO DATA(exception).
      WRITE: / |An error occurred: { exception->get_text( ) }|.
  ENDTRY.
