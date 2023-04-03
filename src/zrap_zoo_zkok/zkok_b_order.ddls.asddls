@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Order CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKOK_B_ORDER as select from zkok_d_order {
    key order_uuid as OrderUuid,
    order_id as OrderId,
    clnt_id as ClientId,
    empl_id as EmployeeId,
    status_id as StatusId,
    ordertype_id as OrdertypeId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    order_price as OrderPrice,
    currency_code as CurrencyCode,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt
}
