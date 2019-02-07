code by Zhengming Xing,Duke University,zx7@duke.edu
The code works on MATLAB R2009a


file list


Demo file
Deme.m   running file for HSI inpainting

main file:
BPFA_GP: main function to implement the Gaussian process BPFA algorithm

Datafile:
R1.mat: a 150*150*210 hyperspectral urban image.
URBAN.wvl:corresponding wavelength information for urban image

Subprogram:
VectorizePatch: verctorize the HSI
InpaintingOutput.m:reconstruct the hyper-image
blockinv.m: invert the block diagnal matrix
blockchol.m:cholesky decomposition for the block diagnal matrix
CovMatrix.m:caculate the covariance matrix for Gaussian Process
sparse_mult.m:Use sparse multiplication to eliminate unnecessary computation
MissingBand:withhold several bands as missing band
GP_predict: interpolate the dictionary corresponding to mising bands

