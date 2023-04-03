CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF order_status,
        created   TYPE c LENGTH 1  VALUE '1',
        confirmed TYPE c LENGTH 1  VALUE '2',
        canceled  TYPE c LENGTH 1  VALUE '3',
        completed TYPE c LENGTH 1  VALUE '4',
      END OF order_status.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Order RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Order RESULT result.

    METHODS canceledStatus FOR MODIFY
      IMPORTING keys FOR ACTION Order~canceledStatus RESULT result.

    METHODS completedStatus FOR MODIFY
      IMPORTING keys FOR ACTION Order~completedStatus RESULT result.

    METHODS confirmedStatus FOR MODIFY
      IMPORTING keys FOR ACTION Order~confirmedStatus RESULT result.

    METHODS recalcTotalPrice FOR MODIFY
      IMPORTING keys FOR ACTION Order~recalcTotalPrice.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Order~calculateTotalPrice.

    METHODS setOrderId FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~setOrderId.

    METHODS validateClient FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateClient.

    METHODS validateOrderType FOR VALIDATE ON SAVE
      IMPORTING keys FOR Order~validateOrderType.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY Order
        FIELDS ( StatusId ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders)
      FAILED failed.

    result =
      VALUE #(
        FOR order IN orders
          LET is_confirmed =   COND #( WHEN order-StatusId = order_status-confirmed
                                         THEN if_abap_behv=>fc-o-disabled
                                         ELSE if_abap_behv=>fc-o-enabled )
              is_canceled  =   COND #( WHEN order-StatusId = order_status-canceled
                                         THEN if_abap_behv=>fc-o-disabled
                                         ELSE if_abap_behv=>fc-o-enabled  )
              is_completed =   COND #( WHEN order-StatusId = order_status-completed
                                         THEN if_abap_behv=>fc-o-disabled
                                         ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                    = order-%tky
              %action-confirmedStatus = is_confirmed
              %action-canceledStatus  = is_canceled
              %action-completedStatus = is_completed
             ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD canceledStatus.

    MODIFY ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY Order
         UPDATE
           FIELDS ( StatusId )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             StatusId = order_status-canceled ) )
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY Order
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    result = VALUE #( FOR order IN orders
                        ( %tky   = order-%tky
                          %param = order ) ).

  ENDMETHOD.

  METHOD completedStatus.

    MODIFY ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY Order
         UPDATE
           FIELDS ( StatusId )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             StatusId = order_status-completed ) )
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY Order
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    result = VALUE #( FOR order IN orders
                        ( %tky   = order-%tky
                          %param = order ) ).

  ENDMETHOD.

  METHOD confirmedStatus.

    MODIFY ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY Order
         UPDATE
           FIELDS ( StatusId )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             StatusId = order_status-confirmed ) )
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY Order
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    result = VALUE #( FOR order IN orders
                        ( %tky   = order-%tky
                          %param = order ) ).

  ENDMETHOD.

  METHOD recalcTotalPrice.

    TYPES: BEGIN OF ty_price_currencycode,
             amount        TYPE /dmo/total_price,
             currency_code TYPE /dmo/currency_code,
           END OF ty_price_currencycode.

    DATA: price_with_currencycode TYPE STANDARD TABLE OF ty_price_currencycode.
    DATA: tt_cart TYPE TABLE FOR UPDATE zkok_i_order\\OrderItem.

    READ ENTITIES OF zkok_i_order IN LOCAL MODE
         ENTITY Order
            FIELDS ( OrdertypeId )
            WITH CORRESPONDING #( keys )
         RESULT DATA(orders).

    DELETE orders WHERE OrdertypeId IS INITIAL.

    LOOP AT orders ASSIGNING FIELD-SYMBOL(<order>).

      SELECT SINGLE typecoeff
          FROM zkok_b_ordertype AS OrderType
          WHERE OrderType~OrderTypeId = @<order>-OrdertypeId
              INTO @DATA(ls_typecoeff).

      READ ENTITIES OF zkok_i_order IN LOCAL MODE
        ENTITY Order BY \_OrderItem
          FIELDS ( GoodsId Quantity )
        WITH VALUE #( ( %tky = <order>-%tky ) )
        RESULT DATA(OrderItem).

      LOOP AT OrderItem ASSIGNING FIELD-SYMBOL(<Items>).
        SELECT SINGLE Price
            FROM zkok_b_goods
            WHERE zkok_b_goods~GoodsId = @<Items>-GoodsId
                INTO @DATA(lv_price).
        <Items>-Price = lv_price.
        <Items>-SubtotalPrice = lv_price * <Items>-Quantity.

        SELECT SINGLE CurrencyCode
            FROM zkok_b_goods
            WHERE zkok_b_goods~GoodsId = @<Items>-GoodsId
                INTO @DATA(lv_curr).
        <Items>-CurrencyCode = lv_curr.

        APPEND VALUE #(
                amount = <Items>-SubtotalPrice * ls_typecoeff
                currency_code = <Items>-CurrencyCode
                      ) TO price_with_currencycode.

        APPEND VALUE #(
                %tky          = <Items>-%tky
                GoodsID       = <Items>-GoodsId
                Price         = <Items>-Price
                SubtotalPrice = <Items>-SubtotalPrice
                CurrencyCode  = <Items>-CurrencyCode
                %control-GoodsId       = if_abap_behv=>mk-on
                %control-Price         = if_abap_behv=>mk-on
                %control-SubtotalPrice = if_abap_behv=>mk-on
                %control-CurrencyCode  = if_abap_behv=>mk-on
                       ) TO tt_cart.

      ENDLOOP.

      MODIFY ENTITIES OF zkok_i_order IN LOCAL MODE
                ENTITY OrderItem
                  UPDATE FIELDS ( Price SubtotalPrice CurrencyCode ) WITH tt_cart.

      CLEAR <order>-OrderPrice.

      LOOP AT price_with_currencycode ASSIGNING FIELD-SYMBOL(<ls_data>).
        <order>-OrderPrice += <ls_data>-amount.
        <order>-CurrencyCode = <ls_data>-currency_code.
      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY order
        UPDATE FIELDS ( OrderPrice CurrencyCode )
        WITH CORRESPONDING #( orders ).

  ENDMETHOD.

  METHOD calculateTotalPrice.
    MODIFY ENTITIES OF zkok_i_order IN LOCAL MODE
    ENTITY order
      EXECUTE recalcTotalPrice
      FROM CORRESPONDING #( keys )
    REPORTED DATA(execute_reported).

    reported = CORRESPONDING #( DEEP execute_reported ).
  ENDMETHOD.

  METHOD setOrderId.

    READ ENTITIES OF zkok_i_order IN LOCAL MODE
          ENTITY Order
            FIELDS ( OrderId ) WITH CORRESPONDING #( keys )
          RESULT DATA(orders).

    DELETE orders WHERE OrderId IS NOT INITIAL.

    CHECK orders IS NOT INITIAL.

    SELECT SINGLE
        FROM  zkok_d_order
        FIELDS MAX( order_id ) AS OrderId
        INTO @DATA(max_orderid).

    MODIFY ENTITIES OF zkok_i_order IN LOCAL MODE
    ENTITY Order
      UPDATE
        FROM VALUE #( FOR order IN orders INDEX INTO i (
          %tky             = order-%tky
          OrderId          = max_orderid + i
          StatusId         = '1'
          %control-OrderId = if_abap_behv=>mk-on
          %control-StatusId = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD validateClient.

    READ ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY Order
        FIELDS ( ClientId ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    DATA clients TYPE SORTED TABLE OF zkok_d_client WITH UNIQUE KEY clnt_id.

    clients = CORRESPONDING #( orders DISCARDING DUPLICATES MAPPING clnt_id = ClientId EXCEPT * ).
    DELETE clients WHERE clnt_id IS INITIAL.

    IF clients IS NOT INITIAL.
      SELECT FROM zkok_d_client FIELDS clnt_id
        FOR ALL ENTRIES IN @clients
        WHERE clnt_id = @clients-clnt_id
        INTO TABLE @DATA(gt_clients).
    ENDIF.

    LOOP AT orders INTO DATA(order).
      IF order-ClientId IS INITIAL OR NOT line_exists( gt_clients[ clnt_id = order-ClientId ] ).
        APPEND VALUE #(  %tky = order-%tky ) TO failed-order.

        APPEND VALUE #(  %tky        = order-%tky
                         %state_area = 'VALIDATE_CLIENT'
                         %msg        = NEW zcm_kok_zoo(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_kok_zoo=>client_unknown
                                           clientid   = order-ClientId )
                         %element-ClientId = if_abap_behv=>mk-on )
          TO reported-order.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateOrderType.

    READ ENTITIES OF zkok_i_order IN LOCAL MODE
      ENTITY Order
        FIELDS ( OrdertypeId ) WITH CORRESPONDING #( keys )
      RESULT DATA(orders).

    DATA ordertypes TYPE SORTED TABLE OF zkok_d_ordertype WITH UNIQUE KEY ordertype_id.

    ordertypes = CORRESPONDING #( orders DISCARDING DUPLICATES MAPPING ordertype_id = OrdertypeId EXCEPT * ).
    DELETE ordertypes WHERE ordertype_id IS INITIAL.

    IF ordertypes IS NOT INITIAL.
     SELECT FROM zkok_d_ordertype FIELDS ordertype_id
        FOR ALL ENTRIES IN @ordertypes
        WHERE ordertype_id = @ordertypes-ordertype_id
        INTO TABLE @DATA(gt_ordertypes).
    ENDIF.

    LOOP AT orders INTO DATA(order).
      IF order-OrdertypeId IS INITIAL OR NOT line_exists( gt_ordertypes[ ordertype_id = order-OrdertypeId ] ).
        APPEND VALUE #(  %tky = order-%tky ) TO failed-order.

        APPEND VALUE #(  %tky        = order-%tky
                         %state_area = 'VALIDATE_ORDERTYPE'
                         %msg        = NEW zcm_kok_zoo(
                                           severity    = if_abap_behv_message=>severity-error
                                           textid      = zcm_kok_zoo=>ordertype_unknown
                                           ordertypeid = order-OrdertypeId )
                         %element-OrdertypeId = if_abap_behv=>mk-on )
          TO reported-order.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
