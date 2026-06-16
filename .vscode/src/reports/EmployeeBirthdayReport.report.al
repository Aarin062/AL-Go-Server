report 50106 "Employee Birthday Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Emp Birthday Report';
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/src/reports/EmployeeBirthdayReport.rdlc';

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
        dataitem(EmployeeDetails; "Employee")
        {
            column(Employee_No; "No.") { }
            column(Department; "Job Title") { }
            column(Employee_Name; FullNameTxt) { }
            column(Birth_Date; "Birth Date") { }
            column(Gender; Gender) { }
            column(Status; Status) { }
            column(Mobile_No; "Mobile Phone No.") { }
            column(E_mail; "e-mail") { }

            trigger OnAfterGetRecord()
            begin
                FullNameTxt := "First Name" + ' ' + "Last Name";
            end;
        }
    }
    var
        FullNameTxt: Text[150];
}
 