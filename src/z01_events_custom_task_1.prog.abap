*&---------------------------------------------------------------------*
*& Report z01_events_custom_task_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_events_custom_task_1.

CONSTANTS: co_ice_hockey TYPE char2 VALUE 'EH',
           co_handball   TYPE char2 VALUE 'HB',
           co_carnival   TYPE char2 VALUE 'KR'.

TYPES: BEGIN OF t_events_all_data,
         id          TYPE z00_events-id,
         kind        TYPE z00_events-kind,
         name        TYPE z00_events-name,
         price_adult TYPE z00_events-price_adult,
         price_child TYPE z00_events-price_child,
         event_date  TYPE z00_events-event_date,
         start_time  TYPE z00_events-start_time,
         end_time    TYPE z00_events-end_time,
         duration    TYPE i,
         countdown   TYPE i,
         costs       TYPE z00_events-price_adult,
       END OF t_events_all_data.

TYPES: tt_events_all_data TYPE STANDARD TABLE OF t_events_all_data
       WITH NON-UNIQUE KEY event_date.

DATA events_all_data TYPE tt_events_all_data.

SELECT
    FROM z00_events
    FIELDS *
    WHERE ( event_date = @sy-datlo AND start_time >= @sy-timlo )
          OR event_date > @sy-datlo
    INTO CORRESPONDING FIELDS OF TABLE @events_all_data.

LOOP AT events_all_data ASSIGNING FIELD-SYMBOL(<event>).
  CASE <event>-kind.
    WHEN co_ice_hockey.
      <event>-costs = 1 * <event>-price_adult + 4 * <event>-price_child.
    WHEN co_handball.
      <event>-costs = 2 * <event>-price_adult + 1 * <event>-price_child.
    WHEN co_carnival.
      <event>-costs = 3 * <event>-price_adult + 6 * <event>-price_child.
  ENDCASE.

  <event>-duration = ( <event>-end_time - <event>-start_time ) / 60.
  <event>-countdown = <event>-event_date - sy-datlo.
ENDLOOP.

TRY.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = DATA(alv)
      CHANGING
        t_table      = events_all_data
    ).

    alv->display( ).

  CATCH cx_salv_msg INTO DATA(exception).
    WRITE: / |An error occurred: { exception->get_text( ) }|.
ENDTRY.
