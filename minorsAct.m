%% Minor Colonization
% Minors may attempt to colonize areas of interest to them

% Re-pull minor powers
minors = powers(powers.player == 0 & powers.colonizer == 1,:);
minorCount = length(minors.pID); % Number of minors to roll for

m = 1;
while m <= minorCount

    mm = minors.pID(m); % True minor ID
    
    % If a d6 <= their activity threshold, they attempt to colonize
    % somewhere this turn
    r = randi(6); thresh = minors.minorActive(m);
    % fprintf("Roll %s, max %s",num2str(r),num2str(thresh));
    if r <= thresh

        roll = randi(6) + randi(6); % Dice roll to determine location

        % Pull the table for this power
        t = minorTables(minorTables{:,"pID"} == mm,:);

        % Area they attempt to colonize
        colAttempt = t{t{:,"roll"} == roll,"aID"};
        areaStatus = area_markers(area_markers{:,"aID"} == colAttempt & area_markers{:,"established"} > 0,:);
        a = areas(colAttempt,:);

        % Maximum level established in Area
        highestStatus = max([0 areaStatus.mID']);
        myHighestStatus = max([0 areaStatus{areaStatus{:,"pID"} == mm,"mID"}]);
        
        did = 1;
        if myHighestStatus == 3
            % Possession

            did = 4;
            area_markers{area_markers{:,"aID"} == colAttempt,"mID"} = did;

        elseif highestStatus < 3 && (a.tID < 3 || a.unrest > 0)
            % Protectorate
            
            did = 3;
            add = {colAttempt did mm 0};
            if myHighestStatus > 0
                area_markers(area_markers{:,"aID"} == colAttempt & area_markers{:,"pID"} == mm,:) = add;
            else
                area_markers = [area_markers;add];
            end
        elseif highestStatus < 3
            % Influence

            did = 2;
            add = {colAttempt did mm 0};
            if myHighestStatus > 0
                area_markers(area_markers{:,"aID"} == colAttempt & area_markers{:,"pID"} == mm,:) = add;
            else
                area_markers = [area_markers;add];
            end
        elseif highestStatus < 4
            % Interest

            did = 1;
            dd = {colAttempt did mm 0};
            if myHighestStatus > 0
                area_markers(area_markers{:,"aID"} == colAttempt & area_markers{:,"pID"} == mm,:) = add;
            else
                area_markers = [area_markers;add];
            end
        end
        fprintf("\n%s establishes %s in %s\n",string(minors{m,"n"}),string(markerTypes{did,2}),string(a.name));
    end

    m = m + 1;

end