classdef Filter_Inverse_Radon_Reconstruction < AbstractFilter
    %FILTER_DROPDOWNTEST Dropdown test filter
    % When the "Action" dropdown is set to "Black", returns a black image.
    % When the "Action" dropdown is set to "Gray", returns a gray image
    %   with a constant value set by the spinner.
    % When the "Action" dropdown is set to "histeq", does histogram
    %   equalization
    
    properties
        Name = 'Inverse Radon Reconstruction';
    end
    
    methods
        function obj = Filter_Inverse_Radon_Reconstruction()
            % Create dropdowns
            firstDropdownName = 'Interpolation Method';
                % Items = values displayed in the dropdown to the user
            
            firstDropdownItems = {'Linear','Nearest','Cubic','Spline'};
            % Can also specify an 'ItemsData' and 'DefaultValue'.
            % 'ItemsData' is same size as 'Items' array and gives the
            %   actual values that are passed into the 'process' method when
            %   an item is selected. 
            % 'DefaultValue' gives the default selected item.
            obj.Dropdowns(1) = FilterDropdownSetting(firstDropdownName,firstDropdownItems);
            
            secondDropdownName = 'Filter';
            secondDropdownItems = {'None','Ram-Lak','Shepp-Logan','Cosine','Hamming','Hann'};
            % Can also specify an 'ItemsData' and 'DefaultValue'.
            % 'ItemsData' is same size as 'Items' array and gives the
            %   actual values that are passed into the 'process' method when
            %   an item is selected. 
            % 'DefaultValue' gives the default selected item.
            obj.Dropdowns(2) = FilterDropdownSetting(secondDropdownName,secondDropdownItems);
            
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
            thirdSettingName = 'Frequency Scaling';
            thirdSettingDefault = 1; % Value of K should not be negative
            thirdSettingBounds = [0,1]; % Value of K should not be negative
            thirdSettingForceInteger = false; % Don't force K to be an integer
            thirdSettingInclusivity = [false, true]; % Bounds are inclusive. K can be 0.
            obj.Settings(3) = FilterSetting(thirdSettingName,...
                                            thirdSettingDefault,...
                                            thirdSettingBounds,...
                                            thirdSettingForceInteger,...
                                            thirdSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            theta_max=settingValues('Theta');
            theta_step_size=settingValues('Theta Step Size');
            theta=0:theta_step_size:theta_max;
            f=settingValues('Frequency Scaling');
            Imethod=settingValues('Interpolation Method');
            filter=settingValues('Filter');
            intermed=iradon(img_in,theta,Imethod,filter,f);
            img_out=(intermed-min(intermed,[],'all'))/(max(intermed,[],'all')-min(intermed,[],'all'));
        end
    end
end

