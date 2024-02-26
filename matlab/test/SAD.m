function sad = SAD(Ip, Ir)
    sad = sum(abs(Ir - Ip), "all");
end