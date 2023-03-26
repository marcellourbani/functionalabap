class zfa_replicate definition public create private .
  public section.
    interfaces:zfa_function.
    class-methods:create importing times type i returning value(fn) type ref to zfa_replicate.
  protected section.
  private section.
    data:repeats type i.
endclass.



class zfa_replicate implementation.


  method create.
    create object fn.
    fn->repeats = times.
  endmethod.


  method zfa_function~call.
    data: itab type zfa_value=>values.
    do repeats times.
      append param to itab.
    enddo.
    result = zfa_table=>create( itab ).
  endmethod.
endclass.
