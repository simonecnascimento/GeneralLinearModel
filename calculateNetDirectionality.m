function T = calculateNetDirectionality(G)
    % CALCULATENETDIRECTIONALITY Computes the in-degree, out-degree, 
    % and net directionality for each node in a directed graph.
    %
    % Input:
    %   G - A directed graph object (digraph)
    %
    % Output:
    %   T - A table containing:
    %       - Node: The node number
    %       - InDegree: Number of edges entering the node
    %       - OutDegree: Number of edges leaving the node
    %       - NetDirectionality: OutDegree - InDegree
    
    % Ensure input is a digraph
    if ~isa(G, 'digraph')
        error('Input must be a digraph object.');
    end

    % Calculate in-degrees and out-degrees
    inDeg = indegree(G);
    outDeg = outdegree(G);

    % Calculate net directionality for each node
    netDirectionality = outDeg - inDeg;

    % Create a table with the results
    T = table((1:numnodes(G))', inDeg, outDeg, netDirectionality, ...
        'VariableNames', {'Node', 'InDegree', 'OutDegree', 'NetDirectionality'});

    % Display the table
    disp(T);
end
