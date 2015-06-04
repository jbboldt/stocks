%str=urlread('http://fxtop.com/en/historical-exchange-rates.php?A=1&C1=DKK&C2=EUR&DD1=01&MM1=12&YYYY1=2013&B=1&P=&I=1&DD2=18&MM2=12&YYYY2=2013&btnOK=Go%21')


% str=urlread('http://fxtop.com/xml/xml_histo.php?C1=DKK&C2=EUR&CLIENT=FXTOP&PWD=ForTestOnFxtop.com&DD1=01&MM1=12&YYYY1=2013&DD2=18&MM2=12&YYYY2=2013&FORMAT=XML&button=+Retrieve+historical+rates+')
% str=xmlread(' http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml');

ecb=xmlread('http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist.xml');

ge=xml2struct(ecb);

clear C

nE = length(ge.gesmes_colon_Envelope.Cube.Cube);
nC = length(ge.gesmes_colon_Envelope.Cube.Cube{1}.Cube);

for n=1:nE
	invIdx = nE-n+1;
	
	C(n).date = ge.gesmes_colon_Envelope.Cube.Cube{invIdx}.Attributes.time;
	C(n).sdn = datenum(C(n).date);
	
	nC = length(ge.gesmes_colon_Envelope.Cube.Cube{invIdx}.Cube);
	for c=1:nC
		cur = ge.gesmes_colon_Envelope.Cube.Cube{invIdx}.Cube{c}.Attributes.currency;
		val = str2num(ge.gesmes_colon_Envelope.Cube.Cube{invIdx}.Cube{c}.Attributes.rate);
		C(n).(cur) = val;
	end
end

%%
nL = 250;
plot([C(end-nL:end).sdn],[C(end-nL:end).USD].^-1.*[C(end-nL:end).DKK]*100);
datetick('x');
