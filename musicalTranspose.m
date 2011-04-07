function [S_t OTI] = musicalTranspose(S, S_orig)
%MUSICALTRANSPOSE transpose S to the key of S_orig
%    S, S_orig  : time series of descriptors
%    S_t        : transpose of S to the key of S_orig
%    OTI        : optimal transposition index

% compute the global descriptors
sum = ones(1,size(S,2)) * S';
gS = sum/max(sum);
sum = ones(1,size(S_orig,2)) * S_orig';
gS_orig = sum/max(sum);

% compute the OTI
gS_t = gS;
OTI = 0;
max_resemblance = gS_orig * gS';
for i=1:size(gS,2)-1
   gS_t = circshift(gS, [0 i]);
   if (gS_orig * gS_t') > max_resemblance
       OTI = i;
       max_resemblance = gS_orig * gS_t';
   end 
end

% compute transposition
S_t = circshift(S, [OTI 0]);

end

