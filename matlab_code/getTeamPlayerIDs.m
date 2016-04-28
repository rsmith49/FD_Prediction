function ids = getTeamPlayerIDs(teamLabel)

url = sprintf('http://espn.go.com/mlb/team/roster/_/name/%s/type/active/',teamLabel);
html = webread(url);

locs = strfind(html,'row player-');
ids = zeros(length(locs),1);

for i=1:length(locs)
    newStr = html(locs(i)+11:locs(i)+11+strfind(html(locs(i)+11:end),'"')-2);
    dashLoc = strfind(newStr,'-');
    newStr = newStr(dashLoc+1:end);
    ids(i) = str2num(newStr);
end
    