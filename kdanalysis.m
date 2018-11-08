% See how players performed during playoffs
clear all
close all
load('Season3playoffdata.mat');

kd = [];
maxkd = [];
teamname = {};
for h = 1:numel(Players)
    
    name = Players{h};
    
    playerkd = [];
    currmax = 0;
    
    for i = 2:numel(Season3Playoffs(:,1))
        
        if strcmp(name,char(Season3Playoffs(i,4)))
           
            playerkd = [playerkd , Season3Playoffs{i,7}/Season3Playoffs{i,8} ];
            playerteam = char(Season3Playoffs{i,5});
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

figure










