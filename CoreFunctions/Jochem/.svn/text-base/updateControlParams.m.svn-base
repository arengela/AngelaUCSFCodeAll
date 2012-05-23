function [controlParams,axesParams]=updateControlParams(handles)
%Abnormal trends
controlParams.AT_on=get(handles.AT_on,'Value');
controlParams.AT_maxSlope=str2double(get(handles.AT_maxSlope,'String'));
controlParams.AT_interval=str2double(get(handles.AT_interval,'String'));
controlParams.AT_shift=str2double(get(handles.AT_shift,'String'));
%Extreme Values
controlParams.EV_on=get(handles.EV_on,'Value');
controlParams.EV_maxDeviation=str2double(get(handles.EV_maxDeviation,'String'));
%Abnormal Values
controlParams.IV_on=get(handles.IV_on,'Value');
controlParams.IV_maxStdDev=str2double(get(handles.IV_maxStdDev,'String'));
%Manual Rejection
controlParams.MR_on=get(handles.MR_on,'Value');
controlParams.MR_beginning=str2double(get(handles.MR_beginning,'String'));
controlParams.MR_end=str2double(get(handles.MR_end,'String'));
%Parameters from other window
axesParams=updateAxesParams(guidata(handles.axesFig));
axesHandles=guidata(handles.axesFig);

%change of basis
sec2indF=1000/axesHandles.ecog.sampDur; %sec2indF is the seconds to indecies conversion factor

controlParams.AT_maxSlope=round(controlParams.AT_maxSlope*sec2indF);
controlParams.AT_interval=round(controlParams.AT_interval*sec2indF);
controlParams.AT_shift=round(controlParams.AT_shift*sec2indF);


controlParams.MR_beginning=round(controlParams.MR_beginning*sec2indF);
controlParams.MR_end=round(controlParams.MR_end*sec2indF);

%input validation
if controlParams.AT_interval > axesParams.plot_interval
    controlParams.AT_interval = axesParams.plot_interval;
    tmp=round(controlParams.AT_interval/sec2indF);
    set(handles.AT_interval,'String',tmp);
elseif controlParams.AT_interval < 2
    controlParams.AT_interval = 2;
    tmp=round(controlParams.AT_interval/sec2indF);
    set(handles.AT_interval,'String',tmp);
end