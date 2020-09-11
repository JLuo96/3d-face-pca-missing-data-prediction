function error = mae(x, y)
x = reshape(x, [47439, 3]);
y = reshape(y, [47439, 3]);
error = 0;
for k = 1 : 47439
    error = error + sqrt((x(k, 1) - y(k, 1))^2 + (x(k, 2) - y(k, 2))^2 + (x(k, 3) - y(k, 3))^2);
end
error = error / 47439;