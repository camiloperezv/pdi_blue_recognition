function y = componentes_yellow( a )
[fil,col,cap] = size(a);

cform = makecform('srgb2cmyk');
a4 = applycform(a,cform);
a4=a4(:,:,1:3);
a4=layer(a4);
y = a4(:,col*2+1:col*3);

end

