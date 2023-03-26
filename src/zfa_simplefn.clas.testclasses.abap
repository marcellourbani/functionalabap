class unit definition for testing risk level harmless duration short.
  private section.
    methods:
      division for testing,
      divisionbyzero for testing,
      call importing fun        type ref to zfa_function
                     operand    type f
           returning value(res) type f.
endclass.

class unit implementation.

  method call.
    data(inv) = zfa_simplevalue=>create( operand ).
    data(resv) = fun->call( inv ).
    resv->extract( importing payload = res ).
  endmethod.

  method division.
    data(cut) = zfa_simplefn=>create( operator = '/' opvalue = 2 ).
    data(res) = call( fun = cut operand = 10 ).
    cl_aunit_assert=>assert_equals( exp = 5 act = res ).
  endmethod.

  method divisionbyzero.
    data(cut) = zfa_simplefn=>create( operator = '/' opvalue = 0 ).
    try.
        data(res) = call( fun = cut operand = 10 ).
        cl_aunit_assert=>fail( msg = 'Division by zero not detected' ).
      catch cx_root into data(cx).
        " expected
    endtry.

  endmethod.

endclass.
