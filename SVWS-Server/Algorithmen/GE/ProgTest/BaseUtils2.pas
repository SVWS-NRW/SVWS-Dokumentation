unit BaseUtils2;
(*------------------------------------------------------------------------------*)
interface
(*------------------------------------------------------------------------------*)
uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.Types;

const
  SLD: String= ' — ';

function  NCountOf(const C: String; S : String): Integer;
function  IstEnthalten(Sub, S: String; CS: Boolean = False; Del: Char = ' '): Boolean;
function  Before(const SubStr, S : String; CS: Boolean= True): String;
function  After(const SubStr, S : String; CS: Boolean= True): String;
function  NBetween(N: Integer;const D: String; S : String): String;
function  S_EndStr(const ZS, QS: String; TrimAll: Boolean): String;
function  S_StartStr(const ZS, QS: String; TrimAll: Boolean): String;
function  S_DelStr(const ZS, QS: String; TrimAll: Boolean): String;
procedure Explode2StringList(const D,FB: String; S: String; slExplodeItems: tStringlist);
function  ImplodeStringList2String(const D: String; slExplodeItems: tStringlist): String;
function  GetDelimiter(const Z: String): Char;
function  SConcat(S1,S2: String; const C: String; TrimAll: Boolean; NurWennS2NichtBereitsEnthalten: Boolean = False): String;
function  SystemDate: String;
function  SystemTime(Kurz: Boolean = False): String;
function  Space(x: Integer): String;
function  Upper(const S: String): String;
function  IIF(Expression : Boolean; const IfTrue, IfFalse : String): String;
function  IntegerVal(const sNumber: String; Default: Int64= 0) : Int64;
function  SInteger(I : Int64) : String;
function  SLIndexOf(K: String; Liste: tStringList; N: Integer = 1; CS: Boolean = False): Integer;

implementation
(*------------------------------------------------------------------------------*)
function CountOf(C,S : String) : Integer;
{ returns the number of occurances of character or String "C" in String "S" }
var
  Zaehler, Len, LenC, I : Integer;
begin
  CountOf := 0;
  Len  := Length(S);
  LenC := Length(C);
  if (Len > 0) and (LenC > 0) then
    begin
      Zaehler := 0;
      if LenC = 1 then   { fast way for chars }
        begin
          for I := 1 to Len do
            if S[I] = c then
              Inc(Zaehler);
        end
      else
        begin          { if we have strings to look for }
          while pos(c,s) > 0 do
            begin
              Inc(Zaehler);
              Delete(s,1,pos(c,s)+lenC-1);
            end;
        end;
      CountOf := Zaehler;
    end;
end;
(*------------------------------------------------------------------------------*)
function NCountOf(const C: String; S : String) : Integer;
begin
  S:= S_EndStr(C,S,False);
  Result:= CountOf(C,S);
end;
(*------------------------------------------------------------------------------*)
function PosCS(const Sub, S : String; CS: Boolean= True) : Integer;
begin
  if CS
    then Result:= Pos(Sub, S)
    else Result:= Pos(Upper(Sub), Upper(S));
end;
(*------------------------------------------------------------------------------*)
function IstEnthalten(Sub, S: String; CS: Boolean = False; Del: Char = ' '): Boolean;
begin
  if Del = ' ' then Del:= GetDelimiter(S);
  Sub:= Del + Sub + Del;
  S  := Del + S   + Del;
  Result:= PosCS(Sub, S, CS) > 0;
end;
(*------------------------------------------------------------------------------*)
function Before(const SubStr, S : String; CS: Boolean= True) : String;
var
  I : Integer;
begin
  I:= PosCS(SubStr, S, CS);
  if I > 0
    then Result:= Copy(S, 1, i-1)
    else Result:= '';
end;
(*------------------------------------------------------------------------------*)
function After(const SubStr, S : String; CS: Boolean= True) : String;
var
  I : Integer;
begin
  I:= PosCS(SubStr, S, CS);
  if I > 0
    then Result:= Copy(s, I+Length(SubStr), MaxInt)
    else Result:= '';
end;
(*------------------------------------------------------------------------------*)
function Between(const SubStr1, SubStr2: String; S : String; CS: Boolean= True): String;
var
  I, J : Integer;
