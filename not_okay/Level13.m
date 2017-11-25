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

%establish parameters of circles
x1 = 3;
y1 = 7;
r1 = 1;
x2 = 8.5;
y2 = 5;
r2 = 0.5;
x3 = 7;
y3 = 3;
r3 = 1.1;

%plot the circles
[w1, shape1] = circle(x1, y1, r1);
[w2, shape2] = circle(x2, y2, r2);
[w3, shape3] = circle(x3, y3, r3);

%establish rectangular wall positions
%          x1   y1    x2     y2
walls = [  6    7     6      6; ...
           6    7     7      7; ...
           6    6     7      6; ...
           7    7     7      6];
       
%create walls that surround the circles 
circlewalls1 = circleWalls(r1, x1, y1);
%add these walls to the original wall matrix 
walls(end+1:end+length(circlewalls1), :) = circlewalls1;
%create walls that surround the circle 
circlewalls2 = circleWalls(r2, x2, y2);
%add these walls to the original wall matrix 
walls(end+1:end+length(circlewalls2), :) = circlewalls2;
%create walls that surround the circle 
circlewalls3 = circleWalls(r3, x3, y3);
%add these walls to the original wall matrix 
walls(end+1:end+length(circlewalls3), :) = circlewalls3;

%plot the walls (indices 1 and 3 are x positions, indices 2 and 4 are y
%positions)
w4 = line(walls(1:4, [1 3])',walls(1:4, [2 4])', 'Color', grey);
%patch the inside of the walls to give appearance of solid shape
shape4 = patch([6 6 7 7 6], [7 6 6 7 7], grey);

%select position and launch angle of ball
[x0, y0, launchX, launchY, b_init, arrow] = userSelect([6 6 7 7 6 NaN...
    4 2 2 4 4 NaN 8 8 9 9 8 NaN 8.1 5.9 5.9 8.1 8.1], [7 6 6 7 7 NaN 6 6 8 8 6 ...
    NaN 4.5 5.5 5.5 4.5 4.5 NaN 1.9 1.9 4.1 4.1 1.9]);

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
        [x0, y0, launchX, launchY, b_init, arrow] = userSelect([6 6 7 7 6 NaN...
            4 2 2 4 4 NaN 8 8 9 9 8 NaN 8.1 5.9 5.9 8.1 8.1], [7 6 6 7 7 NaN 6 6 8 8 6 ...
            NaN 4.5 5.5 5.5 4.5 4.5 NaN 1.9 1.9 4.1 4.1 1.9]);
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
                %if the ball collided with a circle (whose wall will be the
                %last one in the matrix)
                if ismember(wallCollide, circlewalls1) == 1
                    %if the tangent wall contains the center of the first
                    %circle
                    %make the first shape and corresponding walls disappear
                    delete(w1)
                    delete(shape1)
                    walls(5:4+length(circlewalls1), :) = NaN(length(circlewalls1),4);
                elseif ismember(wallCollide, circlewalls2) == 1
                    %make the second shape and corresponding walls disappear
                    delete(w2)
                    delete(shape2)
                    walls(4+length(circlewalls1):3+length(circlewalls1)...
                        +length(circlewalls2), :) = NaN(length(circlewalls2),4);
                elseif ismember(wallCollide, circlewalls3) == 1
                    %make the second shape and corresponding walls disappear
                    delete(w3)
                    delete(shape3)
                    walls(end+1-length(circlewalls3):end, :) = NaN(length(circlewalls3),4);
                elseif (wallCollide(2) == 6 || wallCollide(2) == 7)
                    %make the second shape and corresponding walls disappear
                    delete(w4)
                    delete(shape4)
                    walls(1:4, :) = NaN(4,4);
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
WinnerScreen([shape1, shape2, shape3, shape4], ballState(1),...
    ballState(2), 'Level13.m')

