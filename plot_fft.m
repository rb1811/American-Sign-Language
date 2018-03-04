for i = 1:length(allStats)
	meanacc = [];
	rmsacc = [];
	stdacc = [];

	for j = 1:6
		m=allStats{i}(:,:,j);
		meanacc = vertcat(meanacc,m(1,:));
		rmsacc = vertcat(rmsacc,m(2,:));
		stdacc = vertcat(stdacc, m(3,:));
	end

	meangyro = [];
	rmsgyro = [];
	stdgyro = [];
	for j = 23:28
		m=allStats{i}(:,:,j);
		meangyro = vertcat(meangyro,m(1,:));
		rmsgyro = vertcat(rmsgyro,m(2,:));
		stdgyro = vertcat(stdgyro,m(3,:));
	end


	meanori = [];
	rmsori = [];
	stdori = [];
	for j = 29:2:34
		m=allStats{i}(:,:,j);
		meanori = vertcat(meanori,m(1,:));
		rmsori = vertcat(rmsori,m(2,:));
		stdori = vertcat(stdori,m(3,:));
	end
	for j = 30:2:34
		m=allStats{i}(:,:,j);
		meanori = vertcat(meanori,m(1,:));
		rmsori = vertcat(rmsori,m(2,:));
		stdori = vertcat(stdori,m(3,:));
	end


	subplot(1,2,1); plot3(meanacc(1,:),meanacc(2,:),meanacc(3,:)); title("Left Hand");
	grid on	
	subplot(1,2,2); plot3(meanacc(4,:),meanacc(5,:),meanacc(6,:)); title("Right Hand");
	grid on
	path = "/home/prabhat/Documents/ASL/code/output/images/"+"mean_acc"
	filename = "mean_acc"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(char(path), char(filename)), 'jpeg');
	

	clf('reset')
	subplot(1,2,1); plot3(meangyro(1,:),meangyro(2,:),meangyro(3,:)); title("Left Hand");
	grid on
	subplot(1,2,2); plot3(meangyro(4,:),meangyro(5,:),meangyro(6,:)); title("Right Hand");
	grid on
	path = "/home/prabhat/Documents/ASL/code/output/images/"+"mean_gyro"
	filename = "mean_gyro"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(char(path), char(filename)), 'jpeg');
	
	clf('reset')
	subplot(1,2,1); plot3(meanori(1,:),meanori(2,:),meanori(3,:)); title("Left Hand");
	grid on
	subplot(1,2,2); plot3(meanori(4,:),meanori(5,:),meanori(6,:)); title("Right Hand");
	grid on
	path = "/home/prabhat/Documents/ASL/code/output/images/"+"mean_orie"
	filename = "mean_orie"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(char(path), char(filename)), 'jpeg');
	


	clf('reset')
	subplot(1,2,1); plot3(rmsacc(1,:),rmsacc(2,:),rmsacc(3,:)); title("Left Hand");
	grid on	
	subplot(1,2,2); plot3(rmsacc(4,:),rmsacc(5,:),rmsacc(6,:)); title("Right Hand");
	grid on
	path = "/home/prabhat/Documents/ASL/code/output/images/"+"rms_acc"
	filename = "rms_acc"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(char(path), char(filename)), 'jpeg');
	
	clf('reset')
	subplot(1,2,1); plot3(rmsgyro(1,:),rmsgyro(2,:),rmsgyro(3,:)); title("Left Hand");
	grid on
	subplot(1,2,2); plot3(rmsgyro(4,:),rmsgyro(5,:),rmsgyro(6,:)); title("Right Hand");
	grid on
	path = "/home/prabhat/Documents/ASL/code/output/images/"+"rms_gyro"
	filename = "rms_gyro"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(char(path), char(filename)), 'jpeg');
	
	clf('reset')
	subplot(1,2,1); plot3(rmsori(1,:),rmsori(2,:),rmsori(3,:)); title("Left Hand");
	grid on
	subplot(1,2,2); plot3(rmsori(4,:),rmsori(5,:),rmsori(6,:)); title("Right Hand");
	grid on
	path = "/home/prabhat/Documents/ASL/code/output/images/"+"rms_orie"
	filename = "rms_orie"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(char(path), char(filename)), 'jpeg');
	

	clf('reset')
	subplot(1,2,1); plot3(stdacc(1,:),stdacc(2,:),stdacc(3,:)); title("Left Hand");
	grid on	
	subplot(1,2,2); plot3(stdacc(4,:),stdacc(5,:),stdacc(6,:)); title("Right Hand");
	grid on
	path = "/home/prabhat/Documents/ASL/code/output/images/"+"std_acc"
	filename = "std_acc"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(char(path), char(filename)), 'jpeg');
	
	clf('reset')
	subplot(1,2,1); plot3(stdgyro(1,:),stdgyro(2,:),stdgyro(3,:)); title("Left Hand");
	grid on
	subplot(1,2,2); plot3(stdgyro(4,:),stdgyro(5,:),stdgyro(6,:)); title("Right Hand");
	grid on
	path = "/home/prabhat/Documents/ASL/code/output/images/"+"std_gyro"
	filename = "std_gyro"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(char(path), char(filename)), 'jpeg');
	
	clf('reset')
	subplot(1,2,1); plot3(stdori(1,:),stdori(2,:),stdori(3,:)); title("Left Hand");
	grid on
	subplot(1,2,2); plot3(stdori(4,:),stdori(5,:),stdori(6,:)); title("Right Hand");
	grid on
	path = "/home/prabhat/Documents/ASL/code/output/images/"+"std_orie"
	filename = "std_orie"+filesArray{i}(1:end-4)
	saveas(gca, fullfile(char(path), char(filename)), 'jpeg');
		
end

