clc;
clear all;
close all;

% Import the 100K Dataset
u = importdata('u.data');
len = length(u);
n_users = max(u(:,1));
n_movies = max(u(:,2));

% Cross Validation Indices and Data
cv = cvpartition(len , 'kfold' , 10);
k=[10 50 100];
lambda = [0.01 0.1 1];
trainidx = cv.training(3);
testidx = cv.test(3);
R = zeros(n_users, n_movies);
W = zeros(n_users, n_movies);
training = u(trainidx,:);
test = u(testidx,:);
x1 = length(training);
x2 = length(test);

for i=1:x1
    R(training(i,1),training(i,2)) = training(i,3);  % populate ratings matrix
    W(training(i,1),training(i,2)) = 1;       % weight = 1 if rating is available
end


%%
% Setting the target values
target = test(:,3);
target = target';
target = target>3;

%%

% Plot ROC for different lambda and k values
for n=1:3
    for j=1:3
        [U,V,~,~,residual] = wnmfrulewithWL(R,k(j),W,lambda(n));
        UV(:,:,j) = U*V;
        predict = zeros(j,x2);
        for i=1:x2
            predict(j,i) = UV(test(i,1),test(i,2),j);
        end
        output(j,:) = predict(j,:)/5;
        j
    end
    output(output>1) = 1;
    [tpr1,fpr1,thresholds] = roc(target,output(1,:));
    [tpr2,fpr2,thresholds] = roc(target,output(2,:));
    [tpr3,fpr3,thresholds] = roc(target,output(3,:));
    figure;
    plot(fpr1,tpr1,fpr2,tpr2,'--',fpr3,tpr3,'g','LineWidth',2);
    xlabel('Flase Postive Rate');
    ylabel('True Positive Rate');
    title(['ROC for Lambda = ' num2str(lambda(n))]);
    legend('k=10','k= 50', 'k = 100')
end

