function mse = MSE(Ir, Ip)
    mse = mean((Ir - Ip).^2, "all");
end