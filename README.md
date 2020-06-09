# Statistics for RecRoom Paintball League Season 5

Data collected by M24 (https://rec.net/user/M24rink).

## Auction draft cost vs. k/d analysis across 8 teams for Team Battle mode 

Error bars (when present) represent standard error of the mean. The dotted black line is a linear fit to the entire cost vs k/d for the entire data set (first graph).

![Cost vs k/d](https://github.com/DebrajGhose/RecRoomPaintball/blob/master/Season%205/CostvsKD.svg)


## k/d spread across all players for Team Battle mode

Rectangle bar colors represent teams. Dot color is what team a player was playing against when they achieved a particular k/d.

![k/ds for each player](https://github.com/DebrajGhose/RecRoomPaintball/blob/master/Season%205/KDspread.svg)

## The "Impact" metric

Kills/Deaths (k/d) ratio doesn't capture a player's contribution to the game's outcome. For example, consider results from the following deathmatch game.

| Team | Name | Kills | Deaths |
|------|------|-------|--------|
| A    | Zel  | 4     | 1      |
| A    | Val  | 41    | 32     |
| A    | Raz  | 20    | 33     |
| A    | Ash  | 6     | 34     |
| B    | Ram  | 21    | 23     |
| B    | Lok  | 12    | 13     |
| B    | Eli  | 27    | 25     |
| B    | Tir  | 40    | 10     |

Both Tir and Zel have a k/d of 4, but the magnitude of scores suggest that Tir might have had a bigger influence on the game's outcome. Thus, I propose using a new metric called *"Impact"*, which attempts to use player scores in Team Battle mode to assess how much they affected a game's outcome (I realize that not all player contributions are successfully captured by the scores alone).

Let's plot these results.

![Impact metric](https://github.com/DebrajGhose/RecRoomPaintball/blob/master/Metrics/Metric.svg)

In the graph on the left, we plot **normalized kills vs deaths** (see equation below) for each player. Each dot defines a vector from the origin that has a magnitude and angle. The magnitude captures a player's "effect" on the game and the angle tells you if they performed favorably (angle>45) or unfavorably (angle<45).

Zel and Tir have the same k/d, but Tir likely had a bigger influence on the game's outcome. This is captured by the difference in magnitudes of their respecive vectors. On the other hand, Tir and Ash contributed heavily to the game's outcome but Tir's perfomance was favorable for his team, while Ash's performance was unfavorable for his team -- this is reflected by the anglular distacnes of their respective vectors from the 45 degree line.

In the graph on the right, we obtain a bar chart for **Impact (I)** of each player by muliplying their **vector magnitude** with a **scaled and normalized vector angle** and scaling it to be between -100 to 100. A score of 100 would mean the player on the winning team got all the kills and died 0 times. A score of -100 would mean the player on the losing team got recieved every kill and achieved 0 kills.

Calculating Impact (all angles are in degrees):

1. For each player, find normalized **kills (k)** and **deaths (d)** by dividing both numbers by **total kills and deaths (T)**. Normalized kills = k/T. Normalized deaths = d/T. E.g. Tir's normalized kills = 40/171 and normalized deaths = 10/171.

2. Find **resultant vector (R)** and **normalized angle from 45 degrees (t)**. R =  ((k/T)<sup>2</sup> + (d/T)<sup>2</sup>)<sup>0.5</sup>. t = ( tan<sup>-1</sup>(k/d) - 45 )/45.

3. Calculate Impact. I = 100Rt.  Expanded formula for impact is I = 100((k/T)<sup>2</sup> + (d/T)<sup>2</sup>)<sup>0.5</sup>( tan<sup>-1</sup>(k/d) - 45 )/45.
