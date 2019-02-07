clear all;close all;clc;
%load the data
load R1;
rand('state',0);
fid=fopen('URBAN.wvl');
waveinfo=textscan(fid,'%d%d%d%d');
fclose(fid);
bandind=logical(waveinfo{4});
WaveLength=waveinfo{2}(bandind);
R1=double(R1(:,:,bandind));
[n1 n2 nBand]=size(R1);
IMin0=R1;

%take 2% of the data and use 100% of the bands (take 5%of the data can get better result)
DataRatio=0.02;
BandRatio=1;
%patch size (typical 2,4)
PatchSize=2;
%GP parameter (typically set this number close to the wavelength)
Omega=200;
%dictionary size(typical 128 ,256)
K=128;
%number of iteration
iter=100;


%take DataRatio% of the data and vectorize HSI
[X Index]=VectorizePatch(R1,DataRatio,PatchSize);
%withhold (1-BandRatio)*100% of  bands as missing band
[X Index MissIndex]=MissingBand(BandRatio,nBand,PatchSize,X,Index);
%compute the covariance matrix
[R Ron Rn]=CovMatrix(WaveLength,Omega,PatchSize,MissIndex);
%gp 
[A S Z tao] =BPFA_GP(X,Index,R,K,PatchSize,iter);
%reconstruct the hyper-image
[rec_image]=InpaintingOutput(A,S,Z,PatchSize,n1,n2);

%plot the result and caculated the PSNR
if BandRatio==1
PSNR=20*log10(max(max(max(IMin0)))/sqrt(mean((rec_image(:)-IMin0(:)).^2)));
maxval=max(max(max(IMin0)));
clim=[0 maxval];
figure;
subplot(1,2,1); imagesc(IMin0(:,:,20),clim); title('Original image');colorbar;
subplot(1,2,2); imagesc(rec_image(:,:,20),clim); title(['Restored image, ',num2str(PSNR),'dB']);colorbar;
figure;
subplot(1,2,1); imagesc(IMin0(:,:,100)); title('Original image');colorbar
subplot(1,2,2); imagesc(rec_image(:,:,100)); title(['Restored image, ',num2str(PSNR),'dB']);colorbar
else
[A_pre]=GP_Predict(A,R,Ron,Rn,tao,PatchSize,K);
[rec_missing_band]=InpaintingOutput(A_pre,S,Z,PatchSize,n1,n2);
[rec_image]=InpaintingOutput(A,S,Z,PatchSize,n1,n2);
maxval=max(max(max(IMin0)));
clim=[0 maxval];
MissBand=MissIndex(1:nBand);
IMin1=IMin0(:,:,~MissBand);
IMin2=IMin0(:,:,MissBand);
PSNR=20*log10(max(max(max(IMin1)))/sqrt(mean((rec_image(:)-IMin1(:)).^2)));
PSNR_missing=20*log10(max(max(max(IMin2)))/sqrt(mean((rec_missing_band(:)-IMin2(:)).^2)));
figure;
subplot(1,2,1); imagesc(IMin2(:,:,1),clim); title('Original band');colorbar;
subplot(1,2,2); imagesc(rec_missing_band(:,:,1),clim); title(['Restored band, ',num2str(PSNR_missing),'dB']);colorbar;
figure;
subplot(1,2,1); imagesc(IMin2(:,:,end),clim); title('Original Band');colorbar;
subplot(1,2,2); imagesc(rec_missing_band(:,:,end),clim); title(['Restored band, ',num2str(PSNR_missing),'dB']);colorbar;
end
