report 50102 "Fuel Log List"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/src/module 3/FuelLogList.rdlc';
    Caption = 'Fuel Log Register';

    dataset
    {
        // Parent Dataitem
        dataitem(CompanyInfo; "Company Information")
        {
            DataItemTableView = sorting("Primary Key");
            
            column(CompanyPrimaryKey; "Primary Key") { }
            column(CompanyName; Name) { }
            column(CompanyPicture; Picture) { }

            dataitem(FuelLog; "Fuel Log")
            {
                RequestFilterFields = "Vehicle No.", "Driver No.", "Fuel Type", Date;

                column(LogNo; "Log No.") { }
                column(Date; Date) { }
                column(VehicleNo; "Vehicle No.") { }
                column(DriverNo; "Driver No.") { }
                column(FuelType; "Fuel Type") { }
                column(Quantity; Quantity) { }
                column(PriceperLiter; "Price per Liter") { }
                column(TotalAmount; "Total Amount") { }
                column(CurrentOdometer; "Current Odometer Reading") { }
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