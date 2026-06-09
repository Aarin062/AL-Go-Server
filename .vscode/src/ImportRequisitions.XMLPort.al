xmlport 50102 "Import Requisitions"
{
    Format = VariableText;
    Direction = Import;
    TextEncoding = UTF8;
    UseRequestPage = false;
    FieldSeparator = ',';

    schema
    {
        textelement(Root)
        {
            // We map to the Line table, but intercept the data before it saves
            tableelement(ReqLine; "Custom Requisition Line")
            {
                AutoSave = false;

                // CSV Columns imported as raw Text
                textelement(ReqNoTxt) { }
                textelement(ReqDescTxt) { }
                textelement(DeptCodeTxt) { }
                textelement(ReqByTxt) { }
                textelement(ReqDateTxt) { }
                textelement(LineNoTxt) { }
                textelement(ItemNoTxt) { }
                textelement(QtyTxt) { }

                // This trigger fires every time the XMLPort reads a single line of the CSV
                trigger OnBeforeInsertRecord()
                var
                    ReqHeader: Record "Custom Requisition Header";
                    ActualLineNo: Integer;
                    ActualQty: Decimal;
                    ActualDate: Date;
                begin
                    // 1. Convert text from CSV into proper data types
                    Evaluate(ActualLineNo, LineNoTxt);
                    Evaluate(ActualQty, QtyTxt);
                    Evaluate(ActualDate, ReqDateTxt);

                    // 2. HEADER LOGIC: Check if this Requisition No. already exists. 
                    // If it doesn't, create it!
                    if not ReqHeader.Get(ReqNoTxt) then begin
                        ReqHeader.Init();

                        // IMPORTANT: leave "No." blank so Custom Requisition Header.OnInsert()
                        // can generate it via No. Series.
                        // (Do NOT assign ReqHeader."No." here.)

                        ReqHeader.Description := ReqDescTxt;
                        ReqHeader."Department Code" := DeptCodeTxt;
                        ReqHeader."Requested By" := ReqByTxt;
                        ReqHeader."Request Date" := ActualDate;

                        ReqHeader.Insert(true);

                        // After insertion, capture the generated "No." for the line records.
                        ReqNoTxt := ReqHeader."No.";
                    end;

                    // 3. LINE LOGIC: Insert the line item
                    ReqLine.Init();
                    ReqLine."Requisition No." := ReqNoTxt;
                    ReqLine."Line No." := ActualLineNo;

                    // 🔹 MAGIC: We use VALIDATE instead of :=
                    // This forces the database to look up the Item's price and calculate the Line Amount!
                    ReqLine.Validate("Item No.", ItemNoTxt);
                    ReqLine.Validate(Quantity, ActualQty);

                    ReqLine.Insert(true);
                end;
            }
        }
    }
}