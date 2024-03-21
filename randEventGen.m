%% Random Event Generator
% Generates, records, and prints random events for a turn

eventCount = randi(6); % Number of events this turn
n = 0; % Number of events successfully generated

fprintf("\n# %s Headlines #\n*%s Events*\n\n",num2str(year),num2str(eventCount));

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
        
        % Print event to console
        fprintf("%s. **%s**\n   %s\n\n",num2str(n),string(eventPick.event),string(eventPick.desc));

    end

end