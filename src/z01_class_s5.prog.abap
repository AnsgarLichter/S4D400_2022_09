*&---------------------------------------------------------------------*
*& Report z01_class_s5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_class_s5.

CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_attribute,
             attribute TYPE string,
             value     TYPE string,
           END OF ts_attribute,
           tt_attributes TYPE STANDARD TABLE OF ts_attribute
            WITH NON-UNIQUE KEY attribute.

    METHODS:

      constructor
        IMPORTING iv_name      TYPE string
                  iv_planetype TYPE saplane-planetype
        RAISING   cx_s4d400_wrong_plane,
      set_attributes
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype,

      get_attributes
        RETURNING
          VALUE(rt_attributes) TYPE tt_attributes.

    CLASS-METHODS:
      get_n_o_airplanes EXPORTING ev_number TYPE i,
      class_constructor.

  PROTECTED SECTION.

    DATA:
      mv_name      TYPE string,
      mv_planetype TYPE saplane-planetype.

  PRIVATE SECTION.

    CLASS-DATA:
      gv_n_o_airplanes TYPE i,
      gt_planetypes    TYPE STANDARD TABLE OF saplane WITH NON-UNIQUE KEY planetype.

ENDCLASS.                    "lcl_airplane DEFINITION
CLASS lcl_airplane IMPLEMENTATION.

  METHOD set_attributes.

    mv_name      = iv_name.
    mv_planetype = iv_planetype.



  ENDMETHOD.                    "set_attributes

  METHOD get_attributes.

    rt_attributes = VALUE #(  (  attribute = 'NAME' value = mv_name )
                              (  attribute = 'PLANETYPE' value = mv_planetype ) ).
  ENDMETHOD.                    "display_attributes

  METHOD get_n_o_airplanes.
    ev_number = gv_n_o_airplanes.
  ENDMETHOD.                    "display_n_o_airplanes

  METHOD constructor.
    IF NOT line_exists( gt_planetypes[ planetype = iv_planetype ] ).
      RAISE EXCEPTION TYPE cx_s4d400_wrong_plane.
    ENDIF.
    mv_name = iv_name.
    mv_planetype = iv_planetype.
    gv_n_o_airplanes = gv_n_o_airplanes + 1.
  ENDMETHOD.

  METHOD class_constructor.
    SELECT * FROM saplane INTO TABLE gt_planetypes.
  ENDMETHOD.

ENDCLASS.                    "lcl_airplane IMPLEMENTATION

CLASS lcl_cargo_plane DEFINITION INHERITING FROM lcl_airplane.

  PUBLIC SECTION.

    METHODS: get_attributes REDEFINITION,
      constructor
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype
          iv_weight    TYPE i
        RAISING
          cx_s4d400_wrong_plane,
      get_weight RETURNING VALUE(r_result) TYPE i,
      set_weight IMPORTING iv_weight TYPE i.

  PRIVATE SECTION.

    DATA: mv_weight TYPE i.

ENDCLASS.

CLASS lcl_cargo_plane IMPLEMENTATION.

  METHOD get_attributes.
    rt_attributes = VALUE #( BASE rt_attributes
        (  attribute = 'NAME' value = mv_name )
        (  attribute = 'PLANETYPE' value = mv_planetype )
        (  attribute = 'WEIGHT' value = mv_weight )
    ).
  ENDMETHOD.

  METHOD constructor.
    super->constructor( iv_name = iv_name iv_planetype = iv_planetype ).
    mv_weight = iv_weight.
  ENDMETHOD.

  METHOD get_weight.
    r_result = me->mv_weight.
  ENDMETHOD.

  METHOD set_weight.
    me->mv_weight = iv_weight.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_passenger_plane DEFINITION INHERITING FROM lcl_airplane.

  PUBLIC SECTION.

    METHODS: get_attributes REDEFINITION,
      constructor
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype
          iv_seats     TYPE i
        RAISING
          cx_s4d400_wrong_plane,
      get_seats RETURNING VALUE(r_result) TYPE i,
      set_seats IMPORTING iv_seats TYPE i.

  PRIVATE SECTION.

    DATA:
          mv_seats TYPE i.

ENDCLASS.

CLASS lcl_passenger_plane IMPLEMENTATION.

  METHOD constructor.
    super->constructor( iv_name = iv_name iv_planetype = iv_planetype ).
    mv_seats = iv_seats.
  ENDMETHOD.

  METHOD get_attributes.
    rt_attributes = VALUE #(
        BASE super->get_attributes( )
        ( attribute = `SEATS` value = mv_seats )
    ).
  ENDMETHOD.

  METHOD get_seats.
    r_result = me->mv_seats.
  ENDMETHOD.

  METHOD set_seats.
    me->mv_seats = iv_seats.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_carrier DEFINITION.
  PUBLIC SECTION.
    TYPES: tt_planetab TYPE STANDARD TABLE OF REF TO lcl_airplane WITH EMPTY KEY.

    METHODS add_plane
      IMPORTING plane TYPE REF TO lcl_airplane.

    METHODS get_planes
      RETURNING VALUE(planes) TYPE tt_planetab.

    METHODS get_highest_cargo_weight
      RETURNING VALUE(highest_weight) TYPE i.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mt_planes TYPE tt_planetab.
ENDCLASS.

CLASS lcl_carrier IMPLEMENTATION.

  METHOD add_plane.
    mt_planes = VALUE #(
        BASE mt_planes
        ( plane )
    ).
  ENDMETHOD.

  METHOD get_planes.
    planes = mt_planes.
  ENDMETHOD.

  METHOD get_highest_cargo_weight.
    LOOP AT mt_planes ASSIGNING FIELD-SYMBOL(<plane>).
      IF <plane> IS NOT INSTANCE OF lcl_cargo_plane.
        CONTINUE.
      ENDIF.

      DATA(cargo_plane) = CAST lcl_cargo_plane( <plane> ).
      highest_weight = nmax(
        val1 = highest_weight
        val2 = cargo_plane->get_weight( )
      ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

DATA: go_airplane     TYPE REF TO lcl_airplane,
      gt_airplanes    TYPE TABLE OF REF TO lcl_airplane,
      gt_attributes   TYPE lcl_airplane=>tt_attributes,
      gt_output       TYPE lcl_airplane=>tt_attributes,
      passenger_plane TYPE REF TO lcl_passenger_plane,
      cargo_plane     TYPE REF TO lcl_cargo_plane,
      carrier         TYPE REF TO lcl_carrier.

START-OF-SELECTION.


  TRY.
      carrier = NEW #( ).

      go_airplane = NEW #(
          iv_name      = 'Plane 1'
          iv_planetype = '747-400'
      ).
      carrier->add_plane( go_airplane ).

      passenger_plane = NEW #(
        iv_name = 'HENRI'
        iv_planetype = '747-400'
        iv_seats = 1
      ).
      carrier->add_plane( passenger_plane ).

      cargo_plane = NEW #(
        iv_name = 'JULIAN'
        iv_planetype = '747-400'
        iv_weight = 330000
      ).
      carrier->add_plane( cargo_plane ).

      cargo_plane = NEW #(
        iv_name = 'NICOLAS'
        iv_planetype = '747-400'
        iv_weight = 331000
      ).
      carrier->add_plane( cargo_plane ).

      WRITE: / carrier->get_highest_cargo_weight( ).

    CATCH cx_s4d400_wrong_plane INTO DATA(wrong_plane).
      WRITE: / |Wrong plane type|.
    CATCH cx_salv_msg INTO DATA(exception).
      WRITE: / |An error occurred: { exception->get_text( ) }|.
  ENDTRY.
