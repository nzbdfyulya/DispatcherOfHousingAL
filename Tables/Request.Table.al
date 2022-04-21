table 50122 Request
{
    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    SalesSetup.GET;
                    NoSeriesMgt.TestManual(SalesSetup."Request Nos.");
                    "No. Series" := '';
                    NoSeriesMgt.SetSeries("No.");
                END;

            end;
        }
        field(2; "User ID"; Code[20])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
        }
        field(3; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionMembers = Created,Assigned,Canceled,Posted;
            OptionCaption = 'Created,Assigned,Canceled,Posted';
            Editable = false;

        }
        field(6; Priority; Option)
        {
            Caption = 'Priority';
            DataClassification = ToBeClassified;
            OptionMembers = Low,High,Emergency;
            OptionCaption = 'Low,High,Emergency';
        }
        field(7; "Request Category"; Option)
        {
            Caption = 'Request Category';
            DataClassification = ToBeClassified;
            OptionMembers = Electrician,"Sanitary engineering",Gas;
            OptionCaption = 'Electrician,Sanitary engineering,Gas';
        }
        field(8; "Repairman Code"; Code[20])
        {
            Caption = 'Repairman Code';
            DataClassification = ToBeClassified;
            ValidateTableRelation = true;
            TableRelation = Repairman.Code WHERE("Request Category" = field("Request Category"));

            trigger OnValidate()
            begin
                IF "Repairman Code" = '' THEN
                    Status := Status::Created
                ELSE
                    Status := Status::Assigned;

                CreateDim(DATABASE::Repairman, "Repairman Code",
                DATABASE::Customer, "Customer No.");
            end;

        }
        field(9; "Repairman Name"; Text[50])
        {
            Caption = 'Repairman Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Repairman.Name where("Code" = field("Repairman Code")));
            Editable = false;

        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
            ValidateTableRelation = False;

            trigger OnValidate()
            begin
                IF CustomerRec.GET("Customer No.") THEN BEGIN
                    "Customer Full Name" := CustomerRec."Name";
                    "Customer City" := CustomerRec.City;
                    "Customer Phone No." := CustomerRec."Phone No.";
                    MODIFY;
                END;

                CreateDim(DATABASE::Repairman, "Repairman Code",
                          DATABASE::Customer, "Customer No.");
            end;

        }
        field(11; "Customer Full Name"; Text[50])
        {
            Caption = 'Customer Full Name';
            DataClassification = ToBeClassified;
            TableRelation = Customer.Name WHERE("No." = FIELD("Customer No."));
            ValidateTableRelation = false;

        }
        field(12; "Customer Phone No."; Code[20])
        {
            Caption = 'Customer Phone No.';
            TableRelation = Customer."Phone No." WHERE("No." = FIELD("Customer No."));
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                i: Integer;
                Char: DotNet Char;
            begin
                FOR i := 1 TO STRLEN("Customer Phone No.") DO
                    IF Char.IsLetter("Customer Phone No."[i]) THEN
                        FIELDERROR("Customer Phone No.", PhoneNoCannotContainLettersErr);

                "Customer Phone No." := FormatPhoneNumber;
            end;

        }
        field(13; "Customer City"; Text[50])
        {
            Caption = 'Customer City';
            TableRelation = Customer.City WHERE("No." = FIELD("Customer No."));
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;
        }
        field(14; "Customer Street"; Text[100])
        {
            Caption = 'Customer Street';
            DataClassification = ToBeClassified;
        }
        field(15; "Customer House No."; Code[10])
        {
            Caption = 'Customer House No.';
            DataClassification = ToBeClassified;
        }
        field(16; "Customer Room"; Code[10])
        {
            Caption = 'Customer Room';
            DataClassification = ToBeClassified;
        }
        field(17; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(19; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(false));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(20; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(false));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            TableRelation = "Dimension Set Entry";
            Editable = false;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        DimMgt: Codeunit DimensionManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Sales & Receivables Setup";
        CustomerRec: Record Customer;
        i: Integer;
        PhoneNoCannotContainLettersErr: Label 'Must not contain letters';

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            SalesSetup.GET;
            SalesSetup.TESTFIELD("Request Nos.");
            NoSeriesMgt.InitSeries(SalesSetup."Request Nos.", xRec."Customer No.", 0D, "No.", "No. Series");
        END;

        "User ID" := USERID;
        "Creation Time" := TIME;
        "Creation Date" := WORKDATE;

        IF "Repairman Code" = '' THEN
            Status := Status::Created
        ELSE
            Status := Status::Assigned;


    end;

    local procedure FormatPhoneNumber() PhoneNumber: Text[30]
    begin
        PhoneNumber := DELCHR("Customer Phone No.", '=', '+() -/\;:.,^$');
        EXIT(PhoneNumber)
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF "No." <> '' THEN
            MODIFY;

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
        END;
    end;

    internal procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" := DimMgt.EditDimensionSet("Dimension Set ID", "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
        END;

    end;

    local procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[2] of Integer;
        No: array[2] of Code[20];
        OldDimSetID: Integer;

    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
                Rec, CurrFieldNo, TableID, No, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        IF (OldDimSetID <> "Dimension Set ID") THEN
            MODIFY;
    end;

    internal procedure PostedShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;


}