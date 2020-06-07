%%
clear all
close all
%%
colors = [0 0 0;...
     0.2161    0.7843    0.5923;
     0.9970    0.569    0.2199;
     1 0.71 0.71;
     0.810    0.2228    0.9979;
     0.0689    0.6948    0.8394;
     1 1 1;
     0.9970    0.7659    0.2199];
 %scatter(1:8,1:8,400,'fill','cdata',colors)

%%
formatdata = 0;
costvskd = 1;



if formatdata == 1
    
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
    
    [playerlist , maplist , teamlist ] = generate_noun_list(GD); %generate a list of players, teams, maps, etc.
    
    save('GoodData','GD','playerlist','maplist','teamlist');
    
    Tab = cell2table(GD);
    writetable(Tab,'GoodData.csv')
    
end


if costvskd == 1 %calculate cost vs kd for team battle games

    load('GoodData.mat')
    
    meankds = []; %store all players kds here
    errkds = [];
    costs = [];
    dotcolors = [];
    
    for ii = 2:size(playerlist,1)
        
        kds = [];
        
        for jj = 1:size(GD,1)
           
            if strcmp(GD{jj,6},playerlist{ii}) && contains(GD{jj,2},'TB') && ~isempty(GD{jj,8}) && ~isempty(GD{jj,9}) %do this only for team battle games
               
                kds = [kds ; GD{jj,8}/GD{jj,9}]; %get kd
                cost = GD{jj,7}; %get cost
                dotcolor = colors(find(strcmp(teamlist, GD{jj,3})),:); %get dot color
                
            end
            
        end
        
        if ~isempty(kds)
            costs = [costs ; cost];
            dotcolors = [dotcolors ; dotcolor];
            meankds = [meankds; mean(kds)];
            errkds = [errkds , std(kds)/sqrt(numel(kds))];
        end
    end
    
    
    
    
    subplot(3,3,1)
    
    hold on
    pf = polyfit(costs,meankds,1); %do a fit
    
    plot( [min(costs), max(costs)] , [ min(costs)*pf(1) + pf(2) , max(costs)*pf(1) + pf(2) ] , '--k' )
    
    scatter( costs, meankds , 50 , 'fill' ,'cdata' , dotcolors ,'MarkerEdgeColor', 'k' ); %overlay scatte plot
   xlabel('Player Cost');
    ylabel('Mean k/d')
    title('Cost vs k/d (Team Battle)')
    set(gca,'FontSize',15)
    axis square
    
    ylim([0 3])
    xlim([0 180])
    for ii=1:8
        
    subplot(3,3,ii+1)
    hold on
    
    plot( [min(costs), max(costs)] , [ min(costs)*pf(1) + pf(2) , max(costs)*pf(1) + pf(2) ] , '--k' )
    
        teamplayers = ismember(dotcolors,colors(ii,:) ,'row');
        usecolor = dotcolors(find(teamplayers,1),:);
      errorbar(costs(teamplayers),meankds(teamplayers),errkds(teamplayers),'o','Color',usecolor.*[0.8 0.8 0.8],'MarkerEdgeColor', 'k','MarkerFaceColor', usecolor,'MarkerSize',7);
      
        ylim([0 3])
        xlim([0 180])
        
        
        set(gca,'FontSize',15)
        axis square
         xlabel('Player Cost');
    ylabel('Mean k/d')
    
         title(teamlist{ii,1})
    
    end
    
   
    
end

function [playerlist , maplist , teamlist] = generate_noun_list(GD) %generate lists of players, maps, teams, etc.

playerlist = {}; plcount = 1; 
maplist = {}; mcount = 1;
teamlist = {}; tcount = 1;

for ii = 2:size(GD,1)
    
    playername = GD{ii,6};
    if ~any(strcmp( playerlist,playername ))
        
        playerlist{plcount,1} = playername;
        plcount = plcount + 1;
        
    end
    
    mapname = GD{ii,2};
    if ~any(strcmp( maplist,mapname ))
        
        maplist{mcount,1} = mapname;
        mcount = mcount + 1;
        
    end
    
    teamname = GD{ii,3};
    if ~any(strcmp( teamlist,teamname ))
        
        teamlist{tcount,1} = teamname;
        tcount = tcount + 1;
        
    end
    
end

end

