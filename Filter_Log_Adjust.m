classdef Filter_Log_Adjust < AbstractFilter
    %FILTER_Log_Adjust
    
    properties
        Name = 'Log Adjustment';
    end
    
    methods
        function obj = Filter_Log_Adjust()
            % Create settings:
            firstSettingName = 'Multiplicative Constant';
            firstSettingDefault = 5; % Value of K should not be negative
            firstSettingBounds = [1,Inf]; %
            firstSettingForceInteger = false; % Don't force it to be an integer
            firstSettingInclusivity = [true, false]; % 
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            mc = settingValues('Multiplicative Constant');
            img_out = mat2gray(mc*log(1+double(img_in)));
        end
    end
end