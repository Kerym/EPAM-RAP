@AbapCatalog.sqlViewName: 'ZKOK_STATUS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Status CDS'
@ObjectModel.resultSet.sizeCategory: #XS

define view ZKOK_B_STATUS as select from zkok_d_status{

    @ObjectModel.text.element: ['StatusName']
    key status_id as StatusId,
    statusname as StatusName
}
