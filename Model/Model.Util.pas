unit Model.Util;

interface

uses
  System.SysUtils;

  function RemoveAcento( aValue : String) : string;

implementation

function RemoveAcento(aValue: String): string;
var
  i : integer;
  aux : string;
begin
  aux := AnsiUpperCase(aValue);
    for i := 1 to length(aux) do
    begin
      case aux[i] of
      '�', '�', '�', '�', '�', '�', '�', '�', '�', '�': aux[i] := 'A';
      '�', '�', '�', '�', '�', '�', '�', '�', '&': aux[i] := 'E';
      '�', '�', '�', '�', '�', '�', '�', '�': aux[i] := 'I';
      '�', '�', '�', '�', '�', '�', '�', '�', '�', '�': aux[i] := 'O';
      '�', '�', '�', '�', '�', '�', '�', '�': aux[i] := 'U';
      '�', '�': aux[i] := 'C';
      '�', '�': aux[i] := 'N';
      '�', '�': aux[i] := 'Y';
      else
        if ord(aux[i]) > 127 then
          aux[i] := #32;
      end;
    end;
  Result := aux;
end;

end.
