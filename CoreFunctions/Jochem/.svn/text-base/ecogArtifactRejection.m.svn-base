%Who to blame: Nikolai Kalnin
doArtifactRejection=1;
run_abnormal_trend=1;
run_extreme_val=1;
run_improbable_val=1;
startstop=[1,5*512];
if doArtifactRejection
%     ecog.isGood=true(size(ecog.data)); %2-d vector that contains "bad" time segments

    %ABNORMAL TREND REJECTION
    %%%Plots least squares line through data over interval
    %%%Rejects when slope of line is too great

    %FREQUENTLY TUNED PROPERTIES
    % interval = the span (in seconds) over which 
    % the regression is to be done
    params.interval=round(.05*512);
    % interval=interval*ecog.timebase; %change of basis

    % maxslope = the maximum acceptible slope over the interval
    params.maxSlope = round(.005*512);

    % shift = the amount by which the interval moves forward each iteration
    %   (shift should be less than interval to ensure a good result)
    params.shift = round(.025*512);
    
    if run_abnormal_trend==1
        ecog.isGood(:,startstop(1):startstop(2)) = ecogArtifactRejAbnormalTrends_rev2(ecog.data(:,startstop(1):startstop(2)),ecog.isGood(:,startstop(1):startstop(2)),params);
    end

    %%EXTREME VALUE REJECTION
    %%%Rejects values far from mean
    
    %FREQUENTLY TUNED PROPERTIES
    %max deviation from mean
    max_dev=30;
    
    if run_extreme_val==1
        ecog.isGood(:,startstop(1):startstop(2))=ecogArtifactRejExtremeValues(ecog.data(:,startstop(1):startstop(2)),ecog.isGood(:,startstop(1):startstop(2)),max_dev);
    end

    %%IMPROBABLE VALUE REJECTION
    %%%Rejects values outside max_stdDev standard deviations away from mean
    

    %FREQUENTLY TUNED PROPERTIES
    max_stdDev=3;

    if run_improbable_val==1
        ecog.isGood(:,startstop(1):startstop(2))=ecogArtifactRejImprobableValues(ecog.data(:,startstop(1):startstop(2)),ecog.isGood(:,startstop(1):startstop(2)), max_stdDev);
    end
end

