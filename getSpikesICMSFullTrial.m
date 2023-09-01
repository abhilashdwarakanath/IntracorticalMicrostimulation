function spikes = getSpikesICMSFullTrial(params,x, t)

[b,a] = butter(params.filterorder,params.passband);

samples = filtfilt(b,a,x);

nChunk = 10;

for i = 1:nChunk
    r = randi([1 length(samples)-params.fs],1,1);
    noiseforms = samples(r:r+params.fs);
    thr(i) = median(abs(noiseforms)/0.6745);
end

thr = mean(thr);

minpeakdist = (params.refractory*params.fs)/1000; % This can be changed. This is ideally the refractory period

minpeakh = params.stdmin*thr;
maxpeakh = params.stdmax*thr;

tminus = ceil((params.beforeSpike*params.fs)/1000);
tplus = ceil((params.afterSpike*params.fs)/1000);

%% Detect spikes

fprintf('Detecting spikes...\n')
if size(samples,2)==1
    samples=samples';
end


%  Spikes

locs=find(samples(2:end-1)<=samples(1:end-2) & samples(2:end-1)<=samples(3:end))+1;

% Correct for spikes that don't really match the chosen thresholds
locs(samples(locs)>=minpeakh)=[];
locs(samples(locs)<=maxpeakh)=[];

% Correct and align spikes smaller than the refractory period

fprintf('Correcting and aligning spikes...\n')
if minpeakdist>1
    while 1
        
        del=diff(locs)<minpeakdist;
        
        if ~any(del), break; end % There must be a more efficient way of doing this instead of using break?
        
        pks=samples(locs);
        
        [~,mins]=min([pks(del) ; pks([false del])]);
        
        deln=find(del);
        
        deln=[deln(mins==1) deln(mins==2)+1];
        
        locs(deln)=[];
        
    end
end

%% Collect waveforms

% Maybe we should integrate getting the positive and negative spikeforms
% separately?

fprintf('Collecting waveforms...\n');

spikeForms = zeros(length(locs),tminus+tplus);

for i = 1:length(locs)
    if locs(i) > 2*tminus && locs(i) < locs(end)-2*tminus
        spikeForms(i,:) = [samples(locs(i)-tminus+1:locs(i)+tplus)];
    end
    
end

% If there any 0 rows, i.e. any spike before tminus, remove it

emptyWaveform = find(~any(spikeForms,2));
spikeForms(emptyWaveform,:) = [];
locs(emptyWaveform) = [];

% if any big artifacts sneak in

v = var(spikeForms,[],2);
m = median(v);
idx = find(v>=3.5*m);

spikeForms(idx,:) = [];
locs(idx) = [];

stimOff = find(t == 0)./params.fs;
locs = locs./params.fs;
locs = locs-stimOff;

spikes.waveforms = spikeForms;
spikes.times = locs;