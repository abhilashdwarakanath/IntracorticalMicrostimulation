clear all;
close all;
clc;

% Present ICMS pulses randomised across pulse parameters, electrodes and leading polarity during Resting State
% Maria Alfaro and Abhilash Dwarakanath. UniCog, NeuroSpin.
% Last update - February 2021

%% Initialise Cerestim

% Create stimulator object
stimulator = cerestim96();

% Check for stimulators
DeviceList = stimulator.scanForDevices();

% Select a stimulator
stimulator.selectDevice(DeviceList(1));

% Connect to the stimulator
stimulator.connect;

%% Names and directories

subjID = 'H07'; % Name of the monkey
date = 20220920; % Date of recording
directories.recording = ['D:\Data\' subjID '\' num2str(date)];
mkdir(directories.recording)
cd(directories.recording)

%% Chans to elecs and map

ROIs = [{'PFC'}, {'PPC'}];

arrayToStim = ROIs{2}; % CHANGE THIS LINE TO CHOOSE WHICH ARRAY TO STIMULATE

if strcmp(subjID,'J08')
    
    if strcmp(arrayToStim, 'PFC')
        
        chans = 1:96;
        elecs = [78 88 68 58 56 48 57 38 47 28 37 27 36 18 45 17 46 8 35 16 24 7 26 6 25 5 15 4 14 3 13 2 77 67 76 66 75 65 74 64 73 54 63 53 72 43 62 55 61 44 52 33 51 34 41 42 31 32 21 22 11 23 10 12 96 87 95 86 94 85 93 84 92 83 91 82 90 81 89 80 79 71 69 70 59 60 50 49 40 39 30 29 19 20 1 9];
        
        chan2elec = [chans' elecs'];
        
        map = [NaN 88	78	68	58	48	38	28	18 NaN
            96	87	77	67	57	47	37	27	17	8
            95	86	76	66	56	46	36	26	16	7
            94	85	75	65	55	45	35	25	15	6
            93	84	74	64	54	44	34	24	14	5
            92	83	73	63	53	43	33	23	13	4
            91	82	72	62	52	42	32	22	12	3
            90	81	71	61	51	41	31	21	11	2
            89	80	70	60	50	40	30	20	10	1
            NaN 79	69	59	49	39	29	19	9 NaN]; % Electrode map of the particular array. Here it is J08's Prefrontal array
        
    else
        
        % Enter PPC Stuff here
        
    end
    
elseif strcmp(subjID,'H07')
    
    if strcmp(arrayToStim, 'PFC')
        
        % enter PFC here
        
    else
        
        chans = 1:96;
        elecs = [78 88 68 58 56 48 57 38 47 28 37 27 36 18 45 17 46 8 35 16 24 7 26 6 25 5 15 4 14 3 13 2 77 67 76 66 75 65 74 64 73 54 63 53 72 43 62 55 61 44 52 33 51 34 41 42 31 32 21 22 11 23 10 12 96 87 95 86 94 85 93 84 92 83 91 82 90 81 89 80 79 71 69 70 59 60 50 49 40 39 30 29 19 20 1 9];
        
        chan2elec = [chans' elecs'];
        
        map = [NaN 88	78	68	58	48	38	28	18	29
            96	87	77	67	57	47	37	27	17	8
            95	86	76	66	56	46	36	26	16	7
            94	85	75	65	55	45	35	25	15	6
            93	84	74	64	54	44	34	24	14	5
            92	83	73	63	53	43	33	23	13	4
            91	82	72	62	52	42	32	22	12	3
            NaN 81	71	61	51	41	31	21	11	2
            89	80	70	60	50	40	30	NaN 10	1
            90	79	69	59	49	39	NaN	19	9	20];
    end
    
elseif strcmp(subjID,'Dummy')
    
    if strcmp(arrayToStim, 'PFC')
        
        chans = 1:96;
        elecs = [78 88 68 58 56 48 57 38 47 28 37 27 36 18 45 17 46 8 35 16 24 7 26 6 25 5 15 4 14 3 13 2 77 67 76 66 75 65 74 64 73 54 63 53 72 43 62 55 61 44 52 33 51 34 41 42 31 32 21 22 11 23 10 12 96 87 95 86 94 85 93 84 92 83 91 82 90 81 89 80 79 71 69 70 59 60 50 49 40 39 30 29 19 20 1 9];
        
        chan2elec = [chans' elecs'];
        
        map = [];
        
    end
    
end

%% Setup up all parameters

% Electrode params
params.elecs = 96; % # of electrodes

% Trial params
params.nTrialsPerWaveform = 120; % repeats per combination
params.minPause = 0.5; %seconds
params.maxPause = 1; %seconds

% Pulse params
params.amplitude = [210]; % microAmps
params.frequency = [250]; % Hz

%% Choose electrodes to stimulate

stimElecs = [1:96]; % Choose which electrodes to stimulate
stimChans = (chan2elec(stimElecs,2)); % Get the corresponding channels on the Pin

%% Create trials

waveTypes = allcomb(params.amplitude,params.frequency);
waveTypes = waveTypes';

allTrials = repmat(1:size(waveTypes,2),1,params.nTrialsPerWaveform);

shuffled = ShuffleRC(allTrials, 2); % Randomise trial presentation order

%% Start stimulation, collect trial numbers, IDs

trialInfo(size(shuffled,2)).wavID = [];

for iStim = 1:size(shuffled,2)
    %%Program our waveform (stim pattern)
    
    % get waveform params and ID. There are N distinct waveforms without
    % repetitions
    
    tic;
    
    waveform_Id = shuffled(1,iStim); % The current waveform
    
    pars = waveTypes(:,waveform_Id);
    
    stimulator.setStimPattern('waveform',1,...
        'polarity',0,...%0=CF, 1=AF
        'pulses',50,...%Number of pulses in stim pattern
        'amp1',pars(1),...%Amplitude in uA
        'amp2',pars(1),...%Amplitude in uA
        'width1',50,...%Width for first phase in us
        'width2',50,...%Width for second phase in us
        'interphase',53,...%Time between phases in us
        'frequency',pars(2));%Frequency determines time between biphasic pulses
    
    stimulator.setStimPattern('waveform',2,...
        'polarity',1,...%0=CF, 1=AF
        'pulses',50,...%Number of pulses in stim pattern
        'amp1',pars(1),...%Amplitude in uA
        'amp2',pars(1),...%Amplitude in uA
        'width1',50,...%Width for first phase in us
        'width2',50,...%Width for second phase in us
        'interphase',53,...%Time between phases in us
        'frequency',pars(2));%Frequency determines time between biphasic pulses
    
    stimulator.beginSequence();
    stimulator.beginGroup();
    stimulator.autoStim(1:2:15, 1);
    stimulator.autoStim(2:2:16, 2);
    stimulator.endGroup();
    
    stimulator.beginGroup();
    stimulator.autoStim(17:2:31, 1);
    stimulator.autoStim(18:2:32, 2);
    stimulator.endGroup();
    
    stimulator.beginGroup();
    stimulator.autoStim(33:2:47, 1);
    stimulator.autoStim(34:2:48, 2);
    stimulator.endGroup();
    
    stimulator.beginGroup();
    stimulator.autoStim(49:2:63, 1);
    stimulator.autoStim(50:2:64, 2);
    stimulator.endGroup();
    
    stimulator.beginGroup();
    stimulator.autoStim(65:2:79, 1);
    stimulator.autoStim(66:2:80, 2);
    stimulator.endGroup();
    
    stimulator.beginGroup();
    stimulator.autoStim(81:2:95, 1);
    stimulator.autoStim(82:2:96, 2);
    stimulator.endGroup();
    stimulator.endSequence();
    
    stimulator.play(1);
    
    trialInfo(iStim).wavID = waveform_Id;
    
    disp(['Trial: ' num2str(iStim) '. ' 'Amp: ' num2str(pars(1)) 'uA. ' 'Freq: ' num2str(pars(2)) 'Hz. ' 'Polarity: Alternate Bipolar']);
    
    % pause for a random period - inter-trial interval
    
    randTime = params.maxPause + (params.maxPause-params.minPause)*rand;
    pause(randTime);
    toc;
    
end

%% Save param files

cd(directories.recording)
save('trialInfo_FAHAProp2.mat','trialInfo','','stimElecs');
save('waveformParsIds_FAHAProp2.mat','waveTypes');
stimulator.disconnect;
close all
clear stimulator
clear all