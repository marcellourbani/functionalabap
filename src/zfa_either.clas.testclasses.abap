*"* use this source file for your ABAP unit test classes
class unit definition for testing duration short risk level harmless.
  private section.
    data: cut type ref to zfa_either.
    methods: right for testing,
      left for testing,
      tryfn for testing,
      map for testing,
      bind for testing.

endclass.

class unit implementation.


  method right.

    data extracted type string.

    data(inner) = zfa_simplevalue=>create( 'foo' ).

    cut = zfa_either=>createright( inner ).

    cl_aunit_assert=>assert_equals( act = cut->isright(  ) exp = abap_true ).
    cl_aunit_assert=>assert_equals( act = cut->isleft(  ) exp = abap_false ).
    cl_aunit_assert=>assert_equals( act = zfa_error=>iserror( cut->left(  ) ) exp = abap_true ).

    cl_aunit_assert=>assert_equals( act = cut->right(  ) exp = inner ).
    cut->zfa_value~extract( importing payload = extracted ).

    cl_aunit_assert=>assert_equals( act = extracted exp = 'foo' ).


  endmethod.

  method left.
    data extracted type string.

    data(inner) = zfa_simplevalue=>create( 'foo' ).

    cut = zfa_either=>createleft( inner ).

    cl_aunit_assert=>assert_equals( act = cut->isright(  ) exp = abap_false ).
    cl_aunit_assert=>assert_equals( act = cut->isleft(  ) exp = abap_true ).

    cl_aunit_assert=>assert_equals( act = cut->left(  ) exp = inner ).
    cl_aunit_assert=>assert_equals( act = zfa_error=>iserror( cut->right(  ) ) exp = abap_true ).

    cut->left(  )->extract( importing payload = extracted ).
    cl_aunit_assert=>assert_equals( act = extracted exp = 'foo' ).

    try.
        cut->zfa_value~extract( importing payload = extracted ).
        cl_aunit_assert=>fail( msg = 'Shouldn''t be able to extract from a left' ).
      catch cx_root into data(cx).
        " expected
    endtry.

  endmethod.

  method bind.
    data: result type f.

    data(rawfn) = zfa_either=>tryfn(  zfa_simplefn=>create( operator = '+' opvalue = 2 ) ).
    data(wrapped) = zfa_either=>bind( rawfn ).
    cut ?= wrapped->call( zfa_either=>createright( zfa_simplevalue=>create( 27 ) ) ).
    cl_aunit_assert=>assert_equals( exp = abap_true  act = cut->isright( ) ).
    cut->zfa_value~extract( importing payload = result ).
    cl_aunit_assert=>assert_equals( exp = 29  act = result ).

    cut ?= wrapped->call( zfa_either=>createleft( zfa_simplevalue=>create( 27 ) ) ).
    cl_aunit_assert=>assert_equals( exp = abap_true  act = cut->isleft( ) ).
    cut->left( )->extract( importing payload = result ).
    cl_aunit_assert=>assert_equals( exp = 27  act = result ).

  endmethod.

  method map.
    data: result type f.

    data(rawfn) = zfa_simplefn=>create( operator = '+' opvalue = 2 ).
    data(wrapped) = zfa_either=>map( rawfn ).
    cut ?= wrapped->call( zfa_either=>createright( zfa_simplevalue=>create( 27 ) ) ).
    cl_aunit_assert=>assert_equals( exp = abap_true  act = cut->isright( ) ).
    cut->zfa_value~extract( importing payload = result ).
    cl_aunit_assert=>assert_equals( exp = 29  act = result ).

    cut ?= wrapped->call( zfa_either=>createleft( zfa_simplevalue=>create( 27 ) ) ).
    cl_aunit_assert=>assert_equals( exp = abap_true  act = cut->isleft( ) ).
    cut->left( )->extract( importing payload = result ).
    cl_aunit_assert=>assert_equals( exp = 27  act = result ).

  endmethod.

  method tryfn.
    data: result type f.

    data(rawfn) = zfa_simplefn=>create( operator = '/' opvalue = 3 ).
    data(wrapped) = zfa_either=>tryfn( rawfn ).
    cut ?= wrapped->call( zfa_simplevalue=>create( 27 ) ).
    cl_aunit_assert=>assert_equals( exp = abap_true  act = cut->isright( ) ).
    cut->right(  )->extract( importing payload = result ).
    cl_aunit_assert=>assert_equals( exp = 9  act = result ).

    rawfn = zfa_simplefn=>create( operator = '/' opvalue = 0 ).
    wrapped = zfa_either=>tryfn( rawfn ).
    cut ?= wrapped->call( zfa_simplevalue=>create( 27 ) ).
    cl_aunit_assert=>assert_equals( exp = abap_true  act = cut->isleft( ) ).
    cl_aunit_assert=>assert_equals( exp = abap_true  act = zfa_error=>iserror( cut->left(  ) ) ).

  endmethod.

endclass.
