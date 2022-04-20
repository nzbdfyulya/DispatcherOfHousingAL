page 50122 "Requests List"
{
    PageType = List;
    Caption = 'Requests List';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Request;
    Editable = False;
    CardPageId = "Request Doc";
    PromotedActionCategories = 'New,Process,Report,Dimensions';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = false;
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


            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Dimensions)
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                ShortcutKey = 'Shift+Ctrl+D';
                AccessByPermission = TableData Dimension = R;


                trigger OnAction()
                begin
                    IF (Rec.Status = Rec.Status::Posted) THEN
                        Rec.PostedShowDimensions
                    ELSE BEGIN
                        Rec.ShowDocDim
                    END;


                end;
            }
            action(Print)
            {
                ApplicationArea = all;
                Caption = 'Print';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunPageOnRec = false;

                trigger OnAction()
                var
                begin
                    REPORT.RUN(REPORT::"Requests Report", TRUE, TRUE, Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}