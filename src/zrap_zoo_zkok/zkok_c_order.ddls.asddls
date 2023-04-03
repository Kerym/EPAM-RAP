@EndUserText.label: 'Consupmtion Order CDS'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['OrderId']


define root view entity ZKOK_C_ORDER as projection on ZKOK_I_ORDER {

    key OrderUuid,
        OrderId,
        @Consumption.valueHelpDefinition: [{ entity : {name: 'zkok_b_client' , element: 'ClientId' } }]
        @EndUserText.label: 'Client'
        @ObjectModel.text.element: ['ClientFullName']
        @Search.defaultSearchElement: true
        @UI.textArrangement: #TEXT_ONLY
        ClientId,
        ClientFullName,
        @Consumption.valueHelpDefinition: [{ entity : {name: 'zkok_b_employee' , element: 'EmployeeId' } }]
        @EndUserText.label: 'Employee'
        @ObjectModel.text.element: ['EmployeeFullName']
        @Search.defaultSearchElement: true
        @UI.textArrangement: #TEXT_ONLY
        EmployeeId,
        EmployeeFullName,
        @Consumption.valueHelpDefinition: [{ entity : {name: 'zkok_b_status' , element: 'StatusId' } }]
        @EndUserText.label: 'Status'
        @ObjectModel.text.element: ['Status']
        @Search.defaultSearchElement: true
        @UI.textArrangement: #TEXT_ONLY
        StatusId,
        _Status.StatusName as Status,
        StatusIndicator,
        @Consumption.valueHelpDefinition: [{ entity : {name: 'zkok_b_ordertype' , element: 'OrderTypeId' } }]
        @EndUserText.label: 'OrderType'
        @ObjectModel.text.element: ['OrderType']
        @Search.defaultSearchElement: true
        @UI.textArrangement: #TEXT_ONLY
        OrdertypeId,
        _OrderType.OrderTypeName as OrderType,
        SaleCoeff, 
        @Semantics.amount.currencyCode: 'CurrencyCode'
        OrderPrice,
        CurrencyCode,
        CreatedBy,
        CreatedAt,
        LastChangedBy,
        LastChangedAt,
        LocalLastChangedAt,
        /* Associations */
        _Client,
        _Employee,
        _OrderItem : redirected to composition child ZKOK_C_ORDERITEM,
        _OrderType,
        _Status
}
