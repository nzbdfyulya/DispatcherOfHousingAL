page 50124 "Request Doc"
{
    PageType = Document;
    SourceTable = Request;
    Caption = 'Request Doc';

    PromotedActionCategories = 'New,Process,Report,Dimensions,Status';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = EditableFields;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                }
                field("Request Category"; Rec."Request Category")
                {
                    ApplicationArea = All;
                }
                field("Repairman Code"; Rec."Repairman Code")
                {
                    ApplicationArea = All;
                }
                field("Repairman Name"; Rec."Repairman Name")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Full Name"; Rec."Customer Full Name")
                {
                    ApplicationArea = All;
                }
                field("Customer Phone No."; Rec."Customer Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Customer City"; Rec."Customer City")
                {
                    ApplicationArea = All;
                }
                field("Customer Street"; Rec."Customer Street")
                {
                    ApplicationArea = All;
                }
                field("Customer House No."; Rec."Customer House No.")
                {
                    ApplicationArea = All;
                }
                field("Customer Room"; Rec."Customer Room")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }


            }
            group(Dimensions)
            {
                Caption = 'Dimensions';
                Editable = EditableFields;
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part("Request Count"; "Request Count")
            {
                Caption = 'Request Count';
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action("Post Request")
            {
                Enabled = Enable;
                Caption = 'Post Request';
                Image = PostedOrder;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = True;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF (Rec.Status = Rec.Status::Posted) THEN
                        Enable := FALSE
                    ELSE
                        Enable := TRUE;

                    Rec.Status := Rec.Status::Posted;
                    Rec."Posting Date" := WORKDATE;
                    Rec.Modify();

                end;
            }
            action("Cancel Request")
            {
                Enabled = EnableCancel;
                Caption = 'Cancel Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = True;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF (Rec.Status = Rec.Status::Canceled) THEN
                        EnableCancel := FALSE
                    ELSE
                        EnableCancel := TRUE;

                    Rec.Status := Rec.Status::Canceled;
                    Rec.Modify();
                end;
            }
            action(Dimension)
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                Image = Dimensions;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;

                ShortcutKey = 'Shift+Ctrl+D';
                AccessByPermission = TableData Dimension = R;

                trigger OnAction()
                begin
                    IF (Rec.Status = Rec.Status::Posted) THEN
                        Rec.PostedShowDimensions
                    ELSE BEGIN
                        Rec.ShowDocDim;
                        CurrPage.SAVERECORD;
                    END;

                end;
            }
        }
    }
    trigger OnInit()
    begin
        IF (Rec.Status = Rec.Status::Created) THEN
            EditableFields := TRUE;

    end;

    trigger OnAfterGetRecord()
    Begin

        IF (Rec.Status = Rec.Status::Posted) THEN BEGIN
            Enable := FALSE;
            EditableFields := FALSE;
        END ELSE BEGIN
            Enable := TRUE;
            EditableFields := TRUE;
        END;

        IF (Rec.Status = Rec.Status::Canceled) THEN
            EnableCancel := FALSE
        ELSE
            EnableCancel := TRUE;

    End;

    var
        Enable: Boolean;
        EnableCancel: Boolean;
        EditableFields: Boolean;

}