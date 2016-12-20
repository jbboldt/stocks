function fName = makeIndexPlot(stk,plotType,mA,targetDir )

hA = multiAxis( 1, 1, ...
    'topMargin', 0.05, ...
    'bottomMargin', 0.05, ...
    'leftMargin', 0.04, ...
    'rightMargin', 0.05, ...
    'fontName', 'Calibri', ...
    'fontSize', 20, 'singleXaxis', true, 'verticalMargin', 0.01 );

[~,ma] = movavg( stk.close, 1,mA(4), 0 );
hP(5)=plot(stk.sdn,log10(ma), 'color',getColor(2,-50),'linewidth',2);
hold on
[~,ma] = movavg( stk.close, 1,mA(3), 0 );
hP(4)=plot(stk.sdn,log10(ma), 'color',getColor(2,50),'linewidth',2);
[~,ma] = movavg( stk.close, 1,mA(2), 0 );
hP(3)=plot(stk.sdn,log10(ma), 'color',getColor(5),'linewidth',2);
[~,ma] = movavg( stk.close, 1, mA(1), 0 );
hP(2)=plot(stk.sdn,log10(ma), 'color',getColor(11),'linewidth',2);
hP(1)=plot(stk.sdn,log10(stk.close),'k', 'linewidth', 2);
datetick('x','dd-mm-yy')
legend(hP,{stk.name,num2str(mA(1)),num2str(mA(2)),num2str(mA(3)),num2str(mA(4))},'location', 'northwest' );

oyIdx=stk.sdn>(stk.sdn(end)-365);

yL = [min(log10(stk.close(oyIdx).*0.99)),max(log10(stk.close(oyIdx).*1.01))];
yData = linspace(yL(1),yL(2), 20 );
for n = 1 : 20
    yTL{n} = sprintf( '%.0f', 10.^yData( n ) );
end

set( gca, 'Ytick', yData, 'YTickLabel', yTL,'YLim',yL,'YAxisLocation','right');
set( gca,'gridLineStyle', '-' )
xlim([stk.sdn(1),stk.sdn(end)])

nM=getNewMonth(stk.sdn);
set(gca,'Xtick',nM,'XtickLabel',datestr(nM,'dd/mm'));
xlim([stk.sdn(end)-365,stk.sdn(end)+15]);
title(['Last Data: ', datestr(stk.sdn(end),'dd-mmm-yy')]);

%title(stk.name);

if nargin == 4
    opt.crop = [ 0 0 0 0 ];
    opt.imageSize = [ 1.777 1 ] * 5;
    opt.dpi = 700;
    opt.upScale = 6;
    opt.showOutput = false;
    fName = fig2png( gcf, [ targetDir, filesep, stk.shortName, plotType ], opt );
end