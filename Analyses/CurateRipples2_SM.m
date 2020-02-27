%% CurateRipples
global plotData
plotData.listSel = 1;        % Used to keep track of which list is being selected from for ripple viewing
plotData.Window = 50;
%% Parameters
% envProc = 'RMS';
envProc = 'HILB';           
powThresh = [0 4];
durThresh = 15;             
durThreshMrg = 15;
syncThresh = 0;
syncWin = 10;
smoothWin = 21;

%%
rips = RippleDetection_SM(envProc, powThresh, durThresh, durThreshMrg, syncThresh, syncWin, smoothWin);
[trialRips] = ExtractTrialEventRips_SM(rips, [500 700]);
allTrialRips = sortrows(cell2mat([trialRips.Events(:,1); trialRips.Events(:,2); trialRips.Events(:,3)]));

%% Plot Descriptives
PlotNearTrialRipStats(trialRips)
annotation('textbox', 'position', [0.01 0.01 0.9 0.05], 'string',...
    sprintf('%s', cd), 'linestyle', 'none', 'interpreter', 'none');
annotation('textbox', 'position', [0.01 0.95 0.9 0.05], 'string',...
    sprintf('\\bfThreshold: \\rm+%i(+%i)SD; \\bfEnvelope = \\rm%s; \\bfMerge \\bfThreshold = \\rm%i ms', powThresh(1), powThresh(2), envProc, durThreshMrg),...
    'linestyle', 'none');

PlotRipFeatsByTrlType(rips, trialRips)
annotation('textbox', 'position', [0.01 0.01 0.9 0.05], 'string',...
    sprintf('%s', cd), 'linestyle', 'none', 'interpreter', 'none');
annotation('textbox', 'position', [0.01 0.95 0.9 0.05], 'string',...
    sprintf('\\bfThreshold: \\rm+%i(+%i)SD; \\bfEnvelope = \\rm%s; \\bfMerge \\bfThreshold = \\rm%i ms', powThresh(1), powThresh(2), envProc, durThreshMrg),...
    'linestyle', 'none');

PlotRipFeatsByOdor(rips, trialRips)
annotation('textbox', 'position', [0.01 0.01 0.9 0.05], 'string',...
    sprintf('%s', cd), 'linestyle', 'none', 'interpreter', 'none');
annotation('textbox', 'position', [0.01 0.95 0.9 0.05], 'string',...
    sprintf('\\bfThreshold: \\rm+%i(+%i)SD; \\bfEnvelope = \\rm%s; \\bfMerge \\bfThreshold = \\rm%i ms', powThresh(1), powThresh(2), envProc, durThreshMrg),...
    'linestyle', 'none');

%% Create Figure
plotData.PowThresh = rips.FileInfo.PowerThreshold;
plotData.ripCure = figure;
set(plotData.ripCure, 'UserData', [rips.TimeStamps, mean(rips.SessionData.RipEnv,2)]);
plotData.rawAxes = axes(plotData.ripCure, 'position', [0.1, 0.75, 0.7, 0.2]);
set(plotData.rawAxes, 'UserData', rips.SessionData.RawLFP);
plotData.bpfAxes = axes(plotData.ripCure, 'position', [0.1, 0.55, 0.7, 0.2]);
set(plotData.bpfAxes, 'UserData', rips.SessionData.RipBPF);
plotData.spkAxes = axes(plotData.ripCure, 'position', [0.1, 0.2, 0.7, 0.3]);
set(plotData.spkAxes, 'UserData', rips.SessionData.Spikes);

% Overall Ripple List
ssnRipTitleAx = axes(plotData.ripCure, 'position', [0.825, 0.925, 0.11, 0.05]);
set(ssnRipTitleAx, 'xlim', [-0.5 0.5], 'ylim', [0 0.5]);
text(ssnRipTitleAx, 0,0, 'Session Rips', 'horizontalalignment', 'center', 'verticalalignment', 'bottom');
axis(ssnRipTitleAx, 'off');
plotData.ssnRipList = uicontrol(plotData.ripCure, 'Units', 'Normalized', 'Style', 'listbox', 'String', 1:size(rips.Ripples.Events,1),...
    'Position', [0.825, 0.62, 0.15, 0.3], 'Callback', @SelectSsnRip, 'userData', rips.Ripples.Events);
