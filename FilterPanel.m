classdef FilterPanel < matlab.ui.componentcontainer.ComponentContainer
    %FILTERPANEL Summary of this class goes here
    %   Detailed explanation goes here
    
    events (HasCallbackProperty, NotifyAccess = protected)
        ValueChanged % ValueChangedFcn callback property will be generated
    end
    
    % Components
    properties (Access = private, Transient, NonCopyable)
        MainLayout matlab.ui.container.GridLayout
        TopLayout matlab.ui.container.GridLayout
        OptionDropdownLayout matlab.ui.container.GridLayout
        OptionLayout matlab.ui.container.GridLayout
        FilterTypeDropdown matlab.ui.control.DropDown
        FilterEnabledCheckbox matlab.ui.control.CheckBox
    end
    
    % Public properties (for dealing with heights)
    properties
        filterHeightUpdateFcn; % Callback function to update height of layout
        filterIndex; % Index of filter in list
        requestedHeight = 22; % Requested grid-layout row height for panel
    end
    
    % Filter info
    properties(Access = private)
        filterList = {  Filter_Nothing,...
                        Filter_ContrastTransform,...
                        Filter_Gaussian_Linear_Spatial,...
                        Filter_Sobel_Linear_Spatial,...
                        Filter_Prewitt_Linear_Spatial,...
                        Filter_Motion_Linear_Spatial,...
                        Filter_Log_Linear_Spatial,...
                        Filter_Laplacian_Linear_Spatial,...
                        Filter_Disk_Linear_Spatial,...
                        Filter_Average_Linear_Spatial,...
                        Filter_Sharpen,...
                        Filter_Equalized_Histogram,...
                        Filter_Log_Adjust,...
                        Filter_Bandpass,...
                        Filter_BandReject,...
                        Filter_Highpass,...
                        Filter_Lowpass,...
                        Filter_Notchpass,...
                        Filter_Notchreject,...
                        Filter_Deconvolve_Gaussian,...
                        Filter_Deconvolve_Disk,...
                        Filter_Deconvolve_Average,...
                        Filter_Deconvolve_Motion,...
                        Filter_EdgeTaper_Gaussian,...
                        Filter_EdgeTaper_Disk,...
                        Filter_EdgeTaper_Average};
        filterDropdownLabels cell = cell.empty
        filterDropdowns cell = cell.empty
        filterLabels cell = cell.empty
        filterSpinners cell = cell.empty
    end
    
    % UI Component methods
    methods (Access=protected)
        function setup(obj)
            % Set the initial position of this component
            % obj.Position = [100 100 150 22];
            
            % Change background color to make filters easier to distinguish
            obj.BackgroundColor = [0.9 0.9 0.9];
            
            % Create Layout
            obj.MainLayout = uigridlayout(obj,[2,1], ...
                'RowHeight',{'fit','fit','1x'},'ColumnWidth',{'1x'},...
                'Padding',0);
            
            % Get version. If version is greater than or equal to R2020b,
            % change gridlayout background color to make filters equal to
            % distinguish (gridlayouts do not have a background color
            % before R2020b and I want to make this R2020a compatible)
            if(contains(version,{'R2022b','R2022a','R2021b','R2021a','R2020b'}))
                obj.MainLayout.BackgroundColor = [0.9 0.9 0.9];
            end
            
            % Create top gridlayout for checkbox
            obj.TopLayout = uigridlayout(obj.MainLayout,[1,1],'RowHeight',...
                {'1x'},'ColumnWidth',{'fit','1x'},'Padding',0);
            obj.TopLayout.Layout.Row = 1;
            obj.TopLayout.Layout.Column = 1;
            if(contains(version,{'R2022b','R2022a','R2021b','R2021a','R2020b'}))
                obj.TopLayout.BackgroundColor = [0.9 0.9 0.9];
            end
            
            % Create dropdown that shows filter type
            obj.FilterTypeDropdown = uidropdown(obj.TopLayout);
            obj.FilterTypeDropdown.Items = obj.getFilterNames();
            obj.FilterTypeDropdown.ItemsData = obj.filterList;
            obj.FilterTypeDropdown.Value = obj.filterList{1};
            obj.FilterTypeDropdown.Layout.Row = 1;
            obj.FilterTypeDropdown.Layout.Column = 2;
            obj.FilterTypeDropdown.ValueChangedFcn = @obj.filterDropdownChanged;
            
            % Create checkbox that enables/disables filter
            obj.FilterEnabledCheckbox = uicheckbox(obj.TopLayout);
            obj.FilterEnabledCheckbox.Layout.Row = 1;
            obj.FilterEnabledCheckbox.Layout.Column = 1;
            obj.FilterEnabledCheckbox.Value = 1;
            obj.FilterEnabledCheckbox.Text = '';
            
            % Create layout for option dropdowns
            obj.OptionDropdownLayout = uigridlayout(obj.MainLayout,[1,1],...
                'RowHeight',{'1x'}, 'ColumnWidth',{'fit','1x'}, 'Padding',0);
            obj.OptionDropdownLayout.Layout.Row = 2;
            obj.OptionDropdownLayout.Layout.Column = 1;
            
            % Change background color of option dropdown layout if version allows
            if(contains(version,{'R2022b','R2022a','R2021b','R2021a','R2020b'}))
                obj.OptionDropdownLayout.BackgroundColor = [0.9 0.9 0.9];
            end
            
            % Create layout for options
            obj.OptionLayout = uigridlayout(obj.MainLayout,[1,1],...
                'RowHeight',{'1x'}, 'ColumnWidth',{'fit','1x'}, 'Padding',0);
            obj.OptionLayout.Layout.Row = 3;
            obj.OptionLayout.Layout.Column = 1;
            
            % Change background color of option layout if version allows
            if(contains(version,{'R2022b','R2022a','R2021b','R2021a','R2020b'}))
                obj.OptionLayout.BackgroundColor = [0.9 0.9 0.9];
            end
            
            % Setup UI for filter panel
            obj.updateDisplay();
        end
        
        function update(obj)
            % Do nothing
        end
    end
    
    % Publically accessible methods
    methods
        function img_out = process(obj,img_in)
            % If not enabled, return input image
            if(~obj.FilterEnabledCheckbox.Value)
                img_out = img_in;
                return;
            end
            
            % Get set values for filter settings
            filterValues = obj.getFilterValues();
            
            % Use the filter
            currentFilter = obj.FilterTypeDropdown.Value;
            img_out = currentFilter.process(img_in,filterValues);
        end
    end
    
    % Other methods
    methods (Access=protected)
        
        function filterDropdownChanged(obj,src,event)
            obj.updateDisplay();
        end
        
        function updateDisplay(obj)
            % Get filter information
            currentFilter = obj.FilterTypeDropdown.Value;
            numDropdowns = length(currentFilter.Dropdowns);
            numSettings = length(currentFilter.Settings);
            
            % Update number of rows to match number of settings
            obj.OptionDropdownLayout.RowHeight = repmat({22},1,max(numDropdowns,1));
            if(numDropdowns == 0)
                obj.OptionDropdownLayout.RowHeight = 0;
            end
            obj.OptionLayout.RowHeight = repmat({22},1,max(numSettings,1));
            if(numSettings == 0)
                obj.OptionLayout.RowHeight = 0;
            end
            
            % Remove previous dropdown labels and dropdowns
            for i = 1:length(obj.filterDropdownLabels)
                delete(obj.filterDropdownLabels{i});
            end
            for i = 1:length(obj.filterDropdowns)
                delete(obj.filterDropdowns{i});
            end
            obj.filterDropdownLabels = cell(1,numDropdowns);
            obj.filterDropdowns = cell(1,numDropdowns);
            
            % Remove previous labels and spinners
            for i = 1:length(obj.filterLabels)
                delete(obj.filterLabels{i});
            end
            for i = 1:length(obj.filterSpinners)
                delete(obj.filterSpinners{i});
            end
            obj.filterLabels = cell(1,numSettings);
            obj.filterSpinners = cell(1,numSettings);
            
            % Create new dropdown labels and dropdowns for each dropdown
            for i = 1:numDropdowns
                % Make label showing dropdown name
                obj.filterDropdownLabels{i} = uilabel(obj.OptionDropdownLayout);
                obj.filterDropdownLabels{i}.Layout.Row = i;
                obj.filterDropdownLabels{i}.Layout.Column = 1;
                obj.filterDropdownLabels{i}.Text = ...
                    [currentFilter.Dropdowns(i).Name,':'];
                
                % Make dropdown allowing value selection
                obj.filterDropdowns{i} = uidropdown(obj.OptionDropdownLayout);
                obj.filterDropdowns{i}.Layout.Row = i;
                obj.filterDropdowns{i}.Layout.Column = 2;
                obj.filterDropdowns{i}.Items = ...
                    currentFilter.Dropdowns(i).Items;
                if(currentFilter.Dropdowns(i).isItemsDataSet_)
                    obj.filterDropdowns{i}.ItemsData = ...
                        currentFilter.Dropdowns(i).ItemsData;
                end
                
                if(currentFilter.Dropdowns(i).isDefaultValueSet_)
                    obj.filterDropdowns{i}.DefaultValue = ...
                        currentFilter.Dropdowns(i).DefaultValue;
                end
            end
            
            % Create new labels and spinners for each setting
            for i = 1:numSettings
                % Make label showing setting name
                obj.filterLabels{i} = uilabel(obj.OptionLayout);
                obj.filterLabels{i}.Layout.Row = i;
                obj.filterLabels{i}.Layout.Column = 1;
                obj.filterLabels{i}.Text = [currentFilter.Settings(i).Name,':'];
                
                % Make spinner allowing value selection
                obj.filterSpinners{i} = uispinner(obj.OptionLayout);
                obj.filterSpinners{i}.Layout.Row = i;
                obj.filterSpinners{i}.Layout.Column = 2;
                obj.filterSpinners{i}.Value = currentFilter.Settings(i).Default;
                obj.filterSpinners{i}.Limits = currentFilter.Settings(i).Bounds;
                if(currentFilter.Settings(i).ForceInteger)
                    obj.filterSpinners{i}.RoundFractionalValues = 'on';
                else
                    obj.filterSpinners{i}.RoundFractionalValues = 'off';
                end
                if(currentFilter.Settings(i).Inclusivity(1))
                    obj.filterSpinners{i}.LowerLimitInclusive = 'on';
                else
                    obj.filterSpinners{i}.LowerLimitInclusive = 'off';
                end
                if(currentFilter.Settings(i).Inclusivity(2))
                    obj.filterSpinners{i}.UpperLimitInclusive = 'on';
                else
                    obj.filterSpinners{i}.UpperLimitInclusive = 'off';
                end
            end
            
            % Calculate height of grid layout
            obj.requestedHeight = 22 + 22*numSettings + 22*numDropdowns + ...
                10*max(numSettings-1,0) + 10*max(numDropdowns-1,0) + ...
                10*(numSettings > 0 && numDropdowns > 0) + 10*(numSettings > 0 || numDropdowns > 0);
                % ^ This final conditional thing deals with 10 pixel row
                % spacing between last dropdown and first spinner
            
            % Use filter height callback to update filter height in list
            if(~isempty(obj.filterIndex))
                obj.filterHeightUpdateFcn(obj.filterIndex,obj.requestedHeight);
            end
        end
        
        function valueMap = getFilterValues(obj)
            settingNames = {};
            settingValues = {};
            
            % If no settings, return empty list to save time
            if(isempty(obj.filterSpinners) && isempty(obj.filterDropdowns))
                valueMap = [];
                return;
            end
            
            % Obtain numerical setting values
            if(~isempty(obj.filterSpinners))
                currentFilter = obj.FilterTypeDropdown.Value;
                
                settingNames = cell(1,length(currentFilter.Settings));
                settingValues = zeros(1,length(currentFilter.Settings));
                for i = 1:length(currentFilter.Settings)
                    settingNames{i} = currentFilter.Settings(i).Name;
                    settingValues(i) = obj.filterSpinners{i}.Value;
                end
                
                % Convert setting values to cell array so that dropdown
                % values can be added
                settingValues = num2cell(settingValues);
            end
            
            % Obtain dropdown setting values
            if(~isempty(obj.filterDropdowns))
                currentFilter = obj.FilterTypeDropdown.Value;
                
                dropdownNames = cell(1,length(currentFilter.Dropdowns));
                dropdownValues = cell(1,length(currentFilter.Dropdowns));
                for i = 1:length(currentFilter.Dropdowns)
                    dropdownNames{i} = currentFilter.Dropdowns(i).Name;
                    dropdownValues{i} = obj.filterDropdowns{i}.Value;
                end
                
                % Append to settings cell array
                settingNames = [settingNames, dropdownNames];
                settingValues = [settingValues, dropdownValues];
            end
            
            valueMap = containers.Map(settingNames,settingValues);
        end
        
        function filterNames = getFilterNames(obj)
            filterNames = cell(size(obj.filterList));
            for i = 1:length(obj.filterList)
                filterNames{i} = obj.filterList{i}.Name;
            end
        end
    end
end

