function [trialStruct] = getPulsesBigExpt(params,trialInfo,wavIds,directories,pulses,t)

cd(directories.recording)

%extract wavID from trialInfo
load(trialInfo);
load(wavIds);
wavID = [trialInfo.wavID];
wavID = reshape(wavID',[],1);

%neuralSignal = resample(neuralSignal,4,1);

pulses = filloutliers(double(pulses),'clip','movmedian',0.01,'SamplePoints',t);

%pulses = normalise(pulses);

%% Check if any params are need?

fs = params.analogFs;

%% Collect on and off times

d = diff(pulses);
[idxon] = find(d>=750);
[idxoff] = find(d<=-750);
onTimes = t(idxon);
offTimes = t(idxoff);

pulseTimings(1,:) = onTimes;
pulseTimings(2,:) = offTimes;
pulseTimings(3,:) = offTimes-onTimes;

nPulses = length(pulseTimings);

for iPulse = 1:nPulses
    pulseTimings(4,iPulse) = wavID(iPulse,1);%appends waveform ID
end

trialStruct.onTimes = pulseTimings(1,:);
trialStruct.offTimes = pulseTimings(2,:);
trialStruct.pulseDurations = pulseTimings(3,:);
trialStruct.wavIDs = wavID;

%% Sort by trial types

waveforms = unique(wavID);

for iWav = 1:length(waveforms)
    [idx] = find(wavID==waveforms(iWav));
    trialStruct.trialTypes(iWav,:) = idx;
    clear idx
end

trialStruct.waveParams = waveTypes';

cd(directories.taskdirPFC)
save('trialInfo.mat','trialStruct');

