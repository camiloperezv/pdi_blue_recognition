function html=stopDraw(headers,config)
%global startDraw
%startDraw = 0
fid = fopen('startDraw.txt','wt');
fprintf(fid, '0');
fclose(fid);
html = 'ok'