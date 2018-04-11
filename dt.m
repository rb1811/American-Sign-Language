clc
diary 'classifierOutputStats'
disp("Decision Tree model");
code_path =  pwd;
warning('off','all')
DecisionTreeStats = [];
columnNames = {'user','gesture','precision','recall','f_score'};
subcolNames= {'precision','recall','f_score'};
gestureMeans = array2table(zeros(0,3));
gestureMeans.Properties.VariableNames = {'precision','recall','f_score'};
userMeans = array2table(zeros(0,3));
userMeans.Properties.VariableNames = {'precision','recall','f_score'};
i=1;
start=1;
iter=1;
userfilesList = dir(char(code_path+"/output/CSV"));
for user = 1:length(userfilesList)-2
    
    
    %declare a folder per user for storing the csv files
    userCsvPath = char(code_path+"/output/CSV/DM"+num2str(user));
    trainFiles = dir(fullfile( userCsvPath, '*_train.csv'));
    testFiles = dir(fullfile( userCsvPath, '*_test.csv'));
    TrainfilesArray = {trainFiles.name};
    TestfilesArray = {testFiles.name};
    Models={};
    iter =1;
    for fileName = TrainfilesArray
            Train = readtable(userCsvPath+"/"+fileName{1});
            Models{iter} = fitctree(Train(:,1:9),Train(:,10:10));
            iter=iter+1;
    end
    iter=1;
   
    for fileName = TestfilesArray
            stats=[];
            stats = horzcat(stats,user);
            stats = horzcat(stats,iter);
            Test = readtable(userCsvPath+"/"+fileName{1});
            TestArray = table2array(Test);
            lbls = predict(Models{iter},TestArray(:,1:9));
            [confMat,order] = confusionmat(TestArray(:,10:10),lbls);
            recall =[];
            precision=[];
            for j =1:size(confMat,1)
                precision(j)=confMat(j,j)/sum(confMat(:,j));
                recall(j)=confMat(j,j)/sum(confMat(j,:));
            end
            recall(isnan(recall))=[];
            precision(isnan(precision))=[];
            Recall=sum(recall)/size(confMat,1);
            Precision=sum(precision)/size(confMat,1);
            F_score=2*Recall*Precision/(Precision+Recall);
            stats = horzcat(stats,Recall);
            stats = horzcat(stats,Precision);
            stats = horzcat(stats,F_score);
            iter=iter+1;
            i=i+1;
            DecisionTreeStats = vertcat(DecisionTreeStats,stats);
    end

end
DecisionTreeStats  = array2table(DecisionTreeStats);
DecisionTreeStats.Properties.VariableNames = columnNames;
start=1;
userMeans=[];
 for user = 1:length(userfilesList)-2
     stats=[];
     stats = horzcat(stats,mean(table2array(DecisionTreeStats(start:start+9,3:3)),1));
     stats = horzcat(stats,mean(table2array(DecisionTreeStats(start:start+9,4:4)),1));
     stats = horzcat(stats,mean(table2array(DecisionTreeStats(start:start+9,5:5)),1));
     userMeans = vertcat(userMeans,stats);
   start=start+10;
 end
userMeans  = array2table(userMeans);
userMeans.Properties.VariableNames = subcolNames;
gestureMeans=[];
for i=1:iter-1
      stats=[];
     stats = horzcat(stats,mean(table2array(DecisionTreeStats(DecisionTreeStats.('gesture')==i,3:3)),1));
     stats = horzcat(stats,mean(table2array( DecisionTreeStats(DecisionTreeStats.('gesture')==i,4:4)),1));
     stats = horzcat(stats,mean(table2array( DecisionTreeStats(DecisionTreeStats.('gesture')==i,5:5)),1));
     gestureMeans = vertcat(gestureMeans,stats);
   
end
gestureMeans  = array2table(gestureMeans);
gestureMeans.Properties.VariableNames = subcolNames;
  
    disp(DecisionTreeStats);
    disp("Mean Stats for all Users")
    disp(userMeans);
    disp("Mean Stats for all Gestures");
    disp(gestureMeans);
    
 