begin
  Result:= '';
  I := PosCS(SubStr1, S, CS);
  if I <> 0 then
    begin
      I := I + Length(SubStr1);
      S:= copy(S, I, Length(S));
      J := PosCS(SubStr2, S, CS);
      if (J <> 0) then Result:= Copy(S, 1, J-1);
    end;
end;
(*------------------------------------------------------------------------------*)
function NBetween(N: Integer;const D: String; S : String): String;
var
  I: Integer;
begin
  Result:= '';
  if (Trim(D)='') or (Trim(S)='') or (N=0) then Exit;
  if Pos(D,S)=0 then S:= S + D;
  if copy(S,Length(S)-Length(D)+1,Length(D)) <> D then S:= S + D;
  I:= 0;
  while (Pos(D,S)>0) and (I<N) do
    begin
      Result:= Before(D,S);
      S:= After(D,S);
      Inc(I);
    end;
  if I < N then Result:= '';
end;
(*------------------------------------------------------------------------------*)
function S_EndStr(const ZS, QS: String; TrimAll: Boolean): String;
// fügt an QS den String ZS falls QS nicht bereits hierauf endet
begin
  if TrimAll then Result:= Trim(QS) else Result:= QS;
  if not EndsStr(ZS,Result) then Result:= Result + ZS;
end;
(*------------------------------------------------------------------------------*)
function S_StartStr(const ZS, QS: String; TrimAll: Boolean): String;
// fügt ZS an den Beginn von QS den String ZS falls QS nicht bereits hiermit beginnt
begin
  if TrimAll then Result:= Trim(QS) else Result:= QS;
  if not StartsStr(ZS,Result) then Result:= ZS + Result;
end;
(*------------------------------------------------------------------------------*)
function S_DelStr(const ZS, QS: String; TrimAll: Boolean): String;
// löscht ZS am Ende von QS, falls ZS hierauf endet
begin
  if TrimAll then Result:= Trim(QS) else Result:= QS;
  if EndsStr(ZS+'~',Result+'~') then Result:= Before(ZS+'~',Result+'~');
end;
(*------------------------------------------------------------------------------*)
function SReplace(const S,D, Line: String): String;
begin
  Result:= StringReplace(Line, S, D, [rfReplaceAll,rfIgnoreCase])
end;
(*------------------------------------------------------------------------------*)
function SNReplace(N: Integer; S,D: Char; Line: String): String;
var
  I, J: Integer;
begin
  J:= 0;
  for I := 1 to Length(Line) do
    if Line[I] = S then
      begin
        Inc(J,1);
        if J = N then
          begin
            Line[I]:= D;
            J:= 0;
          end;
      end;
  Result:= Line;
end;
(*------------------------------------------------------------------------------*)
procedure SReplaceP(const S,D: String; var Line: String);
begin
  Line:= SReplace(S,D,Line);
end;
(*------------------------------------------------------------------------------*)
function GetDelimiter(const Z: String): Char;
// bestimmt in einem String den Delimiter - getestet wird auf: ',', ';', '|', #9
// ansonsten wird ein Leerzeichen zurückgegeben
var
  Max, M: Integer;
(* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  *)
procedure Test(D: Char);
begin
  M:= Countof(D,Z);
  if M > Max then
    begin
      Max   := M;
      Result:= D;
    end;
