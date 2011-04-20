clear;
warning off all;
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



%% initialization
load FBigData;

numOfFiles = size(files,1);
D = 12;             % Descriptor length

h = 10;              % Prediction horizon

%% do pairwise comparison
%for i = 1:numOfFiles


%m_range = [2 3 4 5 7 9 12 15];
%tau_range = [1 2 6 9 15];
%K_range = [2 3 4 5 6 7 8 9 10 12 15 20 30 40 50];
%m_range = 3;
%tau_range = 1;
%K_range = 50;
%max_right = 1;

ksi = zeros(numOfFiles,numOfFiles);

for i = 1:1
   % for s = 1:20
        %fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
        fprintf('Base song (%d/66): %s\n',i,files{i});
        curS_a = S_a{i};
        N = size(curS_a, 2);   % Frames in time-series
        
        % Learn optimal TAR coefficients
        %fprintf('try #%d\n',s);
        [m tau K alpha As medoids] = bestRBF(curS_a, h);
        %[As medoids] = doTmpTar(curS_a, h, m, tau, K);
        fprintf('Best parameters:\n');
        fprintf('  m   = %d\n', m);
        fprintf('  tau = %d\n', tau);
        fprintf('  K   = %d\n', K);
        fprintf('  alpha   = %d\n', alpha);
        
        
        for j = 1:numOfFiles
            
            %fprintf('Song to compare: %s\n',files{j});
            
            curS_b = S_a{j};
            % Compute optimal transposition
            
            [S_bt OTI] = musicalTranspose(curS_b, curS_a);
            
            % Predict S_b using As and compute errors
            [~, err] = predictWithRBF(S_bt, h, m, tau, As, medoids);
            ksi(i,j) = err;
            %fprintf('Prediction error: %2.5f\n', error(num));         
        end
        
        % [B,IX] = sort(error);
        % if (max_right<sum(IX(1:5)<6))
        %     fprintf('!! sum(IX(1:5)<6)=%d. m=%f, tau=%f, K=%d\n',sum(IX(1:5)<6),m,tau,K);
        %     max_right = sum(IX(1:5)<6);
        % end
   % end
    
end
D = ksi + ksi';
%[B,IX] = sort(error);
%fprintf('MAX: %d\n',max_right);