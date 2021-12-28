unit Utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, ComCtrls;

type

  { TFormUtama }

  TFormUtama = class(TForm)
    ButtonClose: TButton;
    ButtonSave: TButton;
    ButtonLoad: TButton;
    ButtonReplikasi: TButton;
    ImageOriginal: TImage;
    ImageReplikasi: TImage;
    LabelSkala: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    PanelImage: TPanel;
    SavePictureDialog1: TSavePictureDialog;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    Splitter1: TSplitter;
    TrackBarSkala: TTrackBar;
    procedure ButtonLoadClick(Sender: TObject);
    procedure TrackBarSkalaChange(Sender: TObject);
    procedure ButtonReplikasiClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
  private

  public

  end;

var
  FormUtama: TFormUtama;

implementation

{$R *.lfm}

{ TFormUtama }
uses
  windows, math;

var
  bitmapR, bitmapG, bitmapB : array [0..1000, 0..1000] of integer;
  hasilR, hasilG, hasilB : array [0..2000, 0..2000] of integer;

procedure TFormUtama.ButtonLoadClick(Sender: TObject);
var
  x, y : integer;

begin
  if OpenPictureDialog1.Execute then
  begin
    ImageOriginal.Picture.LoadFromFile(OpenPictureDialog1.FileName);

    TrackBarSkala.Position:=1;
    for y:=0 to ImageOriginal.Height-1 do
    begin
      for x:=0 to ImageOriginal.Width-1 do
      begin
        bitmapR[x,y] := GetRValue(ImageOriginal.Canvas.Pixels[x,y]);
        bitmapG[x,y] := GetGValue(ImageOriginal.Canvas.Pixels[x,y]);
        bitmapB[x,y] := GetBValue(ImageOriginal.Canvas.Pixels[x,y]);
      end;
    end;
  end;
end;

procedure TFormUtama.TrackBarSkalaChange(Sender: TObject);
begin
  LabelSkala.Caption:=FloatToStr((TrackBarSkala.Position/10));
end;

procedure TFormUtama.ButtonReplikasiClick(Sender: TObject);
var
  i, j, x, y : integer;
  skala : double;
begin
  skala := TrackBarSkala.Position / 10;

  for y:=0 to round((ImageOriginal.Height-1)*skala) do
  begin
    for x:=0 to round((ImageOriginal.Width-1)*skala) do
    begin
    end;
  end;

  //penskalaan
  for y:=0 to ImageOriginal.Height-1 do
  begin
    for x:=0 to ImageOriginal.Width-1 do
    begin
      hasilR[round(x*skala),round(y*skala)] := bitmapR[x,y];
      hasilG[round(x*skala),round(y*skala)] := bitmapG[x,y];
      hasilB[round(x*skala),round(y*skala)] := bitmapB[x,y];
    end;
  end;

    //REPLIKASI
    for y :=0 to ImageOriginal.Width-1 do
    begin
      for x :=0 to ImageOriginal.Width-1 do
      begin
        for j:=1 to round(skala) do
        begin
          for i:=1 to round(skala) do
          begin
            hasilR[round(x*skala)+i, round(y*skala)+j] := bitmapR[x,y];
            hasilG[round(x*skala)+i, round(y*skala)+j] := bitmapG[x,y];
            hasilB[round(x*skala)+i, round(y*skala)+j] := bitmapB[x,y];
          end;
        end;
      end;
    end;

  //hasil
  for y:=0 to round((ImageOriginal.Height-1)*skala) do
  begin
    for x:=0 to round((ImageOriginal.Width-1)*skala) do
    begin
      ImageReplikasi.Canvas.Pixels[x,y] := RGB(hasilR[x,y], hasilG[x,y], hasilB[x,y]);
    end;
  end;
end;

procedure TFormUtama.ButtonSaveClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    ImageReplikasi.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TFormUtama.ButtonCloseClick(Sender: TObject);
begin

end;
end.

