clear all
clc
close all

%% Load computed pooled shit

cd('C:\Users\Abhilash Dwarakanath\Documents\MATLAB\RS_ICMS\RS_Data\PFC')
load('pooledLFPl2Norm6.mat')
load('distances.mat')
%% Compute means and SEMs SPIKING

% aw = cell(1,6);
% ls = cell(1,6);
% for iAmp = 1:7
% 	for iSes = 1:3
% 		for iDist = 1:length(distances)
% 			if ~isempty(l2AwakeBaseMod{iAmp}{iSes}{iDist}) | ~isnan(l2AwakeBaseMod{iAmp}{iSes}{iDist}) %#ok<*OR2>
% 				aw{iDist} = [aw{iDist};l2AwakeBaseMod{iAmp}{iSes}{iDist}'];
% 			end
%
% 			if ~isempty(l2LSBaseMod{iAmp}{iSes}{iDist}) | ~isnan(l2LSBaseMod{iAmp}{iSes}{iDist})
% 				ls{iDist} = [ls{iDist};l2LSBaseMod{iAmp}{iSes}{iDist}'];
% 			end
%
% 		end
% 	end
% end
%
% ds = cell(1,6);
% for iAmp = 1:7
% 	for iSes = 1:2
% 		for iDist = 1:length(distances)
%
% 			if ~isempty(l2DSBaseMod{iAmp}{iSes}{iDist}) | ~isnan(l2DSBaseMod{iAmp}{iSes}{iDist})
% 				ds{iDist} = [ds{iDist};l2DSBaseMod{iAmp}{iSes}{iDist}'];
% 			end
%
% 		end
% 	end
% end
%
% for i = 1:6
%
% 	meanAwake(i) = nanmean(aw{i});
% 	errAwake(i) = nanstd(aw{i},[],1)./sqrt(length(aw{i}));
%
% 	meanLS(i) = nanmean(ls{i});
% 	errLS(i) = nanstd(ls{i},[],1)./sqrt(length(ls{i}));
%
% 	meanDS(i) = nanmean(ds{i});
% 	errDS(i) = nanstd(ds{i},[],1)./sqrt(length(ds{i}));
%
% end

% [fitResultAWLine_Low,gofAwLine_Low] = modVsDistFits(distances,meanl2NormAwake{1},errl2NormAwake{1},'poly1');
% [fitResultAWPara_Low,gofAwPara_Low] = modVsDistFits(distances,meanl2NormAwake{1},errl2NormAwake{1},'poly2');
% [fitResultAWLine_High,gofAwLine_High] = modVsDistFits(distances,meanl2NormAwake{2},errl2NormAwake{2},'poly1');
% [fitResultAWPara_High,gofAwPara_High] = modVsDistFits(distances,meanl2NormAwake{2},errl2NormAwake{2},'poly2');
% 
% [fitResultLSLine_Low,gofLSLine_Low] = modVsDistFits(distances,meanl2NormLS{1},errl2NormLS{1},'poly1');
% [fitResultLSPara_Low,gofLSPara_Low] = modVsDistFits(distances,meanl2NormLS{1},errl2NormLS{1},'poly2');
% [fitResultLSLine_High,gofLSLine_High] = modVsDistFits(distances,meanl2NormLS{2},errl2NormLS{2},'poly1');
% [fitResultLSPara_High,gofLSPara_High] = modVsDistFits(distances,meanl2NormLS{2},errl2NormLS{2},'poly2');
% 
% [fitResultDSLine_Low,gofDSLine_Low] = modVsDistFits(distances,meanl2NormDS{1},errl2NormDS{1},'poly1');
% [fitResultDSPara_Low,gofDSPara_Low] = modVsDistFits(distances,meanl2NormDS{1},errl2NormDS{1},'poly2');
% [fitResultDSLine_High,gofDSLine_High] = modVsDistFits(distances,meanl2NormDS{2},errl2NormDS{2},'poly1');
% [fitResultDSPara_High,gofDSPara_High] = modVsDistFits(distances,meanl2NormDS{2},errl2NormDS{2},'poly2');

[fitResultAWLine_Low,gofAwLine_Low] = modVsDistFits(distances,y1,e1,'poly1');
[fitResultAWPara_Low,gofAwPara_Low] = modVsDistFits(distances,y1,e1,'poly2');

[fitResultLSLine_Low,gofLSLine_Low] = modVsDistFits(distances,y2,e2,'poly1');
[fitResultLSPara_Low,gofLSPara_Low] = modVsDistFits(distances,y2,e2,'poly2');

[fitResultDSLine_Low,gofDSLine_Low] = modVsDistFits(distances,y3,e3,'poly1');
[fitResultDSPara_Low,gofDSPara_Low] = modVsDistFits(distances,y3,e3,'poly2');


%% Plot
for i = 1:2
	figure(i+12)
	errorbar(distances,meanl2NormAwake{i},errl2NormAwake{i},'or','LineWidth',2)
	hold on
	errorbar(distances,meanl2NormLS{i},errl2NormLS{i},'og','LineWidth',2)
	errorbar(distances,meanl2NormDS{i},errl2NormDS{i},'ob','LineWidth',2)
	box off
	xlim([0.5 2.7])
end
