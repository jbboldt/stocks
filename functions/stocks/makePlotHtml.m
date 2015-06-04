function fName = makePlotHtml( S, targetDir )

stockName = strrep( S.name, ' ', '' );

fH = fopen( 'styleSetup.txt', 'r' );
str = fread( fH, 'char' );
fclose( fH );

fName = [ strrep( S.name, ' ', '' ), 'Plots.html' ];
fH = fopen( [ targetDir, filesep, fName ], 'w+' );

fprintf( fH, '%s', str );

fprintf( fH, '<h1>%s (%s) %s<h1>', S.name, S.ticker, datestr( now ) );
fprintf( fH, '<img src="%sma.png" width="1600" height="900"><br>\n', stockName );
fprintf( fH, '<img src="%smacd.png" width="1600" height="900"><br>\n', stockName );
fprintf( fH, '<img src="%sbollinger.png" width="1600" height="900"><br>\n', stockName );
fprintf( fH, '<img src="%smaLong.png" width="1600" height="900"><br>\n', stockName );
fprintf( fH, '<img src="%scandle.png" width="1600" height="900"><br>\n', stockName );

fclose( fH );