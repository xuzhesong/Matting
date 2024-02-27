function mse = MSE(Ip, Ir)
    Ir = rgb2gray(Ir);
    mse = mean((Ir - Ip).^2, "all");
end