plotData.ssnRipExport = uicontrol(plotData.ripCure, 'Units', 'Normalized', 'Style', 'pushbutton', 'String', 'Export Session Rips',...
    'Position', [0.825, 0.55, 0.15, 0.05], 'Callback', @ExportSsnRips);

% Trial Ripple List
trlRipTitleAx = axes(plotData.ripCure, 'position', [0.825, 0.5, 0.11, 0.05]);
set(trlRipTitleAx, 'xlim', [-0.5 0.5], 'ylim', [0 0.5]);
text(trlRipTitleAx, 0,0, 'Trial Rips', 'horizontalalignment', 'center', 'verticalalignment', 'bottom');
axis(trlRipTitleAx, 'off');
plotData.trlRipList = uicontrol(plotData.ripCure, 'Units', 'Normalized', 'Style', 'listbox', 'String', 1:size(allTrialRips,1),...
    'Position', [0.825, 0.25, 0.15, 0.25], 'Callback', @SelectTrlRip, 'userData', allTrialRips);
plotData.trlRipExport = uicontrol(plotData.ripCure, 'Units', 'Normalized', 'Style', 'pushbutton', 'String', 'Export Trial Rips',...
    'Position', [0.825, 0.195, 0.15, 0.05], 'Callback', @ExportTrlRips);

% Zoom In
zoomOutBtn = uicontrol(plotData.ripCure, 'Units', 'Normalized', 'Style', 'pushbutton', 'String', 'Zm-',...
    'Position', [0.35, 0.06, 0.05, 0.075], 'Callback', @ZoomOut);
% Zoom Out
zoomInBtn = uicontrol(plotData.ripCure, 'Units', 'Normalized', 'Style', 'pushbutton', 'String', 'Zm+',...
    'Position', [0.65, 0.06, 0.05, 0.075], 'Callback', @ZoomIn);

% Previous Ripple
prevRipBtn = uicontrol(plotData.ripCure, 'Units', 'Normalized', 'Style', 'pushbutton', 'String', '<< Previous Ripple',...
    'Position', [0.05, 0.05, 0.2, 0.1], 'Callback', @PrevRip);
% Next Ripple
nextRipBtn = uicontrol(plotData.ripCure, 'Units', 'Normalized', 'Style', 'pushbutton', 'String', 'Next Ripple >>',...
    'Position', [0.75, 0.05, 0.2, 0.1], 'Callback', @NextRip);

% Remove Ripple
removeRipBtn = uicontrol(plotData.ripCure, 'Units', 'Normalized', 'Style', 'pushbutton', 'String', 'Remove Ripple',...
    'Position', [0.425, 0.075, 0.2, 0.05], 'Callback', @RmvRip);


annotation('textbox', 'position', [0.01 0.005 0.9 0.05], 'string',...
    sprintf('%s', cd), 'linestyle', 'none', 'interpreter', 'none');
annotation('textbox', 'position', [0.01 0.95 0.9 0.05], 'string',...
    sprintf('\\bfThreshold: \\rm+%i(+%i)SD; \\bfEnvelope = \\rm%s; \\bfMerge \\bfThreshold = \\rm%i ms', powThresh(1), powThresh(2), envProc, durThreshMrg),...
    'linestyle', 'none');
%% Initialize Things
SetPlots;

%% Plot Trial Periods
% for trl = 1:size(rips.TrialInfo.TrialPokes,1)
%     switch rips.TrialInfo.OdorVect(trl)
%         case 1
%             patchColor = [44/255 168/255 224/255];
%         case 2
%             patchColor = [154/255 133/255 122/255];
%         case 3
%             patchColor = [9/255 161/255 74/255];
%         case 4 
%             patchColor = [128/255 66/255 151/255];
%         case 5
%             patchColor = [241/255 103/255 36/255];
%     end
%     patch(rawAxes, 'XData', [rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,1)), rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,2)), rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,2)),rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,1))],...
%         'YData', plotData.FigLims.Raw(:),...
%         'FaceColor', patchColor, 'FaceAlpha', 0.5,...
%         'EdgeColor', patchColor, 'EdgeAlpha', 0.5);
%     patch(bpfAxes, 'XData', [rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,1)), rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,2)), rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,2)),rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,1))],...
%         'YData', plotData.FigLims.BPF(:),...
%         'FaceColor', patchColor, 'FaceAlpha', 0.5,...
%         'EdgeColor', patchColor, 'EdgeAlpha', 0.5);
%     patch(spkAxes, 'XData', [rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,1)), rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,2)), rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,2)),rips.TimeStamps(rips.TrialInfo.TrialPokes(trl,1))],...
%         'YData', plotData.FigLims.Spk(:),...
%         'FaceColor', patchColor, 'FaceAlpha', 0.5,...
%         'EdgeColor', patchColor, 'EdgeAlpha', 0.5);    
% end


