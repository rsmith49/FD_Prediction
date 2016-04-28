function factors = parkFactorsForYear(html, parkName)

factors = zeros(1,6);

parkLoc = strfind(html, parkName);
line = html(parkLoc:parkLoc+strfind(html(parkLoc:end),'</tr>')-2);
numLocs = strfind(line,'</td>');
for i=2:length(numLocs)
    tmp = strfind(line(1:numLocs(i)),'>');
    tmp = tmp(end);
    factors(i-1) = str2double(line(tmp+1:numLocs(i)-1));
end