function fName = makeInvestTable(fH,I,opt)

%% Options Parser

defaultOption.diff = [ 1 5 20 60 120 240 ];
defaultOption.name = {'Name', 'Last', 'Day', 'Week', 'Month', 'Quarter', 'Half-Year', 'Year'};
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

nCol = length(opt.name);

c = htmlTable(zeros(length(I)+1,nCol));
c.allUnit('format','%.2f %%');
c.allUnit('align','right');
c.allUnit('paddingRight','10px');
c.table('fontSize',15);

for idx = 1:nCol
  c.data{1,idx}=opt.name{idx};
end

for nI = 1:length(I)
  c.data{nI+1,1}=I(nI).name;
  c.data{nI+1,2}=I(nI).data(end);
  c.row(nI+1,'height',25);
  
  if I(nI).data(end)>I(nI).data(end-1)
    c.unit(nI+1,2,'color',[0 .6 0]);
  elseif I(nI).data(end)<I(nI).data(end-1)
    c.unit(nI+1,2,'color',[.7 0 0]);
  else
    c.unit(nI+1,2,'color',[0 0 0]);
  end
  
  for nDiff = 1:length(opt.diff)
    valLast = I(nI).data(end);
    valPrev = I(nI).data(end-opt.diff(nDiff));
    diff = (valLast-valPrev)/valPrev*100;
    c.data{nI+1,nDiff+2} = diff;
    c.colUnit(nDiff+2,'width',80);
    if diff>0
      c.unit(nI+1,nDiff+2,'color',[0 .6 0]);
    elseif diff<0
      c.unit(nI+1,nDiff+2,'color',[.7 0 0]);
    else
      c.unit(nI+1,nDiff+2,'color',[0 0 0]);
    end

  end
  
end
c.colUnit(1,'align','left');
c.colUnit(1,'format','%s');
c.colUnit(2,'format','%.2f');
c.rowUnit(1,'format','%s');
c.colUnit(1,'paddingRight','30px');
c.colUnit(2,'align','right');

c.table('rules','rows');
c.table('frame','void');
c.table('bordercolor','white');

c = htmlAddTableBGColor(c,[.95 .95 .95;.9 .9 .9]);

processHtmlTable(c,fH);


