classdef Filter_DropdownTest < AbstractFilter
    %FILTER_DROPDOWNTEST Dropdown test filter
    % When the "Action" dropdown is set to "Black", returns a black image.
    % When the "Action" dropdown is set to "Gray", returns a gray image
    %   with a constant value set by the spinner.
    % When the "Action" dropdown is set to "histeq", does histogram
    %   equalization
    
    properties
        Name = 'Dropdown Test';
    end
    
    methods
        function obj = Filter_DropdownTest()
            % Create dropdowns
            firstDropdownName = 'Action';
                % Items = values displayed in the dropdown to the user
            
            firstDropdownItems = {'Black','Gray','histeq'};
            % Can also specify an 'ItemsData' and 'DefaultValue'.
            % 'ItemsData' is same size as 'Items' array and gives the
            %   actual values that are passed into the 'process' method when
            %   an item is selected. 
            % 'DefaultValue' gives the default selected item.
            obj.Dropdowns(1) = FilterDropdownSetting(firstDropdownName,firstDropdownItems);
            
            % Create settings:
            firstSettingName = 'Gray Value';
            firstSettingDefault = 127; % Value of K should not be negative
            firstSettingBounds = [0,255]; % Value of K should not be negative
            firstSettingForceInteger = false; % Don't force K to be an integer
            firstSettingInclusivity = [true, true]; % Bounds are inclusive. K can be 0.
            obj.Settings(1) = FilterSetting(firstSettingName,...
                                            firstSettingDefault,...
                                            firstSettingBounds,...
                                            firstSettingForceInteger,...
                                            firstSettingInclusivity);
        end
        
        function img_out = process(obj,img_in,settingValues)
            Action = settingValues('Action');
            grayValue = settingValues('Gray Value');
            
            switch Action
                case 'Black'
                    img_out = zeros(size(img_in));
                case 'Gray'
                    img_out = ones(size(img_in)) * grayValue / 255;
                case 'histeq'
                    img_out = histeq(img_in);
                otherwise
                    img_out = ones(size(img_in)); % White to show error
            end
        end
    end
end

