classdef Filter_EdgeTaper_Gaussian < AbstractFilter
    %FILTER_Filter_EdgeTaper_Gaussian - Gaussian Edge Taper
    
    properties
        Name = 'Gaussian Edge Taper';
    end
    
    methods
        function obj = Filter_EdgeTaper_Gaussian()
            % Create settings:
            firstSettingName = 'Kernel Size';
            firstSettingDefault = 30; % Value should not be negative
            firstSettingBounds = [0,100]; % Value of K should not be negative
            firstSettingForceInteger = true; % Force K to be an integer
            firstSettingInclusivity = [false, false]; % Bounds are not inclusive. K can not be 0.
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
            secondSettingName = 'Standard Deviation';
            secondSettingDefault = 2;
            secondSettingBounds = [0,6]; % Value of E should not be negative
            secondSettingForceInteger = false; % Don't force E to be an integer
            secondSettingInclusivity = [false, true]; % Bounds are partially inclusive. E can be 0.
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            k = settingValues('Kernel Size');
            sd = settingValues('Standard Deviation');
            filter=fspecial('gaussian',k,sd);
            img_out = edgetaper(img_in,filter);
        end
    end
end