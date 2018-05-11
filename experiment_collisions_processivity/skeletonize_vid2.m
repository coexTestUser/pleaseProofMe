

for x=1:length(number)
    y = number(x);
    
    if (y==16)||(y==20)
        name = strcat('traj',num2str(y));
        name_vid_raw = strcat(name,'.tif');
        name_vid_bin = strcat(name,'_BIN.tif');
        name_file = strcat('traj',num2str(y));
    else
        name = strcat('traj',num2str(y));
        name_vid_raw = strcat(name,'.tif');
        name_vid_bin = strcat(name,'_BIN.tif');
        name_file = name;
    end

    cutoff = 50; 
    increm = 1;

    int = 5;
    spline_res = 0.5;


    info = imfinfo(name_vid_raw,'TIFF');
    nmax = numel(info);

    data = struct('length', 0, 'coordinates', [0,0]);
    data = struct('length',0,'coordinates',0,'RealCoordinates',0,'RCSp',0)

    for frame=1:increm:nmax
        CurrentFrame = frame,
   
        raw_pic = imread(name_vid_bin,frame);
        toshow_pic = imread(name_vid_raw,frame);
    
        desp_pic = bwareaopen(raw_pic,cutoff);
    
        figure(1); imshow(raw_pic,[min(raw_pic(:)),max(raw_pic(:))])
    
        [bw,num] = bwlabel(desp_pic);
        filled = regionprops(bw,'ConvexImage');
    
        figure(1); imshow(toshow_pic,[min(toshow_pic(:)),max(toshow_pic(:))]) 
    
        extreme = regionprops(bw,'Extrema');
        
        for k=1:1:num
            xx = extreme(k).('Extrema')(3,2);
            yy = extreme(k).('Extrema')(3,1)+5;
            text(yy,xx,num2str(k),'Color', 'white','FontSize',12);
        end
    
        title 'identified objects'
    
        boxes = regionprops(bw,'BoundingBox');
    
        s1 = size(boxes,1);
    
        dim = floor(sqrt(s1))+1;
        
        for box = 1:s1
            if floor(boxes(box).BoundingBox(1)) ~= 0
                upperx = floor(boxes(box).BoundingBox(1));
            else
                upperx = 1;
            end    
            
            if floor(boxes(box).BoundingBox(2)) ~= 0
                uppery = floor(boxes(box).BoundingBox(2));
            else
                uppery = 1;
            end 
        
            widthx = floor(boxes(box).BoundingBox(3));
            widthy = floor(boxes(box).BoundingBox(4));
        
            curr_pic = raw_pic(uppery:uppery+widthy,upperx:upperx+widthx);
            toshow_curr_pic = toshow_pic(uppery:uppery+widthy,upperx:upperx+widthx);
        
            desp_pic = bwareaopen(curr_pic,cutoff);
            bw = bwlabel(desp_pic);

            BW3 = bwmorph(bw,'thin',Inf);

            [x_coord,y_coord] = find(BW3);

            [xx,yy] = sort_points(x_coord,y_coord,find_skel_ends(BW3));

            values = custome_spline_fit(xx,yy,int,spline_res);

            bild = figure(2);
            subplot(dim,dim,box); 
            imshow(toshow_curr_pic,[min(toshow_curr_pic(:)),max(toshow_curr_pic(:))])
            hold on
            plot(yy,xx)
            plot(values(2,:),values(1,:),'ro')  
            hold off
        
            saveas(bild,strcat(URL,name,'_frame_',num2str(i),'_objects','.png'))
     
            fil_length = contour_length(values);

            s = struct('length',fil_length,'coordinates',values);   %%% if you just need curvature
            data = [data,s];
        
            Coord = [xx+uppery, yy+upperx];
            CoordSpline = [(values(1,:)+uppery).', (values(2,:)+upperx).'];
            ss = struct('length',fil_length,'coordinates',values,'RealCoordinates',Coord,'RCSp',CoordSpline);
            data = [data,ss];
        
        end
   
        saveas(bild,strcat(URL,name,'_frame_',num2str(frame),'_objects','.png'))   
    end

    data(1) = [];
    save (name_file, 'data', 'int', 'spline_res', 'cutoff', 'increm')
    
    clear
    load('EtEnumber.mat');
end





 



