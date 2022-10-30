clear all;
Filename = ('Sunphotometer_2009-2016_Fine&Coarse_Hyd.xlsx');
A = readtable(Filename);
boxplot(A.AOD500,A.Year);
title('Sunphotometer Data')
xlabel('Year')
ylabel('AOD500')
saveas(gcf,'AOD500.jpg')
figure;
boxplot(A.Alpha,A.Year);
title('Sunphotometer Data')
xlabel('Year')
ylabel('Alpha(500-870)')
saveas(gcf,'Alpha(500-870).jpg')
figure;
boxplot(A.BC880,A.Year);
title('Sunphotometer Data')
xlabel('Year')
ylabel('BC880')
saveas(gcf,'BC880.jpg')

figure;
boxplot(A.AOD500(573:660),A.group(573:660));


File = ('Sunphotometer_Dailymean AOD_Hyderabad.xlsx');
B = readtable(File);
figure;
boxplot(B.AOT380,B.Year);
title('Sunphotometer Data')
xlabel('Year')
ylabel('AOD380')
saveas(gcf,'AOD380.jpg')
figure;
boxplot(B.AOT440,B.Year);
title('Sunphotometer Data')
xlabel('Year')
ylabel('AOD440')
saveas(gcf,'AOD440.jpg')
figure;
boxplot(B.AOT500,B.Year);
title('Sunphotometer Data')
xlabel('Year')
ylabel('AOD500')
saveas(gcf,'AOD500_Daily.jpg')
figure;
boxplot(B.AOT675,B.Year);
title('Sunphotometer Data')
xlabel('Year')
ylabel('AOD675')
saveas(gcf,'AOD675.jpg')
figure;
boxplot(B.AOT870,B.Year);
title('Sunphotometer Data')
xlabel('Year')
ylabel('AOD870')
saveas(gcf,'AOD870.jpg')



