classdef Filter_Gaussian_Linear_Spatial < AbstractFilter
    %FILTER_Filter_Gaussian_LinearSpatial - Filter is Gaussian
    
    properties
        Name = 'Gaussian Linear Spatial Filter';
    end
    
    methods
        function obj = Filter_Gaussian_Linear_Spatial()
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
            img_out = imfilter(img_in,filter,'circular');
        end
    end
end