disp("SVM model");
SVMStats=[];
warning('off','all')
columnNames = {'user','gesture','precision','recall','f_score'};
subcolNames= {'precision','recall','f_score'};
gestureMeans = array2table(zeros(0,3));
gestureMeans.Properties.VariableNames = {'precision','recall','f_score'};
userMeans = array2table(zeros(0,3));
userMeans.Properties.VariableNames = {'precision','recall','f_score'};
i=1;
start=1;
iter=1;
userfilesList = dir(char(code_path+"/output/CSV"));
for user = 1:length(userfilesList)-2
    
    
    %declare a folder per user for storing the csv files
    userCsvPath = char(code_path+"/output/CSV/DM"+num2str(user));
    trainFiles = dir(fullfile( userCsvPath, '*_train.csv'));
    testFiles = dir(fullfile( userCsvPath, '*_test.csv'));
    TrainfilesArray = {trainFiles.name};
    TestfilesArray = {testFiles.name};
    Models={};
    iter =1;
    for fileName = TrainfilesArray
            Train = readtable(userCsvPath+"/"+fileName{1});
            Models{iter} = fitctree(Train(:,1:9),Train(:,10:10));
            iter=iter+1;
    end
    iter=1;
   
    for fileName = TestfilesArray
            stats=[];
            stats = horzcat(stats,user);
            stats = horzcat(stats,iter);
            Test = readtable(userCsvPath+"/"+fileName{1});
            TestArray = table2array(Test);
            lbls = predict(Models{iter},TestArray(:,1:9));
            [confMat,order] = confusionmat(TestArray(:,10:10),lbls);
            recall =[];
            precision=[];
            for j =1:size(confMat,1)
                precision(j)=confMat(j,j)/sum(confMat(:,j));
                recall(j)=confMat(j,j)/sum(confMat(j,:));
            end
            recall(isnan(recall))=[];
            precision(isnan(precision))=[];
            Recall=sum(recall)/size(confMat,1);
            Precision=sum(precision)/size(confMat,1);
            F_score=2*Recall*Precision/(Precision+Recall);
            stats = horzcat(stats,Recall);
            stats = horzcat(stats,Precision);
            stats = horzcat(stats,F_score);
            iter=iter+1;
            i=i+1;
            SVMStats = vertcat(SVMStats,stats);
    end

end
SVMStats  = array2table(SVMStats);
SVMStats.Properties.VariableNames = columnNames;
start=1;
userMeans=[];
 for user = 1:length(userfilesList)-2
     stats=[];
     stats = horzcat(stats,mean(table2array(SVMStats(start:start+9,3:3)),1));
     stats = horzcat(stats,mean(table2array(SVMStats(start:start+9,4:4)),1));
     stats = horzcat(stats,mean(table2array(SVMStats(start:start+9,5:5)),1));
     userMeans = vertcat(userMeans,stats);
   start=start+10;
 end
userMeans  = array2table(userMeans);
userMeans.Properties.VariableNames = subcolNames;
gestureMeans=[];
for i=1:iter-1
      stats=[];
     stats = horzcat(stats,mean(table2array(SVMStats(SVMStats.('gesture')==i,3:3)),1));
     stats = horzcat(stats,mean(table2array( SVMStats(SVMStats.('gesture')==i,4:4)),1));
     stats = horzcat(stats,mean(table2array( SVMStats(SVMStats.('gesture')==i,5:5)),1));
     gestureMeans = vertcat(gestureMeans,stats);
   
end
gestureMeans  = array2table(gestureMeans);
gestureMeans.Properties.VariableNames = subcolNames;
    disp(SVMStats);
    disp("Mean Stats for all Users")
    disp(userMeans);
    disp("Mean Stats for all Gestures");
    disp(gestureMeans);
    

