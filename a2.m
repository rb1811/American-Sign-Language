clc
gestures =   {'ABOUT', 'AND', 'CAN', 'COP', 'DEAF','DECIDE','FATHER', 'FIND', 'GO OUT', 'HEARING'};
actions = [1,1,1,1,1,1,1,1,1,1,];
mapObj = containers.Map(gestures,actions);
classDirectory = '/home/prabhat/Documents/MATLAB/Assignment2/ASL/ClassDirectory';
pwd
path = uigetdir(pwd, 'Select a folder');
cd(path)
files = dir(fullfile(path, '*.csv'));
filesArray = {files.name};
for fileName = filesArray
    for key = keys(mapObj)
         if contains(cellstr(lower(fileName(1))),cellstr(lower(key(1))))             
             fileName = char(fileName)
             fid = fopen(fileName,'r');
             headerline  = fgetl(fid);
             headers = textscan(headerline,'%s','Delimiter',',');
             fclose('all');
             T = readtable(fileName);
             data=T(1:44,1:33);
             headers = cell2table(strsplit(headerline,","));
             headers = headers(:,1:33);

             columnNames = {'ActionID','SensorNames'};
             index=arrayfun(@num2str,1:33,'uni',0);

             tempArray = table2array(data);
             dataTable = array2table(tempArray.');
             dataTable.Properties.RowNames = index;

             tempArray = table2array(headers);
             headersArray = tempArray.';
             
             actionArray = strings(33,1);
             actionArray(:) = strcat('Action', num2str(mapObj(char(key))));
             
             headersArray = horzcat(actionArray, headersArray);
             headersTable = array2table(headersArray);
             headersTable.Properties.RowNames = index;

             headersTable.Properties.VariableNames=columnNames;  

             dataTable = [headersTable dataTable]
             cd(classDirectory)
             gestureFileName = char(key)+ ".csv"
             %writetable(dataTable,gestureFileName);
             
             dlmwrite(gestureFileName, dataTable, 'delimiter', ',');
             
             %Increment the Action value for the next iteration
             mapObj(char(key)) = mapObj(char(key)) + 1
         end
    end
end

disp("done")