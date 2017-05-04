clc;
clear all;
close all;

% Import the 100K Dataset
u = importdata('u.data');
x = size(u,1);
n_users = max(u(:,1));  
n_movies = max(u(:,2));

% Generate R and W Matrices
R = NaN(n_users,n_movies); 
W = zeros(n_users,n_movies); 

for i=1:x
    R(u(i,1),u(i,2)) = u(i,3);  % R = rating if rated
    W(u(i,1),u(i,2)) = 1;       % weight = 1 if rating is available
end

k=[10, 50, 100]; % k values given in question
lse = zeros(1,3);
residual = zeros(1,3);

% Calculate LSE for different K values
for y = 1:3
    [U,V,~,~,residual(y)] = wnmfrule(R,k(y));  % ALS Decomposition
    UV = U*V;
    for i = 1:n_users
        for j = 1:n_movies
            if isnan(R(i,j))==0
                lse(y) = lse(y) + W(i,j)*(R(i,j)-UV(i,j))^2;
            end
        end
    end
    
end
lse
residual
