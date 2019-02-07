function DSsparse = sparse_mult(Yflag,D,S)
%DSsparse = (D*S').*Yflag;
%Use sparse multiplication to eliminate unnecessary computation
%Version 1: 12/01/2009
%Written by Mingyuan Zhou, Duke ECE, mz1@ee.duke.edu
[P,N]=size(Yflag);
DSsparse = sparse(1:P,1:P,double(D(:,1)))*Yflag*sparse(1:N,1:N,double(S(:,1)));
for k=2:size(D,2)
    DSsparse = DSsparse+ sparse(1:P,1:P,double(D(:,k)))*Yflag*sparse(1:N,1:N,double(S(:,k)));
end