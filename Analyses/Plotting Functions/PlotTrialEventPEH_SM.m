function PlotTrialEventPEH_SM(unitID, pokeInAlignedBehavMatrix, pokeOutAlignedBehavMatrix, rewardAlignedBehavMatrix, errorAlignedBehavMatrix, eventLog1, event1ID, eventLog2, event2ID, curUniSpikeLog, origBinWindows, pehBinSize, figID, saveYN)
%% PlotTrialEventPEH_SM
% Future versions should have:
%   1) Clear description up here instead of a to-do list
%   2) Code should be condensed down to a single for loop.
%       - To do this the inputs will need to be changed to be separated
%           into: 
%               : BehaviorMatrices
%               : TrialSelectionVectors (currently referred to as "eventLog1/2")
%               : Spike Vector 
%               : Original Event Windows
%               : Figure ID
%
%% 
if nargin == 11
    figID = figure;
else
    figure(figID);
end
annotation('textbox', [0.05 0.9 0.9 0.1], 'String', sprintf('%s (%s vs %s)', unitID, event1ID, event2ID), 'linestyle', 'none');
%% Poke In Aligned Plots
pokeInAllTrlsPlot = subplot(3,4,1);
pokeInAllTrls = ExtractTrialData_SM(pokeInAlignedBehavMatrix, curUniSpikeLog);
[pokeInAllTrlsPEH, newBins] = RebinPEH_SM(pokeInAllTrls, origBinWindows, pehBinSize);
bar(newBins(1:end-1)+0.05, pokeInAllTrlsPEH, 1, 'k');
axis tight
title({'Poke In Aligned:', 'All Trials'});

pokeInLog1TrlsPlot = subplot(3,4,5);
pokeInLog1Trls = ExtractTrialData_SM(pokeInAlignedBehavMatrix(eventLog1), curUniSpikeLog);
[pokeInLog1TrlsPEH, newBins] = RebinPEH_SM(pokeInLog1Trls, origBinWindows, pehBinSize);
bar(newBins(1:end-1)+0.05, pokeInLog1TrlsPEH, 1, 'k');
axis tight
title({'Poke In Aligned:', event1ID});

pokeInLog2TrlsPlot = subplot(3,4,9);
pokeInLog2Trls = ExtractTrialData_SM(pokeInAlignedBehavMatrix(eventLog2), curUniSpikeLog);
[pokeInLog2TrlsPEH, newBins] = RebinPEH_SM(pokeInLog2Trls, origBinWindows, pehBinSize);
bar(newBins(1:end-1)+0.05, pokeInLog2TrlsPEH, 1, 'k');
axis tight
title({'Poke In Aligned:', event2ID});

%% Poke Out Aligned Plots
pokeOutAllTrlsPlot = subplot(3,4,2);
pokeOutAllTrls = ExtractTrialData_SM(pokeOutAlignedBehavMatrix, curUniSpikeLog);
[pokeOutAllTrlsPEH, newBins] = RebinPEH_SM(pokeOutAllTrls, origBinWindows, pehBinSize);
bar(newBins(1:end-1)+0.05, pokeOutAllTrlsPEH, 1, 'k');
axis tight
title({'Poke Out Aligned:', 'All Trials'});

pokeOutLog1TrlsPlot = subplot(3,4,6);
pokeOutLog1Trls = ExtractTrialData_SM(pokeOutAlignedBehavMatrix(eventLog1), curUniSpikeLog);
[pokeOutLog1TrlsPEH, newBins] = RebinPEH_SM(pokeOutLog1Trls, origBinWindows, pehBinSize);
bar(newBins(1:end-1)+0.05, pokeOutLog1TrlsPEH, 1, 'k');
axis tight
title({'Poke Out Aligned:', event1ID});

pokeOutLog2TrlsPlot = subplot(3,4,10);
pokeOutLog2Trls = ExtractTrialData_SM(pokeOutAlignedBehavMatrix(eventLog2), curUniSpikeLog);
[pokeOutLog2TrlsPEH, newBins] = RebinPEH_SM(pokeOutLog2Trls, origBinWindows, pehBinSize);
bar(newBins(1:end-1)+0.05, pokeOutLog2TrlsPEH, 1, 'k');
axis tight
title({'Poke Out Aligned:', event2ID});

%% Reward Aligned
rewardAllTrlsPlot = subplot(3,4,3);
rewardAllTrls = ExtractTrialData_SM(rewardAlignedBehavMatrix, curUniSpikeLog);
noRwdRmvLog = cellfun(@(a)isempty(a), rewardAllTrls);
rewardAllTrls(noRwdRmvLog) = [];
[rewardAllTrlsPEH, newBins] = RebinPEH_SM(rewardAllTrls, origBinWindows, pehBinSize);
bar(newBins(1:end-1)+0.05, rewardAllTrlsPEH, 1, 'k');
axis tight
title({'Reward Aligned:', 'All Trials'});

