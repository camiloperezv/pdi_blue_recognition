

% Get the snapshot of the current frame
data = imread('me.png');
figure(1);imshow(data);
% we have to subtract the blue component 
% from the grayscale image to extract the blue components in the image.
diff_im = imsubtract(data(:,:,3), rgb2gray(data));
figure(2);imshow(diff_im);
%Use a median filter to filter out noise
%each pixel became the median value in a 3-by-3 neighborhood 
diff_im = medfilt2(diff_im, [3 3]);
figure(3);imshow(diff_im);
% Convert the resulting grayscale image into a binary image.
% reference https://la.mathworks.com/help/images/ref/im2bw.html 
diff_im = im2bw(diff_im,0.18);
diff_imbinary = diff_im;
figure(4);imshow(diff_im);

% Remove all objects who have pixels less than 300px in a binary image
diff_im = bwareaopen(diff_im,300);
figure(5);imshow(diff_im);
% Label all the connected components in the image.
bw = bwlabel(diff_im, 8);
figure(6);imshow(diff_im);
% Here we do the image blob analysis.
% We get a set of properties for each labeled region.
stats = regionprops(bw, 'BoundingBox', 'Centroid');

figure(7);imshow(data);
hold on
%This is a loop to bound the red objects in a rectangular box.
for object = 1:length(stats)
    bb = stats(object).BoundingBox;
    bc = stats(object).Centroid;
    %drawObj = [drawObj;[bc(2),bc(1)]];
    rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
    plot(bc(1),bc(2), '-m+')
    a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
    set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
end
hold off

