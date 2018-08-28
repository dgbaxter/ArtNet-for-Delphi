//////project name
//Artnet

//////description
//Utility library to talk Artnet, ie. DMX over ethernet
// modified to focus on sending DMX levels, for comments refer to the original artnet.pas
//////licence
//GNU Lesser General Public License (LGPL v3)

//////language/ide
//delphi

//////initial author
//Sebastian Oschatz -> oschatz@vvvv.org
// modified by Dave Baxter -> dave@baxeldata.com

unit DelphiArtNet;

interface

uses
  Sysutils, Syncobjs, Classes,
  IdGlobal, IdUDPServer, IdSocketHandle;

type

  TMArtPollPacket  = record
    ID : array[0..7] of ansichar;
    OpCode : Word;
    ProtVerH : Byte; 
    ProtVerL : Byte;
    TalkToMe : Byte;
    Pad : Byte;
  end;

  TMArtPollReplyPacket  = record
    ID : array[0..7] of ansichar;
    OpCode : Word;
    IPAddress : array[0..3] of Byte;
    PortL : Byte;
    PortH : Byte;
    VersInfoH : Byte;
    VersInfoL : Byte;
    SubSwitchH : Byte;
    SubSwitchL : Byte;
    OemH : Byte;
    OemL : Byte;
    UbeaVersion : Byte;
    Status : Byte;
    EstaMan : Word;
    ShortName : array[0..17] of ansichar;
    LongName : array[0..63] of ansichar;
    NodeReport : array[0..63] of ansichar;
    NumPortsH : byte;
    NumPortsL : byte;
    PortTypes : array[0..3] of byte;
    GoodInput : array[0..3] of byte;
    GoodOutput : array[0..3] of byte;
    Swin : array[0..3] of byte;
    Swout : array[0..3] of byte;
    SwVideo : byte;
    SwMacro : byte;
    SwRemote : byte;
    Reserved27 : Byte; 
    Reserved28 : Byte; 
    Reserved29 : Byte; 
    Style : Byte;
    MACAddress : array[0..5] of byte;
    Filler : array[0..31] of byte;
end;

  TMArtPollData = record
    IsInput : boolean;
    Subnet : integer;
    Universe : integer;
    ShortName : string;
    LongName : string;
  end;

  TMArtDmxPacket  = record
    ID : array[0..7] of AnsiChar;
    OpCode : Word;
    ProtVerH : Byte;
    ProtVerL : Byte;
    Sequence : Byte;
    Physical : Byte;
    UniverseL : Byte;
    UniverseH : Byte;
    LengthH : Byte;
    LengthL : Byte;
    Data : array[0..511] of byte;
  end;

  TMArtnetDecoder = class
  private
    FSocket: TIdUDPServer;
    class procedure ReadCB(AThread: TIdUDPListenerThread; const AData: TIdBytes; ABinding: TIdSocketHandle);
  protected
    function CreateArtDMX(subnet, universe: byte; dmx : PByteArray): TMArtDMXPacket;
  public
    constructor Create;
    destructor Destroy;  override;
    procedure SendDMX(DestAdr: String; subnet, universe: byte; dmx: PByteArray);
    function CreateArtPoll: TMArtPollPacket;
    procedure DoArtPoll;
  published
    function isArtPoll(packet : pointer): Boolean;
    procedure ParseArtPoll(packet : pointer);
  end;

const
  cmalOpArtPoll = $2000;
  cmalOpArtPollReply = $2100;
  cmalOpArtDMX = $5000;
  cmalArtNetID = 'Art-Net' + #0;

var
  GArtNetPort : smallint = $1936;    // 6454
  levels: array[0..511] of byte;
  IP: string;

implementation

uses
  Variants, IdUDPBase, artdim;

function TMArtnetDecoder.CreateArtDMX(subnet, universe: byte; dmx:PByteArray): TMArtDMXPacket;
var
  i : integer;
begin
  fillchar(result, sizeof(result), 0);
  result.ID := cmalArtNetID; 
  result.OpCode := cmalOpArtDMX;
  result.ProtVerH := 0;
  result.ProtVerL := 14;
  result.Sequence := 0;  // no sequence
  result.Physical := 1;
  result.UniverseL := ((subnet and $0F) * 16 ) + (universe and $0F);
  result.UniverseH := 0;
  result.LengthH := hi(512);
  result.LengthL := lo(512);
  for i:= 0 to 511 do
    result.Data[i] := dmx[i];
end;

function TMArtnetDecoder.CreateArtPoll: TMArtPollPacket;
begin
  result.ID := cmalArtNetID;
  result.OpCode := cmalOpArtPoll;
  result.ProtVerH := 0;
  result.ProtVerL := 14;
  result.TalkToMe := 0;
  result.Pad := 0;
end;

procedure TMArtnetDecoder.DoArtPoll;
var
  artdmx : TMArtPollPacket;
  buffer: TIdBytes;
begin
  artdmx := CreateArtPoll;
  buffer := IdGlobal.RawToBytes(artdmx, SizeOf(artdmx));
  FSocket.SendBuffer('255.255.255.255', GArtNetPort, Id_IPv4, buffer);  // broadcast
end;

function TMArtnetDecoder.isArtPoll(packet : pointer): Boolean;
var
  poll : ^TMArtPollPacket;
begin
  poll := packet;
  result := poll.OpCode = $2100;
end;

procedure TMArtnetDecoder.ParseArtPoll(packet : pointer);
var
  dmx : ^TMArtPollReplyPacket;
  Ln, Sn: string;
begin
  dmx := packet;
  Ln := dmx.LongName;
  Sn := dmx.ShortName;
  Form1.Memo1.lines.add(Ln);
  Ip := inttostr(dmx.IPAddress[0])+'.'+inttostr(dmx.IPAddress[1])+'.'+inttostr(dmx.IPAddress[2])+'.'+inttostr(dmx.IPAddress[3]);
  Form1.Memo1.lines.add(Ip);
end;

constructor TMArtnetDecoder.Create;
var
  i, j : integer;
begin
  FSocket := TIdUDPServer.Create(nil);
  FSocket.ThreadedEvent := false;    // no threads
  FSocket.DefaultPort := GArtNetPort;
  FSocket.BroadcastEnabled := True;
  FSocket.OnUDPRead := ReadCB;
  FSocket.Active := True;
end;

destructor TMArtnetDecoder.Destroy;
begin
  FSocket.Active := False;
  FSocket.Free;
  inherited;
end;

procedure TMArtnetDecoder.SendDMX(DestAdr: String; subnet, universe: byte; dmx:
    PByteArray);
var
  artdmx : TMArtDMXPacket;
  buffer: TIdBytes;
begin
  artdmx := CreateArtDMX(subnet, universe, dmx);
  buffer := IdGlobal.RawToBytes(artdmx, SizeOf(artdmx));
  FSocket.SendBuffer(DestAdr, GArtNetPort, Id_IPv4, buffer);
end;

class procedure TMArtnetDecoder.ReadCB(AThread: TIdUDPListenerThread; const AData:TIdBytes; ABinding: TIdSocketHandle);
var
  item: Pointer;
  size: integer;
begin
  try
    GetMem(item, Length(AData));
    IdGlobal.BytesToRaw(AData, item^, Length(AData));
    If dmxdim.isArtPoll(item) then dmxdim.ParseArtPoll(item);
  finally
    FreeMem(item);
  end;
end;

end.