program Dim;

uses
  Vcl.Forms,
  artdim in 'artdim.pas' {Form1},
  Delphiartnet in 'Delphiartnet.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
