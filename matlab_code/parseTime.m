function minutesFromMidnight = parseTime(timeString)

mins = 60*str2double(timeString(1:strfind(timeString,':')-1)) + ...
    str2double(timeString(strfind(timeString,':')+1:strfind(timeString,':')+2));

if mins >= 60*12
    mins = mins-60*12;
end

if isempty(strfind(timeString,'AM'))
    mins = mins + 60*12;
end

minutesFromMidnight = mins;