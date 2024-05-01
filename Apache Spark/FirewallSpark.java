import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

import scala.Tuple1;
import scala.Tuple2;
import scala.Tuple5;

public class FirewallSpark {

    private final static int numOfReducers = 2;

    @SuppressWarnings("serial")
    public static void main(String[] args) throws Exception {
        
        // Check if the number of arguments is correct
        if (args.length != 1) {
            System.err.println("Usage: FirewallSpark <output>");
            System.exit(1);
        }

        // Configure Spark
        SparkConf sparkConf = new SparkConf().setAppName("FirewallSpark");
        JavaSparkContext context = new JavaSparkContext(sparkConf);

        // Read input files
        JavaRDD<String> rbLines = context.textFile("./raw_block");
        JavaRDD<String> ipTableLines = context.textFile("./ip_trace");
    
        // Parse input lines and create key-value pairs for IP trace
        JavaPairRDD<String, Tuple5<String, String, String, String, String>> ipTraceKV = ipTableLines.mapToPair(
            line -> {
                String[] parts = line.split(" ", 7);
                if (parts.length > 6) {
                    return new Tuple2<>(parts[1], new Tuple5<>(parts[0], parts[2], parts[4], parts[5], parts[6]));
                } else {
                    return null;
                }
            }
        );

        // Parse input lines and create key-value pairs for raw block
        JavaPairRDD<String, Tuple1<String>> rawBlockKV = rbLines.mapToPair(
            line -> {
                String[] parts = line.split(" ");
                if (parts.length > 1) {
                    return new Tuple2<>(parts[0], new Tuple1<>(parts[1]));
                } else {
                    return null;
                }
            }
        );

        // Join IP trace and raw block data
        JavaPairRDD<String, Tuple2<Tuple5<String, String, String, String, String>, Tuple1<String>>> allData = ipTraceKV.join(rawBlockKV);

        // Filter for blocked connections
        JavaPairRDD<String, Tuple2<Tuple5<String, String, String, String, String>, Tuple1<String>>> allDataF = allData.filter(
            v -> v._2()._2()._1().equals("Blocked")
        );

        // Format data as string and save as text file
        JavaRDD<String> allDataStr = allDataF.map(
            v -> String.format("(%s, %s, %s, %s, %s)", v._2()._1()._1(), v._1(), v._2()._1()._2(), v._2()._1()._3(), v._2()._2()._1())
        );
        allDataStr.saveAsTextFile(args[0].concat("firewall"));

        // Extract source IP data
        JavaPairRDD<String, Integer> sipData = allDataF.mapToPair(
            v -> {
                String sip = v._2()._1()._2();
                String[] parts = sip.split("\\.");
                if (parts.length > 4) {
                    sip = String.format("%s.%s.%s.%s", parts[0], parts[1], parts[2], parts[3]);
                }
                return new Tuple2<>(sip, 1);
            }
        );

        // Reduce by key to count occurrences of source IPs
        JavaPairRDD<String, Integer> counts = sipData.reduceByKey(
            (i1, i2) -> i1 + i2, numOfReducers
        );

        // Sort by count in descending order and save as text file
        JavaPairRDD<String, String> countsVKpairsSorted = counts.mapToPair(
            pair -> new Tuple2<>(String.format("%8d", pair._2()), pair._1())
        ).sortByKey(false);
        countsVKpairsSorted.saveAsTextFile(args[0].concat("sipRanked"));

        // Stop Spark context
        context.stop();
        context.close();
    }
}
