@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composite Order CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZKOK_I_ORDER as select from ZKOK_B_ORDER

  composition [1..*] of ZKOK_I_ORDERITEM as _OrderItem
  
  association [1] to ZKOK_I_CLIENT       as _Client    on $projection.ClientId    = _Client.ClientId

  association [1] to ZKOK_B_EMPLOYEE     as _Employee  on $projection.EmployeeId  = _Employee.EmployeeId
  association [1] to ZKOK_B_STATUS       as _Status    on $projection.StatusId    = _Status.StatusId
  association [1] to ZKOK_B_ORDERTYPE    as _OrderType on $projection.OrdertypeId = _OrderType.OrderTypeId
  
 {
    key OrderUuid,
        OrderId,
        ClientId,
        concat_with_space( _Client.ClientFirstName, _Client.ClientLastName, 1) as ClientFullName,
        EmployeeId,
        concat_with_space( _Employee.EmployeeFirstName, _Employee.EmployeeLastName, 1) as EmployeeFullName,
        StatusId,
        case StatusId
             when '000001'  then 2    -- 'created'    | 2: yellow colour
             when '000002'  then 3    -- 'confirmed'  | 3: green colour
             when '000003'  then 1    -- 'canceled'   | 1: red colour
             when '000004'  then 3    -- 'completed'  | 3: green colour
             else 2                   -- 'created'    | 2: yellow colour
        end                                        as StatusIndicator,
        OrdertypeId,
        _OrderType.TypeCoeff     as SaleCoeff,
        @Semantics.amount.currencyCode: 'CurrencyCode'
        OrderPrice,
        CurrencyCode,
        @Semantics.user.createdBy: true
        CreatedBy,
        @Semantics.systemDateTime.createdAt: true
        CreatedAt,
        @Semantics.user.lastChangedBy: true
        LastChangedBy,
        @Semantics.systemDateTime.lastChangedAt: true
        LastChangedAt,
        @Semantics.systemDateTime.localInstanceLastChangedAt: true
        LocalLastChangedAt,
        
        _OrderItem,
        _Client,
        _Employee,
        _Status,
        _OrderType
}
