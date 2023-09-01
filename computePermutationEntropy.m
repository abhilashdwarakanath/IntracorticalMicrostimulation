function [prePE, postPE] = computePermutationEntropy(data,t,range)

%% Define time windows

[~,tStartPre] = min(abs(t-range(1,1)));
[~,tEndPre] = min(abs(t-range(1,2)));

[~,tStartPost] = min(abs(t-range(2,1))); 
[~,tEndPost] = min(abs(t-range(2,2))); 


%% PE modulation

% Compute permutation entropy for pre-chunk and post-chunk for each channel and trial

prePE = nan(size(data,1),size(data,2),tEndPre-tStartPre);
postPE = nan(size(data,1),size(data,2),tEndPost-tStartPost);

for iChan = 1:size(data, 1)
    for iTrial = 1:size(data, 2)
        % Extract data for current channel and trial
        tmp = squeeze(data(iChan, iTrial, :));
        % Compute permutation entropy for pre-chunk and post-chunk
        prePE(iChan, iTrial,:) = perm_entropy(tmp(tStartPre+1:tEndPre));
        postPE(iChan, iTrial,:) = perm_entropy(tmp(tStartPost+1:tEndPost));
    end
end

prePE = squeeze(nanmean(prePE,3));
postPE = squeeze(nanmean(postPE,3));

end