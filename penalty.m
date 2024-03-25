function result = penalty(playerID,number)
% BONUS - Gives bonus VPs to a player
arguments
    playerID (1,1) double
    number (1,1) double
end

%Globals
global turn powers vpPenalty

% Pull name
name = string(powers{powers{:,"pID"} == playerID,"n"});

% Print msg and write to bonus tracker
fprintf("\n%s penalized %d Victory Points\n\n",name,number);
vpPenalty(turn,playerID) = vpPenalty(turn,playerID) + number;
result = 1;

end