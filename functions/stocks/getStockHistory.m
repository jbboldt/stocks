function So = getStockHistory(conn,Si,S,startDate,endDate)

if 0 
    %day = download_hist_yahoo_data( stockSymbol, startDate, endDate );
    
    d = fetch(conn,S.symbol,{'open','high','low','close','volume','adj close'},startDate,endDate);
    d = flipud(d);
    
    day.sdn = d(:,1);
    day.open = d(:,2);
    day.high = d(:,3);
    day.low = d(:,4);
    day.close = d(:,5);
    day.volume = d(:,6);
    day.adj_close = d(:,7);
elseif 0
    c = GetHistoricGoogle(S.symbol,'01/01/2014',datestr(today,'mm/dd/yyyy'));

    day.sdn = flipud(datenum(c{1}));
    day.open = flipud(c{2});
    day.high = flipud(c{3});
    day.low = flipud(c{4});
    day.close = flipud(c{5});
    day.volume = flipud(c{6});
    day.adj_close = flipud(c{5});
else
    c = getEOD(S.symbol);

    day.sdn = datenum(c{1});
    day.open = c{2};
    day.high = c{3};
    day.low = c{4};
    day.close = c{5};
    day.volume = c{7};
    day.adj_close = c{6};
        
    idx = find(isnan(day.close));

    if length(idx)>0
        for n = length(idx):-1:1
            day.sdn(idx(n)) = [];
            day.open(idx(n)) = [];
            day.high(idx(n)) = [];
            day.low(idx(n)) = [];
            day.close(idx(n)) = [];
            day.volume(idx(n)) = [];
            day.adj_close(idx(n)) = [];
        end
    end
    
    stockHist.shortName = S.symbol;
    
end
    
if length(day.sdn) < 500
    ext = 500;
    tE = [ day.sdn(1) - ext : day.sdn(1)-1 ].';
    day.sdn = [tE;day.sdn];
    day.open = [ones(ext,1) * day.open(1);day.open];
    day.high = [ones(ext,1) * day.high(1);day.high];
    day.low = [ones(ext,1) * day.low(1);day.low];
    day.close = [ones(ext,1) * day.close(1);day.close];
    day.volume = [ones(ext,1) * day.volume(1);day.volume];
    day.adj_close = [ones(ext,1) * day.adj_close(1);day.adj_close];
end
    
    

if strcmp( S.symbol, 'NVO' )
  idx = day.sdn <= 735607;
  scaler = 5;
  day.open(idx)=day.open(idx)/scaler;
  day.high(idx)=day.high(idx)/scaler;
  day.low(idx)=day.low(idx)/scaler;
  day.close(idx)=day.close(idx)/scaler;
elseif strcmp( S.symbol, 'AAPL' ) 
  %day.close = day.adj_close;
  scaler = round(day.close./day.adj_close);
  day.open = day.open./scaler;
  day.close = day.close./scaler;
  day.high = day.high./scaler;
  day.low = day.low./scaler;
elseif strcmp( S.symbol, 'TRYG.CO' )
    idx = day.sdn <= 736100;
    scaler = 5;
    day.open(idx)=day.open(idx)/scaler;
    day.high(idx)=day.high(idx)/scaler;
    day.low(idx)=day.low(idx)/scaler;
    day.close(idx)=day.close(idx)/scaler;
elseif strcmp( S.symbol, 'WDH.CO' )
    idx = day.sdn < 736474;
    scaler = 5;
    day.open(idx)=day.open(idx)/scaler;
    day.high(idx)=day.high(idx)/scaler;
    day.low(idx)=day.low(idx)/scaler;
    day.close(idx)=day.close(idx)/scaler;