%% Callbacks/Functions
function SetPlots
global plotData
if plotData.listSel == 1
    curNdx = plotData.ssnRipList.UserData(plotData.ssnRipList.Value,:);
else
    curNdx = plotData.trlRipList.UserData(plotData.trlRipList.Value,:);
end
rawData = plotData.rawAxes.UserData;
bpfData = plotData.bpfAxes.UserData;
spkData = plotData.spkAxes.UserData;
envData = plotData.ripCure.UserData(:,2);
tmpSpkData = spkData(curNdx(1)-plotData.Window:curNdx(2)+plotData.Window,:);
[spkX, spkY] = find(tmpSpkData~=0);
curTS = plotData.ripCure.UserData(curNdx(1)-plotData.Window:curNdx(2)+plotData.Window,1);

if ~isfield('rawPlot', plotData)    
    plotData.rawPlot = plot(plotData.rawAxes, curTS, rawData(curNdx(1)-plotData.Window:curNdx(2)+plotData.Window,:), 'color', 'k');
    plotData.rawAxes.UserData = rawData;
    for r = 1:length(plotData.rawPlot)
        plotData.rawPlot(r).Color(4) = 0.2;
    end    
    plotData.bpfPlot = plot(plotData.bpfAxes, curTS, bpfData(curNdx(1)-plotData.Window:curNdx(2)+plotData.Window,:), 'color', 'k');
    hold(plotData.bpfAxes, 'on');
    plotData.envPlot = plot(plotData.bpfAxes, curTS, envData(curNdx(1)-plotData.Window:curNdx(2)+plotData.Window,:), 'color', 'r', 'linewidth', 2);
    plotData.envTH1 = plot(plotData.bpfAxes, curTS,...
        ones(1,length(curNdx(1)-plotData.Window:curNdx(2)+plotData.Window))*(mean(plotData.ripCure.UserData(:,2)) + (plotData.PowThresh (1)*std(plotData.ripCure.UserData(:,2)))),...
        'color', 'k', 'linestyle','--', 'linewidth', 2);
    plotData.envTH2 = plot(plotData.bpfAxes, curTS,...
        ones(1,length(curNdx(1)-plotData.Window:curNdx(2)+plotData.Window))*(mean(plotData.ripCure.UserData(:,2)) + (plotData.PowThresh (2)*std(plotData.ripCure.UserData(:,2)))),...
        'color', 'k', 'linestyle','-', 'linewidth', 2);
    plotData.bpfAxes.UserData = bpfData;
    for b = 1:length(plotData.bpfPlot)
        plotData.bpfPlot(b).Color(4) = 0.2;
    end    
    plotData.spkRasts = scatter(plotData.spkAxes, curTS(spkX),spkY, '*k');
    plotData.spkAxes.UserData = spkData;
    xlabel(plotData.spkAxes, 'Time (s)');
    
    linkaxes([plotData.spkAxes, plotData.bpfAxes, plotData.rawAxes], 'x');
    set(plotData.rawAxes, 'color', 'none', 'ycolor', 'none', 'xcolor', 'none', 'xticklabel', [], 'box', 'off');
    set(plotData.bpfAxes,'color', 'none', 'ycolor', 'none', 'xticklabel', [], 'box', 'off');
    set(plotData.spkAxes, 'color', 'none', 'ycolor', 'none', 'box', 'off');
    axis([plotData.rawAxes, plotData.bpfAxes, plotData.spkAxes], 'tight');
    
    plotData.FigLims.Raw = repmat(get(plotData.rawAxes,'ylim'),[2,1]);
    plotData.FigLims.BPF = repmat(get(plotData.bpfAxes,'ylim'),[2,1]);
    spkLim = repmat(get(plotData.spkAxes,'ylim'),[2,1]);
    plotData.FigLims.Spk = [spkLim(:,1)-1, spkLim(:,2)+1];
    
    curRipX = [plotData.ripCure.UserData(curNdx,1); flipud(plotData.ripCure.UserData(curNdx,1))]';
    plotData.RipPatch.Raw = patch(plotData.rawAxes, 'XData', curRipX,...
        'YData', plotData.FigLims.Raw(:),...
        'FaceColor', 'y', 'FaceAlpha', 0.15,...
        'EdgeColor', 'y', 'EdgeAlpha', 0.5);
    plotData.RipPatch.BPF = patch(plotData.bpfAxes, 'XData', curRipX,...
        'YData', plotData.FigLims.BPF(:),...
        'FaceColor', 'y', 'FaceAlpha', 0.15,...
        'EdgeColor', 'y', 'EdgeAlpha', 0.5);
    plotData.RipPatch.Spk = patch(plotData.spkAxes, 'XData', curRipX,...
        'YData', plotData.FigLims.Spk(:),...
        'FaceColor', 'y', 'FaceAlpha', 0.15,...
        'EdgeColor', 'y', 'EdgeAlpha', 0.5);
