function a = layer( b )
[fil, col, cap] = size(b);
c = reshape(b,[fil,col*cap]);
c = double(c);
c = c/max(c(:));
c = c*255; 
a = uint8(c);
end

