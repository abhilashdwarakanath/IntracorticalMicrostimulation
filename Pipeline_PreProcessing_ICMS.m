clear all
close all
clc

% Postprocessing Pipeline for the ICMS experiments.

%% Monkey name, experiment name, date, folders etc.

subjID = 'H07';
date = '20210128';

directories.recording = ['C:\Users\Abhilash Dwarakanath\Documents\MATLAB\RS_ICMS\H07\' date];
recDate = extractAfter(directories.recording,'J08\');
subjName = 'Hayo';
cd(directories.recording) % Enter the data directory here % On Node 2

mkdir PPC
mkdir PFC
mkdir Tracker
mkdir Analog

directories.PFC = [directories.recording '\PFC'];
directories.PPC = [directories.recording '\PPC'];
directories.tracker = [directories.recording '\Tracker'];
directories.analog = [directories.recording '\Analog'];

%% Get filenames for nev and nsx

% NEV files
nevfiles = dir( [directories.recording '/*.nev']); %get files matching pattern
nevfiles = {nevfiles.name};

% ns5 files

recfiles = dir( [directories.recording '/*.ns5']); %get files matching pattern
recfiles = {recfiles.name};

% ns2 files

analogfiles = dir( [directories.recording '/*.ns3']); %get files matching pattern
analogfiles = {analogfiles.name};

%% Parameters

global params % use global variable params so that PARFOR doesn't get cranky

% General params
params.fs = 30000; % in Hz
params.analogFs = 2000;
params.chans = 96*2;
params.elecs = 96*2;
params.nAnalogIns = 16;
%params.clean = 0; % In samples. Usually for NSP1 this is the "Timestamp" value. DEPRECATED. USE NOZEROPAD INSTEAD

% For LFP stuff

params.targetFreq = 500;
params.trialLength = 10; % in seconds!! This is either the length of your trial from the DGZ file or the pieces you use to compute the coherence
params.tapers = 5/2;
params.decimCoeff = params.fs/params.targetFreq; % For reducing sampling rate
params.decimFacs = computeDecimationFactors(params.decimCoeff);

% For spike stuff

params.passband = [600 3000]/(params.fs/2);
params.low = 600; params.high = 3000;
params.stopband = [400 3200]/(params.fs/2); % These are the parameters Alex Ecker uses
params.passripple = 0.002; % Maximum allowed dB of the pass-band ripple
params.stopatten = 60; % Minimum 50dB of attenuation in the stop-band.
params.minSpkNum = 4; % Currently this is set to number of spikes. We can later threshold it in Hz
params.numFeatures = 3; % THIS HAS TO BE LESS THAN OR EQUAL TO THE NUMBER OF SPIKES!!!!
params.stdmin = -5; % First number is for negative thresholded channels
params.stdmax = -50;                     % maximum threshold for detection
params.refractory = 0.5; %ms
params.beforeSpike = 0.5;
params.afterSpike = 1;
params.min_spk = 1;
params.max_spk = 10000;
params.minclus = 5;
params.maxclus = 5;
params.filterorder = 2; % We will use a 2nd order Butterworth filter.
params.offs = 2;
params.thrsh = 60;

% For PSTH stuff
params.kerneltype = 'alpha'; %
params.psthbinsize = 0.025; % in SECONDS please
params.conditions = 8;

% for correlations stuff
params.binsize = 0.015; % in SECONDS please
params.maxlag = 0.5; % in SECONDS

%max_memo_GB = 8; DEPRECATED
notchfilter = 0;

%% Parse the data

whichFiles = 1;
%whichChans = [1:194];
%whichChans = [1:96 129:224];
whichChans = [129:224];
nc5exist=~isempty(dir('*.NC5'));

if nc5exist==0
    cd(directories.recording)
    if length(recfiles)>1   % if two or more recorded files are used
        
        disp('Found 2 datasets...now merging...')
        
        
        mergeNSxNEV(analogfiles{2},analogfiles{1});
        %mergeNSxNEV(recfiles{1},recfiles{2});
        
        recfiles = [recfiles{2}];
        analogfiles = [analogfiles{2}] ;
        
        
        writeDataNSxNEV(params,recfiles{whichFiles(1)},whichChans,directories);
        
    else
        
        writeDataNSxNEV(params,recfiles{whichFiles(1)},whichChans,directories);
        
    end
    
else
    fprintf('This dataset has already been parsed!\n')
    
end


%% Parse the analog data

whichFiles = 1;

    cd(directories.recording)
    if length(recfiles)>1   % if two or more recorded files are used
        
        disp('Found 2 datasets...now merging...')
        
        
        mergeNSxNEV(analogfiles{2},analogfiles{1});
        %mergeNSxNEV(recfiles{1},recfiles{2});
        
        recfiles = [recfiles{2}];
        analogfiles = [analogfiles{2}] ;
        
        writeDataNS3(params,analogfiles,directories);
    else
        writeDataNS3(params,analogfiles{whichFiles(1)},directories);
    end

cd(directories.analog)

load('NSX_TimeStamps.mat');

for iChan = 1:params.nAnalogIns-7 % Only the first nine contain data
    
    dat = read_NC5(['AnInp' num2str(iChan) '.NC5'],1,lts);
    analog(iChan).data = dat;
    
    clear dat
    
end

save('analogData.mat','analog','-v7.3')
%% Load the pulses and do preprocessing

pulses = analog(9).data;
t = linspace(0,length(pulses)/params.analogFs,length(pulses));
trialStruct = getPulses(params,directories,pulses,t);

%% Analyse the neural data