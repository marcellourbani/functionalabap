class ZFA_ERROR definition
  public
  create private .

public section.

  interfaces ZFA_VALUE .

  methods GET_TEXT
    returning
      value(S) type STRING .
  class-methods CREATE
    importing
      !TEXT type STRING
    returning
      value(ERR) type ref to ZFA_ERROR .
  class-methods ISERROR
    importing
      !ERROR type ref to ZFA_VALUE
    returning
      value(E) type ABAP_BOOL .
  class-methods THROW
    importing
      !ERROR type ref to ZFA_VALUE
      !FALLBACK type STRING default 'Unknown error (value is not of type error)' .
  private section.
    data text type string.
ENDCLASS.



CLASS ZFA_ERROR IMPLEMENTATION.


  method create.
    create object err.
    err->text  =  text.
  endmethod.


  method get_text.
    s = text.
  endmethod.


  method iserror.
    data: errorval type ref to zfa_error.
    if error is bound.
       try.
          errorval ?= error.
          e = abap_true.
        catch cx_root.
      endtry.
    endif.
  endmethod.


  method throw.
    data:text type string.

    if iserror( error ) = abap_true.
      error->extract( importing payload = text ).
    else.
      text = fallback.
    endif.

    raise exception type zcx_functionalabap exporting message = text.
    if iserror( error ) = abap_true.
      error->extract( importing payload = text ).
    else.
      text = fallback.
    endif.

    raise exception type zcx_functionalabap exporting message = text.
  endmethod.


  method zfa_value~extract.
    payload = text.
  endmethod.
ENDCLASS.
