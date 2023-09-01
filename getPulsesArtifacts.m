function [trialStruct] = getPulsesArtifacts(params,trialInfo,wavIds,directories,pulses,t)

%extract wavID from trialInfo
cd(directories.recording)

%extract wavID from trialInfo
load(trialInfo);
load(wavIds);
wavID = [trialInfo.wavID];
wavID = reshape(wavID',[],1);

%% filloutliers signal filter using moving median to smooth outlier data points
pulses = filloutliers((pulses),'clip','movmedian',0.01,'SamplePoints',t);

%%input sampling rate frequency
fs = params.fs;
dt = 1/fs;

%% collect durations and on-off times
% x=1;
% y=1;
% n=0;
% n1=0;
% n2=0;
% pulseTimings=[zeros(4,length(wavID))];
% z=1; % put start & end timings into a consecutive order in a separate array
% nPoints = length(pulses);
% 
% for iPoint = 1:nPoints
%     
%     if (iPoint+2) ~= length(pulses)&&(iPoint+1) ~= length(pulses)&&iPoint ~= length(pulses)
%         
%         n = pulses(iPoint);
%         n1 = pulses(iPoint+1);
%         n2 = pulses(iPoint+2);
%         
%     else
%         
%         n=pulses(iPoint);
%         n1 = pulses(iPoint);
%         n2 = pulses(iPoint);
%         
%     end
%     
%     if n<=0 && n1>=1
%         pulseTimings(1,z)=t(iPoint); %records time of on pulse
%         
%     elseif n>=1 && n1<=0
%         pulseTimings(2,z)=t(iPoint); %records time of off pulse, places underneath
%         z = z+1;
%     end
% end
% 
% clear i

[~,idxon] = findpeaks(diff(pulses),'MinPeakHeight',500);
[~,idxoff] = findpeaks(diff(-pulses),'MinPeakHeight',500);

nPulses = length(idxon);

for iPulse = 1:nPulses
    pulseTimings(1,iPulse) = t(idxon(iPulse));
    pulseTimings(2,iPulse) = t(idxoff(iPulse));
    temp = pulseTimings(2,iPulse)-pulseTimings(1,iPulse);
    pulseTimings(3,iPulse) = temp;%appends pulse duration
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
