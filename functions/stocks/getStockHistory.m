function So = getStockHistory(conn,Si,S,startDate,endDate)

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
end

stockHist.ticker = S.symbol;
stockHist.name = S.name;

stockHist.bought = S.bought;
stockHist.price = S.price;
stockHist.stoploss = S.stoploss;
stockHist.stoplossMax = S.stoplossMax;

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
