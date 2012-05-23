function [axesParams]=updateAxesParams(handles)
axesParams.start_location=str2double(get(handles.start_location,'String'));
axesParams.plot_interval=str2double(get(handles.plot_interval,'String'));

%change of basis
axesParams.plot_interval=round(axesParams.plot_interval*1000/handles.ecog.sampDur);
axesParams.start_location=round(axesParams.start_location*1000/handles.ecog.sampDur);

%input validation
if axesParams.plot_interval > handles.ecog.nSamp
    tmp = handles.ecog.nSamp - 1;
    axesParams.plot_interval = tmp;
    tmp = tmp * handles.ecog.sampDur / 1000;
    set(handles.plot_interval,'String',num2str(tmp));
end
if axesParams.start_location + axesParams.plot_interval > handles.ecog.nSamp
    tmp = handles.ecog.nSamp - axesParams.plot_interval - 1;
    axesParams.start_location = tmp;
    tmp = tmp * handles.ecog.sampDur / 1000;
    set(handles.start_location,'String',num2str(tmp))
elseif axesParams.start_location < 1
    axesParams.start_location = 1;
    set(handles.start_location,'String','0')
end

