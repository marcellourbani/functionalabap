class zfa_simplefn definition
  public
  create private .

  public section.

    interfaces zfa_function .

    class-methods create
      importing
        !operator type char1
        !opvalue  type f
      returning
        value(fn) type ref to zfa_simplefn .
  protected section.
  private section.
    data operator type char1.
    data opvalue type f.
endclass.



class zfa_simplefn implementation.


  method create.
    if operator ca '*/+-^'.
      create object fn.
      fn->operator = operator.
      fn->opvalue = opvalue.
    else.
      raise exception type zcx_functionalabap exporting message = 'Unexpected operator'.
    endif.
  endmethod.


  method zfa_function~call.
    data: raw type f.
    param->extract( importing payload = raw ).
    case operator.
      when '/'.
        raw = raw / opvalue.
      when '*'.
        raw = raw * opvalue.
      when '+'.
        raw = raw + opvalue.
      when '-'.
        raw = raw - opvalue.
      when '^'.
        raw = raw ** opvalue.
      when others.
        raise exception type zcx_functionalabap exporting message = 'Unexpected operator'.
    endcase.
    result = zfa_simplevalue=>create( raw ).
  endmethod.
endclass.
