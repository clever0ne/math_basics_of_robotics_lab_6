function [route, numExpanded] = DijkstraGrid(input_map, start_coords, dest_coords, drawMap)
    % ������ ��������� �������� �� �����

    % ������� ������: 
    %     input_map: ���������� ������, � ������� ��������� ������ = 0 (false), ����������� = 1 (true)
    %     start_coords and dest_coords: ���������� (������, �������) ��������� � �������� ������

    % �������� ������:
    %      route : ���������� ������ �������� �������� ���� ������, ��������������� ����������� ���� (����, ���� ���� �� ����������)
    %      numExpanded: ����� ����� ������, ��������������� � ������ (�������� ����� �� ������ � ��� �����)

    % ��������� �������� ����� ��� ������ �����
    % 1 - white -- ��������� ������
    % 2 - black -- �����������
    % 3 - red -- ���������� ������
    % 4 - blue  -- ������ �� ������ ���������������
    % 5 - green -- ��������� ������
    % 6 - yellow -- �������� ������

    cmap = [1 1 1; ...
            0 0 0; ...
            1 0 0; ...
            0 0 1; ...
            0 1 0; ...
            1 1 0; ...
            0.5 0.5 0.5];

    colormap(cmap);

    % ���������� ��� ����������� ����� �� ������ ��������
    drawMapEveryTime = drawMap;

    [nrows, ncols] = size(input_map);

    % map -- ������� ������� ��������� ������
    map = zeros(nrows, ncols);

    map(~input_map) = 1;     % ��������� ��������� ������
    map(input_map)  = 2;     % ��������� �����������

    % �������� ������ ��������� � �������� ������
    start_node = sub2ind(size(map), start_coords(1), start_coords(2));
    dest_node  = sub2ind(size(map), dest_coords(1),  dest_coords(2));

    map(start_node) = 5;
    map(dest_node)  = 6;

    % distance -- ������� ���������� �� ������ �� ������ ������
    distanceFromStart = Inf(nrows, ncols);

    % parent -- �������, ����������� ��� ������ ������ ��������, ������������ ���������� ���������� �� ������
    parent = zeros(nrows, ncols);

    distanceFromStart(start_node) = 0;

    % ������� ��������������� � ������ ������
    numExpanded = 0;

    % ������� ����
    while (true)

        % ��������� ������� �����
        map(start_node) = 5;
        map(dest_node) = 6;

        % ����� ������ ��������� �����: drawMapEveryTime = true 
        if (drawMapEveryTime)
            image(1.5, 1.5, map);
            grid on;
            axis image;
            drawnow;
        end

        % ���������� ������ � ����������� ��������� ����������
        [min_dist, current] = min(distanceFromStart(:));

        if ((current == dest_node) || isinf(min_dist))
            break
        end
        
        % ���������� �����
        map(current) = 3;     % ��������� ������� ������ ��� ����������
        distanceFromStart(current) = Inf;     % �������� ���� ������ �� ������ ���������������

        % ���������� (������, �������) ������� ������
        [i, j] = ind2sub(size(distanceFromStart), current);

        % ********************************************************************* 
        % ��� ��� ������ ���������� �����
        % ���������� �������� ������� ������ ��������������� ������ � 
        % �������� �������� �������� map, distances � parent
        
        idxs(1) = sub2ind(size(distanceFromStart), i, j);
        if (i > 1)
            idxs(end + 1) = sub2ind(size(distanceFromStart), i - 1, j);
        end
        if (i < nrows)
            idxs(end + 1) = sub2ind(size(distanceFromStart), i + 1, j);
        end
        if (j > 1)
            idxs(end + 1) = sub2ind(size(distanceFromStart), i, j - 1);
        end
        if (j < ncols)
            idxs(end + 1) = sub2ind(size(distanceFromStart), i, j + 1);
        end
        
        for idx = idxs(1 : end)
            if (map(idx) == 1 || map(idx) == 6)
                map(idx) = 4;
                dist = min_dist + 1;
                if (dist < distanceFromStart(idx))
                    distanceFromStart(idx) = dist;
                    parent(idx) = idxs(1);
                    numExpanded = numExpanded + 1;
                end
            end
        end

        % *********************************************************************

    end

    %% ���������� ���� � ������� ����������������� ����������� �� ���������
    if (isinf(distanceFromStart(dest_node)))
        route = [];
    else
        route = dest_node;

        while (parent(route(1)) ~= 0)
            route = [parent(route(1)), route];
        end

        % ������������ ����� � ����
        for k = 2:length(route) - 1        
            map(route(k)) = 7;
            pause(0.1);
            image(1.5, 1.5, map);
            grid on;
            axis image;
        end
    end

end
