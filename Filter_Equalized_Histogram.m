classdef Filter_Equalized_Histogram < AbstractFilter
    %FILTER_CONTRASTTRANSFORM Filter that does contrast transformations
    
    properties
        Name = 'Equalized Histogram Transformation';
    end
    
    methods
        function obj = Filter_Equalized_Histogram()
            % Create settings:
            firstSettingName = 'Bins';
            firstSettingDefault = 100; % 
            firstSettingBounds = [2,256]; % values 2 to 256
            firstSettingForceInteger = true; % Must be integer
            firstSettingInclusivity = [true, true]; % Bounds are inclusive
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            b = settingValues('Bins');
            img_out = histeq(img_in,b);
        end
    end
end