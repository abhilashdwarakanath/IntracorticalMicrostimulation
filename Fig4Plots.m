clear all
clc
close all

%% Spikes

cd('C:\Users\Abhilash Dwarakanath\Documents\MATLAB\RS_ICMS\RS_Data\PFC')
load respChars_Spiking.mat

for iAmp = 1:6

	ptAwake = [];
	ptLS = [];
	ptDS = [];

	clear data; clear groups; clear colours;

	for iResp = 1:length(peakTimesAwake{iAmp})
		ptAwake = [ptAwake peakTimesAwake{iAmp}{iResp}];
	end

	for iResp = 1:length(peakTimesLS{iAmp})
		ptLS = [ptLS peakTimesLS{iAmp}{iResp}];
	end

	for iResp = 1:length(peakTimesDS{iAmp})
		ptDS = [ptDS peakTimesDS{iAmp}{iResp}];
	end

	data{1} = ptAwake;
	data{2} = ptLS;
	data{3} = ptDS;

	figure(iAmp);
	violin(data,'xlabel',{'QW','LS','DS'},'facecolor',[1 0 0; 0 1 0; 0 0 1],'edgecolor','w');
	box off; legend off; axis tight;

	% data = [ptAwake'; ptLS'; ptDS'];
	% groups = [ones(length(ptAwake),1);2*ones(length(ptLS),1);3*ones(length(ptDS),1)];
	% colours = [ones(length(ptAwake),1);2*ones(length(ptLS),1);3*ones(length(ptDS),1)];
	% 
	% clear g;
	% figure(iAmp);
	% g = gramm('x',groups,'y',data,'color',colours);
	% g.stat_violin();
	% g.draw()
	% xlim([0.5 3.5])

end

clear peakTimesAwake; clear peakTimesLS; clear peakTimesDS;
clear widthsAwake; clear widthsLS; clear widthsDS;
clear data; clear groups; clear colours; clear ans; clear g;
%% LFP

cd('C:\Users\Abhilash Dwarakanath\Documents\MATLAB\RS_ICMS\RS_Data\PFC')
load respChars_LFP.mat

for iAmp = 1:6

	clear data; clear groups; clear colours;

	ptAwake = postDipAwake{iAmp};
	ptLS = postDipLS{iAmp};
	ptDS = postDipDS{iAmp};

	%data = (([ptAwake; ptLS; ptDS]));
	%groups = [ones(length(ptAwake),1);2*ones(length(ptLS),1);3*ones(length(ptDS),1)];
	%colours = [ones(length(ptAwake),1);2*ones(length(ptLS),1);3*ones(length(ptDS),1)];

	%invalIdxs = isnan(data);

	%data(invalIdxs) = [];
	%groups(invalIdxs) = [];
	%colours(invalIdxs) = [];
	
	data{1} = real(log(ptAwake));
	data{2} = real(log(ptLS));
	data{3} = real(log(ptDS));

	figure(iAmp);
	violin(data,'xlabel',{'QW','LS','DS'},'facecolor',[1 0 0; 0 1 0; 0 0 1],'edgecolor','w');
	box off; legend off; axis tight;
	clear g;
	
	% g = gramm('x',groups,'y',data,'color',colours);
	% g.stat_violin();
	% g.draw()
	% xlim([0.5 3.5])

end