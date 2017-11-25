%close level selection interface
close all

%define initial velocity, timestep, and coefficient of restitution
coefficient_of_restitution = 1;
timestep = 0.1;
v0 = 1;

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

%establish wall positions of walls that need to be activated
%          x1   y1    x2     y2
unact = [  4.5  6.5   5.5    4;...
           4.5  6.5   4      6;...
           4    6     5      3.5;...
           5    3.5   5.5    4;...
           6.5  6.5   7.5    4;...
           6.5  6.5   6      6;...
           6    6     7      3.5;...
           7    3.5   7.5    4];
      

%establish wall positions of regular walls
%          x1   y1    x2     y2
 walls = [ 2.5  6.5   3.5    4;...
           2.5  6.5   2      6;...
           2    6     3      3.5;...
           3    3.5   3.5    4;...
           .5   8     .5     8.5;...
           .5   8     9.5    8;...
           .5   8.5   9.5    8.5;...
           9.5  8     9.5    8.5;...
           .5   1.5   .5     2;...
           .5   1.5   9.5    1.5;...
           .5   2     9.5    2;...
           9.5  1.5   9.5    1.5];
       
%plot the walls (indices 1 and 3 are x positions, indices 2 and 4 are y
%positions)
w1 = line(unact(1:4, [1 3])', unact(1:4, [2 4])', 'Color', 'w');
w2 = line(unact(5:8, [1 3])', unact(5:8, [2 4])', 'Color', 'w');
w3 = line(walls(1:4, [1 3])', walls(1:4, [2 4])', 'Color', grey);
w4 = line(walls(5:8, [1 3])', walls(5:8, [2 4])', 'Color', 'k');
w5 = line(walls(9:12, [1 3])', walls(9:12, [2 4])', 'Color', 'k');
%patch the inside of the walls to give appearance of solid shape
shape1 = patch([4.5 5.5 5 4 4.5], [6.5 4 3.5 6 6.5], 'w');
shape2 = patch([6.5 7.5 7 6 6.5], [6.5 4 3.5 6 6.5], 'w');
shape3 = patch([2.5 3.5 3 2 2.5], [6.5 4 3.5 6 6.5], grey);
shape4 = patch([.5 9.5 9.5 .5 .5], [8 8 8.5 8.5 8], 'k');
shape5 = patch([.5 9.5 9.5 .5 .5], [1.5 1.5 2 2 1.5], 'k');

%select position and launch angle of ball
[x0, y0, launchX, launchY, b_init, arrow] = userSelect([4.5 5.5 5 4 4.5 NaN ...
    6.5 7.5 7 6 6.5 NaN 2.5 3.5 3 2 2.5 NaN 2 8 8 2 2 NaN 2 8 8 2 2], ...
    [6.5 4 3.5 6 6.5 NaN 6.5 4 3.5 6 6.5 NaN 6.5 4 3.5 6 6.5 NaN ...
    8 8 8.5 8.5 8 NaN 1.5 1.5 2 2 1.5]);

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
        [x0, y0, launchX, launchY, b_init, arrow] = userSelect([4.5 5.5 5 4 4.5 NaN ...
            6.5 7.5 7 6 6.5 NaN 2.5 3.5 3 2 2.5 NaN .5 9.5 9.5 .5 .5 NaN .5 9.5 9.5 .5 .5], ...
            [6.5 4 3.5 6 6.5 NaN 6.5 4 3.5 6 6.5 NaN 6.5 4 3.5 6 6.5 NaN ...
            8 8 8.5 8.5 8 NaN 1.5 1.5 2 2 1.5]);
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
            [shape1, shape2, shape3, shape4, shape5], 'Level19.m'});
        
        %while the ball is within the bounds of the screen
        while ballState(1) < 10 && ballState(1) > 0 && ballState(2) < 10 ...
                && ballState(2) > 0
            
            %update the plot and the ball states
            [ballState, oldBallState, wallCollide] = updatePlot(ballState, oldBallState,...
            b_init, trail, timestep, walls, coefficient_of_restitution);
        
            %if the first white shape still exists
            if ishandle(w1) == 1
                %if the ball passes through the white shape
                if ballState(1) > (ballState(2) -16)/-2.5 && ...
                        ballState(1) < (ballState(2) - 17.75)/-2.5 ...
                        && ballState(2) > ballState(1) - 1.5 && ...
                        ballState(2) < ballState(1) + 2
                    %set the new shape color to grey ("activate it")
                    set(w1, 'Color', grey)
                    set(shape1, 'FaceColor', grey)
                end
                %once the ball is out of the shape but the shape has been
                %activated
                c = get(w1, 'Color');
                if c{1}(1) == grey(1) && (ballState(1) < (ballState(2) -16)/-2.5 || ...
                        ballState(1) > (ballState(2) - 17.75)/-2.5 ...
                        || ballState(2) < ballState(1) - 1.5 || ...
                        ballState(2) > ballState(1) + 2)
                    %add the walls to the walls matrix to test for collision
                    walls(13:16, :) = unact(1:4, :);
                end
            end
            
            %if the second white shape still exists
            if ishandle(w2) == 1
                %if the ball passes through the white shape
                if ballState(1) > (ballState(2) - 21)/-2.5 &&...
                        ballState(1) < (ballState(2) - 22.75)/-2.5 ...
                        && ballState(2) > ballState(1) - 3.5 &&...
                        ballState(2) < ballState(1)
                    %set the new shape color to grey ("activate it")
                    set(w2, 'Color', grey)
                    set(shape2, 'FaceColor', grey)
                end
                %once the ball is out of the shape but the shape has been
                %activated
                c = get(w2, 'Color');
                if c{1}(1) == grey(1) && (ballState(1) < (ballState(2) - 21)/-2.5 ||...
                        ballState(1) > (ballState(2) - 22.75)/-2.5 ...
                        || ballState(2) < ballState(1) - 3.5 ||...
                        ballState(2) > ballState(1))
                    %add the walls to the walls matrix to test for collision
                    walls(17:20, :) = unact(5:8, :);
                end
            end

            %if the ball collides with the shape (meaning the velocity has
            %changed)
            if ballState(end, 3) ~= oldBallState(end-1, 3) || ballState(end, 4)...
                    ~= oldBallState(end-1, 4)
                %if the ball collided with the first shape
                if (wallCollide(1) == 4.5 || wallCollide(1) == 4 ...
                    || wallCollide(1) == 5) && (wallCollide(2) == 6.5 ...
                    || wallCollide(2) == 6 || wallCollide(2) == 3.5)
                    %make the first shape and corresponding walls disappear
                    delete(w1)
                    delete(shape1)
                    walls(13:16, :) = NaN(4,4);
                elseif (wallCollide(2) == 6 || wallCollide(2) == 6.5 || wallCollide(2) == 3.5)...
                        && (wallCollide(1) == 6.5 || wallCollide(1) == 6 ...
                        || wallCollide(1) == 7)
                    %make the shape and corresponding walls disappear
                    delete(w2)
                    delete(shape2)
                    walls(17:20, :) = NaN(4,4);
                elseif (wallCollide(2) == 6 || wallCollide(2) == 6.5 || wallCollide(2) == 3.5)...
                        && (wallCollide(1) == 2.5 || wallCollide(1) == 2 ...
                        || wallCollide(1) == 3)
                    %make the shape and corresponding walls disappear
                    delete(w3)
                    delete(shape3)
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

%delete push button
delete(uhoh)
%check if level has been won
%if so, display winner screen
WinnerScreen([shape1, shape2, shape3],...
    ballState(1), ballState(2), 'Level19.m')