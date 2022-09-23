*&---------------------------------------------------------------------*
*& Report z01_calculator
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_calculator_percentage.

PARAMETERS:
  input1 TYPE i,
  op     TYPE c LENGTH 01,
  input2 TYPE i.

DATA output TYPE decfloat16.
CASE op.
  WHEN '+'.
    output = input1 + input2.
  WHEN '-'.
    output = input1 - input2.
  WHEN '*'.
    output = input1 * input2.
  WHEN '/'.
    IF input2 = 0.
      WRITE 'DIVISION BY ZERO'.
      EXIT.
    ENDIF.
    output = input1 / input2.
  WHEN '^'.
    output = 1.
    DO input2 TIMES.
      output = output * input1.
    ENDDO.
  WHEN '%'.
    DATA result_percentage TYPE s4d400_percentage.
    CALL FUNCTION 'S4D400_CALCULATE_PERCENTAGE'
      EXPORTING
        iv_int1          = input1
        iv_int2          = input2
      IMPORTING
        ev_result        = result_percentage
      EXCEPTIONS
        division_by_zero = 1
        OTHERS           = 2.

    IF sy-subrc <> 0.
      WRITE: / 'ERROR CALCULATE PERCENTAGE'.
      EXIT.
    ENDIF.

    output = result_percentage.
  WHEN OTHERS.
    WRITE / 'INVALID OPERATION'.
    EXIT.
ENDCASE.


WRITE: / |{ input1 } { op } { input2 } = { output }|.
IF op = '%'.
  WRITE: '%'.
ENDIF.
