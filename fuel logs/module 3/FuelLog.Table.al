table 50102 "Fuel Log"
{
    DataClassification = CustomerContent;
    Caption = 'Fuel Log';
    LookupPageId = "Fuel Log List";
    DrillDownPageId = "Fuel Log List";

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

            trigger OnValidate()
            var
                VehicleRec: Record "Company Vehicle";
            begin
                if VehicleRec.Get("Vehicle No.") then begin
                    if Rec."Driver No." = '' then
                        Rec."Driver No." := VehicleRec."Assigned Driver";
                        
                    if Rec."Current Odometer Reading" = 0 then
                        Rec."Current Odometer Reading" := VehicleRec."Current Mileage";
                end;
            end;
        }
        field(3; "Driver No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Driver Number';
            TableRelation = Driver;
        }
        field(4; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(5; "Fuel Type"; Enum "Fuel Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Fuel Type';
        }
        field(6; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity (Liters/kWh)';
            DecimalPlaces = 0:2;

            trigger OnValidate()
            begin
                if Quantity <= 0 then
                    Error('Fuel quantity must be greater than zero.');
                
                CalculateTotalAmount();
            end;
        }
        field(7; "Price per Liter"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Price per Liter';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                if "Price per Liter" <= 0 then
                    Error('Fuel price must be greater than zero.');

                CalculateTotalAmount();
            end;
        }
        field(8; "Total Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount';
            Editable = false; // Prevent manual override
            AutoFormatType = 1;
        }
        field(9; "Current Odometer Reading"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Current Odometer Reading';
            DecimalPlaces = 0:2;

            trigger OnValidate()
            var
                VehicleRec: Record "Company Vehicle";
            begin
                if VehicleRec.Get("Vehicle No.") then begin
                    // Validation: Cannot be less than the vehicle's recorded mileage
                    if "Current Odometer Reading" < VehicleRec."Current Mileage" then
                        Error('Odometer reading (%1) cannot be less than the vehicle''s current mileage (%2).', "Current Odometer Reading", VehicleRec."Current Mileage");
                    
                    // Automatically update the Master Vehicle record with the new highest mileage
                    VehicleRec."Current Mileage" := "Current Odometer Reading";
                    VehicleRec.Modify(true);
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
        // Secondary key for fast sorting by Vehicle and Date
        key(VehicleDate; "Vehicle No.", Date) { } 
    }

    local procedure CalculateTotalAmount()
    begin
        "Total Amount" := Quantity * "Price per Liter";
    end;
}