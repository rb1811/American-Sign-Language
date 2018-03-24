
num_components=3;
% figure('units','normalized','outerposition',[0 0 1 1]);
SensorNames = {'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG0R','EMG1L','EMG1R','EMG2L','EMG2R','EMG3L','EMG3R','EMG4L','EMG4R','EMG5L','EMG5R','EMG6L','EMG6R','EMG7L','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','OPL','OPR','ORL','ORR','OYL','OYR'};

colorspec = {[0.9 0.3 0.9];[0.6 0.5 0.2];[0.9 0.8 0.1];[0.8 1 0];[0 1 1];[1 0 0];[0 1 0];[0 0 1]; [1 0.5 0.1];[0 0 0];};

SensorNames = {'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG0R','EMG1L','EMG1R','EMG2L','EMG2R','EMG3L','EMG3R','EMG4L','EMG4R','EMG5L','EMG5R','EMG6L','EMG6R','EMG7L','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','OPL','OPR','ORL','ORR','OYL','OYR'};
cd .;
for i = 1:num_components
    figure('units','normalized','outerposition',[0 0 1 1]);
    x = 1:34;
    y = [];
   
   for j = 1:length(pca_output)
       y(:,j) = pca_output{1,j}{1,i};
        
   end
   figure(i); cla;
    
   
   for k = 1:length(pca_output)
       hold on
       plot(x,y(:, k),'Color', colorspec{k});set(gca,'XTick',1:34,'XTickLabel',SensorNames);xtickangle(-45);
     [~, hobj, ~, ~] = legend({'ABOUT','AND','CAN','COP','DEAF', 'DECIDE', 'FATHER', 'FIND', 'GO OUT', 'HEARING'},'Fontsize',12,'Location','Northwest');
    hl = findobj(hobj,'type','line');
    set(hl,'LineWidth',2.5);
    ht = findobj(hobj,'type','text');
    set(ht,'FontSize',12);
    ylabel('latent DWT values');
    xlabel('Sensor names');
    title("PCA Output "+i);
    grid on

   end
   filename = "overlapped_pca_dwt_component_"+i
    saveas(gca, fullfile(char(path+"/images"), char(filename)), 'jpeg');
    
end
