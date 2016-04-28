clear
tic

conn = database('MLBDaily','root','','VENDOR','MySQL');

if ~isempty(conn.Message)
    conn.Message
end

try
    curs = exec(conn, 'select team from stadium_stats;');
    curs = fetch(curs);
    if ~isempty(curs.Message)
        disp(curs.Message)
    end
    
    ids = [];
    for i=1:length(curs.Data)
        ids = [ids; getTeamPlayerIDs(curs.Data{i})];
    end
    
    for i=1:length(ids)
        updateDBPlayerESPNID(conn,[],ids(i));
    end
catch e
    disp(e.message)
    disp(e)
end

close(conn);
disp('Updated Active Players List and ID''s')
toc