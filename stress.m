function stress(type, t)

switch type
    case 'cpu'
        nb_cores = feature('numCores');
        for i=1:nb_cores*2
            system(sprintf('python stress.py cpu %d &', t));
        end
    case 'memory'
        system(sprintf('python stress.py memory %d &', t));
end