function addPitchingDailyStats(conn, html, playerName, espnID, dateStr, ...
    year, fd_id)
try
    dateNum = datenum([dateStr ' ' num2str(year)]);
    
    lineStart = strfind(html, [dateStr '<']);

    lineEnd = strfind(html(lineStart:end), '</tr>');
    if ~isempty(lineEnd)
        lineEnd = lineEnd(1);
    else
        lineEnd = length(html)-lineStart-1;
    end

    line = html(lineStart:lineStart+lineEnd);
    ends = strfind(line, '</td>');
    numStr = cell(length(ends),1);
    nums = zeros(length(ends),1);
    for i=1:length(ends)
        if ~isempty(strfind(line(ends(i)-5:ends(i)),'>'))
            numStr{i} = line(ends(i)-6+strfind(line(ends(i)-5:ends(i)),'>')+1:ends(i)-1);
            nums(i) = str2double(numStr{i});
            if isnan(nums(i))
                nums(i) = 0;
            end
        end
    end

    opp = line(ends(2)-3:ends(2)-1);


    if ~isempty(strfind(line(ends(2):ends(4)), 'W'))
        result = 'W';
    else
        result = 'L';
    end


        ip = nums(4);
        if ip-floor(ip) > .15
            ip = ip+(2/3-.2);
        elseif ip-floor(ip) > .05
            ip = ip+(1/3-.1);
        end

        h = nums(5);
        r = nums(6);
        er = nums(7);
        hr = nums(8);
        bb = nums(9);
        k = nums(10);
        gb = nums(11);
        fb = nums(12);
        pit = nums(13);
        bf = nums(14);
        gsc = nums(15);

        if ~isempty(strfind(line(ends(16)-10:ends(16)),'W'))
            dec = 'W';
        elseif ~isempty(strfind(line(ends(16)-10:ends(16)),'L'))
            dec = 'L';
        else
            dec = 'N';
        end


    curs = exec(conn, sprintf(['SELECT espnID FROM pitcher_daily_%d WHERE espnID '...
        '= %d AND date = "%s";'], year, espnID, dateStr));
    if ~isempty(curs.Message)
        curs.Message
    end
    curs = fetch(curs);


    if ~isempty(strfind(curs.Data{1},'No Data'))
        
            % Calculating FanDuel Points
            fd_points = 3*(ip + k - er + 4*(dec == 'W'));

        curs = exec(conn, sprintf(['INSERT INTO pitcher_daily_%d (playerName, '...
            'espnID, `date`, opp, result, ip, h, r, er, hr, bb, k, gb, fb, '...
            'pitches, batFaced, avgGameScore, fd_id, dateNum, fd_points) VALUES ("%s", %d, "%s", "%s", '...
            '"%s", %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, "%s", %d, %f);'], year,...
            playerName, espnID, dateStr, opp, result, ip, h, r, er, hr, bb, k,...
            gb, fb, pit, bf, gsc, fd_id, dateNum, fd_points));

        if ~isempty(curs.Message)
            disp(curs.Message)
            curs.SQLQuery
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
    
    disp([playerName ' ' dateStr ' ' num2str(year)])
end
