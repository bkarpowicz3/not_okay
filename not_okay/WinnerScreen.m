function WinnerScreen(shapes, positionX, positionY, level)
%Detemines if the ball is off the screen and all of the shapes have been
%deleted.  If so, it displays a winner screen. Takes in list of handles of
%graphics of shapes (shapes) and X and Y positions to determine location of
%ball. The level input must be a text string referring to the M-file that
%contains the level script to be rerun.

%if the position is outside the bounds of the 10 x 10 window
if (positionX <= 0 || positionX >= 10) || (positionY <= 0 || positionY >= 10)
    %if all of the shapes have been deleted
    if ishandle(shapes) == zeros(1, length(shapes))
        %read in sound data
        [s, f] = audioread('win.wav');
        %play sound
        sound(s, f)
        %generate a random number 
        n = 3 * rand;
        if n <= 1
            %load in image data
            im = imread('winner1.jpg');
            %display image inside region of game
            image([0 10], [0 10], im)
            %flip axis to correct for image orientation
            set(gca,'YDir','reverse')
        elseif n <= 2
            im = imread('winner2.png');
            image([0 10], [0 10], im)
            set(gca,'YDir','reverse')
        else
            im = imread('winner3.png');
            image([0 10], [0 10], im)
            set(gca,'YDir','reverse')
        end
        %pause for 1 second
        pause(1)
        %close the level screen
        close all
        %relaunch level select menu to allow user to select next level
        run('NotOkayGUI.m')
    else
        %if the level is lost (not all shapes have disappeared)
        %but the ball has still moved off the screen
        %read in sound data
        [s, f] = audioread('lose.wav');
        %play sound
        sound(s, f)
        %clear the figure window and turn it blue
        clf
        set(gcf, 'Color', [.68 .92 1])
        %allow the user to retry the level via a push button
        uicontrol('Style', 'pushbutton', 'String', 'Retry Level',...
            'Units', 'Normalized', 'Position', [.25 .2 .5 .2],...
            'FontSize', 24, 'Callback', {@retryLevel,level});
        %allow user to return to main GUI via push button
        uicontrol('Style', 'pushbutton', 'String', 'Main Menu',...
            'Units', 'Normalized', 'Position', [.25 .6 .5 .2],...
            'FontSize', 24, 'Callback', @returnToMenu);
    end
end
end   

function retryLevel(~,~,level)
%close the level function
close all
%rerun level
run(level)
end

function returnToMenu(~,~)
%close the level function
close all
%open GUI
NotOkayGUI()
end