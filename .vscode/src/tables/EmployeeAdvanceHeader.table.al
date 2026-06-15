table 50100 "Employee Advance Header"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Advance Header';

    fields
    {
        field(1; "Request No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Request No.';
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee; 
            Caption = 'Employee No.';

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
               
                if Emp.Get("Employee No.") then begin
                    "Employee Name" := Emp."First Name" + ' ' + Emp."Last Name";

                    Department := Emp."Job Title"; 
                end else begin
                    "Employee Name" := '';
                    Department := '';
                end;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false; 
        }
        field(4; Department; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false; 
        }
        field(5; "Request Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false; 
        }
        field(6; Status; Enum "Advance Status")
        {
            DataClassification = CustomerContent;
            Editable = false; // Locked: Only changed via Action buttons
        }
        field(7; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Employee Advance Line"."Line Amount" where("Request No." = field("Request No.")));
            Editable = false; 
        }
        field(8; "Approved Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false; 
            
            trigger OnValidate()
            begin
                Rec.CalcFields("Total Amount"); 
                if "Approved Amount" > "Total Amount" then
                    Error('Approved Amount (%1) cannot exceed the Total Requested Amount (%2).', "Approved Amount", "Total Amount");
            end;
        }
        field(9; Remarks; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Request No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Request Date" := Today;
        Status := Status::Open;
    end;
}