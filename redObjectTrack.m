%Obtiene informaci?n de la camara
r=1;
a = imaqhwinfo;
[camera_name, camera_id, format] = getCameraInfo(a);


% Captura video de la camara
% You have to replace the resolution & your installed adaptor name.
vid = videoinput(camera_name, camera_id, format);

% Asigna propiedades al objeto de video
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
%Se usan 2 fotogramas de intervalo
vid.FrameGrabInterval = 2;

%Empieza la adquisicion de video
start(vid)
%inicia el arreglo de dibujo
drawObj = [];
% While para capturar 600 fotogramas
while(vid.FramesAcquired<=600)
    
    % Obtiene un fotograma y reescala la imagen al 60%
    data = getsnapshot(vid);
    data = imresize(data,0.6);
    
    %Extrae la capa azul de la imagen y la convierte a una imagen en escala
    %de grises
    diff_im = imsubtract(data(:,:,3), rgb2gray(data));
    %Usa un filtro basado en valores medios para eliminar el ruido
    %Cada pixel se convierte en el valor medio de los 3-3 vecinos
    diff_im = medfilt2(diff_im, [3 3]);
    % Se convierte en imagen binaria
    % reference https://la.mathworks.com/help/images/ref/im2bw.html 
    diff_im = im2bw(diff_im,0.18);
    
    % Remueve todos los objetos que su interconexion sea menor a 300px, eso
    % eliminara el ruido
    diff_im = bwareaopen(diff_im,300);
    
    % Etiqueta todas las zonas conectadas de la imagen
    bw = bwlabel(diff_im, 8);
    
    % Se extrae la informacion de las regiones donde aparecen los objetos
    % de nuestra imagen binaria
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    %Se empieza a dibujar si el objeto de drawObj tiene informacion
    if(length(drawObj) >2)
        % se recorre todo el objeto
        for i=1:length(drawObj)
            %Se dibuja en cada capa en las coordenadas un valor que
            %producira un color
            data(round(drawObj(i,1)):round(drawObj(i,1)+10),round(drawObj(i,2)):round(drawObj(i,2)+10),1) = 120; %a la capa roja en el pixel 30 al 30+20 X y 90 al 20 Y asignele 120
            data(round(drawObj(i,1)):round(drawObj(i,1)+10),round(drawObj(i,2)):round(drawObj(i,2)+10),2) = 152; %a la capa verde en el pixel 30 al 30+20 X y 90 al 20 Y asignele 152
            data(round(drawObj(i,1)):round(drawObj(i,1)+10),round(drawObj(i,2)):round(drawObj(i,2)+10),3) = 0;
        end
    end
    
    % Muestra la imagen
    figure(2);
    imshow(data);
    hold on
    
    %se lee el archivo donde escribe el web server
    txt = textread('startDraw.txt', '%s', 'whitespace', '');
    % Si es uno se debe empezar a dibujar
    if strcmp(txt{1},'1')
        %Este for encierra y encuentra las coordenadas de nuestro color
        %azul
        for object = 1:length(stats)
            bb = stats(object).BoundingBox;
            bc = stats(object).Centroid;
            %reyena el objeto de dibujo
            drawObj = [drawObj;[bc(2),bc(1)]];
            %crea un rectangulo para ser mas evidente la posicion de
            %nuestro objeto
            rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
            plot(bc(1),bc(2), '-m+')
            a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
            set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
        end
    end
    
    hold off
end

% Stop the video aquisition.
stop(vid);

% Flush all the image data stored in the memory buffer.
flushdata(vid);