clear
clc   
diary('asst.txt')
gestures =   {'ABOUT', 'AND', 'CAN', 'COP', 'DEAF','DECIDE','FATHER', 'FIND', 'GO OUT', 'HEARING'};
actions = [1,1,1,1,1,1,1,1,1,1];
mapObj = containers.Map(gestures,actions);

firstFile =  true;
wname = 'db1';
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(wname); 
finalData={};

code_path =  pwd;
path = uigetdir(pwd, 'Select Folder Containing your Data');
cd(path)
folders = dir(path);
isub = [folders(:).isdir];
nameFolds = {folders(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

for k  = 1:36
    mergedData{10} = [];
    subDirPath = char(path+"/"+nameFolds{k})
    files = dir(fullfile(subDirPath, '*.csv'));
    filesArray = {files.name};
    for fileName = filesArray
        for key = keys(mapObj)
            fileNameCopy = char(lower(fileName(1)));
            keyCopy =  char(lower(key(1)));
            fileNameCopy = regexprep( fileNameCopy,'[^a-zA-Z0-9]','');
            keyCopy = regexprep(keyCopy,'[^a-zA-Z0-9]','');
 
            fileNameCopy(~ismember(fileNameCopy,['A':'Z' 'a':'z'])) = '';
            keyCopy(~ismember(keyCopy,['A':'Z' 'a':'z'])) = '';
            
            fileNameCopy(~ismember(double( fileNameCopy),[65:90 97:122])) = '';
            keyCopy(~ismember(double(keyCopy),[65:90 97:122])) = '';

            if contains(fileNameCopy,keyCopy) 
                fileSize = dir(fullfile(char(subDirPath),fileName{1}));
                if(fileSize.bytes < 20*1024)
                    continue; 
                end
                readfileName = char(subDirPath+"/"+fileName);
                
                if firstFile
                    fid = fopen(char(readfileName),'r');
                    headerline  = fgetl(fid);
                    headers = textscan(headerline,'%s','Delimiter',',');
                    fclose(fid);  
                    headers = cell2table(strsplit(headerline,","));
                    headers = headers(:,1:34);
                    firstFile = false;
                end

                T = readtable(readfileName);
                if height(T)>55
                    continue;
                end
                data=T(1:height(T),1:34);
                tempArray = table2array(data);
                tempArray = [tempArray;zeros(55-height(T), 34)];
                dataTable = array2table(tempArray.');

                currentGestureIndex =  find(not(cellfun('isempty', strfind(gestures,char(key)))));
                mergedData{currentGestureIndex} = vertcat(mergedData{currentGestureIndex}, dataTable);
 
             end
        end
    end
    emptyCells = cellfun(@isempty,mergedData);
    mergedData(emptyCells) = [];
    if size(mergedData,2) < 10
        continue;
    end    
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
    end
    allGestures = {};
    for p = 1:length(mergedData)
        T=mergedData{p};
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
        allGestures{p} = currentGesture;
    end
    disp('DWT start')
    newFeatures = [];
    for gesture = 1:length(allGestures)
        dwtStats= [];
        msg = "Gesture "+ num2str(gesture(1))+" of Folder"+ nameFolds{k}+ " is being done,wait";
        disp(char(msg))
        for sensor = 1:size(allGestures{gesture},3)
            approx = [];
            for action = 1:size(allGestures{gesture}(:,:,sensor),1) 
                [c,l] = wavedec(allGestures{gesture}(action,:,sensor),6,Lo_D,Hi_D);
                approx(action) = appcoef(c,l,wname);
            end
            dwtStats(1,sensor) = mean(approx);
            dwtStats(2,sensor) = rms(approx);
            dwtStats(3,sensor) = std(approx);
            dwtStats(4,sensor) = max(approx);
            dwtStats(5,sensor) = min(approx); 
        end
        [coeff,score,latent]  = pca(dwtStats);  
        newFeatures(:,:,gesture) = dwtStats*coeff;
    end
    finalData{end+1} = newFeatures; 
    clear mergedData
end
disp("done")