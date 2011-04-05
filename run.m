%% Initialization
clear;
aFileName = 'Nouvelle Vague - Too Drunk To Fuck';
bFileName = 'dead kennedys - too drunk to fuck';
a = miraudio(aFileName);
b = miraudio(bFileName);

mArray = [1 2 3 5 9 12 15];
tauArray = [1 2 6 9 15];
KArray = [1 2 3 4 5 6 7 8 10 12 15 20 30 40 50];

[c_a ch_a] = mirtonalcentroid(a,'Frame');
[c_b ch_b] = mirtonalcentroid(b,'Frame');
S_a = get(ch_a,'Magnitude');
S_a = cell2mat(S_a{1});
N = size(S_a,2);
D = 12;
h = 2; % prediction horizon

minksi = inf;
best_m = -1; best_tau = -1;
best_A = [];

%% estimate variance
for d=1:D
    sqsigma(d) = (mean(S_a(d,:).^2)-mean(S_a(d,:))^2)*N/(N-1);
end

%% Learning AR
for m = mArray
 for tau = tauArray
   w = (m-1)*tau; %embedding window
   Sstar = zeros(D*m,N-w-h);
     
   for n = w+1:N-h
       sstar_n = [];
       for j=n-w:tau:n
           sstar_n = [S_a(:,j)' sstar_n];
       end
       Sstar(:,n-w) = sstar_n;
   end
   
   %Shat = zeros(D, N-w-h);
   %for n = w+1:N-h
   %    Shat(:,n-w) = S_a(:,n+h);
   %end
   
   %A = (Sstar' \ Shat')';
   A = (Sstar' \ S_a(:,w+1+h:N)')';
   
   Shat = A*Sstar;
   
   %pick the best parameters
   ksi = 0;
   
   for n=w+1:N-h
       for d=1:D
        ksi = ksi+(1/D)*((S_a(d,n+h)-Shat(d,n-w))^2)/sqsigma(d);
       end
   end
   ksi = ksi*(1/(N-h-w));
   
   if (ksi < minksi)
     best_A = A;
     minksi = ksi;
     best_m = m;
     best_tau = tau;
   end
 end
end

fprintf('AR done. m:%f tau:%f\n',best_m, best_tau);

%% Finding common tune
%[transposedHPCP_b, OTI] = findCommonTune(a, b);
