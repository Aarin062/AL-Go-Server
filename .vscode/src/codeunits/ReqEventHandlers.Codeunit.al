codeunit 50101 "Req. Event Handlers"
{
    // This attribute tells the compiler: "Listen for the exact moment BEFORE a Requisition is deleted."
    [EventSubscriber(ObjectType::Table, Database::"Custom Requisition Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure PreventDeletionOfApprovedReqs(var Rec: Record "Custom Requisition Header"; RunTrigger: Boolean)
    begin
        // 1. Safety check to ensure the deletion is actually executing
        if not RunTrigger then
            exit;

        // 2. The Business Logic
        if Rec.Status = Rec.Status::Approved then
            Error('Security Violation: You cannot delete Requisition %1 because it has already been approved for purchasing.', Rec."No.");
    end;
}