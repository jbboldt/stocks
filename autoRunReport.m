beep off
[s,m,mi] = rmdir('C:\Users\Jesper Boldt\Documents\matlab\projects\stocks');
!git clone https://github.com/jbboldt/stocks.git "C:\Users\Jesper Boldt\Documents\matlab\projects\stocks"
cd( 'C:\Users\Jesper Boldt\Documents\matlab\projects\stocks' )
fclose all
[s,m,mi] = rmdir('reports');
makeReport
makeCurrencyReport
makeIndexReport
makeCommodityReport
makeInterestReport
exit