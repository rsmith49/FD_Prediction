clear
tic

conn = database('MLBDaily','root','','VENDOR','MySQL');

if ~isempty(conn.Message)
    conn.Message
end

try
    
    curs_pnames = exec(conn,'SELECT Name FROM player_avgs_2016');
    curs_pnames = fetch(curs_pnames);

    pnames = curs_pnames.Data;

    for i=1:length(pnames)
        if ~(isempty(strfind(pnames{i},'*')) && ...
            isempty(strfind(pnames{i}, '#')))
            pnames{i} = pnames{i}(1:end-1);
        end
    end

    curs = exec(conn, 'SELECT espnID FROM active_players WHERE hand IS NULL');
    curs = fetch(curs);
    

    for i=1:length(curs.Data)
        updateDBPlayerESPNID(conn,pnames,curs.Data{i});
    end

catch e
    disp(e.message)
end

close(conn)

toc
