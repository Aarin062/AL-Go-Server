table 50102 "Posted Advance Header"
{
    DataClassification = CustomerContent;
    Caption = 'Posted Advance Header';
    // No Insert/Validate triggers needed. History tables are read only.

    fields
    {
        field(1; "Posted No."; Code[20]) // Matches "Request No." ID
        {
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Employee Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; Department; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Posted Date"; Date) // Matches "Request Date" ID
        {
            DataClassification = CustomerContent;
        }
        field(7; "Total Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            // no longer a flowfield now
        }
    }

    keys
    {
        key(PK; "Posted No.")
        {
            Clustered = true;
        }
    }
}