clc
filePath = '/home/prabhat/Documents/MATLAB/ASL/output/ABOUT.csv';
T=readtable(filePath);
data = T(1:height(T),3:width(T));
sensorNames = T(1:height(T),2);
sensorNames = table2array(sensorNames);
uniqueSensorNames = unique(sensorNames);
currentGesture{33}=[]
for i = 1:length(uniqueSensorNames)
    nameIndices = find(not(cellfun('isempty', strfind(sensorNames,uniqueSensorNames(i)))));
    tempArr = [];
    for j = nameIndices
        tempArr = vertcat(tempArr,table2array(data(j,:)));
    end
    currentGesture{i} = tempArr; 
end
