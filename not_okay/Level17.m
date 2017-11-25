%close level selection interface
close all

%define initial velocity, timestep, and coefficient of restitution
coefficient_of_restitution = 1;
timestep = 0.1;
v0 = 1.0;

%set the axis field to 10 x 10
%teal background denotes special level
teal = [46, 155, 219] ./ 256;
fig = figure('Color', teal);
ax = axes();
axis ([0 10 0 10]);
set(ax, 'Color', teal)
set(fig, 'Position', [440 378 500 500])
set(gca,'position',[0 0 1 1],'units','normalized')

%turn off the tick labels
set(gca, 'XTick', [])
set(gca, 'YTick', [])

%define grey color
grey = [179, 182, 188] ./ 256;

%create message box that warns user that the white boxes need to be passed
%through first
%uiwait command makes user hit okay before they can continue playing 
wbim = imread('whiteboxex.png');
uiwait(msgbox({'White boxes need to be activated!'; 'Launch the ball through the shape.'},...
    'Level 17','custom', wbim))

%establish wall positions of walls that need to be activated
%          x1   y1    x2     y2
unact = [  4    4     6      4;...
           6    4     4      6;...
           4    4     4      6];
       
%establish wall positions of regular walls
%          x1   y1    x2     y2
walls = [  4    2     6      2;...
           4    2     4      2.5;...
           6    2     6      2.5;...
           4    2.5   6      2.5;...
           4    7.5   6      7.5;...
           4    7.5   4      8;...
           6    7.5   6      8;...
           4    8     6      8;...
           2    4     2      6;...
           2    4     2.5    4;...
           2    6     2.5    6;...
           2.5  4     2.5    6;...
           7.5  4     7.5    6;...
           7.5  4     8      4;...
           7.5  6     8      6;...
           8    4     8      6];

%plot the walls (indices 1 and 3 are x positions, indices 2 and 4 are y
%positions)
w1 = line(unact(1:3, [1 3])', unact(1:3, [2 4])', 'Color', 'w');
w2 = line(walls(1:4, [1 3])', walls(1:4, [2 4])', 'Color', grey);
w3 = line(walls(5:8, [1 3])', walls(5:8, [2 4])', 'Color', grey);
w4 = line(walls(9:12, [1 3])', walls(9:12, [2 4])', 'Color', grey);
w5 = line(walls(13:16, [1 3])', walls(13:16, [2 4])', 'Color', grey);
%patch the inside of the walls to give appearance of solid shape
shape1 = patch([4 6 4 4], [4 4 6 4], 'w');
shape2 = patch([4 4 6 6 4], [2 2.5 2.5 2 2], grey);
shape3 = patch([4 4 6 6 4], [7.5 8 8 7.5 7.5], grey);
shape4 = patch([2 2 2.5 2.5 2], [4 6 6 4 4], grey);
shape5 = patch([7.5 7.5 8 8 7.5], [4 6 6 4 4], grey);

%select position and launch angle of ball
[x0, y0, launchX, launchY, b_init, arrow] = userSelect([4 6 4 4 NaN 4 4 6 6 4 NaN 4 4 6 6 4 ...
    NaN 2 2 2.5 2.5 2 NaN 7.5 7.5 8 8 7.5], [4 4 6 4 NaN 2 2.5 2.5 2 2 NaN 7.5 8 8 7.5 7.5 ...
    NaN 4 6 6 4 4 NaN 4 6 6 4 4]);

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
        [x0, y0, launchX, launchY, b_init, arrow] = userSelect([4 6 4 4 NaN 4 4 6 6 4 NaN 4 4 6 6 4 ...
            NaN 2 2 2.5 2.5 2 NaN 7.5 7.5 8 8 7.5], [4 4 6 4 NaN 2 2.5 2.5 2 2 NaN 7.5 8 8 7.5 7.5 ...
            NaN 4 6 6 4 4 NaN 4 6 6 4 4]);
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
        
            %if the white shape still exists
            if ishandle(w1) == 1
                %if the ball passes through the white shape
                if ballState(1) > 4 && ballState(1) < -ballState(2) + 10 ...
                        && ballState(2) > 4 && ballState(2) < -ballState(1) +10
                    %set the new shape color to grey ("activate it")
                    set(w1, 'Color', grey)
                    set(shape1, 'FaceColor', grey)
                end
                %once the ball is out of the shape but the shape has been
                %activated
                c = get(w1, 'Color');
                if c{1}(1) == grey(1) && (ballState(1) < 4 || ballState(1) > -ballState(2) + 10 ...
                        || ballState(2) < 4 || ballState(2) > -ballState(1) +10)
                    %add the walls to the walls matrix to test for collision
                    walls(17:19, :) = unact;
                end
            end

            %if the ball collides with the shape (meaning the velocity has
            %changed)
            if ballState(end, 3) ~= oldBallState(end-1, 3) || ballState(end, 4)...
                    ~= oldBallState(end-1, 4)
                %if the ball collided with the first shape
                if (wallCollide(1) == 4 || wallCollide(1) == 6) && ...
                        wallCollide(2) == 4
                    %make the first shape and corresponding walls disappear
                    delete(w1)
                    delete(shape1)
                    walls(17:19, :) = NaN(3,4);
                elseif ((wallCollide(2) == 2 || wallCollide(2) == 2.5)...
                        && (wallCollide(1) == 4 || wallCollide(1) == 6))
                    %make the second shape and corresponding walls disappear
                    delete(w2)
                    delete(shape2)
                    walls(1:4, :) = NaN(4,4);
                elseif (wallCollide(4) == 7.5 || wallCollide(4) == 8 ...
                    && (wallCollide(1) == 4 || wallCollide(1) == 6))
                    %make the second shape and corresponding walls disappear
                    delete(w3)
                    delete(shape3)
                    walls(5:8, :) = NaN(4,4);
                elseif (wallCollide(1) == 2 || wallCollide(1) == 2.5)
                    %make the second shape and corresponding walls disappear
                    delete(w4)
                    delete(shape4)
                    walls(9:12, :) = NaN(4,4);
                elseif (wallCollide(1) == 7.5 || wallCollide(1) == 8)
                    %make the second shape and corresponding walls disappear
                    delete(w5)
                    delete(shape5)
                    walls(13:16, :) = NaN(4,4);
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
WinnerScreen([shape1, shape2, shape3, shape4, shape5], ballState(1), ballState(2),...
    'Level17.m')