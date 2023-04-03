@EndUserText.label: 'Consupmtion OrderItem CDS'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZKOK_C_ORDERITEM as projection on ZKOK_I_ORDERITEM  {

    key OrderitemUuid,
        OrderUuid,
        @Consumption.valueHelpDefinition: [{ entity : {name: 'zkok_b_goods' , element: 'GoodsId' } }]
        @EndUserText.label: 'Goods name'
        @ObjectModel.text.element: ['GoodsName']
        @Search.defaultSearchElement: true
        GoodsId,
        _Goods.Description as GoodsName,
        Price,
        Quantity,
        SubtotalPrice,
        CurrencyCode,
        LocalLastChangedAt,
        /* Associations */
        _Goods,
        _Order : redirected to parent ZKOK_C_ORDER
}
