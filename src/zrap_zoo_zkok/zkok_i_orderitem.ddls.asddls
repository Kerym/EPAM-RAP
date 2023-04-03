@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composite OrderItem CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKOK_I_ORDERITEM as select from ZKOK_B_ORDERITEM

  association to parent ZKOK_I_ORDER  as _Order on $projection.OrderUuid = _Order.OrderUuid
  association [1] to ZKOK_B_GOODS     as _Goods on $projection.GoodsId   = _Goods.GoodsId

 {
    key OrderitemUuid,
    OrderUuid,
    GoodsId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    Quantity,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    SubtotalPrice,
    CurrencyCode,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    LocalLastChangedAt,
    
    _Order,
    _Goods
    
}
