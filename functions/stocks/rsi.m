function [ trend, rsiValue] = rsi( price, periods )

priceChange = [ 0; diff( price(:) ) ];

posPC = priceChange;
negPC = priceChange;

posPC( priceChange < 0 ) = 0;
negPC( priceChange >= 0 ) = 0;

negPC = abs( negPC );

[~, posMA ] = movavg( posPC, 1, periods );
[~, negMA ] = movavg( negPC, 1, periods );

posMA( 1:2 ) = 0;
negMA( 1:2 ) = 1;

RS = posMA ./ negMA;

rsiValue = 100 - 100 ./ ( 1 + RS );

if rsiValue( end ) > 85
    trend = '>85';
elseif rsiValue( end ) < 15
    trend = '<15';
else
    trend = '';
end


