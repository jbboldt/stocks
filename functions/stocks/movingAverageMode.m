function mode = movingAverageMode( price, ma ) 

[~, maShort ] = movavg( price, 1, ma( 1 ), 0 );
[~, maMedium ] = movavg( price, 1, ma( 2 ), 0 );
[~, maLong ] = movavg( price, 1, ma( 3 ), 0 );

mode = ( maMedium >= maLong ) * 4 + ...
    ( maShort >= maLong ) * 2 + ...
    ( maShort >= maMedium );

mode( mode == 3 ) = 2;
mode( mode > 5 ) = mode( mode > 5 ) - 1;

mode = mode - 3;


