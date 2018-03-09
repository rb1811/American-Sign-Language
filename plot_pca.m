
SensorNames = {'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG0R','EMG1L','EMG1R','EMG2L','EMG2R','EMG3L','EMG3R','EMG4L','EMG4R','EMG5L','EMG5R','EMG6L','EMG6R','EMG7L','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','OPL','OPR','ORL','ORR','OYL','OYR'}

for i = 1:num_components
    x = 1:55;
    y = [];
   
   for j = 1:length(pca_output)
       y(:,j) = pca_output{1,j}{1,i};
        
   end
   colorstring = 'bkrgycmwbk';
   figure(i); cla;
    
   
   for k = 1:length(pca_output)
        disp(k);
        hold on
    % plot(x,y(:, k), 'Color', [rand(1) rand(1) rand(1)])
        plot(x,y(:, k), 'Color', colorstring(k))
    % set(gca,'XTick',1:34,'XTickLabel',SensorNames);
    %xtickangle(90);
   end
end
