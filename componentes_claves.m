function [ s,y,b,h ] = componentes_claves( a )
[fil,col,cap] = size(a);
a1 = chorizo(a);
a2 = rgb2hsv(a);a2=chorizo(a2);
s = a2(:,col+1:col*2);
cform = makecform('srgb2lab');
a3 = applycform(a,cform);a6=a3;
a3 = chorizo(a3);
b = a3(:,col*2+1:col*3);
cform = makecform('srgb2cmyk');
a4 = applycform(a,cform);k=a4(:,:,4);
a4=a4(:,:,1:3);
a4=chorizo(a4);a5 = [k,k,k];
y = a4(:,col*2+1:col*3);
cform = makecform('lab2lch');
a6 = applycform(a6,cform);
a6 = chorizo(a6);
h = a6(:,col*2+1:col*3);
end

