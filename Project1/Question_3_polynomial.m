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
x = [x2 x3 x4 x5];

K=10;
cv = cvpartition(numel(y), 'kfold',K);
mse2 = zeros(K,1);
mse3 = zeros(K,1);
mse4 = zeros(K,1);
mse5 = zeros(K,1);
mse6 = zeros(K,1);
mse7 = zeros(K,1);
mse8 = zeros(K,1);
mse9 = zeros(K,1);

for k=1:K
    % training/testing indices for this fold
    trainIdx = cv.training(k);
    testIdx = cv.test(k);
    
    %Train Model
    p2 = fitlm(x(trainIdx,:), y(trainIdx) , 'quadratic');
    p3 = fitlm(x(trainIdx,:), y(trainIdx) , 'poly3333');
    p4 = fitlm(x(trainIdx,:), y(trainIdx) , 'poly4444');
    p5 = fitlm(x(trainIdx,:), y(trainIdx) , 'poly5555');
    p6 = fitlm(x(trainIdx,:), y(trainIdx) , 'poly6666');
    p7 = fitlm(x(trainIdx,:), y(trainIdx) , 'poly7777');
    p8 = fitlm(x(trainIdx,:), y(trainIdx) , 'poly8888');
    p9 = fitlm(x(trainIdx,:), y(trainIdx) , 'poly8888');
    % predict regression output
    Y_hat2 = predict(p2, x(testIdx,:));
    Y_hat3 = predict(p3, x(testIdx,:));
    Y_hat4 = predict(p4, x(testIdx,:));
    Y_hat5 = predict(p5, x(testIdx,:));
    Y_hat6 = predict(p6, x(testIdx,:));
    Y_hat7 = predict(p7, x(testIdx,:));
    Y_hat8 = predict(p8, x(testIdx,:));
    Y_hat9 = predict(p9, x(testIdx,:));
    %compute mean squared error
    mse2(k) = mean((y(testIdx) - Y_hat2).^2);
    mse3(k) = mean((y(testIdx) - Y_hat3).^2);
    mse4(k) = mean((y(testIdx) - Y_hat4).^2);
    mse5(k) = mean((y(testIdx) - Y_hat5).^2);
    mse6(k) = mean((y(testIdx) - Y_hat6).^2);
    mse7(k) = mean((y(testIdx) - Y_hat7).^2);
    mse8(k) = mean((y(testIdx) - Y_hat8).^2);
    mse9(k) = mean((y(testIdx) - Y_hat9).^2);
end
% p2 = fitlm(x,y,'quadratic');
% p3 = fitlm(x,y,'poly3333');
% p4 = fitlm(x,y,'poly4444');
% p5 = fitlm(x,y,'poly5555');
% p6 = fitlm(x,y,'poly6666');
% p7 = fitlm(x,y,'poly7777');

mse = [mean(mse2) mean(mse3) mean(mse4) mean(mse5) mean(mse6) mean(mse7) mean(mse8) mean(mse9)];
plot (2:9, mse)
title('RMSE Plot')
xlabel('Degree of the polynomial')
ylabel('RMSE');