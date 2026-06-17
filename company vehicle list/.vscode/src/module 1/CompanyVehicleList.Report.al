report 50100 "Company Vehicle List"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/src/module 1/CompanyVehicleList.rdlc';
    Caption = 'Company Vehicle List';

    dataset
    {
        dataitem(CompanyInfo; "Company Information")
        {
            // DataItemTableView = sorting("Primary Key");
            
            column(CompanyName; Name) { }
            column(CompanyPicture; Picture) { }

            // trigger OnPreDataItem()
            // begin
            //     SetRange("Primary Key", '');
            //     if FindFirst() then
            //         CalcFields(Picture);
            // end;
        

        dataitem(Vehicle; "Company Vehicle")
        {
            RequestFilterFields = "Vehicle Type", Status;

            column(VehicleNo; "Vehicle No.") { }
            column(RegistrationNo; "Registration No.") { }
            column(VehicleType; "Vehicle Type") { }
            column(PurchaseDate; "Purchase Date") { }
            column(Status; Status) { }
            column(AssignedDriver; "Assigned Driver") { }
            
            column(FullVehicleDesc; FullVehicleDesc) { }

            trigger OnAfterGetRecord()
            begin
                FullVehicleDesc := StrSubstNo('%1 %2 (%3)', Brand, Model, "Vehicle Name");
            end;
        }}
    }

    var
        FullVehicleDesc: Text;
}