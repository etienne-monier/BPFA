function [rec_image]=InpaintingOutput(image,PatchSize,m,n, Itab, Jtab)

[n1 n2]=size(image);
n3=n1/PatchSize/PatchSize;

% lengths
Ni = length(Itab);
Nj = length(Jtab);

rec_image=zeros(m,n,n3);
mask=zeros(m,n,n3);

ind = 1;
for j=Jtab
    for i=Itab
        
        % Get patch
        patch = permute(reshape(image(:,ind),[n3 PatchSize PatchSize]),[3 2 1]);
        
        % Put it to the reconstructed image.
        rec_image(i:i+PatchSize-1,j:j+PatchSize-1,:) = rec_image(i:i+PatchSize-1,j:j+PatchSize-1,:) + patch;
        
        % Increment mask
        mask(i:i+PatchSize-1,j:j+PatchSize-1,:) = mask(i:i+PatchSize-1,j:j+PatchSize-1,:) + ones(PatchSize,PatchSize,n3);
        
        % Increment index
        ind = ind+1;
       
    end
end

% Normalise reconstructed image.
rec_image = rec_image./mask;
