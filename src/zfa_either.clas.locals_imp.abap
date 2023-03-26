*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class trywrapper definition.
  public section.
    interfaces:zfa_function.
    methods:constructor importing orig type ref to zfa_function.
  private section.
    data innerf type ref to zfa_function.

endclass.

class trywrapper implementation.

  method zfa_function~call.
    try.
        data(inner) =  innerf->call( param ).
        result = zfa_either=>createright( inner ).
      catch cx_root into data(cx).
        data(err) = zfa_error=>create( cx->get_text(  ) ).
        data ei type ref to zfa_either.
        ei = zfa_either=>createleft( err ).
        result ?= ei.
    endtry.
  endmethod.

  method constructor.
    innerf = orig.
  endmethod.

endclass.

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
    data: source type ref to zfa_either.
    try.
        source ?= param.
      catch cx_root into data(cx).
        result = zfa_either=>error( 'Expected an either as parameter' ).
    endtry.
    if source is bound.
      if source->isright(  ) = abap_true.
        result = zfa_either=>createright( innerf->call( source->right(  ) ) ).
      else.
        result = source.
      endif.
    else.
      result = zfa_either=>error( 'Null parameter is invalid' ).
    endif.
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
    data: source type ref to zfa_either.
    try.
        source ?= param.
      catch cx_root into data(cx).
        result = zfa_either=>error( 'Expected an either as parameter' ).
    endtry.
    if source is bound.
      if source->isright(  ) = abap_true.
        result =  innerf->call( source->right(  ) ) .
      else.
        result = source.
      endif.
    else.
      result = zfa_either=>error( 'Null parameter is invalid' ).
    endif.
  endmethod.


  method create.
    create object mapped.
    mapped->innerf = orig.
  endmethod.

endclass.
