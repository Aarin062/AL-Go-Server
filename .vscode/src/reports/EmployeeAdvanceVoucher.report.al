report 50100 "Employee Advance Voucher"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Employee Advance Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/src/reports/EmployeeAdvanceVoucher.rdlc';

    dataset
    {
        // DATAITEM 1: Company Information (For the Logo and Name)
        dataitem(CompanyInfo; "Company Information")
        {
            column(CompanyName; Name) { }
            column(CompanyPicture; Picture) { }

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture); // Required to load images
            end;
        }

        // DATAITEM 2: The Document Header
        dataitem(AdvanceHeader; "Employee Advance Header")
        {
            RequestFilterFields = "Request No.", "Employee No.", Status;

            column(Request_No; "Request No.") { }
            column(Request_Date; "Request Date") { }
            column(Employee_No; "Employee No.") { }
            column(Employee_Name; "Employee Name") { }
            column(Department; Department) { }
            column(Status; Status) { }
            column(Total_Amount; "Total Amount") { }
            column(Approved_Amount; "Approved Amount") { }
            column(Remarks; Remarks) { }

            trigger OnAfterGetRecord()
            begin
                // Ensures the FlowField is calculated 
                AdvanceHeader.CalcFields("Total Amount");
            end;
        }

            // DATAITEM 3: The Document Lines
            dataitem(AdvanceLine; "Employee Advance Line")
        {
                // pull lines that belong to the specific header currently printing
                DataItemLink = "Request No." = field("Request No.");
                DataItemLinkReference = AdvanceHeader;

            column(Expense_Type; "Expense Type") { }
            column(Description; Description) { }
            column(Quantity; Quantity) { }
            column(Unit_Cost; "Unit Cost") { }
            column(Line_Amount; "Line Amount") { }
            column(Is_Urgent; "Is Urgent") { }
        }
    }
}
