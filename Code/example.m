% This file presents example code lines on how to use the algorithm CuBlock.
% It is therefore a guided example on how to use CuBlock, not a script meant to
%   be ran.
%
% Only the reading of Affymetrix CEL files will be presented here; the following
%   can be also applied to '.txt' files from other platforms by appropriately
%   reading them to organize the data in a (probes x samples) matrix.
%
% First, the CEL files in the working directory are read together with an
%   appropriate CDF file. The CDF files used for the data sets of the CuBlock
%   paper [ref] were "HG-U133_Plus_2.cdf" for the platforms AFX and AFF,
%   "GPL16043_PrimeView_withERCC_binary.cdf" for PRV and
%   "HuGene-2_0-st,pd.hugene.2.0.st.cdf" for HUG.
% Then, an Affymetrix pre-processing step is shown, consisting on the averaging
%   of PM probes per probe set, getting rid of NaN values and applying a log2
%   transformation.
% Finally, the algortihm CuBlock is applied, returning the normalized data at
%   the probe level (probe-set level in the Affymetrix case).
%
% A second example shows the use of RMA normalization as a pre-processing step
%   instead of the simple log2 transformation.
%
% These examples show how to normalize data from a single experiment with a 
%   unique platform. To introduce more platforms (data sets) in the analysis,
%   the same procedure can be applied to each platform data set separately,
%   after which the results can be merged by summarizing the probes at the gene
%   or protein level using the genes or proteins shared by all the platforms involved.
%
% Example 1: Affymetrix data set; pre-processing by probe-set averaging and
%            log2 transformation, followed by normalization with CuBlock
%
% Read the Affymetrix's CEL files together with the corresponding CDF
%  "platformCDF.cdf" file from current folder
allFiles = celintensityread('*','platformCDF.cdf');
dataPM = allFiles.PMIntensities;
ProbeSetIDs = allFiles.ProbeSetIDs;
ProbeIndices = allFiles.ProbeIndices;

% Summarize the PM probes for each probe set by averaging
probesStart = find(ProbeIndices==0);
dataProbeSet = nan(numel(probesStart),size(dataPM,2));
for i = 1:numel(probesStart)
    if i~=numel(probesStart)
        currData = dataPM(probesStart(i):(probesStart(i+1)-1),:);
    else
        currData = dataPM(probesStart(i):end,:);
    end
    dataProbeSet(i,:) = mean(currData,'omitnan');
end

% Get rid of NaN rows
nanInd = any(isnan(dataProbeSet) | abs(dataProbeSet)==Inf,2);
dataProbeSet = dataProbeSet(~nanInd,:);
ProbeSetIDs = ProbeSetIDs(~nanInd);

% log2 transform
dataProbeSet = log2(dataProbeSet);

% CuBlock normalization
dataN = CuBlock(dataProbeSet);

% NOTE 1: The normalized data is delivered at the probe level (Affymetrix probe-
%   set level in this case), i.e. each row corresponds to the ID in ProbeSetIDs.
%   The probes can then be summarized to genes or proteins using an appropriate
%   method.
% NOTE 2: If the microarrays don't come from an Affymetrix platform, one only
%   needs to read the array '.txt' files and select the corresponding expression
%   columns, get rid of potential NaN values, take the log2 and apply CuBlock.

% Example 2: Affymetrix data set; pre-processing involving RMA normalization,
%            followed by normalization with CuBlock

% Read the Affymetrix's CEL files together with the corresponding CDF
%  "platformCDF.cdf" file from current folder
allFiles = celintensityread('*','platformCDF.cdf');
dataPM = allFiles.PMIntensities;
ProbeSetIDs = allFiles.ProbeSetIDs;
ProbeIndices = allFiles.ProbeIndices;

% Apply background correction
dataPM_bg = rmabackadj(dataPM);

% Quantile normalization
dataPM_qn = quantilenorm(dataPM_bg);

% Summarization of PM probes per probe set by RMA and log2 transform
dataProbeSet = rmasummary(ProbeIndices,dataPM_qn);

% Get rid of NaN rows
indNaN = any(isnan(dataProbeSet) | abs(dataProbeSet)==Inf,2);
dataProbeSet = dataProbeSet(~indNaN,:);
ProbeSetIDs = ProbeSetIDs(~indNaN);

% CuBlock normalization
dataN = CuBlock(dataProbeSet);
