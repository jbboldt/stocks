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
I = calGetYahoo(I,'^IXIC',floor(now)-nY*365,floor(now),'d');
I = calGetYahoo(I,'^NDX',floor(now)-nY*365,floor(now),'d');
I = calGetYahoo(I,'^GSPC',floor(now)-nY*365,floor(now),'d');
I(end).name = 'S''n''P';
I = calGetYahoo(I,'^DJI',floor(now)-nY*365,floor(now),'d');
I = calGetYahoo(I,'^GDAXI',floor(now)-nY*365,floor(now),'d');
%I = calGetYahoo(I,'OMXC20.CO',floor(now)-nY*365,floor(now),'d');
I = calGetYahoo(I,'OMXC20',floor(now)-nY*365,floor(now),'d','quandl');
I = calGetYahoo(I,'OMXC20largeCap',floor(now)-nY*365,floor(now),'d','quandl');
I = calGetYahoo(I,'OMXC20midCap',floor(now)-nY*365,floor(now),'d','quandl');
I = calGetYahoo(I,'OMXC20smallCap',floor(now)-nY*365,floor(now),'d','quandl');
I = calGetYahoo(I,'OMXC20PI',floor(now)-nY*365,floor(now),'d','quandl');
I = calGetYahoo(I,'^FTSE',floor(now)-nY*365,floor(now),'d');
I = calGetYahoo(I,'^N100',floor(now)-nY*365,floor(now),'d');
I = calGetYahoo(I,'^N225',floor(now)-nY*365,floor(now),'d');
%I = calGetYahoo(I,'000300.SS',floor(now)-nY*365,floor(now),'d');
I = calGetYahoo(I,'^FCHI',floor(now)-nY*365,floor(now),'d');
I = calGetYahoo(I,'^IBEX',floor(now)-nY*365,floor(now),'d');

%%
makeIndexHtml(I,targetDir);
close all




