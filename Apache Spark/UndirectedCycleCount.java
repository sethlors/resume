import java.util.Arrays;
import java.util.Iterator;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.*;
import scala.Tuple2;

public class UndirectedCycleCount {

    public static void main(String[] args) {
        org.apache.log4j.Logger.getLogger("org").setLevel(org.apache.log4j.Level.DEBUG);
        org.apache.log4j.Logger.getLogger("akka").setLevel(org.apache.log4j.Level.DEBUG);

        System.out.println("Initializing SparkContext...");

        if (args.length != 2) {
            System.err.println("Usage: UndirectedCycleCount <input> <output>");
            System.exit(1);
        }

        try {
            SparkConf sparkConf = new SparkConf().setAppName("UndirectedCycleCount");
            JavaSparkContext context = new JavaSparkContext(sparkConf);
            System.out.println("SparkContext initialized successfully.");

            System.out.println("Reading input file from HDFS...");
            JavaRDD<String> lines = context.textFile(args[0]);
            System.out.println("Input file read successfully.");

            JavaPairRDD<Integer, Integer> edges = lines.mapToPair(new PairFunction<String, Integer, Integer>() {
                public Tuple2<Integer, Integer> call(String line) {
                    String[] tokens = line.split("\\s+");
                    int src = Integer.parseInt(tokens[0]);
                    int dest = Integer.parseInt(tokens[1]);
                    return new Tuple2<>(src, dest);
                }
            });

            JavaPairRDD<Tuple2<Integer, Integer>, Integer> triangles = edges.flatMapToPair(
                new PairFlatMapFunction<Tuple2<Integer, Integer>, Tuple2<Integer, Integer>, Integer>() {
                    public Iterator<Tuple2<Tuple2<Integer, Integer>, Integer>> call(Tuple2<Integer, Integer> edge) {
                        int src = edge._1();
                        int dest = edge._2();
                        return Arrays.asList(
                            new Tuple2<>(new Tuple2<>(src, dest), 1),
                            new Tuple2<>(new Tuple2<>(dest, src), 1)
                        ).iterator();
                    }
                }
            );

            JavaPairRDD<Tuple2<Integer, Integer>, Integer> triangleCounts = triangles.reduceByKey(
                new Function2<Integer, Integer, Integer>() {
                    public Integer call(Integer count1, Integer count2) {
                        return count1 + count2;
                    }
                }
            );

            long cycleCount = triangleCounts.mapToPair(
                new PairFunction<Tuple2<Tuple2<Integer, Integer>, Integer>, Integer, Integer>() {
                    public Tuple2<Integer, Integer> call(Tuple2<Tuple2<Integer, Integer>, Integer> triangleCount) {
                        return new Tuple2<>(1, triangleCount._2());
                    }
                }
            ).reduce(
                new Function2<Tuple2<Integer, Integer>, Tuple2<Integer, Integer>, Tuple2<Integer, Integer>>() {
                    public Tuple2<Integer, Integer> call(Tuple2<Integer, Integer> count1, Tuple2<Integer, Integer> count2) {
                        return new Tuple2<>(count1._1() + count2._1(), count1._2() + count2._2());
                    }
                }
            )._2();

            System.out.println("Total number of undirected cycles of length 3: " + cycleCount);

            context.stop();
            context.close();

            System.out.println("Program execution completed.");
        } catch (Exception e) {
            System.err.println("Error initializing SparkContext: " + e.getMessage());
            e.printStackTrace();
        }
    }
}