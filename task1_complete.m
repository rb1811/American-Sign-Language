clear
clc                 
gestures =   {'ABOUT', 'AND', 'CAN', 'COP', 'DEAF','DECIDE','FATHER', 'FIND', 'GO OUT', 'HEARING'};
actions = [1,1,1,1,1,1,1,1,1,1];
mapObj = containers.Map(gestures,actions);
%initialize cell array to store data
mergedData{10} = [];
code_path =  pwd;
path = uigetdir(pwd, 'Select Folder Containing your Data');
cd(path)
folders = dir(path);
isub = [folders(:).isdir];
nameFolds = {folders(isub).name}';
%remove the the dot and double dot folders for Linux systems to avoid
%recursive file reading
nameFolds(ismember(nameFolds,{'.','..'})) = [];
for k  = 1:length(nameFolds)
    %We are working with first 5 folders. Change the number to
    %length(nameFolds) to make it work for all sub folders.
    subDirPath = char(path+"/"+nameFolds{k})
    files = dir(fullfile(subDirPath, '*.csv'));
    filesArray = {files.name};
    for fileName = filesArray
        for key = keys(mapObj)
            %skip the files/Gestures that are not there in the above list
             if contains(cellstr(lower(fileName(1))),cellstr(lower(key(1))))             
                 fileName = char(subDirPath+"/"+fileName);

                 T = readtable(fileName);
                 %Skip the files if the  time series data for the action is
                 %more than 55
                 if height(T)>55
                     continue;
                 end
                    data=T(1:height(T),1:34);
                    tempArray = table2array(data);
                    %pad the extra rows with 0s
                    tempArray = [tempArray;zeros(55-height(T), 34)];
                    dataTable = array2table(tempArray.');

                    currentGestureIndex =  find(not(cellfun('isempty', strfind(gestures,char(key)))));
                    mergedData{currentGestureIndex} = vertcat(mergedData{currentGestureIndex}, dataTable);
 
             end
        end
    end
end
%Create the header array consisting of the sensor names
fid = fopen(char(fileName),'r');
headerline  = fgetl(fid);
headers = textscan(headerline,'%s','Delimiter',',');
fclose(fid);  

headers = cell2table(strsplit(headerline,","));
headers = headers(:,1:34);
%directory where the final 10 csv will be stores
outputDirectory = char(code_path + "/output")
if exist(outputDirectory, 'dir') == 0
    mkdir(char(outputDirectory))
end
cd(outputDirectory);
for key = keys(mapObj)
    currentGestureIndex =  find(not(cellfun('isempty', strfind(gestures,char(key)))));       
    n = height(mergedData{currentGestureIndex})/34;
    headervalue = repmat(headers,1,round(n));
    serialno=arrayfun(@num2str,1:34*round(n),'uni',0);
    index = repmat(1:round(n),[34 1]);
    index = index(:);
    columnNames = {'ActionID','SensorName'};
    tempArray = table2array(headervalue);
    sensorArray = tempArray.';
    %create the appropriate actionArray
    actionArray = strings(round(n)*34,1);
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

disp("done")
clear