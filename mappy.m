%% Draws maps
% Mappy is my best friend

close all

global areas areaTypes area_markers units adj coast

figure
hold on

xlim([0 18])
ylim([0 13])
pbaspect([18 13 1])

%% Lines and Adjacency
for a = 1:height(areas)
    ar = areas(a,:);
    aY = 13-ar.x;
    aX = ar.y;
    
    % Pull adjacent Areas
    aa = adj(adj{:,"aID"} == ar.aID,:);
    for aaa = 1:height(aa)
        aN = aa{aaa,"to"}; % Area being drawn

        % Its coordinates
        aNX = areas{aN,"y"};
        aNY = 13 - areas{aN,"x"};
        
        % Draw a line
        if aa.type == 1 % Land adjacency
            plot([aX aNX], [aY aNY],'LineWidth',2,'Color',[0 0 0]);
        end
    end
end

%% Coastal
for a = 1:height(areas)
    ar = areas(a,:);
    aY = 13-ar.x;
    aX = ar.y;

    % Pull connected Sea Zones
    aa = coast(coast{:,"aID"} == ar.aID,:);
    for aaa = 1:height(aa)
        aN = aa{aaa,"sea"}; % Sea connection
        
        % Its color
        aNColor = areas{aN,"specialColor"};

        % Add box
        text(aX - 0.2 + 0.1 * aaa,aY - 0.15," ","FontSize",6,"FontWeight","bold",'EdgeColor',[0 0 0],"BackgroundColor",hex2rgb(aNColor),Clipping='on');
    end
end


%% Area and Sea Zone Boxes

for a = 1:height(areas)
    ar = areas(a,:);
    aY = 13-ar.x;
    aX = ar.y;
    boxColor = string(areaTypes{ar.tID,"color"});
    specialColor = string(ar.specialColor);

    % annotation("textbox",[aX/18 aY/13 0.5/18 0.5/13],'String',{string(areas{a,"name"}),"£"+string(areas{a,"ev"})+"     "+string(areas{a,"cs"})})
    % annotation("textbox",[aX/18 aY/13 0.05 0.05],'String',{string(areas{a,"name"}),"£"+string(areas{a,"ev"})+"     "+string(areas{a,"cs"})},'FitBoxToText','on')
    % rectangle('Position',[aX aY 0.3 0.3]);
    % text(aX+0.35, aY+0.15, {string(areas{a,"name"}),"£"+string(areas{a,"ev"})+"     "+string(areas{a,"cs"})},"FontSize",6,"FontWeight","bold",'EdgeColor',[0 0 0])
    if ar.tID == 6 % Metropole
        text(aX, aY, string(ar.name),"FontSize",6.5,"FontWeight","bold",'EdgeColor',[0 0 0],'HorizontalAlignment','center',Clipping='on',BackgroundColor=specialColor)
    elseif ar.tID == 7 % Sea Zones
        text(aX, aY, string(ar.name),"FontSize",7,"FontWeight","bold",'EdgeColor',[0 0 0],'HorizontalAlignment','center',Clipping='on',BackgroundColor=specialColor)
    else % All others
        text(aX, aY, {string(ar.name),"£"+string(ar.ev)+"    "+string(ar.cs)},"FontSize",5.5,"FontWeight","bold",'EdgeColor',[0 0 0],'HorizontalAlignment','center',Clipping='on',BackgroundColor=boxColor)
    end


    %% Status Markers and Units
    m = sortrows(area_markers(area_markers{:,"aID"} == a,:),["mID" "pID"],["descend" "ascend"]);
    
    for c = 1:height(m)

        % Owner and color
        owner = m{c,"pID"};
        color = powers{powers{:,"pID"} == owner,"color"};

        % Border Styles
        if m{c,"established"} == 1
            bStyle = "-";
        else
            bStyle = ":";
        end
    
        % Symbol
        if m{c,"mID"} == 1
            symbol = ".";
        elseif m{c,"mID"} == 2
            symbol = "-";
        elseif m{c,"mID"} == 3
            symbol = "o";
        elseif m{c,"mID"} == 4
            symbol = "#";
        elseif m{c,"mID"} == 5
            symbol = "><";
        end

        mil = "";
        thisCountrys = units(units{:,"pID"} == owner & units{:,"aID"} == ar.aID,:);
        for uu = 1:height(thisCountrys)
            
            p = thisCountrys(uu,:);

            % Type
            if p.uType == 1
                type = "A";
            elseif p.uType == 2
                type = "N";
            elseif p.uType == 3
                type = "M";
            end

            s = p.sz;

            mil = mil + " " + s + type;
        end

        text(aX - 0.2 + 0.1 * c,aY + 0.15,symbol + mil,"FontSize",6,"FontWeight","bold",'EdgeColor',[0 0 0],"BackgroundColor",hex2rgb(color),"LineStyle",bStyle,Clipping='on');
    end
end

hold off