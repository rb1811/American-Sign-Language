clc
pca_input={};
pca_output={};
newFeatures = {};
newFnum_components = 3;
for k = 1 : length(allGestures)
   [coeff,score,latent]  = pca(dwtStats(:,:,k));
   newFeatures{k} = dwtStats(:,:,k)*coeff;  
   components= {};
   for l = 1:num_components
       components{l} = coeff(:,l:l);
   end
    pca_output{k} = components;
end
disp('done')
