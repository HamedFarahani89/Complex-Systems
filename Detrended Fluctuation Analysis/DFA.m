clc
clear
close all
%First load your data then specify the minimum window and maximum window
%and the step you want have betwen min and max and also ord is the order of
% deterend 
load('westrs_dim_1_4.mat')
data = westrs_dim_1_4;

ord = 1;
stp = 100;
minWin = 10;
maxWin = 10000;
win = minWin: stp: maxWin;
yM = zeros(1,length(win));
tic
cnt = 1;
for i = win
    numWin = floor(length(data)/i);
    idxWin = i*numWin;
    yk = data(1:idxWin);
    
    ykr = cumsum(yk - mean(yk));
    yn = reshape(ykr,i,[]);
    xn = 1:i;
    ym = zeros(1,size(yn,2));
    
    for j = 1:size(yn,2)
        cof = polyfit(xn',yn(:,j),ord);
        yf = polyval(cof,xn);
        ym(j)  = rms(yn(:,j) - yf');    
    end
    yM(cnt) = mean(ym);
    cnt = cnt + 1;
end

A = polyfit(log(win),log(yM),1);
toc