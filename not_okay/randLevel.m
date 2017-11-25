function randLevel()
%randLevel displays a pop-up menu.  Within this menu, users can select the 
%difficulty level they would like to play.  Using this info, the function 
%generates a random number and uses it to select and launch a level of the
%chosen difficulty.

%drop down menu in dialog box 
%allow user to select one option
[selected,~] = listdlg('ListString', {'Easy', 'Medium', 'Hard', 'Pro'},...
    'SelectionMode', 'single', 'ListSize', [160 100], 'PromptString',...
    'Select a Difficulty','OKString', 'Go!');

%generate a random number from 1 - 5
n = 5 * rand;

%if the option selected is easy
if selected == 1
    %assign a level based on the rounded down random number 
    if floor(n) == 0
        run('Level1.m')
    elseif floor(n) == 1
        run('Level2.m')
    elseif floor(n) == 2
        run('Level3.m')
    elseif floor(n) == 3
        run('Level4.m')
    else
        run('Level5.m')
    end
%if the selected option is medium
elseif selected == 2
    if floor(n) == 0
        run('Level6.m')
    elseif floor(n) == 1
        run('Level6.m')
    elseif floor(n) == 2
        run('Level8.m')
    elseif floor(n) == 3
        run('Level9.m')
    else
        run('Level10.m')
    end
%if the selected option is hard
elseif selected == 3
    if floor(n) == 0
        run('Level11.m')
    elseif floor(n) == 1
        run('Level12.m')
    elseif floor(n) == 2
        run('Level13.m')
    elseif floor(n) == 3
        run('Level14.m')
    else
        run('Level15.m')
    end
%if the selected option is pro
elseif selected == 4
    if floor(n) == 0
        run('Level16.m')
    elseif floor(n) == 1
        run('Level17.m')
    elseif floor(n) == 2
        run('Level18.m')
    elseif floor(n) == 3
        run('Level19.m')
    else
        run('Level20.m')
    end
end
end