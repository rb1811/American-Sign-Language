clc
gestures =   {'ABOUT', 'AND', 'CAN', 'COP', 'DEAF','DECIDE','FATHER', 'FIND', 'GO OUT', 'HEARING'};
actions = [1,1,1,1,1,1,1,1,1,1];
mapObj = containers.Map(gestures,actions);
%empty cell array for 10 indices
mergedData{10} = []
%directory where the final 10 csv will be stores
classDirectory = 'C:\Users\varun ch\Desktop\HASITHA\academix\ASU\DM\DM02';
outputDirectory = 'C:\Users\varun ch\Desktop\HASITHA\academix\ASU\DM\';
pwd
path = uigetdir(pwd, 'Select a folder');
cd(path)
files = dir(fullfile(path, '*.csv'));
filesArray = {files.name};
for fileName = filesArray
    for key = keys(mapObj)
        %skip the files/Gestures that are not there in the above list
         if contains(cellstr(lower(fileName(1))),cellstr(lower(key(1))))             
             fileName = char(fileName)
             
             T = readtable(fileName);
             data=T(1:44,1:33);
             
             tempArray = table2array(data);
             dataTable = array2table(tempArray.');
             
             currentGestureIndex =  find(not(cellfun('isempty', strfind(gestures,char(key)))))
             mergedData{currentGestureIndex} = vertcat(mergedData{currentGestureIndex}, dataTable)
             
         end
    end
    temp = fileName;
end

fid = fopen(temp,'r');
headerline  = fgetl(fid);
headers = textscan(headerline,'%s','Delimiter',',');
fclose(fid);  

headers = cell2table(strsplit(headerline,","));
headers = headers(:,1:33);
disp(headers);
cd(outputDirectory);
for key = keys(mapObj)
    currentGestureIndex =  find(not(cellfun('isempty', strfind(gestures,char(key)))));       
    n = height(mergedData{currentGestureIndex})/33;
    headervalue = repmat(headers,1,round(n));
    serialno=arrayfun(@num2str,1:33*round(n),'uni',0);
    index = repmat(1:round(n),[33 1]);
    index = index(:);
    columnNames = {'ActionID','SensorName'};
    tempArray = table2array(headervalue);
    sensorArray = tempArray.';
    %create the appropriate actionArray
    actionArray = strings(round(n)*33,1);
    actionArray(:) = strcat('Action ', num2str(index(:)));
    %create the header table by concat of the above two
    headersArray = horzcat(actionArray, sensorArray);
    headersTable = array2table(headersArray);
    headersTable.Properties.RowNames = serialno;
    headersTable.Properties.VariableNames=columnNames;
    mergedData{currentGestureIndex} = horzcat(headersTable,mergedData{currentGestureIndex});
    filename = char(key)+".csv";
    writetable(mergedData{currentGestureIndex},filename);
end

cd(classDirectory);
%{
fid = fopen(fileName,'r');
headerline  = fgetl(fid);
headers = textscan(headerline,'%s','Delimiter',',');
fclose('all');
             
headers = cell2table(strsplit(headerline,","));
headers = headers(:,1:33);
columnNames = {'ActionID','SensorNames'};
%This index has to be made into a seperate funciton. Where the index will be generated based on the number of rows -  length(mergedata(i))
%index=arrayfun(@num2str,1:33,'uni',0);
%then this below line where you are using index will be corrrect. It has to
%be put in a for loop for each mergedData. This same index will be used to
%Sensor names logic and Action1 logic as well.
%dataTable.Properties.RowNames = index;
%create the sensor names array
tempArray = table2array(headers);
sensorArray = tempArray.';
%create the appropriate actionArray
actionArray = strings(33,1);
actionArray(:) = strcat('Action', num2str(mapObj(char(key))));
%create the header table by concat of the above two
headersArray = horzcat(actionArray, sensorArray);
headersTable = array2table(headersArray);
headersTable.Properties.RowNames = index;
headersTable.Properties.VariableNames=columnNames;  
%final data of the file that needs to be written to file in append fashion
             
dataTable = [headersTable dataTable]
cd(classDirectory)
%gestureFileName = char(key)+ ".csv"
%writetable(dataTable,gestureFileName);
%dlmwrite(gestureFileName, dataTable, 'delimiter', ',');
%Increment the Action value for the next iteration
mapObj(char(key)) = mapObj(char(key)) + 1
%}
disp("done")