function [resultU,resultM] = buyUnit(playerID,uType,sz)
% BUYUNIT - Purchases an Army or Navy and places them in the metropole
arguments
    playerID (1,1) double
    uType (1,1) double
    sz (1,1) double
end

global turn powers remaining units armyBought navyBought totalExpenditure,

% Define purchase costs
if sz == 1
    price = 3;
elseif sz == 3
    price = 10;
elseif sz == 10
    price = 30;
end

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

    add = {unitID pp metro uType sz}; % Compile info
    units = [units;add]; % Add to units table

    % Track money
    remaining(turn,playerID) = remaining(turn,playerID) - price;
    totalExpenditure(turn,playerID) = totalExpenditure(turn,playerID) + price;
    
    % Track military construction and print msg to console
    if uType == 1
        armyBought(turn,playerID) = armyBought(turn,playerID) + price;
        fprintf("\n%s recruits size %d army.\n\n",name,sz);
    else
        navyBought(turn,playerID) = navyBought(turn,playerID) + price;
        fprintf("\n%s constructs size %d navy.\n\n",name,sz);
    end
end

end