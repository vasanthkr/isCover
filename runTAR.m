clear;
%% find all the input files
% basePath = 'C:\Users\bmpix\Documents\study\540\git\';
% folders = dir (strcat(basePath,'music'));
% 
% files = [];
% for i = 1:size(folders,1)
%     if (strcmp(folders(i).name,'.')||strcmp(folders(i).name,'..'))
%         continue;
%     end
%     curFiles = dir(strcat(basePath,'music/',folders(i).name));
%     for j = 1:size(curFiles,1)
%         if (strcmp(curFiles(j).name,'.')||strcmp(curFiles(j).name,'..'))
%             continue;
%         end
%         files = [files; cellstr(strcat(basePath,'music/',folders(i).name,'/',curFiles(j).name))];
%     end
% end

%numOfFiles = size(files,1);

%% initialization
load FBigData;
numOfFiles = size(files,1);
D = 12;             % Descriptor length
h = 2;              % Prediction horizon

%% do pairwise comparison
for i = 1:numOfFiles
    fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
    fprintf('Base song: %s\n',files{i});
    curS_a = S_a{i};
    N = size(curS_a, 2);   % Frames in time-series
    
    % Learn optimal TAR coefficients
    [m tau K As medoids] = bestTAR(curS_a, h);
    fprintf('Best parameters:\n');
    fprintf('  m   = %d\n', m);
    fprintf('  tau = %d\n', tau);
    fprintf('  K   = %d\n', K);
    
    for j = i+1:numOfFiles
        
        fprintf('Song to compare: %s\n',files{j});
        
        curS_b = S_a{j};
        % Compute optimal transposition
        
        [S_bt OTI] = musicalTranspose(curS_b, curS_a);
        
        % Predict S_b using As and compute errors
        [~, error] = predictWithTAR(S_bt, h, m, tau, As, medoids);
        fprintf('Prediction error: %2.5f\n', error);
        
    end
end