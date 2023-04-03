

CLASS zcl_generate_demodata_zkok DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
    METHODS fill_employee
      IMPORTING
        out TYPE REF TO if_oo_adt_classrun_out.
    METHODS fill_client
      IMPORTING
        out TYPE REF TO if_oo_adt_classrun_out.
    METHODS fill_goods
      IMPORTING
        out TYPE REF TO if_oo_adt_classrun_out.
    METHODS fill_status
      IMPORTING
        out TYPE REF TO if_oo_adt_classrun_out.
    METHODS fill_ordertype
      IMPORTING
        out TYPE REF TO if_oo_adt_classrun_out.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GENERATE_DEMODATA_ZKOK IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    fill_employee( out ).
    fill_client( out ).
    fill_goods( out ).
    fill_status( out ).
    fill_ordertype( out ).
  ENDMETHOD.


  METHOD fill_employee.
    " delete existing entries in the database table
    DELETE FROM zkok_d_employee.
    DELETE FROM zkok_d_client.

    " insert travel demo data
    INSERT zkok_d_employee FROM (
        SELECT
          FROM /dmo/customer
          FIELDS
            customer_id            AS empl_id               ,
            first_name             AS empl_first_name       ,
            last_name              AS empl_last_name        ,
            phone_number           AS phone                 ,
            email_address          AS email                 ,
            street                 AS address               ,
            local_created_by       AS created_by            ,
            local_created_at       AS created_at            ,
            local_last_changed_by  AS last_changed_by       ,
            local_last_changed_at  AS last_changed_at
            ORDER BY customer_id ASCENDING UP TO 100 ROWS
      ).

    COMMIT WORK.

    IF sy-subrc = 0.
      out->write( |{ sy-dbcnt } records of Employee are inserted!| ).
    ELSE.
      out->write( 'error' ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_client.
    " insert booking demo data
    INSERT zkok_d_client FROM (
        SELECT
          FROM /dmo/customer
          FIELDS
            customer_id            AS clnt_id               ,
            first_name             AS clnt_first_name       ,
            last_name              AS clnt_last_name        ,
            phone_number           AS phone                 ,
            email_address          AS email                 ,
            street                 AS address               ,
            local_created_by       AS created_by            ,
            local_created_at       AS created_at            ,
            local_last_changed_by  AS last_changed_by       ,
            local_last_changed_at  AS last_changed_at
            WHERE customer_id BETWEEN '000100' AND '000199'
            ORDER BY customer_id
      ).
    COMMIT WORK.

    IF sy-subrc = 0.
      out->write( |{ sy-dbcnt } records of Client are inserted!| ).
    ELSE.
      out->write( 'error' ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_goods.
    DATA: it_data TYPE TABLE OF zkok_d_goods.

    it_data = VALUE #(

    ( goods_id = '000001'  description = 'Whiskas - Mini fillet chicken jelly, pouch 85 g' quantity = '2500' price = '0.30' currency_code = 'USD' )
    ( goods_id = '000002'  description = 'Felix - Delicious pads for kittens with milk, with turkey and carrots, 350 ml' quantity = '2000' price = '2.84' currency_code = 'USD' )
    ( goods_id = '000003'  description = 'Pedigree - Markis dog treat, 150 g' quantity = '3000' price = '1.22' currency_code = 'USD' )
    ( goods_id = '000004'  description = 'AQUA - aquariums, 15L' quantity = '500' price = '100.00' currency_code = 'USD' )
    ( goods_id = '000006'  description = 'Kesha - seeds, 250g' quantity = '1300' price = '1.50' currency_code = 'USD' )
    ( goods_id = '000005'  description = 'AQUA - aquariums, 25L' quantity = '300' price = '150.00' currency_code = 'USD' )
    ( goods_id = '000007'  description = 'RIO - grain, 150g' quantity = '1200' price = '1.10' currency_code = 'USD' )
    ( goods_id = '000008'  description = 'Purina - Mini fillet chicken jelly, pouch 85 g' quantity = '2500' price = '0.40' currency_code = 'USD' )
    ( goods_id = '000009'  description = 'Felix - Delicious pads for kittens with milk, with turkey and carrots, 350 g' quantity = '2400' price = '1.84' currency_code = 'USD' )
    ( goods_id = '000010'  description = 'ZETA - cage for rodents, XS' quantity = '300' price = '45.00' currency_code = 'USD' )
    ( goods_id = '000011'  description = 'ZETA - cage for rodents, XL' quantity = '200' price = '60.00' currency_code = 'USD' )
    ( goods_id = '000012'  description = 'Baddy Best - cage for ferret, M' quantity = '150' price = '65.00' currency_code = 'USD' )
    ( goods_id = '000013'  description = 'Lovely Home - aquarium for reptile, 15L' quantity = '130' price = '100.00' currency_code = 'USD' )
    ( goods_id = '000014'  description = 'Felix - Delicious pads for kittens with milk, with turkey and carrots, 350 ml' quantity = '2000' price = '2.84' currency_code = 'USD' )
    ( goods_id = '000015'  description = 'Felix - Delicious pads for kittens with milk, with turkey and carrots, 550 ml' quantity = '2000' price = '4.62' currency_code = 'USD' )
    ( goods_id = '000016'  description = 'Kesha - seeds, 350g' quantity = '1000' price = '2.50' currency_code = 'USD' )
    ( goods_id = '000017'  description = 'Kesha - seeds, 450g' quantity = '1000' price = '3.50' currency_code = 'USD' )
    ( goods_id = '000018'  description = 'Kesha - seeds, 550g' quantity = '400' price = '4.50' currency_code = 'USD' )
    ( goods_id = '000019'  description = 'Kesha - seeds, 6000g' quantity = '100' price = '5.50' currency_code = 'USD' )
    ( goods_id = '000020'  description = 'Kesha - seeds, 550g' quantity = '400' price = '4.50' currency_code = 'USD' )
    ( goods_id = '000021'  description = 'Kesha - seeds, 1000g' quantity = '100' price = '7.50' currency_code = 'USD' )


    ).
    DELETE FROM zkok_d_goods.
    INSERT zkok_d_goods FROM TABLE @it_data.
    IF sy-subrc = 0.
      out->write( |{ sy-dbcnt } records of Goods are inserted!| ).
    ELSE.
      out->write( 'error' ).
    ENDIF.

    COMMIT WORK.
  ENDMETHOD.


    METHOD fill_status.
    DATA: it_data TYPE TABLE OF zkok_d_status.

      it_data = VALUE #(
      ( status_id = '1'  statusname = 'Created'   )
      ( status_id = '2'  statusname = 'Confirmed' )
      ( status_id = '3'  statusname = 'Canceled'  )
      ( status_id = '4'  statusname = 'Completed' )

      ).
        DELETE FROM zkok_d_status.
        INSERT zkok_d_status FROM TABLE @it_data.
        IF sy-subrc = 0.
          out->write( |{ sy-dbcnt } records of Status are inserted!| ).
        ELSE.
          out->write( 'error' ).
        ENDIF.

        COMMIT WORK.

  ENDMETHOD.


    METHOD fill_ordertype.
    DATA: it_data TYPE TABLE OF zkok_d_ordertype.

      it_data = VALUE #(
      ( ordertype_id = '1'  ordertypename = 'Online-store(20%)'  type_coeff = '0.80' )
      ( ordertype_id = '2'  ordertypename = 'Offline-store(0%)' type_coeff = '1.00' )

      ).
        DELETE FROM zkok_d_ordertype.
        INSERT zkok_d_ordertype FROM TABLE @it_data.
        IF sy-subrc = 0.
          out->write( |{ sy-dbcnt } records of Order Type are inserted!| ).
        ELSE.
          out->write( 'error' ).
        ENDIF.

        COMMIT WORK.

  ENDMETHOD.
ENDCLASS.
