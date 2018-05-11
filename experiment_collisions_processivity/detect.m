function varargout = GUI_Version_04(varargin)

    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @GUI_Version_04_OpeningFcn, ...
                       'gui_OutputFcn',  @GUI_Version_04_OutputFcn, ...
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
end

function figure1_CreateFcn(hObject, eventdata, handles)

    global n; n=1;
    global min_grau; min_grau=int16(130);
    global name_mov1; name_mov1 = '8thOct_1i.avi';
    global del_sum; del_sum=int16(650);
    global ana,ana=1;
    global fil;fil=1;

  
    global delt_wink, delt_wink=5;
  
    F = aviinfo(name_mov1),
    
    global anz_frame_mov; anz_frame_mov=F.NumFrames;
    global is_indexed_mov;
    if strcmpi(F.ImageType,'indexed')
        is_indexed_mov=logical(1);
    else
        is_indexed_mov=logical(0);
    end
    
    setappdata(hObject, 'StartPath', pwd);
    addpath(pwd);
  end


function GUI_Version_04_OpeningFcn(hObject, eventdata, handles, varargin)

    handles.output = hObject;

    guidata(hObject, handles);

    if nargin == 3,
        initial_dir = pwd;
    elseif nargin > 4
        if strcmpi(varargin{1},'dir')
            if exist(varargin{2},'dir')
                initial_dir = varargin{2};
            else
                errordlg('Input argument must be a valid directory','Input Argument Error!')
                return
            end
        else
            errordlg('Unrecognized input argument','Input Argument Error!');
            return;
        end
    end
     load_listbox(initial_dir,handles)
 
    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;
  
    makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);  
end

function varargout = GUI_Version_04_OutputFcn(hObject, eventdata, handles) 

    varargout{1} = handles.output;

end


function edit1_Callback(hObject, eventdata, handles)
    disp(str2double(get(hObject,'String')));
end

function edit1_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

end


function slider_min_grau_Callback(hObject, eventdata, handles)

    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;

    slider_value=round(get(hObject,'Value'));
    set(handles.edit_grau_min,'String',slider_value);
    set(handles.slider_min_grau,'Value',slider_value);
    min_grau=slider_value;
    
    makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);

end


function slider_min_grau_CreateFcn(hObject, eventdata, handles)

    global n;
    global min_grau;

    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
    set(hObject,'Value',min_grau);
    
end

function edit_grau_min_Callback(hObject, eventdata, handles)

    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;

    wert=round(str2double(get(hObject,'String')));
    if isnan(wert),
        wert=200;
    elseif wert>255,
        wert=255;
    elseif wert<0,
        wert=0;
    end
    set(handles.edit_grau_min,'String',wert);
    set(handles.slider_min_grau,'Value',wert);
    min_grau=wert;
    
    makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);
end


function edit_grau_min_CreateFcn(hObject, eventdata, handles)

    global min_grau;

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    set(hObject,'String',min_grau);

end


function tog_play_Callback(hObject, eventdata, handles)

    
    button_state = get(hObject,'Value');
    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;
    global anz_frame_mov;
    
    set(handles.edit_framenr,'Enable','off');
    while button_state,
        if n<anz_frame_mov,
            n=n+1;
        else
            set(hObject,'Value',1);
            break;
        end
        
        makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);
        
        
        set(handles.edit_framenr,'String',n);
        
        button_state = get(hObject,'Value');
        

    end
    set(handles.edit_framenr,'Enable','on');
    set(hObject,'Value',0);
    
    if n+1>anz_frame_mov,
        set(handles.pushbutton_nauf,'Enable','off');
        set(handles.pushbutton_nab,'Enable','on');
    elseif n-1<1,
        set(handles.pushbutton_nab,'Enable','off');
        set(handles.pushbutton_nauf,'Enable','on');
    else
        set(handles.pushbutton_nab,'Enable','on');
        set(handles.pushbutton_nauf,'Enable','on');
    end 
    
end

function slider_del_sum_Callback(hObject, eventdata, handles)


    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;

    slider_value=round(get(hObject,'Value'));
    set(handles.edit_del_sum,'String',slider_value);
    set(hObject,'Value',slider_value);
    del_sum=slider_value;
    
    makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);

end


function slider_del_sum_CreateFcn(hObject, eventdata, handles)


    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

    global del_sum;
    
    set(hObject,'Value',del_sum);
end


function edit_del_sum_Callback(hObject, eventdata, handles)

    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;


    wert=round(str2double(get(hObject,'String')));
    if isnan(wert),
        wert=650;
    elseif wert>1020,
        wert=1020;
    elseif wert<0,
        wert=0;
    end
    set(hObject,'String',wert);
    set(handles.slider_del_sum,'Value',wert);
    del_sum=wert;
    
    makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);

end


function edit_del_sum_CreateFcn(hObject, eventdata, handles)
    
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    global del_sum;
    
    set(hObject,'String',del_sum);
    
end



function makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,win1,win2)

    global is_indexed_mov
    
        tic;
      
        pic = aviread(name_mov1,n);
        if is_indexed_mov
            image_mat=pic.cdata;
        else
            image_mat=pic.cdata(:,:,1);
        end
        
     
        toc,
        if fil,
         
            tic;
            im_gefil=filteralg(image_mat,min_grau,del_sum);
            time_filter=toc,
         
            im_gefil(:,1:20)=0;
           
            if ana,
               
                tic;
                anaresult=analyse(im_gefil,min_grau,delt_wink);
                time_analyse=toc,
              
                tic
                axes(win1);
                figure(gcf);
                imagesc(anaresult.map); 
                colormap(colorcube(double(anaresult.fil_nr)));
                
                time_draw=toc,
                
                axes(win2);
                figure(gcf);
                hist(double(anaresult.fil_wink),single(180/delt_wink));

            else
                axes(win1);
                figure(gcf);
                colormap(jet);
                imagesc(im_gefil);
                
            end
        else
                axes(win1);
                figure(gcf);
                colormap(gray(255));
                imagesc(image_mat);
                
        end

end


function checkbox_fil_Callback(hObject, eventdata, handles)

    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;
    
    fil=get(hObject,'Value');
    if fil,
        set(handles.checkbox_ana,'Enable','on');
    else
        set(handles.checkbox_ana,'Enable','off');
    end
    
    makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);
    
end


function checkbox_ana_Callback(hObject, eventdata, handles)

    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;
    
    ana=get(hObject,'Value');

    makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);
    
end



function edit_framenr_Callback(hObject, eventdata, handles)

    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;
    global anz_frame_mov;
    
    wert=round(str2double(get(hObject,'String')));
    if isnan(wert),
        wert=1;
        set(handles.pushbutton_nab,'Enable','off')
        set(handles.pushbutton_nauf,'Enable','on');
    elseif wert>anz_frame_mov,
        wert=anz_frame_mov;
        set(handles.pushbutton_nauf,'Enable','off')
        set(handles.pushbutton_nab,'Enable','on');
    elseif wert<1,
        wert=1;
        set(handles.pushbutton_nab,'Enable','off')
        set(handles.pushbutton_nauf,'Enable','on');
    end
    set(hObject,'String',wert);
    n=wert;
    
    if n+1>anz_frame_mov,
        set(handles.pushbutton_nauf,'Enable','off');
        set(handles.pushbutton_nab,'Enable','on');
    elseif n-1<1,
        set(handles.pushbutton_nab,'Enable','off');
        set(handles.pushbutton_nauf,'Enable','on');
    else
        set(handles.pushbutton_nab,'Enable','on');
        set(handles.pushbutton_nauf,'Enable','on');
    end   

    makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);

end


function edit_framenr_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    global n;
   
    set(hObject,'String',n);
    
end


function vergl(name_mov1,n,min_grau,del_sum,delt_wink,win1,win2)
    global is_indexed_mov;

    pic = aviread(name_mov1,n-1);
    if is_indexed_mov
        image_mat=pic.cdata;
    else
        image_mat=pic.cdata(:,:,1);
    end    
    
    %image_mat=rgb2gray(pic.cdata);
    im_gefil=filteralg(image_mat,min_grau,del_sum);
    
    tic;
    anaresult1=analyse(im_gefil,min_grau,delt_wink);
    time_bild1=toc,
    
    assignin('base','ANA1',anaresult1);
    
    axes(win1);
    figure(1);
    colormap(colorcube(double(anaresult1.fil_nr)));  
    image(anaresult1.map); 
    drawnow;  

    disp('bild0');
       
    pic = aviread(name_mov1,n);
    if is_indexed_mov
        image_mat=pic.cdata;
    else
        image_mat=pic.cdata(:,:,1);
    end      
    
    im_gefil=filteralg(image_mat,min_grau,del_sum);
    
    tic;
    anaresult1=anavergl(im_gefil,min_grau,delt_wink,anaresult1);
    tim_bild2=toc,
    
    assignin('base','ANA1',anaresult1);
    
    axes(win1);
    figure(1);
    colormap(colorcube(double(anaresult1.fil_nr))); 
    image(anaresult1.map); 
    drawnow;   
    
    pic = aviread(name_mov1,n+1);
    if is_indexed_mov
        image_mat=pic.cdata;
    else
        image_mat=pic.cdata(:,:,1);
    end      
    
    im_gefil=filteralg(image_mat,min_grau,del_sum);
    
    tic;
    anaresult2=anavergl(im_gefil,min_grau,delt_wink,anaresult1);
    tim_bild2=toc,
    
    assignin('base','ANA2',anaresult2);
    
    axes(win1);
    figure(2);
    colormap(colorcube(double(anaresult1.fil_nr))); 
    image(anaresult2.map); 
    drawnow;   
    
    for i=int16(1):anaresult2.fil_nr,
        if anaresult2.fil_gr(i)>0,
        
            if anaresult2.fil_qu(i)==0,
                text(double(anaresult2.fil_x(i)),double(anaresult2.fil_y(i)),strcat(int2str(anaresult2.fil_wink(i)+180),', Nr: ', int2str(anaresult2.fil_qu(i))),'FontSize',8,'Color',[0,1,0]);                                
            elseif anaresult2.fil_qu(i)<3,
                text(double(anaresult2.fil_x(i)),double(anaresult2.fil_y(i)),strcat(int2str(anaresult2.fil_wink(i)+180),', Nr: ', int2str(anaresult2.fil_qu(i))),'FontSize',8,'Color',[1,0,0]);
            else
                text(double(anaresult2.fil_x(i)),double(anaresult2.fil_y(i)),strcat(int2str(anaresult2.fil_wink(i)),', Nr: ', int2str(anaresult2.fil_qu(i))),'FontSize',8,'Color',[0,0,1]);
            end
        end
    end
    
    
