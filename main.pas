unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, RichMemo,
  ExtendedTabControls, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ExtendedTabControl1: TExtendedTabControl;
    ExtendedTabToolbar1: TExtendedTabToolbar;
    RichMemo1: TRichMemo; // Left text
    RichMemo2: TRichMemo; // Right text
    procedure Button1Click(Sender: TObject);
    procedure ExtendedTabControl1Change(Sender: TObject);
    procedure RichMemo1Change(Sender: TObject);
    procedure RichMemo1KeyPress(Sender: TObject; var Key: char);
    procedure RichMemo2Change(Sender: TObject);
    procedure RichMemo2KeyPress(Sender: TObject; var Key: char);
  private
    Buffer1, Buffer2: TStringList; // Buffers to store original text
    procedure GenerateDiff;
    procedure HighlightText(Memo: TRichMemo; StartPos, Length: Integer; AColor: TColor);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

// Constructor: Initialize buffers
constructor TForm1.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Buffer1 := TStringList.Create;
  Buffer2 := TStringList.Create;
end;

// Destructor: Free buffers
destructor TForm1.Destroy;
begin
  Buffer1.Free;
  Buffer2.Free;
  inherited Destroy;
end;

// Triggered when RichMemo1 text changes
procedure TForm1.RichMemo1Change(Sender: TObject);
begin
  Buffer1.Text := RichMemo1.Lines.Text; // Update buffer
  GenerateDiff;
end;

procedure TForm1.RichMemo1KeyPress(Sender: TObject; var Key: char);
begin
  //Buffer1.Text := RichMemo1.Lines.Text; // Update buffer
  //GenerateDiff;
end;

// Triggered when RichMemo2 text changes
procedure TForm1.RichMemo2Change(Sender: TObject);
begin
  Buffer2.Text := RichMemo2.Lines.Text; // Update buffer
  GenerateDiff;
end;

procedure TForm1.RichMemo2KeyPress(Sender: TObject; var Key: char);
begin
  //Buffer2.Text := RichMemo2.Lines.Text; // Update buffer
  //             GenerateDiff;
end;

// Highlights a specific range of text in the given RichMemo
procedure TForm1.HighlightText(Memo: TRichMemo; StartPos, Length: Integer; AColor: TColor);
begin
  Memo.SelStart := StartPos;
  Memo.SelLength := Length;
  Memo.SetRangeColor(StartPos, StartPos + Length, AColor);
end;

// Diff algorithm and coloring logic
procedure TForm1.GenerateDiff;
var
  i, MaxLines, Pos1, Pos2: Integer;
begin
  RichMemo1.Lines.BeginUpdate;
  RichMemo2.Lines.BeginUpdate;
  try
    // Clear existing formatting
    RichMemo1.SetRangeColor(0, Length(RichMemo1.Text), clBlack);
    RichMemo2.SetRangeColor(0, Length(RichMemo2.Text), clBlack);

    MaxLines := Max(Buffer1.Count, Buffer2.Count);

    Pos1 := 0;
    Pos2 := 0;

    for i := 0 to MaxLines - 1 do
    begin
      if (i < Buffer1.Count) and (i < Buffer2.Count) then
      begin
        if Buffer1[i] <> Buffer2[i] then
        begin
          // Highlight differences in both memos
          HighlightText(RichMemo1, Pos1, Length(Buffer1[i]), clRed);
          HighlightText(RichMemo2, Pos2, Length(Buffer2[i]), clRed);
        end;
        Pos1 := Pos1 + Length(Buffer1[i]) + 2; // Account for line breaks
        Pos2 := Pos2 + Length(Buffer2[i]) + 2;
      end
      else if i < Buffer1.Count then
      begin
        // Highlight extra lines in RichMemo1
        HighlightText(RichMemo1, Pos1, Length(Buffer1[i]), clBlue);
        Pos1 := Pos1 + Length(Buffer1[i]) + 2;
      end
      else
      begin
        // Highlight extra lines in RichMemo2
        HighlightText(RichMemo2, Pos2, Length(Buffer2[i]), clBlue);
        Pos2 := Pos2 + Length(Buffer2[i]) + 2;
      end;
    end;

  finally
    RichMemo1.Lines.EndUpdate;
    RichMemo2.Lines.EndUpdate;
  end;
end;

// Placeholder for ExtendedTabControl1Change; no current functionality
procedure TForm1.ExtendedTabControl1Change(Sender: TObject);
begin
  // This can be implemented later as needed
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   Buffer2.Text := RichMemo2.Lines.Text;
     Buffer1.Text := RichMemo1.Lines.Text; // Update buffer
  GenerateDiff;
end;

end.

