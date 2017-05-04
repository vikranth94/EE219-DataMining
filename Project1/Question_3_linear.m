clc;
clear all;
close all;
data = importdata('network_backup_dataset.csv');
data.textdata =  data.textdata(2:end , :);
l = length(data.textdata);
%data.data = [data.data zeros(l,1)]
x2 = zeros(l,1);
x1 = str2double(data.textdata(:,1)); % week number

for i=1:l
    if(strcmp(data.textdata(i,2),'Monday'))
        x2(i) = 1;
    elseif(strcmp(data.textdata(i,2),'Tuesday'))
        x2(i) = 2;
    elseif(strcmp(data.textdata(i,2),'Wednesday'))
        x2(i) = 3;
    elseif(strcmp(data.textdata(i,2),'Thursday'))
        x2(i) = 4;
    elseif(strcmp(data.textdata(i,2),'Friday'))
        x2(i) = 5;
    elseif(strcmp(data.textdata(i,2),'Saturday'))
        x2(i) = 6;
    elseif(strcmp(data.textdata(i,2),'Sunday'))
        x2(i) = 7;
    end
end  % Day of the week

x3 = str2double(data.textdata(:,3)); % backup start time

x4= zeros(l,1);
x5 = zeros(l,1);
for i= 1:l
    temp1 = char(data.textdata(i,4));
    temp2 = char(data.textdata(i,5));
    x4(i) = str2double(temp1(end:end)); % extracting workflow id
    
    l2 = length(temp2);
    if(l2 == 6)
        x5(i) = str2double(temp2(end:end));
    elseif(l2 ==7)
        x5(i) = str2double(temp2(end-1:end)); % extracting file name
    end
end

y= data.data(:,1);
x = [x1 x2 x3 x4 x5 y];

workload_0 = x4==0;
workload_1 = x4==1;
workload_2 = x4==2;
workload_3 = x4==3;
workload_4 = x4==4;
workload_0_data = x(workload_0, :);
workload_1_data = x(workload_1, :);
workload_2_data = x(workload_2, :);
workload_3_data = x(workload_3, :);
workload_4_data = x(workload_4, :);

lm_0 = fitlm(workload_0_data(:,[1:3 5]),workload_0_data(:,6),'linear');
lm_0
lm_1 = fitlm(workload_1_data(:,[1:3 5]),workload_1_data(:,6),'linear');
lm_1
lm_2 = fitlm(workload_2_data(:,[1:3 5]),workload_2_data(:,6),'linear');
lm_2
lm_3 = fitlm(workload_3_data(:,[1:3 5]),workload_3_data(:,6),'linear');
lm_3
lm_4 = fitlm(workload_4_data(:,[1:3 5]),workload_4_data(:,6),'linear');
lm_4