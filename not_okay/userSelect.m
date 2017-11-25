function [x0, y0, launchX, launchY, b_init, arrow] = userSelect(shapeX, shapeY)
%This function prompts the user to select the position of the ball and the
%launch direction and plots an arrow between the two. shapeX and shapeY are
%both vectors indicating the locations of the shapes present in the figure.

%turn on box to guide user to position ball
box on

%use mouse controls to select position of ball
[x0, y0] = ginput(1);

%set ball radius to be .1
ballRadius = .1;

%if user attempts to plot something in the bounds of the shape
while inpolygon(x0+ballRadius, y0+ballRadius, shapeX, shapeY) == 1 || ...
        inpolygon(x0-ballRadius, y0-ballRadius, shapeX, shapeY)
    %play error noise
    beep
    %make user reselect points
    [x0, y0] = ginput(1);
end

%plot the ball at the selected point 
% plot in image so that the radius at the ball so that the radius of the
% ball is known
hold on
% load the image of the blue ball
[ball,~,AlphaData] = imread('blueball.png');
% put that image on axes and create a handle to it
b_init = imagesc([(x0-ballRadius) (x0+ballRadius)],[(y0-ballRadius) (y0+ballRadius)],ball);
% set the alpha data of the image to be the given alpha data so that the
% corners are transparent
set(b_init,'alphadata',AlphaData);
%turn off box to avoid user interpreting box as walls 
box off; axis off

%use mouse controls to select angle of ball launch
[launchX, launchY] = ginput(1);
%calculate distance between two points
dist = [launchX, launchY] - [x0, y0];
%display an arrow from ball to selected point
arrow = quiver(x0, y0, dist(1), dist(2), 0, 'Color', 'k');

end

