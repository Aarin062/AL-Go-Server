table 50101 "Custom Requisition Line"
{
    DataClassification = CustomerContent;
    Caption = 'Requisition Line';

    fields
    {
        field(1; "Requisition No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Requisition No.';
            TableRelation = "Custom Requisition Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                ItemRec: Record Item;
            begin
                // Fetch details from the standard Item table
                if ItemRec.Get(Rec."Item No.") then begin
                    Rec.Description := ItemRec.Description;
                    Rec."Unit Price" := ItemRec."Unit Price";
                end;
                CalculateLineAmount();
            end;
        }
        field(4; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(5; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                if Rec.Quantity <= 0 then
                    Error('Quantity must be greater than 0.');
                
                CalculateLineAmount();
            end;
        }
        field(6; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                if Rec."Unit Price" < 0 then
                    Error('Unit Price cannot be negative.');
                    
                CalculateLineAmount();
            end;
        }
        field(7; "Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Amount';
            Editable = false; // Strictly calculated
        }
    }

    keys
    {
        // Composite Primary Key
        key(PK; "Requisition No.", "Line No.")
        {
            Clustered = true;
        }
    }

    // Helper procedure to keep calculation logic in one place
    local procedure CalculateLineAmount()
    begin
        Rec."Line Amount" := Rec.Quantity * Rec."Unit Price";
    end;
}