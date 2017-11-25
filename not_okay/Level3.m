%close level selection interface
close all

%establish wall positions
%          x1 y1  x2  y2
walls = [  6  1   8   1; ...
           6  3   8   3; ...
           6  1   6   3; ...
           8  1   8   3; ...
           6  7   8   7; ...
           6  9   8   9; ...
           6  7   6   9; ...
           8  7   8   9; ...
           2  4   4   4; ...
           2  6   4   6; ...
           2  4   2   6; ...
           4  4   4   6];

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

%plot the walls (indices 1 and 3 are x positions, indices 2 and 4 are y
%positions)
w1 = line(walls(1:4,[1 3])',walls(1:4,[2 4])', 'Color', grey);
w2 = line(walls(5:8,[1 3])',walls(5:8,[2 4])', 'Color', grey);
w3 = line(walls(9:12,[1 3])',walls(9:12,[2 4])', 'Color', grey);
%patch the inside of the walls to give appearance of solid shape
shape1 = patch([6 8 8 6 6], [1 1 3 3 1], grey);
shape2 = patch([6 8 8 6 6], [7 7 9 9 7], grey);
shape3 = patch([2 4 4 2 2], [4 4 6 6 4], grey);

%select position and launch angle of ball
[x0, y0, launchX, launchY, b_init, arrow] = userSelect([6 8 8 6 6 NaN...
    6 8 8 6 6 NaN 2 4 4 2 2], [1 1 3 3 1 NaN 7 7 9 9 7 NaN 4 4 6 6 4]);

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
        [x0, y0, launchX, launchY, b_init, arrow] = userSelect([6 8 8 6 6 NaN...
    6 8 8 6 6 NaN 2 4 4 2 2], [1 1 3 3 1 NaN 7 7 9 9 7 NaN 4 4 6 6 4]);
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
                if wallCollide(2) == 1 || wallCollide(2) == 3
                %make the first shape and corresponding walls disappear
                    delete(w1)
                    delete(shape1)
                    walls(1:4, :) = NaN(4,4);
                elseif wallCollide(2) == 7 || wallCollide(2) == 9
                %make the second shape and corresponding walls disappear
                    delete(w2)
                    delete(shape2)
                    walls(5:8, :) = NaN(4,4);
                elseif wallCollide(1) == 2 || wallCollide(1) == 4
                    %make the second shape and corresponding walls disappear
                    delete(w3)
                    delete(shape3)
                    walls(9:12, :) = NaN(4,4);
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
WinnerScreen([shape1, shape2, shape3], ballState(1), ballState(2), 'Level3.m')