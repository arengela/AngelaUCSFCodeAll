function [h0,h1]=AR_controller(ecog)
h0 = ArtifactRejection_axesGUI(ecog);
h1 = ArtifactRejection_controlsGUI(h0);
handles = guidata(h0);
handles.close=h1;
guidata(h0,handles);
handles = guidata(h1);
handles.close=h0;
guidata(h1,handles);
set(h0,'CloseRequestFcn',@MyCloseFcn);
set(h1,'CloseRequestFcn',@MyCloseFcn);

function MyCloseFcn(src,evnt)
handles=guidata(gcbf);
delete(handles.close);
delete(gcbf);

