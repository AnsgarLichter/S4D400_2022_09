*&---------------------------------------------------------------------*
*& Report z01_events_custom_task_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_events_custom_task_3.

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

SELECT SINGLE
    FROM z00_events
    FIELDS event_date
    WHERE kind = @co_carnival
    INTO @DATA(event_date).

IF event_date IS INITIAL.
  WRITE: / |No carnival event.|.
  EXIT.
ENDIF.

WHILE sy-datlo < event_date.
  DATA(difference) = event_date - sy-datlo.

  WRITE: / difference.
  event_date -= 1.
ENDWHILE.

WRITE / |Juhu|.
