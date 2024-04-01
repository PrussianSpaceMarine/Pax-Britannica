function result = stat(existing,turn)
%% STAT
% Calculates and displays a tracked statistic as of this turn

arguments
    existing (:,:) double
    turn (1,1) double
end

% Globals
global powers area_markers units areas markerTypes yearTicker vpPenalty vpBonus vpBought
statName = inputname(1);

% Filter to powers controlled by a player
playerPowers = powers(powers{:,"player"} == 1,:);

% Remake area_markersJ
area_markersJ = join(join(area_markers,areas,"Keys","aID"),markerTypes,"Keys","mID");

% Begin chart
figure;
tiledlayout(2,1);
nexttile;
rev = zeros(1,height(playerPowers));

for p = 1:height(playerPowers)

    % Identify power
    pp = playerPowers{p,"pID"};
    
    % Depending on which stat is identified as the target, calculate and
    % display current values for all player powers
    switch statName
        case "victoryPoints" % Victory points

            % Divisor
            VPdiv = playerPowers{p,"vpDiv"};
            
            % Established status markers
            f = area_markersJ(area_markersJ{:,"pID"} == pp & area_markersJ{:,"tID"} ~= 6 & area_markersJ{:,"established"} == 1,:);
        
            % Revenue
            rev(p) = sum(f.ev .* f.evM);
        
            % Divide by VP divisor
            rev(p) = rev(p) / VPdiv;
        
            % Apply bonuses/penalties
            existing(turn,p) = rev(p) * 2 - vpPenalty(turn,p) + vpBonus(turn,p) + vpBought(turn,p);

        case "armies" % Number of armies
            existing(turn,p) = sum(units{units{:,"pID"} == pp & units{:,"uType"} == 1,"sz"});
        case "navies" % Number of navies
            existing(turn,p) = sum(units{units{:,"pID"} == pp & units{:,"uType"} == 2,"sz"});
        otherwise
            existing(turn,p) = existing(turn,p); % No change; should be auto-calculated every input
    end

end

%% Bar

% Initial
playerPowers.stat = existing(turn,:)';

% Sort and return correct order
playerPowers = sortrows(playerPowers,"stat","descend");

b = bar(playerPowers.n,playerPowers.stat,0.8,"grouped","yellow");
title(upper(statName) + " - " + string(yearTicker(turn)))
b.FaceColor = 'flat';
grid on;
for bb = 1:height(playerPowers)
    b.CData(bb,:) = hex2rgb(playerPowers{bb,"color"});
end
xlabel("POWERS")
ylabel(upper(statName))

%% Line

nexttile;
xticks(yearTicker);
xlim([1880 1916]);
title(upper(statName) + " - ALL TURNS")
hold on;
playerPowers = sortrows(playerPowers,"pID","ascend");
for bb = 1:height(playerPowers)
    color = playerPowers{bb,"color"};
    c = plot(yearTicker,existing(:,bb),"Color",hex2rgb(color),"LineWidth",4);
end
grid on;
legend([playerPowers{:,"n"}]);
xlabel("YEAR")
ylabel(upper(statName))
hold off;

result = existing;

end