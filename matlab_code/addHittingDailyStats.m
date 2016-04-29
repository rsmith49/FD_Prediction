function addHittingDailyStats(conn, html, playerName, espnID, dateStr, ...
    year, doubleHeaderNum, fd_id)

try
    dateNum = datenum([dateStr ' ' num2str(year)]);
    lineStart = strfind(html, dateStr);

    if length(lineStart) > 1
        lineStart = lineStart(doubleHeaderNum);
    end

    lineEnd = strfind(html(lineStart:end), 'row">');
    if ~isempty(lineEnd)
        lineEnd = lineEnd(1);
    else
        lineEnd = length(html)-lineStart-1;
    end

    line = html(lineStart:lineStart+lineEnd);
    ends = strfind(line, '</td>');



    opp = line(ends(2)-3:ends(2)-1);


    if ~isempty(strfind(line(ends(2):ends(4)), 'W'))
        result = 'W';
    else
        result = 'L';
    end

    if isempty(strfind(line, 'Did not play'))
        ab = str2num(line(ends(4)-1));
        r = str2num(line(ends(5)-1));
        h = str2num(line(ends(6)-1));
        b2 = str2num(line(ends(7)-1));
        b3 = str2num(line(ends(8)-1));
        hr = str2num(line(ends(9)-1));
        rbi = str2num(line(ends(10)-1));
        bb = str2num(line(ends(11)-1));
        so = str2num(line(ends(12)-1));
        sb = str2num(line(ends(13)-1));
        cs = str2num(line(ends(14)-1));

    else
        ab = 0;
        r = 0;
        h = 0;
        b2 = 0;
        b3 = 0;
        hr = 0;
        rbi = 0;
        bb = 0;
        so = 0;
        sb = 0;
        cs = 0;

    end

    curs = exec(conn, sprintf(['SELECT espnID FROM player_daily_%d WHERE espnID '...
        '= %d AND date = "%s" AND opp = "%s" AND result = "%s" AND '...
        'ab = %d AND r = %d AND h = %d AND 2B = %d AND 3B = %d AND HR = %d'...
        ' AND RBI = %d AND BB = %d AND K = %d AND sb = %d AND cs = %d;'],...
         year, espnID, dateStr, opp, result, ab, r, h, b2, b3, hr, rbi, bb,...
         so, sb, cs));
    if ~isempty(curs.Message)
        curs.Message
    end
    curs = fetch(curs);

    if ~isempty(strfind(curs.Data{1},'No Data'))    
        
        % calculating fanduel points
        fd_points = 3*(h+b2+2*b3+3*hr+2*sb+bb)+3.2*r+3.5*rbi;

        curs = exec(conn, sprintf(['INSERT INTO player_daily_%d (playerName, '...
            'espnID, `date`, opp, result, ab, r, h, 2B, 3B, HR, RBI, BB, K, '...
            'sb, cs, fd_id, dateNum, fd_points) VALUES ("%s", %d, "%s", "%s", "%s", %d, %d, %d'...
            ', %d, %d, %d, %d, %d, %d, %d, %d, "%s", %d, %f);'], year, playerName, espnID, dateStr,...
            opp, result, ab, r, h, b2, b3, hr, rbi, bb, so, sb, cs, fd_id, dateNum, fd_points));
        
        if ~isempty(curs.Message)
            disp(curs.Message) 
        end

    else
    %    disp('Entry Already Exists')
    %    disp(espnID)
    %    disp(playerName)
    %    disp(dateStr)
    %    disp(year)
    end
catch e
        disp(e.identifier)
    disp(e.message)
    disp(e.cause)
    
    disp([playerName ' ' dateStr ' ' num2str(year) ' ' num2str(doubleHeaderNum)])
end
