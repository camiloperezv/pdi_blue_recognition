clear all; close all; clc
img = imread('hd.jpg');
size = 20;
cursorPositionX = 30;
cursorPositionY = 90;

img(cursorPositionX:cursorPositionX+size,cursorPositionY:cursorPositionY+size,1) = 120; %a la capa roja en el pixel 30 al 30+20 X y 90 al 20 Y asignele 120
img(cursorPositionX:cursorPositionX+size,cursorPositionY:cursorPositionY+size,2) = 152; %a la capa verde en el pixel 30 al 30+20 X y 90 al 20 Y asignele 152
img(cursorPositionX:cursorPositionX+size,cursorPositionY:cursorPositionY+size,3) = 0; %a la capa azul en el pixel 30 al 30+20 X y 90 al 20 Y asignele 0

imshow(img);impixelinfo;