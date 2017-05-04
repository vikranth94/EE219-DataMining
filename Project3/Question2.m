clc;
clear all;
close all;

% Import the 100K Dataset
u = importdata('u.data');
len = size(u,1);
n_users = max(u(:,1));  
n_movies = max(u(:,2));

cv = cvpartition(len, 'kfold',10);  % 10 fold Crossvalidation
R = NaN(n_users,n_movies); % Initializing R matrix
avgerror = zeros(10,3);
residual=zeros(10,3);
k=[10, 50, 100]; % k values
error = zeros(10,3) ;
for K = 1:10
    trainidx = cv.training(K);
    disp(K);
    for i=1:len
        if (trainidx(i) == 1)
            R(u(i,1),u(i,2)) = u(i,3);
        end
    end
    
    
    % Calculating Absolute and Average Errors
    [U,V,~,~,residual(K,1)] = wnmfrule(R,k(1));
    UV_10 = U*V;
    
    [U,V,~,~,residual(K,2)] = wnmfrule(R,k(2));
    UV_50 = U*V;
    
    [U,V,~,~,residual(K,3)] = wnmfrule(R,k(3));
    UV_100 = U*V;
    
    testidx = cv.test(K);
    for i=1:len
        if (testidx(i) == 1)
            error(K,1) = error(K,1)+ abs(UV_10(u(i,1),u(i,2))  - u(i,3));
            error(K,2) = error(K,2)+ abs(UV_50(u(i,1),u(i,2))  - u(i,3));
            error(K,3) = error(K,3)+ abs(UV_100(u(i,1),u(i,2))  - u(i,3));
        end
    end
    
    for i = 1:3
        avgerror(K,i) = error(K,i)/numel(testidx(testidx==1));
    end
    
end

