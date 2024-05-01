// SL 2/6/2024
import java.io.I0Exception;
import org.apache.hadoop.conf.*;

import org.apache.hadoop.fs.*;
public class experiment2 {
    public static void main ( String [] args ) {
        String bigDataFilePath = "/home/cpre419/Downloads/bigdata";

        try {
            Configuration conf = new Configuration ();
            FileSystem fs = FileSystem.get(conf);
            Path filePath = new Path(bigDataFilePath);

            FSDataInputStream inputStream = fs.open(filePath);

            long start = 100000000L;
            long end = 1000000999L;
            inputStream.seek(start);

            int checksum = 0;
            for (long offset = start; offset <= end; offset++) {
                int currentByte = inputStream.read();
                checksum ^= currentByte;
            }

            System.out.println("8-bit XOR checksum: " + checksum);

            inputStream.close();
            fs.close();
        }
        catch (I0Exception e) {
            e.printStackTrace();
        }
    }
}