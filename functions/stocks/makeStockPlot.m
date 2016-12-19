function fName = makeStockPlot( stockHist, plotType, nDay, targetDir )

DG.stockHist = stockHist;

if nDay > DG.stockHist.day.count
    nDay = DG.stockHist.day.count;
end

DG.cIdx = DG.stockHist.day.count - nDay + 1 : DG.stockHist.day.count;
DG.nData = length( DG.cIdx );

hA = multiAxis( [ 2 5 2 ], 1, ...
    'topMargin', 0.05, ...
    'bottomMargin', 0.05, ...
    'leftMargin', 0.04, ...
    'rightMargin', 0.05, ...
    'fontSize', 16, 'singleXaxis', true, 'verticalMargin', 0.01 );

switch plotType
    case 'ma'
        
        axes( hA( 3 ) )
        lVol = log10(DG.stockHist.day.volume( DG.cIdx ));
        bar( 1 : nDay, lVol, 1, 'FaceColor', getColor(8), 'EdgeColor', getColor(8) );
        ylim( [min(lVol(lVol>-inf)).*0.99,max(lVol(lVol>-inf)).*1.01 ])
        hold on
        ylabel( 'log Volume' );
        
        hA(4) = axes('Position',get(hA(3),'Position'),'YAxisLocation','right', 'Color', 'none', ...
            'Xtick', [], 'Ytick', [] );
        
        %moving average on volume removed
        if 0
            hold on
            [~, ma ] = movavg( DG.stockHist.day.volume, 1, 20, 0 );
            plot( 1 : nDay, ma( DG.cIdx ), 'g', 'linewidth', 1 )
            [~, ma ]=movavg( DG.stockHist.day.volume, 1, 5, 0 );
            plot( 1 : nDay, ma( DG.cIdx ) , 'r', 'linewidth', 2 )
            [~, ma ]=movavg( DG.stockHist.day.volume, 1, 20, 0 );
            plot( 1 : nDay, ma( DG.cIdx ) , 'g', 'linewidth', 2 )
            [~, ma ]=movavg( DG.stockHist.day.volume, 1, 60, 0 );
            plot( 1 : nDay, ma( DG.cIdx ) , 'b', 'linewidth', 2 )
        end
        
        axes( hA( 1 ) )
        mode = movingAverageMode( DG.stockHist.day.close, [ 5 20 60 ] );
        hB = bar( mode( DG.cIdx ), 1 );
        set( get( hB, 'children' ), 'cdata', sign( mode( DG.cIdx ) ) );
        colormap( [1 0 0; 0 .7 0] ); % red & blue in rgb
        ylim( [ -4 4 ] );
        ylabel( 'mode' );
        
        axes( hA( 2 ))
        if ~isempty(DG.stockHist.bought)
            buyIdx = find(DG.stockHist.day.sdn==datenum(DG.stockHist.bought))-DG.cIdx(1);
            line([buyIdx, buyIdx],log10([DG.stockHist.price.*0.96,DG.stockHist.price*1.04]), ...
                'color', [.7 .7 .7], 'linewidth', 3)
            hold on
            line([1, nDay + 5],log10([DG.stockHist.price,DG.stockHist.price]), ...
                'color', [.7 .7 .7], 'linewidth', 3)
        end
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 5, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'r', 'linewidth', 2 )
        hold on
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 20, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'g', 'linewidth', 2 )
        
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 60, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'b', 'linewidth', 2 )
        
        legend( '5', '20', '60', 'location', 'northwest' );
        
    case 'maLong'
        
        axes( hA( 3 ) )
        
        logVolume = log10(DG.stockHist.day.volume( DG.cIdx ));
        bar( 1 : nDay, logVolume, 1, 'FaceColor', getColor(8), 'EdgeColor', getColor(8) );
        ylim([min(logVolume(logVolume>-inf)).*0.99,max(logVolume)*1.01]);
        ylabel( 'log Volume' );
        
        axes( hA( 2 ))
        if ~isempty(DG.stockHist.bought)
            buyIdx = find(DG.stockHist.day.sdn==datenum(DG.stockHist.bought))-DG.cIdx(1);
            line([buyIdx, buyIdx],log10([DG.stockHist.price.*0.9,DG.stockHist.price*1.1]), ...
                'color', [.7 .7 .7], 'linewidth', 2)
            hold on
            line([1, nDay + 5],log10([DG.stockHist.price,DG.stockHist.price]), ...
                'color', [.7 .7 .7], 'linewidth', 2)
        end
        
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 60, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'b', 'linewidth', 1 )
        hold on
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 100, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'm', 'linewidth', 1 )
        
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 200, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'c', 'linewidth', 1 )
        
        legend( '60', '100', '200', 'location', 'northwest' );
        
    case 'maLongMulti'
        %%
        axes( hA( 3 ) )
        
        logVolume = log10(DG.stockHist.day.volume( DG.cIdx ));
        bar( 1 : nDay, logVolume, 1, 'FaceColor', getColor(8), 'EdgeColor', getColor(8) );
        ylim([min(logVolume(logVolume>-inf)).*0.99,max(logVolume)*1.01]);
        ylabel( 'log Volume' );
        
        axes( hA( 2 ))
        if ~isempty(DG.stockHist.bought)
            buyIdx = find(DG.stockHist.day.sdn==datenum(DG.stockHist.bought))-DG.cIdx(1);
            line([buyIdx, buyIdx],log10([DG.stockHist.price.*0.9,DG.stockHist.price*1.1]), ...
                'color', [.7 .7 .7], 'linewidth', 1)
            hold on
            line([1, nDay + 5],log10([DG.stockHist.price,DG.stockHist.price]), ...
                'color', [.7 .7 .7], 'linewidth', 1)
        end
        
        load hotCM
        hCI = 1;
        maDiff = [];
        for mM = [5 10 20 30 80 160 320];
            
            [~, ma ]=movavg( DG.stockHist.day.close, 1, mM, 0 );
            plot( log10( ma( DG.cIdx ) ) , 'linewidth', 1.2, 'color', hotCM(hCI,:));
            hold on
            hCI = hCI + 8;
            if mM > 5
                maDiff = [maDiff,log10(maPrev( DG.cIdx ))-log10(ma( DG.cIdx ))];
            end
            
            maPrev = ma;
        end
        
        axes( hA( 1 ) )
        %area(fliplr(maDiff), 'LineStyle', 'none')
        area(fliplr(maDiff), 'EdgeColor', [1 1 1 ])
        colormap(flipud(hotCM(1:end-10,:)))
        
        axes( hA( 3 ) )
        maDiff(maDiff<0)=0;
        area(fliplr(maDiff), 'EdgeColor', [1 1 1 ])
        colormap(flipud(hotCM(1:end-10,:)))
        %%
    case 'bollinger'
        
        axes( hA( 1 ) )
        [~, ma5 ]=movavg( DG.stockHist.day.close, 1, 5, 0 );
        [~, ma20 ]=movavg( DG.stockHist.day.close, 1, 20, 0 );
        [~, ma60 ]=movavg( DG.stockHist.day.close, 1, 60, 0 );
        
        line( [ 1 length( DG.cIdx ) ], [ 0 0 ], 'color', [ 0 0 0 ], 'linewidth', 3 );
        plot( log10(ma5( DG.cIdx ))-log10(ma20( DG.cIdx )) , 'linewidth', 2, 'color', [ 1 .7 .7 ] .* 0.8 )
        plot( log10(ma20( DG.cIdx ))-log10(ma60( DG.cIdx )) , 'linewidth', 2, 'color', [ 1 .7 .7 ] .* 0.4 )
        
        hold on
        legend( 'C/D Short', 'C/D Long', 'location', 'northwest' );
        grid on
        set( hA(1), 'GridLineStyle', '-' );
        
        axes( hA( 2 ))
        if ~isempty(DG.stockHist.bought)
            buyIdx = find(DG.stockHist.day.sdn==datenum(DG.stockHist.bought))-DG.cIdx(1);
            line([buyIdx, buyIdx],log10([DG.stockHist.price.*0.96,DG.stockHist.price*1.04]), ...
                'color', [.7 .7 .7], 'linewidth', 3)
            hold on
            line([1, nDay + 5],log10([DG.stockHist.price,DG.stockHist.price]), ...
                'color', [.7 .7 .7], 'linewidth', 3)
        end
        
        lw = 1.5;
        [ mid, uppr, lowr] = bollinger( DG.stockHist.day.close, 60, 2 );
        hp(1) = plot( log10( uppr( DG.cIdx ) ) , 'linewidth', lw, 'color', getColor(4) );
        plot( log10( lowr( DG.cIdx ) ) , 'linewidth', lw, 'color', getColor(4) );
        plot( log10( mid( DG.cIdx ) ) , ':', 'linewidth', lw, 'color', getColor(4) );
        
        [ mid, uppr, lowr] = bollinger( DG.stockHist.day.close, 20, 2 );
        hp(2) = plot( log10( uppr( DG.cIdx ) ) , 'linewidth', lw, 'color', getColor(3) );
        plot( log10( lowr( DG.cIdx ) ) , 'linewidth', lw, 'color', getColor(3) );
        plot( log10( mid( DG.cIdx ) ) , ':', 'linewidth', lw, 'color', getColor(3));
        
        [ mid, uppr, lowr] = bollinger( DG.stockHist.day.close, 5, 2 );
        hp(3) = plot( log10( uppr( DG.cIdx ) ) , 'linewidth', lw, 'color', getColor(2) );
        plot( log10( lowr( DG.cIdx ) ) , 'linewidth', lw, 'color', getColor(2) );
        hold on
        plot( log10( mid( DG.cIdx ) ) , ':', 'linewidth', lw, 'color', getColor(2) );
        
        legend( hp, {'60', '20', '5'}, 'location', 'northwest');
        
    case 'obv'
        
        axes( hA( 3 ) )
        obVal = obv( DG.stockHist.day );
        [~, obvMA ]=movavg( obVal, 1, 20, 0 );
        lw = 1.5;
        plot( obvMA( DG.cIdx ) , 'g', 'linewidth', lw )
        hold on
        plot( obVal( DG.cIdx ), 'k', 'linewidth', lw )
        ylabel( 'OBV' );
        
        yL = ylim;
        yData = linspace( yL(1), yL(2), 10 );
        set( hA( 3 ), 'YGrid', 'on', 'Ytick', yData, 'YTickLabel', [] );
        set( gca,'gridLineStyle', '-' )
        
        axes( hA( 1 ) )
        [ kVal, dVal ] = stochastic( DG.stockHist.day, [ 20 10 5 ] );
        line( [ 1, nDay ], [80,80], 'linewidth', 2, 'color', [ 1 1 1 ].*0.6 );
        line( [ 1, nDay ], [20,20], 'linewidth', 2, 'color', [ 1 1 1 ].*0.6 );
        plot( kVal( DG.cIdx ), 'k', 'linewidth', 2 );
        plot( dVal( DG.cIdx ), 'linewidth', 2, 'color', [.7 .7 .7 ] );
        ylim( [ 0 100 ] );
        ylabel( 'Stochastic' );
        set( gca,'gridLineStyle', '-' )
        axes( hA( 2 ) )
        
    case 'x'
        
        axes( hA( 3 ) )
        bar( 1 : nDay, DG.stockHist.day.volume( DG.cIdx ), 1, 'FaceColor', getColor(8), 'EdgeColor', getColor(8) );
        hold on
        ylabel( 'Volume' );
        
        hA(4) = axes('Position',get(hA(3),'Position'),'YAxisLocation','right', 'Color', 'none', ...
            'Xtick', [], 'Ytick', [] );
        hold on
        [~, ma ] = movavg( DG.stockHist.day.volume, 1, 20, 0 );
        plot( 1 : nDay, ma( DG.cIdx ), 'g', 'linewidth', 1 )
        
        [~, ma ]=movavg( DG.stockHist.day.volume, 1, 5, 0 );
        plot( 1 : nDay, ma( DG.cIdx ) , 'r', 'linewidth', 2 )
        
        [~, ma ]=movavg( DG.stockHist.day.volume, 1, 20, 0 );
        plot( 1 : nDay, ma( DG.cIdx ) , 'g', 'linewidth', 2 )
        
        [~, ma ]=movavg( DG.stockHist.day.volume, 1, 60, 0 );
        plot( 1 : nDay, ma( DG.cIdx ) , 'b', 'linewidth', 2 )
        
        axes( hA( 2 ))
        
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 5, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'r', 'linewidth', 2 )
        hold on
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 20, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'g', 'linewidth', 2 )
        
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 60, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'b', 'linewidth', 2 )
        
        maxVal=max(log10( DG.stockHist.day.high( DG.cIdx ) ));
        minVal=min(log10( DG.stockHist.day.low( DG.cIdx ) ));
        ylim( [minVal * 0.999 , maxVal * 1.001] );
        
        
    case 'dev'
        
        axes( hA( 3 ) )
        
        vc = volCorr( DG.stockHist.day.close, DG.stockHist.day.volume, 5 );
        plot( vc( DG.cIdx ), 'r', 'linewidth', 2 );
        hold on
        vc = volCorr( DG.stockHist.day.close, DG.stockHist.day.volume, 20 );
        plot( vc( DG.cIdx ), 'g', 'linewidth', 2 );
        vc = volCorr( DG.stockHist.day.close, DG.stockHist.day.volume, 60 );
        plot( vc( DG.cIdx ), 'b', 'linewidth', 2 );
        grid on
        set( hA(3), 'GridLineStyle', '-' );
        ylabel( 'volCorr' );
        
        hA(4) = axes('Position',get(hA(3),'Position'),'YAxisLocation','right', 'Color', 'none', ...
            'Xtick', [], 'Ytick', [] );
        
        axes( hA( 2 ))
        
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 5, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'r', 'linewidth', 2 )
        hold on
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 20, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'g', 'linewidth', 2 )
        
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 60, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'b', 'linewidth', 2 )
        
        axes( hA( 1 ) )
        [~, ma5 ]=movavg( DG.stockHist.day.close, 1, 5, 0 );
        [~, ma20 ]=movavg( DG.stockHist.day.close, 1, 20, 0 );
        [~, ma60 ]=movavg( DG.stockHist.day.close, 1, 60, 0 );
        
        line( [ 1 length( DG.cIdx ) ], [ 0 0 ], 'color', [ 0 0 0 ], 'linewidth', 3 );
        plot( log10(ma5( DG.cIdx ))-log10(ma20( DG.cIdx )) , 'linewidth', 2, 'color', [ 1 .7 .7 ] .* 0.8 )
        plot( log10(ma20( DG.cIdx ))-log10(ma60( DG.cIdx )) , 'linewidth', 2, 'color', [ 1 .7 .7 ] .* 0.4 )
        
        hold on
        
        legend( 'C/D Short', 'C/D Long', 'location', 'northwest' );
        grid on
        set( hA(1), 'GridLineStyle', '-' );
        axes( hA( 2 ))
        
    case 'macd'
        
        axes( hA( 3 ) )
        [ trend, macdLine, signalLine, macdHist ] = macd( DG.stockHist.day.close, [ 26, 12, 9 ] ) ;
        bar( 1 : nDay, macdHist( DG.cIdx ), 0.4, 'FaceColor', [.6 .6 .6] );
        hold on
        lw = 1.5;
        plot( macdLine( DG.cIdx ), 'k', 'linewidth', lw )
        plot( signalLine( DG.cIdx ), 'r', 'linewidth', lw )
        legend( 'Hist', 'MACD', 'Signal Line', 'location', 'NorthWest' );
        xlim( [ 1 nDay + 1 ] )
        
        axes( hA( 1 ) )
        
        [ rsiMode, rsiVal14 ] = rsi( DG.stockHist.day.close, 14 );
        line( [ 1, nDay ], [80,80], 'linewidth', 2, 'color', [ 1 1 1 ].*0.6 );
        line( [ 1, nDay ], [20,20], 'linewidth', 2, 'color', [ 1 1 1 ].*0.6 );
        plot( rsiVal14( DG.cIdx ), 'linewidth', 2 );
        ylim( [ 0 100 ] );
        ylabel( 'RSI' );
        
        axes( hA( 2 ))
        
        if ~isempty(DG.stockHist.bought)
            buyIdx = find(DG.stockHist.day.sdn==datenum(DG.stockHist.bought))-DG.cIdx(1);
            line([buyIdx, buyIdx],log10([DG.stockHist.price.*0.96,DG.stockHist.price*1.04]), ...
                'color', [.7 .7 .7], 'linewidth', 3)
            hold on
            line([1, nDay + 5],log10([DG.stockHist.price,DG.stockHist.price]), ...
                'color', [.7 .7 .7], 'linewidth', 3)
        end
        
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 5, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'r', 'linewidth', 2 )
        hold on
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 20, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'g', 'linewidth', 2 )
        
        [~, ma ]=movavg( DG.stockHist.day.close, 1, 60, 0 );
        plot( log10( ma( DG.cIdx ) ) , 'b', 'linewidth', 2 )
        
        legend( '5', '20', '60', 'location', 'northwest' );
        
