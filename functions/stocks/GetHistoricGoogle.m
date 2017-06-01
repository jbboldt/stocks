function [ data ] = GetHistoricGoogle( symbol,startDate,endDate )
%   Produced by Chris Reeves (A2X Capital LLC)
%   query date ranges from google finance
%   sample usage GetHistoricGoogle('AAPL','04/27/2010','04/27/2017')
    startDateNum = datenum(startDate);
    endDateNum = datenum(endDate);

    startDateStr = datestr(startDateNum,'mmm dd, yyyy');
    endDateStr = datestr(endDateNum,'mmm dd, yyyy');

    url = strcat('http://www.google.com/finance/historical?q=',symbol,'&startdate=',startDateStr,'&enddate=',endDateStr,'&output=csv');
    url = strrep(url,' ','%20');
    url
    response = urlread(url);
    data = textscan(response,'%s %f %f %f %f %f','delimiter',',','HeaderLines',1);

end