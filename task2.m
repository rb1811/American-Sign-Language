clc
clear
path = char(pwd+"/output/")
cd(path);
files = dir(fullfile(path, '*.csv'));
filesArray = {files.name};
allGestures = {};
for k = 1:length(filesArray)
    T=readtable(filesArray{k});
    data = T(1:height(T),3:width(T));
    %create the sensor array only for all the gestures
    sensorNames = T(1:height(T),2);
    sensorNames = table2array(sensorNames);
    uniqueSensorNames = unique(sensorNames);
    %each layer is one sensor data 
    currentGesture=[];
    for i = 1:length(uniqueSensorNames)
        nameIndices = find(not(cellfun('isempty', strfind(sensorNames,uniqueSensorNames(i)))));
        tempArr = [];
        for j = nameIndices
            tempArr = vertcat(tempArr,table2array(data(j,:)));
        end
        currentGesture(:,:,i) = tempArr; 
    end
    
    allGestures{k} = currentGesture;
end
%calculate the statistics and store them in cell array. The order is mean,
%rms and std.
fftStats = {};
for k = 1 : length(allGestures)
    currentStats = [];
    tempArray = mean(fft(allGestures{k},[],2));
    currentStats = vertcat(currentStats, tempArray);
    tempArray = rms(fft(allGestures{k},[],2));
    currentStats = vertcat(currentStats, tempArray);
    tempArray = std(fft(allGestures{k},[],2));
    currentStats = vertcat(currentStats, tempArray);
    fftStats{k} =  currentStats;
end

disp('FFT done, DWT start')
%We are using first Wavelet i.e db1 = Haar wavelet
wname = 'db1';
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(wname); 
dwtStats= [];
for gesture = 1:length(allGestures)
    msg = "Gesture "+ num2str(gesture(1)) + " is being done, please wait";
    disp(char(msg))
    for sensor = 1:size(allGestures{gesture},3)
        approx = [];
        for action = 1:size(allGestures{gesture}(:,:,sensor),1)
            %6 levels of filters
            [c,l] = wavedec(allGestures{gesture}(action,:,sensor),6,Lo_D,Hi_D);
            approx(action) = appcoef(c,l,wname);
        end
        dwtStats(1,sensor,gesture) = mean(approx);
        dwtStats(2,sensor,gesture) = rms(approx);
        dwtStats(3,sensor,gesture) = std(approx);
        dwtStats(4,sensor,gesture) = max(approx);
        dwtStats(5,sensor,gesture) = min(approx); 
    end
end
disp("done")