%%
clear all
close all
%%
colors = [0 0 0;...
    0.1161    0.7843    0.123;
    0.9970    0.569    0.2199;
    1 0.71 0.71;
    0.810    0.2228    0.9979;
    0.0689    0.6948    0.8394;
    1 1 1;
    0.9970    0.7659    0.2199];
%scatter(1:8,1:8,400,'fill','cdata',colors)

%% format data into computationally useable format

formatdata = 0;
costvskd = 1;
playerkdspread = 0;


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
    
    A = [A , cell(size(A,1),1) ]; %pad A with a rubbish array to make next step easier
    
    
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
    
    for ii = 5:52 %go down rows to cover all players
        
        Team = A{ii,2}; Player = A{ii,3}; Cost = str2double(A{ii,4}(2:end)); Hits = []; Outs=[]; Week = []; GameType = []; Side = []; Result = []; Opponent = [];
        
        jj = 5;
        
        while jj<size(A,2) % go along the columns and store values per game into rows of another matrix
            
            switch char(A(4,jj)) %check what you are looking at
                
                case 'Hits'
                    
                    if ~isempty(A{ii,jj})
                        
                        Hits = A{ii,jj};
                        
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
                    
                case 'W/L' %this is another version of W/L/T that appears in the document
                    
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
            
            if (~strcmp(char(A{2,jj}),char(A{2,jj+1})) && ~isempty(Result)) %switch to new row in the matrix you are copying to when you are done with a game
                %disp(GameType)
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

%% generate cost vs k/d plots

if costvskd == 1 %calculate cost vs kd for team battle games
    
    load('GoodData.mat')
    
    meankds = []; %store all players kds here
    errkds = [];
    costs = [];
    dotcolors = [];
    
    for ii = 1:size(playerlist,1)
        
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
    
    scatter( costs, meankds , 15 , 'fill' ,'MarkerEdgeColor', 'k' , 'MarkerFaceColor' , [0.5 0.5 0.5] )% ,'cdata' , dotcolors  ); %overlay scatte plot
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
        %errorbar(costs(teamplayers),meankds(teamplayers),errkds(teamplayers),'o','Color',usecolor.*[0.8 0.8 0.8],'MarkerEdgeColor', 'k','MarkerFaceColor', usecolor,'MarkerSize',7);
        
        scatter(costs(teamplayers),meankds(teamplayers), 15 , 'fill' ,'MarkerFaceColor' , usecolor ,'MarkerEdgeColor', 'k' );
        
        ylim([0 3])
        xlim([0 180])
        
        
        set(gca,'FontSize',15)
        axis square
        xlabel('Player Cost');
        ylabel('Mean k/d')
        
        title(teamlist{ii,1})
        
        
    end
    
    set(gcf,'Units','Normalized','Position',[0 0 0.5 0.5])
    
    saveas(gcf,'CostvsKD.svg')
    
    fig2plotly(gcf,'offline',true,'filename','CostvsKD','strip',false,'include_plotlyjs',false)
    
end

%% get k/d spread for all players

if playerkdspread == 1
    
    load('GoodData.mat')
    
    meankds = []; %store all players kds here
    dotcolors = [];
    
    
    hold on
    for aa = [0.5:1:49]
        plot( [ aa aa  ],[ 0  3  ] ,'LineStyle' ,'--' ,'Color', [0.8 0.8 0.8]  )
    end
    
    colcount = 0; %indicate team colors
    for aa = [0.5:6:42.5]
        colcount = colcount + 1;
        rectangle( 'Position' , [aa -0.1 6 0.1  ] ,'FaceColor', colors(colcount,:) )
        plot( [ aa aa  ],[ 0  3  ] , 'k'   )
    end
    
    
    
    grid on
    set(gca,'XGrid','off')
    
    for ii = 1:size(playerlist,1)
        
        kds = [];
        oppdotcolors = [];
        
        for jj = 1:size(GD,1)
            
            if strcmp(GD{jj,6},playerlist{ii}) && contains(GD{jj,2},'TB') && ~isempty(GD{jj,8}) && ~isempty(GD{jj,9}) %do this only for team battle games
                
                kds = [kds ; GD{jj,8}/GD{jj,9}]; %get kd
                dotcolor = colors(find(strcmp(teamlist, GD{jj,3})),:); %get dot color
                oppdotcolors = [ oppdotcolors ; colors(find(strcmp(teamlist, GD{jj,4})),:)];%get color of opponent
            end
            
        end
        
        hold on
        
        
        %scatter(ones(numel(kds),1)*ii,kds,200,'fill','MarkerFaceColor',dotcolor,'MarkerEdgeColor','k') %k/ds of players
        scatter(ones(numel(kds),1)*ii + 0.2*(rand(numel(kds),1)-0.5),kds,60,'fill','cdata', oppdotcolors ,'MarkerEdgeColor','k' ) %show color of opponents
        
        
        %
        set(gca,'FontSize',15)
        
        title('k/d spread for team battle mode')
        
        xlim([0 49])
        ylim([-0.1 Inf])
        
    end
    
    
    xticks([1:size(playerlist,1)]-0.5)
    xticklabels(playerlist)
    xtickangle(80)
    set(gcf,'Units','Normalized','Position',[0 0 1 1])
    saveas(gcf,'KDspread.svg')
    
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

