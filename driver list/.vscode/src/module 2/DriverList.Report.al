report 50101 "Driver List"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/src/module 2/DriverList.rdlc';
    Caption = 'Driver List';

    dataset
    {
        dataitem(CompanyInfo; "Company Information")
        {
            DataItemTableView = sorting("Primary Key");
            
            column(CompanyName; Name) { }
            column(CompanyPicture; Picture) { }


        dataitem(Driver; Driver)
        {
            RequestFilterFields = Department, Status;

            column(DriverNo; "Driver No.") { }
            column(DriverName; "Driver Name") { }
            column(ContactNo; "Contact No.") { }
            column(LicenseNo; "License No.") { }
            column(LicenseExpiryDate; "License Expiry Date") { }
            column(Department; Department) { }
            column(Status; Status) { }

            column(ContactAndDept; ContactAndDept) { }

            trigger OnAfterGetRecord()
            begin
                ContactAndDept := StrSubstNo('%1 / %2', Department, "Contact No.");
            end;
        }
            trigger OnPreDataItem()
            begin
                SetRange("Primary Key", '');
                if FindFirst() then
                    CalcFields(Picture);
            end;
    }}

    var
        ContactAndDept: Text;
}