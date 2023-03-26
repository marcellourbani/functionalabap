*"* use this source file for your ABAP unit test classes

class unit definition for testing duration short risk level harmless.
  private section.
    data: cut type ref to zfa_simplevalue.
    methods: str for testing,
      simpletab for testing,
      obj for testing.

endclass.

class unit implementation.

  method str.
    data: original  type string value 'foo bar',
          extracted type string.
    cut = zfa_simplevalue=>create( original ).
    cut->zfa_value~extract( importing payload = extracted ).

    cl_aunit_assert=>assert_equals( exp = original act = extracted ).

  endmethod.

  method simpletab.
    data: original  type stringtab,
          extracted type stringtab.
    append 'foo' to original.
    append 'bar' to original.
    cut = zfa_simplevalue=>create( original ).
    cut->zfa_value~extract( importing payload = extracted ).

    cl_aunit_assert=>assert_equals( exp = original act = extracted ).
  endmethod.

  method obj.
    data: original  type ref to zfa_value,
          extracted type ref to zfa_value,
          inner     type string.
    original = zfa_simplevalue=>create( 'foo' ).
    cut = zfa_simplevalue=>create( original ).
    cut->zfa_value~extract( importing payload = extracted ).

    cl_aunit_assert=>assert_equals( exp = original act = extracted ).

    extracted->extract( importing payload = inner ).

    cl_aunit_assert=>assert_equals( exp = 'foo' act = inner ).

  endmethod.

endclass.
