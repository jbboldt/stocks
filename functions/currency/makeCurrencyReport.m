clear 
clc
C=getCurrencyData;

targetDir = 'reports/curReport';
if isdir( targetDir )
    [s,m,mi]=rmdir( targetDir, 's' );
end
mkdir( targetDir );


for idx=1:length(C);
	C(idx).USDDKK = C(idx).USD^-1.*C(idx).DKK;
	C(idx).NOKDKK = C(idx).NOK^-1.*C(idx).DKK;
	C(idx).SEKDKK = C(idx).SEK^-1.*C(idx).DKK;
	C(idx).USDEUR = C(idx).USD^-1;
	C(idx).JPYEUR = C(idx).JPY^-1;
	C(idx).CNYEUR = C(idx).CNY^-1;
end

tS = 300;
opt.targetDir = targetDir;

tempFile = [targetDir,'/index.html'];
fH = fopen(tempFile,'w');
fprintf( fH, '<h1>%s</h1>', datestr( now ) );
S.sdn = [C.sdn];

S.data = [C.USDDKK];
opt.title = ['USD-DKK'];
fn = makeInvestPlot(S,tS,opt);
htmlAddFigure(fH,fn);

S.data = [C.NOKDKK];
opt.title = ['NOK-DKK'];
fn = makeInvestPlot(S,tS,opt);
htmlAddFigure(fH,fn);

S.data = [C.SEKDKK];
opt.title = ['SEK-DKK'];
fn = makeInvestPlot(S,tS,opt);
htmlAddFigure(fH,fn,1200,500);

S.data = [C.DKK];
opt.title = ['EUR-DKK'];
fn = makeInvestPlot(S,tS,opt);
htmlAddFigure(fH,fn,1200,500);

S.data = [C.USDEUR];
opt.title = ['USD-EUR'];
fn = makeInvestPlot(S,tS,opt);
htmlAddFigure(fH,fn,1200,500);

S.data = [C.JPYEUR];
opt.title = ['JPY-EUR'];
fn = makeInvestPlot(S,tS,opt);
htmlAddFigure(fH,fn,1200,500);

S.data = [C.CNYEUR];
opt.title = ['CNY-EUR'];
fn = makeInvestPlot(S,tS,opt);
htmlAddFigure(fH,fn,1200,500);

fclose(fH);
close all
