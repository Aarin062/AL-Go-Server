table 50101 "Employee Advance Line"
{
    DataClassification = CustomerContent;
    Caption = 'Employee Advance Line';

    fields
    {
        field(1; "Request No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Employee Advance Header"; // Links child to parent
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Expense Type"; Enum "Expense Type")
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Validate(Description);
            end;
        }
        field(4; Description; Text[100])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if ("Expense Type" = "Expense Type"::Travel) and (Description = '') then
                    Error('A Description is mandatory when the Expense Type is Travel.');
            end;
        }
        field(5; Quantity; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Quantity <= 0 then
                    Error('Quantity cannot be zero or negative.');
                
                CalculateLineAmount();
            end;
        }
        field(6; "Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "Unit Cost" < 0 then
                    Error('Unit Cost cannot be negative.');
                
                CalculateLineAmount();
            end;
        }
        field(7; "Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false; // Calculated automatically
        }
        field(8; "Is Urgent"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Request No.", "Line No.") 
        {
            Clustered = true;
        }
    }

    local procedure CalculateLineAmount()
    begin
        "Line Amount" := Quantity * "Unit Cost";
    end;
}