function [resultU,resultM] = moveUnit(uID,destination)
% moveUnit - Moves an army, navy, or merchant fleet from one Area/Zone to another
arguments
    uID (1,1) double
    destination
end

global powers units areas,

thisUnit = units(units{:,"uID"} == uID,:); % Pull units with matching ID
pp = thisUnit.pID;
p = powers(pp,:);
name = string(powers{pp,"n"});

if height(thisUnit) > 1
    fprintf("\nERR: Duplicate Units\n\n");
elseif height(thisUnit) < 1
    fprintf("\nERR: Unit does not exist or belongs to someone else\n\n");
else
    % Unit type
    if thisUnit.uType == 1
        cat = "army";
    elseif thisUnit.uType == 2
        cat = "navy";
    elseif thisUnit.uType == 3
        cat = "merchant fleet";
    end

    %% Unit exists, check for illegal moves

    a = areas(areas{:,"aID"} == destination,:); % Target destination
    metro = p.aID; % This country's metropole
    if a.tID == 6 && metro ~= a.aID
        % Attempting to move into another country's metropole
        fprintf("\nERR: Units cannot enter another country's metropole\n\n");
    elseif a.tID ~= 7 && thisUnit.uType == 3
        % Attempting to move merchant fleet onto land
        fprintf("\nERR: Merchant fleets cannot go onto land\n\n");
    else
        % Valid, now move!
        units{units{:,"uID"} == uID,"aID"} = destination;
        fprintf("\n%s moved unit %d (strength %d %s) to Area %d (%s)\n\n",name,uID,thisUnit.sz,cat,destination,string(a.name));
    end

    % Move unit
end

end