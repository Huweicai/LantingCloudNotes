package test;

import com.sun.net.httpserver.HttpExchange;

import java.io.OutputStream;
import java.io.PrintStream;
import java.io.StringWriter;
import java.net.InetAddress;
import java.net.ServerSocket;

/**
 * A class that generates a report of what ports can be bound to in the
 * OpenShift environment.
 *
 * @author Scott stark (sstark@redhat.com) (C) 2011 Red Hat Inc.
 * @version $Revision:$
 */
public class PortScan {
    private InetAddress bindAddr;

    /** Potential ports used by JBossAS */
    public static int[] DEFAULT_PORTS = {
        8080, 8443, 3528, 3529, 9999, 9990, 9443, 5445, 5455, 8090, 4447, 4712, 4713,
        7600, 57600
    };

    public PortScan(InetAddress bindAddr) {
        this.bindAddr = bindAddr;
    }

    /**
     *
     * @param ports
     */
    public void doScan(int[] ports, HttpExchange he) {
        for(int port : ports) {
            testPort(port, he);
        }
    }
    private void testPort(int port, HttpExchange he) {
        String heading = "Port:"+port;
        OutputStream os = he.getResponseBody();
        PrintStream ps = new PrintStream(os);
        ps.print("<h1>");
        ps.print(heading);
        ps.print("</h1>\n");
        System.out.printf("Testing port: %d...", port);
        try {
            ServerSocket socket = new ServerSocket(port, 0, bindAddr);
            socket.close();
            ps.print("Succeeded!!!\n");
            System.out.println("Succeeded!!!");
        } catch (Exception e) {
            System.out.println("Failed!!!");
            ps.print("Failed!!!\n<pre>\n");
            e.printStackTrace(ps);
            ps.print("</pre>\n");
        }
    }
}
