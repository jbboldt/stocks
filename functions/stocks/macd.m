function [ trend, macdLine, signalLine, macdHist ] = macd( price, period ) 

[~, maLong ] = movavg( price, 1, period( 1 ), 'e' );
[~, maShort ] = movavg( price, 1, period( 2 ), 'e' );

macdLine = ( maShort - maLong ); 

[~, signalLine ] = movavg( macdLine, 1, period( 3 ), 'e' );

macdHist = macdLine - signalLine;

if macdLine( end ) < 0 & macdLine( end - 1 ) > 0
    trend = 'bear';
elseif macdLine( end ) > 0 & macdLine( end - 1 ) < 0
    trend = 'bull';
elseif  signalLine( end ) < macdLine( end ) & signalLine( end - 1 ) > macdLine( end - 1 )
    trend = 'buy';
elseif signalLine( end ) > macdLine( end ) & signalLine( end - 1 ) < macdLine( end - 1 )
    trend = 'sell';
else
    trend = '';
end


