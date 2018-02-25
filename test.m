clear all, close all, clc
img = imread('hd.jpg');
%figure(1); imshow(img);

diff_im = imsubtract(img(:,:,3), rgb2gray(img));
%imagen solo con componentes azules
%figure(2); imshow(diff_im);

%Use a median filter to filter out noise
%each pixel became the median value in a 3-by-3 neighborhood 
diff_im = medfilt2(diff_im, [3 3]);
% Convert the resulting grayscale image into a binary image.
% reference https://la.mathworks.com/help/images/ref/im2bw.html 
diff_im = im2bw(diff_im,0.18);
%figure(3); imshow(diff_im);
% Remove all objects who have pixels less than 100px in a binary image
diff_im = bwareaopen(diff_im,100);
%figure(4); imshow(diff_im);

% Label all the connected components in the image.
bw = bwlabel(diff_im, 8);
%figure(6); imshow(bw);
% Here we do the image blob analysis.
% We get a set of properties for each labeled region.
stats = regionprops(bw, 'BoundingBox', 'Centroid');
% Display the image


for i = 1:length(stats)
    %obtiene el centroide de cada punto azul de la imagen
    bc = stats(i).Centroid;    
    img(bc(2):bc(2)+20,bc(1):bc(1)+20,1) = 120; %a la capa roja en el pixel 30 al 30+20 X y 90 al 20 Y asignele 120
    img(bc(2):bc(2)+20,bc(1):bc(1)+20,2) = 152; %a la capa verde en el pixel 30 al 30+20 X y 90 al 20 Y asignele 152
    img(bc(2):bc(2)+20,bc(1):bc(1)+20,3) = 0; %a la capa azul en el pixel 30 al 30+20 X y 90 al 20 Y asignele 0
    
end

imshow(img)

