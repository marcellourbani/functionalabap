class mapwrapper definition create private.
  public section.
    interfaces:zfa_function.
    class-methods:create importing orig          type ref to zfa_function
                         returning value(mapped) type ref to mapwrapper.
  private section.
    data innerf type ref to zfa_function.

endclass.

class mapwrapper implementation.

  method zfa_function~call.
    data: source  type ref to zfa_table,
          resline type ref to zfa_value,
          restab  like table of resline,
          lines   type zfa_value=>values.
    field-symbols: <line> type zfa_value=>avalue.
    source ?= param.
    lines = source->tablines(  ).
    loop at lines assigning <line>.
      resline = innerf->call( <line> ).
      append resline to restab.
    endloop.
    result = zfa_table=>create( restab ).
  endmethod.

  method create.
    create object mapped.
    mapped->innerf = orig.
  endmethod.

endclass.

class bindwrapper definition create private.
  public section.
    interfaces:zfa_function.
    class-methods:create importing orig          type ref to zfa_function
                         returning value(mapped) type ref to bindwrapper.
  private section.
    data innerf type ref to zfa_function.

endclass.

class bindwrapper implementation.

  method zfa_function~call.
    data: source  type ref to zfa_table,
          resline type ref to zfa_table,
          restab  type table of zfa_value=>avalue,
          lines   type zfa_value=>values.
    field-symbols: <line> type zfa_value=>avalue.
    source ?= param.
    lines = source->tablines(  ).
    loop at lines assigning <line>.
      resline ?= innerf->call( <line> ).
      append lines of resline->tablines(  ) to restab.
    endloop.
    result = zfa_table=>create( restab ).
  endmethod.


  method create.
    create object mapped.
    mapped->innerf = orig.
  endmethod.

endclass.
