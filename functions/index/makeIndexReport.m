clear
clc
fclose all;

targetDir = 'reports/idxReport';
if isdir( targetDir )
    [s,m,mi]=rmdir( targetDir, 's' );
end
mkdir( targetDir );

nY=5;

%%
I=[];
% I = calGetYahoo(I,'^IXIC',floor(now)-nY*365,floor(now),'d');
% I = calGetYahoo(I,'^NDX',floor(now)-nY*365,floor(now),'d');
% I = calGetYahoo(I,'^GSPC',floor(now)-nY*365,floor(now),'d');
% I(end).name = 'S''n''P';
% I = calGetYahoo(I,'^DJI',floor(now)-nY*365,floor(now),'d');
% I = calGetYahoo(I,'^GDAXI',floor(now)-nY*365,floor(now),'d');
% %I = calGetYahoo(I,'OMXC20.CO',floor(now)-nY*365,floor(now),'d');
% I = calGetYahoo(I,'OMXC20',floor(now)-nY*365,floor(now),'d','quandl');
% I = calGetYahoo(I,'OMXC20largeCap',floor(now)-nY*365,floor(now),'d','quandl');
% I = calGetYahoo(I,'OMXC20midCap',floor(now)-nY*365,floor(now),'d','quandl');
% I = calGetYahoo(I,'OMXC20smallCap',floor(now)-nY*365,floor(now),'d','quandl');
% I = calGetYahoo(I,'OMXC20PI',floor(now)-nY*365,floor(now),'d','quandl');
% I = calGetYahoo(I,'^FTSE',floor(now)-nY*365,floor(now),'d');
% I = calGetYahoo(I,'^N100',floor(now)-nY*365,floor(now),'d');
% I = calGetYahoo(I,'^N225',floor(now)-nY*365,floor(now),'d');
% %I = calGetYahoo(I,'000300.SS',floor(now)-nY*365,floor(now),'d');
% I = calGetYahoo(I,'^FCHI',floor(now)-nY*365,floor(now),'d');
% I = calGetYahoo(I,'^IBEX',floor(now)-nY*365,floor(now),'d');

clear S

idx = 1;
S(idx).name = 'NASDAQ';
S(idx).symbol = 'IXIC.INDX';
idx = idx + 1;
S(idx).name = 'Dow Jones';
S(idx).symbol = 'DJI.INDX';
idx = idx + 1;
S(idx).name = 'DAX';
S(idx).symbol = 'GDAXI.INDX';

idx = idx + 1;
S(idx).name = 'OMX 20CAP';
S(idx).symbol = 'OMXC20CAP.INDX';
idx = idx + 1;
S(idx).name = 'OMX Large Cap';
S(idx).symbol = 'OMXCLCPI.INDX';
idx = idx + 1;
S(idx).name = 'OMX Mid Cap';
S(idx).symbol = 'OMXCMCPI.INDX';
idx = idx + 1;
S(idx).name = 'OMX Small Cap';
S(idx).symbol = 'OMXCSCPI.INDX';



idxHist = [];
for cS = 1 : length( S )
 
  fprintf( 'Fetching: %s\n', S(cS).name );
  idxHist = getStockHistory([],idxHist,S(cS),'01-jan-2000',date);

end

%save('indexData','I');
%%
makeIndexHtml(idxHist,targetDir);
close all




