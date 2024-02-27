function [MSE_value,SAD_value,gradient_error,connectivity_error] = evaluation(Ip, Ir)
    MSE_value = MSE(Ip, Ir);
    SAD_value = SAD(Ip, Ir);
    gradient_error = GradientError(Ip, Ir);
    connectivity_error = ConnectivityError(Ip, Ir);
end