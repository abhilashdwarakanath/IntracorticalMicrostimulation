fs = 3e4;

extractBefore = 2; % in seconds
extractAfter = 4; % in seconds

TimeStampsRec = TimeStampsRec./1e3;

t = linspace(-1*extractBefore,extractAfter,((extractBefore+extractAfter)*fs));

chanData = [pfcChan1 pfcChan2 ppcChan1 ppcChan2];

extractedData = zeros(size(chanData,2),length(trialStruct.offTimes),length(t));

for iChan = 1:size(chanData,2)
    
    for iTrial = 1:length(trialStruct.offTimes)
        
        
        [idx idx] = min(abs(TimeStampsRec-trialStruct.offTimes(iTrial)));
        
        
        extractedData(iChan,iTrial,:) = chanData(idx-(extractBefore*fs):idx+(extractAfter*fs)-1,iChan);
        
    end
    
end


 

% Plot for sanity check


for i = 1:50

plot(t,squeeze(extractedData(1,i,:)))

pause

clf

end