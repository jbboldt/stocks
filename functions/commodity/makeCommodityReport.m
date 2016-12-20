clear 
clc
Quandl.auth('DoRpQ551ou195t45ovsz');

%block = urlread('https://www.quandl.com/api/v1/datasets/FRED/GDP.csv?auth_token=DoRpQ551ou195t45ovsz');

targetDir = 'reports/comReport';
if isdir(targetDir)
    [s,m,mi]=rmdir( targetDir, 's' );
end
mkdir( targetDir );

tS = 300;
opt.targetDir = targetDir;

tempFile = [targetDir,'/index.html'];
fH = fopen(tempFile,'w');
fprintf( fH, '<h1>%s</h1>', datestr( now ) );

% Gold
% data = Quandl.get('OFDP/GOLD_2');
% S(1).sdn = data.USD.Time+datenum(data.USD.TimeInfo.StartDate);
% S(1).data = data.USD.Data;
% opt.title = ['Gold USD'];
% fn = makeInvestPlot(S,tS,opt);
% htmlAddFigure(fH,fn);

data = Quandl.get('BUNDESBANK/BBK01_WT5511')
S(1).sdn = data.Time+datenum(data.TimeInfo.StartDate);
S(1).data = data.Data;
opt.title = ['Gold USD'];
fn = makeInvestPlot(S,tS,opt);
htmlAddFigure(fH,fn);

%Oil
data = Quandl.get('GOOG/LON_OILB');
D = data.get;
S(2).sdn = D.Time+datenum(D.TimeInfo.StartDate);
S(2).data = D.Close.Data;
opt.title = ['Brent Oil'];
fn = makeInvestPlot(S(2),tS,opt);
htmlAddFigure(fH,fn);

fprintf( fH, '<h1>Long Term</h1>', datestr( now ) );

tS = 200*10;
opt.title = ['Gold USD'];
fn = makeInvestPlot(S(1),tS,opt);
htmlAddFigure(fH,fn);

opt.title = ['Brent Oil'];
fn = makeInvestPlot(S(2),tS,opt);
htmlAddFigure(fH,fn);

fclose(fH);
