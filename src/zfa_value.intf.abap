interface zfa_value  public .
  types:avalue type ref to zfa_value,
        values type table of avalue with default key.
  methods: extract exporting payload type any.
endinterface.
