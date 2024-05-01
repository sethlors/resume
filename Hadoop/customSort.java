import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.KeyValueTextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.mapreduce.lib.partition.TotalOrderPartitioner;
import org.apache.hadoop.mapreduce.Partitioner;
import org.apache.hadoop.mapreduce.lib.partition.InputSampler;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;


public class customSort {

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();

        if (args.length != 2) {
            System.err.println("Usage: customSort <inputPath> <outputPath>");
            System.exit(2);
        }

        Job job1 = Job.getInstance(conf, "Sorting Program Round One");
        job1.setJarByClass(customSort.class);
        job1.setNumReduceTasks(1);
        job1.setMapperClass(Map_One.class);
        job1.setOutputKeyClass(Text.class);
        job1.setOutputValueClass(Text.class);
        job1.setInputFormatClass(TextInputFormat.class);
        job1.setOutputFormatClass(TextOutputFormat.class);
        FileInputFormat.addInputPath(job1, new Path(args[0]));
        Path tempOutputPath = new Path(args[1] + "_temp");
        FileOutputFormat.setOutputPath(job1, tempOutputPath);
        job1.waitForCompletion(true);

        Job job2 = Job.getInstance(conf, "Sorting Program Round Two");
        job2.setJarByClass(customSort.class);
        job2.setNumReduceTasks(1);
        job2.setPartitionerClass(TotalOrderPartitioner.class);
        job2.setInputFormatClass(KeyValueTextInputFormat.class);
        job2.setOutputFormatClass(TextOutputFormat.class);
        job2.setOutputKeyClass(Text.class);
        job2.setOutputValueClass(Text.class);
        FileInputFormat.addInputPath(job2, tempOutputPath);
        FileOutputFormat.setOutputPath(job2, new Path(args[1]));

        Path partitionFile = new Path(args[1] + "_partition");
        TotalOrderPartitioner.setPartitionFile(job2.getConfiguration(), partitionFile);
        InputSampler.Sampler<Text, Text> sampler = new InputSampler.RandomSampler<Text, Text>(0.1, 10000, 10);
        InputSampler.writePartitionFile(job2, sampler);
        job2.addCacheFile(partitionFile.toUri());

        System.exit(job2.waitForCompletion(true) ? 0 : 1);
    }

    public static class Map_One extends Mapper<LongWritable, Text, Text, Text> {
        private Text outKey = new Text();
        private Text outValue = new Text();

        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            String line = value.toString();
            String[] parts = line.split("\t");
            if (parts.length == 2) {
                outKey.set(parts[0].substring(0, Math.min(15, parts[0].length())));
                outValue.set(parts[0] + "\t" + parts[1]);
                context.write(outKey, outValue);
            }
        }
    }
    

    public class MyPartitioner extends Partitioner<Text, Text> {
        @Override
        public int getPartition(Text key, Text value, int numPartitions) {
            int hashCode = key.hashCode();
            hashCode = Math.abs(hashCode);
            
            int partition = hashCode % numPartitions;
            return partition;
        }
    }
}
