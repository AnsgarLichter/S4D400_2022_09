*&---------------------------------------------------------------------*
*& Report z01_calculator
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_calculator.

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
  WHEN OTHERS.
    WRITE 'INVALID OPERATION'.
    EXIT.
ENDCASE.


WRITE: / |{ input1 } { op } { input2 } = { output }|.
