function [resultU,resultM] = buyStatus(playerID,mType,loc)
% BUYUNIT - Purchases an Army or Navy and places them in the metropole
arguments
    playerID (1,1) double
    mType (1,1) double
    loc (1,1) double
end

global turn powers remaining units armyBought navyBought totalExpenditure,

% Define purchase costs


% Ensure the player has enough money
if price > remaining(turn,playerID)
    fprintf("\nERR: Not enough money\n\n");
else
    % Build unit
    
    p = powers(playerID,:);
    pp = p.pID;
    name = string(p.n);

    unitID = max(units.uID) + 1; % Assign unit ID
    metro = p.aID; % Assign metropole

    add = {unitID pp metro mType loc}; % Compile info
    units = [units;add]; % Add to units table

    % Track money
    remaining(turn,playerID) = remaining(turn,playerID) - price;
    totalExpenditure(turn,playerID) = totalExpenditure(turn,playerID) + price;
    
    % Track military construction and print msg to console
    if mType == 1
        armyBought(turn,playerID) = armyBought(turn,playerID) + price;
        fprintf("\n%s recruits size %d army.\n\n",name,loc);
    else
        navyBought(turn,playerID) = navyBought(turn,playerID) + price;
        fprintf("\n%s constructs size %d navy.\n\n",name,loc);
    end
end

end