end


switch plotType
    case 'maLong'
        hhl = plot( log10( DG.stockHist.day.high( DG.cIdx )),'k');
        set(hA(2),'YLim', ...
            [ min(log10( DG.stockHist.day.high( DG.cIdx )))*0.99, ...
            max(log10( DG.stockHist.day.high( DG.cIdx )))*1.01]);
        set( hhl,'linewidth', 1.5 )
    case 'maLongMulti'
        set(hA(2),'YLim', ...
            [ min(log10( DG.stockHist.day.high( DG.cIdx )))*0.99, ...
            max(log10( DG.stockHist.day.high( DG.cIdx )))*1.01]);
    otherwise
        hhl = highlow( log10( DG.stockHist.day.high( DG.cIdx ) ), ...
            log10( DG.stockHist.day.low( DG.cIdx ) ), ...
            log10( DG.stockHist.day.close( DG.cIdx ) ), ...
            log10( DG.stockHist.day.open( DG.cIdx ) ), [ 0 0 0 ] );
        set( hhl,'linewidth', 1.8 )
        set(hA(2),'YLim', ...
            [ min(log10( DG.stockHist.day.high( DG.cIdx )))*0.99, ...
            max(log10( DG.stockHist.day.high( DG.cIdx )))*1.01]);
end

