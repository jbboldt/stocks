clear
clc

% delete( '*.png' )
% delete( '*.html' )

targetDir = 'reports/stockReport';
if isdir( targetDir )
  [s,m,mi]=rmdir( targetDir, 's' );
end
mkdir( targetDir );

diary( 'log.txt' )

%generateStockDataTest
generateStockData

idxW1 = 1;
idxW2 = 1;
idxT = 1;
idxO = 1;

isCon = false;
while isCon == false
  try
    conn = yahoo;
    isCon = true;
  catch
    isCon = false;
    warning('Could not connect');
  end
end

stockHist = [];
for cS = 1 : length( S )
  fprintf( 'Fetching: %s\n', S(cS).name );
  stockHist = getStockHistory(conn,stockHist,S(cS),'01-jan-2000',date);
end

for cS = 1 : length(stockHist)
  
  fprintf( 'Processing: %s\n', stockHist(cS).name );
  
  % mode
  mode = movingAverageMode( stockHist(cS).day.close, [ 5 20 60 ] );
  [ currMode, lastMode, days, rowColor ] = maMode2str( mode );
  
  C{ 1 } = stockHist(cS).name;
  C{ 2 } = currMode;
  C{ 3 } = days;
  
  [ C{6}, ~ ] = rsi( stockHist(cS).day.close, 14 );
  [ C{7}, ~, ~, ~, C{11} ] = macd( stockHist(cS).day.close, [ 26, 12, 9 ] );
  
  pChange = (stockHist(cS).day.close(end)-stockHist(cS).day.close(end-5))/stockHist(cS).day.close(end-5) * 100;
  C{8} = [num2str(roundn(pChange,-1)),'%'];
 
  pChange = (stockHist(cS).day.close(end)-stockHist(cS).day.close(end-10))/stockHist(cS).day.close(end-10) * 100;
  C{9} = [num2str(roundn(pChange,-1)),'%'];

  pChange = (stockHist(cS).day.close(end)-stockHist(cS).day.close(end-20))/stockHist(cS).day.close(end-20) * 100;
  C{10} = [num2str(roundn(pChange,-1)),'%'];
  
  if ~isempty( stockHist(cS).bought )
    
    % Percentages:
    % Price from buy:
    devPrice = stockHist(cS).day.close( stockHist(cS).day.sdn >= datenum( stockHist( cS ).bought ) );
    C{4} = roundn( ( devPrice(end) / stockHist( cS ).price - 1 ) * 100, -2 );
    C{5} = roundn( ( devPrice(end) / max( devPrice ) - 1 ) * 100, -2 );
    
    T( idxT, : ) = C(:);
    modeT( idxT ) = mode(end);
    rowColorT( idxT, : ) = rowColor;
    idxT = idxT + 1;
    
    if ( C{4} < stockHist( cS ).stoploss ) || ~isempty( C{6} ) || ~isempty( C{7} )
      W1( idxW1, : ) = C(:);
      rowColorW1(idxW1+1,:) = [ 255, 100, 0 ];
      idxW1 = idxW1 + 1;
    elseif ( C{5} < stockHist( cS ).stoplossMax ) || ~isempty( C{6} ) || ~isempty( C{7} )
      W1( idxW1, : ) = C(:);
      rowColorW1(idxW1+1,:) = [ 255, 200, 0 ];
      idxW1 = idxW1 + 1;
    end
    
  else
    
    C{4} = '';
    C{5} = '';
    O( idxO, : ) = C(:);
    idxO = idxO + 1;
    
    if ( ~isempty( C{6} ) || ~isempty( C{7} ) )
      W2( idxW2, : ) = C(:);
      idxW2 = idxW2 + 1;
    end
    
  end
  
  
end

[ nS, nV ] = size( T );

L = { 'Name', 'CurrentMode', 'days', '%', '%Max', 'RSI', 'MACD', '5d', '10d', '20d', 'MACD Hist' };

