function [route, numExpanded] = DijkstraGrid(input_map, start_coords, dest_coords, drawMap)
    % запуск алгоритма Дейкстры на сетке

    % входные данные: 
    %     input_map: логический массив, в котором свободная клетка = 0 (false), препятствие = 1 (true)
    %     start_coords and dest_coords: координаты (строка, столбец) начальной и конечной клеток

    % выходные данные:
    %      route : одномерный массив линейных индексов всех клеток, соответствующих кратчайшему пути (пуст, если пути не существует)
    %      numExpanded: общее число клеток, задействованных в поиске (конечная точка не входит в это число)

    % настройка цветовой схемы для вывода карты
    % 1 - white -- свободная клетка
    % 2 - black -- препятствие
    % 3 - red -- посещенная клетка
    % 4 - blue  -- клетка из списка рассматриваемых
    % 5 - green -- начальная клетка
    % 6 - yellow -- конечная клетка

    cmap = [1 1 1; ...
            0 0 0; ...
            1 0 0; ...
            0 0 1; ...
            0 1 0; ...
            1 1 0; ...
            0.5 0.5 0.5];

    colormap(cmap);

    % переменная для отображения карты на каждой итерации
    drawMapEveryTime = drawMap;

    [nrows, ncols] = size(input_map);

    % map -- таблица текущих состояний клеток
    map = zeros(nrows, ncols);

    map(~input_map) = 1;     % раскраска свободных клеток
    map(input_map)  = 2;     % раскраска препятствий

    % линейный индекс начальной и конечной клеток
    start_node = sub2ind(size(map), start_coords(1), start_coords(2));
    dest_node  = sub2ind(size(map), dest_coords(1),  dest_coords(2));

    map(start_node) = 5;
    map(dest_node)  = 6;

    % distance -- таблица расстояний от старта до каждой клетки
    distanceFromStart = Inf(nrows, ncols);

    % parent -- таблица, фиксирующая для каждой клетки родителя, реализующего наименьшее расстояние от старта
    parent = zeros(nrows, ncols);

    distanceFromStart(start_node) = 0;

    % счетчик задействованных в поиске клеток
    numExpanded = 0;

    % главный цикл
    while (true)

        % отрисовка текущей карты
        map(start_node) = 5;
        map(dest_node) = 6;

        % чтобы видеть изменение карты: drawMapEveryTime = true 
        if (drawMapEveryTime)
            image(1.5, 1.5, map);
            grid on;
            axis image;
            drawnow;
        end

        % нахождение клетки с минимальным значением расстояния
        [min_dist, current] = min(distanceFromStart(:));

        if ((current == dest_node) || isinf(min_dist))
            break
        end
        
        % обновление карты
        map(current) = 3;     % раскраска текущей клетки как посещенной
        distanceFromStart(current) = Inf;     % удаление этой клетки из списка рассматриваемых

        % координаты (строка, столбец) текущей клетки
        [i, j] = ind2sub(size(distanceFromStart), current);

        % ********************************************************************* 
        % ВАШ КОД ДОЛЖЕН НАХОДИТЬСЯ ЗДЕСЬ
        % необходимо посетить каждого соседа рассматриваемой клетки и 
        % обновить значения массивов map, distances и parent
        
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

    %% построение пути с помощью последовательного прохождения по родителям
    if (isinf(distanceFromStart(dest_node)))
        route = [];
    else
        route = dest_node;

        while (parent(route(1)) ~= 0)
            route = [parent(route(1)), route];
        end

        % визуализация карты и пути
        for k = 2:length(route) - 1        
            map(route(k)) = 7;
            pause(0.1);
            image(1.5, 1.5, map);
            grid on;
            axis image;
        end
    end

end
