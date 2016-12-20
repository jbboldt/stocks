function makeIndexHtml(I,targetDir)

fH = fopen( 'styleSetup.txt', 'r' );
str = fread( fH, 'char' );
fclose( fH );

fH = fopen( [ targetDir, filesep, 'index.html' ], 'w+' );
fprintf( fH, '%s', str );
fprintf( fH, '\n');
fprintf( fH, '<h1>%s</h1>', datestr( now ) );

for nI = 1:length(I)
  I(nI).data = I(nI).close;
end
makeInvestTable(fH,I);

for cI=1:length(I)
  
  makeIndexPlot(I(cI),'oneYear',[20,60,100,200],targetDir);
  %fprintf( fH, '<h1>%s (%s) %s<h1>', S.name, S.symbol, datestr( now ) );
  fprintf( fH, '<img src="%s.png" width="1000" height="600"><br>\n', [I(cI).shortName,'oneYear'] );
  
end

fclose( fH );