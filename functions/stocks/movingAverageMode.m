function mode = movingAverageMode( price, ma ) 

[maShort ] = movavg( price, 'linear', ma( 1 ) );
[maMedium ] = movavg( price, 'linear', ma( 2 ) );
[maLong ] = movavg( price, 'linear', ma( 3 ) );

mode = ( maMedium >= maLong ) * 4 + ...
    ( maShort >= maLong ) * 2 + ...
    ( maShort >= maMedium );

mode( mode == 3 ) = 2;
mode( mode > 5 ) = mode( mode > 5 ) - 1;

mode = mode - 3;


