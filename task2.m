clc
clear
path = uigetdir(pwd, 'Select Folder Containing your Data');
cd(path);
files = dir(fullfile(path, '*.csv'));
filesArray = {files.name};
count = true;
allGestures = {};
for k = 1:length(filesArray)
    T=readtable(filesArray{k});
    data = T(1:height(T),3:width(T));
    %create the sensor array only for all the gestures
    if count == true
        sensorNames = T(1:height(T),2);
        sensorNames = table2array(sensorNames);
        uniqueSensorNames = unique(sensorNames);
        count = false;
    end
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

allStats = {};
for k = 1 : length(allGestures)
    currentStats = [];
    tempArray = mean(allGestures{k});
    currentStats = vertcat(currentStats, tempArray);
    tempArray = rms(allGestures{k});
    currentStats = vertcat(currentStats, tempArray);
    tempArray = std(allGestures{k});
    currentStats = vertcat(currentStats, tempArray);
    allStats{k} =  currentStats;
end