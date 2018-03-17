clc
clear
path = uigetdir(pwd, 'Select Folder Containing your Data');
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
allStats = {};
for k = 1 : length(allGestures)
    currentStats = [];
    tempArray = mean(fft(allGestures{k},[],2));
    currentStats = vertcat(currentStats, tempArray);
    tempArray = rms(fft(allGestures{k},[],2));
    currentStats = vertcat(currentStats, tempArray);
    tempArray = std(fft(allGestures{k},[],2));
    currentStats = vertcat(currentStats, tempArray);
    allStats{k} =  currentStats;
end

approx = [];
wname = 'db1';
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(wname); 
dwtAllGestures= [];
for gesture = 1:length(allGestures)
    for sensor = 1:size(allGestures{gesture},3)
        for action = 1:size(allGestures{gesture}(:,:,sensor),1)
            [c,l] = wavedec(allGestures{gesture}(action,:,sensor),6,Lo_D,Hi_D);
            approx(action) = appcoef(c,l,wname);
        end
        dwtAllGestures(1,sensor,gesture) = mean(approx(action));
        dwtAllGestures(2,sensor,gesture) = rms(approx(action));
        dwtAllGestures(3,sensor,gesture) = std(approx(action));
        dwtAllGestures(4,sensor,gesture) = max(approx(action));
        dwtAllGestures(5,sensor,gesture) = min(approx(action)); 
    end
end