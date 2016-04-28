function id = getESPNID(conn, playerName, team)

thisCurs = exec(conn, sprintf(['select espnID, playerName, currentTeamID from '...
    'active_players where playerName = "%s"'], playerName));
if ~isempty(thisCurs.Message)
    disp(thisCurs.Message);
end

thisCurs = fetch(thisCurs);
if strcmp(thisCurs.Data{1}, 'No Data')
    id = -1;
else
    

    num = 1;
    if size(thisCurs.Data,1) > 1
        for ndx=1:size(thisCurs.Data,1)
            if strcmp(thisCurs.Data{ndx,3},team)
                num = ndx;
            end
        end
    end
    id = thisCurs.Data{num,1};
    
end
