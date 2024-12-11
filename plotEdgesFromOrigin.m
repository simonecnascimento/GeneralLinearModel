function plotEdgesFromOrigin(G, origin)
    % PLOTEDGESFROMORIGIN Plots all edges of a directed graph as arrows from a single origin point.
    %
    % Input:
    %   G - A directed graph object (digraph)
    %   origin - [x, y] coordinates of the origin point for all arrows
    %
    % Example:
    %   s = [1 2 3 4];
    %   t = [2 3 4 1];
    %   G = digraph(s, t);
    %   plotEdgesFromOrigin(G, [0, 0]);

    % Ensure input is a digraph
    if ~isa(G, 'digraph')
        error('Input must be a digraph object.');
    end

    % Get the edges and nodes
    edges = G.Edges;
    nodes = G.Nodes;

    % Check if origin is valid
    if length(origin) ~= 2
        error('Origin must be a 2-element vector [x, y].');
    end

    % Randomly generate positions for each node (if positions are not predefined)
    numNodes = numnodes(G);
    positions = rand(numNodes, 2); % Change this to actual coordinates if available

    % Plot the edges as arrows originating from the same point
    figure;
    hold on;
    for i = 1:height(edges)
        % Get the source and target node indices
        srcIdx = findnode(G, edges.EndNodes{i, 1});
        tgtIdx = findnode(G, edges.EndNodes{i, 2});

        % Get the positions of the source and target nodes
        tgtPos = positions(tgtIdx, :);

        % Plot an arrow from the origin to the target node position
        quiver(origin(1), origin(2), tgtPos(1) - origin(1), tgtPos(2) - origin(2), ...
            0, 'MaxHeadSize', 0.5, 'Color', 'b', 'LineWidth', 1.5, 'AutoScale', 'on');
    end
    hold off;

    % Format the figure
    axis equal;
    xlabel('X');
    ylabel('Y');
    title('All Edges as Arrows from Origin');
end
