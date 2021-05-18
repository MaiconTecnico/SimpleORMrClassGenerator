unit Model.DAO.Connection.FireDac;

interface

uses
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB,
  FireDAC.DApt,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Phys.IB,
  FireDAC.Phys.IBDef,
  FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.Phys.ODBC,
  FireDAC.Phys.ODBCDef,
  Model.DAO.Interfaces,
  System.SysUtils;

type
  TModelDAOConnection = class(TInterfacedObject, iModelDAOConnection)
    private
      FConnection : TFDConnection;
    public
      constructor Create;
      Destructor Destroy; override;
      class function New : iModelDAOConnection;
      function AddParam( aValue : String) : iModelDAOConnection;
      function DriverName( aValue : String) : iModelDAOConnection;
      function Database( aValue : String) : iModelDAOConnection;
      function Password( aValue : String) : iModelDAOConnection;
      function UserName( aValue : String) : iModelDAOConnection;
      function Server( aValue : String) : iModelDAOConnection;
      function Port( aValue : String) : iModelDAOConnection;
      function Connected( aValue : Boolean) : iModelDAOConnection;
      function Connection : TCustomConnection;
      function AutoReconnect( aValue : Boolean) : iModelDAOConnection;
      function ParamClear : iModelDAOConnection;
  end;

  TModelDAOConnectionQuery = class(TInterfacedObject, iModelDAOConnectionQuery)
      private                                                       
        FConnection : TFDConnection;
        FQuery : TFDQuery;
        procedure GetTableListFirebird;
        procedure GetTableListSQLite;
        procedure GetTableListMSSQL;
      public
        constructor Create( aConnection : iModelDAOConnection);
        Destructor Destroy; override;
        class function New( aConnection : iModelDAOConnection) : iModelDAOConnectionQuery;
        function Active( aValue : Boolean) : iModelDAOConnectionQuery;
        function DataSet : TDataSet;
        function SQLClear : iModelDAOConnectionQuery;
        function SQL( aValue : String) : iModelDAOConnectionQuery;
        function AddParam( aParam: String; aValue : Variant): iModelDAOConnectionQuery;
        function GetTableList : TDataSet;
        function Open : iModelDAOConnectionQuery;
        function Close : iModelDAOConnectionQuery;
  end;

implementation

{ TModelDAOConnectionQuery }

function TModelDAOConnectionQuery.Active(aValue: Boolean): iModelDAOConnectionQuery;
begin
  Result := Self;
  FQuery.Active := aValue;
end;

function TModelDAOConnectionQuery.AddParam(aParam: String; aValue: Variant): iModelDAOConnectionQuery;
begin
  Result := Self;
  FQuery.ParamByName(aParam).Value := aValue;
end;

function TModelDAOConnectionQuery.Close: iModelDAOConnectionQuery;
begin
  Result := Self;
  FQuery.Close;
end;

constructor TModelDAOConnectionQuery.Create( aConnection : iModelDAOConnection);
begin
  FConnection := (aConnection.Connection as TFDConnection);

  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FConnection;
end;

destructor TModelDAOConnectionQuery.Destroy;
begin
  FQuery.DisposeOf;
  inherited;
end;

function TModelDAOConnectionQuery.GetTableList: TDataSet;
begin
  FQuery.Close;
  if FConnection.Params.DriverID = 'FB' then
    GetTableListFirebird
  else if FConnection.Params.DriverID = 'SQLite' then
    GetTableListSQLite
  else if FConnection.Params.DriverID = 'MSSQL' then
    GetTableListMSSQL
  else
    raise Exception.Create('GetTableList n�o implementada!');
  Result := FQuery;
end;

class function TModelDAOConnectionQuery.New( aConnection : iModelDAOConnection) : iModelDAOConnectionQuery;
begin
  Result := Self.Create(aConnection);
end;

function TModelDAOConnectionQuery.Open: iModelDAOConnectionQuery;
begin
  FQuery.Open;
end;

procedure TModelDAOConnectionQuery.GetTableListFirebird;
begin
  FQuery.Open('select rdb$relation_name from rdb$relations where rdb$system_flag = 0 order by rdb$relation_name;');
end;

procedure TModelDAOConnectionQuery.GetTableListMSSQL;
begin
  FQuery.Open('SELECT TABLE_NAME FROM information_schema.tables order by TABLE_NAME;');
end;

procedure TModelDAOConnectionQuery.GetTableListSQLite;
begin
  FQuery.Open('SELECT name FROM sqlite_master WHERE type=''table'' ORDER BY name;');
end;

function TModelDAOConnectionQuery.DataSet: TDataSet;
begin
  Result := FQuery;
end;

function TModelDAOConnectionQuery.SQL(aValue: String): iModelDAOConnectionQuery;
begin
  Result := Self;
  FQuery.SQL.Add(aValue);
end;

function TModelDAOConnectionQuery.SQLClear: iModelDAOConnectionQuery;
begin
  Result := Self;
  FQuery.SQL.Clear;
end;

{ TModelDAOConnection }

function TModelDAOConnection.AddParam(aValue: String): iModelDAOConnection;
begin
  Result := Self;
  FConnection.Params.Add(aValue);
end;

function TModelDAOConnection.AutoReconnect(aValue: Boolean): iModelDAOConnection;
begin
  Result := Self;
  FConnection.ResourceOptions.AutoReconnect := aValue;
end;

function TModelDAOConnection.Connected(aValue: Boolean): iModelDAOConnection;
begin
  Result := Self;
  FConnection.Connected := aValue;
end;

function TModelDAOConnection.Connection: TCustomConnection;
begin
  Result := FConnection;
end;

constructor TModelDAOConnection.Create;
begin
  FConnection := TFDConnection.Create(nil);
end;

function TModelDAOConnection.Database(aValue: String): iModelDAOConnection;
begin
  Result := Self;
  FConnection.Params.Database := aValue;
end;

destructor TModelDAOConnection.Destroy;
begin
  FConnection.DisposeOf;
  inherited;
end;

function TModelDAOConnection.DriverName(aValue: String): iModelDAOConnection;
begin
  Result := Self;
  FConnection.Params.DriverID := aValue;
end;

class function TModelDAOConnection.New: iModelDAOConnection;
begin
  Result := Self.Create;
end;

function TModelDAOConnection.ParamClear: iModelDAOConnection;
begin
  Result := Self;
  FConnection.Params.Clear;
end;

function TModelDAOConnection.Password(aValue: String): iModelDAOConnection;
begin
  Result := Self;
  FConnection.Params.Password := aValue;
end;

function TModelDAOConnection.Port(aValue: String): iModelDAOConnection;
begin
  Result := Self;
  if not aValue.IsEmpty then
    FConnection.Params.Add('Port='+aValue);
end;

function TModelDAOConnection.Server(aValue: String): iModelDAOConnection;
begin
  Result := Self;
  FConnection.Params.Add('Server='+aValue);
end;

function TModelDAOConnection.UserName(aValue: String): iModelDAOConnection;
begin
  Result := Self;
  FConnection.Params.UserName := aValue;
end;

end.
