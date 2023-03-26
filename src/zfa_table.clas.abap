class zfa_table definition
  public
  create private .

  public section.

    interfaces zfa_value .
    methods:tablines returning value(result) type zfa_value=>values.

    class-methods: create
      importing !itab         type any table
      returning value(result) type ref to zfa_table.
    class-methods bind
      importing !orig          type ref to zfa_function
      returning value(wrapped) type ref to zfa_function .
    class-methods map
      importing !orig          type ref to zfa_function
      returning value(wrapped) type ref to zfa_function .
  protected section.
  private section.
    class-methods tovalue
      importing line          type any
      returning value(result) type ref to zfa_value.
    data:inner type zfa_value=>values.
endclass.



class zfa_table implementation.


  method create.
    data: item  type ref to zfa_value.
    field-symbols: <line> type any.

    create object result.
    loop at itab assigning <line>.
      item = tovalue( <line> ).
      append item to result->inner.
    endloop.
  endmethod.


  method tovalue.
    data: ltype type ref to cl_abap_typedescr,
          refd  type ref to cl_abap_refdescr,
          lkind type abap_typecategory.
    ltype = cl_abap_typedescr=>describe_by_data( line ).
    if ltype->kind = cl_abap_typedescr=>kind_ref.
      try.
          refd ?= ltype.
          lkind = refd->get_referenced_type(  )->kind.
          if lkind = cl_abap_typedescr=>kind_intf or lkind = cl_abap_typedescr=>kind_class.
            result = line.
          endif.
        catch cx_root into data(cx).
      endtry.
    endif.
    if result is initial.
      result = zfa_simplevalue=>create( line ).
    endif.

  endmethod.


  method zfa_value~extract.
    data: ptype type ref to cl_abap_typedescr.
    field-symbols: <line>  like line of inner,
                   <itab>  type standard table,
                   <pline> type any.
    ptype = cl_abap_typedescr=>describe_by_data( payload ).
    if ptype->kind <> cl_abap_typedescr=>kind_table.
      raise exception type zcx_functionalabap exporting message = 'Table payload expected'.
    else.
      assign payload to <itab>.
      loop at inner assigning <line>.
        append initial line to <itab> assigning <pline>.
        <line>->extract( importing payload = <pline> ).
      endloop.
    endif.
  endmethod.

  method bind.
    wrapped = bindwrapper=>create( orig ).
  endmethod.

  method map.
    wrapped = mapwrapper=>create( orig ).
  endmethod.

  method tablines.
    result = inner.
  endmethod.

endclass.
