class unit definition for testing risk level harmless duration short.
  private section.
    methods: simple for testing,
      objlist for testing,
      map for testing,
      bind for testing.
endclass.

class unit implementation.

  method objlist.
    data: cut       type ref to zfa_table,
          orig      type table of ref to zfa_value,
          expected  type stringtab,
          extracted type stringtab.
    append zfa_simplevalue=>create( 'foo' ) to orig.
    append zfa_simplevalue=>create( 'bar' ) to orig.
    append 'foo' to expected.
    append 'bar' to expected.
    cut = zfa_table=>create( orig ).
    cut->zfa_value~extract( importing payload = extracted ).
    cl_aunit_assert=>assert_equals( exp = expected act = extracted ).
  endmethod.

  method simple.
    data: cut       type ref to zfa_table,
          orig      type stringtab,
          extracted like orig.
    append 'foo' to orig.
    append 'bar' to orig.
    cut = zfa_table=>create( orig ).
    cut->zfa_value~extract( importing payload = extracted ).
    cl_aunit_assert=>assert_equals( exp = orig act = extracted ).
  endmethod.

  method bind.
    data: source   type table of f,
          expected type table of f,
          result   type table of f.
    data(replicate) = zfa_replicate=>create( 2 ).
    data(replicatetab) = zfa_table=>bind( replicate ).
    append 2 to source.
    append 3 to source.
    append 2 to expected.
    append 2 to expected.
    append 3 to expected.
    append 3 to expected.
    data(replicated) = replicatetab->call( zfa_table=>create( source ) ).
    replicated->extract( importing payload = result ).

    cl_aunit_assert=>assert_equals( exp = expected act = result ).
  endmethod.

  method map.
    data: source   type table of f,
          expected type table of f,
          result   type table of f.
    data(double) = zfa_simplefn=>create( operator = '*' opvalue = 2 ).
    data(doubletab) = zfa_table=>map( double ).
    append 2 to source.
    append 3 to source.
    append 4 to expected.
    append 6 to expected.
    data(doubled) = doubletab->call( zfa_table=>create( source ) ).
    doubled->extract( importing payload = result ).

    cl_aunit_assert=>assert_equals( exp = expected act = result ).

  endmethod.

endclass.
