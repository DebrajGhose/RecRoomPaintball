% See how players performed during playoffs
clear all
close all
load('Season3playoffdata.mat');
load('Players.mat');

%spread of all player kds

kd = [];
maxkd = [];
for h = 2:size(Players,1)
    
    name = Players{h};
    
    playerkd = [];
    currmax = 0;
    
    for i = 2:numel(Season3Playoffs(:,1))
        
        if strcmp(name,char(Season3Playoffs(i,4)))
            
            playerkd = [playerkd , Season3Playoffs{i,7}/Season3Playoffs{i,8} ];
            
        end
        
    end
    
    Players{h,4} = playerkd;
    Players{h,5} = mean(playerkd(:));
    Players{h,6} = max(playerkd(:));
    
end

%clean player matrix
i = 1;
while i<size(Players,1)
    
   i = i+1;
    if isempty(cell2mat(Players(i,4))), Players(i,:)=[]; i = i-1; end
    
end


figure

for i = 2:size(Players,1)
    hold on
    
   dotcolor = choosedotcolor(char(Players(i,3)));
   scatter(  i*ones(1,numel(cell2mat(Players(i,4)))),cell2mat(Players(i,4)),'MarkerFaceColor',dotcolor,'MarkerEdgeColor','none');
    
end

xticks(2:size(Players,1))
xticklabels(Players(2:end,1));
set(gca,'TickLabelInterpreter','none');
xtickangle(60)

% generate color matrix

colordots = [];

for i = 2:size(Players,1)
   
    dotcolor = choosedotcolor(char(Players(i,3)));
    colordots = [ colordots ; dotcolor ];
    
end

%cost vs kd graph

figure
scatter(cell2mat(Players(2:end,2)),cell2mat(Players(2:end,5)),30,colordots,'fill');
p = polyfit(cell2mat(Players(2:end,2)),cell2mat(Players(2:end,5)),1);
hold on
plot( cell2mat(Players(2:end,2)) , p(1)*cell2mat(Players(2:end,2)) + p(2));

xlabel('Player Cost'); ylabel('Avg kd');

figure
%cost vs max kd
scatter(cell2mat(Players(2:end,2)),cell2mat(Players(2:end,6)),30,colordots,'fill');
p = polyfit(cell2mat(Players(2:end,2)),cell2mat(Players(2:end,6)),1);
hold on
plot( cell2mat(Players(2:end,2)) , p(1)*cell2mat(Players(2:end,2)) + p(2));

xlabel('Player Cost'); ylabel('Max kd');


function [dotcolor] = choosedotcolor(teamname)


switch teamname
    
    case 'Black'
        dotcolor = [ 0 0 0 ];
    case 'Orange'
        dotcolor = [ 1 0.6 0.2 ];
    case 'Teal'
        dotcolor = [ 0.7 1 1 ];
    case 'Purple'
        dotcolor = [ 0.8 0.4 0.8 ];
    case 'Pink'
        dotcolor = [ 1 0.5 0.5 ];
    case 'Yellow'
        dotcolor = [ 0.9 0.9 0.4 ];
    case 'Green'
        dotcolor = [ 0.5 1 0.5 ];
    case 'White'
        dotcolor = [ 0.5 0.5 0.5 ];
        
end

end
