clc
figure('units','normalized','outerposition',[0 0 1 1]);
images_path = path+"/images";
if exist(char(images_path), 'dir') == 0
    mkdir(char(images_path));
end
meanacc_path = char(images_path+"/mean_acc");
meangyro_path = char(images_path+"/mean_gyro");
meanorie_path = char(images_path+"/mean_orie");
rmsacc_path = char(images_path+"/rms_acc");
rmsgyro_path = char(images_path+"/rms_gyro");
rmsorie_path = char(images_path+"/rms_orie");
stdacc_path = char(images_path+"/std_acc");
stdgyro_path = char(images_path+"/std_gyro");
stdorie_path = char(images_path+"/std_orie");


for i = 1:length(fftStats)
	meanacc = [];
	rmsacc = [];
	stdacc = [];

	for j = 1:6
		m=fftStats{i}(:,:,j);
		meanacc = vertcat(meanacc,m(1,:));
		rmsacc = vertcat(rmsacc,m(2,:));
		stdacc = vertcat(stdacc, m(3,:));
	end

	meangyro = [];
	rmsgyro = [];
	stdgyro = [];
	for j = 23:28
		m=fftStats{i}(:,:,j);
		meangyro = vertcat(meangyro,m(1,:));
		rmsgyro = vertcat(rmsgyro,m(2,:));
		stdgyro = vertcat(stdgyro,m(3,:));
	end


	meanori = [];
	rmsori = [];
	stdori = [];
	for j = 29:2:34
		m=fftStats{i}(:,:,j);
		meanori = vertcat(meanori,m(1,:));
		rmsori = vertcat(rmsori,m(2,:));
		stdori = vertcat(stdori,m(3,:));
	end
	for j = 30:2:34
		m=fftStats{i}(:,:,j);
		meanori = vertcat(meanori,m(1,:));
		rmsori = vertcat(rmsori,m(2,:));
		stdori = vertcat(stdori,m(3,:));
	end


	subplot(1,2,1); plot3(meanacc(1,:),meanacc(2,:),meanacc(3,:)); title("Left Hand accelerometer"); 
    xlabel('Mean ALX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Mean ALY'); set(get(gca,'ylabel'),'rotation',-40); zlabel('Mean ALZ');
	grid on	
	subplot(1,2,2); plot3(meanacc(4,:),meanacc(5,:),meanacc(6,:)); title("Right Hand accelerometer");
    xlabel('Mean ARX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Mean ARY'); set(get(gca,'ylabel'),'rotation',-40);zlabel('Mean ARZ');
	h = rotate3d; 
    grid on
    if exist(meanacc_path, 'dir') == 0
        mkdir(char(meanacc_path))
    end
    filename = "mean_acc"+filesArray{i}(1:end-4)
    saveas(gca, fullfile(meanacc_path, char(filename)), 'jpeg');
	

	clf('reset')
	subplot(1,2,1); plot3(meangyro(1,:),meangyro(2,:),meangyro(3,:)); title("Left Hand Gyroscope");
    xlabel('Mean ALX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Mean ALY'); set(get(gca,'ylabel'),'rotation',-40); zlabel('Mean ALZ');
	grid on
	subplot(1,2,2); plot3(meangyro(4,:),meangyro(5,:),meangyro(6,:)); title("Right Hand Gyroscope");
    xlabel('Mean ARX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Mean ARY'); set(get(gca,'ylabel'),'rotation',-40);zlabel('Mean ARZ');
	h = rotate3d; 
    grid on
    if exist(meangyro_path, 'dir') == 0
        mkdir(meangyro_path)
    end
    filename = "mean_gyro"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(meangyro_path, char(filename)), 'jpeg');
	
	clf('reset')
	subplot(1,2,1); plot3(meanori(1,:),meanori(2,:),meanori(3,:)); title("Left Hand Orientation");
    xlabel('Mean ALX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Mean ALY'); set(get(gca,'ylabel'),'rotation',-40); zlabel('Mean ALZ');
	grid on
	subplot(1,2,2); plot3(meanori(4,:),meanori(5,:),meanori(6,:)); title("Right Hand Orientation");
    xlabel('Mean ARX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Mean ARY'); set(get(gca,'ylabel'),'rotation',-40);zlabel('Mean ARZ');
	h = rotate3d; 
    grid on
    if exist(meanorie_path, 'dir') == 0
        mkdir(meanorie_path)
    end
    filename = "mean_orie"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(meanorie_path, char(filename)), 'jpeg');
	


	clf('reset')
	subplot(1,2,1); plot3(rmsacc(1,:),rmsacc(2,:),rmsacc(3,:)); title("Left Hand Accelerometer");
    xlabel('RMS ALX'); set(get(gca,'xlabel'),'rotation',32); ylabel('RMS ALY'); set(get(gca,'ylabel'),'rotation',-40); zlabel('RMS ALZ');
	grid on	
	subplot(1,2,2); plot3(rmsacc(4,:),rmsacc(5,:),rmsacc(6,:)); title("Right Hand Accelerometer");
    xlabel('RMS ARX'); set(get(gca,'xlabel'),'rotation',32); ylabel('RMS ARY'); set(get(gca,'ylabel'),'rotation',-40);zlabel('RMS ARZ');
	h = rotate3d; 
    grid on
    if exist(rmsacc_path, 'dir') == 0
        mkdir(rmsacc_path)
    end
    filename = "rms_acc"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(rmsacc_path, char(filename)), 'jpeg');
	
	clf('reset')
	subplot(1,2,1); plot3(rmsgyro(1,:),rmsgyro(2,:),rmsgyro(3,:)); title("Left Hand Gyroscope");
    xlabel('RMS ALX'); set(get(gca,'xlabel'),'rotation',32); ylabel('RMS ALY'); set(get(gca,'ylabel'),'rotation',-40); zlabel('RMS ALZ');
	grid on
	subplot(1,2,2); plot3(rmsgyro(4,:),rmsgyro(5,:),rmsgyro(6,:)); title("Right Hand Gyroscope");
    xlabel('RMS ARX'); set(get(gca,'xlabel'),'rotation',32); ylabel('RMS ARY'); set(get(gca,'ylabel'),'rotation',-40);zlabel('RMS ARZ');
	h = rotate3d; 
   
	grid on
    if exist(rmsgyro_path, 'dir') == 0
        mkdir(rmsgyro_path)
    end
    filename = "rms_gyro"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(rmsgyro_path, char(filename)), 'jpeg');
	
	clf('reset')
	subplot(1,2,1); plot3(rmsori(1,:),rmsori(2,:),rmsori(3,:)); title("Left Hand Orientation");
    xlabel('RMS ALX'); set(get(gca,'xlabel'),'rotation',32); ylabel('RMS ALY'); set(get(gca,'ylabel'),'rotation',-40); zlabel('RMS ALZ');
	grid on
	subplot(1,2,2); plot3(rmsori(4,:),rmsori(5,:),rmsori(6,:)); title("Right Hand Orientation");
    xlabel('RMS ARX'); set(get(gca,'xlabel'),'rotation',32); ylabel('RMS ARY'); set(get(gca,'ylabel'),'rotation',-40);zlabel('RMS ARZ');
	h = rotate3d; 
    
	grid on
    if exist(rmsorie_path, 'dir') == 0
        mkdir(rmsorie_path)
    end
	filename = "rms_orie"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(rmsorie_path, char(filename)), 'jpeg');
	

	clf('reset')
	subplot(1,2,1); plot3(stdacc(1,:),stdacc(2,:),stdacc(3,:)); title("Left Hand Accelerometer");
    xlabel('Std ALX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Std ALY'); set(get(gca,'ylabel'),'rotation',-40); zlabel('Std ALZ');
	grid on	
	subplot(1,2,2); plot3(stdacc(4,:),stdacc(5,:),stdacc(6,:)); title("Right Hand Accelerometer");
    xlabel('Std ARX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Std ARY'); set(get(gca,'ylabel'),'rotation',-40);zlabel('Std ARZ');
	h = rotate3d; 
   
	grid on
    if exist(stdacc_path, 'dir') == 0
        mkdir(stdacc_path)
    end
	filename = "std_acc"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(stdacc_path, char(filename)), 'jpeg');
	
	clf('reset')
	subplot(1,2,1); plot3(stdgyro(1,:),stdgyro(2,:),stdgyro(3,:)); title("Left Hand Gyroscope");
    xlabel('Std ALX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Std ALY'); set(get(gca,'ylabel'),'rotation',-40); zlabel('Std ALZ');
	grid on
	subplot(1,2,2); plot3(stdgyro(4,:),stdgyro(5,:),stdgyro(6,:)); title("Right Hand Gyroscope");
    xlabel('Std ARX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Std ARY'); set(get(gca,'ylabel'),'rotation',-40);zlabel('Std ARZ');
	h = rotate3d; 
    
	grid on
    if exist(stdgyro_path, 'dir') == 0
        mkdir(stdgyro_path)
    end
    filename = "std_gyro"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(stdgyro_path, char(filename)), 'jpeg');
	
	clf('reset')
	subplot(1,2,1); plot3(stdori(1,:),stdori(2,:),stdori(3,:)); title("Left Hand Orientation");
    xlabel('Std ALX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Std ALY'); set(get(gca,'ylabel'),'rotation',-40); zlabel('Std ALZ');
	grid on
	subplot(1,2,2); plot3(stdori(4,:),stdori(5,:),stdori(6,:)); title("Right Hand Orientation");
    xlabel('Std ARX'); set(get(gca,'xlabel'),'rotation',32); ylabel('Std ARY'); set(get(gca,'ylabel'),'rotation',-40);zlabel('Std ARZ');
	h = rotate3d; 
    grid on
    if exist(stdorie_path, 'dir') == 0
        mkdir(stdorie_path)
    end
    filename = "std_orie"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(stdorie_path, char(filename)), 'jpeg');
		
end

