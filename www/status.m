function html=cameraDraw(headers,config)
txt = textread('startDraw.txt', '%s', 'whitespace', '');
ret = 'NO';
if strcmp(txt{1},'1')
    ret = 'YES';
end
%global startDraw
%disp('g---------g');
%disp(startDraw)
%ret = 'NO';
%if(startDraw)
%    ret = 'YES';
%end

html = ret