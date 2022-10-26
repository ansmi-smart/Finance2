codeunit 50000 MyTest
{
    Subtype = Test;

    trigger OnRun()
    begin
        myTest();
    end;

    [Test]
    procedure myTest()
    begin
    end;
}