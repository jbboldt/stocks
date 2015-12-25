clear S
idx = 1;
S(idx).name = 'ALK Abello';
S(idx).symbol = 'ALK-B.CO';
S(idx).bought = '2015-01-06';
S(idx).price = 673;
S(idx).stoploss = -5;
S(idx).stoplossMax = -5;

S(idx).name = 'Bang og Olufsen';
S(idx).symbol = 'BO.CO';
S(idx).bought = '2015-03-22';
S(idx).price = 52;
S(idx).stoploss = -9;
S(idx).stoplossMax = -10;

return

idx = 1;
S(idx).name = 'SnP 500';
S(idx).symbol = '^GSPC';
S(idx).bought = '2010-12-08';
S(idx).price = 6.31;
S(idx).stoploss = -5;

idx = idx+1;
S(idx).name = 'NASDAQ Composite';
S(idx).symbol = '^IXIC';

idx = idx + 1;
S(idx).name = 'C20';
S(idx).symbol = 'OMXC20.CO';

return

idx = idx + 1;
S(idx).name = 'C20 CAP';
S(idx).symbol = 'OMXC20CAP.CO';

% idx = idx + 1;
% S(idx).name = 'Dow Jones';
% S(idx).symbol = '^DJI';

idx = idx + 1;
S(idx).name = 'DAX';
S(idx).symbol = '^GDAXI';

idx = idx + 1;
S(idx).name = 'FTSE 100';
S(idx).symbol = '^FTSE';


idx = idx + 1;
S(idx).name = 'NASDAQ';
S(idx).symbol = '^NDX';



idx = idx + 1;
S(idx).name = 'EURONEXT100';
S(idx).symbol = '^N100';
