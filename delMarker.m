function result = delMarker(playerID,aID)
% DELMARKER - Removes existing status markers in a given area belonging to
% a certain player

arguments
    playerID (1,1) double
    aID (1,1) double
end

global powers area_markers areas

% Power information
p = powers(playerID,:);
name = string(p.n);

% Remove from list
area_markers(area_markers{:,"aID"} == aID & area_markers{:,"pID"} == playerID,:) = [];

% Print msg to console
fprintf("\n%s deletes marker in %s\n",name,string(areas{areas{:,"aID"} == aID,"name"}));

end