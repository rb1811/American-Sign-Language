clc

pca_input={};
pca_output={};
num_components = 3;

for k = 1 : length(allGestures)
    tempArray = mean(allGestures{k});
    %tempArray = mean(allGestures{k}(:,:,1:6));
    tempArr_size = size(tempArray);
    temp = reshape(tempArray,[tempArr_size(1)*tempArr_size(2),tempArr_size(3)]);
    pca_input{k}=temp;
    [coeff,score,latent]  = pca(pca_input{k}.','NumComponents',num_components);
    components= {};
    for l = 1:num_components
        components{l} = coeff(:,l:l);
    end
    pca_output{k} = components;
end


