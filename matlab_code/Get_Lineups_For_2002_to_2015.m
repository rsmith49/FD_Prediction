%close(conn)
clear

tic
conn = database('MLBDaily','root','','VENDOR','MySQL');
%try

    curs = exec(conn, ['select col_0, col_1, col_3, col_6, col_102, col_104, '...
        'col_106, col_107, col_109, col_110, col_112, col_113, col_115, col_116, '...
        'col_118, col_119, col_121, col_122, col_124, col_125, col_127, col_128, '...
        'col_130, col_131, col_133, col_134, col_136, col_137, col_139, col_140, '...
        'col_142, col_143, col_145, col_146, col_148, col_149, col_151, col_152, '...
        'col_154, col_155, col_157, col_158 from game_logs']);

    if ~isempty(curs.Message)
        disp(curs.Message)
    end

    curs = fetch(curs);

    for i=1:size(curs.Data,1)
        year = floor(curs.Data{i,1}/10000);
if year >= 2012
        dateNum = datenum(num2str(curs.Data{i,1}),'yyyymmdd');
        dateStr = '';
        switch month(dateNum)
            case 1
                dateStr = 'Jan ';
            case 2
                dateStr = 'Feb ';
            case 3
                dateStr = 'Mar ';
            case 4
                dateStr = 'Apr ';
            case 5
                dateStr = 'May ';
            case 6
                dateStr = 'Jun ';
            case 7
                dateStr = 'Jul ';
            case 8
                dateStr = 'Aug ';
            case 9
                dateStr = 'Sep ';
            case 10
                dateStr = 'Oct ';
            case 11
                dateStr = 'Nov ';
            case 12
                dateStr = 'Dec ';
            otherwise
                disp('WTF');
        end
        dateStr = [dateStr num2str(day(dateNum))];
        visRetro = curs.Data{i,3};
        homeRetro = curs.Data{i,4};

        switch homeRetro
            case 'MON'
                homeRetro = 'WAS';
            case 'FLO'
                homeRetro = 'MIA';
            otherwise
                homeRetro = homeRetro;
        end
        switch visRetro
            case 'MON'
                visRetro = 'WAS';
            case 'FLO'
                visRetro = 'MIA';
            otherwise
                visRetro = visRetro;
        end



        tmpCurs = exec(conn, sprintf(['select team, teamLong from stadium_stats where '...
            'retrosheetTeam = "%s"'], visRetro));
        if ~isempty(tmpCurs.Message)
            disp(tmpCurs.Message)
        end
        tmpCurs = fetch(tmpCurs);
        visShort = tmpCurs.Data{1,1};
        visLong = tmpCurs.Data{1,2};

        tmpCurs = exec(conn, sprintf(['select team, teamLong from stadium_stats where '...
            'retrosheetTeam = "%s"'], homeRetro));
        if ~isempty(tmpCurs.Message)
            disp(tmpCurs.Message)
        end
        tmpCurs = fetch(tmpCurs);
        homeShort = tmpCurs.Data{1,1};
        homeLong = tmpCurs.Data{1,2};

        visSP = curs.Data{i,5};
        visSPID = getESPNID(conn, visSP, visShort);
        homeSP = curs.Data{i,6};
        homeSPID = getESPNID(conn, homeSP, homeShort);

        visLineup = cell(9,3);
        homeLineup = cell(9,3);
        for j=1:9
            visLineup{j,1} = curs.Data{i,5+2*j};
            visLineup{j,2} = curs.Data{i,6+2*j};
            visLineup{j,3} = getESPNID(conn, visLineup{j,1}, visShort);

            homeLineup{j,1} = curs.Data{i,23+2*j};
            homeLineup{j,2} = curs.Data{i,24+2*j};
            homeLineup{j,3} = getESPNID(conn, homeLineup{j,1}, homeShort);
        end

        sqlquery = sprintf(['insert into game_info_%d (home, homeLong, vis, visLong'...
            ', `date`, datenum, hLineup1Name, hLineup1ESPNID, hLineup1Pos, '...
            'hLineup2Name, hLineup2ESPNID, hLineup2Pos, '...
            'hLineup3Name, hLineup3ESPNID, hLineup3Pos, '...
            'hLineup4Name, hLineup4ESPNID, hLineup4Pos, '...
            'hLineup5Name, hLineup5ESPNID, hLineup5Pos, '...
            'hLineup6Name, hLineup6ESPNID, hLineup6Pos, '...
            'hLineup7Name, hLineup7ESPNID, hLineup7Pos, '...
            'hLineup8Name, hLineup8ESPNID, hLineup8Pos, '...
            'hLineup9Name, hLineup9ESPNID, hLineup9Pos, '...
            'vLineup1Name, vLineup1ESPNID, vLineup1Pos, '...
            'vLineup2Name, vLineup2ESPNID, vLineup2Pos, '...
            'vLineup3Name, vLineup3ESPNID, vLineup3Pos, '...
            'vLineup4Name, vLineup4ESPNID, vLineup4Pos, '...
            'vLineup5Name, vLineup5ESPNID, vLineup5Pos, '...
            'vLineup6Name, vLineup6ESPNID, vLineup6Pos, '...
            'vLineup7Name, vLineup7ESPNID, vLineup7Pos, '...
            'vLineup8Name, vLineup8ESPNID, vLineup8Pos, '...
            'vLineup9Name, vLineup9ESPNID, vLineup9Pos, '...
            'hSPName, hSPESPNID, vSPName, vSPESPNID) VALUES ( '...
            '"%s", "%s", "%s", "%s", "%s", %d, "%s", %d, %d, '...
            '"%s", %d, %d, "%s", %d, %d, "%s", %d, %d, "%s", %d, %d, '...
            '"%s", %d, %d, "%s", %d, %d, "%s", %d, %d, "%s", %d, %d, '...
            '"%s", %d, %d, "%s", %d, %d, "%s", %d, %d, "%s", %d, %d, '...
            '"%s", %d, %d, "%s", %d, %d, "%s", %d, %d, "%s", %d, %d, '...
            '"%s", %d, %d, "%s", %d, "%s", %d);'], year, homeShort, homeLong, ...
            visShort, visLong, dateStr, dateNum, ...
            homeLineup{1,1}, homeLineup{1,3}, homeLineup{1,2},...
            homeLineup{2,1}, homeLineup{2,3}, homeLineup{2,2},...
            homeLineup{3,1}, homeLineup{3,3}, homeLineup{3,2},...
            homeLineup{4,1}, homeLineup{4,3}, homeLineup{4,2},...
            homeLineup{5,1}, homeLineup{5,3}, homeLineup{5,2},...
            homeLineup{6,1}, homeLineup{6,3}, homeLineup{6,2},...
            homeLineup{7,1}, homeLineup{7,3}, homeLineup{7,2},...
            homeLineup{8,1}, homeLineup{8,3}, homeLineup{8,2},...
            homeLineup{9,1}, homeLineup{9,3}, homeLineup{9,2},...
            visLineup{1,1}, visLineup{1,3},  visLineup{1,2},...
            visLineup{2,1}, visLineup{2,3},  visLineup{2,2},...
            visLineup{3,1}, visLineup{3,3},  visLineup{3,2},...
            visLineup{4,1}, visLineup{4,3},  visLineup{4,2},...
            visLineup{5,1}, visLineup{5,3},  visLineup{5,2},...
            visLineup{6,1}, visLineup{6,3},  visLineup{6,2},...
            visLineup{7,1}, visLineup{7,3},  visLineup{7,2},...
            visLineup{8,1}, visLineup{8,3},  visLineup{8,2},...
            visLineup{9,1}, visLineup{9,3},  visLineup{9,2},...
            homeSP, homeSPID, visSP, visSPID);

        tmpCurs = exec(conn, sqlquery);
        if ~isempty(tmpCurs.Message)
            disp(tmpCurs.Message)
            disp(sqlquery)
        end
end
    end
%catch e
%    disp(e.message)
%    i
%end

close(conn)
disp('Lineups done')
toc