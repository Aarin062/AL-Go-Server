table 50103 "Vehicle Trip"
{
    DataClassification = CustomerContent;
    Caption = 'Vehicle Trip';
    LookupPageId = "Vehicle Trip List";
    DrillDownPageId = "Vehicle Trip List";

    fields
    {
        field(1; "Trip No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Trip Number';
        }
        field(2; "Vehicle No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vehicle Number';
            TableRelation = "Company Vehicle";

            trigger OnValidate()
            var
                VehicleRec: Record "Company Vehicle";
            begin
                if VehicleRec.Get("Vehicle No.") then begin
                    if Rec."Driver No." = '' then
                        Rec."Driver No." := VehicleRec."Assigned Driver";
                        
                    if Rec."Start Kilometer" = 0 then
                        Rec."Start Kilometer" := VehicleRec."Current Mileage";
                end;
            end;
        }
        field(3; "Driver No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Driver Number';
            TableRelation = Driver;
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        }
        field(5; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';

            trigger OnValidate()
            begin
                if ("End Date" <> 0D) and ("End Date" < "Start Date") then
                    Error('End Date (%1) cannot be earlier than Start Date (%2).', "End Date", "Start Date");
            end;
        }
        field(6; Source; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Source';
        }
        field(7; Destination; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Destination';
        }
        field(8; Purpose; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Purpose';
        }
        field(9; "Start Kilometer"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Kilometer';
            DecimalPlaces = 0:2;

            trigger OnValidate()
            begin
                CalculateTotalDistance();
            end;
        }
        field(10; "End Kilometer"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'End Kilometer';
            DecimalPlaces = 0:2;

            trigger OnValidate()
            var
                VehicleRec: Record "Company Vehicle";
            begin
                if ("End Kilometer" <> 0) and ("End Kilometer" < "Start Kilometer") then
                    Error('End Kilometer (%1) cannot be less than Start Kilometer (%2).', "End Kilometer", "Start Kilometer");

                CalculateTotalDistance();

                // Automatically update the Master Vehicle record with the new highest mileage
                if VehicleRec.Get("Vehicle No.") then begin
                    if "End Kilometer" > VehicleRec."Current Mileage" then begin
                        VehicleRec."Current Mileage" := "End Kilometer";
                        VehicleRec.Modify(true);
                    end;
                end;
            end;
        }
        field(11; "Total Distance"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Distance Traveled';
            Editable = false; 
            DecimalPlaces = 0:2;
        }
    }

    keys
    {
        key(PK; "Trip No.")
        {
            Clustered = true;
        }
    }

    local procedure CalculateTotalDistance()
    begin
        if ("Start Kilometer" > 0) and ("End Kilometer" > 0) then
            "Total Distance" := "End Kilometer" - "Start Kilometer"
        else
            "Total Distance" := 0;
    end;
}