%% Administration Calculator
% Calculates finances for player countries

playerPowers = powers(powers.player == 1,:); % Reset player power information

fprintf("# ADMINISTRATION #\n");

for p = 1:length(playerPowers.pID)

    pp = playerPowers{p,"pID"};
    empire = area_markersJ(area_markersJ{:,"pID"} == pp & area_markersJ{:,"tID"} ~= 6,:);
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
    f = area_markersJ(area_markersJ{:,"pID"} == pp & area_markersJ{:,"tID"} ~= 6,:);
    
    % Filter units to this country
    u = units(units{:,"pID"} == pp,:);
    u = join(u,areas,"Keys","aID"); % Combine with area information
    u = u(u{:,"uType"} < 3 & u{:,"tID"} ~= 6,:); % Filter to units they must actually pay for
    u = join(u,area_markers(area_markers{:,"pID"} == pp,:),"Keys","aID","KeepOneCopy","pID"); % Combine with marker info
    u = u(u{:,"mID"} < 5,:); % Exclude dominions/states

    % Army Upkeep
    armyUpkeep(turn,p) = sum(u{u{:,"uType"} == 1,"sz"});

    % Navy Upkeep
    navyUpkeep(turn,p) = sum(u{u{:,"uType"} == 2,"sz"});

    % Status marker revenue and maintenance
    statusRevenue(turn,p) = sum(f.ev .* f.evM);
    statusUpkeep(turn,p) = sum(f.maint);

    % Final totals
    totalRevenue(turn,p) = statusRevenue(turn,p) + colonialOffice(turn,p);
    totalExpenditure(turn,p) = statusUpkeep(turn,p) + armyUpkeep(turn,p) + navyUpkeep(turn,p);

    spendable(turn,p) = totalRevenue(turn,p) - totalExpenditure(turn,p);
    remaining(turn,p) = spendable(turn,p);


    %% Print Finances to Console

    fprintf("\n**%s**\n",string(powers{pp,"n"}));
    fprintf("*Revenue:* %d£\n",totalRevenue(turn,p));
    fprintf("- %d£ Colonial Office\n",colonialOffice(turn,p));
    fprintf("- %d£ Foreign Holdings\n",statusRevenue(turn,p));

    fprintf("*Expenditure:* %d£\n",-1*totalExpenditure(turn,p));
    fprintf("- %d£ Holdings Upkeep\n",-1*statusUpkeep(turn,p));
    fprintf("- %d£ Army Supplies\n",-1*armyUpkeep(turn,p));
    fprintf("- %d£ Naval Supplies\n",-1*navyUpkeep(turn,p));

    fprintf("\nTOTAL INCOME: **%d£**\n\n",spendable(turn,p));

end