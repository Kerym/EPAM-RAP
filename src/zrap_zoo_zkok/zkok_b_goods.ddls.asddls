@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Goods CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKOK_B_GOODS

    as select from zkok_d_goods 
    association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency {
    
    @ObjectModel.text.element: ['Description']
    key goods_id as GoodsId,
    description as Description,
    quantity as Quantity,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    currency_code as CurrencyCode,
    
    _Currency
    
}
