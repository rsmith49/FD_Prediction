function updateOldWeatherData(conn, airport, year, homeTeam)

sqlquery = sprintf(['SELECT `date`, startTime FROM game_info_%d WHERE home = "%s"'...
    ' AND temp IS NULL AND homeLong IS NOT NULL'], year, homeTeam);
curs = exec(conn, sqlquery);
if ~isempty(curs.Message)
    disp(curs.Message)
end
curs = fetch(curs);
%dates = curs.Data{:,1};
%times = curs.Data{:,2};
formatIn = ['mmm dd ' num2str(year)];
options = weboptions('Timeout', 60);

for i=1:size(curs.Data,1)
    dateNumVar = datenum(curs.Data{i,1}, formatIn);
    url = sprintf(['https://www.wunderground.com/history/airport/%s/%d/%d/%d/'...
        'DailyHistory.html?req_city=&req_state=&req_statename=&reqdb.zip=&'...
        'reqdb.magic=&reqdb.wmo=&format=1'], airport, year,month(dateNumVar), day(dateNumVar));
    html = webread(url, options);
    
    minsStartTime = parseTime(curs.Data{i,2});
    breaks = strfind(html,'<br');
    smallestDiff = 60*24;
    lineNum = 0;
    for j=1:length(breaks)-1
        minsObs = parseTime(html(breaks(j)+7:strfind(html(breaks(j):end),',')...
            -2+breaks(j)));
        if abs(minsObs-minsStartTime) < smallestDiff
            smallestDiff = abs(minsObs - minsStartTime);
            lineNum = j;
        end
    end
    
    if lineNum > 0
        line = html(breaks(lineNum)+7:breaks(lineNum+1)-1);
        answer = cell(11,1);
        commas = strfind(line,',');
        commas = [1 commas];
        for j=2:6
            answer{j-1} = str2double(line(commas(j)+1:commas(j+1)-1));
        end
        answer{6} = line(commas(7)+1:commas(8)-1);
        if strcmp(answer{6},'Calm')
            answer{7} = 0;
        else
            answer{7} = str2double(line(commas(8)+1:commas(9)-1));
        end
        if strcmp(line(commas(9)+1:commas(10)-1),'-')
            answer{8} = 0;
        else
            answer{8} = str2double(line(commas(9)+1:commas(10)-1));
        end
        if strcmp(line(commas(10)+1:commas(11)-1),'N/A')
            answer{9} = 0;
        else
            answer{9} = str2double(line(commas(10)+1:commas(11)-1));
        end
        
        for j=10:11
            answer{j} = line(commas(j+1)+1:commas(j+2)-1);
        end
        
        sqlquery = sprintf(['UPDATE game_info_%d SET temp = %f, dewPoint = %f,'...
            ' percentHumidity = %d, pressure = %f, visibility = %f, windDir = "%s"'...
            ', windSpeed = %f, gustSpeed = %f, precip = %f, events = "%s", '...
            'conds = "%s" WHERE home = "%s" AND `date` = "%s"'], year, ...
            answer{1}, answer{2}, answer{3}, answer{4}, answer{5}, answer{6}, answer{7}, answer{8}, ...
            answer{9}, answer{10}, answer{11}, homeTeam, curs.Data{i,1});
        curs2 = exec(conn, sqlquery);
        if ~isempty(curs2.Message)
            disp(curs2.Message)
            disp(url)
        end
    end
end

        
            
