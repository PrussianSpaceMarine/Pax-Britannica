function [resultU,resultM] = delUnit(uID)
% moveUnit - Moves an army, navy, or merchant fleet from one Area/Zone to another
arguments
    uID (1,1) double
end

global powers units areas,

thisUnit = units(units{:,"uID"} == uID,:); % Pull units with matching ID
pp = thisUnit.pID;
name = string(powers{pp,"n"});

if height(thisUnit) > 1
    fprintf("\nERR: Duplicate Units\n\n");
elseif height(thisUnit) < 1
    fprintf("\nERR: Unit does not exist\n\n");
else
    % Unit type
    if thisUnit.uType == 1
        cat = "army";
    elseif thisUnit.uType == 2
        cat = "navy";
    elseif thisUnit.uType == 3
        cat = "merchant fleet";
    end

    %% Unit exists, delete

    % Valid, now delete!
    units(units{:,"uID"} == uID,:) = [];
    fprintf("\n%s deleted unit %d (strength %d %s)\n\n",name,uID,thisUnit.sz,cat);

end

end