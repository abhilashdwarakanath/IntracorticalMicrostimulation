function browseData(data,t, params)

%% Set up some parameters

fs = params.targetFreq; % Sampling rate
duration = params.dispFrame; % Duration of each plot in seconds
num_samples = size(data, 1); % Total number of samples
num_plots = floor(num_samples / (duration * fs)); % Total number of plots

% Define persistent variable to store the current plot number
persistent current_plot;
if isempty(current_plot)
    current_plot = 1; % Initialize current plot to the first one
end

%% Set up the figure and axes

fig = uifigure;
set(fig, 'WindowState', 'maximized');

% Plot the initial data

ax = stackedplot(fig,t,data);

%% Shrink plot to fit buttons

ax.Position(3) = ax.Position(3) * 0.85;
ax.Position(4) = ax.Position(4) * 0.85;
ax.OuterPosition(3) = ax.OuterPosition(3) * 0.85;
ax.OuterPosition(4) = ax.OuterPosition(4) * 0.85;
title(ax, ['Dataframe : ' num2str(current_plot)]);
xlabel(ax,'time [s]');
xlim(ax,[1 duration]);

%% Set up the forward and back and close buttons

btn_forward = uibutton(fig, 'push', 'Position', fig.Position .*  [0.85 0.005 0.1 0.1], ...
    'Text', 'Forward', 'ButtonPushedFcn', @next_plot);
btn_back = uibutton(fig, 'push', 'Position', fig.Position .*  [0.05 0.005 0.1 0.1], ...
    'Text', 'Back', 'ButtonPushedFcn', @previous_plot);
btn_close = uibutton(fig, 'push', 'Position', fig.Position .*  [0.05 0.05 0.1 0.1], ...
    'Text', 'Close', 'ButtonPushedFcn', @(~,~)close(fig));

%% Setup back and forward callback functions and update plot

    function next_plot(~, ~)
        if current_plot == num_plots
            current_plot = 1;
        else
            current_plot = current_plot + 1;
        end
        tChunk = t((1+fs*duration*(current_plot-1)):(fs*duration*current_plot));
        xlim(ax,[tChunk(1) tChunk(end)]);
        title(ax, ['Dataframe : ' num2str(current_plot)]);

    end

    function previous_plot(~, ~)
        if current_plot == 1
            current_plot = num_plots;
        else
            current_plot = current_plot - 1;
        end
        tChunk =  t((1+fs*duration*(current_plot-1)):(fs*duration*current_plot));
        xlim(ax,[tChunk(1) tChunk(end)]);
        title(ax, ['Dataframe : ' num2str(current_plot)]);
    end

%% Store the handles for the buttons in the UserData property of the axes
ax.ApplicationData.btn_forward = btn_forward;
ax.ApplicationData.btn_back = btn_back;
ax.ApplicationData.btn_close = btn_close;

%% Set up the keyboard callbacks
set(fig, 'KeyPressFcn', @key_press_callback);

    function key_press_callback(~, event)
        switch event.Key
            case 'rightarrow'
                next_plot();
            case 'leftarrow'
                previous_plot();
            case 'escape'
                close(fig);
        end
    end

end
