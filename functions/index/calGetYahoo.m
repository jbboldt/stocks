function So = calGetYahoo(Si,ticker,d1,d2,freq,method)

if nargin < 6
  method = 'm1';
end

if nargin < 5
  freq = 'd';
end

idx = length(Si)+1;
So=Si;

switch method
  case 'm1'
    try
      St = download_hist_yahoo_data(ticker,d1,d2);
      St.ticker = ticker;
      St.name = getLongName(ticker);
      St.shortName = getShortName(ticker);
      
      So = [Si,St];
    catch err
      disp(err)
    end
    
  case 'm2'
    try
      S = get_yahoo_stockdata2(ticker,d1,d2,freq);
      St.name = S.Name;
      St.ticker = S.Ticker;
      St.sdn = S.DNum;
      St.open = S.Open;
      St.high = S.High;
      St.low = S.Low;
      St.close = S.Close;
      St.volume = S.Volume;
      St.adj_close = S.AdjClose;
      
      St.shortName = getShortName(ticker);
      
      So = [Si,St];
    catch err
      disp(err)
    end
    
  case 'quandl'
    try
      Quandl.auth('DoRpQ551ou195t45ovsz');
      
      if strcmp(ticker,'^DJI')
        data = Quandl.get('BCB/UDJIAD1');
        St.sdn = datenum(data.TimeInfo.StartDate)+data.Time;
        St.close = data.Data;
      elseif strcmp(ticker,'OMXC20')
        data = Quandl.get('NASDAQOMX/OMXC20CAP');
        St.sdn = datenum(data.IndexValue.TimeInfo.StartDate)+data.IndexValue.Time;
        St.close = data.IndexValue.Data;
      elseif strcmp(ticker,'OMXC20smallCap')
        data = Quandl.get('NASDAQOMX/OMXCSCPI');
        St.sdn = datenum(data.IndexValue.TimeInfo.StartDate)+data.IndexValue.Time;
        St.close = data.IndexValue.Data;
      elseif strcmp(ticker,'OMXC20midCap')
        data = Quandl.get('NASDAQOMX/OMXCMCPI');
        St.sdn = datenum(data.IndexValue.TimeInfo.StartDate)+data.IndexValue.Time;
        St.close = data.IndexValue.Data;
      elseif strcmp(ticker,'OMXC20largeCap')
        data = Quandl.get('NASDAQOMX/OMXCLCPI');
        St.sdn = datenum(data.IndexValue.TimeInfo.StartDate)+data.IndexValue.Time;
        St.close = data.IndexValue.Data;
      elseif strcmp(ticker,'OMXC20PI')
        data = Quandl.get('NASDAQOMX/OMXCPI');
        St.sdn = datenum(data.IndexValue.TimeInfo.StartDate)+data.IndexValue.Time;
        St.close = data.IndexValue.Data;
      end
      
      St.name = getLongName(ticker);
      St.shortName = getShortName(ticker);
      
      St.ticker = ticker;
      St.open = [];
      St.high = [];
      St.low = [];
      St.volume = [];
      St.adj_close = [];
      
      So = [Si,St];
    catch err
      disp(err)
    end
end


function sName = getShortName(ticker)

sName = strrep(strrep(strrep(ticker,' ',''),'&amp;','n'),'^','');

function lName = getLongName(ticker)

switch ticker
  case '^IXIC'
    lName = 'NASDAQ Composite';
  case '^NDX'
    lName = 'NASDAQ 100';
  case '000300.SS'
    lName = 'Shanghai Shenzhen CSI 300 Index';
  case '^GDAXI'
    lName = 'DAX - Germany';
  case '^FTSE'
    lName = 'FTSE 100 - London';
  case 'OMXC20.CO'
    lName = 'C20';
  case '^N100'
    lName = 'EURONEXT 100';
  case '^FCHI'
    lName = 'CAC 40 - France';
  case '^IBEX'
    lName = 'IBEX 35 - Spain';
  case '^N225'
    lName = 'Nikkei 225';
  case '^DJI'
    lName = 'Dow Jones Industrial Average';
  otherwise
    lName = ticker;
end