disp("Decision Tree model-User_Independent_Analysis");
DecisionTreeStats = [];
columnNames = {'gesture','precision','recall','f_score'};
i=1;
start=1;
iter=1;

    %declare a folder per user for storing the csv files
    trainCsvPath = char(code_path+"/output/trainCombineCsv");
    testCsvPath = char(code_path+"/output/testCombinCsv");
    trainFiles = dir(fullfile( trainCsvPath, 'train_*.csv'));
    testFiles = dir(fullfile( testCsvPath, 'test_*.csv'));
    TrainfilesArray = {trainFiles.name};
    TestfilesArray = {testFiles.name};
    Models={};
    iter =1;
    for fileName = TrainfilesArray
            Train = readtable(char(trainCsvPath+"/"+fileName{1}));
            Models{iter} = fitctree(Train(:,1:9),Train(:,10:10));
            iter=iter+1;
    end
    iter=1;
   
    for fileName = TestfilesArray
            stats=[];
            stats = horzcat(stats,iter);
            Test = readtable(char(testCsvPath+"/"+fileName{1}));
            TestArray = table2array(Test);
            lbls = predict(Models{iter},TestArray(:,1:9));
            [confMat,order] = confusionmat(TestArray(:,10:10),lbls);
            recall =[];
            precision=[];
            for j =1:size(confMat,1)
                precision(j)=confMat(j,j)/sum(confMat(:,j));
                recall(j)=confMat(j,j)/sum(confMat(j,:));
            end
            recall(isnan(recall))=[];
            precision(isnan(precision))=[];
            Recall=sum(recall)/size(confMat,1);
            Precision=sum(precision)/size(confMat,1);
            F_score=2*Recall*Precision/(Precision+Recall);
            stats = horzcat(stats,Recall);
            stats = horzcat(stats,Precision);
            stats = horzcat(stats,F_score);
            iter=iter+1;
            i=i+1;
            DecisionTreeStats = vertcat(DecisionTreeStats,stats);
    end

DecisionTreeStats  = array2table(DecisionTreeStats);
DecisionTreeStats.Properties.VariableNames = columnNames;
disp(DecisionTreeStats);
    
warning('off','all')

disp("SVM model-User_Independent_Analysis");
SVMStats = [];
columnNames = {'gesture','precision','recall','f_score'};
i=1;
start=1;
iter=1;

    %declare a folder per user for storing the csv files
    trainCsvPath = char(code_path+"/output/trainCombineCsv");
    testCsvPath = char(code_path+"/output/testCombinCsv");
    trainFiles = dir(fullfile( trainCsvPath, 'train_*.csv'));
    testFiles = dir(fullfile( testCsvPath, 'test_*.csv'));
    TrainfilesArray = {trainFiles.name};
    TestfilesArray = {testFiles.name};
    Models={};
    iter =1;
    for fileName = TrainfilesArray
            Train = readtable(trainCsvPath+"/"+fileName{1});
            Models{iter} = fitcsvm(Train(:,1:9),Train(:,10:10));
            iter=iter+1;
    end
    iter=1;
   
    for fileName = TestfilesArray
            stats=[];
            stats = horzcat(stats,iter);
            Test = readtable(testCsvPath+"/"+fileName{1});
            TestArray = table2array(Test);
            lbls = predict(Models{iter},TestArray(:,1:9));
            [confMat,order] = confusionmat(TestArray(:,10:10),lbls);
            recall =[];
            precision=[];
            for j =1:size(confMat,1)
                precision(j)=confMat(j,j)/sum(confMat(:,j));
                recall(j)=confMat(j,j)/sum(confMat(j,:));
            end
            recall(isnan(recall))=[];
            precision(isnan(precision))=[];
            Recall=sum(recall)/size(confMat,1);
            Precision=sum(precision)/size(confMat,1);
            F_score=2*Recall*Precision/(Precision+Recall);
            stats = horzcat(stats,Recall);
            stats = horzcat(stats,Precision);
            stats = horzcat(stats,F_score);
            iter=iter+1;
            i=i+1;
            SVMStats = vertcat(SVMStats,stats);
    end

SVMStats  = array2table(SVMStats);
SVMStats.Properties.VariableNames = columnNames;
disp(SVMStats);
diary off
movefile('classifierOutputStats', char(code_path+"/output"))
        
    