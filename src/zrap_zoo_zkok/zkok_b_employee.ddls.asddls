@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Employee CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZKOK_B_EMPLOYEE as select from zkok_d_employee {
    @ObjectModel.text.element: ['EmployeeFirstName']
    key empl_id as EmployeeId,
    empl_first_name as EmployeeFirstName,
    empl_last_name as EmployeeLastName,
    phone as Phone,
    email as Email,
    adress as Adress,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt
}
