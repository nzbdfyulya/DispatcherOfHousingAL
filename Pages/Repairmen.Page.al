page 50121 Repairmen
{
    Caption = 'Repairmen';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Dimensions';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Repairman;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;

                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;

                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = All;

                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;

                }
                field("Request Category"; Rec."Request Category")
                {
                    ApplicationArea = All;

                }

            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Dimensions)
            {
                Caption = 'Dimensions';
                action(DimensionsSingle)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions-Single';
                    ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Category4;

                    ShortcutKey = 'Shift+Ctrl+D';
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(50121), "No." = field(Code);



                    trigger OnAction()
                    begin

                    end;
                }
                action(DimensionsMultiple)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions-&Multiple';
                    ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';
                    Image = DimensionSets;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    AccessByPermission = TableData 348 = R;


                    trigger OnAction()
                    var
                        RepairmanRec: Record Repairman;
                        DefaultDimMultiple: Page "Default Dimensions-Multiple";
                    begin
                        CurrPage.SETSELECTIONFILTER(RepairmanRec);
                        DefaultDimMultiple.SetMultiRecord(RepairmanRec, Rec.FIELDNO(Code));
                        DefaultDimMultiple.RUNMODAL;
                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
}