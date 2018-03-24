clc
figure('units','normalized','outerposition',[0 0 1 1]);
images_path = path+"/images";
if exist(char(images_path), 'dir') == 0
    mkdir(char(images_path));
end
maxdwt_path = images_path +  "/max_dwt";
mindwt_path = images_path +  "/min_dwt";
meandwt_path = images_path + "/mean_dwt";
rmsdwt_path = images_path +  "/rms_dwt";
stddwt_path = images_path +  "/std_dwt";


SensorNames = {'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG0R','EMG1L','EMG1R','EMG2L','EMG2R','EMG3L','EMG3R','EMG4L','EMG4R','EMG5L','EMG5R','EMG6L','EMG6R','EMG7L','EMG7R','GLX','GLY','GLZ','GRX','GRY','GRZ','OPL','OPR','ORL','ORR','OYL','OYR'};
colorspec = {[0.9 0.3 0.9];[0.6 0.5 0.2];[0.9 0.8 0.1];[0.8 1 0];[0 1 1];[1 0 0];[0 1 0];[0 0 1]; [1 0.5 0.1];[0 0 0];};
for i=1:size((dwtStats),3)
    data_mean=dwtStats(1,:,i);
    data_rms=dwtStats(2,:,i);
    data_std = dwtStats(3,:,i);
    data_max=dwtStats(4,:,i);
    data_min=dwtStats(5,:,i);
    
    
%     hold on
    plot(data_mean,'Color', colorspec{i});set(gca,'XTick',1:34,'XTickLabel',SensorNames);xtickangle(-45);
%     [~, hobj, ~, ~] = legend({'ABOUT','AND','CAN','COP','DEAF', 'DECIDE', 'FATHER', 'FIND', 'GO OUT', 'HEARING'},'Fontsize',12,'Location','Northwest');
    [~, hobj, ~, ~] = legend({filesArray{i}(1:end-4)},'Fontsize',12,'Location','Northwest');
    hl = findobj(hobj,'type','line');
    set(hl,'LineWidth',2.5);
    ht = findobj(hobj,'type','text');
    set(ht,'FontSize',12);
    ylabel('Mean values');
    xlabel('Sensor names');
    title("mean of dwt");
    grid on
    if exist(meandwt_path, 'dir') == 0
        mkdir(char(meandwt_path))
    end
    filename = "mean_dwt"+filesArray{i}(1:end-4)
% 	filename = "overlapped_mean_dwt"
    saveas(gca, fullfile(char(meandwt_path), char(filename)), 'jpeg');
%     
%     hold on
    plot(data_rms,'Color', colorspec{i});set(gca,'XTick',1:34,'XTickLabel',SensorNames);xtickangle(-45);
%     [~, hobj, ~, ~] = legend({'ABOUT','AND','CAN','COP','DEAF', 'DECIDE', 'FATHER', 'FIND', 'GO OUT', 'HEARING'},'Fontsize',12,'Location','Northwest');
    [~, hobj, ~, ~] = legend({filesArray{i}(1:end-4)},'Fontsize',12,'Location','Northwest');
    hl = findobj(hobj,'type','line');
    set(hl,'LineWidth',2.5);
    ht = findobj(hobj,'type','text');
    set(ht,'FontSize',12);
    ylabel('RMS values');
    xlabel('Sensor names');
    title("rms of dwt");
    grid on
    if exist(rmsdwt_path, 'dir') == 0
        mkdir(char(rmsdwt_path))
    end
    filename = "rms_dwt"+filesArray{i}(1:end-4)
% 	filename = "overlapped_rms_dwt"
    saveas(gca, fullfile(char(rmsdwt_path), char(filename)), 'jpeg'); 
%  

%     hold on
    plot(data_max,'Color', colorspec{i});set(gca,'XTick',1:34,'XTickLabel',SensorNames);xtickangle(-45);
%     [~, hobj, ~, ~] = legend({'ABOUT','AND','CAN','COP','DEAF', 'DECIDE', 'FATHER', 'FIND', 'GO OUT', 'HEARING'},'Fontsize',12,'Location','Northwest');
    [~, hobj, ~, ~] = legend({filesArray{i}(1:end-4)},'Fontsize',12,'Location','Northwest');
    hl = findobj(hobj,'type','line');
    set(hl,'LineWidth',2.5);
    ht = findobj(hobj,'type','text');
    set(ht,'FontSize',12);
    ylabel('Max values');   
    xlabel('Sensor names');
    title("max of dwt");
    grid on
    if exist(maxdwt_path, 'dir') == 0
        mkdir(char(maxdwt_path))
    end
    filename = "max_dwt"+filesArray{i}(1:end-4)
% 	filename = "overlapped_max_dwt"
    saveas(gca, fullfile(char(maxdwt_path), char(filename)), 'jpeg');
%    
%     hold on
    plot(data_min,'Color', colorspec{i});set(gca,'XTick',1:34,'XTickLabel',SensorNames);xtickangle(-45);
%     [~, hobj, ~, ~] = legend({'ABOUT','AND','CAN','COP','DEAF', 'DECIDE', 'FATHER', 'FIND', 'GO OUT', 'HEARING'},'Fontsize',12,'Location','southwest');
    [~, hobj, ~, ~] = legend({filesArray{i}(1:end-4)},'Fontsize',12,'Location','Northwest');
    hl = findobj(hobj,'type','line');
    set(hl,'LineWidth',2.5);
    ht = findobj(hobj,'type','text');
    set(ht,'FontSize',12);
    ylabel('Min values');     
    xlabel('Sensor names');
    title("min of dwt");
    grid on
    if exist(mindwt_path, 'dir') == 0
        mkdir(char(mindwt_path))
    end
    filename = "min_dwt"+filesArray{i}(1:end-4)
% 	filename = "overlapped_min_dwt"
    saveas(gca, fullfile(char(mindwt_path), char(filename)), 'jpeg');
    
    

%     hold on
    plot(data_std,'Color', colorspec{i});set(gca,'XTick',1:34,'XTickLabel',SensorNames);xtickangle(-45);
%     [~, hobj, ~, ~] = legend({'ABOUT','AND','CAN','COP','DEAF', 'DECIDE', 'FATHER', 'FIND', 'GO OUT', 'HEARING'},'Fontsize',12,'Location','Northwest');
    [~, hobj, ~, ~] = legend({filesArray{i}(1:end-4)},'Fontsize',12,'Location','Northwest');
    hl = findobj(hobj,'type','line');
    set(hl,'LineWidth',2.5);
    ht = findobj(hobj,'type','text');
    set(ht,'FontSize',12);
    ylabel('std values');     
    xlabel('Sensor names');
    title("std of dwt");
    grid on
    if exist(stddwt_path, 'dir') == 0
        mkdir(char(stddwt_path))
    end
    filename = "std_dwt"+filesArray{i}(1:end-4)
% 	filename = "overlapped_std_dwt"
    saveas(gca, fullfile(char(stddwt_path), char(filename)), 'jpeg');
end