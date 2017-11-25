function helpScreen()
%helpScreen is responsible for showing the images that detail how the game
%plays.  Each step is displayed after the "next" button is hit, and the
%final button closes the help screen and returns to the level selection
%menu.

%make a blue figure and set its position
fig = figure('Color', [.68 .92 1]);
set(fig, 'Position', [440 378 500 500])

%plot the initial text
step1 = {'Using the crosshairs as a guide, click once to place the ball.',...
    'Click again to place the head of the arrow.',...
    'This indicates the direction and launch angle of your ball.'};
txt1 = uicontrol('Style','text','Units', 'Normalized',...
    'Position', [.05 .7 .5 .25],'String', step1, 'BackgroundColor', [.68 .92 1],...
    'FontSize', 16);
%plot the initial gif
axes('Position', [.6 .7 .35 .25])
gifplayer('projectgif1.gif', 0.1)
%plot the initial next push button 
next1 = uicontrol('Style', 'pushbutton', 'String', 'Next',...
            'Units', 'Normalized', 'Position', [.75 .05 .2 .1],...
            'FontSize', 16);
set(next1, 'Callback', {@Next1, next1});

end

function Next1(~, ~, button1)
%delete current button
delete(button1)
%plot new button
next2 = uicontrol('Style', 'pushbutton', 'String', 'Next',...
            'Units', 'Normalized', 'Position', [.75 .05 .2 .1],...
            'FontSize', 16);
set(next2, 'Callback', {@Next2, next2});
%plot still image over the existing gif 
%gifplayer distorts image when it freezes
im = imread('gif1still.png');
imshow(im)
%plot the next set of text
step2 = {'Don''t like your current placement? No problem!',...
    'Press the ''r'' key to reset.',...
    'Then select a new placement and launch angle using the mouse.'};
txt2 = uicontrol('Style','text','Units', 'Normalized',...
    'Position', [.05 .4 .5 .25],'String', step2, 'BackgroundColor', [.68 .92 1],...
    'FontSize', 16);
%plot the gif
axes('Position', [.6 .4 .35 .25])
gifplayer('projectgif2.gif', 0.1)
end

function Next2(~, ~, button2)
%delete current button
delete(button2)
%plot new button to close current figure 
uicontrol('Style', 'pushbutton', 'String', 'Got It!',...
            'Units', 'Normalized', 'Position', [.75 .05 .2 .1],...
            'FontSize', 16, 'Callback', 'close(gcf)');
%plot still image over the existing gif 
%gifplayer distorts image when it freezes
axes('Position', [.6 .4 .35 .25])
im = imread('gif2still.png');
imshow(im)
%plot the next set of text
step3 = 'Press the spacebar to launch!';
uicontrol('Style','text','Units', 'Normalized',...
    'Position', [.05 .35 .5 .05],'String', step3, 'BackgroundColor', [.68 .92 1],...
    'FontSize', 16);
%plot the last gif
axes('Position', [.125 .05 .35 .3])
gifplayer('projectgif3b.gif', 10)
end
