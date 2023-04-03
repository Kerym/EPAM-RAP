CLASS zcm_kok_zoo DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    CONSTANTS:
      BEGIN OF client_unknown,
        msgid TYPE symsgid VALUE 'ZKOK_MSG_ZOO',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'CLIENTID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF client_unknown ,

      BEGIN OF ordertype_unknown,
        msgid TYPE symsgid VALUE 'ZKOK_MSG_ZOO',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'ORDERTYPEID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF ordertype_unknown ,

      BEGIN OF goods_unknown,
        msgid TYPE symsgid VALUE 'ZKOK_MSG_ZOO',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'GOODSID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF goods_unknown ,

      BEGIN OF wrong_quantity,
        msgid TYPE symsgid VALUE 'ZKOK_MSG_ZOO',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'QUANTITY',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF wrong_quantity.

    METHODS constructor
      IMPORTING
        severity    TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid      LIKE if_t100_message=>t100key OPTIONAL
        previous    TYPE REF TO cx_root      OPTIONAL
        clientid    TYPE zkok_client_id      OPTIONAL
        ordertypeid TYPE zkok_order_type_id  OPTIONAL
        goodsid     TYPE zkok_goods_id       OPTIONAL
        quantity    TYPE zkok_quantity       OPTIONAL.

    DATA clientid    TYPE zkok_client_id     READ-ONLY.
    DATA ordertypeid TYPE zkok_order_type_id READ-ONLY.
    DATA goodsid     TYPE zkok_goods_id      READ-ONLY.
    DATA quantity    TYPE zkok_quantity      READ-ONLY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCM_KOK_ZOO IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    me->if_abap_behv_message~m_severity = severity.
    me->clientid    = clientid.
    me->ordertypeid = ordertypeid.
    me->goodsid     = goodsid.
    me->quantity    = quantity.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
