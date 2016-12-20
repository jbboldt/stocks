%function x = getDkInterestRate

cW = weeknum(now);
cY = year(now);

str = 'http://www.realkreditraadet.dk/Admin/Public/DWSDownload.aspx?File=%2fFiles%2fFiler%2f5+Statistikker%2fObligationsrente%2f2015+Obligationsrente%2fObligationsrente_RKR_uge';
eM = 'error';

while ~isempty(eM) 
    eM = [];
    uStr = [str,num2str(cW),'_',num2str(cY),'.xlsx'];
    try
        dU = urlwrite(uStr,'data.xlsx');
    catch eM
    end
    cW = cW-1;
end

d = xlsread(dU);

S(1).sdn = data.Time+datenum(data.TimeInfo.StartDate);
S(1).data = data.Data;

