codeunit 50100 "Requisition Workflow Mgt."
{
    // 1. Define a global procedure that can be called from other objects
    procedure ApproveRequisition(var ReqHeader: Record "Custom Requisition Header")
    begin
        // Step A: Data Validation
        ReqHeader.CalcFields("Total Amount");
        if ReqHeader."Total Amount" <= 0 then
            Error('Cannot approve a requisition with a zero total. Please add lines.');

        // Step B: State Change
        if ReqHeader.Status = ReqHeader.Status::Approved then
            exit; // Silently exit if it is already approved

        ReqHeader.Status := ReqHeader.Status::Approved;
        
        // Step C: Database Commit
        ReqHeader.Modify(true);
        
        // Step D: User Feedback
        Message('Requisition %1 has been successfully approved.', ReqHeader."No.");
    end;
}