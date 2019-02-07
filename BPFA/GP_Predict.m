function [A_pre]=GP_Predict(A,R,Ron,Rn,tao,PatchSize,K) 
%caculate the dictionaries(A) for missing band, only use the mean here.
%written by Zhengming Xing,Duke University,zx7@duke.edu
RR=blockinv(R,PatchSize);
for j=1:K
    A_pre(:,j)=Ron*RR*((A(:,j)));
    A_pre_v=tao(j)*(Rn-Ron*RR*Ron');
    % A_sample(:,j)=chol(A_pre_v)*randn(n4,1)+A_pre(:,j);
end
