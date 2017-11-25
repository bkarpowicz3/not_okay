function [t,collisionState] = findCollision(ballState, wall,...
    coefficient_of_restitution)
%findCollision determines when the ball will collide with a given wall.
%The ballState variable input is a four-element vector containing the
%current position and velocity of the ball [x y vx vy].  The wall input is
%a four-element row vector that stores the enpoints of the wall as [x1 y1
%x2 y2]. The input coefficient_of_restitution is related to the speed after
%collision and acts on the component of velocity normal to the wall with
%which it collides.

%The output t returns the time at which the collision will occur.  The
%output collisionState outputs the position and velocity of the ball
%after the collision as [x y vx vy].  If the ball does not collide with
%a wall, the output t = Inf and collisionState = [NaN NaN NaN NaN].

%establish initial x and y positions
x = ballState(1);
y = ballState(2);
%establish initial velocities
vx = ballState(3);
vy = ballState(4);

%determine qualities of the wall
x1 = wall(1);
y1 = wall(2);
x2 = wall(3);
y2 = wall(4);
xdiff = abs(x1 - x2);
ydiff = abs(y1 - y2);

%assume there will be no collision
t = Inf;
collisionState = [NaN NaN NaN NaN];

% define the radius of the ball to be 0.1
ballRadius = 0.1;

%if the wall is vertical
if xdiff == 0
    %determine when it would hit the wall and at what y
    % take into account the radius based on which way the collision is
    % happening
    % if the velocity is greater than zero, the collision would be
    % happening from the right, which means the radius must be added to the
    % x position of the ball. This would find the time when the ball is
    % radius distance from the wall
    if vx > 0
        time = (x2 - (x + ballRadius)) / vx;
        % if approaching the wall from the left, the radius must be substracted
        % for the same reasons
    else
        time = (x2 - (x - ballRadius)) / vx;
    end
    ynew = y + vy * time;
    %if the position of the ball will hit the wall in the future
    if time > 0
        %if where it will hit lies on the wall
        if (ynew <= max(y1,y2) + ballRadius) && (ynew >= min(y1,y2) - ballRadius)
            %update vx
            vx2 = -coefficient_of_restitution * vx;
            %update the time
            t = time;
            %update position
            if vx > 0
                xnew = x1 - ballRadius;
            else
                xnew = x1 + ballRadius;
            end
            %update collision state
            collisionState = [xnew ynew vx2 vy];
        end
    end
    %if the wall is horizontal
elseif ydiff == 0
    %determine the position of the ball when it would hit the wall
    % if the ball is hitting the wall from below, find the time when the
    % center of the ball is radius distance away from the wall by adding the radius to
    % the y position
    if vy > 0
        time = (y2 - (y + ballRadius)) / vy;
    else
        % if approaching from above, then subtract the radius from the y
        % position to find when the center of the ball is radius distance
        % from the wall
        time = (y2 - (y - ballRadius)) / vy;
    end
    xnew = x + vx * time;
    %if it will hit the wall in the future
    if time > 0
        %if it will contact the wall within the bounds of the wall
        if (xnew <= max(x1,x2) + ballRadius) && (xnew >= min(x1,x2) - ballRadius)
            %update vy
            vy2 = -coefficient_of_restitution * vy;
            %update time
            t = time;
            %update position
            if vy > 0
                ynew = y1 - ballRadius;
            else
                ynew = y1 + ballRadius;
            end
            ynew = y1;
            %update collision state
            collisionState = [xnew ynew vx vy2];
        end
    end
else
    %if the wall is angled
    %call to the tiltAxis function to shift axes and make it vertical
    [xnew, ynew, vxnew, vynew, time] = tiltAxis(ballState, wall,...
        coefficient_of_restitution);
    %report back time and collision state
    t = time;
    collisionState = [xnew ynew vxnew vynew];
end