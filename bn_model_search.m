function varargout = bn_model_search(varargin)
% BN_MODEL_SEARCH MATLAB code for bn_model_search.fig
%      BN_MODEL_SEARCH, by itself, creates a new BN_MODEL_SEARCH or raises the existing
%      singleton*.
%
%      H = BN_MODEL_SEARCH returns the handle to a new BN_MODEL_SEARCH or the handle to
%      the existing singleton*.
%
%      BN_MODEL_SEARCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BN_MODEL_SEARCH.M with the given input arguments.
%
%      BN_MODEL_SEARCH('Property','Value',...) creates a new BN_MODEL_SEARCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bn_model_search_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bn_model_search_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bn_model_search

% Last Modified by GUIDE v2.5 05-Dec-2016 12:40:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bn_model_search_OpeningFcn, ...
                   'gui_OutputFcn',  @bn_model_search_OutputFcn, ...
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


% --- Executes just before bn_model_search is made visible.
function bn_model_search_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bn_model_search (see VARARGIN)

% Choose default command line output for bn_model_search
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bn_model_search wait for user response (see UIRESUME)
% uiwait(handles.figure1);

    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    axes(handles.axes1)
    cla
    
    axes(handles.axes2)
    cla

    axes(handles.axes3)
    cla
    axis off
    daspect([ 1 1 1 ])
    axis([0 1 0 0.1])
    rectangle('Position',[0 0 1 0.1],'FaceColor','w')

    axes(handles.axes4)
    cla
    axis off
    daspect([ 1 1 1 ])
    axis([0 1 0 0.1])
    rectangle('Position',[0 0 1 0.1],'FaceColor','w')

