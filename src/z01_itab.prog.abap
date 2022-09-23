*&---------------------------------------------------------------------*
*& Report z01_itab
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_itab.

DATA g_connections TYPE z01_t_connections.

g_connections = VALUE #(
    ( carrid = 'LH' connid = '400' )
    ( carrid = 'LH' connid = '402' )
).

TRY.
    cl_s4d400_flight_model=>get_flights_for_connections(
      EXPORTING
        it_connections = g_connections
      IMPORTING
        et_flights     = DATA(g_flights)
    ).

    DATA g_percentages TYPE d400_t_percentage.
    g_percentages = CORRESPONDING #( g_flights ).

    LOOP AT g_percentages ASSIGNING FIELD-SYMBOL(<percentage>)
        WHERE percentage IS NOT INITIAL.

      <percentage>-percentage =
        <percentage>-seatsocc / <percentage>-seatsmax * 100.
    ENDLOOP.

    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = DATA(alv)
      CHANGING
        t_table      = g_percentages
    ).

    alv->display( ).
  CATCH cx_root INTO DATA(exception).
    WRITE: / |An exception occurred: { exception->get_text( ) }.|.
ENDTRY.
