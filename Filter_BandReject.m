classdef Filter_BandReject < AbstractFilter
    %FILTER_BandReject Filter that does BandReject filtering in the frequency
    %domain
    
    properties
        Name = 'Band Reject';
    end
    
    methods
        function obj = Filter_BandReject()
            % Create settings:
            firstSettingName = 'C';
            firstSettingDefault = 128; 
            firstSettingBounds = [0,Inf]; 
            firstSettingForceInteger = false; 
            firstSettingInclusivity = [false, false]; 
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
            
            secondSettingName = 'W';
            secondSettingDefault = 30;
            secondSettingBounds = [0,Inf]; 
            secondSettingForceInteger = false; 
            secondSettingInclusivity = [false, false]; 
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);

            thirdSettingName = 'Gaussian';
            thirdSettingDefault = 0;
            thirdSettingBounds = [0,1]; % Gaussian flag is confined to two values
            thirdSettingForceInteger = true; 
            thirdSettingInclusivity = [true, true]; % Bounds are inclusive.
            obj.Settings(3) = FilterSetting(thirdSettingName,...
                                            thirdSettingDefault,...
                                            thirdSettingBounds,...
                                            thirdSettingForceInteger,...
                                            thirdSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            C = settingValues('C');
            W= settingValues('W');
            g = settingValues('Gaussian');
            img_out = filterBandreject(img_in,C,W,g);
        end
    end
end

