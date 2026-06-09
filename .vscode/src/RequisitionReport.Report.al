report 50149 "Requisition Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Purchase Requisition Report';

    // RDLC layout – previewable directly from BC dashboard
    DefaultLayout = RDLC;
    RDLCLayout = './RequisitionReport.rdl';

    dataset
    {
        // ─────────────────────────────────────────────
        // 1. MASTER RECORD – Requisition Header
        // ─────────────────────────────────────────────
        dataitem(ReqHeader; "Custom Requisition Header")
        {
            // Task 3.3 – Request Page auto-filter fields
            RequestFilterFields = "Request Date", "Department Code", Status;

            // ── Header Columns ──
            column(No_ReqHeader; "No.") { }
            column(Description_ReqHeader; Description) { }
            column(DepartmentCode_ReqHeader; "Department Code") { }
            column(RequestedBy_ReqHeader; "Requested By") { }
            column(RequestDate_ReqHeader; "Request Date") { }
            column(Status_ReqHeader; Status) { }
            column(TotalAmount_ReqHeader; "Total Amount") { }

            // ── Calculated & Global Columns ──
            column(FormattedDate; FormattedDate) { }
            column(CompanyName; CompanyName) { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(TodayDate; TodayDate) { }

            // ─────────────────────────────────────────
            // 2. DETAIL RECORD – Requisition Line
            // ─────────────────────────────────────────
            dataitem(ReqLine; "Custom Requisition Line")
            {
                // Link lines to the current header
                DataItemLink = "Requisition No." = field("No.");
                // Sort by Line No. ascending
                DataItemTableView = sorting("Line No.") order(ascending);

                // ── Line Columns ──
                column(LineNo_ReqLine; "Line No.") { }
                column(ItemNo_ReqLine; "Item No.") { }
                column(Description_ReqLine; Description) { }
                column(Quantity_ReqLine; Quantity) { }
                column(UnitPrice_ReqLine; "Unit Price") { }
                column(LineAmount_ReqLine; "Line Amount") { }

                // ── Calculated Line Column ──
                column(LineAmountText; LineAmountText) { }

                trigger OnAfterGetRecord()
                begin
                    // Format the line amount with currency symbol
                    LineAmountText := StrSubstNo('$%1', Format(ReqLine."Line Amount", 0, '<Precision,2:2><Standard Format,0>'));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // Format Date as DD-MMM-YYYY (e.g., 04-Jun-2026)
                FormattedDate := Format(ReqHeader."Request Date", 0, '<Day,2>-<Month Text,3>-<Year4>');
            end;
        }
    }

    // ─────────────────────────────────────────────
    // Request Page – Task 3.3
    // Adds filter controls for Date Range, Department, Status
    // ─────────────────────────────────────────────
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(FilterOptions)
                {
                    Caption = 'Filter Options';

                    field(StartDate; StartDateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Request Date From';
                        ToolTip = 'Enter the start date for filtering requisitions.';
                    }
                    field(EndDate; EndDateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Request Date To';
                        ToolTip = 'Enter the end date for filtering requisitions.';
                    }
                    field(DeptFilter; DeptCodeFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Department Code';
                        ToolTip = 'Filter by department code.';
                    }
                    field(StatusFilter; StatusFilterValue)
                    {
                        ApplicationArea = All;
                        Caption = 'Status';
                        ToolTip = 'Filter by requisition status.';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            StartDateFilter := 0D;
            EndDateFilter := 0D;
            DeptCodeFilter := '';
        end;
    }

    // ── Global Variables ──
    var
        CompanyInfo: Record "Company Information";
        FormattedDate: Text;
        LineAmountText: Text;
        CompanyName: Text;
        TodayDate: Text;
        StartDateFilter: Date;
        EndDateFilter: Date;
        DeptCodeFilter: Code[20];
        StatusFilterValue: Enum "Requisition Status";

    // ── OnPreReport – fires once before data is read ──
    trigger OnPreReport()
    begin
        // Load company info for logo and name
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        CompanyName := CompanyInfo.Name;

        // Format today's date for the report header
        TodayDate := Format(Today, 0, '<Day,2>-<Month Text,3>-<Year4>');

        // Apply custom date range filters from request page
        if (StartDateFilter <> 0D) and (EndDateFilter <> 0D) then
            ReqHeader.SetFilter("Request Date", '%1..%2', StartDateFilter, EndDateFilter)
        else begin
            if StartDateFilter <> 0D then
                ReqHeader.SetFilter("Request Date", '>=%1', StartDateFilter);
            if EndDateFilter <> 0D then
                ReqHeader.SetFilter("Request Date", '<=%1', EndDateFilter);
        end;

        // Apply department filter
        if DeptCodeFilter <> '' then
            ReqHeader.SetRange("Department Code", DeptCodeFilter);
    end;
}
