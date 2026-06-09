table 50105 "Custom Requisition Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Custom Requisition Setup';

    fields
    {
        // 🔹 Every setup table in BC needs a Primary Key field of type Code[10]
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }

        // 🔹 This field links directly to BC's native No. Series directory table
        field(2; "Requisition Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Requisition Nos.';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}