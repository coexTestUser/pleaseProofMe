function [x_out,y_out] = sort_points(xi,yi,ends)

% starting point (arbitrary)

length = size(xi,1);
x_out = zeros(length,1);
y_out = zeros(length,1);

point_mat = zeros(length,3);
point_mat(:,1) = xi;
point_mat(:,2) = yi;


% set starting and end points
for i=1:length
    
%     x = point_mat(i,1),
%     y = point_mat(i,2),
%     ends,
   if point_mat(i,1) == ends(1,2) && point_mat(i,2) == ends(1,1)
        point_mat(i,3) = 1;
        x_out(1) = point_mat(i,1);
        y_out(1) = point_mat(i,2);
   elseif point_mat(i,1) == ends(2,2) && point_mat(i,2) == ends(2,1)
        point_mat(i,3) = 1;
        x_out(length) = point_mat(i,1);
        y_out(length) = point_mat(i,2);   
   end     
end    


% find nearest neighbor and sort accordingly
dist = 100;
index = 0;

for i=1:length-2
    for point = 1:length
        
        if point_mat(point,3) == 0
            cur_dist = sqrt((x_out(i)-point_mat(point,1))^2+(y_out(i)-point_mat(point,2))^2);
            
            cur_dist;
            firstif = 1;
            if (cur_dist < dist)
                dist = cur_dist;
                index = point;
                secondif = 1;
            
            end
        end
        
    end
    if index > 0
    x_out(i+1) = point_mat(index,1);
    y_out(i+1) = point_mat(index,2);
    point_mat(index,3) = 1;
    end
    dist = 100;
    index = 0;
end    


end