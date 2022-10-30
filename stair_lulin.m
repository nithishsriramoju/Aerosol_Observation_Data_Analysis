clear ;clc;
Filename = ('BC Data_Lulin.xlsx');
A = readtable(Filename);
%%%%Winter = 12 & 1 & 2;
%%%%Spring = 3 & 4 & 5;
%%%%Summer = 6 & 7 & 8;
%%%%Fall  = 9 & 10 & 11;
[win,~] = find(( A.Mon == 12)|(A.Mon == 1)|(A.Mon == 2));
x = A.conc_6_(win);
bin  = [-310:50:2036];
count = hist(x,bin);
[spr,~] = find(( A.Mon == 3)|(A.Mon == 4)|(A.Mon == 5));
y = A.conc_6_(spr);
count1 = hist(y,bin);
[sum,~] = find(( A.Mon == 6)|(A.Mon == 7)|(A.Mon == 8));
p = A.conc_6_(sum);
count2 = hist(p,bin);
[fall,~] = find(( A.Mon == 9)|(A.Mon == 10)|(A.Mon == 11));
q = A.conc_6_(fall);
count3 = hist(q,bin);
[xb,yb] = stairs(bin,count);
[xa,ya] = stairs(bin,count1);
[xc,yc] = stairs(bin,count2);
[xd,yd] = stairs(bin,count3);
hold on
plot(xb,yb,'LineWidth',2);
plot(xa,ya,'LineWidth',2);
plot(xc,yc,'LineWidth',2);
plot(xd,yd,'LineWidth',2);
hold off

