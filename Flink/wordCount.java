import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.sink.RichSinkFunction;
import org.apache.flink.util.Collector;
import org.apache.flink.api.java.utils.ParameterTool;
import org.apache.flink.streaming.api.windowing.time.Time;
import org.apache.flink.streaming.api.windowing.assigners.TumblingProcessingTimeWindows;

import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.*;

public class exp1 {

    public static void main(String[] args) throws Exception {
        final ParameterTool params = ParameterTool.fromArgs(args);

        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        env.getConfig().setGlobalJobParameters(params);

        DataStream<String> text = env.readTextFile("/Users/sethlors/IdeaProjects/lab7/shakespeare");

        DataStream<Tuple2<String, Integer>> counts =
                text.flatMap(new Tokenizer())
                        .keyBy(0)
                        .window(TumblingProcessingTimeWindows.of(Time.seconds(1)))
                        .sum(1);

        counts.addSink(new TopNWordsSink(10));

        env.execute("Streaming WordCount Example");
    }

    public static final class Tokenizer implements FlatMapFunction<String, Tuple2<String, Integer>> {
        @Override
        public void flatMap(String value, Collector<Tuple2<String, Integer>> out) {
            String[] words = value.toLowerCase().split("\\W+");

            for (String word : words) {
                if (!word.isEmpty()) {
                    out.collect(new Tuple2<>(word, 1));
                }
            }
        }
    }

    public static final class TopNWordsSink extends RichSinkFunction<Tuple2<String, Integer>> {
        private final int topSize;
        private PriorityQueue<Tuple2<String, Integer>> queue;

        public TopNWordsSink(int topSize) {
            this.topSize = topSize;
        }

        @Override
        public void open(Configuration parameters) throws Exception {
            queue = new PriorityQueue<>(topSize, Comparator.comparing(wordCount -> wordCount.f1));
        }

        @Override
        public void invoke(Tuple2<String, Integer> value, Context context) throws Exception {
            queue.offer(value);

            if (queue.size() > topSize) {
                queue.poll();
            }
        }

        @Override
        public void close() throws Exception {
            List<Tuple2<String, Integer>> topWords = new ArrayList<>();
            while (!queue.isEmpty()) {
                topWords.add(queue.poll());
            }

            Collections.reverse(topWords);

            try (PrintWriter writer = new PrintWriter(new FileWriter("/Users/sethlors/IdeaProjects/lab7/src/main/java/exp1_output.txt"))) {
                for (Tuple2<String, Integer> wordCount : topWords) {
                    writer.println(wordCount);
                }
            }
        }
    }
}
