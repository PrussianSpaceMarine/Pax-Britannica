%% Administration Calculator
% Calculates finances for player countries

playerPowers = powers(powers.player == 1,:); % Reset player power information

fprintf("# ADMINISTRATION #\n");

for p = 1:length(playerPowers.pID)
    
    pp = playerPowers{p,"pID"};
    empire = area_markers(area_markers{:,"pID"} == pp,:);
    highest = max([empire.mID;0]);

    % Colonial Office Funding
    coLvl = playerPowers{p,"fundLvl"}; % Level for this country
    coRange = funding{:,coLvl}; % Possible rolls
    
    % If the country has no controlled colonies, they automatically take
    % six on their Colonial Office roll
    if highest < 3
        r = 6;
    else
        r = randi(6);
    end

    % Final Colonial Office Revenue
    colonialOffice(turn,p) = coRange(r) * playerPowers{p,"fundM"};
    
    % Filter status markers to this country
    f = area_markersJ(area_markersJ{:,"pID"} == pp,:);

    % Status marker revenue and maintenance
    statusRevenue(turn,p) = sum(f.ev .* f.mID);
    statusUpkeep(turn,p) = sum(f.maint);

    % Final totals
    totalRevenue(turn,p) = statusRevenue(turn,p) + colonialOffice(turn,p);
    totalExpenditure(turn,p) = statusUpkeep(turn,p);

    totalIncome(turn,p) = totalRevenue(turn,p) - totalExpenditure(turn,p);


    %% Print Finances to Console

    fprintf("\n**%s**\n",string(powers{pp,"n"}));
    fprintf("*Revenue:* %d£\n",totalRevenue(turn,p));
    fprintf("- %d£ Colonial Office\n",colonialOffice(turn,p));
    fprintf("- %d£ Foreign Holdings\n",statusRevenue(turn,p));

    fprintf("*Expenditure:* %d£\n",-1*totalExpenditure(turn,p));
    fprintf("- %d£ Foreign Upkeep\n",-1*statusUpkeep(turn,p));

    fprintf("\nTOTAL INCOME: **%d£**\n\n",totalIncome(turn,p));

end