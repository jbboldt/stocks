beep off
cd( 'C:\Users\Jesper Boldt\Documents\matlab\projects\stocks' )
fclose all
[s,m,mi] = rmdir('reports');
makeReport
makeCurrencyReport
makeIndexReport
makeCommodityReport
makeInterestReport
exit