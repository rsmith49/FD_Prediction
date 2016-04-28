function updateDBPlayerESPNID(conn, playerList, idNum)


try
    url = sprintf('http://espn.go.com/mlb/player/stats/_/id/%d/',idNum);
    options = weboptions('Timeout', 60);

    html = webread(url, options);

    titleBounds = [strfind(html,'<title>') strfind(html,'</title>')];
    titleBounds(1) = titleBounds(1)+7;
    htmltitle = html(titleBounds(1):titleBounds(2));

    if isempty(strfind(htmltitle,'MLB Players Rosters'))

        playerName = htmltitle(1:strfind(htmltitle,'Stats - ')-2);

        if isempty(playerList) || ismember(playerName,playerList)
            
            team = htmltitle(strfind(htmltitle, 'Stats - ')+8:end-8);
            posLoc = strfind(html, 'class="first">#');
            newPos = strfind(html(posLoc:end),'</li>');

            position = strtrim(html(posLoc+newPos(1)-3:posLoc+newPos(1)-2));
            
            if isempty(strfind(position,'P'))
                newPos = strfind(html, ', Throws');
            else
                newPos = strfind(html, ', Bats');
            end
            hand = html(newPos-1);
            searchString = sprintf('</td>\n<td><ul class="game-schedule"');
            posYears = strfind(html, searchString);
            years = zeros(length(posYears),1);
            for i=1:length(posYears)
                years(i) = str2num(html(posYears(i)-4:posYears(i)-1));
            end
            startYear = min(years);
            
            
            curs = exec(conn,sprintf(['SELECT * FROM active_players WHERE'...
             ' espnid = %d'],idNum));
            curs = fetch(curs);

            if ~isempty(strfind(curs.Data{1},'No Data'))
                sqlquery = sprintf(['INSERT INTO active_players (playerName, '...
                 'espnID, startYear, currentTeam, position, hand) '...
                 'VALUES ("%s", %d, %d, "%s", "%s", "%s")'],...
                 playerName, idNum, startYear, team, position, hand);

            else
                sqlquery = sprintf(['UPDATE active_players SET playerName'...
                    ' = "%s", startYear = %d, currentTeam = "%s", '...
                    'position = "%s", hand = "%s" WHERE espnID = %d'], ...
                    playerName, startYear, team, position, hand, idNum);
            end
            
            curs = exec(conn,sqlquery);
            if ~isempty(curs.Message)
                disp(curs.Message)
                disp(sqlquery)
            end
        end
    end
        
catch e
    disp(e.message)
    disp(idNum)
end
        
        
