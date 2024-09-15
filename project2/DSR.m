% Parameters
gridSize = 1000; % in meters
numNodes = 49;
numRows = sqrt(numNodes);
numCols = sqrt(numNodes);
nodeSpacingX = gridSize / (numCols + 1);
nodeSpacingY = gridSize / (numRows + 1);
numSteps = 100; % Number of simulation steps
pauseTime = 0.1; % Pause time between steps in seconds
dataGenerationRate = 0.1; % Rate of data generation (0.1 data packets per node per step)

% Initialize nodes with grid-based positions
nodes = struct('id', {}, 'x', {}, 'y', {}, 'speed', {}, 'direction', {}, 'routeTable', {});
for row = 1:numRows
    for col = 1:numCols
        nodeID = (row - 1) * numCols + col;
        nodes(nodeID).id = nodeID;
        nodes(nodeID).x = col * nodeSpacingX;
        nodes(nodeID).y = row * nodeSpacingY;
        nodes(nodeID).speed = 1 + rand * 4; % Random speed between 1 and 5 m/s
        nodes(nodeID).direction = rand * 2 * pi; % Random direction
        nodes(nodeID).routeTable = []; % Initialize route table
    end
end

% Main simulation loop
for step = 1:numSteps
    % Move nodes using random waypoint mobility model
    for i = 1:numNodes
        if rand < 0.1 % With 10% probability, select new random destination
            nodes(i).x = rand * gridSize;
            nodes(i).y = rand * gridSize;
        end
        
        % Update node position based on speed and direction
        nodes(i).x = nodes(i).x + nodes(i).speed * cos(nodes(i).direction);
        nodes(i).y = nodes(i).y + nodes(i).speed * sin(nodes(i).direction);
        
        % Ensure nodes stay within the grid
        nodes(i).x = max(0, min(nodes(i).x, gridSize));
        nodes(i).y = max(0, min(nodes(i).y, gridSize));
    end
    
    % Generate data packets at random nodes
    for i = 1:numNodes
        if rand < dataGenerationRate
            disp(['Node ', num2str(i), ' generates data packet.']);
            % Simulate data packet forwarding
            destination = randi(numNodes);
            disp(['Node ', num2str(i), ' forwards data packet to Node ', num2str(destination), '.']);
            
            % Implement routing logic here
            % For demonstration, just displaying communication
            disp(['Communication: Node ', num2str(i), ' -> Node ', num2str(destination)]);
        end
    end
    
    % Pause for visualization
    pause(pauseTime);
    
    % Visualization (plot nodes)
    clf; % Clear previous plot
    hold on;
    for i = 1:numNodes
        plot(nodes(i).x, nodes(i).y, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
        text(nodes(i).x, nodes(i).y, num2str(nodes(i).id));
    end
    xlim([0, gridSize]);
    ylim([0, gridSize]);
    title(['Step ', num2str(step)]);
    hold off;
end













