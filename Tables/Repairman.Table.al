table 50121 "Repairman"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';

            DataClassification = ToBeClassified;
            Description = 'Key';

            trigger OnValidate()
            begin
                IF "Code" <> xRec."Code" THEN BEGIN
                    SalesSetup.GET;
                    NoSeriesMgt.TestManual(SalesSetup."Repairman Nos.");
                    "No. Series" := '';
                    NoSeriesMgt.SetSeries("Code");
                END;

            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3; "E-mail"; Text[80])
        {
            Caption = 'E-mail';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                IF "E-mail" = '' THEN
                    ERROR(EmailAddressEmptyErr);
                MailManagement.CheckValidEmailAddresses("E-mail");
            end;
        }
        field(4; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            var
                Char: DotNet "Char";
            begin

                FOR i := 1 TO STRLEN("Phone No.") DO
                    IF Char.IsLetter("Phone No."[i]) THEN
                        FIELDERROR("Phone No.", PhoneNoCannotContainLettersErr);
                "Phone No." := FormatPhoneNumber;
            end;

        }
        field(5; "Request Category"; Option)
        {
            Caption = 'Request Category';
            DataClassification = ToBeClassified;
            OptionCaption = 'Electrician,Sanitary engineering,Gas';
            OptionMembers = Electrician,"Sanitary engineering",Gas;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(7; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;

        }
        field(8; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Code" = '' THEN BEGIN
            SalesSetup.GET;
            SalesSetup.TESTFIELD("Repairman Nos.");
            NoSeriesMgt.InitSeries(SalesSetup."Repairman Nos.", xRec."Code", 0D, "Code", "No. Series");
        END;

        DimMgt.UpdateDefaultDim(DATABASE::Repairman, "Code", "Global Dimension 1 Code", "Global Dimension 2 Code");

    end;

    trigger OnDelete()
    begin
        DimMgt.DeleteDefaultDim(DATABASE::Repairman, Code);
    end;

    trigger OnRename()
    begin
        DimMgt.RenameDefaultDim(DATABASE::Repairman, xRec.Code, Code);
    end;

    local procedure FormatPhoneNumber() PhoneNumber: Text[30]
    begin
        PhoneNumber := DELCHR("Phone No.", '=', '+() -/\;:.,^$');
        EXIT(PhoneNumber)
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        IsHandled: Boolean;
    begin
        IsHandled := FALSE;
        IF IsHandled THEN
            EXIT;

        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);

        IF NOT ISTEMPORARY THEN BEGIN
            DimMgt.SaveDefaultDim(DATABASE::Repairman, Code, FieldNumber, ShortcutDimCode);
            MODIFY;
        END;

    end;

    var
        EmailAddressEmptyErr: Label 'An email address must be specified.';
        ConfigAlreadyExistsErr: Label 'The email address has already been added.';
        PhoneNoCannotContainLettersErr: Label 'Must not contain letters';
        MailManagement: Codeunit "Mail Management";
        DimMgt: Codeunit DimensionManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SalesSetup: Record "Sales & Receivables Setup";
        RequestRec: Record Request;
        i: Integer;

}

