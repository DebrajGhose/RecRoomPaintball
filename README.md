# Statistics for RecRoom Paintball League Season 5

Data collected by M24 (https://rec.net/user/M24rink).

## Auction draft cost vs. k/d analysis across 8 teams for Team Battle mode 

Error bars (when present) represent standard error of the mean. The dotted black line is a linear fit to the entire cost vs k/d for the entire data set (first graph).

![Cost vs k/d](https://github.com/DebrajGhose/RecRoomPaintball/blob/master/Season%205/CostvsKD.svg)


## k/d spread across all players for Team Battle mode

Rectangle bar colors represent teams. Dot color is what team a player was playing against when they achieved a particular k/d.

![k/ds for each player](https://github.com/DebrajGhose/RecRoomPaintball/blob/master/Season%205/KDspread.svg)

## The "Impact" metric

k/d ratio doesn't capture a player's contribution to the game's outcome. I propose using "Impact", which attempts to use player scores in Team Battle mode to asses how much they affected the game's outcome (I realize that not all player contributions are successfully captured by the scores alone).

Consider the results of a game shown in the figure below.

![Impact metric](https://github.com/DebrajGhose/RecRoomPaintball/blob/master/Metrics/Metric.svg)

In the left subplanel above, two teams of four have their kills and deaths shown per player, respectively.

In the middle subpanel, we plot **normalized kills vs deaths** for each player. Each dot defines a vector from the origin that has a magnitude and angle. The magnitude captures a player's "effect" on the game and the angle tells you if they performed favorably (angle>45) or unfavorably (angle<45).

Intuitively both, Zel and Tir have the same k/d, but Tir clearly contributed more to the game, and that is captured by the magnitudes of their respecive vectors. On the other hand, Tir and Ash contributed heavily to the game's outcome but Tir's perfomance was favorable for his team, while Ash's performance was unfavorable for his team -- this is reflected by the angles of their vectors.

In the third panel, we obtain Impact (I) for each player by muliplying their **vector magnitude** with the **scaled and normalized vector angle**.

Formula (all angles are in degrees):

I = ((k/T)<sup>2</sup> + (d/T)<sup>2</sup>)<sup>0.5</sup>*( tan<sup>-1</sup>(k/d) - 45 )/45.

Here, k is kills, d is deaths, T is all kills + deaths. Note that I goes from -1 to 1.

