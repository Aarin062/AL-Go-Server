table 50100 "Custom Requisition Header"
{
    DataClassification = CustomerContent;
    Caption = 'Requisition Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; "Department Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Department Code';
        }
        field(4; "Requested By"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Requested By';
        }
        field(5; "Request Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Request Date';
        }
        field(6; Status; Enum "Requisition Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            InitValue = Draft; // Defaults to Draft automatically
        }
        field(7; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
            // Automatically sums the Line Amount from child records
            CalcFormula = sum("Custom Requisition Line"."Line Amount" where("Requisition No." = field("No.")));
        }
        field(8; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
            TableRelation = "No. Series";
            Editable = false;
        }
    }


    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ReqSetup: Record "Custom Requisition Setup"; // Points to our new setup table
    begin
        // 1. Only run if the user didn't manually type a number
        if "No." = '' then begin

            // 2. Safely read the single setup row from the database
            if ReqSetup.Get() then begin

                // 3. Crash gracefully with a helpful message if the admin forgot to configure the field
                ReqSetup.TestField("Requisition Nos.");

                // 4. Pass the dynamic setup data straight to the generation engine
                NoSeriesMgt.InitSeries(ReqSetup."Requisition Nos.", '', 0D, "No.", "No. Series");
            end else begin
                // Fallback error if the setup record hasn't been initialized at all yet
                Error('Requisition Setup records are completely missing. Please initialize the Custom Requisition Setup page first.');
            end;

        end;
    end;
}