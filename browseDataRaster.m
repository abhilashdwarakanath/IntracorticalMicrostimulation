function browseDataRaster(spikeData,lfpData,params)
%
% Browse through resting state data, LFP and rasters. AD. NS 2023

%% Get and setup parameters

fs = params.targetFreq; % Sampling rate
duration = params.dispFrame; % Duration of each plot in seconds
nSamps = size(spikeData, 2); % Total number of samples
nFrames = floor(nSamps / (duration * fs)); % Total number of plots

% Define persistent variable to store the current plot number

persistent currentFrame;

if isempty(currentFrame)
    currentFrame = 1; % Initialize current plot to the first one
end

%% Set up the figure and axes

fig = uifigure; % Create a figure with UI control
set(fig, 'WindowState', 'maximized'); % Maximise that shit
spikeAx = axes(fig);

% Plot the initial data - FIND A BETTER WAY TO DO THIS. TAKES A LOOOONG TIME.

for iChan = 1:size(spikeData,1)
    spikeTimes = find(spikeData(iChan,1:duration*fs)==1);
    for iSpk = 1:length(spikeTimes)
        plot(spikeAx, [spikeTimes(iSpk)./fs spikeTimes(iSpk)./fs],[iChan iChan+0.5],'-k');
        % LOL
        hold(spikeAx, "on")
    end
end

plot(spikeAx,(1:duration*fs)./fs,(lfpData(1:duration*fs)*32)-4,'LineWidth',2,'Color',[0.8500 0.3250 0.0980 0.5])

% LOL. Yep, thanks MATLAB. That's why we need this shit.
hold(spikeAx, "off")

%% Shrink plot to fit buttons

spikeAx.Position(3) = spikeAx.Position(3) * 0.85; % Uh I tried to scale the axes to 85%. 
spikeAx.Position(4) = spikeAx.Position(4) * 0.85; 
spikeAx.OuterPosition(3) = spikeAx.OuterPosition(3) * 0.85; % Doesn't seem to work?
spikeAx.OuterPosition(4) = spikeAx.OuterPosition(4) * 0.85;
title(spikeAx, ['Dataframe : ' num2str(currentFrame)]);
xlabel(spikeAx,'time [s]');

%% Define the forward and back and close buttons

btn_forward = uibutton(fig, 'push', 'Position', fig.Position .*  [0.85 0.005 0.1 0.1], 'Text', 'Forward', 'ButtonPushedFcn', @nextFrame);
btn_back = uibutton(fig, 'push', 'Position', fig.Position .*  [0.05 0.005 0.1 0.1], 'Text', 'Back', 'ButtonPushedFcn', @previousFrame);
btn_close = uibutton(fig, 'push', 'Position', fig.Position .*  [0.05 0.05 0.1 0.1],'Text', 'Close', 'ButtonPushedFcn', @(~,~)close(fig));

%% Setup back and forward callback functions and update plot

    function nextFrame(~, ~)
        if currentFrame == nFrames
            currentFrame = 1;
        else
            currentFrame = currentFrame + 1;
        end
        tChunk = (1+fs*duration*(currentFrame-1)):(fs*duration*currentFrame);
        for iChan = 1:size(spikeData,1) %#ok<*FXUP> 
            spikeTimes = find(spikeData(iChan,tChunk)==1);
            for iSpk = 1:length(spikeTimes)
                plot(spikeAx, [duration*(currentFrame-1) + spikeTimes(iSpk)./fs duration*(currentFrame-1) + spikeTimes(iSpk)./fs],[iChan iChan+0.5],'-k');
                hold(spikeAx, "on")
            end
        end
        plot(spikeAx,tChunk./fs,(lfpData(tChunk)*32)-4,'LineWidth',2,'Color',[0.8500 0.3250 0.0980 0.5])
        hold(spikeAx, "off")
        xlabel(spikeAx,'time [s]');
        title(spikeAx, ['Dataframe : ' num2str(currentFrame)]);
    end
        

    function previousFrame(~, ~)
        if currentFrame == 1
            currentFrame = nFrames;
        else
            currentFrame = currentFrame - 1;
        end
        tChunk = (1+fs*duration*(currentFrame-1)):(fs*duration*currentFrame);
        for iChan = 1:size(spikeData,1)
            spikeTimes = find(spikeData(iChan,tChunk)==1);
            for iSpk = 1:length(spikeTimes)
                plot(spikeAx, [duration*(currentFrame-1) + spikeTimes(iSpk)./fs duration*(currentFrame-1) + spikeTimes(iSpk)./fs],[iChan iChan+0.5],'-k');
                hold(spikeAx, "on")
            end
        end
        plot(spikeAx,tChunk./fs,(lfpData(tChunk)*32)-4,'LineWidth',2,'Color',[0.8500 0.3250 0.0980 0.5])
        hold(spikeAx, "off")
        xlabel(spikeAx,'time [s]');
        title(spikeAx, ['Dataframe : ' num2str(currentFrame)]);
    end

%% Store the handles for the buttons in the ApplicationData property of the axes, for updating

spikeAx.ApplicationData.btn_forward = btn_forward;
spikeAx.ApplicationData.btn_back = btn_back;
spikeAx.ApplicationData.btn_close = btn_close;

%% Set up the keyboard callbacks

set(fig, 'KeyPressFcn', @key_press_callback);

    function key_press_callback(~, event)
        switch event.Key
            case 'rightarrow'
                nextFrame();
            case 'leftarrow'
                previousFrame();
            case 'escape'
                close(fig);
        end
    end

end
