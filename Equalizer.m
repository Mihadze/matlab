classdef Equalizer < handle
    properties(Constant = true)
        freqArray(10,1){double} = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000];
    end
    properties(Access = public)
        gain(10,1){double} = ones;
    end
    properties(GetAccess = public, SetAccess = protected)
        order(10,1){double} = 64;
        fS(1,1){double} = 44100;
    end
    properties(Access = protected)
        bBank{double};
        initB{double} = [];
    end
    methods
        function obj = Equalizer(order, fS)
            obj.order = order;
            obj.fS = fS;
            obj.bBank = zeros(lengyh)
        end
    end
end

