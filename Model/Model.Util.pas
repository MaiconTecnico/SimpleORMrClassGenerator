unit Model.Util;

interface

uses
  System.SysUtils;

  function RemoveAcento( aValue : String) : string;
  function Capitaliza( aValue : String; Captalizar, RemoveCaracter : Boolean) : string;

implementation

function Capitaliza( aValue : String; Captalizar, RemoveCaracter : Boolean) : string;
var
  flag: Boolean;
  i: Byte;
  t: string;
begin
  t := aValue;
  if Captalizar then
  begin
    flag := True;
    aValue := AnsiLowerCase(aValue);
    t := EmptyStr;
    for i := 1 to Length(aValue) do
    begin
      if flag then
        t := t + AnsiUpperCase(aValue[i])
      else
        t := t + aValue[i];
      flag := (CharInSet(aValue[i],[' ','_','-', '[',']', '(', ')']));
    end;
  end;
  if RemoveCaracter then
    t := t.Replace(' ','')
          .Replace('_','')
          .Replace('-','')
          .Replace(',','')
          .Replace(', ','');

  Result := t;
end;

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