else
    for r = 1:length(plotData.rawPlot)
        set(plotData.rawPlot(r), 'XData', curTS, 'YData', rawData(r,:));
    end
    for b = 1:length(plotData.bpfPlot)
        set(plotData.bpfPlot(b), 'XData', curTS, 'YData', bpfData(r,:));
    end
    set(plotData.spkRasts, 'XData', curTS(spkX), 'YData', spkY);
    set(plotData.envPlot, 'XData', curTS, 'YData', envData(curNdx(1)-plotData.Window:curNdx(2)+plotData.Window,:));
    set(plotData.envTH1, 'XData', curTS, 'YData', ones(1,length(curNdx(1)-plotData.Window:curNdx(2)+plotData.Window))*(mean(plotData.ripCure.UserData(:,2)) + (plotData.PowThresh (1)*std(plotData.ripCure.UserData(:,2)))));
    set(plotData.envTH2, 'XData', curTS, 'YData', ones(1,length(curNdx(1)-plotData.Window:curNdx(2)+plotData.Window))*(mean(plotData.ripCure.UserData(:,2)) + (plotData.PowThresh (2)*std(plotData.ripCure.UserData(:,2)))));
    curRipX = [plotData.ripCure.UserData(curNdx,1); flipud(plotData.ripCure.UserData(curNdx,1))]';
    set(plotData.RipPatch.Raw, 'XData', curRipX);
    set(plotData.RipPatch.BPF, 'XData', curRipX);
    set(plotData.RipPatch.Spk, 'XData', curRipX);
end       
title(plotData.spkAxes, sprintf('Duration = %i(ms)', diff(curNdx)));
% refreshdata(plotData.ripCure);
end

function SelectSsnRip(source,event)
global plotData
plotData.listSel = 1;
SetPlots
end

function SelectTrlRip(source,event)
global plotData
plotData.listSel = 2;
SetPlots
end

function NextRip(source,event)
global plotData
if plotData.listSel == 1
    plotData.ssnRipList.Value = plotData.ssnRipList.Value + 1;
else
    plotData.trlRipList.Value = plotData.trlRipList.Value + 1;
end
SetPlots
end

function PrevRip(source,event)
global plotData
if plotData.listSel == 1
    plotData.ssnRipList.Value = plotData.ssnRipList.Value - 1;
else
    plotData.trlRipList.Value = plotData.trlRipList.Value - 1;
end
SetPlots
end

function ZoomOut(source,event)
global plotData
plotData.Window = plotData.Window+100;
SetPlots
end

function ZoomIn(source,event)
global plotData
plotData.Window = plotData.Window-100;
if plotData.Window < 50
    plotData.Window = 50;
end
SetPlots
end

function RmvRip(source,event)
global plotData
if plotData.listSel == 1
    curNdx = plotData.ssnRipList.UserData(plotData.ssnRipList.Value,:);
else
    curNdx = plotData.trlRipList.UserData(plotData.trlRipList.Value,:);
end
ssnList = plotData.ssnRipList.UserData;
ssnList(ssnList(:,1)==curNdx(1),:) = [];
trlList = plotData.ssnRipList.UserData;
trlList(trlList(:,1)==curNdx(1),:) = [];

plotData.ssnRipList.UserData = ssnList;
plotData.ssnRipList.String = 1:size(ssnList,1);
plotData.trlRipList.UserData = trlList;
plotData.trlRipList.String = 1:size(trlList,1);

