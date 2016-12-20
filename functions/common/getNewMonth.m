function newMonth = getNewMonth(dnum)

idx=abs(sign([0;diff(month(dnum))]));
mdn=dnum(find(idx==1));
newMonth=mdn;