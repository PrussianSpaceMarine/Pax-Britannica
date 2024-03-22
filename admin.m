%% Administration Calculator
% Calculates finances for player countries

playerPowers = powers(powers.player == 1,:); % Reset player power information

for p = 1:length(playerPowers.pID)
    
    pp = playerPowers{p,"pID"};

    % Colonial Office Funding
    coLvl = playerPowers{p,"fundLvl"}; % Level for this country
    coRange = funding{:,coLvl}; % Possible rolls
    
    % Final Colonial Office Revenue
    colonialOffice(turn,p) = coRange(randi(6)) * playerPowers{p,"fundM"};
    
    % Filter status markers to this country
    f = area_markersJ(area_markersJ{:,"pID"} == pp,:);

    % Status marker revenue and maintenance
    statusRevenue(turn,p) = sum(f.ev .* f.mID);
    statusUpkeep(turn,p) = sum(f.maint);

    % Final totals
    totalRevenue(turn,p) = statusRevenue(turn,p) + colonialOffice(turn,p);
    totalExpenditure(turn,p) = statusUpkeep(turn,p);

    totalIncome(turn,p) = totalRevenue(turn,p) - totalExpenditure(turn,p);

end