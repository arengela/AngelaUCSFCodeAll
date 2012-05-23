% Available functions
%
%
% --- BASIC SETUP OF DATA STRUCTURES
%
% ecogRaw2Ecog(data,timebaseMs,badChannels,refChan,channel2GridMatrixIdx) create an ecog structure with trials
%
% ecogDigitalChannels2Trigger(basePath,fNames,decValues) % convert a set of digital channels to one analogue trigger channel
% 
% ecogSegmentTS(tS,triggerIdx,preDurSamp,postDurSamp) Create zero baseline datasegments around the indces in triggerIdx 
%
% ecogMkEmptyEcog() Creates an empty ecog structure
%
% ecogTDTData2MatlabConvertMultTags(rawDataPath,blockName,tags2Export,channels2Export) Dump all channels in a TDT block to matlab files. Repeadetly calls ecogTDTData2Matlab
%
% ecogTDTData2Matlab(rawDataPath,blockName,chans2Convert,dataTag,outputPath,outputPrefix) Covert a set of channels recorded with a TDT sytem to matlab
%
% ecogTDTGetBlockInfo(rawDataPath,blockName) Returns information about a data block
%
% --- DATA VISUALIZATION
%
% ecogMatrixPlotTS(ecog, trialList) plot time series in single trials
%
% ecogButterflyPlot(ecog, trialList) make a butterfly plot of the active channels in data time series
%
% ecogStackedTSPlot(ecog,trialNum) plot time series stacked in one column
% 
% ecogImagescTS(ecog, trialList) an image of the time series amplitudes on the grid
%
% ecogMovieTS(ecog, timepoint,colorLim, nColumns) make a movie of the amplitude distribution on the grid by calling ecogImagesc repeatedly
%
% ecogVisOnBrainNifti2BrainAnat(fName,thresh) Creates a brainAnat structure and a brain surface from a nifti-volume
%
% ecogVisOnBrainRenderBrain(brainAnat, cMap); Render a brain surface
%
% ecogVisOnBrainRenderDataOnBrain(brainAnat,pointsVox,pointsValue,smoothParms,cMap); Render data on a brain surface. See help for further advice on how to do further calculations with brain rendered data.
%
% ecogVisOnBrainFindClosestVertex(brainAnat,pointsVox) For a set of pointsfind the closest vertex on a brain surface
%
% ecogVisOnBrain(brainAnat,pointMM); Convert points given in mm to voxel space indices 
%
% --- CHANNEL HANDLING
%
% ecogDeselectBadChan: Excludes the channels makrked bad from the list of selected channels
%
%
% --- TIME SERIES PROCESSING
%
% ecogBaselineCorrect: Set the baseline of each channel to zero average
%
% ecogRemoveCommonAverageReference(ecog) Removes the common average reference
%
% ecogPCANoiseRemoval: Use PCA to remove noise that is common to channels
%
% ecogDownsampleTS(ecog1,newFrequencyHz) Downsample ecog time series data
%
% ecogNormalizeTS(ecog,type) Normalize timeseries
%
%
% --- FREQUENCY DOMAIN PROCESSING
%
% ecogFilterTemporal(ecog,filterBandsHz,filterOrder) Filter ecog time series
%
% ecogMkSpectrogramMorlet(ecog,centerFrequency,significantCycles) Spectrogram of ecog time series based on Morlet wavelet transform
%
% ecogMkSpectrogramHilbert(ecog,frequencyBandsHz) Spectrogram of ecogtime series based on hilbert transform
%
% ecogMkSpectrogramMultiTaper(ecog,trialList,param) calculates spectrograms of ecog data using the multitaper technique implemented in the chronux toolbox
%
% ecogMkSpectrograms(ecog,trialList,param) OLD REPLACED BY THE ABOVE
%
%
% --- UNIVARIATE STATISTICS
%
% ecogTValues(ecog1,ecog2) Calculate t values for two set comparison 
%
%
% --- CLASSIFICATION
%
% ecogSpiderMkDataObject(ecog1,ecog2) Outputs a data object for use with spider
%
% ecogSpiderTSClassify(ecog1,ecog2,c,) Perform a classification on two full ecog datasets
%
% ecogSpiderTSLeaveOneOut(ecog1,ecog2,c,crit) SVM leave-one-out cross validation with prior feature selection
%
%
% --- HELPER FUNCTIONS
%
% [theWavelet,scalingFac]=anoMkUnscaledMorlet(centerFreq,sampFreq,nCycles,scalingType) %Make unscaled complex Morlet wavelets
% nearly(timePoint,timeArray) Find closest sample index to time point.
%
%
% --- ARTIFACT REJECTION
% [badEpoch]=ecogArtifactRejAbnormalTrends_rev2(ecog.data,badEpoch,maxSlope,interval,shift) %Reject artifacts based on linear regression (maximum allowable slope)
% [badEpoch]=ecogArtifactRejAbnormalTrends_rev2(ecog.data,badEpoch,maxSlope,interval,shift) OLD REPLACED BY THE ABOVE
% [badEpoch]=ecogArtifactRejExtremeValues(ecog.data,badEpoch,max_dev); %Reject artifacts based on deviation from norm (static value)
% [badEpoch]=ecogArtifactRejImprobableValues(ecog.data,badEpoch,max_stdDev); %Reject artifacts based on deviation from norm (dynamic value based on std deviaton)

