% create the walls of the circle to do an estimation
function walls = circleWalls(radius,centerx,centery)
% choose a theta to rotate
% create a 36-sided polygon
theta = 10; % this is in degrees
% create a vertical line of the correct length using the angle so that the
% endpoints of this line will be the endpoints of the adjacent lines too
x1 = centerx + radius;
y1 = centery + radius*tand(theta/2);
x2 = centerx + radius;
y2 = centery - radius*tand(theta/2);

% use the counterclockwise rotation matrix to create lines
rotmat = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

%initializing walls matrix of zeros
walls = zeros(360/theta,4);
%first wall is vertical wall computed above
walls(1,1:4) = [x1 y1 x2 y2];
%initialize counter
counter = 2;
%for the rest of the walls
for n = 2:size(walls,1)
    %first two coordinates rotated theta degrees
    % must subtract center values and then add after rotation because the
    % rotation matrix is about the center. this shifts the circle about the
    % center for the rotation and then moves it back
    walls(n,1:2) = rotmat*[(walls(n-1,1)-centerx);(walls(n-1,2)-centery)] + [centerx;centery];
    %second two coordinates rotated theta degrees
    walls(n,3:4) = [walls(n-1,1);walls(n-1,2)];
    counter = counter + 1;
end

% visulization so that we can see if it worked
% % % for n = 1:size(walls,1)
% % %     plot(walls(n,1),walls(n,2),'k.')
% % %     hold on
% % %     plot(walls(n,3),walls(n,4),'k.')
% % %     axis equal
% % % end
% % % x = centerx-radius:.01:radius+centerx;
% % % plot(x,sqrt(radius^2-(x-centerx).^2) + centery)
% % %
% % % plot(x,-sqrt(radius^2-(x-centerx).^2) + centery)
% % % plot(x1,y1,'r.','MarkerSize',20)
% % % plot(x2,y2,'g.','MarkerSize',20)
% % % plot(walls(2,1),walls(2,2),'k.','markersize',20)
% % % plot(walls(2,3),walls(2,4),'b.','markersize',20)