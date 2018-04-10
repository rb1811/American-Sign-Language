clear
clc   
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

nnPath = char(code_path+"/output/"+"NN");
trainCsvPath = char(code_path+"/output/"+"trainCombineCsv");
testCsvPath = char(code_path+"/output/"+"testCombinCsv");

if exist(nnPath, 'dir') == 0
        mkderir(nnPath)
end
if exist(trainCsvPath, 'dir') == 0
        mkdir(trainCsvPath)
end
if exist(testCsvPath, 'dir') == 0
        mkdir(testCsvPath)
end

    
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

    instanceFail = false;
    for i = 1:length(mergedData)
        if size(mergedData{i},1)/34 < 10
            instanceFail = true;
            break;
        end
    end
    if instanceFail
        disp("skipping folders, inconsistency betweeen gestures")
        clearvars mergedData
        continue
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
    
    disp('DWT and PCA start')
    newFeatures = {};
    for gesture = 1:length(allGestures)
        msg = "Gesture "+ num2str(gesture(1))+" of Folder "+ nameFolds{k}+ " is being done,wait";
        disp(char(msg))
        currentGesture = [];
        for sensor = 1:size(allGestures{gesture},3)
            currentSensor = [];
            for action = 1:size(allGestures{gesture}(:,:,sensor),1)
                [c,l] = wavedec(allGestures{gesture}(action,:,sensor),3,Lo_D,Hi_D);
                currentSensor = vertcat(currentSensor,appcoef(c,l,wname));
            end
            currentGesture(:,:,sensor) = currentSensor;
        end
        
        %PCA starts
        pcaInput = horzcat(currentGesture(:,:,23),currentGesture(:,:,24),currentGesture(:,:,25),currentGesture(:,:,26),currentGesture(:,:,27),currentGesture(:,:,28));
        [coeff,score,latent] = pca(pcaInput, 'NumComponents', 9);
        newFeatures{end+1} = pcaInput*coeff;
    end

    finalData{end+1} = newFeatures; 
    
    %for NN user dependent CSV files
    NN = [];
    for gesture = 1:length(finalData{end})
        classLabel = repmat({gestures{gesture}},size(finalData{end}{gesture},1),1);
        NN = vertcat(NN,[num2cell(finalData{end}{gesture}) classLabel]);       
    end
    
    % saving the neural csv data'
%     columnNames = {'fea1','fea2','fea3','fea4','fea5','fea6','fea7','fea8','fea9','class'};
%     NN = cell2table(NN);
%     NN.Properties.VariableNames=columnNames;
    cd(code_path)
    fileName  = char(subDirPath(end-3:end)+".csv");
    cell2csv(fileName, NN);
    movefile(fileName, nnPath);

    clearvars mergedData
    clearvars allGestures
end


cd(code_path)

traincsv{10} = [];
testcsv{10} = [];

for user = 1:size(finalData,2)
    %declare a folder per user for storing the csv files
    userCsvPath = char(code_path+"/output/CSV/DM"+num2str(user));
    if exist(userCsvPath, 'dir') == 0
        mkdir(userCsvPath)
    end
    
    for gesture = 1:size(finalData{user},2)    
        %needs reset for every new gesture
        trainGesture = [];
        testGesture = [];
        
        class = finalData{user}{gesture};
        nonClass = {finalData{user}{1:end ~= gesture}};
        
        %training data
        splitSixty = floor(0.6*size(class,1));
        trainPos = repmat({'+'},splitSixty,1);
        tempTrainData = [num2cell(class(1:splitSixty,:)) trainPos];
        trainGesture = vertcat(trainGesture, tempTrainData);
        
        for otherGesture = 1:length(nonClass)
            splitSixty = floor(0.6*size(nonClass{otherGesture},1));
            trainNeg = repmat({'-'},splitSixty,1);
            tempTrainData = [num2cell(nonClass{otherGesture}(1:splitSixty,:)) trainNeg];
            trainGesture = vertcat(trainGesture, tempTrainData);
        end
        
        %testing data
        splitForty = floor(0.4*size(class,1));
        testPos  = repmat({'+'},size(class,1)-splitForty,1);
        tempTestData = [num2cell(class(splitForty+1:end,:)) testPos];
        testGesture = vertcat(testGesture, tempTestData);
        
        for otherGesture = 1:length(nonClass)
            splitForty = floor(0.4*size(nonClass{otherGesture},1));
            testNeg  = repmat({'-'},size(nonClass{otherGesture},1)-splitForty,1);
            tempTestData = [num2cell(nonClass{otherGesture}(splitForty+1:end,:)) testNeg];
            testGesture = vertcat(testGesture, tempTestData);
        end
        
        %Storing the files assuming you need only one file for machine
        fileName = char(gestures{gesture}+".csv");
        cell2csv(fileName, vertcat(trainGesture, testGesture));
        movefile(fileName, userCsvPath);
        
        %stoing the file assuming you need separate files for train & test
        trainFileName = char(gestures{gesture}+"_train"+".csv");
        testFileName = char(gestures{gesture}+"_test"+".csv");
        cell2csv(trainFileName, trainGesture);
        movefile(trainFileName, userCsvPath);
        cell2csv(testFileName, testGesture);
        movefile(testFileName, userCsvPath);
        
        
        %After one gesture is done
        traincsv{gesture} = vertcat(traincsv{gesture}, trainGesture);
        testcsv{gesture} = vertcat(testcsv{gesture}, testGesture);

    end
end

%________________________________________
%Combined CSV files for all users. Not needed anywhere but still creating
%________________________________________

for i = 1:length(gestures)
    filename = char("train_"+ gestures{i} + ".csv");
    cell2csv(filename,traincsv{i});
    movefile(filename, trainCsvPath);
    
    filename = char("test_"+ gestures{i} + ".csv");
    cell2csv(filename,testcsv{i});
    movefile(filename, testCsvPath);
end

disp("done")