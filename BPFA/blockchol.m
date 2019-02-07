function Achol=blockchol(A,patchsize)
%caculate the cholesky decomposition of block diagnal matrix
[n1,n2]=size(A);
Achol=zeros(n1,n2);
nband=n1/patchsize^2;
for i=1:patchsize^2
Achol((i-1)*nband+1:i*nband,(i-1)*nband+1:i*nband)=chol(A((i-1)*nband+1:i*nband,(i-1)*nband+1:i*nband));
end