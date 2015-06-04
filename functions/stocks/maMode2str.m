function [ currMode, lastMode, days, modeColor ] = maMode2str( mode )

[ currMode, modeColor ] = mode2str( mode( end ) );

modeChange = [ diff( mode ) ~= 0 ];
idxMC = find( modeChange == 1 );

if length( idxMC ) > 0
    lastMode = mode2str( mode( idxMC( end ) ) );
    days = length( mode ) - idxMC( end );
else
    lastMode = currMode;
    days = 0;
end

end

function [ strMode, modeColor ] = mode2str( mode )

switch mode
    case 3
        strMode = 'up';
        modeColor = [ 50, 255, 50 ];
    case 2
        strMode = 'up, but changing';
        modeColor = [ 150, 255, 150 ];
    case 1
        strMode = 'up, but changing fast';
        modeColor = [ 200, 255, 200 ];
    case -1
        strMode = 'down, but changing fast';
        modeColor = [ 255, 200, 200 ];
    case -2
        strMode = 'down, but changing';
        modeColor = [ 255, 150, 150 ];
    case -3
        strMode = 'down';
        modeColor = [ 255, 50, 50 ];
end
end