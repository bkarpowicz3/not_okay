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

%tell user that ball will return to screen if launched off screen
im = imread('vortexexample.png');
uiwait(msgbox({'If the ball leaves the screen,'; 'it will return on the other side.';...
    'Avoid the vortex!'},'Level 20', 'custom', im))

%establish wall positions
%          x1 y1  x2  y2
walls = [  4  0.5   6   0.5; ...
           4  1.5   6   1.5; ...
           4  0.5   4   1.5; ...
           6  0.5   6   1.5; ...
           4  2.5   6   2.5; ...
           4  3.5   6   3.5; ...
           4  2.5   4   3.5; ...
           6  2.5   6   3.5; ...
           4  6.5   6   6.5; ...
           4  7.5   6   7.5; ...
           4  6.5   4   7.5; ...
           6  6.5   6   7.5;...
           4  8.5   6   8.5; ...
           4  9.5   6   9.5; ...
           4  8.5   4   9.5; ...
           6  8.5   6   9.5;];
       
 vortex = [4  4.5   6   4.5; ...
           4  5.5   6   5.5; ...
           4  4.5   4   5.5; ...
           6  4.5   6   5.5];
       
%plot the walls (indices 1 and 3 are x positions, indices 2 and 4 are y
%positions)
w1 = line(walls(1:4, [1 3])', walls(1:4, [2 4])', 'Color', grey);
w2 = line(walls(5:8, [1 3])', walls(5:8, [2 4])', 'Color', grey);
v = line(vortex(1:4, [1 3])', vortex(1:4, [2 4])', 'Color', 'white');
w4 = line(walls(9:12, [1 3])', walls(9:12, [2 4])', 'Color', grey);
w5 = line(walls(13:16, [1 3])', walls(13:16, [2 4])', 'Color', grey);
%patch the inside of the walls to give appearance of solid shape
shape1 = patch([4 4 6 6 4], [0.5 1.5 1.5 0.5 0.5], grey);
shape2 = patch([4 4 6 6 4], [2.5 3.5 3.5 2.5 2.5], grey);
shape4 = patch([4 4 6 6 4], [6.5 7.5 7.5 6.5 6.5], grey);
shape5 = patch([4 4 6 6 4], [8.5 9.5 9.5 8.5 8.5], grey);

%select position and launch angle of ball
[x0, y0, launchX, launchY, b_init, arrow] = userSelect([4 4 6 6 4 NaN 4 4 6 6 4 NaN 4 4 6 6 4 ...
    NaN 4 4 6 6 4 NaN 4 4 6 6 4], [0.5 1.5 1.5 0.5 0.5 NaN 2.5 3.5 3.5 2.5 2.5 NaN 4.5 5.5 5.5 4.5 4.5 ...
    NaN 6.5 7.5 7.5 6.5 6.5 NaN 8.5 9.5 9.5 8.5 8.5]);

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
        [x0, y0, launchX, launchY, b_init, arrow] = userSelect([4 4 6 6 4 NaN 4 4 6 6 4 NaN 4 4 6 6 4 ...
             NaN 4 4 6 6 4 NaN 4 4 6 6 4], [0.5 1.5 1.5 0.5 0.5 NaN 2.5 3.5 3.5 2.5 2.5 NaN 4.5 5.5 5.5 4.5 4.5 ...
             NaN 6.5 7.5 7.5 6.5 6.5 NaN 8.5 9.5 9.5 8.5 8.5]);
        %break out of the loop
        key = 0;
    elseif key == 32
        %remove the arrow from the plot
        delete(arrow)
        
        %determine components of velocity 
        [vx, vy] = calculateVelocity(v0, x0, y0, launchX, launchY);
        
        %plot initial ball image
        [ballState, oldBallState, trail] = initialPlot(x0, y0, vx, vy);

        %plot a button that calls winner screen so that if the ball is infinitely
        %circling, the user can opt to "lose"
        uhoh = uicontrol('Style', 'pushbutton', 'String', 'Uh oh',...
                    'Units', 'Normalized', 'Position', [.75 .05 .2 .1],...
                    'FontSize', 16);
        set(uhoh, 'Callback', {@LevelBreak, ballState, ...
            [shape1, shape2, shape4, shape5], 'Level20.m'});

        %while the ball is within reasonable bounds of the screen
        while ballState(1) < 11 && ballState(1) > -1 && ballState(2) < 11 ...
                && ballState(2) > -1
           
            %update the plot and the ball states
            [ballState, oldBallState, wallCollide] = updatePlot(ballState, oldBallState,...
            b_init, trail, timestep, walls, coefficient_of_restitution);
            
            %if the ball leaves the screen, make it return on the other
            %side
            if ballState(1) >= 10
                ballState(1) = 0;
            elseif ballState(1) <= 0
                ballState(1) = 10;
            elseif ballState(2) >= 10
                ballState(2) = 0;
            elseif ballState(2) <= 0
                ballState(2) = 10;
            end

            %if the ball is within the bounds of the vortex
            if ballState(1) > 4 && ballState(1) < 6 && ballState(2) < 5.5...
                    && ballState(2) > 4.5
                %ball position breaks while loop
                ballState(1) = 15;
                ballState(2) = -1;
                %ball ceases to move
                ballState(3) = NaN;
                ballState(4) = NaN;
                %ball "disappears" into vortex
                delete(b_init)
            end 
            
            %if the ball collides with the shape (meaning the velocity has
            %changed)
            if ballState(end, 3) ~= oldBallState(end-1, 3) || ballState(end, 4)...
                    ~= oldBallState(end-1, 4)
                %if the ball collided with the first shape
                if (wallCollide(2) == 0.5 || wallCollide(2) == 1.5)
                    %make the first shape and corresponding walls disappear
                    delete(w1)
                    delete(shape1)
                    walls(1:4, :) = NaN(4,4);
                elseif (wallCollide(2) == 2.5 || wallCollide(2) == 3.5)
                    %make the second shape and corresponding walls disappear
                    delete(w2)
                    delete(shape2)
                    walls(5:8, :) = NaN(4,4);
                elseif (wallCollide(2) == 6.5 || wallCollide(2) == 7.5)
                    %make the second shape and corresponding walls disappear
                    delete(w4)
                    delete(shape4)
                    walls(9:12, :) = NaN(4,4);
                elseif (wallCollide(2) == 8.5 || wallCollide(2) == 9.5)
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

%delete push button
delete(uhoh)
%check if level has been won
%if so, display winner screen
WinnerScreen([shape1, shape2, shape4, shape5], ballState(1), ballState(2),...
'Level20.m')