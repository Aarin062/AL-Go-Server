table 50101 Driver
{
    DataClassification = CustomerContent;
    Caption = 'Driver';
    LookupPageId = "Driver List";
    DrillDownPageId = "Driver List";

    fields
    {
        field(1; "Driver No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Driver Number';
        }
        field(2; "Driver Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Driver Name';
        }
        field(3; "Contact No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Number';
            ExtendedDatatype = PhoneNo;
        }
        field(4; "License No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'License Number';
        }
        field(5; "License Expiry Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'License Expiry Date';

            trigger OnValidate()
            begin
                if "License Expiry Date" < Today then
                    Error('The License Expiry Date cannot be in the past. Date entered: %1', "License Expiry Date");
            end;
        }
        field(6; Department; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Department';
        }
        field(7; Status; Enum "Driver Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
    }

    keys
    {
        key(PK; "Driver No.")
        {
            Clustered = true;
        }
    }
    
    fieldgroups
    {
        fieldgroup(DropDown; "Driver No.", "Driver Name", "License No.") { }
    }
}