if plotData.listSel == 1
    if plotData.ssnRipList.Value == 1
        plotData.ssnRipList.Value = 1;
    elseif plotData.ssnRipList.Value == size(ssnList,1)+1
        plotData.ssnRipList.Value = size(ssnList,1);
    end
else
    if plotData.trlRipList.Value == 1
        plotData.trlRipList.Value = 1;
    elseif plotData.trlRipList.Value == size(ssnList,1)+1
        plotData.trlRipList.Value = size(ssnList,1);
    end
end
SetPlots
end

function ExportSsnRips(source, event)
global plotData
exportData = plotData.ssnRipList.UserData;
save('SessionRips.mat', 'exportData');
msgbox('Session Ripple Indices Saved');
end

function ExportTrlRips(source, event)
global plotData
exportData = plotData.trlRipList.UserData;
save('TrialRips.mat', 'exportData');
msgbox('Trial Ripple Indices Saved');
end

%% Data Organization Functions
function [rips] = RippleDetection_SM(envProc, powThresh, durThresh, durThreshMrg, syncThresh, syncWin, smoothWin)
%% RippleDetection_SM
%   Inputs:
%       - envProc: Enveloping procedure
%               - 'RMS' : Use the root mean squared approach to enveloping
%               - 'HILB' : Use hilbert transform envelope
%       - powThresh: Thresholds used for defining the ripple.
%               - First value is the threshold for defining a ripple epoc.
%               - Second value is the threshold needed to for an epoc to be
%                   considered a ripple.
%       - durThresh: Threshold used to select ripples of only a particular
%           duration. **CURRENTLY NOT IMPLEMENTED**
%       - durThreshMrg: Threshold of the inter-ripple-interval used to
%           merge together potential ripples that happen close in time
%       - syncThresh: Synchrony threshold used to select ripples of a
%           particular coherence. **CURRENTLY NOT IMPLEMENTED**
%       - syncWin: Window size used to compute sliding window coherence
%           across the session. **CURRENTLY NOT IMPLEMENTED**
%       - smoothWin: Window size used for gaussian smoothing.


%#ok<*IDISVAR,*NODEF,*USENS,*NASGU,*COLND>
%%
if nargin == 0
    envProc = 'RMS';            % Enable for RMS determination of envelope
    % envProc = 'HILB';           % Enable for abs(Hilbert) determinination of envelope
    powThresh = [0 4];
    durThresh = 15;             % Duration Threshold
    durThreshMrg = 15;
    syncThresh = 0;
    syncWin = 10;
    smoothWin = 21;
end
%%
%% Define Analysis Features
w = gausswin(smoothWin);
w = w/sum(w);
%% Load Data
origDir = cd;
[fileDir] = uigetdir(origDir);
if fileDir==0
    disp('Analysis Cancelled')
    return
else
    cd(fileDir)
end
dirContents = dir(fileDir);
fileNames = {dirContents.name};
tetFileLog = cellfun(@(a)~isempty(a), regexp(fileNames, '_T([0-9]*)_SM.mat'));
tetFiles = fileNames(tetFileLog)';
behavFileLog = cellfun(@(a)~isempty(a), regexp(fileNames, '_BehaviorMatrix'));
ensembleFileLog = cellfun(@(a)~isempty(a), regexp(fileNames, '_EnsembleMatrix'));
load(fileNames{behavFileLog});
load(fileNames{ensembleFileLog});
behavMatrixTrialStruct = OrganizeTrialData_SM(behavMatrix, behavMatrixColIDs, [0 0], 'PokeIn');

%% Extract Raw Values & Compute RMS Power
ripBPF = nan(size(behavMatrix,1),size(tetFiles,1));
ripVolts = nan(size(behavMatrix,1),size(tetFiles,1));
ripRMS = nan(size(behavMatrix,1),size(tetFiles,1));
ripHilb = nan(size(behavMatrix,1),size(tetFiles,1));
ripTetIDs = cell(size(tetFiles));
for fl = 1:length(tetFiles)
    load(tetFiles{fl})
    samp = mode(diff(statMatrix(:,1)));
    wIndx = round((1/200)*(1/samp));
    fprintf('%s......', tetFiles{fl});
    ripCol = find(cellfun(@(a)~isempty(a), regexp(statMatrixColIDs, 'LFP_Ripple$')));
    ripVolts(:,fl) = statMatrix(:,2);
    if strcmp(envProc, 'RMS')
        ripRMS(:,fl) = conv(sqrt(conv(statMatrix(:,ripCol).^2, ones(wIndx,1)/wIndx, 'same')), w, 'same');
    elseif strcmp(envProc, 'HILB')
        ripRMS(:,fl) = conv(abs(hilbert(statMatrix(:,ripCol))),w,'same');
    end
    ripBPF(:,fl) = statMatrix(:,ripCol);
    ripHilb(:,fl) = statMatrix(:,ripCol+1);
    ripTetIDs{fl} = statMatrixColIDs{ripCol};
    fprintf('done\n');
