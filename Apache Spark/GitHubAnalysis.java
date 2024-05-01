import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaSparkContext;
import scala.Tuple2;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class GitHubAnalysis {

    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("Usage: GitHubAnalysis <inputFilePath>");
            System.exit(1);
        }

        String inputFilePath = args[0];

        SparkConf sparkConf = new SparkConf().setAppName("GitHub Analysis");
        // .setMaster("local[*]");
        JavaSparkContext context = new JavaSparkContext(sparkConf);

        try {
            JavaRDD<String> lines = context.textFile(inputFilePath);

            String header = lines.first();
            JavaRDD<String> data = lines.filter(line -> !line.equals(header));

            JavaPairRDD<String, Integer> languageStarsPairRDD = data.mapToPair(line -> {
                String[] parts = line.split(",");
                return new Tuple2<>(parts[1], Integer.parseInt(parts[12]));
            });

            JavaPairRDD<String, Iterable<Integer>> groupedLanguageStarsRDD = languageStarsPairRDD.groupByKey();
            JavaPairRDD<String, Tuple2<Integer, String>> languageMaxStarsRDD = groupedLanguageStarsRDD.mapValues(iter -> {
                Integer maxStars = iter.iterator().next();
                String maxStarsRepo = "";
                for (Integer stars : iter) {
                    if (stars > maxStars) {
                        maxStars = stars;
                    }
                }
                return new Tuple2<>(maxStars, maxStarsRepo);
            });
 
            Map<String, Long> languageRepoCountMap = languageStarsPairRDD.mapValues(value -> 1L)
                    .reduceByKey(Long::sum)
                    .collectAsMap();

            List<Map.Entry<String, Long>> sortedLanguageRepoCount = languageRepoCountMap.entrySet().stream()
                    .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
                    .collect(Collectors.toList());

            sortedLanguageRepoCount.forEach(entry -> {
                String language = entry.getKey();
                long repoCount = entry.getValue();
                Tuple2<Integer, String> maxStarsTuple = languageMaxStarsRDD.filter(tuple -> tuple._1.equals(language)).first()._2();
                System.out.println(language + " " + repoCount + " " + maxStarsTuple._2 + " " + maxStarsTuple._1);
            });
        } finally {
            context.stop();
            context.close();
        }
    }
}