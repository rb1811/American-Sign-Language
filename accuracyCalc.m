diary 'classifierOutputStats'
disp("Decision Tree model");

warning('off','all')
DecisionTreeStats = array2table(zeros(0,5));
DecisionTreeStats.Properties.VariableNames = {'user','gesture','precision','recall','f_score'};
gestureMeans = array2table(zeros(0,3));
gestureMeans.Properties.VariableNames = {'precision','recall','f_score'};
userMeans = array2table(zeros(0,3));
userMeans.Properties.VariableNames = {'precision','recall','f_score'};
i=1;
start=1;

for user = 1:size(finalData,2)
    
    
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
            DecisionTreeStats.('user')(i)= user;
            DecisionTreeStats.('gesture')(i) = iter;
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
            DecisionTreeStats.('recall')(i) = Recall;
            DecisionTreeStats.('precision')(i) = Precision;
            DecisionTreeStats.('f_score')(i) = F_score;
            iter=iter+1;
            i=i+1;
    end
   userMeans.('precision')(user) = mean(table2array(DecisionTreeStats(start:start+9,3:3)),1);
   userMeans.('recall')(user) = mean(table2array(DecisionTreeStats(start:start+9,4:4)),1);
   userMeans.('f_score')(user) = mean(table2array(DecisionTreeStats(start:start+9,5:5)),1);
   start=start+10;
end
for i=1:iter-1
    gestureMeans.('precision')(i) = mean(table2array( DecisionTreeStats(DecisionTreeStats.('gesture')==i,3:3)),1);
    gestureMeans.('recall')(i) = mean(table2array( DecisionTreeStats(DecisionTreeStats.('gesture')==i,4:4)),1);
    gestureMeans.('f_score')(i) = mean(table2array( DecisionTreeStats(DecisionTreeStats.('gesture')==i,5:5)),1);
end
  
    disp(DecisionTreeStats);
    disp("Mean Stats for all Users")
    disp(userMeans);
    disp("Mean Stats for all Gestures");
    disp(gestureMeans);
    

  
disp("SVM model");

warning('off','all')
SVMStats = array2table(zeros(0,5));
SVMStats.Properties.VariableNames = {'user','gesture','precision','recall','f_score'};
gestureMeans = array2table(zeros(0,3));
gestureMeans.Properties.VariableNames = {'precision','recall','f_score'};
userMeans = array2table(zeros(0,3));
userMeans.Properties.VariableNames = {'precision','recall','f_score'};
i=1;
start=1;

for user = 1:size(finalData,2)
    
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
            Models{iter} = fitcsvm(Train(:,1:9),Train(:,10:10));
            iter=iter+1;
    end
    iter=1;
    
    for fileName = TestfilesArray
            SVMStats.('user')(i)= user;
            SVMStats.('gesture')(i) = iter;
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
            SVMStats.('recall')(i) = Recall;
            SVMStats.('precision')(i) = Precision;
            SVMStats.('f_score')(i) = F_score;
            iter=iter+1;
            i=i+1;
    end
   userMeans.('precision')(user) = mean(table2array(DecisionTreeStats(start:start+9,3:3)),1);
   userMeans.('recall')(user) = mean(table2array(DecisionTreeStats(start:start+9,4:4)),1);
   userMeans.('f_score')(user) = mean(table2array(DecisionTreeStats(start:start+9,5:5)),1);
   start=start+10;
end
for i=1:iter-1
    gestureMeans.('precision')(i) = mean(table2array( DecisionTreeStats(DecisionTreeStats.('gesture')==i,3:3)),1);
    gestureMeans.('recall')(i) = mean(table2array( DecisionTreeStats(DecisionTreeStats.('gesture')==i,4:4)),1);
    gestureMeans.('f_score')(i) = mean(table2array( DecisionTreeStats(DecisionTreeStats.('gesture')==i,5:5)),1);
end
  
    disp(SVMStats);
    disp("Mean Stats for all Users")
    disp(userMeans);
    disp("Mean Stats for all Gestures");
    disp(gestureMeans);
    

disp("Decision Tree model-User_Independent_Analysis");
warning('off','all')
DecisionTreeStats = array2table(zeros(0,4));
DecisionTreeStats.Properties.VariableNames = {'gesture','precision','recall','f_score'};

i=1;
start=1;

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
            
            Models{iter} = fitctree(Train(:,1:9),Train(:,10:10));
            iter=iter+1;
    end
    iter=1;
    for fileName = TestfilesArray
            
            DecisionTreeStats.('gesture')(i) = iter;
            
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
            DecisionTreeStats.('recall')(i) = Recall;
            DecisionTreeStats.('precision')(i) = Precision;
            DecisionTreeStats.('f_score')(i) = F_score;
            iter=iter+1;
            i=i+1;
    end
 

  
disp(DecisionTreeStats);
        
    
disp("SVM model-User_Independent_Analysis");
warning('off','all')
SVMStats = array2table(zeros(0,4));
SVMStats.Properties.VariableNames = {'gesture','precision','recall','f_score'};

i=1;
start=1;

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
            
            SVMStats.('gesture')(i) = iter;
            
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
            SVMStats.('recall')(i) = Recall;
            SVMStats.('precision')(i) = Precision;
            SVMStats.('f_score')(i) = F_score;
            iter=iter+1;
            i=i+1;
    end
    disp(SVMStats);
    diary off
    