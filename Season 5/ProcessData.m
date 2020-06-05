%%
clear all
close all
load('Datastuff.mat');

A = InputData;

for ii = 4:(size(A,2)-1)
    
    if ~isempty(A{1,ii+1}) %copy game week
        
        Gameweek = A{1,ii+1};
        
    else
        
        A{1,ii+1} = Gameweek;
        
    end
    
    if ~isempty(A{2,ii+1}) %copy game type (e.g. River (TB))
        
        Gametype = A{2,ii+1};
        
    else
        
        A{2,ii+1} = Gametype;
        
    end
    
    if ~isempty(A{3,ii+1}) %copy team color
        
        Gamecolor = A{3,ii+1};
        
    else
        
        A{3,ii+1} = Gamecolor;
        
    end
    
end

GD = cell(100,9); %create Good data cell array
GD{1,1} = 'Week';
GD{1,2} = 'GameType';
GD{1,3} = 'Team';
GD{1,4} = 'Opponent';
GD{1,5} = 'Result';
GD{1,6} = 'Player';
GD{1,7} = 'Cost';
GD{1,8} = 'Hits';
GD{1,9} = 'Outs';
GD{1,10} = 'Side';

GDind = 1; %index for player line

for ii = 5:52
    
    Team = A{ii,2}; Player = A{ii,3}; Cost = str2double(A{ii,4}(2:end)); Hits = []; Outs=[]; Week = []; GameType = []; Side = []; Result = []; Opponent = [];
    
    jj = 5;
    
    while jj<size(A,2)
        
        switch char(A(4,jj))
            
            case 'Hits'
                
                if ~isempty(A{ii,jj})
                    
                    Hits = A{ii,jj};
                    Week = A{1,jj};
                    GameType = A{2,jj};
                    Side = A{3,jj};
                    
                end
                
            case 'Outs'
                
                if ~isempty(A{ii,jj})
                    Outs = A{ii,jj};
                end
                
            case 'W/L/T'
                
                if ~isempty(A{ii,jj})
                    Result = A{ii,jj};
                    Week = A{1,jj};
                    GameType = A{2,jj};
                end
                
            case 'Opponent'
                
                if ~isempty(A{ii,jj})
                    Opponent = A{ii,jj};
                end
        end
        
        if (~strcmp(char(A{2,jj}),char(A{2,jj+1})) && ~isempty(Result)) %switch to new row when you are done with a game
            
            GDind = GDind + 1;
            
            GD(GDind,:) = { Week , GameType, Team, Opponent, Result, Player, Cost, Hits, Outs, Side };
            Hits = []; Week = []; GameType = []; Side = []; Result = []; Opponent = [];
            
        end
        
        jj  = jj+1;
        
    end
end

save('GoodData','GD');

Tab = cell2table(GD);
writetable(Tab,'GoodData.csv')