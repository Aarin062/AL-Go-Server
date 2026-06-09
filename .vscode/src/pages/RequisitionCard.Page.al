page 50102 "Requisition Card"
{
    PageType = Card;
    SourceTable = "Custom Requisition Header";
    Caption = 'Requisition Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = IsCardEditable; // Dynamic lock

                field("No."; Rec."No.") { ApplicationArea = All;
                toolTip = 'Unique identifier for the requisition. Auto-generated.'; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Department Code"; Rec."Department Code") { ApplicationArea = All; }
                field("Requested By"; Rec."Requested By") { ApplicationArea = All; }
                field("Request Date"; Rec."Request Date") { ApplicationArea = All; }
                field(Status; Rec.Status) 
                { 
                    ApplicationArea = All;
                    editable = false;
                }
            }

            part(RequisitionLines; "Requisition Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Requisition No." = field("No.");
                UpdatePropagation = Both; // Refreshes Total Amount automatically
                Editable = IsCardEditable;
            }

            group(Totals)
            {
                Caption = 'Totals';
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action(PrintRequisition)
            {
                ApplicationArea = All;
                Caption = 'Print Requisition';
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Print or preview the current requisition report.';

                trigger OnAction()
                var
                    ReqHeader: Record "Custom Requisition Header";
                begin
                    // Filter to only the current requisition
                    ReqHeader.SetRange("No.", Rec."No.");
                    // Open the report in preview mode (true = show request page, false = don't print directly)
                    Report.Run(Report::"Requisition Report", true, false, ReqHeader);
                end;
            }
        }
    }

    var
        IsCardEditable: Boolean;

    trigger OnOpenPage()
    begin
        if Rec.Get() then begin
            SetEditableState();
        end else begin
            Rec.Init();
            Rec.Insert(true); 
            SetEditableState();
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        SetEditableState();
    end;

    local procedure SetEditableState()
    begin
        // If Status is Approved, lock the fields and subform. Otherwise, unlock.
        IsCardEditable := (Rec.Status <> Rec.Status::Approved);
    end;
}