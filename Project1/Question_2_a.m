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
x = [x1 x2 x3 x4 x5];

% Model1 = fitrlinear(x,y,'kfold',10, 'Learner', 'leastsquares');
% 
% L = kfoldLoss(Model1,'Mode', 'individual')

K=10;
cv = cvpartition(numel(y), 'kfold',K);
mse = zeros(K,1);

for k=1:K
    % training/testing indices for this fold
    trainIdx = cv.training(k);
    testIdx = cv.test(k);
    
    %Train Model
    lm = fitlm(x(trainIdx,:), y(trainIdx) , 'linear');
    lm
    % predict regression output
    Y_hat = predict(lm, x(testIdx,:));
    %compute mean squared error
    mse(k) = mean((y(testIdx) - Y_hat).^2);
end

rmse = mean(mse)
plot(1:10,mse)
xlabel('Learning Cycle')
ylabel('10-fold cross validated MSE')

lm_final = fitlm(x,y, 'linear');
Y_hat = predict(lm, x);

figure;
scatter(1:l,y,8,'b')
hold;
scatter(1:l,Y_hat,8,'r')
xlabel('Time');
ylabel('File Size');
title('Actual and Fitted Values');
legend('Actual','Fitted');

figure;
scatter(Y_hat,y-Y_hat,10,'filled')
xlabel('Fitted values');
ylabel('Residuals');
title('Residuals versus Fitted Values');

    