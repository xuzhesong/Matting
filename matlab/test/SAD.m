function sad = SAD(Ir, Ip)
    sad = sum(abs(Ir - Ip), "all");
end