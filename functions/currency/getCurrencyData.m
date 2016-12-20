function C = getCurrencyData;

ecb = xmlread('http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist.xml');

ge=xml2struct(ecb);

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
