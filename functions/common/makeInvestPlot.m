function fName = makeInvestPlot(S,nS,opt)

%% Options Parser

defaultOption.imageSize = [1150 500];
defaultOption.upScale = 2;
defaultOption.figureName = ['temp',timeStamp];
defaultOption.title = datestr(now);
defaultOption.targetDir = '.';

%Generate the 'opt' struct from the fields found in the input
%parameter 'opt' and the fields from the 'defaultOption' struct:

if ~exist( 'opt', 'var' )
	opt = struct;
end

% Parse options:
opt = optionParser( defaultOption, opt );

if nargin<2
	nS=length(S.sdn);
end

hA = multiAxis( 1, 1, ...
	'topMargin', 0.06, ...
	'bottomMargin', 0.1, ...
	'leftMargin', 0.04, ...
	'rightMargin', 0.05, ...
	'fontSize', 10 );

plot(S.sdn(end-nS+1:end),S.data(end-nS+1:end));
datetick('x');
xl = [S.sdn(end-nS+1), S.sdn(end)];
xlim([S.sdn(end-nS+1), S.sdn(end) + diff(xl).*0.02]);

A = axis;
dA = [A(2)-A(1) A(4)-A(3)];
ylim([A(3)-dA(2)*0.02 A(4)+dA(2)*0.02]);

% xt = linspace(S.sdn(end-nS+1),S.sdn(end),10);
% set(gca,'XTick',xt,'XTickLabel',datestr(xt,'dd/mm'));

title(opt.title)
set(gca,'YAxisLocation','right')
grid on

if floor(now) -1 <= S.sdn(end)
	tColor = [0 .8 0];
elseif floor(now) -3 <= S.sdn(end)
	tColor = [1 .5 0];
else
	tColor = [.8 0 0];
end

A = axis;
dA = [A(2)-A(1) A(4)-A(3)];
text(A(1),A(4)+0.01*dA(2),datestr(S.sdn(end-nS+1)),'VerticalAlignment','bottom','fontsize',8);
text(A(2),A(4)+0.01*dA(2),...
	sprintf('%s : %g', datestr(S.sdn(end)), S.data(end)),'color', tColor, ...
	'VerticalAlignment','bottom','HorizontalAlignment','right','fontsize',8);

fName = [opt.targetDir, '/' opt.figureName, '.png'];
pp = [ 0 0 opt.imageSize(1) opt.imageSize(2) ] * opt.upScale ./ 254;
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', pp );
print(gcf, '-dpng', '-r254', fName );
str = sprintf('convert %s -resize 1200x500 %s',fName,fName);
system( str );

idx=strfind(fName,'/');
fName = fName(idx(end)+1:end);
