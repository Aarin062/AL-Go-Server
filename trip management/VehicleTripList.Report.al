report 50103 "Vehicle Trip List"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/src/module 4/VehicleTripList.rdlc';
    Caption = 'Vehicle Trip Register';

    dataset
    {
        dataitem(CompanyInfo; "Company Information")
        {
            DataItemTableView = sorting("Primary Key");
            
            column(CompanyPrimaryKey; "Primary Key") { }
            column(CompanyName; Name) { }
            column(CompanyPicture; Picture) { }

            trigger OnPreDataItem()
            begin
                SetRange("Primary Key", '');
                if FindFirst() then
                    CalcFields(Picture);
            end;

        }

        dataitem(Trip; "Vehicle Trip")
        {
            RequestFilterFields = "Vehicle No.", "Driver No.", "Start Date";

            column(TripNo; "Trip No.") { }
            column(VehicleNo; "Vehicle No.") { }
            column(DriverNo; "Driver No.") { }
            column(StartDate; "Start Date") { }
            column(EndDate; "End Date") { }
            column(Source; Source) { }
            column(Destination; Destination) { }
            column(TotalDistance; "Total Distance") { }
        }
    }
}
