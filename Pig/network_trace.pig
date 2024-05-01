-- Load the network trace file
data = LOAD 'network_trace.txt' USING PigStorage(' ') 
       AS (time:chararray, ip_protocol:chararray, source_ip:chararray, 
           arrow:chararray, destination_ip:chararray, protocol:chararray);

-- Filter records to only include TCP protocol data
tcp_data = FILTER data BY protocol == 'tcp';

-- Process source IP addresses to remove extra information
processed_data = FOREACH tcp_data GENERATE source_ip AS source_ip:chararray, destination_ip AS destination_ip:chararray;

-- Group by source IP and collect distinct destination IPs
grouped = GROUP processed_data BY source_ip;

-- Count the number of unique destination IPs for each source IP
unique_destinations = FOREACH grouped GENERATE group AS source_ip, COUNT(processed_data.destination_ip) AS num_unique_destinations;

-- Order the results by the number of unique destination IPs in descending order
ordered = ORDER unique_destinations BY num_unique_destinations DESC;

-- Limit the results to the top 10 source IP addresses
top_10 = LIMIT ordered 10;

-- Store the results in the specified output location
STORE top_10 INTO '/home/cpre419/lab4/exp2/output/' USING PigStorage(',');

-- Display the results
DUMP top_10;

