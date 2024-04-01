function result = buyMarker(playerID,mID,aID,pay)
% BUYMARKER - Purchases a status marker and places it in the designated
% area.  Auto-establishes if < Prot and no unrest.

arguments
    playerID (1,1) double
    mID (1,1) double
    aID (1,1) double
    pay (1,1) double = 1
end

global turn powers remaining totalExpenditure markerTypes area_markers statusBought areas resentment turn

% Listed price
price = markerTypes{markerTypes{:,"mID"} == mID,"buy"};

% Any existing markers
existing = area_markers(area_markers{:,"aID"} == aID,:);
thisCountrys = existing(existing{:,"pID"} == playerID,:);
thisMax = max([0 thisCountrys.mID]);

% Current maximum status present
maxType = markerTypes(markerTypes{:,"mID"} == thisMax,:);
currentInvest = max([0 maxType.buy]);

% Adjusted price
price = price - currentInvest;

% Ensure the player has enough money
if pay == 1 && price > remaining(turn,playerID)
    fprintf("\nERR: Not enough money\n\n");
else
    % Buy marker

    p = powers(playerID,:);
    pp = p.pID;
    name = string(p.n);

    % Compile info
    if mID < 3 && areas{aID,"unrest"} < 1
        add = {aID mID pp 1}; % If < Prot and no unrest, auto-establish
    else
        add = {aID mID pp 0}; % Otherwise, leave unestablished
    end

    % Is the area part of China or a Chinese Vassal?  If so, increase
    % resentment
    tID = areas{areas{:,"aID"} == aID,"tID"};
    if tID == 2 % Chinese Vassal

        takenResent = max([0 maxType.cvResentPlace]); % Already taken resentment
        resentIncrease = markerTypes{mID,"cvResentPlace"} - takenResent; % Amount to increase
        resentment(turn) = resentment(turn) + resentIncrease; % Write to file

    elseif tID == 3 % Chinese Empire proper

        takenResent = max([0 maxType.cResentPlace]); % Already taken resentment
        resentIncrease = markerTypes{mID,"cResentPlace"} - takenResent; % Amount to increase
        resentment(turn) = resentment(turn) + resentIncrease; % Write to file
        
    end

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