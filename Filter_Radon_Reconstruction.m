classdef Filter_Radon_Reconstruction < AbstractFilter
    %FILTER_DROPDOWNTEST Dropdown test filter
    % When the "Action" dropdown is set to "Black", returns a black image.
    % When the "Action" dropdown is set to "Gray", returns a gray image
    %   with a constant value set by the spinner.
    % When the "Action" dropdown is set to "histeq", does histogram
    %   equalization
    
    properties
        Name = 'Radon Reconstruction';
    end
    
    methods
        function obj = Filter_Radon_Reconstruction()
            % Create dropdowns
            firstDropdownName = 'Interpolation Method';
                % Items = values displayed in the dropdown to the user
            
         
            
            % Create settings:
            firstSettingName = 'Theta';
            firstSettingDefault = 179; % Value of K should not be negative
            firstSettingBounds = [0,180]; % Value of K should not be negative
            firstSettingForceInteger = true; % Don't force K to be an integer
            firstSettingInclusivity = [false, true]; % Bounds are inclusive. K can be 0.
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
            secondSettingName = 'Theta Step Size';
            secondSettingDefault = 1; % Value of K should not be negative
            secondSettingBounds = [0.001,100]; % Value of K should not be negative
            secondSettingForceInteger = false; % Don't force K to be an integer
            secondSettingInclusivity = [true, true]; % Bounds are inclusive. K can be 0.
            obj.Settings(2) = FilterSetting(secondSettingName,...
                                            secondSettingDefault,...
                                            secondSettingBounds,...
                                            secondSettingForceInteger,...
                                            secondSettingInclusivity);
            
        end
        
        function img_out = process(obj,img_in,settingValues)
            theta_max=settingValues('Theta');
            theta_step_size=settingValues('Theta Step Size');
            theta=0:theta_step_size:theta_max;
            intermed=radon(img_in,theta);
            img_out=(intermed-min(intermed,[],'all'))/(max(intermed,[],'all')-min(intermed,[],'all'));
        end
    end
end

