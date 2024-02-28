function sad = SAD(Ip, Ir)
    if ndims(Ip) == 3
        Ip = rgb2gray(Ip);
    end
    if ndims(Ir) == 3
        Ir = rgb2gray(Ir);
    end
    Ir = rgb2gray(Ir);
    sad = sum(abs(Ir - Ip), "all");
end