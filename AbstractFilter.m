classdef AbstractFilter < handle
    %ABSTRACTFILTER Abstract class for a filter
    
    properties(Abstract)
        Name char
    end
    
    properties
        Settings FilterSetting = FilterSetting.empty;
        ImageWidth
        ImageHeight
    end
    
    methods (Abstract)
        img_out = process(obj,img_in,settingValues); % Filters an inputted image
        % img_in = input image
        % settingValues = containers.Map containing values of each setting.
        % To get a setting titled 'SettingName', access
        % settingValues('SettingName').
        %
        % img_out = output image, after filtration
        %
        % Assume both input and output images are doubles.
    end
end

