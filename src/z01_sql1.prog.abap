*&---------------------------------------------------------------------*
*& Report z01_sql1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_sql1.

DATA: gs_flight TYPE d400_s_flight.

PARAMETERS: carr_id TYPE s_carr_id,
            conn_id TYPE s_conn_id,
            fl_date TYPE s_date.

SELECT SINGLE
    FROM sflight
    FIELDS *
    WHERE carrid = @carr_id
          AND connid = @conn_id
          AND fldate = @fl_date
    INTO @DATA(flight).

DATA structdescr TYPE REF TO cl_abap_structdescr.
structdescr ?= cl_abap_structdescr=>describe_by_data( flight ).

LOOP AT structdescr->components ASSIGNING FIELD-SYMBOL(<component>).
  ASSIGN COMPONENT <component>-name OF STRUCTURE flight TO FIELD-SYMBOL(<value>).
  IF <value> IS ASSIGNED.
    WRITE: / |{ <component>-name }: { <value> }|.
  ENDIF.
ENDLOOP.
