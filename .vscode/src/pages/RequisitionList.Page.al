page 50100 "Requisition List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Custom Requisition Header";
    CardPageId = "Requisition Card";
    Caption = 'Requisitions';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Department Code"; Rec."Department Code") { ApplicationArea = All; }
                field("Requested By"; Rec."Requested By") { ApplicationArea = All; }
                field("Request Date"; Rec."Request Date") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Style = Strong; // Highlights in bold
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportCSV)
            {
                ApplicationArea = All;
                Caption = 'Import Requisitions (CSV)';
                Image = ImportDatabase;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Upload a CSV file to bulk import requisitions and lines.';

                trigger OnAction()
                begin
                    // Run the XMLPort: (XmlPortID, ShowRequestPage, IsImport)
                    Xmlport.Run(Xmlport::"Import Requisitions", false, true);

                    // Refresh the UI so the new records appear instantly
                    CurrPage.Update(false);
                end;
            }
        }

        area(Reporting)
        {
            action(PrintSelected)
            {
                ApplicationArea = All;
                Caption = 'Print Selected';
                Image = PrintForm;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    ReqHeader: Record "Custom Requisition Header";
                begin
                    // 1. Grab all the rows the user has highlighted with their mouse
                    CurrPage.SetSelectionFilter(ReqHeader);

                    // 2. Pass that filtered batch to the report
                    if ReqHeader.FindSet() then
                        Report.Run(Report::"Requisition Report", true, false, ReqHeader)
                    else
                        Message('Please select at least one requisition to print.');
                end;
            }
        }
    }
}