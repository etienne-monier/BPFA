
warning('off','all')

% this file should contain the Y matrix, the mask, PatchSize, Omega, K,
% iter.

% % Patch size (typical 2,4)
% PatchSize=9;
% %GP parameter (typically set this number close to the wavelength)
% Omega=1;
% %dictionary size(typical 128 ,256)
% K=128;
% %number of iteration
% iter=100;

Y = double(Y);
Omega = double(Omega);
K = double(K);
Step = double(Step);

disp(['Step is ' num2str(Step)])

start = tic;
%% vectorize HSI
disp('Vectorizes patches ...')
[X Index Itab Jtab]=VectorizePatch(Y,mask,PatchSize,Step);

%compute the covariance matrix
[R Ron Rn]=CovMatrix(1:size(Y,3),Omega,PatchSize,false(size(Y,3)*PatchSize^2,1),PatchSize^2*size(Y,3));

%gp 
disp('BPFA ...')
[A S Z tao] = BPFA_GP(X,Index,R,K,PatchSize,iter);

%reconstruct the HSI
imHat = A*(Z.*S)';

%reconstruct the hyper-image
disp('Reconstructing data ...')
[Xhat]=InpaintingOutput(imHat,PatchSize,size(Y,1),size(Y,2), Itab, Jtab);

time = toc(start);

disp('Saving data ...')
save(outName,'Xhat','time')

% figure,
% subplot(131),imagesc(Y), axis image,
% subplot(132),imagesc(Y.*mask), axis image,
% subplot(133),imagesc(Xhat), axis image

