unit uTest;

interface
type
    TTestClass = class
    public
        function Getcount : integer;
        property Count : integer read Getcount default 0;
    end;

    TNewTestClass = class(TTestClass)

    end;

    TTestClassHelper = class helper for TTestClass

    end;
implementation

{ TTestClass }

function TTestClass.getcount: integer;
begin

end;

end.