elseif strcmp( S.symbol, 'UA' )

    clear newDay
    
    cL = length(day.sdn);
    nAdd = 500;
    
    newDay.sdn(nAdd+1:nAdd+cL,1) = day.sdn;
    newDay.sdn(1:nAdd,1) = [day.sdn-nAdd+1:day.sdn(1)];
    
    newDay.open(nAdd+1:nAdd+cL,1) = day.open;
    newDay.high(nAdd+1:nAdd+cL,1) = day.high;
    newDay.low(nAdd+1:nAdd+cL,1) = day.low;
    newDay.close(nAdd+1:nAdd+cL,1) = day.close;
    newDay.volume(nAdd+1:nAdd+cL,1) = day.volume;
    newDay.adj_close(nAdd+1:nAdd+cL,1) = day.adj_close;

    newDay.open(1:nAdd,1) = day.open(1);
    newDay.high(1:nAdd,1) = day.high(1);
    newDay.low(1:nAdd,1) = day.low(1);
    newDay.close(1:nAdd,1) = day.close(1);
    newDay.volume(1:nAdd,1) = day.volume(1);
    newDay.adj_close(1:nAdd,1) = day.adj_close(1);
    
    day = newDay;   
    
end

stockHist.ticker = S.symbol;
stockHist.name = S.name;

if isfield(S,'bought')
    stockHist.bought = S.bought;
    stockHist.price = S.price;
    stockHist.stoploss = S.stoploss;
    stockHist.stoplossMax = S.stoplossMax;
end

%day.close = day.adj_close;
day.count = length( day.close );
day.idx = 1 : day.count;

%startDate = datestr( now - 365*15, 'dd-mmm-YYYY' );

yw = year( day.sdn ) * 100 + weeknum( day.sdn );

ywu = unique( yw );

for n = 1 : length( ywu )
    
    week.high( n ) = max( day.high( yw == ywu(n) ) );
    week.low( n ) = min( day.low( yw == ywu(n) ) );
    
    lcOpen = day.open( yw == ywu(n) );
    week.open( n ) = lcOpen( 1 );
    
    lcClose = day.close( yw == ywu(n) );
    week.close( n ) = lcClose( end );
    
    week.volume( n ) = sum( day.volume( yw == ywu( n ) ) );
    
    lcDates = day.sdn( yw == ywu( n ) );
    week.sdn( n ) = lcDates( 1 );
        
end

week.sdn = week.sdn.';
week.high = week.high.';
week.low = week.low.';
week.open = week.open.';
week.close = week.close.';
week.volume = week.volume.';

week.count = length( week.close );
week.idx = 1 : week.count;

stockHist.day = day;
stockHist.week = week;

if stockHist.day.sdn(end) < today-5
  warning('Data from %s is too old [%s]',S.name,datestr(day.sdn(end)));
  So = Si;
elseif length(stockHist.day.sdn) < 20
  warning('Not enough Data!');
  So = Si;
elseif length(stockHist.day.sdn) < 200
  cLength = length(stockHist.day.sdn);
  for c = 1:length(stockHist.day.sdn)
    stockHist.day.sdn(500+c)=stockHist.day.sdn(c);
    stockHist.day.open(500+c)=stockHist.day.open(c);
    stockHist.day.high(500+c)=stockHist.day.high(c);
    stockHist.day.low(500+c)=stockHist.day.low(c);
    stockHist.day.close(500+c)=stockHist.day.close(c);
    stockHist.day.volume(500+c)=stockHist.day.volume(c);
    stockHist.day.adj_close(500+c)=stockHist.day.adj_close(c);
  end
  for c = 1:500
    stockHist.day.sdn(c)=stockHist.day.sdn(501)-500+c;
    stockHist.day.open(c)=stockHist.day.open(501);
    stockHist.day.high(c)=stockHist.day.high(501);
    stockHist.day.low(c)=stockHist.day.low(501);
    stockHist.day.close(c)=stockHist.day.close(501);
    stockHist.day.volume(c)=stockHist.day.volume(501);
    stockHist.day.adj_close(c)=stockHist.day.adj_close(501);
  end
  stockHist.day.count = cLength+500;
  stockHist.day.idx = 1:(cLength+500)
  So = [Si;stockHist];
else  
  So = [Si;stockHist];
end
