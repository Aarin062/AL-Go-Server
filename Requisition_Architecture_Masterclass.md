# Microsoft Dynamics 365 Business Central Technical Masterclass & Workspace Audit

Welcome to this technical masterclass and codebase audit of your Business Central extension project (**ALProject6**, runtime version **6.6**, targeting **Business Central v17**). 

This guide systematically dissects every configuration, enum, table, page, XMLPort, and report file in your workspace folder. It explains their technical mechanics, compilation behaviors, ERP patterns, and runtime execution paths.

---

## Workspace Directory Map
* **Configurations**:
  * [app.json](file:///c:/Users/Aarin%20Bhatta/Documents/AL/ALProject7/app.json) — Extension Manifest
  * [launch.json](file:///c:/Users/Aarin%20Bhatta/Documents/AL/ALProject7/.vscode/launch.json) — Debugger & Deployment Profile
* **Database Schema (Data Dictionary)**:
  * [RequisitionStatus.Enum.al](file:///c:/Users/Aarin%20Bhatta/Documents/AL/ALProject7/.vscode/src/enum/RequisitionStatus.Enum.al) — Status Enum (ID 50100)
  * [RequisitionHeader.Table.al](file:///c:/Users/Aarin%20Bhatta/Documents/AL/ALProject7/.vscode/src/tables/RequisitionHeader.Table.al) — Header Table (ID 50100)
  * [RequisitionLine.Table.al](file:///c:/Users/Aarin%20Bhatta/Documents/AL/ALProject7/.vscode/src/tables/RequisitionLine.Table.al) — Line Table (ID 50101)
* **User Interface (UI Layer)**:
  * [RequisitionList.Page.al](file:///c:/Users/Aarin%20Bhatta/Documents/AL/ALProject7/.vscode/src/pages/RequisitionList.Page.al) — List Page (ID 50100)
  * [RequisitionCard.Page.al](file:///c:/Users/Aarin%20Bhatta/Documents/AL/ALProject7/.vscode/src/pages/RequisitionCard.Page.al) — Document Card (ID 50102)
  * [RequisitionSubform.Page.al](file:///c:/Users/Aarin%20Bhatta/Documents/AL/ALProject7/.vscode/src/subforms/RequisitionSubform.Page.al) — Embedded Sub-Grid (ID 50101)
* **Data Integration (ETL Layer)**:
  * [ImportRequisitions.XMLPort.al](file:///c:/Users/Aarin%20Bhatta/Documents/AL/ALProject7/.vscode/src/ImportRequisitions.XMLPort.al) — CSV Bulk Importer (ID 50102)
* **Reporting & Document Layout**:
  * [RequisitionReport.Report.al](file:///c:/Users/Aarin%20Bhatta/Documents/AL/ALProject7/.vscode/src/RequisitionReport.Report.al) — Dataset Controller (ID 50149)
  * [RequisitionReport.rdl](file:///c:/Users/Aarin%20Bhatta/Documents/AL/ALProject7/RequisitionReport.rdl) — RDL Visual Layout Template

---

## 1. Global Configurations & Environment Profiles

### File: `app.json`
This is the manifest file of the Business Central extension. It coordinates compiler properties, dependencies, and license compliance rules.

```json
{
  "id": "f8b6359f-c01d-4caa-9e4e-0057e59776ff",
  "name": "ALProject6",
  "publisher": "Default Publisher",
  "version": "1.0.0.0",
  "platform": "1.0.0.0",
  "application": "17.0.0.0",
  "idRanges": [
    {
      "from": 50100,
      "to": 50149
    }
  ],
  "showMyCode": true,
  "runtime": "6.6",
  "features": [
    "NoImplicitWith"
  ]
}
```

#### The Context & Business Purpose
In Dynamics 365 Business Central, extensions are packaged as `.app` files. The `app.json` defines identity metadata, dependencies, licensing constraints, and compile-time instructions for the AL compiler.

#### System Architecture & Blueprint properties
* **`id`**: A unique GUID identifying this extension. It registers this application in the database's `NAV App` table.
* **`name` & `publisher` & `version`**: String metadata used by the Extension Management page in BC.
* **`dependencies`**: List of other extensions this app relies on. Currently empty, meaning it only relies on system-level applications declared implicitly or via target settings.
* **`platform` & `application`**: Defines compatibility boundaries. Setting `"application": "17.0.0.0"` targets Microsoft Dynamics 365 Business Central 2020 Release Wave 2 (BC v17). The app engine will block installation on older environments.
* **`idRanges`**: Controls the object ID range allocated to this app (IDs 50100–50149). This prevents object ID collision with other third-party extensions. The AL compiler throws a compilation error if an object ID falls outside this range.
* **`showMyCode`**: Set to `true`. This tells the server to include the raw AL source code in the compiled `.app` package, allowing downstream developers to debug into your code or extract the source.
* **`runtime`**: Set to `"6.6"`. This corresponds to BC v17 syntax levels, instructing the compiler to generate metadata compatible with the NST (NAV Service Tier) v17.
* **`features` -> `NoImplicitWith`**: Turns off the legacy implicit `with Rec do` and `with X do` scopes. Without this flag, the compiler automatically assumes fields are properties of `Rec`. Enabling `NoImplicitWith` prevents naming conflicts if Microsoft adds a field to a base table that shares a name with your local variables.

---

### File: `.vscode/launch.json`
Configures the debug engine and deployment server connection.

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Your own server",
            "request": "launch",
            "type": "al",
            "environmentType": "OnPrem",
            "server": "http://localhost:8080/BC170",
            "serverInstance": "BC170",
            "authentication": "Windows",
            "startupObjectId": 22,
            "startupObjectType": "Page",
            "launchBrowser": true,
            "enableLongRunningSqlStatements": true,
            "enableSqlInformationDebugger": true,
            "tenant": "default",
            "port": 17049,
            "schemaUpdateMode": "ForceSync",
            "usePublicURLFromServer": true
        }
    ]
}
```

#### The Context & Business Purpose
Tells the VS Code AL language debugger extension where to deploy, how to authenticate, and which synchronization mode to use when pushing custom table schemas to the SQL Server.

#### System Architecture & Blueprint properties
* **`environmentType`**: `"OnPrem"` specifies deployment to a locally managed or privately hosted server rather than SaaS.
* **`authentication`**: `"Windows"` runs Single-Sign-On (SSO) passing your Windows Domain credentials to active directory groups configured on the IIS and NST.
* **`startupObjectId`**: `22` (Startup Type: `Page`) tells the client to open Page 22 ("Customer List") in the browser immediately upon deploying.
* **`schemaUpdateMode`**: `"ForceSync"`. During compilation and publishing, this tells the database to execute a destructive schema update. If a field's data type changed, it drops and recreates SQL tables/columns instantly.
  > [!WARNING]
  > Never use `ForceSync` in a production environment, as it results in irreversible data loss. Use `Synchronize` instead.
* **`enableLongRunningSqlStatements` & `enableSqlInformationDebugger`**: Instructs the debugger to track SQL execution plans and issue warnings in the debug console for slow queries.

---

## 2. Database Schema (The Data Dictionary)

### File: `RequisitionStatus.Enum.al`
Defines the state engine for our document lifecycle.

```al
enum 50100 "Requisition Status"
{
    Extensible = true;
    
    value(0; Draft) { Caption = 'Draft'; }
    value(1; "Pending Approval") { Caption = 'Pending Approval'; }
    value(2; Approved) { Caption = 'Approved'; }
    value(3; Rejected) { Caption = 'Rejected'; }
}
```

#### The Context & Business Purpose
Requisitions represent internal requests for inventory purchase. They must transition through a defined approval workflow before purchase orders can be created. This enum enforces a type-safe workflow state engine.

#### System Architecture & Blueprint properties
* **`Extensible = true;`**: Instructs the compiler that downstream developers can create `enumextension` objects. This allows other apps to add values like `Archived` or `Pending Clarification` without modifying the original code.

---

### File: `RequisitionHeader.Table.al`
Creates the main document table for the Requisition Header.

```al
table 50100 "Custom Requisition Header"
{
    DataClassification = CustomerContent;
    Caption = 'Requisition Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(3; "Department Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Department Code';
        }
        field(4; "Requested By"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Requested By';
        }
        field(5; "Request Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Request Date';
        }
        field(6; Status; Enum "Requisition Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            InitValue = Draft; 
        }
        field(7; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Custom Requisition Line"."Line Amount" where("Requisition No." = field("No.")));
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
```

#### The Context & Business Purpose
The Header table stores document-wide metadata. It maintains transactional integrity by establishing a single point of authority for document identification, department cost allocation, auditing, and total financial value.

#### System Architecture & Blueprint properties
* **`DataClassification = CustomerContent;`**: Tells the compiler and reporting system that this table contains customer-owned, non-system transaction data.
* **`Code[20]` (on `"No."`)**: This data type forces values to be uppercase, alphanumeric strings. Business Central defaults document numbers to 20 characters to align with standard number series dimensions.
* **`FieldClass = FlowField;`**: This tells the compiler that the field is **virtual** and is not stored physically in the database. Instead, the runtime evaluates its value on-demand by executing the specified `CalcFormula` (an aggregated SQL query over the child table).
* **`CalcFormula`**: `sum("Custom Requisition Line"."Line Amount" where("Requisition No." = field("No.")))` tells the query generator to run a `SUM` on the child line table, filtering where the foreign key `Requisition No.` matches this header's primary key (`"No."`).
* **`key(PK; "No.") { Clustered = true; }`**: Declares the primary key constraint. `Clustered = true` instructs SQL Server to physically arrange the table rows on disk sorted by `"No."`, optimizing index seeks for document retrieval.

---

### File: `RequisitionLine.Table.al`
Creates the detail line item table.

```al
table 50101 "Custom Requisition Line"
{
    DataClassification = CustomerContent;
    Caption = 'Requisition Line';

    fields
    {
        field(1; "Requisition No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Requisition No.';
            TableRelation = "Custom Requisition Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.';
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                ItemRec: Record Item;
            begin
                if ItemRec.Get(Rec."Item No.") then begin
                    Rec.Description := ItemRec.Description;
                    Rec."Unit Price" := ItemRec."Unit Price";
                end;
                CalculateLineAmount();
            end;
        }
        field(4; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(5; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                if Rec.Quantity <= 0 then
                    Error('Quantity must be greater than 0.');
                
                CalculateLineAmount();
            end;
        }
        field(6; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                if Rec."Unit Price" < 0 then
                    Error('Unit Price cannot be negative.');
                    
                CalculateLineAmount();
            end;
        }
        field(7; "Line Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Amount';
            Editable = false; 
        }
    }

    keys
    {
        key(PK; "Requisition No.", "Line No.")
        {
            Clustered = true;
        }
    }

    local procedure CalculateLineAmount()
    begin
        Rec."Line Amount" := Rec.Quantity * Rec."Unit Price";
    end;
}
```

#### The Context & Business Purpose
The child table in the Master-Detail pattern. It holds individual line items (quantities, item numbers, unit prices, descriptions) that belong to a single requisition.

#### System Architecture & Blueprint properties
* **`TableRelation = "Custom Requisition Header"."No."`**: Configures a foreign key relationship at the metadata level, enforcing referential integrity.
* **`TableRelation = Item."No."`**: Connects this field to Business Central's core inventory Master table. In UI layouts, this automatically generates lookup controls for selecting items.
* **`key(PK; "Requisition No.", "Line No.")`**: A composite primary key. The first field connects the line to the header, while the second field (an integer) distinguishes each line item.

#### AL Logic & Code Breakdown

##### Field Trigger: `Item No. - OnValidate()`
Fires when the user updates the item number.
1. Declares a local instance of the standard `Item` table: `ItemRec: Record Item;`.
2. Evaluates `ItemRec.Get(Rec."Item No.")`. The `Get()` method performs a primary key lookup in the database cache. If the item exists, it populates `ItemRec` with the item data and returns `true`.
3. If `Get` is successful, the code copies the item's standard data fields to this record:
   * `Rec.Description := ItemRec.Description;`
   * `Rec."Unit Price" := ItemRec."Unit Price";`
4. Calls the local procedure `CalculateLineAmount();`.

##### Field Trigger: `Quantity - OnValidate()`
Fires when the quantity changes.
1. Checks if the quantity is less than or equal to 0: `if Rec.Quantity <= 0 then Error(...)`.
2. The `Error()` method interrupts execution, rolls back any active SQL database transactions, and displays the error message in the UI.
3. If valid, it invokes `CalculateLineAmount();`.

##### Field Trigger: `Unit Price - OnValidate()`
Fires when the price changes.
1. Enforces validation to prevent negative pricing: `if Rec."Unit Price" < 0 then Error(...)`.
2. If valid, it invokes `CalculateLineAmount();`.

##### Local Procedure: `CalculateLineAmount()`
An internal helper routine designed to centralize calculations:
```al
Rec."Line Amount" := Rec.Quantity * Rec."Unit Price";
```
This procedure uses direct assignment (`:=`) because this is a simple mathematical calculation. We do not use `Validate("Line Amount")` here because `"Line Amount"` is configured as `Editable = false` and has no validation logic of its own. Using `Validate` on a read-only field with no triggers would add unnecessary performance overhead.

---

## 3. User Interface & Page Objects

### File: `RequisitionList.Page.al`
Creates a tabular dashboard view of all Requisitions.

```al
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
                    Style = Strong; 
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
                    Xmlport.Run(Xmlport::"Import Requisitions", false, true);
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
                    CurrPage.SetSelectionFilter(ReqHeader);
                    if ReqHeader.FindSet() then
                        Report.Run(Report::"Requisition Report", true, false, ReqHeader)
                    else
                        Message('Please select at least one requisition to print.');
                end;
            }
        }
    }
}
```

#### The Context & Business Purpose
The primary worklist where users search, filter, and review purchase requisitions. It acts as the navigation hub for requisition management.

#### System Architecture & Blueprint properties
* **`PageType = List;`**: Renders the UI as a grid/tabular layout.
* **`UsageCategory = Lists;`**: Enables search discovery in the Tell Me search box.
* **`CardPageId = "Requisition Card";`**: Connects this list to the card page. Double-clicking a grid row or choosing the "Edit" action automatically opens the card page loaded with the selected record.
* **`Editable = false;`**: Prevents users from modifying fields directly in the list view, forcing them to edit records inside the card page.
* **`Style = Strong;`**: Instructs the rendering engine to display the `"Total Amount"` field in **bold**.

#### AL Logic & Code Breakdown

##### Action: `ImportCSV - OnAction()`
1. Invokes the importer: `Xmlport.Run(Xmlport::"Import Requisitions", false, true)`. 
   * **`false`**: Hides the default XMLPort request page.
   * **`true`**: Instructs the runtime to execute the XMLPort in **Import** mode.
2. Calls `CurrPage.Update(false)`. This refreshes the page dataset from the database to display the newly imported records. Passing `false` tells the page to refresh without saving changes to the active record first.

##### Action: `PrintSelected - OnAction()`
1. Declares a local instance of the header table: `ReqHeader: Record "Custom Requisition Header"`.
2. Calls `CurrPage.SetSelectionFilter(ReqHeader)`. This copies the selection state of the UI grid, applying filters to the `ReqHeader` record variable so it contains only the rows the user selected.
3. Evaluates `if ReqHeader.FindSet() then`. 
   * The `FindSet()` method executes a SQL query to retrieve the selected records. It optimizes performance by instructing SQL Server to open a fast forward-only cursor, which is ideal for loops.
   * If records are found, it runs the report: `Report.Run(Report::"Requisition Report", true, false, ReqHeader)`. This opens the report preview, passing the filtered `ReqHeader` record variable as the active dataset.
   * If no records are selected, it displays a popup message using `Message()`.

---

### File: `RequisitionCard.Page.al`
Creates the detailed document editor page.

```al
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
                Editable = IsCardEditable; 

                field("No."; Rec."No.") { ApplicationArea = All; }
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
                UpdatePropagation = Both; 
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
                    ReqHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Requisition Report", true, false, ReqHeader);
                end;
            }
        }
    }

    var
        IsCardEditable: Boolean;

    trigger OnOpenPage()
    begin
        SetEditableState();
    end;

    trigger OnAfterGetRecord()
    begin
        SetEditableState();
    end;

    local procedure SetEditableState()
    begin
        IsCardEditable := (Rec.Status <> Rec.Status::Approved);
    end;
}
```

#### The Context & Business Purpose
The primary work area for creating and editing purchase requisitions. It provides a structured view of the requisition header and lines, automatically locks approved documents to prevent changes, and displays the requisition's total value.

#### System Architecture & Blueprint properties
* **`PageType = Card;`**: Renders the page as a structured form optimized for editing a single record at a time.
* **`part(RequisitionLines; "Requisition Subform")`**: Embeds the Requisition Subform (Page 50101) directly inside the card page.
* **`SubPageLink = "Requisition No." = field("No.");`**: Links the subform's line items to the header record. When a line is added inside the subform grid, the runtime automatically populates its `"Requisition No."` foreign key with the header's `"No."` primary key.
* **`UpdatePropagation = Both;`**: Configures bidirectional UI updates. When a user updates lines in the subform, the subform notifies the parent page. This forces the parent card page to update and recalculate its `Total Amount` FlowField in the UI.

#### AL Logic & Code Breakdown

##### Trigger: `OnOpenPage()`
Runs when the page is first initialized. It calls `SetEditableState();` to determine whether the document should be editable or read-only.

##### Trigger: `OnAfterGetRecord()`
Fires when the page retrieves a record from the database (e.g., when the user opens a document or navigates between records). It calls `SetEditableState();` to update the page's editable state for the current record.

##### Action: `PrintRequisition - OnAction()`
1. Declares a local `ReqHeader` record variable.
2. Calls `ReqHeader.SetRange("No.", Rec."No.")` to filter the table to only the active requisition.
3. Invokes `Report.Run(Report::"Requisition Report", true, false, ReqHeader)`. This runs the report, opening its request page (`true`) but without printing directly (`false`), passing the filtered header record.

##### Local Procedure: `SetEditableState()`
Updates the `IsCardEditable` Boolean variable:
```al
IsCardEditable := (Rec.Status <> Rec.Status::Approved);
```
If the requisition status is `Approved`, `IsCardEditable` is set to `false`. This disables edits on both the general header fields and the subform grid, preventing changes to approved documents.

---

### File: `RequisitionSubform.Page.al`
Creates the subform page for editing requisition lines.

```al
page 50101 "Requisition Subform"
{
    PageType = ListPart;
    SourceTable = "Custom Requisition Line";
    Caption = 'Lines';
    AutoSplitKey = true; 

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Item No."; Rec."Item No.") { ApplicationArea = All; }
                field(Description; Rec.Description) 
                { 
                    ApplicationArea = All; 
                    Editable = false; 
                }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Unit Price"; Rec."Unit Price") { ApplicationArea = All; }
                field("Line Amount"; Rec."Line Amount") { ApplicationArea = All; }
            }
        }
    }
}
```

#### The Context & Business Purpose
Displays the lines sub-grid within the requisition card page, allowing users to enter and edit line items.

#### System Architecture & Blueprint properties
* **`PageType = ListPart;`**: Identifies this page as an embedded sub-grid. It cannot be launched as a standalone page.
* **`AutoSplitKey = true;`**: Automates primary key generation for lines. When the composite key ends with an integer field (`"Line No."` in this case), `AutoSplitKey` automatically calculates values for new lines in increments of 10,000 (e.g., 10000, 20000, 30000). If a user inserts a line between existing lines 10000 and 20000, the system automatically assigns 15000, avoiding key collisions and maintaining line order.
* **`Editable = false` (on `Description` & `Line Amount`)**: Marks these fields as read-only in the UI, as they are calculated by validation triggers on other fields.

---

## 4. Data Integration (ETL Layer)

### File: `ImportRequisitions.XMLPort.al`
Imports requisition records from a flat CSV file.

```al
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
            tableelement(ReqLine; "Custom Requisition Line")
            {
                AutoSave = false; 

                textelement(ReqNoTxt) { }
                textelement(ReqDescTxt) { }
                textelement(DeptCodeTxt) { }
                textelement(ReqByTxt) { }
                textelement(ReqDateTxt) { }
                textelement(LineNoTxt) { }
                textelement(ItemNoTxt) { }
                textelement(QtyTxt) { }

                trigger OnBeforeInsertRecord()
                var
                    ReqHeader: Record "Custom Requisition Header";
                    ActualLineNo: Integer;
                    ActualQty: Decimal;
                    ActualDate: Date;
                begin
                    Evaluate(ActualLineNo, LineNoTxt);
                    Evaluate(ActualQty, QtyTxt);
                    Evaluate(ActualDate, ReqDateTxt);

                    if not ReqHeader.Get(ReqNoTxt) then begin
                        ReqHeader.Init();
                        ReqHeader."No." := ReqNoTxt;
                        ReqHeader.Description := ReqDescTxt;
                        ReqHeader."Department Code" := DeptCodeTxt;
                        ReqHeader."Requested By" := ReqByTxt;
                        ReqHeader."Request Date" := ActualDate;
                        ReqHeader.Insert(true);
                    end;

                    ReqLine.Init();
                    ReqLine."Requisition No." := ReqNoTxt;
                    ReqLine."Line No." := ActualLineNo;
                    
                    ReqLine.Validate("Item No.", ItemNoTxt); 
                    ReqLine.Validate(Quantity, ActualQty); 
                    
                    ReqLine.Insert(true);
                end;
            }
        }
    }
}
```

#### The Context & Business Purpose
Provides a data integration interface to import purchase requisitions and lines from third-party systems or external tools (like Excel) using flat CSV files.

#### System Architecture & Blueprint properties
* **`Format = VariableText;`**: Configures the XMLPort to read delimited text files (like CSVs) rather than structured XML.
* **`FieldSeparator = ',';`**: Sets the character used to split columns.
* **`AutoSave = false;`**: Overrides automatic database writes. By default, an XMLPort inserts records automatically as soon as columns are parsed. Setting this to `false` lets us intercept the import process and run custom logic before saving records.

#### AL Logic & Code Breakdown

##### Trigger: `ReqLine - OnBeforeInsertRecord()`
Fires after parsing a line from the CSV file, but before it is committed to the database.

1. **Convert Text to Native Types**:
   ```al
   Evaluate(ActualLineNo, LineNoTxt);
   Evaluate(ActualQty, QtyTxt);
   Evaluate(ActualDate, ReqDateTxt);
   ```
   The `Evaluate()` method parses text values from the CSV columns into native data types (`Integer`, `Decimal`, and `Date`). If parsing fails, it throws a runtime exception and rolls back the transaction.

2. **Ensure Header Record Exists**:
   ```al
   if not ReqHeader.Get(ReqNoTxt) then begin
       ReqHeader.Init();
       ReqHeader."No." := ReqNoTxt;
       ReqHeader.Description := ReqDescTxt;
       ...
       ReqHeader.Insert(true);
   end;
   ```
   The code checks if a header record already exists for the requisition number. If it does not, it initializes and inserts a new header record. Passing `true` to `Insert(true)` ensures that any custom table-level validation and initialization triggers run.

3. **Initialize and Populate Line Record**:
   ```al
   ReqLine.Init();
   ReqLine."Requisition No." := ReqNoTxt;
   ReqLine."Line No." := ActualLineNo;
   ```
   Initializes the line buffer and populates the composite primary key.

4. **Validate Import Fields**:
   ```al
   ReqLine.Validate("Item No.", ItemNoTxt); 
   ReqLine.Validate(Quantity, ActualQty);
   ```
   * **Why `Validate` instead of direct assignment (`:=`)?** Direct assignment only updates the field value in memory. `Validate` assigns the value and then runs the field's `OnValidate` trigger in the table. This ensures the line imports correctly by looking up the item's standard details and pricing, and calculating the line amount.

5. **Commit the Record**:
   `ReqLine.Insert(true);` saves the populated line record to the database.

---

## 5. Reporting & Document Layout

### File: `RequisitionReport.Report.al`
The dataset controller for the Requisition Report.

```al
report 50149 "Requisition Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Purchase Requisition Report';

    DefaultLayout = RDLC;
    RDLCLayout = './RequisitionReport.rdl';

    dataset
    {
        dataitem(ReqHeader; "Custom Requisition Header")
        {
            RequestFilterFields = "Request Date", "Department Code", Status;

            column(No_ReqHeader; "No.") { }
            column(Description_ReqHeader; Description) { }
            column(DepartmentCode_ReqHeader; "Department Code") { }
            column(RequestedBy_ReqHeader; "Requested By") { }
            column(RequestDate_ReqHeader; "Request Date") { }
            column(Status_ReqHeader; Status) { }
            column(TotalAmount_ReqHeader; "Total Amount") { }

            column(FormattedDate; FormattedDate) { }
            column(CompanyName; CompanyName) { }
            column(CompanyLogo; CompanyInfo.Picture) { }
            column(TodayDate; TodayDate) { }

            dataitem(ReqLine; "Custom Requisition Line")
            {
                DataItemLink = "Requisition No." = field("No.");
                DataItemTableView = sorting("Line No.") order(ascending);

                column(LineNo_ReqLine; "Line No.") { }
                column(ItemNo_ReqLine; "Item No.") { }
                column(Description_ReqLine; Description) { }
                column(Quantity_ReqLine; Quantity) { }
                column(UnitPrice_ReqLine; "Unit Price") { }
                column(LineAmount_ReqLine; "Line Amount") { }

                column(LineAmountText; LineAmountText) { }

                trigger OnAfterGetRecord()
                begin
                    LineAmountText := StrSubstNo('$%1', Format(ReqLine."Line Amount", 0, '<Precision,2:2><Standard Format,0>'));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FormattedDate := Format(ReqHeader."Request Date", 0, '<Day,2>-<Month Text,3>-<Year4>');
            end;
        }
    }

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

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        CompanyName := CompanyInfo.Name;

        TodayDate := Format(Today, 0, '<Day,2>-<Month Text,3>-<Year4>');

        if (StartDateFilter <> 0D) and (EndDateFilter <> 0D) then
            ReqHeader.SetFilter("Request Date", '%1..%2', StartDateFilter, EndDateFilter)
        else begin
            if StartDateFilter <> 0D then
                ReqHeader.SetFilter("Request Date", '>=%1', StartDateFilter);
            if EndDateFilter <> 0D then
                ReqHeader.SetFilter("Request Date", '<=%1', EndDateFilter);
        end;

        if DeptCodeFilter <> '' then
            ReqHeader.SetRange("Department Code", DeptCodeFilter);
    end;
}
```

#### The Context & Business Purpose
Generates a printable purchase requisition document, including document headers, detailed lines, and company branding (logo and name).

#### System Architecture & Blueprint properties
* **`DefaultLayout = RDLC;`**: Specifies that the report uses the Report Definition Language Client-side format for its layout.
* **`RDLCLayout = './RequisitionReport.rdl';`**: Links the report controller to its visual layout file.
* **`RequestFilterFields`**: Adds the specified fields (`"Request Date"`, `"Department Code"`, and `Status`) to the report request page's default filter group.
* **`DataItemLink = "Requisition No." = field("No.");`**: Establishes parent-child data linking, ensuring that the report engine queries lines only for the active requisition header.
* **`DataItemTableView = sorting("Line No.") order(ascending);`**: Sorts the child requisition lines by `"Line No."` in ascending order.

#### AL Logic & Code Breakdown

##### Trigger: `OnPreReport()`
Runs once before the report data is read.
1. Calls `CompanyInfo.Get()`. This retrieves the company information record.
2. Calls `CompanyInfo.CalcFields(Picture)`. 
   > [!NOTE]
   > Business Central tables store media fields (like images and attachments) as binary blobs. These blobs are not retrieved during normal database queries to optimize performance. The `CalcFields()` method forces the database engine to retrieve the image blob.
3. Populates global header variables (`CompanyName` and `TodayDate`).
4. Applies custom date range filters entered on the request page:
   ```al
   if (StartDateFilter <> 0D) and (EndDateFilter <> 0D) then
       ReqHeader.SetFilter("Request Date", '%1..%2', StartDateFilter, EndDateFilter)
   ```
   If both filters are set, it applies a range filter. Otherwise, it applies minimum (`>=`) or maximum (`<=`) filters.
5. Applies a department filter if one was entered:
   ```al
   if DeptCodeFilter <> '' then
       ReqHeader.SetRange("Department Code", DeptCodeFilter);
   ```

##### Trigger: `ReqHeader - OnAfterGetRecord()`
Runs for each header record retrieved by the query. It formats the requisition date into a standardized string format:
```al
FormattedDate := Format(ReqHeader."Request Date", 0, '<Day,2>-<Month Text,3>-<Year4>');
```
This formats the date to a readable format (e.g., `08-Jun-2026`).

##### Trigger: `ReqLine - OnAfterGetRecord()`
Runs for each line record associated with the current header. It formats the decimal line amount as a currency string:
```al
LineAmountText := StrSubstNo('$%1', Format(ReqLine."Line Amount", 0, '<Precision,2:2><Standard Format,0>'));
```
This formats the decimal value with two decimal places and a thousands separator, prepending a dollar sign.

---

## 6. Business Central Architectural Concepts

### Master-Detail (Header/Line) Architecture
The Master-Detail pattern is a fundamental pattern for document structures in ERP systems.

```
       [ Custom Requisition Header ]
                     │
                     └── (PK: "No.")
                           │
                           ▼ Table Relation
                     ┌──────────────────────────────┐
                     │  "Requisition No." (FK)      │
                     │  "Line No." (PK Part 2)      │
                     └──────────────────────────────┘
                        [ Custom Requisition Line ]
