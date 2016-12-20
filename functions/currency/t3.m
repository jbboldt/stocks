%C=getCurrencyData;

for idx=1:length(C);
	C(idx).USDDKK = C(idx).USD^-1.*C(idx).DKK;
	C(idx).USDEUR = C(idx).USD^-1;
end
%