end;
(* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  *)
begin
  Max:= -1;
  Result:= ' ';
  Test(';');
  Test(',');
  Test('|');
  Test(#9);
end;
(*------------------------------------------------------------------------------*)
procedure Explode2StringList(const D,FB: String; S: String; slExplodeItems: tStringlist);
// überführt einen String S in eine stringlist die zuvor erzeugt worden sein muss
// D ist der Delimiter FB ist der Feldbegrenzer
// Bsp.: S= "item1";"item2";  -- D=';', FB= '"'
var
  Item: String;
begin
  slExplodeItems.Clear;
  if S = '' then Exit;
  if D = '' then Exit;
  if Pos(D,S) = 0 then S:= S + D;
  repeat
    Item:= '';
    if ((FB <> '') and (pos(FB,S)=1))
      then
        begin
          Item:= Between(FB,FB,S);
          S:= After(Item,S);
        end
      else Item:= Before(D,S);
    slExplodeItems.Add(Item);
    S:= After(D,S);
    if (S<>'') and (Pos(D,S)=0) then
      begin
        slExplodeItems.Add(S);
        S:= '';
      end;
  until S = '';
end;
(*------------------------------------------------------------------------------*)
function ImplodeStringList2String(const D: String; slExplodeItems: tStringlist): String;
var
  N: Integer;
begin
  Result:= '';
  if D = '' then Exit;
  for N := 0 to slExplodeItems.Count - 1 do
    begin
      Result:= Result + slExplodeItems[N];
      if N < slExplodeItems.Count - 1 then Result:= Result + D;
    end;
end;
(*------------------------------------------------------------------------------*)
function SConcat(S1,S2: String; const C: String; TrimAll: Boolean; NurWennS2NichtBereitsEnthalten: Boolean = False): String;
// verbindet die beiden strings und fügt falls s1<>'' dazwischen c ein
begin
  if TrimAll then
    begin
      S1:= Trim(S1);
      S2:= Trim(S2);
    end;
  if (S1 <> '') and (S2 <> '') then
    begin
      if NurWennS2NichtBereitsEnthalten then
        begin
          if IstEnthalten(S2,S1) then
            begin
              Result:= S1;
              Exit;
            end;
        end;
      S1:= S1+C;
    end;
  Result:= S1+S2;
end;
(*------------------------------------------------------------------------------*)
function SystemDate: String;
begin
  Result:= DateToStr(NOW);
end;
(*------------------------------------------------------------------------------*)
function SystemTime(Kurz: Boolean = False): String;
begin
  if Kurz
    then Result:= FormatDateTime('hh:mm',NOW)
    else Result:= TimeToStr(NOW);
end;
(*------------------------------------------------------------------------------*)
function Space(x: Integer): String;
var
  res: string;
begin
 if x > 0 then FmtStr(res, '%*s', [x, '']) else res := '';
 Result := res;
end;
(*------------------------------------------------------------------------------*)
function Upper(const S: String): String;
begin
  Result := AnsiUpperCase(S);
end;
(*------------------------------------------------------------------------------*)
function Lower(const S: String): String;
begin
  Result := AnsiLowerCase(S);
end;
(*------------------------------------------------------------------------------*)
function IIF(Expression : Boolean; const IfTrue, IfFalse : String) : String;
begin
  if Expression
    then Result := IfTrue
    else Result := IfFalse;
end;
(*------------------------------------------------------------------------------*)
function IntegerVal(const sNumber: String; Default: Int64= 0) : Int64;
begin
  Result:= System.SysUtils.StrToInt64Def(sNumber,Default);
end;
(*------------------------------------------------------------------------------*)
function SInteger(I : Int64) : String;
begin
  Result:= System.SysUtils.IntToStr (I);
end;
(*------------------------------------------------------------------------------*)
function SLIndexOf(K: String; Liste: tStringList; N: Integer = 1; CS: Boolean = False): Integer;
// überprüft ob K gleich der n-ten Spalte eines Listeneintrages der Liste ist
// List.Item kann aus mehreren Saplten mit dem Delimiter SLD bestehen
// Rückgabe: gefundener Listenindex (bzw. -1 wenn nicht gefunden)
var
  I   : Integer;
  Item: String;
begin
  Result:= -1;
  K:= Trim(K);
  if not CS then K:= Upper(K);
  if (K = '') or (not Assigned(Liste)) then Exit;
  with Liste do
    for I:= 0 to Count-1 do
      begin
        if N = 0 then Item:= Strings[I];
        if N = 1 then
          begin
            if Pos(SLD,Strings[I]) > 0
              then Item:= Before(SLD,Strings[I])
              else Item:= Strings[I];
          end;
        if N > 1 then Item:= NBetween(N,SLD,Strings[I]);
        Item:= Trim(Item);
        if not CS then Item:= Upper(Item);
        if(K = Item) then
          begin
            Result:= I;
            Break;
          end;
        end;
end;
end.
