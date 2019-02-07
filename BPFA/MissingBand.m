function [X Index MissIndex]=MissingBand(BandRatio,nBand,PatchSize,X,Index)
%withhold several band as missing band
tempbandind=randperm(nBand);
tempbandindex=false(nBand,1);
tempbandindex(tempbandind(1:ceil(BandRatio*nBand)))=1;
bandindex=repmat(tempbandindex,PatchSize^2,1);
X=X(bandindex,:);
Index=Index(bandindex,:);
MissIndex=~bandindex;