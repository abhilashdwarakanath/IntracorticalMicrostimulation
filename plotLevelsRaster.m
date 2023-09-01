clear all
clc
close all

%% Load data

cd('C:\Users\Abhilash Dwarakanath\Documents\MATLAB\RS_ICMS\RS_Data\PFC\2\11')
load('neuralActivity.mat')
aw = neuralActivity; clear neuralActivity;

cd('C:\Users\Abhilash Dwarakanath\Documents\MATLAB\RS_ICMS\RS_Data\PFC\2\21')
load('neuralActivity.mat')
ls = neuralActivity; clear neuralActivity;

cd('C:\Users\Abhilash Dwarakanath\Documents\MATLAB\RS_ICMS\RS_Data\PFC\2\31')
load('neuralActivity.mat')
ds = neuralActivity; clear neuralActivity;

%% Remove chutiya firing neurons

rasterAw = aw.spikes.activity;
tAw = aw.spikes.t;
frAw = sum(rasterAw,2)/tAw(end);
valChans = frAw>2.5;

rasterAw = rasterAw(valChans,:);
lfpAw = aw.lfp.activity(valChans,:);

rasterLS = ls.spikes.activity;
rasterLS = rasterLS(valChans,:);
lfpLS = ls.lfp.activity(valChans,:);

rasterDS = ds.spikes.activity;
rasterDS = rasterDS(valChans,:);
lfpDS = ds.lfp.activity(valChans,:);

clear aw; clear ls; clear ds;

%% Plot the rasters in 20s chunks

xlimits(:,1) = 0:10:1180;
xlimits(:,2) = 20:10:1200;

for iEpoch = 1:size(xlimits,1)

    [~,idx11] = min(abs(tAwake-xlimits(iEpoch,1)));
    [~,idx21] = min(abs(tAwake-xlimits(iEpoch,2)));
    
    [~,idx12] = min(abs(binsAwake-xlimits(iEpoch,1)));
    [~,idx22] = min(abs(binsAwake-xlimits(iEpoch,2)));

    subplot(3,1,1)
    yyaxis right
    plotSpikeRaster(logical(valRasterAwake(:,idx11:idx21-1)),'PlotType','vertline','XlimForCell',xlimits(iEpoch,:),'VertSpikeHeight',0.5);
    axis xy
    yyaxis left
    plot(binsAwake(idx12:idx22-1),alphaAwake(1,(idx12:idx22-1)),'LineWidth',1.5)

    subplot(3,1,2)
    plotSpikeRaster(logical(valRasterLS(:,idx11:idx21-1)),'PlotType','vertline','XlimForCell',xlimits(iEpoch,:),'VertSpikeHeight',0.5);
    hold on
    axis xy

    subplot(3,1,3)
    plotSpikeRaster(logical(valRasterDS(:,idx11:idx21-1)),'PlotType','vertline','XlimForCell',xlimits(iEpoch,:),'VertSpikeHeight',0.5);
    hold on
    axis xy

    pause

    close all

end

%% Run HMM