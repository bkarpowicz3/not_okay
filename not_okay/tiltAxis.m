% create a function that tilts the axis and calls on findCollision to
% determine if the new ball state if there is a collision and then
% transforms back to the original coordinates
function [xnew, ynew, vxnew, vynew,time] = ...
    tiltAxis(ballState,wall,coefficient_of_restitution)

% initialize
xnew = NaN;
ynew = NaN;
vxnew = NaN;
vynew = NaN;
time = Inf;

% define the wall coordinates
x1 = wall(1);
y1 = wall(2);
x2 = wall(3);
y2 = wall(4);

% define the position and velocity values of the ball
x0 = ballState(1);
y0 = ballState(2);
vx = ballState(3);
vy = ballState(4);

% determine the angle for the rotation of the wall and the ball's state

% use the rotation matrix to rotate the walls, but must be careful and
% create two cases based on the way that the wall tilts to make sure that
% the y values of the wall will now lie along the y axis. Essentially, all
% of the walls should be rotated so that they are along the vertical axis

% if the wall has a positive slope, it must be rotated counterclockwise
% determine slope of the wall

theta = atan2(x2-x1,y2-y1);

m = (y2-y1)/(x2-x1);
if m > 0
% %     theta = abs(atan((x2-x1)/(y2-y1)));
    rotmat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    rwall1 = rotmat*[x1,y1]';
    rwall2 = rotmat*[x2,y2]';
    rballpos = rotmat*[x0,y0]';
    rballvel = rotmat*[vx,vy]';
    
    % define the rotated wall coordinates
    rx1 = round(rwall1(1), 3);
    ry1 = round(rwall1(2), 3);
    rx2 = round(rwall2(1), 3);
    ry2 = round(rwall2(2), 3);
    % define the rotated position and velocity values of the ball
    rx0 = round(rballpos(1), 3);
    ry0 = round(rballpos(2), 3);
    rvx = round(rballvel(1), 3);
    rvy = round(rballvel(2) ,3);
    
    % now call findCollision. Since my walls are rotated vertically now, we can
    % just use this function to compute the rotated values of position and
    % velocity for the ball
    [t,collisionState] = findCollision([rx0 ry0 rvx rvy],[rx1 ry1 rx2 ry2],...
        coefficient_of_restitution);
    
    % the values in collisionState are rotated, so we must rotate back using
    % the inverse of the rotation matrix computed above for the given wall
    newballpos = rotmat\[collisionState(1) collisionState(2)]';
    newballvel = rotmat\[collisionState(3) collisionState(4)]';
    % define the outputs of the function
    xnew = newballpos(1);
    ynew = newballpos(2);
    vxnew = newballvel(1);
    vynew = newballvel(2);
    time = t;
    
elseif m < 0
    % using the same rotation matrix, if the slope is negative, we need to
    % use a negative theta.
% % %     theta = -abs(atan((x2-x1)/(y2-y1)));
    rotmat = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    rwall1 = rotmat*[x1,y1]';
    rwall2 = rotmat*[x2,y2]';
    rballpos = rotmat*[x0,y0]';
    rballvel = rotmat*[vx,vy]';
    % define the rotated wall coordinates
    rx1 = round(rwall1(1), 3);
    ry1 = round(rwall1(2), 3);
    rx2 = round(rwall2(1), 3);
    ry2 = round(rwall2(2), 3);
    % define the rotated position and velocity values of the ball
    rx0 = round(rballpos(1), 3);
    ry0 = round(rballpos(2), 3);
    rvx = round(rballvel(1), 3);
    rvy = round(rballvel(2), 3);
    
    % now call findCollision. Since my walls are rotated vertically now, we can
    % just use this function to compute the rotated values of position and
    % velocity for the ball
    [t,collisionState] = findCollision([rx0 ry0 rvx rvy],[rx1 ry1 rx2 ry2],...
        coefficient_of_restitution);
    
    % the values in collisionState are rotated, so we must rotate back using
    % the inverse of the rotation matrix computed above for the given wall
    newballpos = rotmat\[collisionState(1) collisionState(2)]';
    newballvel = rotmat\[collisionState(3) collisionState(4)]';
    % define the outputs of the function
    xnew = newballpos(1);
    ynew = newballpos(2);
    vxnew = newballvel(1);
    vynew = newballvel(2);
    time = t;
    
end