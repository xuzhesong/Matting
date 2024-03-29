
function mse = MSE(Ip, Ir)
    if ndims(Ip) == 3
        Ip = rgb2gray(Ip);
    end
    if ndims(Ir) == 3
        Ir = rgb2gray(Ir);
    end
    Ir = double(rgb2gray(Ir));
    mse = mean((Ir - Ip).^2, "all");
end