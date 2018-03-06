function html=startDraw(headers,config)
%global startDraw
%startDraw = 1
fid = fopen('startDraw.txt','wt');
fprintf(fid, '1');
fclose(fid);
html = 'ok'