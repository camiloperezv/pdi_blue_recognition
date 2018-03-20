%Inicia Variable de dibujo en cero
fid = fopen('startDraw.txt','wt');
fprintf(fid, '0');
fclose(fid);
%Crea proceso de web server
j = batch('webserver');
%inicia el procesamiento de imagenes
redObjectTrack();
%destruye el proceso del web server para terminar
delete(j)