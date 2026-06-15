page 50100 "Employee Advance Card"
{
    PageType = Card;
    SourceTable = "Employee Advance Header";
    Caption = 'Employee Advance Request';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General Information';

                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }

            part(ExpenseLines; "Employee Advance Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Request No." = field("Request No.");
                UpdatePropagation = Both; // Forces the header to refresh when lines are changed
            }

            group(Totals)
            {
                Caption = 'Totals & Remarks';

                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    MultiLine = true; // bigger text box
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(ApprovalGroup)
            {
                Caption = 'Approval Workflow';

                action(SendApproval)
                {
                    ApplicationArea = All;
                    Caption = 'Send for Approval';
                    Image = SendApprovalRequest; // button icon
                    Promoted = true; // Puts the button in the top ribbon menu
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        AdvanceLine: Record "Employee Advance Line";
                    begin
                        // Rule 1: Document must be open
                        if Rec.Status <> Rec.Status::Open then
                            Error('You can only send Open requests for approval.');

                        // Rule 2: Document must have at least one expense line
                        AdvanceLine.SetRange("Request No.", Rec."Request No.");
                        if AdvanceLine.IsEmpty() then
                            Error('You cannot send an empty request. Please add expense lines.');

                        // Execution: Change status
                        Rec.Status := Rec.Status::"Pending Approval";
                        Rec.Modify();
                        Message('The request has been sent for approval.');
                    end;
                }

                action(Approve)
                {
                    ApplicationArea = All; 
                    Caption = 'Approve Request';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // Rule 1: Must be pending approval
                        if Rec.Status <> Rec.Status::"Pending Approval" then
                            Error('Only requests Pending Approval can be approved.');

                        // Rule 2: Cannot approve a 0 amount document
                        Rec.CalcFields("Total Amount");
                        if Rec."Total Amount" <= 0 then
                            Error('Total amount must be greater than zero to approve.');

                        // Execution: Approve and copy amount
                        Rec.Status := Rec.Status::Approved;
                        Rec."Approved Amount" := Rec."Total Amount"; // Auto-fills the approved amount
                        Rec.Modify();
                        Message('Request approved successfully.');
                    end;
                }

                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject Request';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // Rule 1: Must be pending approval
                        if Rec.Status <> Rec.Status::"Pending Approval" then
                            Error('Only requests Pending Approval can be rejected.');

                        // Rule 2: Remarks are mandatory for rejection
                        if Rec.Remarks = '' then
                            Error('You must enter a reason for rejection in the Remarks field before rejecting.');

                        // Execution: Reject
                        Rec.Status := Rec.Status::Rejected;
                        Rec.Modify();
                        Message('Request has been rejected.');
                    end;
                }

                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'Post Request';
                    Image = Post; // Standard posting icon
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PostedHeader: Record "Posted Advance Header";
                    begin
                        // Rule 1: Must be Approved
                        if Rec.Status <> Rec.Status::Approved then
                            Error('You can only post an Approved request.');

                        // Rule 2: Prevent Duplicate Posting
                        if PostedHeader.Get(Rec."Request No.") then
                            Error('This request has already been posted to the history ledger.');

                        // Execution 1: Calculate the FlowField before copying
                        Rec.CalcFields("Total Amount");

                        // Execution 2: The Magic Transfer
                        PostedHeader.Init(); // Prepares a blank row in the new table
                        PostedHeader.TransferFields(Rec); // Copies everything instantly based on Field IDs
                        
                        // Overwrite specific fields where needed
                        PostedHeader."Posted Date" := Today; 
                        PostedHeader."Total Amount" := Rec."Total Amount"; // Locks in the FlowField math
                        
                        PostedHeader.Insert(); // Saves the new historical record to the database

                        // Execution 3: Update original document status
                        Rec.Status := Rec.Status::Posted;
                        Rec.Modify();
                        
                        Message('The request has been successfully posted.');
                    end;
                }
            }
        }
    }

    // Ensures the FlowField calculates the moment you open the page
    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Total Amount");
    end;
}