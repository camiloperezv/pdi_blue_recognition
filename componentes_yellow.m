function y = componentes_yellow( a )
[fil,col,cap] = size(a);

cform = makecform('srgb2cmyk');
a4 = applycform(a,cform);k=a4(:,:,4);
a4=a4(:,:,1:3);
a4=layer(a4);a5 = [k,k,k];
y = a4(:,col*2+1:col*3);

end