xlim( [ 1 nDay + 1 ] )

axes(hA(1))
title( sprintf( '%s (%s) %s', stockHist.name, stockHist.ticker, datestr( now ) ) );

axes(hA(2))
yL = ylim;
yData = linspace( yL(1), yL(2), 20 );
for n = 1 : 20
    yTL{n} = sprintf( '%.1f', 10.^yData( n ) );
end
set( hA( 2 ), 'Ytick', yData, 'YTickLabel', yTL );
set( gca,'gridLineStyle', '-' )

if nDay > 100 & nDay < 500
    monthDiff = [ 0; diff( month( DG.stockHist.day.sdn( DG.cIdx ) ) ) ];
    monthDiff( end - 10 : end ) = 0;
    monthDiff( end ) = 1;
    monthDiff( end - nDay + 1 : end );
    xData = find( monthDiff ~= 0 );
    
    for c = 1 : length( xData )
        tic{c} = datestr( DG.stockHist.day.sdn( DG.cIdx( xData( c ) ) ), 'mmmyy' );
    end
    tic{end} = datestr( DG.stockHist.day.sdn( DG.cIdx( xData( end ) ) ), 'ddmmmyy' );
    
    set( hA(1), 'Xlim', [ 1 nDay + 5 ], 'XTick', xData, 'XGrid', 'on' );
    set( hA(2), 'Xlim', [ 1 nDay + 5 ], 'XTick', xData, 'YAxisLocation', 'right', 'XGrid', 'on' );
    set( hA(3), 'Xlim', [ 1 nDay + 5 ], 'XTick', xData, 'XTickLabel', tic, 'XGrid', 'on' );
    
    if length( hA ) > 3 % Volume Moving average plot
        set( hA(4), 'Xlim', [ 1 nDay + 5 ] );
    end