end

%% Calculate Thresholds
% Aggregate Power
aggPower = mean(ripRMS,2);                  % Mean envelope
% aggPower = zscore(mean(ripRMS,2));          % Z-Score Mean envelope
% aggPower = mean(zscore(ripRMS),2);          % Mean Z-Score envelope

% Threshold Based on Mean +/- STD Aggregate Power
rmsThresh1 = (mean(aggPower) + (powThresh(1)*std(aggPower)));
rmsThresh2 = (mean(aggPower) + (powThresh(2)*std(aggPower)));

%% Identify Ripples
% Define putative ripple periods
abvThresh1 = aggPower>rmsThresh1;
epocWindows = [find(diff(abvThresh1)==1), find(diff(abvThresh1)==-1)];

% Apply secondary (peak power) threshold
abvThresh2 = aggPower>rmsThresh2;
dualThreshLog = false(size(epocWindows,1),1);
for epoc = 1:size(epocWindows,1)
    if sum(abvThresh2(epocWindows(epoc,1):epocWindows(epoc,2))) >=1
        dualThreshLog(epoc) = true;
    end
end
epocWindows(~dualThreshLog,:) = [];                                         % Comment out if not using dual thresholds

% Merge short latency ripples
interEpocInterval = epocWindows(2:end,1) - epocWindows(1:end-1,2);
slrLog = interEpocInterval<durThreshMrg;
shortLatRipls = find(slrLog);
mrgdNdxs = false(size(interEpocInterval));
for slr = 1:length(shortLatRipls)
    nxtNdx = shortLatRipls(slr)+find(slrLog(shortLatRipls(slr)+1:end)==0,1,'first');
    epocWindows(shortLatRipls(slr),2) = epocWindows(nxtNdx,2);
    mrgdNdxs(nxtNdx) = true;
end
epocWindows(mrgdNdxs,:) = [];

%% Quantify & Extract Ripples
% Determine the duration/timing of each event
epocDur = diff(epocWindows,1,2);

% Determine the Synchrony of each event
epocSync = nan(size(epocWindows,1),1);
epocSyncConfMtx = cell(size(epocWindows,1),1);
for epoc = 1:size(epocWindows,1)
    tempConfMtx = nan(size(ripHilb,2));
    for e1 = 1:size(ripHilb,2)
        for e2 = 1:size(ripHilb,2)
            [tempConfMtx(e1,e2),~] = circ_corrcc(ripHilb(epocWindows(epoc,1):epocWindows(epoc,2),e1),...
                ripHilb(epocWindows(epoc,1):epocWindows(epoc,2),e2));
        end
    end
    epocSyncConfMtx{epoc} = tempConfMtx;
    epocSync(epoc) = mean(tempConfMtx(triu(true(size(ripHilb,2)))));
end

