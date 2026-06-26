table 50104 "Maintenance Log"
{
    DataClassification = CustomerContent;
    Caption = 'Maintenance Log';
    LookupPageId = "Maintenance Log List";
    DrillDownPageId = "Maintenance Log List";

    fields
    {
        field(1; "Log No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Log Number';
        }
        field(2; "Vehicle No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vehicle Number';
            TableRelation = "Company Vehicle";
        }
        field(3; "Maintenance Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Maintenance Date';
        }
        field(4; "Maintenance Type"; Enum "Maintenance Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Maintenance Type';
        }
        field(5; Vendor; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor';
        }
        field(6; Cost; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cost';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                if Cost < 0 then
                    Error('Maintenance Cost cannot be negative.');
            end;
        }
        field(7; Description; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(8; "Next Service Kilometer"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Next Service Kilometer';
            DecimalPlaces = 0:2;

            trigger OnValidate()
            var
                VehicleRec: Record "Company Vehicle";
            begin
                if VehicleRec.Get("Vehicle No.") then begin
                    // Validation: Next service must be in the future, logically higher than current mileage
                    if ("Next Service Kilometer" <> 0) and ("Next Service Kilometer" <= VehicleRec."Current Mileage") then
                        Error('Next Service Kilometer (%1) must be greater than the vehicle''s current mileage (%2).', "Next Service Kilometer", VehicleRec."Current Mileage");
                end;
            end;
        }
    }

    keys
    {
        key(PK; "Log No.")
        {
            Clustered = true;
        }
    }
}