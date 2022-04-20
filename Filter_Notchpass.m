classdef Filter_Notchpass < AbstractFilter
    %FILTER_BandReject Filter that does BandReject filtering in the frequency
    %domain
    
    properties
        Name = 'Notchpass';
    end
    
    methods
        function obj = Filter_Notchpass()
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
            
            secondSettingName = 'xcenter';
            secondSettingDefault = 30;
            secondSettingBounds = [-Inf,Inf]; 
            secondSettingForceInteger = false; 
            secondSettingInclusivity = [false, false]; 
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);

            thirdSettingName = 'ycenter';
            thirdSettingDefault = 30;
            thirdSettingBounds = [-Inf, Inf]; 
            thirdSettingForceInteger = false; 
            thirdSettingInclusivity = [false,false]; 
            obj.Settings(3) = FilterSetting(thirdSettingName,...
                                            thirdSettingDefault,...
                                            thirdSettingBounds,...
                                            thirdSettingForceInteger,...
                                            thirdSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            D = settingValues('D');
            xcenter= settingValues('xcenter');
            ycenter=settingValues('ycenter');

            img_out = filterNotchpass(img_in,xcenter,ycenter,D);
        end
    end
end

