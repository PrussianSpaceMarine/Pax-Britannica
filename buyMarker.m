function [resultU,resultM] = buyMarker(playerID,mID,aID,pay)
% BUYUNIT - Purchases an Army or Navy and places them in the metropole
arguments
    playerID (1,1) double
    mID (1,1) double
    aID (1,1) double
    pay (1,1) double = 1
end

global turn powers remaining totalExpenditure markerTypes area_markers statusBought areas

% Listed price
price = markerTypes{markerTypes{:,"mID"} == mID,"buy"};

% Any existing markers
existing = area_markers(area_markers{:,"aID"} == aID,:);
thisCountrys = existing(existing{:,"pID"} == playerID,:);
thisMax = max([0 thisCountrys.mID]);

currentInvest = max([0 markerTypes{markerTypes{:,"mID"} == thisMax,"buy"}]);

% Adjusted price
price = price - currentInvest;

% Ensure the player has enough money
if pay == 1 && price > remaining(turn,playerID)
    fprintf("\nERR: Not enough money\n\n");
else
    % Build unit

    p = powers(playerID,:);
    pp = p.pID;
    name = string(p.n);

    add = {aID mID pp 0}; % Compile info

    % Add to list
    area_markers = [area_markers;add];

    if pay == 1
        % Track money
        remaining(turn,playerID) = remaining(turn,playerID) - price;
        totalExpenditure(turn,playerID) = totalExpenditure(turn,playerID) + price;
    
        % Track purchase cost and print msg to console
        statusBought(turn,playerID) = statusBought(turn,playerID) + price;
        fprintf("\n%s pursues %s in %s\n",name,string(markerTypes{mID,2}),string(areas{areas{:,"aID"} == aID,"name"}));
    end
    
end

end