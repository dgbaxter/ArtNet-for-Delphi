unit artdim;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  IdBaseComponent, IdComponent, IdUDPBase, DelphiArtNet, IdUDPServer,
  IdGlobal, IdSocketHandle;

type
  TForm1 = class(TForm)
    TrackBar1: TTrackBar;
    Memo1: TMemo;
    IdUDPServer1: TIdUDPServer;
    TrackBar2: TTrackBar;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  dmxdim: Tmartnetdecoder;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
    edit1.Text := IP;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    dmxdim.CreateArtPoll;
    dmxdim.DoArtPoll;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    dmxdim.free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    dmxdim := Tmartnetdecoder.Create;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var
    dmx: pByteArray;
begin
    levels[0] := 255-Trackbar1.Position;
    dmx := @levels;
    dmxdim.SendDMX(edit1.text,0,0,dmx);
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
var
    dmx: pByteArray;
begin
    levels[1] := 255-Trackbar2.Position;
    dmx := @levels;
    dmxdim.SendDMX(edit1.text,0,0,dmx);
end;

procedure TForm1.TrackBar3Change(Sender: TObject);
var
    dmx: pByteArray;
begin
    levels[2] := 255-Trackbar3.Position;
    dmx := @levels;
    dmxdim.SendDMX(edit1.text,0,0,dmx);
end;

procedure TForm1.TrackBar4Change(Sender: TObject);
var
    dmx: pByteArray;
begin
    levels[3] := 255-Trackbar4.Position;
    dmx := @levels;
    dmxdim.SendDMX(edit1.text,0,0,dmx);
end;

end.

