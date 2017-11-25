function [ballState] = LevelBreak(~, ~, ballState, shapes, level)
%Callback of push button in Level 19 that breaks the reoccuring cycle of
%the ball returning to the screen if the user feels that the level is lost.

%ball position breaks while loop
ballState(1) = 15;
ballState(2) = -5;
%ball ceases to move
ballState(3) = NaN;
ballState(4) = NaN;

%call winner screen function, prompt losing screen options to appear
WinnerScreen(shapes, ballState(1), ballState(2),...
level)
end