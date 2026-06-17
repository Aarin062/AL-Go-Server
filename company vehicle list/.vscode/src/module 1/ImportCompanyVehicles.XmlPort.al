xmlport 50100 "Import Company Vehicles"
{
    Direction = Import;
    Format = VariableText;
    FieldSeparator = ',';
    UseRequestPage = false; 

    schema
    {
        textelement(Root)
        {
            tableelement(Vehicle; "Company Vehicle")
            {
                AutoUpdate = true; 

                fieldelement(VehicleNo; Vehicle."Vehicle No.") { }
                fieldelement(RegistrationNo; Vehicle."Registration No.") { }
                fieldelement(VehicleName; Vehicle."Vehicle Name") { }
                fieldelement(VehicleType; Vehicle."Vehicle Type") { }
                fieldelement(Brand; Vehicle.Brand) { }
                fieldelement(Model; Vehicle.Model) { }
                fieldelement(PurchaseDate; Vehicle."Purchase Date") { }
                fieldelement(PurchaseCost; Vehicle."Purchase Cost") { }
                fieldelement(CurrentMileage; Vehicle."Current Mileage") { }
                fieldelement(Status; Vehicle.Status) { }
                
                // Changed from fieldelement to textelement to intercept the value
                textelement(ImportedDriver) { }

                // Trigger fires before a new vehicle is inserted
                trigger OnBeforeInsertRecord()
                begin
                    ProcessDriverAssignment();
                end;

                // Trigger fires before an existing vehicle is updated (due to AutoUpdate = true)
                trigger OnBeforeModifyRecord()
                begin
                    ProcessDriverAssignment();
                end;
            }
        }
    }

    local procedure ProcessDriverAssignment()
    var
        Emp: Record Employee;
    begin
        // If the CSV has a value for the driver
        if ImportedDriver <> '' then begin
            
            // Check if the Employee already exists
            if not Emp.Get(ImportedDriver) then begin
                // If not, create a basic placeholder record
                Emp.Init();
                Emp."No." := ImportedDriver;
                Emp."First Name" := 'Auto-Generated Driver';
                Emp.Insert(true);
            end;

            // Assign the verified/created driver code to our Vehicle record
            Vehicle."Assigned Driver" := ImportedDriver;
            
        end else begin
            // Handle cases where the CSV has a blank value (e.g., V005)
            Vehicle."Assigned Driver" := '';
        end;
    end;
}