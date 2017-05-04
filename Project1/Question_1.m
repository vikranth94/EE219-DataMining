clc;
clear all;
close all;
data = importdata('network_backup_dataset.csv');
l = length(data.textdata);
data.data = [zeros(1,2); data.data];
data.data = [data.data zeros(l,1)]
week_num = str2double(data.textdata(:,1));
for i=2:l
    if(strcmp(data.textdata(i,2),'Monday'))
        data.data(i,3) = week_num(i)*7 -7 + 0;
    elseif(strcmp(data.textdata(i,2),'Tuesday'))
        data.data(i,3) = week_num(i)*7 -7 + 1;
    elseif(strcmp(data.textdata(i,2),'Wednesday'))
        data.data(i,3) = week_num(i)*7 -7 + 2;
    elseif(strcmp(data.textdata(i,2),'Thursday'))
        data.data(i,3) = week_num(i)*7 -7 + 3;
    elseif(strcmp(data.textdata(i,2),'Friday'))
        data.data(i,3) = week_num(i)*7 -7 + 4;
    elseif(strcmp(data.textdata(i,2),'Saturday'))
        data.data(i,3) = week_num(i)*7 -7 + 5;
    elseif(strcmp(data.textdata(i,2),'Sunday'))
        data.data(i,3) = week_num(i)*7 -7+ 6;
    end
end
workload_0 = strcmp(data.textdata(:,4),'work_flow_0');
workload_1 = strcmp(data.textdata(:,4),'work_flow_1');
workload_2 = strcmp(data.textdata(:,4),'work_flow_2');
workload_3 = strcmp(data.textdata(:,4),'work_flow_3');
workload_4 = strcmp(data.textdata(:,4),'work_flow_4');
workload_0_data = data.data(workload_0, :);
workload_1_data = data.data(workload_1, :);
workload_2_data = data.data(workload_2, :);
workload_3_data = data.data(workload_3, :);
workload_4_data = data.data(workload_4, :);
%scatter(workload_0_data(:,3), workload_0_data(:,1),2)

size_0 = zeros(20,1);
for i=0:19
    for j=1:size(workload_0_data)
        if (i== workload_0_data(j,3))
            size_0(i+1) = size_0(i+1) + workload_0_data(j,1);
        end
    end
end

size_1 = zeros(20,1);
for i=0:19
    for j=1:size(workload_1_data)
        if (i== workload_1_data(j,3))
            size_1(i+1) = size_1(i+1) + workload_1_data(j,1);
        end
    end
end

size_2 = zeros(20,1);
for i=0:19
    for j=1:size(workload_2_data)
        if (i== workload_2_data(j,3))
            size_2(i+1) = size_2(i+1) + workload_2_data(j,1);
        end
    end
end


size_3 = zeros(20,1);
for i=0:19
    for j=1:size(workload_3_data)
        if (i== workload_3_data(j,3))
            size_3(i+1) = size_3(i+1) + workload_3_data(j,1);
        end
    end
end


size_4 = zeros(20,1);
for i=0:19
    for j=1:size(workload_4_data)
        if (i== workload_4_data(j,3))
            size_4(i+1) = size_4(i+1) + workload_4_data(j,1);
        end
    end
end



plot(1:20,size_0)
title('workflow 0')
xlabel('days')
ylabel('size in GB');
figure;

plot(1:20,size_1)
title('workflow 1')
xlabel('days')
ylabel('size in GB');
figure;

plot(1:20,size_2)
title('workflow 2')
xlabel('days')
ylabel('size in GB');
figure;

plot(1:20,size_3)
title('workflow 3')
xlabel('days')
ylabel('size in GB');
figure;

plot(1:20,size_4)
title('workflow 4')
xlabel('days')
ylabel('size in GB');