elseif nDay >= 500
    
    yearDiff = [ 0; diff( year( DG.stockHist.day.sdn( DG.cIdx ) ) ) ];
    yearDiff( end - 10 : end ) = 0;
    yearDiff( end ) = 1;
    yearDiff( end - nDay + 1 : end );
    xData = find( yearDiff ~= 0 );
    
    for c = 1 : length( xData )
        tic{c} = datestr( DG.stockHist.day.sdn( DG.cIdx( xData( c ) ) ), 'mmmyy' );
    end
    tic{end} = datestr( DG.stockHist.day.sdn( DG.cIdx( xData( end ) ) ), 'ddmmmyy' );
    
    set( hA(1), 'Xlim', [ 1 nDay + 50 ], 'XTick', xData, 'XGrid', 'on' );
    set( hA(2), 'Xlim', [ 1 nDay + 50 ], 'XTick', xData, 'YAxisLocation', 'right', 'XGrid', 'on' );
    set( hA(3), 'Xlim', [ 1 nDay + 50 ], 'XTick', xData, 'XTickLabel', tic, 'XGrid', 'on' );
    
    if length( hA ) > 3 % Volume Moving average plot
        set( hA(4), 'Xlim', [ 1 nDay + 5 ] );
    end
    
else
    weekDiff = [ 0; diff( weeknum( DG.stockHist.day.sdn( DG.cIdx ) ) ) ];
    weekDiff( end - 3 : end ) = 0;
    weekDiff( end ) = 1;
    weekDiff( end - nDay + 1 : end );
    xData = find( weekDiff ~= 0 );
    
    for c = 1 : length( xData )
        tic{c} = datestr( DG.stockHist.day.sdn( DG.cIdx( xData( c ) ) ), 'ddmmmyy' );
    end
    tic{end} = datestr( DG.stockHist.day.sdn( DG.cIdx( xData( end ) ) ), 'ddmmmyy' );
    set( hA(1), 'Xlim', [ 1 nDay + 2 ], 'XTick', xData, 'XGrid', 'on' );
    set( hA(2), 'Xlim', [ 1 nDay + 2 ], 'XTick', xData, 'YAxisLocation', 'right', 'XGrid', 'on' );
    set( hA(3), 'Xlim', [ 1 nDay + 2 ], 'XTick', xData, 'XTickLabel', tic, 'XGrid', 'on' );
    
    if length( hA ) > 3 % Volume Moving average plot
        set( hA(4), 'Xlim', [ 1 nDay + 2 ] );
    end
    
end
% %%
% axes( hA( 1 ) );
% a = axis;
% text( a(1) + (a(2)-a(1))/200, a( 4 ) - ( a(4)-a(3) ) / 100, 'Mode', 'VerticalAlignment', 'top', 'fontsize', 12 )
%
% axes( hA( 3 ) );
% a = axis;
% text( a(1) + (a(2)-a(1))/200, a( 4 ) - ( a(4)-a(3) ) / 100, 'Volume', 'VerticalAlignment', 'top', 'fontsize', 12 )


if nargin == 4
    opt.crop = [ 0 0 0 0 ];
    opt.imageSize = [ 1.777 1 ] * 10;
    opt.dpi = 500;
    opt.upScale = 3;
    opt.showOutput = false;
    fName = fig2png( gcf, [ targetDir, filesep, strrep( stockHist.name, ' ', '' ), plotType ], opt );
end
