function varargout = NotOkayGUI(varargin)
% NOTOKAYGUI MATLAB code for NotOkayGUI.fig
%      NOTOKAYGUI, by itself, creates a new NOTOKAYGUI or raises the existing
%      singleton*.
%
%      H = NOTOKAYGUI returns the handle to a new NOTOKAYGUI or the handle to
%      the existing singleton*.
%
%      NOTOKAYGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NOTOKAYGUI.M with the given input arguments.
%
%      NOTOKAYGUI('Property','Value',...) creates a new NOTOKAYGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NotOkayGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NotOkayGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NotOkayGUI

% Last Modified by GUIDE v2.5 07-Dec-2016 18:32:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NotOkayGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @NotOkayGUI_OutputFcn, ...
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


% --- Executes just before NotOkayGUI is made visible.
function NotOkayGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NotOkayGUI (see VARARGIN)

% Choose default command line output for NotOkayGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NotOkayGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NotOkayGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%FOR ALL OF THE BELOW FUNCTIONS:
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
%runs level 1
     run('Level1.m')

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
%runs level 2
    run('Level2.m')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
%runs level 3
    run('Level3.m')


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
%runs level 4
    run('Level4.m')

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
%runs level 5
    run('Level5.m')

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
%runs level 6
    run('Level6.m')

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
%runs level 7
    run('Level7.m')

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% runs level 8
    run('Level8.m')

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
%runs level 9
    run('Level9.m')

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
%runs level 10
    run('Level10.m')

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
%runs level 11
    run('Level11.m')
    
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
%runs level 12
    run('Level12.m')
    
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
%runs level 13
    run('Level13.m')
    
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
%runs level 14
    run('Level14.m')
    
% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
%runs level 15
    run('Level15.m')
    
% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
%runs level 16
    run('Level16.m')
    
% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
%runs level 17
    run('Level17.m')
    
% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
%runs level 18
    run('Level18.m')
    
% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
%runs level 19
    run('Level19.m')
    
% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
%runs level 20
    run('Level20.m')
    
% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
%displays pop up help menu/tutorial
    helpScreen()

% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
%assigns and plays a random level
    randLevel()

% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
%quits game
close all
