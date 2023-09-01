function pooledEnergy =  responseCurveLFP(data,params,session,t,range)

% Compute response curve. AD. NS 2023

%% Check for session

if session > 1

    amps = [1 5 8 15 20 25];

elseif session == 1

    amps = [15 100];

end

%% Specify time window for signal energy calculation

[~,tStartPre] = min(abs(t-range(1,1)));
[~,tEndPre] = min(abs(t-range(1,2)));

nTrials = size(data{1},2);

%% Compute the energy for each trial, across channels, for each amplitude

energy = zeros(length(amps), nTrials, params.elecs);

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
        
        energyPre = rms(data_chunkPre,2); energyPost = rms(data_chunkPost,2);

        % Compute the energy of the chunk of data for each trial
        energy(iAmp,iTrial,:) = ((energyPost-energyPre)./(energyPost+energyPre))*100; % mean of the RMS of across channels
    end
end

% Reshape to collapse
pooledEnergy = reshape(energy, size(energy,1), [])';