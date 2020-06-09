%% Contribution graph

close all
clear all

mecolors = parula(8);

set(gcf,'Renderer','Painters')
set(groot,'defaultAxesColorOrder', mecolors([3,5,7,4],:) )

TeamAkd = [ 40 27 12 21 ; 10 25 13 23  ]; 

TeamBkd = [ 6 20 41 4 ; 34 33 32 1 ];

TeamABnames = {'Tir','Eli','Lok','Ram',...
    'Ash','Raz','Val','Zel'};

Tot = sum(TeamAkd(:));

TeamAnorm = TeamAkd/Tot;

TeamBnorm = TeamBkd/Tot;

figure



subplot(1,2,1)

hold on

plot([ 0 1 ],[ 0 1 ] , '--k')

scatter( TeamAnorm(2,:) , TeamAnorm(1,:) ,100,'fill' );
scatter( TeamBnorm(2,:) , TeamBnorm(1,:) ,100,'fill' );
axis equal

text( 0.009 + [TeamAnorm(2,:) , TeamBnorm(2,:)] ,  [TeamAnorm(1,:) , TeamBnorm(1,:)] , TeamABnames , 'FontSize', 10  )


draw_arrow(  [0 0] , [ TeamAnorm(2,1)  TeamAnorm(1,1)] )
draw_arrow(  [0 0] , [ TeamBnorm(2,4)  TeamBnorm(1,4)] )

draw_arrow(  [0 0] , [ TeamBnorm(2,1)  TeamBnorm(1,1)] )

%plot( [0 TeamAnorm(2,1)],[ 0 TeamAnorm(1,1)]  )

%plot( [0 TeamBnorm(2,4)],[ 0 TeamBnorm(1,4)]  )



legend('45 degree line','Team A','Team B')

grid on


ylim([-0.04 0.3])
xlim([-0.04 0.3])

xlabel('Normalized Deaths')
ylabel('Normalized Kills')

set(gca,'FontSize',10)



%%
subplot(1,2,2)


[ teamts , teamrs ] = cart2pol( [ TeamAnorm(2,:) , TeamBnorm(2,:)   ]' , [ TeamAnorm(1,:) , TeamBnorm(1,:)   ]'      );

teamts = (teamts - pi/4)/(pi/4);

bar( teamts.*teamrs*100 );
axis square

ylabel('Impact')

xticklabels(TeamABnames)
xtickangle(70)
set(gca,'FontSize',10)


function [] = draw_arrow(a,b)

d  = b - a;

quiver(a(1),a(2),d(1),d(2),0,'Color','k')


end