% Sort Table T
[y,idx] = sort( modeT );
T = T( idx,: );
rowColorT = rowColorT( idx, : );
rowColorT( 2:nS+1,: ) = rowColorT;

T = [ L; T ];

%%
fH = fopen( 'styleSetup.txt', 'r' );
str = fread( fH, 'char' );
fclose( fH );

%%
fH = fopen( [ targetDir, filesep, 'index.html' ], 'w+' );
fprintf( fH, '%s', str );
fprintf( fH, '<h1>%s</h1>', datestr( now ) );

%%
colWidth( 1:nV ) = 180;
colWidth( 1 ) = 220;
colWidth( 2 ) = 160;
colWidth( 3 ) = 50;
colWidth( 4:7 ) = 50;

colWidth( 8:10 ) = 70;
colWidth( 11 ) = 120;

tdAlign( 1:nV ) = { 'center' };
tdAlign( 1 ) = { 'left' };

%% Warning
if exist( 'W1' )
  W1 = [ L; W1 ];
  [ mW1, nW1 ] = size( W1 );
  
  %rowColorW1 = repmat( [ 255, 200, 0 ], size( W1, 1 ), 1 );
  rowColorW1( 1,: ) = [ 200, 200, 200 ];
  textColorW1( 1:mW1, 1:nW1, 1:3 ) = 0;
  fontWeightW1( 1:mW1, 1:nW1 ) = { 'normal' };
  
  fprintf( fH, '<table rules="rows" frame="void" border="2" bordercolor=white>\n' );
  for cR = 1 : size( W1, 1 )
    hexColor = [ dec2hex( rowColorW1( cR, 1 ), 2 ), dec2hex( rowColorW1( cR, 2 ), 2 ), dec2hex( rowColorW1( cR, 3 ), 2 ) ];
    fprintf( fH, [ '<tr bgcolor=#', hexColor, '>\n' ] );
    
    for cC = 1 : size( W1, 2 )
      hexColor = [ dec2hex( textColorW1( cR, cC, 1 ) ), dec2hex( textColorW1( cR, cC, 2 ) ), dec2hex( textColorW1( cR, cC, 3 ) ) ];
      
      if ( cC == 1 ) && ( cR > 1 )
        str = sprintf( '<a href="%s.html">%s</a>', [ strrep( num2str( W1{ cR, cC } ), ' ', '' ), 'Plots' ], num2str( W1{ cR, cC } ) );
      else
        str = num2str( W1{ cR, cC } );
      end
      
      fprintf( fH, '<td width="%d" align="%s" style="font-weight:%s;"><font color=#%s>%s</font></td>\n', ...
        colWidth( cC ), tdAlign{cC}, fontWeightW1{ cR, cC }, hexColor, str );
    end
  end
  fprintf( fH, '</tr></table><br>\n' );
  
end
%%

[ nS, nV ] = size( T );

% html = GTHTMLtable( T, {'Name', 'Current<br>Mode', 'days', 'Last<br>mode' }, S )
% fprintf( fH, '%s', html );

%T( 1, 1:nV ) = { 'Name', 'CurrentMode', 'days', 'Last mode', '%', '%Max' };

rowColorT( 1,: ) = [ 200, 200, 200 ];
% rowColorT( 2,: ) = [ 200,  255, 255 ];

textColor( 1:nS+1, 1:nV, 1:3 ) = 0;
%textColor( 1, :, : ) = repmat( [ 255, 255, 255 ], 2, 1 );

fontWeight( 1:nS+1, 1:nV ) = { 'normal' };
%fontWeight( 1, 1:nV ) = { 'bold' };