rewardLog1TrlsPlot = subplot(3,4,7);
rewardLog1Trls = ExtractTrialData_SM(rewardAlignedBehavMatrix(eventLog1), curUniSpikeLog);
noRwdRmvLog = cellfun(@(a)isempty(a), rewardLog1Trls);
rewardLog1Trls(noRwdRmvLog) = [];
if ~isempty(rewardLog1Trls)
    [rewardLog1TrlsPEH, newBins] = RebinPEH_SM(rewardLog1Trls, origBinWindows, pehBinSize);
    bar(newBins(1:end-1)+0.05, rewardLog1TrlsPEH, 1, 'k');
    axis tight
else
    set(gca, 'xlim', [0 0.01], 'ylim', [0 0.01]);
end
title({'Reward Aligned:', event1ID});

rewardLog2TrlsPlot = subplot(3,4,11);
rewardLog2Trls = ExtractTrialData_SM(rewardAlignedBehavMatrix(eventLog2), curUniSpikeLog);
noRwdRmvLog = cellfun(@(a)isempty(a), rewardLog2Trls);
rewardLog2Trls(noRwdRmvLog) = [];
if ~isempty(rewardLog2Trls)
    [rewardLog2TrlsPEH, newBins] = RebinPEH_SM(rewardLog2Trls, origBinWindows, pehBinSize);
    bar(newBins(1:end-1)+0.05, rewardLog2TrlsPEH, 1, 'k');
    axis tight
else
    set(gca, 'xlim', [0 0.01], 'ylim', [0 0.01]);
end
title({'Reward Aligned:', event2ID});

%% ErrorAligned
errorAllTrlsPlot = subplot(3,4,4);
errorAllTrls = ExtractTrialData_SM(errorAlignedBehavMatrix, curUniSpikeLog);
noErrRmvLog = cellfun(@(a)isempty(a), errorAllTrls);
errorAllTrls(noErrRmvLog) = [];
[errorAllTrlsPEH, newBins] = RebinPEH_SM(errorAllTrls, origBinWindows, pehBinSize);
bar(newBins(1:end-1)+0.05, errorAllTrlsPEH, 1, 'k');
axis tight
title({'Error Aligned:', 'All Trials'});

errorLog1TrlsPlot = subplot(3,4,8);
errorLog1Trls = ExtractTrialData_SM(errorAlignedBehavMatrix(eventLog1), curUniSpikeLog);
noErrRmvLog = cellfun(@(a)isempty(a), errorLog1Trls);
errorLog1Trls(noErrRmvLog) = [];
if ~isempty(errorLog1Trls)
    [errorLog1TrlsPEH, newBins] = RebinPEH_SM(errorLog1Trls, origBinWindows, pehBinSize);
    bar(newBins(1:end-1)+0.05, errorLog1TrlsPEH, 1, 'k');
    axis tight
else
    set(gca, 'xlim', [0 0.01], 'ylim', [0 0.01]);
end
title({'Error Aligned:', event1ID});

errorLog2TrlsPlot = subplot(3,4,12);
errorLog2Trls = ExtractTrialData_SM(errorAlignedBehavMatrix(eventLog2), curUniSpikeLog);
noRwdRmvLog = cellfun(@(a)isempty(a), errorLog2Trls);
errorLog2Trls(noRwdRmvLog) = [];
if ~isempty(errorLog2Trls)
    [errorLog2TrlsPEH, newBins] = RebinPEH_SM(errorLog2Trls, origBinWindows, pehBinSize);
    bar(newBins(1:end-1)+0.05, errorLog2TrlsPEH, 1, 'k');
    axis tight
else
    set(gca, 'xlim', [0 0.01], 'ylim', [0 0.01]);
end
title({'Error Aligned:', event2ID});

%% Link Axes!
linkaxes([pokeInAllTrlsPlot, pokeInLog1TrlsPlot, pokeInLog2TrlsPlot,...
    pokeOutAllTrlsPlot, pokeOutLog1TrlsPlot, pokeOutLog2TrlsPlot,...
    rewardAllTrlsPlot, rewardLog1TrlsPlot, rewardLog2TrlsPlot,...
    errorAllTrlsPlot, errorLog1TrlsPlot, errorLog2TrlsPlot], 'xy');

ylims = get(pokeInAllTrlsPlot, 'ylim');
if ylims(1)<0
    set(pokeInAllTrlsPlot, 'ylim', [0 0.25]);
end

if saveYN==1
    set(figID, 'PaperOrientation', 'landscape');
    print('-fillpage', figID, '-dpdf', sprintf('%s (%s vs %s).pdf', unitID, event1ID, event2ID));
end