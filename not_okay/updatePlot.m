function [ballState, oldBallState, wallCollide] = updatePlot(ballState, oldBallState,...
    b_init, trail, timestep, walls, coefficient_of_restitution)
%This function calls updateBallState to update the plot of the ball.  It
%takes in the handle of the initial plot of the ball b_init, the plot handle of 
%the trail of the ball (trail), the timestep and coefficient of restitution
%parameters, the walls matrix, and the vectors ballState and oldBallState.
%It returns the new ballState and oldBallState reassigned to the same variable names and does
%all plotting following the initial plot.  It also returns the wallCollide
%parameter produced by updateBallState that tells the user which particular
%wall the ball collided with.

%update the ball state
[ballState, wallCollide] = updateBallState(ballState, ...
    timestep, walls, coefficient_of_restitution);

% create the x and y data for the ball based on the ballState and the
% radius
r = .1;
X = [(ballState(1)-r) (ballState(1)+r)];
Y = [(ballState(2)-r) (ballState(2)+r)];

%redraw the ball
set(b_init, 'XData', X);
set(b_init, 'YData', Y);

%draw the path
oldBallState(end+1,:) = ballState;

set(trail, 'XData', oldBallState(:,1));
set(trail, 'YData', oldBallState(:,2));
            
end

