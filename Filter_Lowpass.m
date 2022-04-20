classdef Filter_Lowpass < AbstractFilter
    %FILTER_LOWPASS Filter that does lowpass filtering in the frequency
    %domain
    
    properties
        Name = 'Lowpass';
    end
    
    methods
        function obj = Filter_Lowpass()
            % Create settings:
            firstSettingName = 'D';
            firstSettingDefault = 30; % Value of D should not be negative
            firstSettingBounds = [0,Inf]; 
            firstSettingForceInteger = false; % Don't force D to be an integer
            firstSettingInclusivity = [false, false]; % D cannot be zero and have an image, it cannot be infinity 
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
            secondSettingName = 'Gaussian';
            secondSettingDefault = 0;
            secondSettingBounds = [0,1]; % Gaussian flag is confined to two values
            secondSettingForceInteger = true; 
            secondSettingInclusivity = [true, true]; % Bounds are inclusive.
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            D = settingValues('D');
            g = settingValues('Gaussian');
            img_out = filterLowpass(img_in,D,g);
        end
    end
end

