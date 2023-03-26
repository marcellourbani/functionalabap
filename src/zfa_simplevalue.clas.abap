class zfa_simplevalue definition public create private .
  public section.

    interfaces zfa_value .

    class-methods: create importing value         type any
                          returning value(result) type ref to zfa_simplevalue.
  protected section.
  private section.
    data:inner type ref to data.
endclass.



class zfa_simplevalue implementation.

  method zfa_value~extract.
    field-symbols:<f> type any.
    assign inner->* to <f>.
    payload = <f>.
  endmethod.
  method create.
    field-symbols:<f> type any.
    create object result.
    create data result->inner like value.
    assign result->inner->* to <f>.
    <f> = value.
  endmethod.

endclass.