%% Organize Spiking Data Based on Total # Spikes
spkMtx = ensembleMatrix(:,2:end);
sortedSpkCountsAndIndices = sortrows([sum(spkMtx); 1:size(spkMtx,2)]');
spkMtxSorted = spkMtx(:,sortedSpkCountsAndIndices(:,2));

%% Evaluate Ensemble Activity
epocNsmblAct = nan(size(epocWindows,1),1);
for epoc = 1:size(epocWindows,1)
    tempSpkMtx = ensembleMatrix(epocWindows(epoc,1):epocWindows(epoc,2),2:end);
    epocNsmblAct(epoc) = mean(sum(tempSpkMtx)>=1);
end

%% Organize Data Output
rips = struct(...
    'TimeStamps', statMatrix(:,1),...
    'Ripples', struct('Events', epocWindows, 'Duration', epocDur,...
        'Synchrony', epocSync, 'EnsembleActivity', epocNsmblAct),...
    'SessionData', struct('RawLFP', ripVolts, 'RipBPF', ripBPF,...
        'RipEnv', ripRMS, 'RipPhase', ripHilb, 'TetIDs', {ripTetIDs},...
        'Spikes', spkMtxSorted),...
    'TrialInfo', struct('Perf', [behavMatrixTrialStruct.Performance]==1,...
        'TransDist', [behavMatrixTrialStruct.TranspositionDistance],...
        'OdorVect', [behavMatrixTrialStruct.Odor],...
        'PositionVect', [behavMatrixTrialStruct.Position],...
        'TrialPokes', [[behavMatrixTrialStruct.PokeInIndex]', [behavMatrixTrialStruct.PokeOutIndex]'],...
        'TrialRewards', [behavMatrixTrialStruct.RewardIndex]),...
    'FileInfo', struct('Directory', cd, 'EnvelopeProcedure', envProc,...
        'PowerThreshold', powThresh, 'DurationThreshold', durThresh,...
        'DurationMergeThreshold', durThreshMrg,...
        'SynchronyThreshold', syncThresh, 'SynchronyWindow', syncWin,...
        'GaussianDuration', smoothWin));
end

function [trialRipStruct] = ExtractTrialEventRips_SM(rips, trialWin)
% ExtractTrialEventRips_SM
%   Extracts and organizes ripple data relative to the trial periods
%
%   Inputs:
%       - rips: Ripple data structure created by RippleDetection_SM
%       - trialWin: Periods used for delineation of trial event related
%           SWR.
%               - First value is period prior to poke initiation considered
%                   as the "pre-trial" period
%               - Second value is the period after poke withdrawal
%                   considered as the "post-trial" period

%% Extract Near-Trial Epocs
trialPokeTimes = rips.TrialInfo.TrialPokes;
trialRips = cell(size(trialPokeTimes,1),3);
trialRipLat = cell(size(trialPokeTimes,1),3);
trialRipsDur = cell(size(trialPokeTimes,1),3);
trialRipsSync = cell(size(trialPokeTimes,1),3);
trialRipsNsmblAct = cell(size(trialPokeTimes,1),3);
for trl = 1:size(trialPokeTimes,1)
    preTrlLog = rips.Ripples.Events(:,1)>(trialPokeTimes(trl,1)-trialWin(1)) & rips.Ripples.Events(:,1)<trialPokeTimes(trl,1);
    trialRips{trl,1} = rips.Ripples.Events(preTrlLog,:);
    trialRipLat{trl,1} = rips.Ripples.Events(preTrlLog,1) - trialPokeTimes(trl,1);
    trialRipsDur{trl,1} = rips.Ripples.Duration(preTrlLog,:);
    trialRipsSync{trl,1} = rips.Ripples.Synchrony(preTrlLog,:);
    trialRipsNsmblAct{trl,1} = rips.Ripples.EnsembleActivity(preTrlLog,:);
    
    trlLog = rips.Ripples.Events(:,1)>trialPokeTimes(trl,1) & rips.Ripples.Events(:,1)<trialPokeTimes(trl,2);
    trialRips{trl,2} = rips.Ripples.Events(trlLog,:);
    trialRipLat{trl,2} = rips.Ripples.Events(trlLog,1) - trialPokeTimes(trl,1);
    trialRipsDur{trl,2} = rips.Ripples.Duration(trlLog,:);
    trialRipsSync{trl,2} = rips.Ripples.Synchrony(trlLog,:);
    trialRipsNsmblAct{trl,2} = rips.Ripples.EnsembleActivity(trlLog,:);
    
    pstTrlLog = rips.Ripples.Events(:,1)>trialPokeTimes(trl,2) & (rips.Ripples.Events(:,1)<trialPokeTimes(trl,2)+trialWin(2));
    trialRips{trl,3} = rips.Ripples.Events(pstTrlLog,:);
    trialRipLat{trl,3} = rips.Ripples.Events(pstTrlLog,1) - trialPokeTimes(trl,2);
    trialRipsDur{trl,3} = rips.Ripples.Duration(pstTrlLog,:);
    trialRipsSync{trl,3} = rips.Ripples.Synchrony(pstTrlLog,:);
    trialRipsNsmblAct{trl,3} = rips.Ripples.EnsembleActivity(pstTrlLog,:);
end

trialRipStruct = struct('Events', {trialRips}, 'Latency', {trialRipLat},...
    'Duration', {trialRipsDur}, 'Synchrony', {trialRipsSync},...
    'EnsembleAct', {trialRipsNsmblAct});
end