CLASS lhc_OrderItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateItemSubtotal FOR DETERMINE ON MODIFY
      IMPORTING keys FOR OrderItem~calculateItemSubtotal.

    METHODS validateGoods FOR VALIDATE ON SAVE
      IMPORTING keys FOR OrderItem~validateGoods.

    METHODS validateQuantity FOR VALIDATE ON SAVE
      IMPORTING keys FOR OrderItem~validateQuantity.

ENDCLASS.

CLASS lhc_OrderItem IMPLEMENTATION.

  METHOD calculateItemSubtotal.

    READ ENTITIES OF zkok_i_order IN LOCAL MODE
    ENTITY OrderItem BY \_Order
      FIELDS ( OrderUUID )
      WITH CORRESPONDING #( keys )
      RESULT DATA(Items)
      FAILED DATA(read_failed).

    MODIFY ENTITIES OF zkok_i_order IN LOCAL MODE
    ENTITY Order
      EXECUTE recalctotalprice
      FROM CORRESPONDING #( Items )
    REPORTED DATA(execute_reported).

    reported = CORRESPONDING #( DEEP execute_reported ).

  ENDMETHOD.

  METHOD validateGoods.

      READ ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY Orderitem
        FIELDS ( GoodsId OrderUuid ) WITH CORRESPONDING #( keys )
      RESULT DATA(orderitems).

    DATA goods TYPE SORTED TABLE OF zkok_d_goods WITH UNIQUE KEY goods_id.

    goods = CORRESPONDING #( orderitems DISCARDING DUPLICATES MAPPING goods_id = GoodsId EXCEPT * ).
    DELETE goods WHERE goods_id IS INITIAL.

    IF goods IS NOT INITIAL.
     SELECT FROM zkok_d_goods FIELDS goods_id
        FOR ALL ENTRIES IN @goods
        WHERE goods_id = @goods-goods_id
        INTO TABLE @DATA(gt_goods).
    ENDIF.

    LOOP AT orderitems ASSIGNING FIELD-SYMBOL(<ls_orderitem>).
      IF <ls_orderitem>-GoodsId IS INITIAL OR NOT line_exists( gt_goods[ goods_id = <ls_orderitem>-GoodsId ] ).
        APPEND VALUE #(  %tky = <ls_orderitem>-%tky ) TO failed-orderitem.

        APPEND VALUE #(  %tky        = <ls_orderitem>-%tky
                         %state_area = 'VALIDATE_GOODS'
                         %path       = VALUE #( Order-%is_draft = <ls_orderitem>-%is_draft
                                                Order-OrderUuid = <ls_orderitem>-OrderUuid )
                         %msg        = NEW zcm_kok_zoo(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_kok_zoo=>goods_unknown
                                           goodsid     = <ls_orderitem>-GoodsId )
                         %element-GoodsId = if_abap_behv=>mk-on )
          TO reported-orderitem.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateQuantity.

    READ ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY Orderitem
        FIELDS ( Quantity OrderUuid ) WITH CORRESPONDING #( keys )
      RESULT DATA(orderitems).

    DATA quantities TYPE SORTED TABLE OF zkok_d_orderitem WITH UNIQUE KEY orderitem_uuid.

    quantities = CORRESPONDING #( orderitems DISCARDING DUPLICATES MAPPING orderitem_uuid = OrderitemUuid EXCEPT * ).
    DELETE quantities WHERE quantity IS INITIAL.

    LOOP AT orderitems ASSIGNING FIELD-SYMBOL(<ls_orderitem>).
      IF <ls_orderitem>-Quantity < 1.
        APPEND VALUE #(  %tky = <ls_orderitem>-%tky ) TO failed-orderitem.

        APPEND VALUE #(  %tky        = <ls_orderitem>-%tky
                         %state_area = 'VALIDATE_QUANTITY'
                         %path       = VALUE #( Order-%is_draft = <ls_orderitem>-%is_draft
                                                Order-OrderUuid = <ls_orderitem>-OrderUuid )
                         %msg        = NEW zcm_kok_zoo(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_kok_zoo=>wrong_quantity
                                           quantity    = <ls_orderitem>-Quantity
                                            )
                         %element-Quantity = if_abap_behv=>mk-on )
          TO reported-orderitem.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
