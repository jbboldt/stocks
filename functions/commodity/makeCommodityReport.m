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
data = Quandl.get('OFDP/GOLD_2');
S(1).sdn = data.USD.Time+datenum(data.USD.TimeInfo.StartDate);
S(1).data = data.USD.Data;
opt.title = ['Gold USD'];
fn = makeInvestPlot(S,tS,opt);
htmlAddFigure(fH,fn);

%Oil
data = Quandl.get('OFDP/FUTURE_B1');
S(2).sdn = data.Settle.Time+datenum(data.Settle.TimeInfo.StartDate);
S(2).data = data.Settle.Data;
opt.title = ['Brent Oil'];
fn = makeInvestPlot(S(2),tS,opt);
htmlAddFigure(fH,fn);

fprintf( fH, '<h1>Long Term</h1>', datestr( now ) );

tS = 300*10;
opt.title = ['Gold USD'];
fn = makeInvestPlot(S(1),tS,opt);
htmlAddFigure(fH,fn);

opt.title = ['Brent Oil'];
fn = makeInvestPlot(S(2),tS,opt);
htmlAddFigure(fH,fn);

fclose(fH);
