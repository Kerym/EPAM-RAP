@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composite Client CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKOK_I_CLIENT as select from ZKOK_B_CLIENT 

{
    key ClientId,
        ClientFirstName,
        ClientLastName,
        Phone,
        Email,
        Adress,
        @Semantics.user.createdBy: true
        CreatedBy,
        @Semantics.systemDateTime.createdAt: true
        CreatedAt,
        @Semantics.user.lastChangedBy: true
        LastChangedBy,
        @Semantics.systemDateTime.lastChangedAt: true
        LastChangedAt
        
}
