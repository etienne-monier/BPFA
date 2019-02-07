%
% BPFA demo
%

% Add BPFA path
addpath('../BPFA')

% Face image loading
face = double(rgb2gray(imread('face.jpg')));

% Construct a mask
ratio = 0.2; % ratio of sampled pixels.
mask = rand(size(face)) < ratio;

% Reconstruction using BPFA
facer = BPFA(face, mask, 15);

% Display everything
figure,
subplot(1,2,1)
imagesc(face)
axis('image')
subplot(1,2,2)
imagesc(facer)
axis('image')