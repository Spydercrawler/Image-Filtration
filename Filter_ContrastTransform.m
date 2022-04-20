classdef Filter_ContrastTransform < AbstractFilter
    %FILTER_CONTRASTTRANSFORM Filter that does contrast transformations
    
    properties
        Name = 'Contrast Transformation';
    end
    
    methods
        function obj = Filter_ContrastTransform()
            % Create settings:
            firstSettingName = 'K';
            firstSettingDefault = 127; % Value of K should not be negative
            firstSettingBounds = [0,Inf]; % Value of K should not be negative
            firstSettingForceInteger = false; % Don't force K to be an integer
            firstSettingInclusivity = [true, true]; % Bounds are inclusive. K can be 0.
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
            secondSettingName = 'E';
            secondSettingDefault = 2;
            secondSettingBounds = [0,Inf]; % Value of E should not be negative
            secondSettingForceInteger = false; % Don't force E to be an integer
            secondSettingInclusivity = [true, true]; % Bounds are inclusive. E can be 0.
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            K = settingValues('K');
            E = settingValues('E');
            img_out = 1./(1+(K./(255*img_in)).^E);
        end
    end
end

