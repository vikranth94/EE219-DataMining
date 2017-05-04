clc;
clear all;
close all;

% Import the 100K Dataset
u = importdata('u.data');
x = size(u,1);
n_users = max(u(:,1));  
n_movies = max(u(:,2));

R = NaN(n_users,n_movies); % Usual R initialization
W = zeros(n_users,n_movies); % Usual w initialization

Rswap = zeros(n_users,n_movies); % Swapped R initialization
Wswap = zeros(n_users,n_movies); % Swapped W initialization


for i=1:x
    R(u(i,1),u(i,2)) = u(i,3);  % populate ratings matrix
    W(u(i,1),u(i,2)) = 1;       % weight = 1 if rating is available
end

for i=1:x
    Rswap(u(i,1),u(i,2)) = 1;  % Swapped R = Original W
    Wswap(u(i,1),u(i,2)) = u(i,3);  % Swapped W = Original R
end

k=[10, 50, 100]; % k values as given in question

lse1 = zeros(1,3);
residual1=zeros(1,3);

% Calculating LSE without Regularization
for y = 1:3
    [U,V,~,~,residual1(y)] = wnmfrulewithWL(Rswap,k(y),Wswap,0);
    UV1(:,:,y) = U*V;
    for i=1:943
        for j=1:1682
            lse1(y) = lse1(y) + Wswap(i,j)*(Rswap(i,j)-UV1(i,j,y))^2;
        end
    end
end

% Calculating LSE with Regularization
lambda = [.01, .1, 1]; 
lse2 = zeros(3,3);
residual2=zeros(3,3);
for y = 1:3
    for x = 1:3
        [U,V,~,~,residual2(y,x)] = wnmfrulewithWL(Rswap,k(y),Wswap,lambda(x));
        UV = U*V;
        interim1 = 0;
        interim2 = 0;
        for i = 1:943
            for j = 1:k(y)
                interim1 = interim1 + U(i,j)^2;
            end
        end
        for i = 1:k(y)
            for j = 1:1682
                interim2 = interim2 + V(i,j)^2;
            end
        end
        regularization = lambda(y)*(interim1+interim2);
        for i=1:943
            for j=1:1682
                lse2(y,x) = lse2(y,x) + Wswap(i,j)*(Rswap(i,j)-UV(i,j))^2;
            end
        end
        lse2(y,x) = lse2(y,x) + regularization;
    end
end