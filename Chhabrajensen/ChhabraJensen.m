clc
clear
close all

Timeseries = [1 2 1 5 3 2 9 1];
qValues = [-3 -2 -1 0 1 2 3];
scales  = [1 2 3];

for i = 1:length(qValues)
    q = qValues(i);
    for j = 1:length(scales)
        %for the i-th qValue and j-th scale:
        window = 2^scales(j);
        
        %break the time series into windows & sum
        TimeseriesReshaped = reshape(Timeseries,[],window);
        TimeseriesSummed  =sum(Timeseries);
        
        %calculate p
        ps = sum(TimeseriesReshaped,1);
        p = ps./TimeseriesSummed;
        Nor = sum(p.^q);
        mu = (p.^q)/Nor;
        
        
        if q<=1 && q>0
            Md(j) = sum(p.*log10(p))/Nor;
        else
            Md(j) = log10(Nor);
        end
        
        Ma(j) = sum(mu.*log10(p));
        Mf(j) = sum(mu.*log10(mu));
        
        muScales(j) = -log10(2^scales(j));
    end
    xMd = polyfit(muScales, Md, 1);
    
    if q<=1 && q>0
        slpMd(i) = xMd(1);
    else
        slpMd(i) = xMd(1)/(q-1);
    end
    
    xMa = polyfit(muScales, Ma, 1);
    slpMa(i) = xMa(1);
    
    xMf = polyfit(muScales, Mf, 1);
    slpMf(i) = xMf(1);
end

scatter(slpMa,slpMf)
figure
scatter(qValues,slpMd)