report 50104 "Maintenance Log List"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/src/module 5/MaintenanceLogList.rdlc';
    Caption = 'Vehicle Maintenance Register';

    dataset
    {
        dataitem(CompanyInfo; "Company Information")
        {
            DataItemTableView = sorting("Primary Key");
            
            column(CompanyPrimaryKey; "Primary Key") { }
            column(CompanyName; Name) { }
            column(CompanyPicture; Picture) { }


            dataitem(Maintenance; "Maintenance Log")
            {
                RequestFilterFields = "Vehicle No.", "Maintenance Type", "Maintenance Date";

                column(LogNo; "Log No.") { }
                column(VehicleNo; "Vehicle No.") { }
                column(MaintenanceDate; "Maintenance Date") { }
                column(MaintenanceType; "Maintenance Type") { }
                column(Vendor; Vendor) { }
                column(Cost; Cost) { }
                column(Description; Description) { }
                column(NextServiceKm; "Next Service Kilometer") { }
            }
            
            trigger OnPreDataItem()
            begin
                SetRange("Primary Key", '');
                if FindFirst() then
                    CalcFields(Picture);
            end;
        }
    }
}