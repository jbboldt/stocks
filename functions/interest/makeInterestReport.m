clear 
clc
Quandl.auth('DoRpQ551ou195t45ovsz');

targetDir = 'reports/interestReport';
if isdir(targetDir)
    [s,m,mi]=rmdir( targetDir, 's' );
end
mkdir( targetDir );

tS = 300;
opt.targetDir = targetDir;

tempFile = [targetDir,'/index.html'];
fH = fopen(tempFile,'w');
fprintf( fH, '<h1>%s</h1>', datestr( now ) );

% 10-Year Treasury Constant Maturity Rate
data = Quandl.get('FRED/DGS10');
S(1).sdn = data.Time+datenum(data.TimeInfo.StartDate);
S(1).data = data.Data;
opt.title = ['10-Year Treasury Constant Maturity Rate'];
fn = makeInvestPlot(S,tS,opt);
htmlAddFigure(fH,fn);

fprintf( fH, '<h1>Long Term</h1>', datestr( now ) );

tS = 300*10;
opt.title = ['10-Year Treasury Constant Maturity Rate'];
fn = makeInvestPlot(S(1),tS,opt);
htmlAddFigure(fH,fn);
fclose(fH);
close all

%%





