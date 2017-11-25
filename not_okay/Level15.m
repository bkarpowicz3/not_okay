%close level selection interface
close all

%define initial velocity, timestep, and coefficient of restitution
coefficient_of_restitution = 1;
timestep = 0.1;
v0 = 1.0;

%set the axis field to 10 x 10
fig = figure('Color', 'white');
axis ([0 10 0 10]);
set(fig, 'Position', [440 378 500 500])
set(gca,'position',[0 0 1 1],'units','normalized')

%turn off the tick labels
set(gca, 'XTick', [])
set(gca, 'YTick', [])

%define grey color
grey = [179, 182, 188] ./ 256;

%establish parameters of circle 
x = 4;
y = 6;
r = 1;

%plot the circle 
[w1, shape1] = circle(x, y, r);

%establish rectangular wall positions
%          x1   y1    x2     y2
walls = [  6    0.5   9.5   0.5;...
           6    0.5   9.5    4;... 
           9.5   4    9.5   0.5;...
           1     2    4      2;...
           1     2    1      3;...
           4     2    4      3;...
           1     3    4      3;...
           9.5   9.5  9.5    6.5;...
           9.5   6.5  6.5    6.5;...
           6.5   6.5  6.5    9.5;...
           6.5   9.5  9.5    9.5];

%create walls that surround the circle 
circlewalls = circleWalls(r, x, y);
%add these walls to the original wall matrix 
walls(end+1:end+length(circlewalls), :) = circlewalls;

%plot the walls (indices 1 and 3 are x positions, indices 2 and 4 are y
%positions)
w2 = line(walls(1:3, [1 3])',walls(1:3, [2 4])', 'Color', grey);
w3 = line(walls(4:7, [1 3])',walls(4:7, [2 4])', 'Color', grey);
w4 = line(walls(8:11, [1 3])',walls(8:11, [2 4])', 'Color', grey);
%patch the inside of the walls to give appearance of solid shape
shape2 = patch([6 9.5 9.5 6], [0.5 4 0.5 0.5], grey);
shape3 = patch([1 1 4 4 1], [2 3 3 2 2], grey);
shape4 = patch([6.5 6.5 9.5 9.5 6.5], [6.5 9.5 9.5 6.5 6.5], grey);

%select position and launch angle of ball
[x0, y0, launchX, launchY, b_init, arrow] = userSelect([2 2 4 4 2 NaN...
    6 9.5 9.5 6 NaN 1 1 4 4 1 NaN 6.5 6.5 9.5 9.5 6.5],...
    [5 7 7 5 5 NaN 0.5 4 0.5 0.5 NaN 2 3 3 2 2 NaN 6.5 9.5 9.5 6.5 6.5]);

%use keyboard commands to reselect current position/angle or to launch ball
%force entry into loops
key = 0;
while key~=1
    waitforbuttonpress
    key=get(fig,'CurrentCharacter');
    if key == 'r'
        %remove the current arrow and ball
        delete(b_init)
        delete(arrow)
        %reset position and angle of ball
        [x0, y0, launchX, launchY, b_init, arrow] = userSelect([2 2 4 4 2 NaN...
            6 9.5 9.5 6 NaN 1 1 4 4 1 NaN 6.5 6.5 9.5 9.5 6.5],...
            [5 7 7 5 5 NaN 0.5 4 0.5 0.5 NaN 2 3 3 2 2 NaN 6.5 9.5 9.5 6.5 6.5]);
        %break out of the loop
        key = 0;
    elseif key == 32
        %remove the arrow from the plot
        delete(arrow)
        
        %determine components of velocity 
        [vx, vy] = calculateVelocity(v0, x0, y0, launchX, launchY);
        
        %plot initial ball image
        [ballState, oldBallState, trail] = initialPlot(x0, y0, vx, vy);
        
        %while the ball is within the bounds of the screen
        while ballState(1) < 10 && ballState(1) > 0 && ballState(2) < 10 ...
                && ballState(2) > 0
            
            %update the plot and the ball states
            [ballState, oldBallState, wallCollide] = updatePlot(ballState, oldBallState,...
            b_init, trail, timestep, walls, coefficient_of_restitution);
            
            %if the ball collides with the shape (meaning the velocity has
            %changed)
            if ballState(end, 3) ~= oldBallState(end-1, 3) || ballState(end, 4)...
                    ~= oldBallState(end-1, 4)
                %if the ball collided with the first shape
                if ismember(wallCollide, circlewalls) == 1
                    %make the first shape and corresponding walls disappear
                    delete(w1)
                    delete(shape1)
                    walls(end+1-length(circlewalls):end, :) = NaN(length(circlewalls),4);
                elseif (wallCollide(2) == 0.5 || wallCollide(2) == 4)
                    %make the second shape and corresponding walls disappear
                    delete(w2)
                    delete(shape2)
                    walls(1:3, :) = NaN(3,4);
                elseif (wallCollide(2) == 2 || wallCollide(2) == 3)
                    %make the second shape and corresponding walls disappear
                    delete(w3)
                    delete(shape3)
                    walls(4:7, :) = NaN(4,4);
                elseif (wallCollide(2) == 6.5 || wallCollide(2) == 9.5)
                    %make the second shape and corresponding walls disappear
                    delete(w4)
                    delete(shape4)
                    walls(8:11, :) = NaN(4,4);
                end
            end
            %pause to produce animation
            pause (0.01);
        end
        %break out of the loop
        key = 1;
    else
        key = 0;
    end
end

%check if level has been won
%if so, display winner screen
WinnerScreen([shape1, shape2, shape3, shape4], ballState(1), ballState(2),...
    'Level15.m')
