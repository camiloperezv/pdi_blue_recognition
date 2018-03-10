% function r = cameraDraw()
global startDraw
%job = batch('webserver');
%wait(job);
%load(job,'WEBSERVER')


r=1;
a = imaqhwinfo;
[camera_name, camera_id, format] = getCameraInfo(a);


% Capture the video frames using the videoinput function
% You have to replace the resolution & your installed adaptor name.
vid = videoinput(camera_name, camera_id, format);

% Set the properties of the video object
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb')
vid.FrameGrabInterval = 2;

%start the video aquisition here
start(vid)
drawObj = [];
% Set a loop that stop after 100 frames of aquisition
while(vid.FramesAcquired<=200)
    
    % Get the snapshot of the current frame
    data = getsnapshot(vid);
    data = imresize(data,0.6);
    diff_im = componentes_yellow(data);
    % Now to track red objects in real time
    % we have to subtract the red component 
    % from the grayscale image to extract the blue components in the image.
    diff_im(diff_im<240)=0;diff_im(diff_im>0)=255;
    diff_im = medfilt2(diff_im, [3 3]);
    diff_im = bwareaopen(diff_im,100);
    bw = bwlabel(diff_im, 8);
    stats = regionprops(bw, 'BoundingBox', 'Centroid');

    %OLD
    %{
    diff_im = imsubtract(data(:,:,3), rgb2gray(data));
    %Use a median filter to filter out noise
    %each pixel became the median value in a 3-by-3 neighborhood 
    diff_im = medfilt2(diff_im, [3 3]);
    % Convert the resulting grayscale image into a binary image.
    % reference https://la.mathworks.com/help/images/ref/im2bw.html 
    diff_im = im2bw(diff_im,0.18);
    
    % Remove all objects who have pixels less than 300px in a binary image
    diff_im = bwareaopen(diff_im,300);
    
    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    %OLD% 
    %}
    if(length(drawObj) >2)
        for i=1:length(drawObj)
            data(round(drawObj(i,1)):round(drawObj(i,1)+20),round(drawObj(i,2)):round(drawObj(i,2)+20),1) = 120; %a la capa roja en el pixel 30 al 30+20 X y 90 al 20 Y asignele 120
            data(round(drawObj(i,1)):round(drawObj(i,1)+20),round(drawObj(i,2)):round(drawObj(i,2)+20),2) = 152; %a la capa verde en el pixel 30 al 30+20 X y 90 al 20 Y asignele 152
            data(round(drawObj(i,1)):round(drawObj(i,1)+20),round(drawObj(i,2)):round(drawObj(i,2)+20),3) = 0;
        end
    end
    
    % Display the image
    figure(2);
    imshow(data);
    
    hold on
    txt = textread('startDraw.txt', '%s', 'whitespace', '');
    % if startDraw == 1
    if strcmp(txt{1},'1')
        %This is a loop to bound the red objects in a rectangular box.
        for object = 1:length(stats)
            bb = stats(object).BoundingBox;
            bc = stats(object).Centroid;
            drawObj = [drawObj;[bc(2),bc(1)]];


            rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
            plot(bc(1),bc(2), '-m+')
            a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
            set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
        end
    end
    
    hold off
end
% Both the loops end here.

% Stop the video aquisition.
stop(vid);

% Flush all the image data stored in the memory buffer.
flushdata(vid);

% Clear all variables
%clear all
sprintf('%s','That was all about Image tracking, Guess that was pretty easy :) ');

%delete(job)
%clear job

html = 'ok';
