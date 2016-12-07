function varargout = bn_model(varargin)
% BN_MODEL MATLAB code for bn_model.fig
%      BN_MODEL, by itself, creates a new BN_MODEL or raises the existing
%      singleton*.
%
%      H = BN_MODEL returns the handle to a new BN_MODEL or the handle to
%      the existing singleton*.
%
%      BN_MODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BN_MODEL.M with the given input arguments.
%
%      BN_MODEL('Property','Value',...) creates a new BN_MODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bn_model_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bn_model_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bn_model

% Last Modified by GUIDE v2.5 05-Dec-2016 12:39:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bn_model_OpeningFcn, ...
                   'gui_OutputFcn',  @bn_model_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bn_model is made visible.
function bn_model_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bn_model (see VARARGIN)

% Choose default command line output for bn_model
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bn_model wait for user response (see UIRESUME)
% uiwait(handles.figure1);

    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg
    
    if exist('properties.mat')
        load('properties.mat')
        if strcmp(dot_prg,'')
            dot_prg = sprintf('/usr/local/bin/dot');
        end
    else
            dot_prg = sprintf('/usr/local/bin/dot');
            save('properties.mat','dot_prg')
    end

    if ~exist(dot_prg)
        uiwait(errordlg('The GraphViz software is not configured properly, please visit www.graphviz.org to install or configure the path','Error','modal'));
    end



% --- Outputs from this function are returned to the command line.
function varargout = bn_model_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg
    
    [filename,pathname] = uigetfile('*.mat','Select the Dataset (Observations) file');
    if ~filename, return, end
        
    bn_filename=filename;
    bn_pathname=pathname;
    
    fullfilename=fullfile(bn_pathname, bn_filename);
    load(fullfilename);
    
    bn_dataset=logical(bn_dataset);
    
    set(handles.text1,'String',bn_filename);
    set(handles.uitable1,'Data',bn_dataset');
    set(handles.uitable1,'RowName',bn_nodeshortnames);

    set(handles.pushbutton2,'Enable','on');
    set(handles.pushbutton3,'Enable','on');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    bn_model_search

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    bn_model_edit


% --------------------------------------------------------------------
function menu_properties_Callback(hObject, eventdata, handles)
% hObject    handle to menu_properties (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    prompt = 'Path for dot program: /usr/local/bin/dot';
    dlg_title = 'GraphViz Configuration';
    num_lines = 1;
    def = {dot_prg};
    answer = inputdlg(prompt,dlg_title,num_lines,def);

    if ~isempty(answer)     
        dot_prg = answer{1};
        if ~exist(dot_prg)
            uiwait(errordlg('The GraphViz software is not configured properly, please visit www.graphviz.org to install or configure the path','Error','modal'));
        end     
        save('properties.mat','dot_prg');
    end
    
% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on pushbutton2 and none of its controls.
function pushbutton2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
