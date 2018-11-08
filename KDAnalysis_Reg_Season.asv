% See how players performed during playoffs
clear all
close all
load('Season3regseasondata.mat');

kd = [];
maxkd = [];
teamname = {};
for h = 1:numel(Players)
    
    name = Players{h};
    
    playerkd = [];
    currmax = 0;
    
    for i = 2:numel(Season3RegSeason(:,1))
        
        if strcmp(name,char(Season3RegSeason(i,4)))
            
            playerkd = [playerkd , Season3RegSeason{i,7}/Season3RegSeason{i,8} ];
            playerteam = char(Season3RegSeason{i,5});
        end
        
    end
    
    kd = [ kd ; mean(playerkd)];
    maxkd = [maxkd ; max(playerkd(:))];
    teamname{h} = playerteam;
    
    hold on
    scatter(h*ones(1,numel(playerkd)),playerkd ,'fill');
    
end

xticks(1:numel(Players))
xticklabels(Players);
xtickangle(60)

%arrange everything

Playerdata = {};

for i = 1:numel(Players)
    
    Playerdata{i,1} = Players{i};
    Playerdata{i,2} = kd(i);
    Playerdata{i,3} = maxkd(i);
    Playerdata{i,4} = teamname{i};
    
end

figure

%Carriers

Teamdata = {};

for i = 1:numel(Teams)
    
    players = {};
    kds = [];
    
    for j = 1:size(Playerdata,1)
        
        if strcmp(Teams{i},char(Playerdata{j,4}))
            
            players = [players, char(Playerdata{j,1}) ];
            kds = [kds , Playerdata{j,2} ]
            
        end
        
    end
    
    Teamdata{i,1} = Teams{i};
    Teamdata{i,2} = players;
    Teamdata{i,3} = kds/(max(kds(:)));
    
    hold on
    scatter( i*ones(1,numel(Teamdata{i,3})) , Teamdata{i,3} , 'fill' );
    text(0.1+i*ones(1,numel(Teamdata{i,3})) , Teamdata{i,3}, players )
    
end

xticks(1:size(Teams,1))
xticklabels(Teams);
xtickangle(60);

xlim([0 9])