% --- Outputs from this function are returned to the command line.
function varargout = bn_model_search_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton2.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    txt = get(hObject,'String')
    if strcmp(txt,'Run')
        set(hObject,'String','Stop')
        set(handles.pushbutton2,'Enable','Off')
        set(handles.pushbutton3,'Enable','Off')
        
        axes(handles.axes1),cla
        axes(handles.axes2),cla
        axes(handles.axes3),cla
        axis off
        daspect([ 1 1 1 ])
        axis([0 1 0 0.1])
        rectangle('Position',[0 0 1 0.1],'FaceColor','w')

        axes(handles.axes4),cla
        axis off
        daspect([ 1 1 1 ])
        axis([0 1 0 0.1])
        rectangle('Position',[0 0 1 0.1],'FaceColor','w')

        [m,n]=size(bn_dataset);    
        NARCS = n;                                                                      %define the average of arc count
    
        fitness='';
    	radio1=get(handles.radiobutton1,'Value');
        radio2=get(handles.radiobutton2,'Value');
        if radio1
            fitness='fitnessMDL';
        elseif radio2
            fitness='fitnessK2';
        end

        end_ngen=str2num(get(handles.edit1,'String'));
        PSIZE=str2num(get(handles.edit2,'String'));
    
        P0 = rand(PSIZE,NARCS^2)>0.85;													%initial random population
        P0(1,:)=zeros(1,NARCS^2);														%force a structure with no arcs
        P0(2,:)= reshape(triu(ones(NARCS,NARCS),1)',[1,NARCS^2]);		                %force a structure with full connection

        if NARCS==12
            x1=[
                0 0 0 0 0 1 1 0 0 0 0 0
                1 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 1 0 0 0 0
                0 0 0 0 0 0 0 1 0 0 0 0 
                0 0 0 0 0 1 1 0 0 0 0 0
                0 0 0 0 0 0 0 0 1 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 1 1 0
                0 0 0 0 0 0 0 0 0 1 1 0
                0 0 0 0 0 0 0 0 0 0 0 1
                0 0 0 0 0 0 0 0 0 0 0 0
                0 0 0 0 0 0 0 0 0 0 0 0
            ];
            X1 = reshape(x1',1,NARCS^2);
            P0(3,:)=X1;																		%force a bayesian network as CPN without transitions
        end
        

        bn_stopGA=0;
    
        [x1,f1,a1,c1,gen] = GA_bnsearch(...
            'labels'         ,bn_nodenames,...
            'P'              ,P0,...
            'fitness'        ,fitness,...
            'Dataset'        ,bn_dataset,...
            'NARCS'          ,NARCS,...
            'SIGMA'          ,0.75,...
            'end_ngen'       ,end_ngen,...
            'axes_fitness'   ,handles.axes1,...
            'axes_graph'     ,handles.axes2,...
            'axes_progress1' ,handles.axes3,...
            'axes_progress2' ,handles.axes4,...
            'edit_fitness1'  ,handles.edit4);

        xbest = x1(gen,:);
        fbest = f1(gen);
        bn_matrix = reshape(xbest,[NARCS,NARCS])';
        
        set(handles.edit4,'String',sprintf('%f',fbest));
        
        set(hObject,'String','Run')        
        set(hObject,'Enable','on')
        set(handles.pushbutton2,'Enable','On')
        set(handles.pushbutton3,'Enable','On')
        
    else
        %set(hObject,'String','Run')
        set(hObject,'Enable','off')
        bn_stopGA=1;
    end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if exist('tmp.png')
        figure
        I = imread('tmp.png');
        imshow(I)
    end
    
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    bn_model_edit

% --------------------------------------------------------------------
function Save_1_Callback(hObject, eventdata, handles)
% hObject    handle to Save_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    [filename, pathname] = uiputfile('*.mat', 'Save the BN model file','bn_network untitled.mat');
    if isequal(filename,0) || isequal(pathname,0)
        return
    end    
    
    fullfilename=fullfile(pathname,filename);
    
    bn_matrix1 = bn_matrix;
    bn_nodenames1 = bn_nodenames;
    save(fullfilename,'bn_matrix1','bn_nodenames1');
    


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save2PDF_Callback(hObject, eventdata, handles)
% hObject    handle to Save2PDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    [filename,pathname] = uiputfile('*.pdf','Save Network','bn_network test1.pdf');
    if ~filename, return, end
    fullfilename=fullfile(pathname,filename);
    
    dot_file = 'tmp3.dot';
    graph_to_dot(...
        'A'       ,bn_matrix,...
        'labels'  ,bn_nodenames,...
        'filename',dot_file);

    cmd = sprintf('more %s | %s -Tpdf > "%s"',dot_file,dot_prg,fullfilename);
    system(cmd);
        

% --------------------------------------------------------------------
function Save2EPS_Callback(hObject, eventdata, handles)
% hObject    handle to Save2EPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    [filename,pathname] = uiputfile('*.eps','Save Network','bn_network test1.eps');
    if ~filename, return, end
    fullfilename=fullfile(pathname,filename);
    
    dot_file = 'tmp3.dot';
    graph_to_dot(...
        'A'       ,bn_matrix,...
        'labels'  ,bn_nodenames,...
        'filename',dot_file);

    cmd = sprintf('more %s | %s -Teps > "%s"',dot_file,dot_prg,fullfilename);
    system(cmd);


% --------------------------------------------------------------------
function Save2PNG_Callback(hObject, eventdata, handles)
% hObject    handle to Save2PNG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global bn_filename bn_pathname bn_dataset bn_matrix bn_nodenames bn_nodeshortnames bn_stopGA dot_prg

    [filename,pathname] = uiputfile('*.png','Save Network','bn_network test1.png');
    if ~filename, return, end
    fullfilename=fullfile(pathname,filename);
    
    dot_file = 'tmp3.dot';
    graph_to_dot(...
        'A'       ,bn_matrix,...
        'labels'  ,bn_nodenames,...
        'filename',dot_file);

    cmd = sprintf('more %s | %s -Tpng > "%s"',dot_file,dot_prg,fullfilename);
    system(cmd);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
