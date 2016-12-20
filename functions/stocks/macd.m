function [ trend, macdLine, signalLine, macdHist, lastSignal ] = macd( price, period ) 

[~, maLong ] = movavg( price, 1, period( 1 ), 'e' );
[~, maShort ] = movavg( price, 1, period( 2 ), 'e' );

macdLine = ( maShort - maLong ); 

[~, signalLine ] = movavg( macdLine, 1, period( 3 ), 'e' );

macdHist = macdLine - signalLine;

if  signalLine( end ) < macdLine( end ) & signalLine( end - 1 ) > macdLine( end - 1 )
    trend = 'buy';
elseif signalLine( end ) > macdLine( end ) & signalLine( end - 1 ) < macdLine( end - 1 )
    trend = 'sell';
elseif macdLine( end ) < 0 & macdLine( end - 1 ) > 0
    trend = 'bear';
elseif macdLine( end ) > 0 & macdLine( end - 1 ) < 0
    trend = 'bull';
else
    trend = '';
end

%% Find last signal
diffHist = sign(diff(sign(signalLine-macdLine)));
lsIdx = find(diffHist ~= 0);
daysAgo = length(diffHist)-lsIdx(end);

if diffHist(lsIdx(end)) == -1
    lastSignal = ['buy, ', num2str(daysAgo),' days'];
else
    lastSignal = ['sell, ', num2str(daysAgo),' days'];
end
