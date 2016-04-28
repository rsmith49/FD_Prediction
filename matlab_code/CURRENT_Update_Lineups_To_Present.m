clear
tic
conn = database('MLBDaily','root','','VENDOR','MySQL');

todayNum = today('datenum');

try
    curs = exec(conn,sprintf(['SELECT DISTINCT date FROM game_info_%d WHERE '...
        'datenum <= %d AND homeLong IS NULL'], year(todayNum), todayNum));
    curs = fetch(curs);
    if ~isempty(curs.Message)
        disp(curs.Message)
    end
    
    for i=1:length(curs.Data)
        updateLineupsForDate(conn,year(todayNum),curs.Data{i});
    end
catch e
    disp(e)
    disp(curs.Data{i})
end
close(conn)
disp('------------------------------------')
disp('------------------------------------')
disp('Finished updating lineups')
toc
disp('------------------------------------')
disp('------------------------------------')
