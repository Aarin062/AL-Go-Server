table 50100 "Company Vehicle"
{
    DataClassification = CustomerContent;
    Caption = 'Company Vehicle';

    fields
    {
        field(1; "Vehicle No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vehicle Number';

            trigger OnValidate()
            var
                ExistingVehicle: Record "Company Vehicle";
            begin
                // Check if the number entered already exists in the database
                if ExistingVehicle.Get(Rec."Vehicle No.") then
                    Error('The Vehicle Number %1 is already in use.', Rec."Vehicle No.");
            end;
        }
        field(2; "Registration No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Registration Number';
        }
        field(3; "Vehicle Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Vehicle Name';
        }
        field(4; "Vehicle Type"; Enum "Company Vehicle Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Vehicle Type';
        }
        field(5; Brand; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Brand';
        }
        field(6; Model; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Model';
        }
        field(7; "Purchase Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Date';
        }
        field(8; "Purchase Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Cost';
            AutoFormatType = 1; 
        }
        field(9; "Current Mileage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Current Mileage';
            DecimalPlaces = 0:2;
        }
        field(10; Status; Enum "Company Vehicle Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(11; "Assigned Driver"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Assigned Driver';
            TableRelation = Employee; 
        }
    }

    keys
    {
        key(PK; "Vehicle No.")
        {
            Clustered = true;
        }
    }
    
    fieldgroups
    {
        fieldgroup(DropDown; "Vehicle No.", "Registration No.", "Vehicle Name") { }
    }
}