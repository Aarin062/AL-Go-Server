page 50109 "Maintenance Log List"
{
    PageType = List;
    SourceTable = "Maintenance Log";
    CardPageId = "Maintenance Log Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Maintenance Logs';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Log No."; Rec."Log No.") { ApplicationArea = All; }
                field("Vehicle No."; Rec."Vehicle No.") { ApplicationArea = All; }
                field("Maintenance Date"; Rec."Maintenance Date") { ApplicationArea = All; }
                field("Maintenance Type"; Rec."Maintenance Type") { ApplicationArea = All; }
                field(Vendor; Rec.Vendor) { ApplicationArea = All; }
                field(Cost; Rec.Cost) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportMaintenance)
            {
                ApplicationArea = All;
                Caption = 'Import Maintenance Logs (CSV)';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = xmlport "Import Maintenance";
            }
        }
    }
}