unit Utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs, ComCtrls;

type

  { TFormUtama }

  TFormUtama = class(TForm)
    ButtonBlending: TButton;
    ButtonLoadImage2: TButton;
    ButtonClose: TButton;
    ButtonSave: TButton;
    ButtonLoadImage1: TButton;
    ImageOriginal2: TImage;
    ImageBlending: TImage;
    ImageOriginal1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    procedure ButtonLoadImage1Click(Sender: TObject);
    procedure ButtonLoadImage2Click(Sender: TObject);
    procedure ButtonBlendingClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
  private

  public

  end;

var
  FormUtama: TFormUtama;

implementation

{$R *.lfm}

{ TFormUtama }
uses windows, math;
//deklarasi variabel global
var
  bitmapR1, bitmapG1, bitmapB1, BitmapGray1, BitmapBiner1 : array[0..1000, 0..1000] of integer;
  bitmapR2, bitmapG2, bitmapB2, BitmapGray2, BitmapBiner2 : array[0..1000, 0..1000] of integer;
  hasilR, hasilG, hasilB, hasilGray, hasilBiner : array[0..1000, 0..1000] of integer;

procedure TFormUtama.ButtonLoadImage1Click(Sender: TObject);
var
  x, y, R, G, B, gray : integer;
begin
  if (OpenPictureDialog1.Execute) then
  begin
    ImageOriginal1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end;
  ImageOriginal2.Width:=ImageOriginal1.Width;
  ImageOriginal2.Height:=ImageOriginal1.Height;
  ImageOriginal2.Top:=ImageOriginal1.Top;
  ImageOriginal2.Left:=ImageOriginal1.Left + 10 + ImageOriginal1.Width;
  ImageBlending.Width:=ImageOriginal1.Width;
  ImageBlending.Height:=ImageOriginal1.Height;
  ImageBlending.Top:=ImageOriginal1.Top;
  ImageBlending.Left:=ImageOriginal1.Left + 2*(10 + ImageOriginal1.Width);
  for y:=0 to ImageOriginal1.Height-1 do
  begin
    for x:=0 to ImageOriginal1.Width-1 do
    begin
      R := GetRValue(ImageOriginal1.Canvas.Pixels[x,y]);
      G := GetGValue(ImageOriginal1.Canvas.Pixels[x,y]);
      B := GetBValue(ImageOriginal1.Canvas.Pixels[x,y]);
      gray := (R + G + B) div 3;
      bitmapR1[x,y] := R;
      bitmapG1[x,y] := G;
      bitmapB1[x,y] := B;
      bitmapGray1[x,y] := gray;

      if gray>127 then
        BitmapBiner1[x,y]  := 1
      else
        BitmapBiner1[x,y]  := 0;
    end;
  end;
end;

procedure TFormUtama.ButtonLoadImage2Click(Sender: TObject);
var
  x, y, R, G, B, gray : integer;
begin
  if (OpenPictureDialog1.Execute) then
  begin
    ImageOriginal2.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  end;
  for y:=0 to ImageOriginal2.Height-1 do
  begin
    for x:=0 to ImageOriginal2.Width-1 do
    begin
      //mengambil nilai RGB
      R := GetRValue(ImageOriginal2.Canvas.Pixels[x,y]);
      G := GetGValue(ImageOriginal2.Canvas.Pixels[x,y]);
      B := GetBValue(ImageOriginal2.Canvas.Pixels[x,y]);
      gray := (R + G + B) div 3;
      bitmapR2[x,y] := R;
      bitmapG2[x,y] := G;
      bitmapB2[x,y] := B;
      bitmapGray2[x,y] := gray;
      if gray>127 then
        BitmapBiner2[x,y] := 1
      else
        BitmapBiner2[x,y] := 0;
    end;
  end;
end;

procedure TFormUtama.ButtonBlendingClick(Sender: TObject);
var
  bitR, bitG, bitB : integer;
  temp : Double;
  x, y, R, G, B, gray : integer;
  P : Double;
begin
  P := 50/100;
  for y:=0 to ImageOriginal1.Height-1 do
  begin
    for x:=0 to ImageOriginal1.Width-1 do
    begin
      hasilR[x,y] := Round(P*(bitmapR1[x,y] + (1-P)*bitmapR2[x,y]));
      hasilG[x,y] := Round(P*(bitmapG1[x,y] + (1-P)*bitmapG2[x,y]));
      hasilB[x,y] := Round(P*(bitmapB1[x,y] + (1-P)*bitmapB2[x,y]));
      ImageBlending.Canvas.Pixels[x,y]:= RGB(hasilR[x,y], hasilG[x,y], hasilB[x,y]);
    end;
  end;
end;

procedure TFormUtama.ButtonCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFormUtama.ButtonSaveClick(Sender: TObject);
begin
  if (SavePictureDialog1.Execute) then
  begin
    ImageBlending.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

end.

