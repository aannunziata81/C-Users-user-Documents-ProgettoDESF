function d = MyFitnessFunction(x)
[pv batt load] = parameter_pass();
delta_p = (pv * x(1) + batt * x(2)) - load;

d = sqrt(sum(delta_p.^2));

end


