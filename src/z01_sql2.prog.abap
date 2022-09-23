*&---------------------------------------------------------------------*
*& Report z01_sql2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_sql2.

PARAMETERS: carr_id TYPE s_carr_id,
            conn_id TYPE s_conn_id.

SELECT
   FROM sflight
   FIELDS *
   WHERE carrid = @carr_id
         AND connid = @conn_id
   INTO TABLE @DATA(flights).

TRY.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = DATA(alv)
      CHANGING
        t_table      = flights
    ).

    alv->display( ).

  CATCH cx_salv_msg INTO DATA(exception).
    WRITE: / |An error occurred: { exception->get_text( ) }|.
ENDTRY.
