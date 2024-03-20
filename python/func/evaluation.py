from func import MSE
from func import SAD
from func import gradient_error
from func import connectivity_error

def evaluation(Ip, Ir):
    # Assuming MSE, SAD, gradient_error, and connectivity_error functions are already defined
    MSE_value = MSE.MSE(Ip, Ir)
    SAD_value = SAD.SAD(Ip, Ir)
    gradient_error_value = gradient_error.gradient_error(Ip, Ir)
    # connectivity_error_value = connectivity_error.connectivity_error(Ip, Ir)  # This function's implementation depends on context

    return MSE_value, SAD_value, gradient_error_value#, connectivity_error_value
