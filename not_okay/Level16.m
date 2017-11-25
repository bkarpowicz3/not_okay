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

%create message box that warns user that the black boxes do not get removed
%from the level 
%uiwait command makes user hit okay before they can continue playing 
bbim = imread('blackboxex.png');
uiwait(msgbox('Black boxes are permanent!', 'Level 16','custom', bbim))

%establish rectangular wall positions
%          x1   y1    x2     y2
walls = [  1.75 2     1.75   8;...
           1.75 2     2      2;...
           2    2     2      8;...
           1.75 8     2      8;...
           8    2     8      8;...
           8    2     8.25   2;...
           8.25 2     8.25   8;...
           8    7     8.25   7;...
           3    2     3      7;...
           3    2     3.25   2;...
           3.25 2     3.25   7;...
           3    7     3.25   7;...
           4.25 3     4.25   8;...
           4.25 3     4.5    3;...
           4.5  3     4.5    8;...
           4.25 8     4.5    8;...
           5.5  2     5.5    7;...
           5.5  2     5.75   2;...
           5.75 2     5.75   7;...
           5.5  7     5.75   7;...
           6.75 3     6.75   8;...
           6.75 3     7      3;...
           6.75 3     7      8;...
           7    8     7      8;...
           2.1  7.5  4.15    7.5;...
           2.1  7.5  2.1     8;...
           2.1  8    4.15    8;...
           4.15 7.5  4.15    8;...
           4.6  7.5  6.65    7.5;...
           4.6  7.5  4.6     8;...
           4.6  8    6.65    8;...
           6.65 7.5  6.65    8;...
           3.35 2    5.4     2;...
           3.35 2    3.35    2.5;...
           3.35 2.5  5.4     2.5;...
           5.4  2    5.4     2.5;...
           5.85 2    7.9     2;...
           5.85 2    5.85    2.5;...
           5.85 2.5  7.9     2.5;...
           7.9  2    7.9     2.5];

%plot the walls (indices 1 and 3 are x positions, indices 2 and 4 are y
%positions)
b1 = line(walls(1:4, [1 3])',walls(1:4, [2 4])', 'Color', 'k');
b2 = line(walls(5:8, [1 3])', walls(5:8, [2 4])', 'Color', 'k');
b3 = line(walls(9:12, [1 3])', walls(9:12, [2 4])', 'Color', 'k');
b4 = line(walls(13:16, [1 3])', walls(13:16, [2 4])', 'Color', 'k');
b5 = line(walls(17:20, [1 3])', walls(17:20, [2 4])', 'Color', 'k');
b6 = line(walls(21:24, [1 3])', walls(21:24, [2 4])', 'Color', 'k');
w1 = line(walls(25:28, [1 3])', walls(25:28, [2 4])', 'Color', grey);
w2 = line(walls(29:32, [1 3])', walls(29:32, [2 4])', 'Color', grey);
w3 = line(walls(33:36, [1 3])', walls(33:36, [2 4])', 'Color', grey);
w4 = line(walls(37:40, [1 3])', walls(37:40, [2 4])', 'Color', grey);
%patch the inside of the walls to give appearance of solid shape
block1 = patch([1.75 1.75 2 2 1.75], [2 8 8 2 2], 'k');
block2 = patch([8 8 8.25 8.25 8], [2 8 8 2 2], 'k');
block3 = patch([3 3 3.25 3.25 3], [2 7 7 2 2], 'k');
block4 = patch([4.25 4.25 4.5 4.5 4.25], [3 8 8 3 3], 'k');
block5 = patch([5.5 5.5 5.75 5.75 5.5], [2 7 7 2 2], 'k');
block6 = patch([6.75 6.75 7 7 6.75], [3 8 8 3 3], 'k');
shape1 = patch([2.1 2.1 4.15 4.15 2.1], [7.5 8 8 7.5 7.5], grey);
shape2 = patch([4.6 4.6 6.65 6.65 4.6], [7.5 8 8 7.5 7.5], grey);
shape3 = patch([3.35 3.35 5.4 5.4 3.35], [2 2.5 2.5 2 2], grey);
shape4 = patch([5.85 5.85 7.9 7.9 5.85], [2 2.5 2.5 2 2], grey);

%select position and launch angle of ball
[x0, y0, launchX, launchY, b_init, arrow] = userSelect([1.75 1.75 2 2 1.75 NaN...
    8 8 8.25 8.25 8 NaN 3 3 3.25 3.25 3 NaN 4.25 4.25 4.5 4.5 4.25 NaN...
    5.5 5.5 5.75 5.75 5.5 NaN 6.75 6.75 7 7 6.75 NaN 2.1 2.1 4.15 4.15 2.1...
    NaN 4.6 4.6 6.65 6.65 4.6 NaN 3.35 3.35 5.4 5.4 3.35 NaN 5.85 5.85 7.9 7.9 5.85],...
    [2 8 8 2 2 NaN 2 8 8 2 2 NaN 2 7 7 2 2 NaN 3 8 8 3 3 NaN 2 7 7 2 2 NaN...
    3 8 8 3 3 NaN 7.5 8 8 7.5 7.5 NaN 7.5 8 8 7.5 7.5 NaN 2 2.5 2.5 2 2 NaN...
    2 2.5 2.5 2 2]);

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
        [x0, y0, launchX, launchY, b_init, arrow] = userSelect([1.75 1.75 2 2 1.75 NaN...
            8 8 8.25 8.25 8 NaN 3 3 3.25 3.25 3 NaN 4.25 4.25 4.5 4.5 4.25 NaN...
            5.5 5.5 5.75 5.75 5.5 NaN 6.75 6.75 7 7 6.75 NaN 2.1 2.1 4.15 4.15 2.1...
            NaN 4.6 4.6 6.65 6.65 4.6 NaN 3.35 3.35 5.4 5.4 3.35 NaN 5.85 5.85 7.9 7.9 5.85],...
            [2 8 8 2 2 NaN 2 8 8 2 2 NaN 2 7 7 2 2 NaN 3 8 8 3 3 NaN 2 7 7 2 2 NaN...
            3 8 8 3 3 NaN 7.5 8 8 7.5 7.5 NaN 7.5 8 8 7.5 7.5 NaN 2 2.5 2.5 2 2 NaN...
            2 2.5 2.5 2 2]);
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
        set(uhoh, 'Callback', {@LevelBreak, ballState, [shape1, shape2,...
            shape3, shape4], 'Level16.m'});
        
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
                if wallCollide(1) == 2.1 || wallCollide(1) == 4.15
                    %make the first shape and corresponding walls disappear
                    delete(w1)
                    delete(shape1)
                    walls(25:28, :) = NaN(4,4);
                elseif (wallCollide(1) == 4.6 || wallCollide(1) == 6.65)
                    %make the second shape and corresponding walls disappear
                    delete(w2)
                    delete(shape2)
                    walls(29:32, :) = NaN(4,4);
                elseif (wallCollide(1) == 3.35 || wallCollide(1) == 5.4)
                    %make the second shape and corresponding walls disappear
                    delete(w3)
                    delete(shape3)
                    walls(33:36, :) = NaN(4,4);
                elseif (wallCollide(1) == 5.85 || wallCollide(1) == 7.9)
                    %make the second shape and corresponding walls disappear
                    delete(w4)
                    delete(shape4)
                    walls(37:40, :) = NaN(4,4);
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
WinnerScreen([shape1, shape2, shape3, shape4], ballState(1), ballState(2),...
    'Level16.m')