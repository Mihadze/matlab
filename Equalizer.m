classdef Equalizer < handle
    properties (Constant = true)
        freqArray (10,1) {double} = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000,16000];
    end
    properties (Access = public)
        gain (10,1) {double} = ones;
    end
    properties (GetAccess = public, SetAccess = protected)
        order (1,1) {double} = 64;
        fS (1,1) {double} = 44100;
    end
    properties (Access = protected)
        bBank {double};
        initB {double} = [];
    end

    methods
        function obj = Equalizer(order, fS)
            obj.order = order;
            obj.fS = fS;
            obj.CreateFilters();
        end

        function [signalOut, initB] = Filtering(obj,signal)
            b = sum(obj.gain .* obj.bBank, 1);
            [signalOut, initB] = filter(b, 1, signal, obj.initB);
        end

        function CreateFilters (obj)
            N = length(obj.freqArray);
            freqArrayNorm = obj.freqArray/(obj.fS/2);
            for i = 1:N
                if i == 1
                    mlow = [1, 1, 0, 0];
                    freqLow = [0, freqArrayNorm(1), 2*freqArrayNorm(1), 1];
                    obj.bBank = [obj.bBank; fir2(obj.order, freqLow, mlow)];
                elseif i == N
                    mHigh = [0, 0, 1, 1];
                    freqHigh = [0, freqArrayNorm(end)/2, freqArrayNorm(end), 1];
                    obj.bBank = [obj.bBank; fir2(obj.order, freqHigh, mHigh)];
                else
                    mBand = [0, 0, 1, 0, 0];
                    freqBand = [0, freqArrayNorm(i - 1), freqArrayNorm(i), freqArrayNorm(i + 1), 1];
                    obj.bBank = [obj.bBank; fir2(obj.order, freqBand, mBand)];
                end
            end
        end
            function [h, w] = GetFreqResponce(obj)
                b = sum(obj.gain.*obj.bBank);
                [H, w] = freqz(b, 1, obj.order);
                todB = @(x)20*log10(x);
                h = todB(abs(H));
                w = w/pi*obj.fS/2;
        end
    end
end
