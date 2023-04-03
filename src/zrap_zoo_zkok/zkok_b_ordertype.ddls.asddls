@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic OrderType CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZKOK_B_ORDERTYPE as select from zkok_d_ordertype {
    @ObjectModel.text.element: ['OrderTypeName']
    key ordertype_id as OrderTypeId,
    ordertypename as OrderTypeName,
    type_coeff as TypeCoeff
}
