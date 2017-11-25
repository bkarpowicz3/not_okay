function [ballState, oldBallState, trail] = initialPlot(x0, y0, vx, vy)
%This function takes in the initial position and velocity of the ball and
%performs the initial plotting.  It returns the current ball state and the
%one immediately previous.  It also returns the plot handle for the trail
%of the ball.

%define inital state of ball
%                x y  vx  vy
initialState = [x0 y0 vx  vy];

%define current state as initial state
ballState = initialState;
%define current state as old state
oldBallState = initialState;

%initialize display of the old position of the ball.
trail = plot(oldBallState(1), oldBallState(2), 'k.',...
    'MarkerFaceColor','k');

end

