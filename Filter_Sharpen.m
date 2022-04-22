classdef Filter_Sharpen < AbstractFilter
    %FILTER_CONTRASTTRANSFORM Filter that does contrast transformations
    
    properties
        Name = 'Sharpen Image';
    end
    
    methods
        function obj = Filter_Sharpen()
            % Create settings:
            firstSettingName = 'Radius';
            firstSettingDefault = 1; % 
            firstSettingBounds = [0,Inf]; % Value should not be negative
            firstSettingForceInteger = true; % 
            firstSettingInclusivity = [false, false]; % 
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
            secondSettingName = 'Amount';
            secondSettingDefault = 0.8;
            secondSettingBounds = [0,2]; % 
            secondSettingForceInteger = false; % 
            secondSettingInclusivity = [false, false]; % 
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);
            thirdSettingName = 'Threshold';
            thirdSettingDefault = 0;
            thirdSettingBounds = [0,1]; % 
            thirdSettingForceInteger = false; % Don't force E to be an integer
            thirdSettingInclusivity = [true, true]; % Bounds are inclusive. E can be 0.
            obj.Settings(3) = FilterSetting(thirdSettingName,...
                                            thirdSettingDefault,...
                                            thirdSettingBounds,...
                                            thirdSettingForceInteger,...
                                            thirdSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            r = settingValues('Radius');
            a = settingValues('Amount');
            t = settingValues('Threshold');
            img_out = imsharpen(img_in,'Radius',r,'Amount',a,'Threshold',t);
        end
    end
end