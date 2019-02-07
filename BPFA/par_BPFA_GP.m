function [A S Z tao] =BPFA_GP(X,Index,R,K,PatchSize,iter)
%main function for Gaussian process BPFA algorithm
%written by Zhengming Xing,Duke University,zx7@duke.edu
[P N]=size(X);
%%hyper-parameters setting
%hyper-parameters for pi (usaully set b0 to a large number)
a0=1;
b0=N/4;
%hyper-parameters for phi
c0=10e-6;
d0=10e-6;
%hyper-parameters for alpha
e0=10e-6;
f0=10e-6;
%hyper-parameters for tao
a1=10e-6;
b1=10e-6;
%initialize the latent variables
A=randn(P,K);
S=randn(N,K);
Z=false(N,K);
Pi=ones(K,1);
alpha=1;
phi=1;
RR=blockinv(R,PatchSize);
tao=ones(K,1);

it=0;

TmpCellX = cell(K,1)
TmpCellX2 = cell(K,1)
TmpCellZ = cell(K,1)

myPool = parpool('local', 3);

%Gibbs sampling part
while it<iter
    localStart = tic;
    it=it+1;
    
    %sample A
  
    X_k=Index.*X-Index.*(A*(Z.*S)');
    
    
    parfor j=1:K
        tmp = X_k(:,Z(:,j)) + sparse_mult(Index(:,Z(:,j)),A(:,j),S(Z(:,j),j));
        sig_A=P*RR*tao(j)+diag(phi*Index(:,Z(:,j))*(S(Z(:,j),j).^2));
        sig_A=blockinv(sig_A,PatchSize);
        mu_A=phi*sig_A*(X_k(:,Z(:,j))*S(Z(:,j),j));
        A(:,j)=blockchol(sig_A,PatchSize)*randn(P,1)+mu_A;
        tmp2 = tmp - sparse_mult(Index(:,Z(:,j)),A(:,j),S(Z(:,j),j));
        TmpCellX{j} = tmp2;
    end
    for j=1:K
        X_k(:,Z(:,j)) = TmpCellX{j};
    end

    
    % sample Z
    
    parfor j=1:K
        tmpX = X_k
        tmpX(:,Z(:,j)) = X_k(:,Z(:,j)) + sparse_mult(Index(:,Z(:,j)),A(:,j),S(Z(:,j),j));
        tempz1=((A(:,j).^2)'*Index)';
        tempz2=(A(:,j)'*X_k)';
        tempz=-(S(:,j).^2.*tempz1/2-S(:,j).*tempz2)*phi;
        tempz=exp(tempz)*Pi(j);
        tmpZ=rand(N,1)>((1-Pi(j))./(tempz+1-Pi(j)));
        tmpX =(:,Z(:,j)) tmpX(:,Z(:,j)) -sparse_mult(Index(:,tmpZ),A(:,j),S(tmpZ,j));
        
        TmpCellZ{j} = tmpZ
        TmpCellX{j}=tmpX;
    end
    for j=1:K
        X_k(:,Z(:,j)) = TmpCellX{j}
        Z(:,j) = TmpCellZ{j}
        
    end

    % sample S
    
    parfor j=1:K
        X_k(:,Z(:,j)) = X_k(:,Z(:,j)) + sparse_mult(Index(:,Z(:,j)),A(:,j),S(Z(:,j),j));
        numz=nnz(Z(:,j));
        temps1=((A(:,j).^2)'*Index(:,Z(:,j)))';
        temps2=(A(:,j)'*X_k(:,Z(:,j)))';
        sig_s=1./(alpha*ones(numz,1)+phi*temps1);
        mu_s=phi*sig_s.*temps2;
        S(Z(:,j),j)=randn(numz,1).*sqrt(sig_s)+mu_s;
        S(~Z(:,j),j)=randn(N-numz,1).*sqrt(1./alpha);
        X_k(:,Z(:,j)) = X_k(:,Z(:,j)) - sparse_mult(Index(:,Z(:,j)),A(:,j),S(Z(:,j),j));
    end

    
    %sample alpha phi Pi
    ai=a0+sum(Z,1);
    bi=b0+N-sum(Z,1);
    Pi=betarnd(ai,bi);
    ci=c0+1/2*sum(sum(Index));
    di=d0+1/2*sum(sum((Index.*X-Index.*(A*(Z.*S)')).^2));
    phi=gamrnd(ci,1./di);
    ei=e0+K*N/2;
    fi=f0+1/2*sum(sum(S.^2));
    alpha=gamrnd(ei,1./fi);
    %updata tao
    ai1=a1+P/2;
    for j=1:K
        bi1=b1+A(:,j)'*RR*P*A(:,j)/2;
        tao(j)=gamrnd(ai1,1/bi1);
    end
    time=toc(localStart);
    disp(['iter:' num2str(it)  '         '  'time:' num2str(time)]);
end

delete(myPool);
