clear

tic
conn = database('MLBDaily','root','','VENDOR','MySQL');

try
%    curs = exec(conn, ['SELECT playerName, espnID FROM active_players'...
%        ' WHERE position <> ''RP'' AND position <> ''SP'';']);
%    curs = exec(conn, ['SELECT playerName, espnID FROM active_players WHERE'...
%        ' position <> "RP" AND position <> "SP";']);

%    curs = exec(conn,['select playerName, espnID from active_players where'...
%        ' startYear < 2016 and position <> "SP" and position <> "RP" and'...
%        ' espnID not in (select distinct espnID from player_daily_2016);']);
    curs = exec(conn,['select playerName, espnID from active_players where'...
        ' position = "SP";']);


    if curs.Message
        curs.Message
    end
    curs = fetch(curs);

    options = weboptions('Timeout', 60);
    
    for i=1:length(curs.Data)
        
        try
            html = webread(sprintf(['http://espn.go.com/mlb/player/gamelog/_/'...
                'id/%d/year/2016'], curs.Data{i,2}), options);
            years = getAllESPNYears(html);
%            years = [2016]';
            
            
            for j=1:length(years)
                html = webread(sprintf(['http://espn.go.com/mlb/player/'...
                    'gamelog/_/id/%d/year/%d'], curs.Data{i,2}, years(j)),... 
                    options);
                
                
                %dates = getAllESPNHitterDates(html);
                dates = getAllESPNPitcherDates(html);
                
                for k=1:length(dates)
%                    if k > 1 && strcmp(dates{k},dates{k-1})
%                        dbHeaderNum = 2;
%                    else
%                        dbHeaderNum = 1;
%                    end
%                    addHittingDailyStats(conn, html, curs.Data{i,1}, ...
%                        curs.Data{i,2}, dates{k}, years(j), dbHeaderNum);

                    addPitchingDailyStats(conn,html,curs.Data{i,1},...
                        curs.Data{i,2},dates{k},years(j));

                end
            end
        catch e
            disp(e.identifier)
            disp(e.message)
            disp(e.cause)
            disp(e.stack)
            
            disp([dates{k} num2str(years(j)) curs.Data{i,1}])
       
        end
    end
catch e
    disp(e.identifier)
    disp(e.message)
    disp(e.cause)
    disp(e.stack)
end

close(conn);
toc
                       
        
