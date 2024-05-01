-- A. Regenerate the firewall log file
-- Load the IP trace file
ip_trace_data = LOAD '/home/cpre419/Downloads/ip_trace' USING PigStorage(' ') 
                AS (time:chararray, connection_id:int, source_ip:chararray, 
                    arrow:chararray, destination_ip:chararray, protocol:chararray);

-- Load the raw block file
raw_block_data = LOAD '/home/cpre419/Downloads/raw_block' USING PigStorage(' ') 
                 AS (connection_id:int, action_taken:chararray);

-- Join the IP trace data with the raw block data to filter out blocked connections
blocked_connections = JOIN ip_trace_data BY connection_id, raw_block_data BY connection_id;

-- Filter out the blocked connections and format them into firewall log format
firewall_log = FOREACH blocked_connections GENERATE ip_trace_data::time AS time, 
               ip_trace_data::connection_id AS connection_id, 
               ip_trace_data::source_ip AS source_ip, 
               ip_trace_data::destination_ip AS destination_ip, 
               'Blocked' AS action_taken;

-- Store the regenerated firewall log file
STORE firewall_log INTO '/home/cpre419/lab4/exp3/firewall' USING PigStorage(',');

-- B. Generate the list of all unique source IP addresses that were blocked
-- Group the blocked connections by source IP and count the occurrences
blocked_counts = FOREACH (GROUP firewall_log BY source_ip) GENERATE group AS source_ip, 
                  COUNT(firewall_log) AS num_blocks;

-- Order the results by the number of times each IP was blocked in descending order
sorted_blocked_counts = ORDER blocked_counts BY num_blocks DESC;

-- Store the sorted list of blocked IPs and their counts
STORE sorted_blocked_counts INTO '/home/cpre419/lab4/exp3/output' USING PigStorage(',');

-- Display the results
DUMP sorted_blocked_counts;

