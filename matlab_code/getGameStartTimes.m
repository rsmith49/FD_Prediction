function data = getGameStartTimes(year,team)

html = webread(sprintf('http://espn.go.com/mlb/teams/printSchedule/_/team/%s/season/%d',...
    team, year));

endLines = strfind(html,'<td align=right>');

for i=2:length(endLines)
    tmp = strfind(html(endLines(i):end),'</font>');
    endLines(i) = endLines(i)+tmp(1)-2;
end

data = cell(length(endLines)-1,3);

endLines(1) = endLines(1) + strfind(html(endLines(1):endLines(2)),'<b>')-1;

for i=1:length(endLines)-1
    line = html(endLines(i):endLines(i+1));
    bLocStart = strfind(line,'<b>');
    bLocEnd = strfind(line,'</b>');
    data{i,1} = line(bLocStart(1)+3:bLocEnd(1)-1);
    
    if ~isempty(strfind(data{i,1},'.'))
        switch data{i,1}(1:3)
            case 'Mar'
                data{i,1} = ['Mar' data{i,1}(5:end)];
            case 'Apr'
                data{i,1} = ['Apr' data{i,1}(5:end)];
            case 'Jun'
                data{i,1} = ['Jun' data{i,1}(5:end)];
            case 'Jul'
                data{i,1} = ['Jul' data{i,1}(5:end)];
            case 'Aug'
                data{i,1} = ['Aug' data{i,1}(5:end)];
            case 'Sep'
                data{i,1} = ['Sep' data{i,1}(6:end)];
            case 'Oct'
                data{i,1} = ['Oct' data{i,1}(5:end)];
            otherwise
                data{i,1} = data{i,1};
        end
    end
                
    
    line = line(bLocEnd(1):end);
    nextSizeE1 = strfind(line,'size=1>');
    endFont2 = strfind(line,'</font>');
    data{i,2} = line(nextSizeE1(1)+7:endFont2(2)-1);
    
    line = line(endFont2(2)+7:end);
    nextSizeE1 = strfind(line,'size=1>');
    data{i,3} = line(nextSizeE1(end)+7:end);
end
    
    