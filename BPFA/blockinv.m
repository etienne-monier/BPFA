function Ainv=blockinv(A,patchsize)
%caculate the inversion of Block diagnal matrix
[n1,n2]=size(A);
Ainv=zeros(n1,n2);
nband=n1/patchsize^2;
for i=1:patchsize^2
Ainv((i-1)*nband+1:i*nband,(i-1)*nband+1:i*nband)=inv(A((i-1)*nband+1:i*nband,(i-1)*nband+1:i*nband));
end