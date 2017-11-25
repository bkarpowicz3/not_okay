function [vx, vy] = calculateVelocity(v0, x0, y0, launchX, launchY)
%This function takes in the user-selected coordinates and the initial
%velocity of the system and calculates the velocity components in the x and
%y directions according to the user-selected angle.

%launch the ball
%calculate angle in degrees given selected points
theta = atand((launchY - y0)/(launchX - x0));

%calculate vx and vy
vx = v0 * cosd(theta);
vy = v0 * sind(theta);

%account for 360 degree range of possible angles
if launchX < x0
    vy = -vy;
    vx = -vx;
end

end

