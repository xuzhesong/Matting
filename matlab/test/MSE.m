function mse = MSE(Ip, Ir)
    mse = mean((Ir - Ip).^2, "all");
end