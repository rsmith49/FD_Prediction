function res = getQuery(conn,query)

res = exec(conn,query);
if ~isempty(res.Message)
    disp(res.Message)
end
res = fetch(res);
res = res.Data;
