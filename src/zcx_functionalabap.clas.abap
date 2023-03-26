class ZCX_FUNCTIONALABAP definition
  public
  inheriting from CX_NO_CHECK
  final
  create public .

public section.

  constants ZCX_FUNCTIONALABAP type SOTR_CONC value '02EBA46F1F491EDDB2DED34EA5B382FF' ##NO_TEXT.
  data MESSAGE type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !MESSAGE type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_FUNCTIONALABAP IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = ZCX_FUNCTIONALABAP .
 ENDIF.
me->MESSAGE = MESSAGE .
  endmethod.
ENDCLASS.
