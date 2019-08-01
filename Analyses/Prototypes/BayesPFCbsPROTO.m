%% Runtime variables
binSize = 20;
dsRate = 5;

%%
smPath = uigetdir;
cd(smPath);
files = dir(smPath);
fileNames = {files.name};
% Load the behavior matrix file for poke events plots
behMatFile = fileNames{cellfun(@(a)~isempty(a), strfind(fileNames, 'BehaviorMatrix'))};
nsmblMatFile = fileNames{cellfun(@(a)~isempty(a), strfind(fileNames, 'EnsembleMatrix'))};
load([smPath '\' behMatFile]);
load([smPath '\' nsmblMatFile]);
% Identify list of all statMatrix files
smFileList = fileNames(cellfun(@(a)~isempty(a), regexp(fileNames, '_SM\>')))';

%% Extract Behavioral Periods
trialPeriodTD = OrganizeTrialData_SM(behavMatrix, behavMatrixColIDs, [-0.5 1.5], 'PokeIn');
trialEnsemble = ExtractTrialData_SM(trialPeriodTD, ensembleMatrix(:,2:end)); %#ok<*NODEF>
trialEnsembleMtx = cell2mat(reshape(trialEnsemble, [1 1 length(trialEnsemble)]));

trialTimes = behavMatrix(trialPeriodTD(1).TrialLogVect,1) - behavMatrix(trialPeriodTD(1).PokeInIndex,1);

%% Bin the spiking data
% First convolve the entire trialEnsembleMtx with a square to bin the
% spikes
binnedEnsembleMtx = nan(size(trialEnsembleMtx));
for t = 1:size(trialEnsembleMtx,3)
    for u = 1:size(trialEnsembleMtx,2)
        binnedEnsembleMtx(:,u,t) = conv(trialEnsembleMtx(:,u,t), ones(1,binSize)./(binSize/1000), 'same');
    end
end
% Now downsample the binned matrix
dsVect = downsample(1:size(binnedEnsembleMtx,1), dsRate);
spikeMatrix = binnedEnsembleMtx(dsVect,:,:);
trialTime = trialTimes(dsVect);

%% Create Logical Vectors
perfLog = [trialPeriodTD.Performance];
inSeqLog = [trialPeriodTD.TranspositionDistance]==0;
outSeqLog = [trialPeriodTD.TranspositionDistance]~=0 & abs([trialPeriodTD.TranspositionDistance])<10;
odorAlog = [trialPeriodTD.Odor] == 1;
odorBlog = [trialPeriodTD.Odor] == 2;
odorClog = [trialPeriodTD.Odor] == 3;
odorDlog = [trialPeriodTD.Odor] == 4;

fullInSeqSeqsStart = find(conv([trialPeriodTD.Odor], 1:4, 'valid')==20 & conv([trialPeriodTD.Position], 1:4, 'valid')==20 & conv([trialPeriodTD.Performance]*1, ones(1,4), 'valid')==4);
inSeqSeqs = nan(3,length(fullInSeqSeqsStart));
for iS = 1:length(fullInSeqSeqsStart)
    inSeqSeqs(1,iS) = fullInSeqSeqsStart(iS);
    inSeqSeqs(2,iS) = fullInSeqSeqsStart(iS) + 1;
    inSeqSeqs(3,iS) = fullInSeqSeqsStart(iS) + 2;
    inSeqSeqs(4,iS) = fullInSeqSeqsStart(iS) + 3;
end
fullInSeqLog = false(1,length(trialPeriodTD));
fullInSeqLog(inSeqSeqs(:)) = true;

%% 
uniFRthreshLog = max(mean(spikeMatrix,3))<1;
spkMtx = spikeMatrix;
spkMtx(:,uniFRthreshLog,:) = [];
goodUniNames = {ensembleUnitSummaries(~uniFRthreshLog).UnitName};
%%
corrISmtx = mean(spkMtx(:,:,perfLog & inSeqLog),3);





%%
function [postMtx] = CalculatePostProb(meanFR, trialFR)
propVect = CalculateProportionalConstant(meanFR);
post = nan(size(trialFR,1), size(trialFR,1), size(trialFR,3));

for trl = 1:size(trialFR,3)
    tic
    for i1 = 1:size(trialFR,1)
        curPopVect = trialFR(i1,:,trl);
        curPopVectFact = factorial(curPopVect);
        for i2 = 1:size(trialFR,1)
            curMeanFR = meanFR(i2,:);
            condProbSpkPerUni = nan(size(curMeanFR));
            for uni = 1:size(trialFR,2)
                condProbSpkPerUni(uni) = (((binSize/1000 * curMeanFR(uni))^curPopVect(uni))/curPopVectFact(uni)) * exp(-(binSize/1000*curMeanFR(uni)));
            end
            post(i1,i2,trl) = propVect(i1)*prod(condProbSpkPerUni);
        end
    end
    toc
end

end

%%
function [propConst] = CalculateProportionalConstant(rateMtx)
% propConstMtx = nan(size(rateMtx));
% for u = 1:size(rateMtx,2)
%     propConstMtx(:,u) = 1./(rateMtx(:,u).*sum(rateMtx(:,u)~=0));
% end
% propConstMtx(isinf(propConstMtx)) = 0;

% sum(rateMtx'.*(1./sum(rateMtx')))
propConstMtx = 1./sum(rateMtx');
end
