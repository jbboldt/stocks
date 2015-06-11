function fName = makeStockPlotSimple(S,plotType,nDay,targetDir)

%S = getStockHistory(stk.symbol,'01-jan-2005',date);

hA = multiAxis(2,1, ...
    'topMargin', 0.05, ...
    'bottomMargin', 0.05, ...
    'leftMargin', 0.04, ...
    'rightMargin', 0.05, ...
    'fontSize', 16, 'singleXaxis', true, 'verticalMargin', 0.01 );

cIdx = S.day.count-nDay+1:S.day.count;

axes(hA(1))
candle(S.day.high(cIdx),S.day.low(cIdx),S.day.close(cIdx),S.day.open(cIdx),...
  'k')
C = get(gca,'children');
set(C(2),'lineWidth',2)
set(C(3),'lineWidth',2)

xlim([0 nDay+1])
set(gca,'YAxisLocation','right')
title( sprintf( '%s (%s) %s. Last data: %s', S.name, S.ticker, datestr( now ),datestr(S.day.sdn(end))));
xgrid(0.5:5:nDay,[1 1 1].*0.7,2);
set(gca,'XTick',[])

axes(hA(2))
lVol = log10(S.day.volume(cIdx));
bar(lVol);
xlim([0 nDay+1])
set(gca,'YAxisLocation','right');
%%bar( 1 : nDay, lVol, 1, 'FaceColor', getColor(8), 'EdgeColor', getColor(8) );
ylim( [min(lVol(lVol>-inf)).*0.99,max(lVol(lVol>-inf)).*1.01 ]);
xgrid(0.5:5:nDay,[1 1 1].*0.7,2);
set(gca,'TickLength',[0 0])
ylabel('log Volume')

cSdn = S.day.sdn(cIdx);
set(gca,'Xtick',[1:5:nDay nDay],'XtickLabel', datestr(cSdn([1:5:nDay nDay]),'dd/mm'))

if nargin == 4
    opt.crop = [ 0 0 0 0 ];
    opt.imageSize = [ 1.777 1 ] * 10;
    opt.dpi = 500;
    opt.upScale = 3;
    opt.showOutput = false;
    fName = fig2png( gcf, [ targetDir, filesep, strrep( S.name, ' ', '' ), plotType ], opt );
end