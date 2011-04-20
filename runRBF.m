clear;
warning off all;

%% initialization
load FBigData;

numOfFiles = size(files,1);
D = 12;             % Descriptor length
h = 10;             % Prediction horizon
ksi = zeros(numOfFiles,numOfFiles);

%% do pairwise comparison
for i = 1:numOfFiles
        fprintf('Base song (%d/66): %s\n',i,files{i});
        curS_a = S_a{i};
        N = size(curS_a, 2);   % Frames in time-series
        
        % Learn optimal TAR coefficients
        [m tau K alpha B medoids rho] = bestRBF(curS_a, h);

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
            [~, err] = predictWithRBF(S_bt, h, m, tau, alpha, B, medoids, rho);
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