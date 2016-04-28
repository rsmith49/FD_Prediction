% For one record, 98 seconds

clear

tic
conn = database('MLBDaily','root','','VENDOR','MySQL');
todayNum = today('datenum');

try
    curs = exec(conn,'SELECT playerName, espnID, position FROM active_players');


    if curs.Message
        curs.Message
    end
    curs = fetch(curs);

    options = weboptions('Timeout', 60);
    
    for i=1:length(curs.Data)
        
        try
            if isempty(strfind(curs.Data{i,3},'P'))
                updateHittingDailyStats(conn,curs.Data{i,2},year(todayNum));
            elseif strcmp(curs.Data{i,3},'SP')
                updatePitchingDailyStats(conn,curs.Data{i,2},year(todayNum));
            end
        catch e
            disp(e.message)
            disp([curs.Data{i,1} ' could not update data'])
        end
    end
catch e
    disp(e.identifier)
    disp(e.message)
    disp(e.cause)
    disp(e.stack)
end

close(conn);
disp('------------------------------------')
disp('------------------------------------')
disp('Finished Updating daily player data')
toc
disp('------------------------------------')
disp('------------------------------------')
                       
        
