function C = getEOD(ticker);

cMonth = month(today) - 1;
cDay = day(today);
cYear = year(today);

url = ['http://eodhistoricaldata.com/api/table.csv?s=', ...
    ticker, ...
    '&api_token=5980f5f8e649b&a=0&b=1&c=2010', ...
    sprintf('&d=%d&e=%dC&f=%d&g=d', cMonth, cDay, cYear ) ];


[s,status] = urlread(url,'Timeout',60);
C = textscan(s, '%s%f%f%f%f%f%f', 'HeaderLines', 1, 'delimiter', ',', 'CollectOutput', 0);

for c = 1:7
    C{c} = flipud(C{c}(1:end));
end

C{1} = C{1}(2:end);