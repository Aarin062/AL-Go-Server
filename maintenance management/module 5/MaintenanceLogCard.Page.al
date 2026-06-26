page 50108 "Maintenance Log Card"
{
    PageType = Card;
    SourceTable = "Maintenance Log";
    Caption = 'Maintenance Detail';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General Information';
                field("Log No."; Rec."Log No.") { ApplicationArea = All; }
                field("Vehicle No."; Rec."Vehicle No.") { ApplicationArea = All; }
                field("Maintenance Date"; Rec."Maintenance Date") { ApplicationArea = All; }
                field("Maintenance Type"; Rec."Maintenance Type") { ApplicationArea = All; }
            }
            group(ServiceDetails)
            {
                Caption = 'Service Details';
                field(Vendor; Rec.Vendor) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; MultiLine = true; }
                field(Cost; Rec.Cost) { ApplicationArea = All; Style = Strong; }
                field("Next Service Kilometer"; Rec."Next Service Kilometer") { ApplicationArea = All; }
            }
        }
    }
}