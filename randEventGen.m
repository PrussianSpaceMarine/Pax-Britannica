%% Random Event Generator
% Generates, records, and prints random events for a turn

eventCount = randi(6); % Number of events this turn
n = 0; % Number of events successfully generated

fprintf("\n# %s Headlines #\n*%s Events*\n\n",num2str(yr),num2str(eventCount));

while n < eventCount

    % Roll dice
    dice1 = randi(6);
    dice2 = randi(6);
    
    % Pull event
    eventPick = events(events{:,"d1"} == dice1 & events{:,"d2"} == dice2,:);
    eID = eventPick.eID;

    % If the event has not been used this turn, proceed, otherwise ignore and re-roll
    if sum(randomEvents(turn,:) == eID) < 1
        
        % Increment successful events
        n = n + 1;
        
        % Assign to randomEvent history matrix
        randomEvents(turn,n) = eID;
        
        % Unrest rolls
        unrestr1 = randi(6);
        unrestr2 = randi(6);
        if eID >= 31 % Table A
            unrestPick = unrest(unrest{:,"table"} == 1 & unrest{:,"d1"} == unrestr1 & unrest{:,"d2"} == unrestr2,:);
        elseif eID >= 26 % Table B
            unrestPick = unrest(unrest{:,"table"} == 2 & unrest{:,"d1"} == unrestr1 & unrest{:,"d2"} == unrestr2,:);
        elseif eID >= 22 % Table C
            unrestPick = unrest(unrest{:,"table"} == 3 & unrest{:,"d1"} == unrestr1 & unrest{:,"d2"} == unrestr2,:);
        elseif eID >= 20 % Table D
            unrestPick = unrest(unrest{:,"table"} == 4 & unrest{:,"d1"} == unrestr1 & unrest{:,"d2"} == unrestr2,:);
        end

        % Adjust funding multipliers
        affected = eventPick.pID; % pID of affected country
        if affected > 0
            mult = eventPick.fundM; % Funding multiplier
            powers{affected,"fundM"} = powers{affected,"fundM"} * mult;
        end

        resentment(turn) = resentment(turn) + eventPick.CR; % Adjust Chinese Resentment
        tensions(turn) = tensions(turn) + eventPick.ET; % Adjust European Tension
        
        % Print event to console
        if eID >= 20
            fprintf("%s. **%s**\n   %s is in turmoil.\n\n",num2str(n),string(eventPick.event),string(unrestPick.name));
            areas{unrestPick.aID,"unrest"} = 1;
        else
            fprintf("%s. **%s**\n   %s\n\n",num2str(n),string(eventPick.event),string(eventPick.desc));
        end

    end

end