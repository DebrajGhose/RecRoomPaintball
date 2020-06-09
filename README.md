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

Consider the results of from a Deathmatch/Team Battle game shown in the following table.

| Team | Name | Kills | Deaths |
|------|------|-------|--------|
| Blue | Zel  | 4     | 1      |
| Blue | Val  | 41    | 32     |
| Blue | Raz  | 20    | 33     |
| Blue | Ash  | 6     | 34     |
| Red  | Ram  | 21    | 23     |
| Red  | Lok  | 12    | 13     |
| Red  | Eli  | 27    | 25     |
| Red  | Tir  | 40    | 10     |

![Impact metric](https://github.com/DebrajGhose/RecRoomPaintball/blob/master/Metrics/Metric.svg)

In the graph on the left, we plot **normalized kills vs deaths** (see equation below) for each player. Each dot defines a vector from the origin that has a magnitude and angle. The magnitude captures a player's "effect" on the game and the angle tells you if they performed favorably (angle>45) or unfavorably (angle<45).

Intuitively, both Zel and Tir have the same k/d, but Tir clearly contributed more to the game. This is captured by the magnitudes of their respecive vectors. On the other hand, Tir and Ash contributed heavily to the game's outcome but Tir's perfomance was favorable for his team, while Ash's performance was unfavorable for his team -- this is reflected by the angles of their respective vectors.

In the graph on the right, we obtain a bar chart for Impact (I) of each player by muliplying their **vector magnitude** with the **scaled and normalized vector angle**.

Formula (all angles are in degrees):

I = ((k/T)<sup>2</sup> + (d/T)<sup>2</sup>)<sup>0.5</sup>*( tan<sup>-1</sup>(k/d) - 45 )/45.

Here, k is kills, d is deaths, T is all kills + deaths (T is used to obtain normalized kills and deaths). Note that I goes from -1 to 1.