```

* **Relational Structure**: The pattern separates document-wide properties (the header) from individual line items (the detail lines).
* **Identity Propagation**: The child table uses a composite primary key: `("Requisition No.", "Line No.")`. The parent key (`"No."`) propagates to the child's `"Requisition No."` foreign key.
* **UI Sync**: The system links the parent page and sub-grid using the `SubPageLink` property:
  ```al
  SubPageLink = "Requisition No." = field("No.");
  ```
  When the subform initialized, this link filters the lines to display only those belonging to the active header. When a user creates a new line in the subpage, the runtime automatically assigns the header's `"No."` to the line's `"Requisition No."` field.

---

### FlowFields & Sum Index Field Technology (SIFT)
FlowFields are calculated, read-only fields that display real-time calculations.

```
       [ Custom Requisition Header ]
          - "Total Amount" (FlowField)
                    │
                    ▼ Sums Line Amounts
       [ Custom Requisition Line ]
          - "Line Amount" (Decimal)
                    │
                    ▼ Supported by
       [ SQL Server Clustered Index ]
          - Index Key: "Requisition No.", "Line No."
          - SIFT Sum-Index: "Line Amount"
```

1. **Calculations**: SIFT uses indexed views in SQL Server to maintain pre-calculated sums of specified fields for each key. When the system updates a line record, the database updates these sums in real-time.
2. **Retrieval**: When the application reads a FlowField (e.g., displaying the `"Total Amount"` field on the card page), SQL Server queries the pre-aggregated sum directly from the SIFT index, avoiding a table scan.
3. **Execution**: SIFT aggregates are updated automatically on the database server. In AL code, you can force the calculation of a FlowField by calling `Record.CalcFields("Total Amount")` before reading its value.

---

### Event-Driven Architecture (Publishers & Subscribers)
Event-driven architecture allows developers to extend Business Central without modifying standard base code.

```
     [ Standard Base Application ]
           │
           ▼ executes base code (e.g., Item Post)
     [ Integration Publisher ]
           │
           ▼ raises event notification
     [ Event Subscriber ] (in your extension)
           │
           ▼ runs custom extension logic
