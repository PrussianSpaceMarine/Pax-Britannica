function result = info(area,activateDisplay)
%% INFO - Displays information about an Area and all units contained therein
% If an area ID is entered, returns its name.  If a name is entered, returns the corresponding aID.

arguments
    area (1,1)
    activateDisplay (1,1) double = 1
end

% Globals
global areas areaTypes area_markers adj coast markerTypes powers units

% Find Area in list
if ~isnumeric(area)
    a = areas(string(areas{:,"name"}) == area,:);
    result = a.aID;
else
    a = areas(areas{:,"aID"} == area,:);
    result = string(a.name);
end

if height(a) < 1
    fprintf("ERR: Area does not exist\n\n");
    result = NaN;
elseif height(a) > 1
    fprintf("ERR: Area is not unique\n\n");
    result = NaN;
elseif activateDisplay == 1
    %% Look up and Display Information

    % Basic information
    fprintf("\nArea %d: %s\n   EV: %d, CS: %d\n",a.aID,string(a.name),a.ev,a.cs);

    % Type
    t = a.tID;
    type = string(areaTypes{areaTypes{:,"tID"} == t,"type"});
    fprintf("   %s Area\n",type);

    % Unrest
    if a.unrest == 1
        fprintf("   Area is in Unrest!\n");
    end

    % Status Markers
    markers = area_markers(area_markers{:,"aID"} == a.aID,:);
    if height(markers) > 0
        for j = 1:height(markers)

            % Pull marker type
            mt = string(markerTypes{markerTypes{:,"mID"} == markers{j,"mID"},"marker"});

            % Pull power
            p = string(powers{powers{:,"pID"} == markers{j,"pID"},"n"});

            % Establishment
            if markers{j,"established"} == 0
                fprintf("\n%s of %s - UNESTABLISHED",mt,p); % Print
            else
                fprintf("\n%s of %s",mt,p); % Print
            end
            

        end
    else
        fprintf("\nAs-yet unpillaged by foreign powers!")
    end
    fprintf("\n");

    % Adjacency
    connections = adj(adj{:,"aID"} == a.aID | adj{:,"to"} == a.aID,:);
    if height(connections) > 0
        fprintf("\nADJACENT TO:\n")
        for j = 1:height(connections)
            
            % Pull whichever of the connection pair IS NOT the display info
            if connections{j,"aID"} == a.aID
                nextTo = connections{j,"to"};
            else
                nextTo = connections{j,"aID"};
            end
    
            % Pull name of adjacent Area
            nextToName = string(areas{areas{:,"aID"} == nextTo,"name"});
            fprintf("   %s\n",nextToName); % Display
    
        end
    elseif a.tID == 7
    else
        fprintf("\nAdjacent to nothing\n");
    end

    % Coasts
    aCoasts = coast(coast{:,"aID"} == a.aID,:);
    if height(aCoasts) > 0
        if a.tID == 7
            fprintf("\nCONNECTS TO:\n")
        else
            fprintf("\nPORTS ON:\n");
        end
        for j = 1:height(aCoasts)
            
            % Pull coast
            nextTo = aCoasts{j,"sea"};
    
            % Pull name of coast
            nextToName = string(areas{areas{:,"aID"} == nextTo,"name"});
            fprintf("   The %s\n",nextToName); % Display
    
        end
    else
        fprintf("\nHas no ports\n");
    end

    % Military Units
    u = units(units{:,"aID"} == a.aID,:);
    if height(u) > 0
        fprintf("\nMilitary Presence:\n")
        for uu = 1:height(u)
            
            % Power
            p = string(powers{powers{:,"pID"} == u{uu,"pID"},"n"});

            % Type
            if u{uu,"uType"} == 1
                type = "Army";
            elseif u{uu,"uType"} == 2
                type = "Navy";
            elseif u{uu,"uType"} == 3
                type = "Merchant Fleet";
            end

            % Print
            if type == "Merchant Fleet"
                fprintf("   Unit ID %d - %s %s\n",u{uu,"uID"},p,type);
            else
                fprintf("   Unit ID %d - %s size %d %s\n",u{uu,"uID"},p,u{uu,"sz"},type);
            end

        end
        
    else
        fprintf("\nNo foreign military presence\n\n");
    end

end

end