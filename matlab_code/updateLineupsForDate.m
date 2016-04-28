function updateLineupsForDate(conn, year, date)
monthNum = month(datenum(date,'mmm dd'));
dayNum = day(datenum(date,'mmm dd'));

url = sprintf('http://www.baseballpress.com/lineups/%d-%d-%d', year, monthNum, dayNum);
html = webread(url);

gamesStart = strfind(html,'class="game clearfix">');
tmp = strfind(html,'class="weather clearfix">');
gamesStart = [gamesStart tmp(end)];

for i=1:length(gamesStart)-1
    
    try
        game = html(gamesStart(i):gamesStart(i+1));

        tnameLocs = strfind(game,'class="team-name');
        tmpStart = strfind(game(tnameLocs(1):end),'>')+tnameLocs(1)-1;
        tmpEnd = strfind(game(tnameLocs(1):end),'</div>')+tnameLocs(1)-1;
        visMascott = game(tmpStart(1)+1:tmpEnd(1)-1);

        tmpStart = strfind(game(tnameLocs(2):end),'>')+tnameLocs(2)-1;
        tmpEnd = strfind(game(tnameLocs(2):end),'</div>')+tnameLocs(2)-1;
        homeMascott = game(tmpStart(1)+1:tmpEnd(1)-1);

        endHeader = strfind(game,'class="cssDialog clearfix">');
        linkStarts = strfind(game(1:endHeader),'<a');
        linkEnds = strfind(game(1:endHeader),'</a>');
        visPitchLine = game(linkStarts(2):linkEnds(2));
        visPitcherName = visPitchLine(strfind(visPitchLine,'>')+1:end-1);
        homePitchLine = game(linkStarts(4):linkEnds(4));
        homePitcherName = homePitchLine(strfind(homePitchLine,'>')+1:end-1);

        visLineupNames = cell(9,1);
        homeLineupNames = cell(9,1);
        visLineupPos = zeros(9,1);
        homeLineupPos = zeros(9,1);

        lineupStarts = strfind(game,'<div class="players">');
        vLineup = game(lineupStarts(1):lineupStarts(2));
        hLineup = game(lineupStarts(2):end);

        vDivEnds = strfind(game(lineupStarts(1):end),'</div>') + lineupStarts(1)-1;
        hDivEnds = strfind(game(lineupStarts(2):end),'</div>') + lineupStarts(2)-1;
        tmpLocV = lineupStarts(1);
        tmpLocH = lineupStarts(2);

        for i=1:9
            lineV = game(tmpLocV:vDivEnds(i));
            lineH = game(tmpLocH:hDivEnds(i));
            tmpLocV = vDivEnds(i)+6;
            tmpLocH = hDivEnds(i)+6;

            tmpSt = strfind(lineV,'<a');
            tmpEnd = strfind(lineV,'</a>');
            visLineupNames{i} = lineV(strfind(lineV(tmpSt:end),'>')+tmpSt:tmpEnd-1);

            tmp1 = strfind(lineV(tmpEnd:end),')')+tmpEnd-1;
            %tmp2 = strfind(lineV(tmp1:end),'"')+tmp1-1;
            visLineupPos(i) = getPos(lineV(tmp1+2:end-1));


            tmpSt = strfind(lineH,'<a');
            tmpEnd = strfind(lineH,'</a>');
            homeLineupNames{i} = lineH(strfind(lineH(tmpSt:end),'>')+tmpSt:tmpEnd-1);

            tmp1 = strfind(lineH(tmpEnd:end),')')+tmpEnd-1;
            %tmp2 = strfind(lineH(tmp1:end),'"')+tmp1-1;
            homeLineupPos(i) = getPos(lineH(tmp1+2:end-1));

        end
        % Time to update table with only partial info

        cursV = exec(conn,['select team, teamLong from stadium_stats where teamLong like "%'...
            visMascott '"']);
        cursV = fetch(cursV);
        if ~isempty(cursV.Message)
            disp(cursV.Message);
        end
        cursH = exec(conn,['select team, teamLong from stadium_stats where teamLong like "%'...
            homeMascott '"']);
        cursH = fetch(cursH);
        if ~isempty(cursH.Message)
            disp(cursH.Message);
        end
        home = cursH.Data{1,1};
        vis = cursV.Data{1,1};
        homeLong = cursH.Data{1,2};
        visLong = cursV.Data{1,2};
        dtNum = datenum([date ' ' num2str(year)],'mmm dd yyyy');

        sqlquery = sprintf('update game_info_%d set ', year);
        sqlquery = [sqlquery sprintf(['homeLong = "%s", vis = "%s", visLong = "%s"'...
            ', datenum = %d'], homeLong, vis, visLong, dtNum)];
        for i=1:9
            sqlquery = [sqlquery sprintf([', hLineup%dName = "%s", vLineup%dName = "%s"'...
                ', hLineup%dPos = %d, vLineup%dPos = %d'], i,homeLineupNames{i},...
                i,visLineupNames{i},i,homeLineupPos(i),i,visLineupPos(i))];
        end

        sqlquery = [sqlquery sprintf(', hSPName = "%s", vSPName = "%s"', homePitcherName, visPitcherName)];
        sqlquery = [sqlquery sprintf(' where home = "%s" AND date = "%s"', home,date)];

        curs = exec(conn, sqlquery);
        if ~isempty(curs.Message)
            disp(curs.Message)
        end
    catch e
        disp(sprintf('Lineups Unavailable for: %s at %s on %s',...
            visMascott, homeMascott, date));
        sqlquery = sprintf('update game_info_%d set ', year);
        sqlquery = [sqlquery sprintf(['homeLong = "%s", vis = "%s", visLong = "%s"'...
            ', datenum = %d'], homeLong, vis, visLong, dtNum)];
        sqlquery = [sqlquery sprintf(', hSPName = "%s", vSPName = "%s"', homePitcherName, visPitcherName)];
        sqlquery = [sqlquery sprintf(' where home = "%s" AND date = "%s"', home,date)];
        curs = exec(conn, sqlquery);
        if ~isempty(curs.Message)
            disp(curs.Message)
        end
    end
    
end
    
    
    