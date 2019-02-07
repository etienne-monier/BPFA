function [X Index Itab Jtab]=VectorizePatch(XX,mask,PatchSize,Step)
%sample data and vectorize HSI
%sample DataRatio% of the data

% Get data size
[n1 n2 n3]=size(XX);

% Create 3D mask
mask3 = repmat(mask,[1 1 n3]);

% Sub-sampling
% XX = mask3.*XX;

% Indices for iteration
% Along I
Itab = 1:Step:(n1-PatchSize+1);
if Itab(end)~=(n1-PatchSize+1) Itab = [Itab n1-PatchSize+1]; end
% Along j
Jtab = 1:Step:(n2-PatchSize+1);
if Jtab(end)~=(n2-PatchSize+1) Jtab = [Jtab n2-PatchSize+1]; end
% lengths
Ni = length(Itab);
Nj = length(Jtab);

% Data matrix
X=zeros(PatchSize^2*n3,Ni*Nj);
Index=true(size(X));

tmp = zeros(n1,n2);

ind = 1;
for j=Jtab
    for i=Itab
        
        temp=XX(i:i+PatchSize-1,j:j+PatchSize-1,:);
        tempz=mask3(i:i+PatchSize-1,j:j+PatchSize-1,:);
        
        temp1 = permute(temp,[3,2,1]);
        temp2 = permute(tempz,[3,2,1]);

        X(:,ind)=sparse(temp1(:));
        Index(:,ind)=temp2(:);
        
        ind = ind+1;
        tmp(i:i+PatchSize-1,j:j+PatchSize-1) = tmp(i:i+PatchSize-1,j:j+PatchSize-1) + ones(PatchSize,PatchSize);
    end
end

Index=sparse(Index);