fprintf( fH, '<table rules="rows" frame="void" border="2" bordercolor=white>\n' );
% fprintf( fH, '<tr>\n<th>x1</th><th>x2</th></tr>' );
for cR = 1 : nS
  hexColor = [ dec2hex( rowColorT( cR, 1 ), 2 ), dec2hex( rowColorT( cR, 2 ), 2 ), dec2hex( rowColorT( cR, 3 ), 2 ) ];
  fprintf( fH, [ '<tr bgcolor=#', hexColor, '>\n' ] );
  for cC = 1:nV
    hexColor = [ dec2hex( textColor( cR, cC, 1 ) ), dec2hex( textColor( cR, cC, 2 ) ), dec2hex( textColor( cR, cC, 3 ) ) ];
    
    if ( cC == 1 ) && ( cR > 1 )
      str = sprintf( '<a href="%s.html">%s</a>', [ strrep( num2str( T{ cR, cC } ), ' ', '' ), 'Plots' ], num2str( T{ cR, cC } ) );
    else
      str = num2str( T{ cR, cC } );
    end
    
    fprintf( fH, '<td width="%d" align="%s" style="font-weight:%s;"><font color=#%s>%s</font></td>\n', ...
      colWidth( cC ), tdAlign{cC}, fontWeight{ cR, cC }, hexColor, str );
  end
  fprintf( fH, '</tr>\n' );
end
fprintf( fH, '</table><br>\n' );

%% Observation
if exist( 'O' )
  
  O = [ L; O ];
  rowColorO = repmat( [ 220, 220, 220 ], size( O, 1 ), 1 );
  rowColorO( 1,: ) = [ 200, 200, 200 ];
  
  [ mO, nO ] = size( O );
  
  textColorO( 1:mO, 1:nO, 1:3 ) = 0;
  fontWeightO( 1:mO, 1:nO ) = { 'normal' };
  
  fprintf( fH, '<table rules="rows" frame="void" border="2" bordercolor=white>\n' );
  for cR = 1 : size( O, 1 )
    hexColor = [ dec2hex( rowColorO( cR, 1 ), 2 ), dec2hex( rowColorO( cR, 2 ), 2 ), dec2hex( rowColorO( cR, 3 ), 2 ) ];
    fprintf( fH, [ '<tr bgcolor=#', hexColor, '>\n' ] );
    for cC = 1 : size( O, 2 )
      hexColor = [ dec2hex( textColorO( cR, cC, 1 ) ), dec2hex( textColorO( cR, cC, 2 ) ), dec2hex( textColorO( cR, cC, 3 ) ) ];
      
      if ( cC == 1 ) && ( cR > 1 )
        str = sprintf( '<a href="%s.html">%s</a>', [ strrep( num2str( O{ cR, cC } ), ' ', '' ), 'Plots' ], num2str( O{ cR, cC } ) );
      else
        str = num2str( O{ cR, cC } );
      end
      
      fprintf( fH, '<td width="%d" align="%s" style="font-weight:%s;"><font color=#%s>%s</font></td>\n', ...
        colWidth( cC ), tdAlign{cC}, fontWeightO{ cR, cC }, hexColor, str );
    end
    fprintf( fH, '</tr>\n' );
  end
  fprintf( fH, '</table>\n' );
  
end
fprintf( fH, '</body>\n</html>\n' );
fclose( fH );



%% Plots
idx = 1;
for c = 1 : length(stockHist)
  fprintf( 'Making Plots: %s\n', stockHist(c).name );
  
  fName{idx} = makePlotHtml(stockHist(c), targetDir );
  idx=idx+1;
  
  fName{idx} = makeStockPlot(stockHist(c), 'ma', 200, targetDir );
  idx=idx+1;
  
  fName{idx} = makeStockPlot(stockHist(c), 'macd', 200, targetDir );
  idx=idx+1;
  
  fName{idx} = makeStockPlot(stockHist(c), 'bollinger', 200, targetDir );
  idx=idx+1;
  
  fName{idx} = makeStockPlot(stockHist(c), 'maLong', 2000, targetDir );
  idx=idx+1;
  
  fName{idx} = makeStockPlotSimple(stockHist(c),'candle',40,targetDir);
  idx=idx+1;
  
  fName{idx} = makeStockPlot(stockHist(c), 'maLongMulti', 1000, targetDir );
  idx=idx+1;

end

close all
fclose all

close(conn)
diary off