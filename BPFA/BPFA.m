function [Xhat] = BPFA(Y, mask, PatchSize, varargin)
%Beta Process Factor Analysis function.
% 
% Args:
%     Y (2D or 3D double array): The (possibly multi-band) image. Note that in the
%       case of a 3D image, the last dimension is the spectrum axis.
%     mask (2D logical array): The sampling mask. true means the pixel has
%       been acquired. false means it did not.
%     PatchSize (int): The patch width (and height).
%  
% Keyword Args:
%     iter (int): The number of iterations. Default is 100.
%     K (int): The number of dictionaries. Default is 128.
%     step (int): The step number (see note). Default is 1.
%
% Returns:
%     Xhat (2D or 3D double array): The reconstructed array.
%
% Note:
%     In the case of really big images, one has to reduce computational
%     costs (at least when the processing exceeds 1h15m). Two methods are
%     possible:
%           1. Reduce the Patch size.
%           2. Reduce the number of patches.
%
%     The second point is made possible by not taking all the possible patches, i.e. 
%     by reducing overlaping. The step optional parameter set the number of pixels 
%     between two patches in both x and y dimensions. Setting a higher
%     value of step will reduce computational cost but it will also degrade
%     the reconstruction.
%
% Example:
%     Xhat = BPFA(Y, mask, 15)
%     Xhat = BPFA(Y, mask, 15, 'iter', 50)
%     Xhat = BPFA(Y, mask, 15, 'iter', 50, 'step', 3)
%
% Author and License:
%     This code was improved by Etienne Monier
%     (https://github.com/etienne-monier) based on a code developed by Zhengming Xing,
%     Duke University (https://zmxing.github.io/).
%
%     The previous code did not have any license. Then, this repository is
%     shared under MIT License.

% Input arguments ------------------------------

% Default values
defaultIter = 100;
defaultK = 128;
defaultStep = 1;

p = inputParser;

% Y data
validationFcn = @(x) (ndims(x) == 2 || ndims(x) == 3) && isnumeric(x) && isa(x,'double');
addRequired(p,'Y',validationFcn);

% mask
validationFcn = @(x) (ndims(x) == 2) && islogical(x);
addRequired(p,'mask',validationFcn);

% PatchSize
validationFcn = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addRequired(p,'PatchSize',validationFcn);

% iter
validationFcn = @(x) isnumeric(x) && isscalar(x) && (x > 0);
addParameter(p,'iter',defaultIter,validationFcn);

% K
validationFcn = @(x) (x > 0) && isnumeric(x) && isscalar(x) ;
addParameter(p,'K',defaultK,validationFcn);

% step
validationFcn = @(x) (x > 0) && isnumeric(x) && isscalar(x) ;
addParameter(p,'step',defaultStep,validationFcn);

% Parsing input
parse(p,Y, mask, PatchSize, varargin{:});

% Required
Y = p.Results.Y;
mask = p.Results.mask;
PatchSize = p.Results.PatchSize;
iter = p.Results.iter;
K = p.Results.K;
Step = p.Results.step; 
Omega = 1;

% Disable warnings
warning('off','all')


% Running algorithm ----------------------------------------------

start = tic;

% Vectorize HSI
disp('Vectorizes patches ...')
[X Index Itab Jtab]=VectorizePatch(Y,mask,PatchSize,Step);

% Compute the covariance matrix
[R Ron Rn]=CovMatrix(1:size(Y,3),Omega,PatchSize,false(size(Y,3)*PatchSize^2,1),PatchSize^2*size(Y,3));

% GBPFA 
disp('BPFA ...')
[A S Z tao] = BPFA_GP(X,Index,R,K,PatchSize,iter);

% Reconstruct the HSI
imHat = A*(Z.*S)';

% Reconstruct the hyper-image
disp('Reconstructing data ...')
[Xhat]=InpaintingOutput(imHat,PatchSize,size(Y,1),size(Y,2), Itab, Jtab);

% Get time ...
time = toc(start);

h = floor(time/3600);
r = time-3600*h;
m = floor(r/60);
s = r - 60*m;

if h ~=0 
    text = sprintf('%2uh %2um %2.1fs', h, m, s);
elseif h==0 && m~=0
    text = sprintf('%2um %2.1fs', m, s);
else
    text = sprintf('%2.1fs', s); 
end
disp (['Elapsed time: ' text]);

end