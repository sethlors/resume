import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.util.Collector;

public class exp2 {

    public static void main(String[] args) throws Exception {
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        DataStream<String> shakespeareStream = env.readTextFile("/Users/sethlors/IdeaProjects/lab7/shakespeare");

        DataStream<Tuple2<String, Integer>> bigramCounts = shakespeareStream
                .flatMap(new BigramExtractor())
                .keyBy(0)
                .sum(1);

        bigramCounts.writeAsText("/Users/sethlors/IdeaProjects/lab7/src/main/java/exp2_output");

        env.execute("Bigram Frequency Counter");
    }

    public static class BigramExtractor implements FlatMapFunction<String, Tuple2<String, Integer>> {
        @Override
        public void flatMap(String sentence, Collector<Tuple2<String, Integer>> out) {
            String[] words = sentence.replaceAll("[^a-zA-Z ]", "").toLowerCase().split("\\s+");

            for (int i = 0; i < words.length - 1; i++) {
                String firstWord = words[i];
                String secondWord = words[i + 1];
                out.collect(new Tuple2<>(firstWord + " " + secondWord, 1));
            }
        }
    }
}
