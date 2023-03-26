*"* use this source file for your ABAP unit test classes
class unit definition for testing duration short risk level harmless.
  private section.
    data: cut type ref to zfa_error.
    methods: create for testing.

endclass.

class unit implementation.

  method create.

    cut = zfa_error=>create( 'foo' ).

    cl_aunit_assert=>assert_equals( exp = abap_true act = zfa_error=>iserror( cut ) ).

    try.
        zfa_error=>throw( cut ).
        cl_aunit_assert=>fail( msg = 'should have thrown an exception' ).
      catch cx_root into data(cx).
        cl_aunit_assert=>assert_equals( exp = 'foo' act = cx->get_text(  ) ).
    endtry.

  endmethod.

endclass.
