clc;
clear all;
close all;

% Import 100k Dataset
u = importdata('u.data');
len = length(u);
n_users = max(u(:,1));
n_movies = max(u(:,2));

% Initializations
cv = cvpartition(len , 'kfold' , 10);
k=[10 50 100];
trainidx = cv.training(3);
testidx = cv.test(3);
R = NaN(n_users,n_movies); 
training = u(trainidx,:);
test = u(testidx,:);
W = zeros(n_users,n_movies); 
x1 = length(training);
x2 = length(test);

for i=1:x1
    R(training(i,1),training(i,2)) = training(i,3);  % populate ratings matrix
    W(training(i,1),training(i,2)) = 1;       % weight = 1 if rating is available
end
%%
for z = 1:3
    [U,V,~,~,residual] = wnmfrule(R,k(z));
    UV = U*V;
    %%
    predict = zeros(1,x2);
    for i=1:x2
        predict(i) = UV(test(i,1),test(i,2));
    end
    
    % If Rating >3 then the user likes the movie. 
    target = test(:,3);
    target = target';
    target = target>3;
    
    %%
    thres = 1:0.5:5;
    l_t = length(thres);
    fprintf(' k = %i \n' , k(z));
    for i = 1:l_t
        Output = predict>thres(i);

        % Confusion Matrix
        C(:,:,i) = confusionmat(target,Output);  
        fprintf('threshold = %d \n', thres(i));
        
        % Calculating Precision, Recall, Accuracy and False postive rate
        Precision(z,i) = C(2,2,i)/(C(2,2,i) + C(1,2,i));
        Recall(z,i) = C(2,2,i)/(C(2,2,i) + C(2,1,i));
        fpr(z,i) = C(1,2,i)/(C(1,1,i) + C(1,2,i));
        Accuracy(z,i) = (C(1,1,i) + C(2,2,i))/(C(1,1,i) + C(1,2,i) + C(2,1,i)+ C(2,2,i));
        fprintf('\t Precision \t Recall \t Accuracy \n');
        fprintf('\t %f \t %f \t %f \n', Precision(i), Recall(i), Accuracy(i));
    end

    % Printing the values when threshold = 3
    C(:,:,5)
    fprintf('Total Number of predicted likes = %d \n', (C(2,2,5) + C(1,2,5)));
    fprintf('Total Number of actual likes = %d \n', (C(2,2,5) + C(2,1,5)));
    fprintf('\t %f \t %f \t %f \n', Precision(z,5), Recall(z,5), Accuracy(z,5));
end
%%

% Plotting ROC
figure;
plot(fpr(1,:),Recall(1,:),fpr(2,:),Recall(2,:),'--',fpr(3,:),Recall(3,:),'g','LineWidth',2);
xlabel('Flase Postive Rate');
ylabel('True Positive Rate');
title('Receiver Operating Characteristic (ROC) Curve');
legend('k=10','k= 50', 'k = 100')

% Plotting Precision vs Recall
figure;
plot(Precision(1,:),Recall(1,:),Precision(2,:),Recall(2,:),'--',Precision(3,:),Recall(3,:),'g','LineWidth',2);
xlabel('Recall');
ylabel('Precision');
title('Precision vs Recall');
legend('k=10','k= 50', 'k = 100')