```

* **Decoupling**: The base application defines **Publishers** (hooks) at key transaction events.
* **Subscribers**: Custom extensions define **Subscribers** that listen to these events.
* **Declarative Routing**: Subscribers register with the platform using attributes:
  ```al
  [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
  ```
  When the publisher event fires, the runtime invokes all registered subscribers. This allows you to insert custom logic and validation without changing the standard codebase.

---

### Visual Rendering Engines: RDLC vs. Word Layout
Business Central supports different layouts for formatting report datasets.

| Dimension | RDLC Layout | Word Layout |
| :--- | :--- | :--- |
| **Technology** | SQL Server Reporting Services (SSRS) | OpenXML Word Document Structure |
| **Layout Model** | Tabular, page-oriented layout hierarchy | Flow-based page design |
| **Complexity** | High (supports conditional grouping, dynamic columns, page formulas) | Low (designed for simple formatting and fields) |
| **Performance** | Optimized for complex datasets and large documents | Optimized for simple document printing and labels |
| **Editing Tools** | Visual Studio Report Designer, Report Builder | Microsoft Word |

* **RDLC Layout**: Built on SSRS technology. It uses a structured page layout with repeat headers, groupings, and page number calculations, making it ideal for financial reports and invoices.
* **Word Layout**: Maps report dataset fields to custom XML properties inside a Word document. It is easy to customize in Microsoft Word, but lacks support for advanced grouping and page numbering rules.
