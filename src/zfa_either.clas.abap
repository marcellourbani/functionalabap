class zfa_either definition
  public
  create private .

  public section.

    interfaces zfa_value .

    methods isright
      returning
        value(v) type abap_bool .
    methods isleft
      returning
        value(v) type abap_bool .
    methods right
      returning
        value(r) type ref to zfa_value .
    methods left
      returning
        value(r) type ref to zfa_value .
    class-methods createright
      importing
        !v       type ref to zfa_value
      returning
        value(e) type ref to zfa_either .
    class-methods createleft
      importing
        !v       type ref to zfa_value
      returning
        value(e) type ref to zfa_either .
    class-methods error
      importing
        !text    type csequence
      returning
        value(e) type ref to zfa_either .
    class-methods tryfn
      importing
        !orig          type ref to zfa_function
      returning
        value(wrapped) type ref to zfa_function .
    class-methods bind
      importing
        !orig          type ref to zfa_function
      returning
        value(wrapped) type ref to zfa_function .
    class-methods map
      importing
        !orig          type ref to zfa_function
      returning
        value(wrapped) type ref to zfa_function .
  private section.
    data: righttag type abap_bool,
          invalue  type ref to zfa_value.

endclass.



class zfa_either implementation.


  method createleft.
    if v is bound.
      create object e.
      e->invalue = v.
      e->righttag = abap_false.
    else.
      e = error( 'Uninitialized left value' ) .
    endif.
  endmethod.


  method createright.
    if v is bound.
      create object e.
      e->invalue = v.
      e->righttag = abap_true.
    else.
      e = error( 'Uninitialized right value' ).
    endif.
  endmethod.


  method error.
    data: errortext type string.
    errortext = text.
    e = createleft( zfa_error=>create( errortext ) ).
  endmethod.


  method isleft.
    if righttag = abap_false.
      v = abap_true.
    endif.
  endmethod.


  method isright.
    v = righttag.
  endmethod.


  method left.

    if righttag = abap_false.
      r = invalue.
    else.
      r =  zfa_error=>create( 'Trying to extract a left value from a right' ).
    endif.

  endmethod.


  method map.

    wrapped = mapwrapper=>create( orig ).

  endmethod.


  method right.

    if righttag = abap_true.
      r = invalue.
    else.
      r =  zfa_error=>create( 'Trying to extract a right value from a left' ).
    endif.

  endmethod.


  method tryfn.

    create object wrapped type trywrapper exporting orig = orig.

  endmethod.


  method zfa_value~extract.
    if righttag = abap_true.
      invalue->extract( importing payload = payload ).
    else.
      zfa_error=>throw( error = invalue fallback = 'Can''t extract value from a left' ).
    endif.
  endmethod.
  method bind.
    wrapped = bindwrapper=>create( orig ).
  endmethod.

endclass.
