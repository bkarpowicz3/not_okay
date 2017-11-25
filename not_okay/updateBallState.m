function [newBallState, wallCollide] = updateBallState(ballState, dt, ...
    walls, coefficient_of_restitution)
%updateBallState computes where the ball should be after the time step dt
%in seconds, taking account collisions with walls.  It determines which, if
%any, walls in the matrix the ball collides with during the simulation interval using
%findCollision.  It returns the new ball state as a vector [x y vx vy]. 

%assume will not hit wall
newBallState(1) = ballState(1) + ballState(3) * dt;
newBallState(2) = ballState(2) + ballState(4) * dt;
newBallState(3:4) = ballState(3:4);

%determine how big the walls matrix is 
rows = size(walls,1);

%create empty lists to store variables
times = zeros(rows, 1);
collisionStates = zeros(rows, 4);

%for every row in walls
for j = 1:rows
    %determine if there will be a collision
    [t, collisionState] = findCollision(ballState, walls(j,:),...
        coefficient_of_restitution);
    %extract all the times
    times(j, 1) = t;
    %extract all the collision states
    collisionStates(j,:) = collisionState;
end

%sort the list of times
[sorted, indices] = sort(times);
%extract minimum time
minT = sorted(1);
%extract index of minimum time
k = indices(1);
     
if walls(k,:) == [1.5 2.5 7.5 8.5]
    b = 0;
end

%if the minimum time is less than the time step with some error 
if minT < dt + eps
    %if the time between two walls is roughly the same (corner)
    if abs(sorted(1) - sorted(2)) < eps
        %position stays the same
        xf = ballState(1);
        yf = ballState(2);
        %velocity updates
        vxf = -coefficient_of_restitution * ballState(3);
        vyf = -coefficient_of_restitution * ballState(4);
        %update ball state
        newBallState = [xf yf vxf vyf];
        oldWallCollide = [walls(k,:); walls(indices(2),:)];     
    else 
        newBallState = collisionStates(k, :);
        oldWallCollide = walls(k, :);
    end
else 
    oldWallCollide = NaN(1,4);
end

%set wallCollide to its most recent value
wallCollide = oldWallCollide;

%determine the amount of time left after the collision
timeleft = dt - minT;

%if the time left is positive
if timeleft > 0
    %update the ball state 
    [newBallState, ~] = updateBallState(newBallState, timeleft, walls,...
            coefficient_of_restitution);
end