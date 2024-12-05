function plotCellDistanceNetwork(data_CFU, data_analysis, simultaneousMatrixDelaybyCell2, simultaneousMatrixDelaybyCell_average2)
    % Function to plot a directed graph representing cell distance networks
    % Inputs:
    % - data_CFU: Data containing cell coordinates
    % - data_analysis: Analysis data including perivascularCells
    % - simultaneousMatrixDelaybyCell2: Cell array with edge weights
    % - simultaneousMatrixDelaybyCell_average2: Cell array with adjacency matrix values
    
    % Extract cell coordinates
    cellCoords = [data_CFU.cfuInfo1(:,1), data_CFU.cfuInfo1(:,3)];
    numCells = size(cellCoords, 1);
    
    % Compute cell centers
    centers_allCells = [];
    for i = 1:numCells
        [rows1, cols1] = find(cellCoords{i,2} ~= 0); % Extract coordinates of non-zero elements
        centers = [mean(rows1), mean(cols1)]; % Compute center coordinates
        centers_allCells = [centers_allCells; centers];
    end
    
    % Nodes, edges, and weights
    edgeWeights = simultaneousMatrixDelaybyCell2;
    connectionsMatrix = simultaneousMatrixDelaybyCell_average2;

    % Calculate edge weights based on the number of elements in each cell
    numericWeights = cellfun(@(c) numel(c), edgeWeights);

    % Process adjacency matrix
    adjMatrix = cell2mat(connectionsMatrix);
    adjMatrix(isnan(adjMatrix)) = 0; % Replace NaN with 0
    adjMatrix(numericWeights < 2) = 0; % Remove edges with weights < 2

    % Create directed graph
    G = digraph(adjMatrix);

    % Identify nodes with single appearance
    endNodes = G.Edges.EndNodes;
    allNodes = endNodes(:);
    nodeCounts = histcounts(allNodes, 1:(max(allNodes)+1));
    nodesWithSingleAppearance = find(nodeCounts == 1);

    % Find indices of edges connected to nodes with single appearance
    rowsWithSingleAppearance = [];
    for i = 1:length(nodesWithSingleAppearance)
        node = nodesWithSingleAppearance(i);
        indices = find(endNodes(:, 1) == node | endNodes(:, 2) == node);
        rowsWithSingleAppearance = [rowsWithSingleAppearance; indices];
    end

    % Set up figure
    digraphFig = figure;
    axesHandle = axes;
    set(axesHandle, 'Color', 'w');
    hold(axesHandle, 'on');
    
    % Plot graph
    h = plot(G, 'XData', centers_allCells(:, 2), 'YData', centers_allCells(:, 1));
    h.MarkerSize = 5;
    h.ArrowSize = 30;
    h.NodeFontSize = 25;
    h.EdgeColor = [0.7, 0.7, 0.7];

    % Set line thickness for edges
    validWeights = numericWeights(numericWeights >= 2);
    h.LineWidth = validWeights * 2;

    % Assign node colors
    perivascular = data_analysis.perivascularCells;
    nodeTypes = ismember(1:numCells, perivascular);
    nodeColors = 2 * (~nodeTypes); % Red (0) or Blue (2)
    colormap(axesHandle, [1 0 0; 0 0 1]);
    h.NodeCData = nodeColors;

    % Adjust axis
    title('Cell Distance Network on Image Frame');
    set(gca, 'YDir', 'reverse');
    xlim([1, 626]);
    ylim([1, 422]);

    % Annotate edges with weights and style
    for i = 1:numedges(G)
        source = G.Edges.EndNodes(i, 1);
        target = G.Edges.EndNodes(i, 2);
        sourceCoord = h.XData(source);
        targetCoord = h.XData(target);
        ySourceCoord = h.YData(source);
        yTargetCoord = h.YData(target);
        midpointX = (sourceCoord + targetCoord) / 2;
        midpointY = (ySourceCoord + yTargetCoord) / 2;
        edgeWeight = G.Edges.Weight(i);
        edgeWeightInt = round(edgeWeight);

        % Check if edge is dashed
        if ismember(i, rowsWithSingleAppearance)
            line([sourceCoord, targetCoord], [ySourceCoord, yTargetCoord], ...
                'LineStyle', '--', 'LineWidth', 2, 'Color', 'k');
        end

        % Display weight
        text(midpointX, midpointY, num2str(edgeWeightInt), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
            'FontSize', 12, 'Color', 'k');
    end
    hold off;
end
