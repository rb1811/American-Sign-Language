clc

pca_input={};
pca_output={};
num_components = 3;

    for j = 1 : length(allGestures)
        pca_input{j} = dwtStats(:,:,j);
    end

 for k = 1 : length(allGestures)
    [coeff,score,latent]  = pca(pca_input{k},'NumComponents',num_components);
    components= {};
    for l = 1:num_components
        components{l} = coeff(:,l:l);
    end
    pca_output{k} = components;
end


