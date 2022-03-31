import Implementation.ImplementRunnable;
import Implementation.ImplementThread;

public class Main {
    public static void main(String[] args) {
        ImplementThread implementThread = new ImplementThread();
        ImplementThread implementThread2 = new ImplementThread();

        implementThread.run();
        implementThread2.run();

        ImplementRunnable implementRunnable = new ImplementRunnable();
        implementRunnable.run();

    }
}