end


function pushbutton3_Callback(hObject, eventdata, handles)

    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;

    vergl(name_mov1,n,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);
    
    disp('fertig');

end


function anaresult=analyse(im_gefil,min_grau,delt_wink)
    
        fil_map=int16(zeros(size(im_gefil,1),size(im_gefil,2)));
        fil_nr=int16(1);
        fil_x=int16([]);
        fil_x(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_y=int16([]);
        fil_y(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_gr=int16([]);
        fil_gr(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_wink=int16([]);
        fil_abst=int16([]);
        fil_wink(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_abst(size(im_gefil,1)*size(im_gefil,2))=0;
        stackx=int16([]);
        stackx(size(im_gefil,1)*size(im_gefil,2))=0;
        stacky=int16([]);
        stacky(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_ausrmap_t=int16(zeros(4000,180/delt_wink+1));
        tmpx=0;
        tmpy=0;
        for x=int16(2):size(im_gefil,2),
            for y=int16(2):size(im_gefil,1),
                if  fil_map(y,x)==0 && im_gefil(y,x)>min_grau,
                    tmpx=0;
                    tmpy=0;
                    n_max=1;
                    i=1;
                    stackx(1)=x;
                    stacky(1)=y;
%                    
                    while i<=n_max,

                        fil_gr(fil_nr)=fil_gr(fil_nr)+1;
                        tmpx=tmpx+double(stackx(i));
                        tmpy=tmpy+double(stacky(i));

                  
                        if (stacky(i) + 1)>0 && (stackx(i))>0 && (stacky(i) + 1)<=size(fil_map,1) && (stackx(i))<=size(fil_map,2) && fil_map(stacky(i) + 1, stackx(i))==0 && im_gefil(stacky(i) + 1, stackx(i))>min_grau,
                            stacky(n_max+1)=stacky(i)+1;
                            stackx(n_max+1)=stackx(i);
                            n_max=n_max+1;
                            fil_map(stacky(i)+1,stackx(i))=fil_nr;
                        end
                        if (stacky(i) - 1)>0 && (stackx(i))>0 && (stacky(i) - 1)<=size(fil_map,1) && (stackx(i))<=size(fil_map,2) && fil_map(stacky(i) - 1, stackx(i))==0 && im_gefil(stacky(i) - 1, stackx(i))>min_grau,
                            stacky(n_max+1)=stacky(i)-1;
                            stackx(n_max+1)=stackx(i);
                            n_max=n_max+1;
                            fil_map(stacky(i)-1,stackx(i))=fil_nr;
                        end
                        if (stacky(i))>0 && (stackx(i)+1)>0 && stacky(i)<=size(fil_map,1) && (stackx(i)+1)<=size(fil_map,2) && fil_map(stacky(i), stackx(i) + 1)==0 && im_gefil(stacky(i), stackx(i) + 1)>min_grau,
                            stacky(n_max+1)=stacky(i);
                            stackx(n_max+1)=stackx(i)+1;
                            n_max=n_max+1;
                            fil_map(stacky(i),stackx(i)+1)=fil_nr;
                        end
                        if (stacky(i))>0 && (stackx(i)-1)>0 && stacky(i)<=size(fil_map,1) && (stackx(i)-1)<=size(fil_map,2) && fil_map(stacky(i), stackx(i) - 1)==0 && im_gefil(stacky(i), stackx(i) - 1)>min_grau,
                            stacky(n_max+1)=stacky(i);
                            stackx(n_max+1)=stackx(i)-1;
                            n_max=n_max+1;
                            fil_map(stacky(i),stackx(i)-1)=fil_nr;
                        end
                        i=i+1;
                    end         
                    fil_x(fil_nr)=int16(tmpx/fil_gr(fil_nr));
                    fil_y(fil_nr)=int16(tmpy/fil_gr(fil_nr));       

                    if fil_gr(fil_nr)<25,
                        for i=1:n_max
                            fil_map(stacky(i),stackx(i))=0;
                        end
                        fil_gr(fil_nr)=0;
                        fil_nr=fil_nr-1;
                    else
                        fil_ausrmap=fil_ausrmap_t;
                        dmax=int16(0);
                        for i=1:n_max
                            tmpx=double(stackx(i));
                            tmpy=double(stacky(i));
                        
                            for alpha=0:delt_wink:180,
                               d=round(tmpx*sin(alpha*pi/180)-tmpy*cos(alpha*pi/180));
                               fil_ausrmap(d+1500,alpha/delt_wink+1)=fil_ausrmap(d+1500,alpha/delt_wink+1)+1;
                               if dmax<fil_ausrmap(d+1500,alpha/delt_wink+1),
                                   dmax=fil_ausrmap(d+1500,alpha/delt_wink+1);
                                   fil_wink(fil_nr)=int16(alpha);
                                   fil_abst(fil_nr)=int16(d);
                               end
                            end
                           
                        end
                    end
                   
                    fil_nr=fil_nr+1;                
                end

            end
        end
        fil_x=fil_x(1:fil_nr);
        fil_y=fil_y(1:fil_nr);
        fil_gr=fil_gr(1:fil_nr);
        
        fil_wink=fil_wink(1:fil_nr);
        fil_abst=fil_abst(1:fil_nr);
        
        anaresult.map=fil_map;
        anaresult.fil_x=fil_x;
        anaresult.fil_y=fil_y;
        anaresult.fil_gr=fil_gr;
        anaresult.fil_wink=fil_wink;
        anaresult.fil_abst=fil_abst;
        anaresult.fil_nr=fil_nr;
        
        
end


function anaresult=anavergl(im_gefil,min_grau,delt_wink,inresult)

        fil_map=int16(zeros(size(im_gefil,1),size(im_gefil,2)));
        fil_nr=inresult.fil_nr+1;
        fil_x=int16([]);
        fil_x(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_y=int16([]);
        fil_y(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_x0=int16([]);
        fil_x0(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_y0=int16([]);
        fil_y0(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_gr=int16([]);
        fil_gr(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_wink=int16([]);
        fil_abst=int16([]);
        fil_wink(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_abst(size(im_gefil,1)*size(im_gefil,2))=0;
        fil_qu=int16([]);
        fil_qu(size(im_gefil,1)*size(im_gefil,2))=0;
        stackx=int16([]);
        stackx(size(im_gefil,1)*size(im_gefil,2))=0;
        stacky=int16([]);
        stacky(size(im_gefil,1)*size(im_gefil,2))=0;
     
        fil_ausrmap_t=int16(zeros(4000,180/delt_wink+1));
     
        radius=int16(40);
        stack_filnr(radius*(radius+1))=int16(0);
        stack_punkte(radius*(radius+1))=int16(0);
        fil_pkt=int16([]);
        fil_pkt(1:size(im_gefil,1)*size(im_gefil,2))=int16(1100);

   
        for x=int16(2):size(im_gefil,2),
            for y=int16(2):size(im_gefil,1),
                
                if  fil_map(y,x)==0 && im_gefil(y,x)>min_grau,
                    tmpx=0;
                    tmpy=0; 
                    n_max=int16(1);
                    i=int16(1);
                    stackx(1)=x;
                    stacky(1)=y;
                    fil_x0(fil_nr)=x;
                    fil_y0(fil_nr)=y;
                    while i<=n_max,

                        fil_gr(fil_nr)=fil_gr(fil_nr)+1;
                        tmpx=tmpx+double(stackx(i));
                        tmpy=tmpy+double(stacky(i));

                 
                        if (stacky(i) + 1)>0 && (stackx(i))>0 && (stacky(i) + 1)<=size(fil_map,1) && (stackx(i))<=size(fil_map,2) && fil_map(stacky(i) + 1, stackx(i))==0 && im_gefil(stacky(i) + 1, stackx(i))>min_grau,
                            stacky(n_max+1)=stacky(i)+1;
                            stackx(n_max+1)=stackx(i);
                            n_max=n_max+1;
                            fil_map(stacky(i)+1,stackx(i))=fil_nr;
                        end
                        if (stacky(i) - 1)>0 && (stackx(i))>0 && (stacky(i) - 1)<=size(fil_map,1) && (stackx(i))<=size(fil_map,2) && fil_map(stacky(i) - 1, stackx(i))==0 && im_gefil(stacky(i) - 1, stackx(i))>min_grau,
                            stacky(n_max+1)=stacky(i)-1;
                            stackx(n_max+1)=stackx(i);
                            n_max=n_max+1;
                            fil_map(stacky(i)-1,stackx(i))=fil_nr;
                        end
                        if (stacky(i))>0 && (stackx(i)+1)>0 && stacky(i)<=size(fil_map,1) && (stackx(i)+1)<=size(fil_map,2) && fil_map(stacky(i), stackx(i) + 1)==0 && im_gefil(stacky(i), stackx(i) + 1)>min_grau,
                            stacky(n_max+1)=stacky(i);
                            stackx(n_max+1)=stackx(i)+1;
                            n_max=n_max+1;
                            fil_map(stacky(i),stackx(i)+1)=fil_nr;
                        end
                        if (stacky(i))>0 && (stackx(i)-1)>0 && stacky(i)<=size(fil_map,1) && (stackx(i)-1)<=size(fil_map,2) && fil_map(stacky(i), stackx(i) - 1)==0 && im_gefil(stacky(i), stackx(i) - 1)>min_grau,
                            stacky(n_max+1)=stacky(i);
                            stackx(n_max+1)=stackx(i)-1;
                            n_max=n_max+1;
                            fil_map(stacky(i),stackx(i)-1)=fil_nr;
                        end
                        i=i+1;
                    end
                    fil_x(fil_nr)=int16(tmpx/fil_gr(fil_nr));
                    fil_y(fil_nr)=int16(tmpy/fil_gr(fil_nr));                    


                
                    if fil_gr(fil_nr)<25,
                        for i=1:n_max
                            fil_map(stacky(i),stackx(i))=0;
                        end
                        fil_gr(fil_nr)=0;
                        fil_nr=fil_nr-1;
                    else
                        fil_ausrmap=fil_ausrmap_t;
                        dmax=int16(0);
                        for i=1:n_max
                            tmpx=double(stackx(i));
                            tmpy=double(stacky(i));
                        
                            for alpha=0:delt_wink:180,
                               d=round(tmpx*sin(alpha*pi/180)-tmpy*cos(alpha*pi/180));
                               fil_ausrmap(d+1500,alpha/delt_wink+1)=fil_ausrmap(d+1500,alpha/delt_wink+1)+1;
                               if dmax<fil_ausrmap(d+1500,alpha/delt_wink+1),
                                   dmax=fil_ausrmap(d+1500,alpha/delt_wink+1);
                                   fil_wink(fil_nr)=int16(alpha);
                                   fil_abst(fil_nr)=int16(d);
                               end
                            end
                          
                        end
                        
                        kx=fil_x(fil_nr);
                        ky=fil_y(fil_nr);
                        vorz=int16(-1);
                        nr=int16(1);
                        max=int16(900);
                        maxnr=int16(0);
                        entpkt=2;
                        grpkt=int16(2);
                        winkpkt=1;
                        abstpkt=0.5;
                        
                        if inresult.map(ky,kx)>0,
                            stack_filnr(nr)=inresult.map(ky,kx);

                            stack_punkte(nr)=abs(inresult.fil_gr(stack_filnr(nr))-fil_gr(fil_nr))*grpkt+abs(inresult.fil_wink(stack_filnr(nr))-fil_wink(fil_nr))*winkpkt+abs(inresult.fil_abst(stack_filnr(nr))*abstpkt-fil_abst(fil_nr))+int16(entpkt*sqrt(double(fil_x(fil_nr)-inresult.fil_x(stack_filnr(nr)))^2 + double(fil_y(fil_nr)-inresult.fil_y(stack_filnr(nr)))^2));
                            if stack_punkte(nr)<max && stack_punkte(nr)<fil_pkt(stack_filnr(nr)),
                                max=stack_punkte(nr);
                                maxnr=nr;
                            end                            
                            nr=nr+1;

                        end
                        for z=1:radius
                             vorz=-vorz;
                             for k=1:z
                                if ky+(k*vorz)>0 && ky+(k*vorz)<size(inresult.map,1),
                                    if inresult.map(ky+(k*vorz),kx)>0,
                                        stack_filnr(nr)=inresult.map(ky+(k*vorz),kx);

                                        stack_punkte(nr)=abs(inresult.fil_gr(stack_filnr(nr))-fil_gr(fil_nr))*grpkt+abs(inresult.fil_wink(stack_filnr(nr))-fil_wink(fil_nr))*winkpkt+abs(inresult.fil_abst(stack_filnr(nr))-fil_abst(fil_nr))*abstpkt+int16(entpkt*sqrt(double(fil_x(fil_nr)-inresult.fil_x(stack_filnr(nr)))^2 + double(fil_y(fil_nr)-inresult.fil_y(stack_filnr(nr)))^2));
                                        if stack_punkte(nr)<max && stack_punkte(nr)<fil_pkt(stack_filnr(nr)),
                                            max=stack_punkte(nr);
                                            maxnr=nr;
                                        end
                                        nr=nr+1;

                                    end
                                else
                                    break
                                end
                             end
                            if ky+(k*vorz)>0 && ky+(k*vorz)<size(inresult.map,1), ky=ky+(k*vorz); end
                            for k=1:z
                                if kx-(k*vorz)>0 && kx-(k*vorz)<size(inresult.map,2),
                                    if inresult.map(ky,kx-(k*vorz))>0,
                                        stack_filnr(nr)=inresult.map(ky,kx-(k*vorz));

                                        stack_punkte(nr)=abs(inresult.fil_gr(stack_filnr(nr))-fil_gr(fil_nr))*grpkt+abs(inresult.fil_wink(stack_filnr(nr))-fil_wink(fil_nr))*winkpkt+abs(inresult.fil_abst(stack_filnr(nr))-fil_abst(fil_nr))*abstpkt+int16(entpkt*sqrt(double(fil_x(fil_nr)-inresult.fil_x(stack_filnr(nr)))^2 + double(fil_y(fil_nr)-inresult.fil_y(stack_filnr(nr)))^2));
                                        if stack_punkte(nr)<max && stack_punkte(nr)<fil_pkt(stack_filnr(nr)),
                                            max=stack_punkte(nr);
                                            maxnr=nr;
                                        end
                                        nr=nr+1;

                                    end
                                else
                                    break
                                end
                            end
                            if kx-(k*vorz)>0 && kx-(k*vorz)<size(inresult.map,2), kx=kx-(k*vorz); end
                        end
                        if maxnr>0,
                            for i=1:n_max
                                fil_map(stacky(i),stackx(i))=stack_filnr(maxnr); 
                            end

                            dx=fil_x(fil_nr)-inresult.fil_x(stack_filnr(maxnr));
                            dy=fil_y(fil_nr)-inresult.fil_y(stack_filnr(maxnr));
                            
                            if dx>=0 && dy>=0,
                                fil_qu(stack_filnr(maxnr))=4;                              
                            elseif dx>=0 && dy<0,
                                fil_qu(stack_filnr(maxnr))=1;                               
                            elseif dx<0 && dy>0,
                                fil_qu(stack_filnr(maxnr))=3;
                            elseif dx<0 && dy<=0,
                                fil_qu(stack_filnr(maxnr))=2;
                            end
                            

                            
                            if fil_gr(stack_filnr(maxnr))>0,
                             
                                tx=fil_x(stack_filnr(maxnr));
                                ty=fil_y(stack_filnr(maxnr));
                                tx0=fil_x0(stack_filnr(maxnr));
                                ty0=fil_y0(stack_filnr(maxnr));                                
                                tgr=fil_gr(stack_filnr(maxnr));
                                twink=fil_wink(stack_filnr(maxnr));
                                tabst=fil_abst(stack_filnr(maxnr));
                                
                                fil_x(stack_filnr(maxnr))=fil_x(fil_nr);
                                fil_y(stack_filnr(maxnr))=fil_y(fil_nr);
                                fil_x0(stack_filnr(maxnr))=fil_x0(fil_nr);
                                fil_y0(stack_filnr(maxnr))=fil_y0(fil_nr);                                  
                                fil_gr(stack_filnr(maxnr))=fil_gr(fil_nr);
                                fil_wink(stack_filnr(maxnr))=fil_wink(fil_nr);
                                fil_abst(stack_filnr(maxnr))=fil_abst(fil_nr);
                                fil_pkt(stack_filnr(maxnr))=max;
                                
                                fil_x(fil_nr)=tx;
                                fil_y(fil_nr)=ty;
                                fil_x0(fil_nr)=tx0;
                                fil_y0(fil_nr)=ty0;                                
                                fil_gr(fil_nr)=tgr;
                                fil_wink(fil_nr)=twink;
                                fil_abst(fil_nr)=tabst;
                                fil_pkt(fil_nr)=0;
                             
                                n_max=int16(1);
                                i=int16(1);
                                stackx(1)=tx0;
                                stacky(1)=ty0;
                                
                                while i<=n_max,

                                

                                    if (stacky(i) + 1)>0 && (stackx(i))>0 && (stacky(i) + 1)<=size(fil_map,1) && (stackx(i))<=size(fil_map,2) && fil_map(stacky(i) + 1, stackx(i))==stack_filnr(maxnr),
                                        stacky(n_max+1)=stacky(i)+1;
                                        stackx(n_max+1)=stackx(i);
                                        n_max=n_max+1;
                                        fil_map(stacky(i)+1,stackx(i))=fil_nr;
                                    end
                                    if (stacky(i) - 1)>0 && (stackx(i))>0 && (stacky(i) - 1)<=size(fil_map,1) && (stackx(i))<=size(fil_map,2) && fil_map(stacky(i) - 1, stackx(i))==stack_filnr(maxnr),
                                        stacky(n_max+1)=stacky(i)-1;
                                        stackx(n_max+1)=stackx(i);
                                        n_max=n_max+1;
                                        fil_map(stacky(i)-1,stackx(i))=fil_nr;
                                    end
                                    if (stacky(i))>0 && (stackx(i)+1)>0 && stacky(i)<=size(fil_map,1) && (stackx(i)+1)<=size(fil_map,2) && fil_map(stacky(i), stackx(i) + 1)==stack_filnr(maxnr),
                                        stacky(n_max+1)=stacky(i);
                                        stackx(n_max+1)=stackx(i)+1;
                                        n_max=n_max+1;
                                        fil_map(stacky(i),stackx(i)+1)=fil_nr;
                                    end
                                    if (stacky(i))>0 && (stackx(i)-1)>0 && stacky(i)<=size(fil_map,1) && (stackx(i)-1)<=size(fil_map,2) && fil_map(stacky(i), stackx(i) - 1)==stack_filnr(maxnr),
                                        stacky(n_max+1)=stacky(i);
                                        stackx(n_max+1)=stackx(i)-1;
                                        n_max=n_max+1;
                                        fil_map(stacky(i),stackx(i)-1)=fil_nr;
                                    end
                                    i=i+1;
                                end
                               

                    
                            else
                                
                                fil_x(stack_filnr(maxnr))=fil_x(fil_nr);
                                fil_y(stack_filnr(maxnr))=fil_y(fil_nr);
                                fil_x0(stack_filnr(maxnr))=fil_x0(fil_nr);
                                fil_y0(stack_filnr(maxnr))=fil_y0(fil_nr);                                
                                fil_gr(stack_filnr(maxnr))=fil_gr(fil_nr);
                                fil_wink(stack_filnr(maxnr))=fil_wink(fil_nr);
                                fil_abst(stack_filnr(maxnr))=fil_abst(fil_nr);
                                fil_pkt(stack_filnr(maxnr))=max;
                                
                                fil_x(fil_nr)=0;
                                fil_y(fil_nr)=0;
                                fil_x0(fil_nr)=0;
                                fil_y0(fil_nr)=0;
                                fil_gr(fil_nr)=0;
                                fil_wink(fil_nr)=0;
                                fil_pkt(fil_nr)=0;
                                
                                fil_nr=fil_nr-1;
                                
                            end

                            
                        end 
                        
                    end
               
                    fil_nr=fil_nr+1;                
                end

            end
        end

        
        anaresult.map=fil_map;
        anaresult.fil_x=fil_x(1:fil_nr);
        anaresult.fil_y=fil_y(1:fil_nr);
        anaresult.fil_gr=fil_gr(1:fil_nr);
        anaresult.fil_wink=fil_wink(1:fil_nr);
        anaresult.fil_abst=fil_abst(1:fil_nr);
        anaresult.fil_qu=fil_qu(1:fil_nr);
        anaresult.fil_nr=fil_nr;

        
end




function tog_vergl_Callback(hObject, eventdata, handles)
    button_state = get(hObject,'Value');
    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;
    global anz_frame_mov;
    global is_indexed_mov
    
    set(handles.edit_framenr,'Enable','off');
    k=int16(0);
    
    if button_state,
        pic = aviread(name_mov1,n);
        if is_indexed_mov
            image_mat=pic.cdata;
        else
            image_mat=pic.cdata(:,:,1);
        end      
       
        im_gefil=filteralg(image_mat,min_grau,del_sum);
        
        im_gefil(:,1:20)=0;
    
        tic;
        anaresult1=analyse(im_gefil,min_grau,delt_wink);
        time_bild1=toc,
        
           
            fid=fopen(strcat('Auswertung',date,'.txt'),'wt');
      
            for o=1:anaresult1.fil_nr
                if anaresult1.fil_gr(o)>0
                    fprintf(fid,'%4.0u\t%4.0u\t%4.0u\t%4.0u\t%4.0u\t%4.0u\n',[o; n; anaresult1.fil_x(o); anaresult1.fil_y(o); anaresult1.fil_wink(o); anaresult1.fil_gr(o)]);
                end
            end
            fclose(fid);
        
         axes(handles.axes1);
        figure(gcf);
        farben=double(anaresult1.fil_nr);
        colormap(colorcube(farben));  
        image(anaresult1.map); 
        drawnow;
        
        winkel_list=[];
        n0=n;

    end
    
    
    while button_state,
        if n<anz_frame_mov,
            n=n+1;
        else
            set(hObject,'Value',1);
            break;
        end
            pic = aviread(name_mov1,n);
        if is_indexed_mov
            image_mat=pic.cdata;
        else
            image_mat=pic.cdata(:,:,1);
        end      
            
        im_gefil=filteralg(image_mat,min_grau,del_sum);
              
        im_gefil(:,1:20)=0;
  
        
        tic;
        anaresult2=anavergl(im_gefil,min_grau,delt_wink,anaresult1);
        tim_bild2=toc,
        
          
        fid=fopen(strcat('Auswertung',date,'.txt'),'at');
            for o=1:anaresult1.fil_nr
            if anaresult1.fil_gr(o)>0
                fprintf(fid,'%4.0u\t%4.0u\t%4.0u\t%4.0u\t%4.0u\t%4.0u\n',[o; n; anaresult1.fil_x(o); anaresult1.fil_y(o); anaresult1.fil_wink(o); anaresult1.fil_gr(o)]);
            end
        end
        fclose(fid);
        
     

        axes(handles.axes1);
        figure(gcf);
        colormap(colorcube(farben)); 
        image(mod(anaresult2.map,farben)); 
        drawnow;   
        
        pause(0.001);
        if get(handles.checkbox_labeled,'Value'),
            for i=int16(1):anaresult2.fil_nr,
                if anaresult2.fil_gr(i)>0,

                               
                    if anaresult2.fil_qu(i)==0,
                        text(double(anaresult2.fil_x(i)),double(anaresult2.fil_y(i)),strcat(int2str(anaresult2.fil_wink(i)+180),', Nr: ', int2str(i)),'FontSize',8,'Color',[0,1,0]);                                
                    elseif anaresult2.fil_qu(i)<3,
                        text(double(anaresult2.fil_x(i)),double(anaresult2.fil_y(i)),strcat(int2str(anaresult2.fil_wink(i)+180),', Nr: ', int2str(i)),'FontSize',8,'Color',[1,0,0]);
                    else
                        text(double(anaresult2.fil_x(i)),double(anaresult2.fil_y(i)),strcat(int2str(anaresult2.fil_wink(i)),', Nr: ', int2str(i)),'FontSize',8,'Color',[0,0,1]);
                    end
                end
            end
        end
        figure(1);
        colormap(jet(farben)); 
        image(mod(anaresult2.map,farben)); 
        drawnow;   
        if get(handles.checkbox_labeled,'Value'),
            for i=int16(1):anaresult2.fil_nr,
                if anaresult2.fil_gr(i)>0,

                    
                    if anaresult2.fil_qu(i)==0,
                        text(double(anaresult2.fil_x(i)),double(anaresult2.fil_y(i)),strcat(', Nr: ', int2str(i)),'FontSize',8,'Color',[1,1,1]);                                
                    elseif anaresult2.fil_qu(i)<3,
                        text(double(anaresult2.fil_x(i)),double(anaresult2.fil_y(i)),strcat(', Nr: ', int2str(i)),'FontSize',8,'Color',[1,1,1]);
                    else
                        text(double(anaresult2.fil_x(i)),double(anaresult2.fil_y(i)),strcat(', Nr: ', int2str(i)),'FontSize',8,'Color',[1,1,1]);
                    end
                end
            end
        end
        

        k0=k;
        winkel_list(k+anaresult2.fil_nr,1:2)=0;
        for i=int16(1):anaresult2.fil_nr,
            if anaresult2.fil_gr(i)>0,
                if anaresult2.fil_qu(i)==0,
                    
                elseif anaresult2.fil_qu(i)>2,
                    k=k+1;
                    winkel_list(k,1)=anaresult2.fil_wink(i);
                    winkel_list(k,2)=n;
                else
                    k=k+1;
                    winkel_list(k,1)=anaresult2.fil_wink(i)+180;
                    winkel_list(k,2)=n;
                end
            end
        end
        winkel_list=winkel_list(1:k,:);
        
        axes(handles.axes2);
        figure(gcf);
        hist(double(winkel_list(k0+1:k,1)),single(360/delt_wink));

        
        set(handles.edit_framenr,'String',n);
        pause(0.001);
        anaresult1=anaresult2;
        
        button_state = get(hObject,'Value');
        
    end
    

    
    if k>0,        
        figure(2);
        hist3(winkel_list,[single(360/delt_wink), (n-n0)*2]);
    end
    
    set(handles.edit_framenr,'Enable','on');
    set(hObject,'Value',0);
    
    if n+1>anz_frame_mov,
        set(handles.pushbutton_nauf,'Enable','off');
        set(handles.pushbutton_nab,'Enable','on');
    elseif n-1<1,
        set(handles.pushbutton_nab,'Enable','off');
        set(handles.pushbutton_nauf,'Enable','on');
    else
        set(handles.pushbutton_nab,'Enable','on');
        set(handles.pushbutton_nauf,'Enable','on');
    end 
    
end



function listbox1_Callback(hObject, eventdata, handles)
  
    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;
    global anz_frame_mov;
    global is_indexed_mov;

    get(handles.figure1,'SelectionType');
    if strcmp(get(handles.figure1,'SelectionType'),'open')
        index_selected = get(handles.listbox1,'Value');
        file_list = get(handles.listbox1,'String');
        filename = file_list{index_selected};
        if  handles.is_dir(handles.sorted_index(index_selected))
            cd (filename)
            load_listbox(pwd,handles)
        else
            [path,name,ext,ver] = fileparts(filename);
            switch ext
                case '.avi'
                    name_mov1=filename;
                    F=aviinfo(name_mov1),
                    anz_frame_mov=F.NumFrames;
                    if strcmpi(F.ImageType,'indexed')
                        is_indexed_mov=logical(1);
                    else
                        is_indexed_mov=logical(0);
                    end
                    n=1;
                    set(handles.edit_framenr,'String',n);
                    if n+1>anz_frame_mov,
                        set(handles.pushbutton_nauf,'Enable','off');
                        set(handles.pushbutton_nab,'Enable','on');
                    elseif n-1<1,
                        set(handles.pushbutton_nab,'Enable','off');
                        set(handles.pushbutton_nauf,'Enable','on');
                    else
                        set(handles.pushbutton_nab,'Enable','on');
                        set(handles.pushbutton_nauf,'Enable','on');
                    end   
                    makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);
                    
            end
        end
    end

end


function load_listbox(dir_path,handles)
    cd (dir_path)
    dir_struct = dir(dir_path);
    [sorted_names,sorted_index] = sortrows({dir_struct.name}');
    handles.file_names = sorted_names;
    handles.is_dir = [dir_struct.isdir];
    handles.sorted_index = sorted_index;
    guidata(handles.figure1,handles)
    set(handles.listbox1,'String',handles.file_names,...
        'Value',1)
    set(handles.txt_path,'String',pwd)

end


function listbox1_CreateFcn(hObject, eventdata, handles)
   
    usewhitebg = 1;
    if usewhitebg
        set(hObject,'BackgroundColor','white');
    else
        set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
    end

end


function figure1_DeleteFcn(hObject, eventdata, handles)
  
    if isappdata(hObject, 'StartPath')
        rmpath(getappdata(hObject, 'StartPath'));
    end

end

function pushbutton_nauf_CreateFcn(hObject, eventdata, handles)
    global n;
    global anz_frame_mov;
    if n+1>anz_frame_mov, set(hObject,'Enable','off'); end     
end


function pushbutton_nauf_Callback(hObject, eventdata, handles)

    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;
    global anz_frame_mov;
    
    if n+1>anz_frame_mov,
        set(hObject,'Enable','off');
        return;
    elseif n+2>anz_frame_mov,
        set(hObject,'Enable','off');
        n=n+1;
    else,        
        n=n+1;
    end
    if get(handles.pushbutton_nab,'Enable'), set(handles.pushbutton_nab,'Enable','on'), end
    set(handles.edit_framenr,'String',n);

    makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);

end

function pushbutton_nab_CreateFcn(hObject, eventdata, handles)
    global n;    
    if n-1<1, set(hObject,'Enable','off'); end     
end

function pushbutton_nab_Callback(hObject, eventdata, handles)

    global n;
    global min_grau;
    global ana;
    global fil;
    
    global name_mov1;
    global del_sum;
    global delt_wink;
    global anz_frame_mov;
    
    if n-1<1,
        set(hObject,'Enable','off');
        return;
    elseif n-2<1,
        set(hObject,'Enable','off');
        n=n-1;    
    else,
        n=n-1;
    end
    if get(handles.pushbutton_nauf,'Enable'), set(handles.pushbutton_nauf,'Enable','on'), end
    set(handles.edit_framenr,'String',n);

    makepic(name_mov1,n,ana,fil,min_grau,del_sum,delt_wink,handles.axes1,handles.axes2);

end

