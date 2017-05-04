function [A,Y,numIter,tElapsed,finalResidual]=wnmfrulewithWL(X,k,W,lambda,option)
% Weighted NMF based on multiple update rules for missing values: X=AY, s.t. A,Y>=0.Both basis matrix and coefficient matrix are constrained by
% l_2 and l_1 norm.
% Definition:
%     [A,Y,numIter,tElapsed,finalResidual]=wnmfrule(X,k)
%     [A,Y,numIter,tElapsed,finalResidual]=wnmfrule(X,k,option)
% X: non-negative matrix, dataset to factorize, each column is a sample,
% and each row is a feature. A missing value is represented by 0.
% k: number of clusters.
% W: Weight matrix
% lambda: regularization term
% option: struct:
% option.distance: distance used in the objective function. It could be
%    'ls': the Euclidean distance (defalut),
%    'kl': KL divergence.
% option.iter: max number of interations. The default is 1000.
% option.dis: boolen scalar, It could be 
%     false: not display information,
%     true: display (default).
% option.residual: the threshold of the fitting residual to terminate. 
%    If the ||X-XfitThis||<=option.residual, then halt. The default is 1e-4.
% option.tof: if ||XfitPrevious-XfitThis||<=option.tof, then halt. The default is 1e-4.
% A: matrix, the basis matrix.
% Y: matrix, the coefficient matrix.
% numIter: scalar, the number of iterations.
% tElapsed: scalar, the computing time used.
% finalResidual: scalar, the fitting residual.
%%%%

tStart=tic;
optionDefault.distance='ls';
optionDefault.iter=1000;
optionDefault.dis=true;
optionDefault.residual=1e-4;
optionDefault.tof=1e-4;
if nargin<5
   option=optionDefault;
else
    option=mergeOption(option,optionDefault);
end
 
% iter: number of iterations
[r,c]=size(X); % c is # of samples, r is # of features
Y=rand(k,c);
% Y(Y<eps)=0;
Y=max(Y,eps);
A=X/Y;
% A(A<eps)=0;
A=max(A,eps);
%disp(size(A));
%disp(size(X));
%disp(size(Y));
XfitPrevious=Inf;
for i=1:option.iter
    switch option.distance
        case 'ls'
            A=A.*(((W.*X)*Y')./((W.*(A*Y))*Y'+lambda.*A));
%             A(A<eps)=0;
                A=max(A,eps);
            Y=Y.*((A'*(W.*X))./(A'*(W.*(A*Y))+lambda.*Y));
%             Y(Y<eps)=0;
                Y=max(Y,eps);
        case 'kl'
            A=(A./(W*Y')) .* ( ((W.*X)./(A*Y))*Y');
            A=max(A,eps);
            Y=(Y./(A'*W)) .* (A'*((W.*X)./(AY)));
            Y=max(Y,eps);
        otherwise
            error('Please select the correct distance: option.distance=''ls''; or option.distance=''kl'';');
    end
    if mod(i,10)==0 || i==option.iter
        if option.dis
           % disp(['Iterating >>>>>> ', num2str(i),'th']);
        end
        XfitThis=A*Y;
        fitRes=matrixNorm(W.*(XfitPrevious-XfitThis));
        XfitPrevious=XfitThis;
        curRes=norm(W.*(X-XfitThis),'fro');
        if option.tof>=fitRes || option.residual>=curRes || i==option.iter
            s=sprintf('Mutiple update rules based NMF successes! \n # of iterations is %0.0d. \n The final residual is %0.4d.',i,curRes);
            disp(s);
            numIter=i;
            finalResidual=curRes;
            break;
        end
    end
end
tElapsed=toc(tStart);
end
