*&---------------------------------------------------------------------*
*& Report z01_structure
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_structure.

TYPES: BEGIN OF t_complete,
         carrid    TYPE z01_connection-carrid,
         connid    TYPE z01_connection-connid,
         cityfrom  TYPE z01_connection-cityfrom,
         cityto    TYPE z01_connection-cityto,
         fldate    TYPE d400_s_flight-fldate,
         planetype TYPE d400_s_flight-planetype,
         seatsmax  TYPE d400_s_flight-seatsmax,
         seatsocc  TYPE d400_s_flight-seatsocc,
       END OF t_complete.

DATA(g_connection) = VALUE z01_connection(
    carrid = 'LH'
    connid = '0400'
    cityfrom = 'FRANKFURT'
    cityto = 'NEW YORK'
).

TRY.
    cl_s4d400_flight_model=>get_next_flight(
      EXPORTING
        iv_carrid = g_connection-carrid
        iv_connid = g_connection-connid
      IMPORTING
        es_flight = DATA(g_flight)
    ).

    DATA(g_complete) = CORRESPONDING t_complete(
        BASE ( g_connection )
        g_flight
    ).

    cl_s4d_output=>display_structure( g_complete ).
  CATCH cx_s4d400_no_data cx_s4d_no_structure INTO DATA(error).
    WRITE error->get_text( ).
ENDTRY.
