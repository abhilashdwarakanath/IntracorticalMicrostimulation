function pooledscmod =  responseCurveSpiking(data,params,session,t,range)

% Compute response curve. AD. NS 2023

%% Check for session

if session > 1

	amps = [1 5 8 15 20 25];

elseif session == 1

	amps = [15 100];

end

%% Get some shit

[~,tStartPre] = min(abs(t-range(1,1)));
[~,tEndPre] = min(abs(t-range(1,2)));

nTrials = size(data{1},2);
%% Compute the spike count mod for each trial, across channels, for each amplitude

scmod = zeros(length(amps), nTrials, params.elecs);

for iAmp = 1:length(amps) % Loop over amplitudes

	if amps(iAmp) < 15

		[~,tStartPost] = min(abs(t-range(2,1)));
		[~,tEndPost] = min(abs(t-range(2,2)));

	elseif amps(iAmp) == 15

		[~,tStartPost] = min(abs(t-range(3,1)));
		[~,tEndPost] = min(abs(t-range(3,2)));

	else

		[~,tStartPost] = min(abs(t-range(4,1)));
		[~,tEndPost] = min(abs(t-range(4,2)));

	end

	for iTrial = 1:nTrials % Loop over trials

		% Extract the chunk of data corresponding to the time window of interest
		data_chunkPre = squeeze(data{iAmp}(:,iTrial,tStartPre+1:tEndPre));
		data_chunkPost = squeeze(data{iAmp}(:,iTrial,tStartPost+1:tEndPost));

		% Compute the spike counts of the chunk of data for each trial
		scPre = sum(data_chunkPre,2)./size(data_chunkPre,2); scPost = sum(data_chunkPost,2)./size(data_chunkPost,2);

		% Compute the spike count modulation of the chunk of data for each trial
		scmod(iAmp,iTrial,:) = ((scPost-scPre)./(scPost+scPre))*100; % mean of the RMS of across channels
	end
end

% Reshape to collapse
pooledscmod = reshape(scmod, size(scmod,1), [])';