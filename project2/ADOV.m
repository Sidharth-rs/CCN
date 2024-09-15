% MANET Simulation: AODV Routing Protocol with Grid-Based Topology

% Parameters
numNodesPerRow = 7; % Number of nodes per row in the grid
numRows = 7; % Number of rows in the grid
areaSize = 1000; % Size of the simulation area in meters
distanceThreshold = 150; % Threshold distance for neighbor detection in meters
simulationTime = 60; % Simulation time in seconds
maxHops = 5; % Maximum number of hops for route discovery
pauseTime = 0.1; % Pause time for visualization

% Generate node positions in a grid-based topology
[xGrid, yGrid] = meshgrid(linspace(0, areaSize, numNodesPerRow), linspace(0, areaSize, numRows));
nodePositions = [xGrid(:), yGrid(:)];

% Remove one node to get 49 nodes
numNodes = size(nodePositions, 1) - 1;
nodePositions = nodePositions(1:numNodes, :);

% Visualize network topology
scatter(nodePositions(:, 1), nodePositions(:, 2), 'filled');
xlim([0, areaSize]);
ylim([0, areaSize]);
title('Grid-Based Topology with 49 Nodes');
xlabel('X Position (m)');
ylabel('Y Position (m)');
grid on;

hold on; % Keep the current plot while adding new elements

% Initialize routing table for each node
routingTable = cell(numNodes, 1);

% Initialize route cache for each node
routeCache = cell(numNodes, numNodes);

% Define AODV routing functions (route discovery and route maintenance)

% Function for route discovery
routeRequestHelperRecursiveFunc = @(currentNode, destNode, visitedNodes, currentTime, remainingHops) ...
    routeRequestHelperRecursive(currentNode, destNode, visitedNodes, currentTime, remainingHops);

% Initialize variables to store route paths
routePaths = cell(0);
errorNodes = [];

% Simulation loop
for t = 1:simulationTime
    % Placeholder for node mobility
    nodePositions = updateNodePositions(nodePositions, areaSize, pauseTime);
    
    % Example: Call routeRequest at certain time intervals
    if mod(t, 5) == 0 % Route request every 5 seconds
        sourceNode = randi(numNodes);
        destNode = randi(numNodes);
        [path, error, replyMsg] = routeRequestHelperRecursiveFunc(sourceNode, destNode, [], t, maxHops);
        routePaths{end+1} = path;
        if error
            errorNodes(end+1) = sourceNode;
        end
        disp(replyMsg);
    end
    
    % Visualization: Update node positions and route paths
    scatter(nodePositions(:, 1), nodePositions(:, 2), 'filled');
    for i = 1:numel(routePaths)
        if ~isempty(routePaths{i})
            path = nodePositions(routePaths{i}, :);
            plot(path(:, 1), path(:, 2), 'k--');
        end
    end
    if ~isempty(errorNodes)
        scatter(nodePositions(errorNodes, 1), nodePositions(errorNodes, 2), 'r', 'filled');
    end
    xlim([0, areaSize]);
    ylim([0, areaSize]);
    title(['Grid-Based Topology with 49 Nodes - Time: ', num2str(t)]);
    xlabel('X Position (m)');
    ylabel('Y Position (m)');
    grid on;
    pause(pauseTime); % Pause to display updates
end
hold off; % Release the plot hold

% Dummy implementation of routeRequestHelperRecursive function
function [path, error, replyMsg] = routeRequestHelperRecursive(currentNode, destNode, visitedNodes, currentTime, remainingHops)
    % Placeholder for routeRequestHelperRecursive
    disp(['Route request from Node ', num2str(currentNode), ' to Node ', num2str(destNode), ' at time ', num2str(currentTime)]);
    
    % Simulate route error with some probability
    error = rand < 0.3;
    if error
        disp(['Route error encountered from Node ', num2str(currentNode), ' to Node ', num2str(destNode)]);
        replyMsg = ['Route from Node ', num2str(currentNode), ' to Node ', num2str(destNode), ' unsuccessful due to route error.'];
    else
        replyMsg = ['Route from Node ', num2str(currentNode), ' to Node ', num2str(destNode), ' completed successfully.'];
    end
    
    % Dummy path
    path = [currentNode, destNode];
    
    % Implement route discovery and maintenance logic here
    % Example: Check if destination is reached, update routing table, forward request to neighbors, etc.
end

% Dummy implementation of finding neighboring nodes
function neighborNodes = findNeighborNodes(currentNode)
    % Placeholder: Find neighboring nodes based on the grid topology
    % Assuming nodes are connected to adjacent nodes in the grid
    
    % Define the grid parameters
    numNodesPerRow = 7;
    numRows = 7;
    
    % Convert 1D index to 2D grid indices
    [row, col] = ind2sub([numRows, numNodesPerRow], currentNode);
    
    % Determine neighboring nodes
    neighborNodes = [];
    if row > 1
        neighborNodes = [neighborNodes, currentNode - numNodesPerRow]; % Node above
    end
    if row < numRows
        neighborNodes = [neighborNodes, currentNode + numNodesPerRow]; % Node below
    end
    if col > 1
        neighborNodes = [neighborNodes, currentNode - 1]; % Node to the left
    end
    if col < numNodesPerRow
        neighborNodes = [neighborNodes, currentNode + 1]; % Node to the right
    end
end

% Dummy implementation of node mobility
function updatedNodePositions = updateNodePositions(nodePositions, areaSize, pauseTime)
    % Placeholder for node mobility
    % Example: Nodes move randomly within the simulation area
    
    numNodes = size(nodePositions, 1);
    velocity = 10; % Constant velocity for all nodes
    
    % Randomly select new destinations for nodes
    newDestinations = rand(numNodes, 2) * areaSize;
    
    % Move nodes towards their new destinations
    displacement = (newDestinations - nodePositions) .* (velocity * pauseTime);
    
    % Update node positions
    nodePositions = nodePositions + displacement;
    
    % Ensure nodes stay within the simulation area
    nodePositions(nodePositions < 0) = 0;
    nodePositions(nodePositions > areaSize) = areaSize;
    
    updatedNodePositions = nodePositions;
end



