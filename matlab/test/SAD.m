function sad = SAD(Ip, Ir)
    Ir = rgb2gray(Ir);
    sad = sum(abs(Ir - Ip), "all");
end