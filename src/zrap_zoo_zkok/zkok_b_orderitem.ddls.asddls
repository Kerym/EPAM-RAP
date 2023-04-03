@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic OrderItem CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKOK_B_ORDERITEM as select from zkok_d_orderitem {
    key orderitem_uuid as OrderitemUuid,
    order_uuid as OrderUuid,
    goods_id as GoodsId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    quantity as Quantity,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    subtotal_price as SubtotalPrice,
    currency_code as CurrencyCode,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt
}
