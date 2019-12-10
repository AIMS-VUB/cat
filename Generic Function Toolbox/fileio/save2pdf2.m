function save2pdf2(InputFigureHandle, OutFileName, ShouldPrintAxes)
% SaveFigureAsVectorPDF Saves a figure as a pdf file.
 %   InputFigureHandle must contain exactly one figure handle
 %   OutFileName must contain exactly one OutFileName
 %   ShouldPrintAxes must be a boolean true / false that determines if the axes should be printed.
    %% Check input parameters
    NumberOfFigures = numel(InputFigureHandle);    

    if(NumberOfFigures ~= 1)
        error('This function only supports one figure handle.');
    end

    if(isempty(OutFileName))
        error('No file path provided to save the figure to.');
    end
    
    if nargin < 3
      ShouldPrintAxes = 1;
    end

    cUnit = 'centimeters';

    %% Copy the input figure so we can mess with it    
    %Make a copy of the figure so we don't modify the properties of the
    %original.
    FigureHandleCopy = copy(InputFigureHandle);

    %NOTE:  Do not set this figure to be invisible, for some bizarre reason
    %       it must be visible otherwise Matlab will just ignore attempts 
    %       to set its properties.
    % 
    %       I would prefer it if the figure did not briefly flicker into
    %       view but I am not sure how to prevent that.

    %% Find the axis handle
    ChildAxisHandles     = get(FigureHandleCopy, 'Children');
    NumberOfChildFigures = length(ChildAxisHandles);

    if(NumberOfChildFigures ~= 1)
       %note that every plot has at least one child figure
       error('This function currently only supports plots with one child figure.');
    end

    AxisHandle = ChildAxisHandles(1);

    %% Set Units
    % It doesn't matter what unit you choose as long as it's the same for
    % the figure, axis, and paper. Note that 'PaperUnits' unfortunately
    % does not support 'pixels' units.

    set(FigureHandleCopy,   'PaperUnits',   cUnit);
    set(FigureHandleCopy,   'Unit',         cUnit);
    set(AxisHandle,         'Unit',         cUnit); 

    %% Get old axis position and inset offsets 
    %Note that the axes and title are contained in the inset
    OldAxisPosition = get(AxisHandle,   'Position');
    OldAxisInset    = get(AxisHandle,   'TightInset');

    OldAxisWidth    = OldAxisPosition(3);
    OldAxisHeight   = OldAxisPosition(4);

    OldAxisInsetLeft    = OldAxisInset(1);
    OldAxisInsetBottom  = OldAxisInset(2);
    OldAxisInsetRight   = OldAxisInset(3);
    OldAxisInsetTop     = OldAxisInset(4);

    %% Set positions and size of the figure and the Axis 
    if(~ShouldPrintAxes)
        FigurePosition = [0.0, 0.0, OldAxisWidth, OldAxisHeight];

        PaperSize = [OldAxisWidth, OldAxisHeight];

        AxisPosition = FigurePosition;
    else
        WidthWithInset  = OldAxisWidth   + OldAxisInsetLeft + OldAxisInsetRight;
        HeightWithInset = OldAxisHeight  + OldAxisInsetTop  + OldAxisInsetBottom;

        FigurePosition = [0.0, 0.0, WidthWithInset,  HeightWithInset];

        PaperSize = [WidthWithInset, HeightWithInset];

        AxisPosition = [OldAxisInsetLeft, OldAxisInsetBottom, OldAxisWidth, OldAxisHeight];
    end

    set(FigureHandleCopy,   'Position', FigurePosition);
    set(AxisHandle,         'Position', AxisPosition);

    %Note:  these properties do not effect the preview but they are
    %       absolutely necessary for the pdf!!
    set(FigureHandleCopy,   'PaperSize',        PaperSize);
    set(FigureHandleCopy,   'PaperPosition',    FigurePosition);

    %% Write the figure to the PDF file
    print('-dpdf', OutFileName);

    set(FigureHandleCopy, 'name', 'PDF Figure Preview', 'numbertitle', 'off');

    %If you want to see the figure (e.g., for debugging purposes), comment
    %the line below out.
    close(FigureHandleCopy);
end