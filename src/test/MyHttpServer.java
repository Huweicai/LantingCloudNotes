package test;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.URI;
import java.util.Date;
import java.util.Properties;

/**
 * A little jdk http server for testing the diy OpenShift cartridge with java
 * @author Scott stark (sstark@redhat.com) (C) 2011 Red Hat Inc.
 * @version $Revision:$
 */
public class MyHttpServer {
    private static MyHttpServer server;

    private HttpServer httpServer;
    private PortScan portScan;

    static class HtmlHandler implements HttpHandler {
        private File root;
        HtmlHandler(File root) {
            this.root = root;
        }
        public void handle(HttpExchange he) throws IOException {
            System.out.printf("Begin ------ %s\n", new Date());
            try {
                Properties queryParams = writeHeaders(he);
                System.out.printf("QueryParams: %s\n", queryParams);
                String action = queryParams.getProperty("action");
                String file = getRequestFile(he.getRequestURI());
                String rootPath = root.getAbsolutePath();
                if(action != null) {
                    if(action.equalsIgnoreCase("stop")) {
                        he.sendResponseHeaders(HttpURLConnection.HTTP_ACCEPTED, -1);
                        he.close();
                        System.out.print("Stopping server...");
                        server.stop(1);
                        System.out.println("done");
                        System.out.flush();
                    } else if(action.equalsIgnoreCase("portscan")) {
                        String portsStr = queryParams.getProperty("ports");
                        int[] ports = PortScan.DEFAULT_PORTS;
                        if(portsStr != null) {
                            String[] tmp = portsStr.split("[,]");
                            ports = new int[tmp.length];
                            for(int n = 0; n < tmp.length; n ++) {
                                ports[n] = Integer.decode(tmp[n]);
                            }
                        }
                        he.sendResponseHeaders(HttpURLConnection.HTTP_OK, 0);
                        server.doScan(ports, he);
                        he.close();
                    }
                } else {
                    System.out.printf("Reading file: %s%s\n", rootPath, file);
                    writeFile(new File(root, file), he);
                    he.close();
                }
                System.out.printf("End ------ %s\n", new Date());
            } catch (Throwable t) {
                System.out.println("Internal error: ");
                t.printStackTrace();
                he.sendResponseHeaders(HttpURLConnection.HTTP_INTERNAL_ERROR, -1);
                System.out.printf("End ------ %s\n", new Date());
            }
        }
        Properties writeHeaders(HttpExchange he) {
            String method = he.getRequestMethod();
            URI requestURI = he.getRequestURI();
            String query = requestURI.getQuery();
            System.out.printf("RequestURI: %s\n", requestURI);
            System.out.printf("RequestURI.Path: %s\n", requestURI.getPath());
            System.out.printf("RequestURI.Query: %s\n", query);
            String action = null;
            Properties queryParams = new Properties();
            if(query != null) {
                // action=x,...
                System.out.printf("Parsing query string: %s\n",query);
                String[] params = query.split("[=,]");
                for(int n = 0; n < params.length; n += 2) {
                    queryParams.setProperty(params[n].toLowerCase(), params[n+1]);
                }
                action = queryParams.getProperty("action");
                if(action != null) {
                    System.out.printf("Found action: %s\n",action);
                }
            }
            System.out.printf("RequestMethod: %s\n", method);
            System.out.printf("Protocol: %s\n", he.getProtocol());
            System.out.printf("RemoteAddress: %s\n", he.getRemoteAddress());
            System.out.printf("LocalAddress: %s\n", he.getLocalAddress());
            System.out.printf("ContextPath: %s\n", he.getHttpContext().getPath());
            System.out.printf("ContextAttributes: %s\n", he.getHttpContext().getAttributes());
            Headers headers = he.getRequestHeaders();
            for(String key : headers.keySet()) {
                System.out.printf("Header(%s): %s\n", key, headers.getFirst(key));
            }
            return queryParams;
         }
        String getRequestFile(URI requestURI) {
            String file = requestURI.getPath();
            return file;
        }
        void writeFile(File path, HttpExchange he) throws IOException {
            OutputStream os = he.getResponseBody();
            he.getRequestBody().close();
            if(path.exists() == false) {
                he.sendResponseHeaders(HttpURLConnection.HTTP_NOT_FOUND, -1);
                os.close();
                System.out.printf("File not found: %s\n", path.getCanonicalPath());
                return;
            } else if(path.isDirectory()) {
                // TODO: could look for welcome type files...
                he.sendResponseHeaders(HttpURLConnection.HTTP_UNSUPPORTED_TYPE, -1);
                os.close();
                System.out.printf("File is a directory: %s\n", path.getCanonicalPath());
                return;
            }
            System.out.printf("Sending file: %s,%d\n", path.getCanonicalPath(), path.length());
            he.sendResponseHeaders(HttpURLConnection.HTTP_OK, path.length());

            FileInputStream fis = new FileInputStream(path);
            byte[] tmp = new byte[1024];
            int length = fis.read(tmp);
            while(length > 0) {
                os.write(tmp, 0, length);
                length = fis.read(tmp);
            }
            os.close();
            fis.close();
        }
    }

    MyHttpServer(InetAddress isa, int port, String repo) throws Exception {
        portScan = new PortScan(isa);

        httpServer = HttpServer.create(new InetSocketAddress(isa, port), 10);
        File root = new File(repo+"/html");
        if(root.exists() == false)
            throw new FileNotFoundException(root.getAbsolutePath());
        System.out.printf("Starting HttpServer for root context:%s\n", root.getCanonicalPath());
        HtmlHandler handler = new HtmlHandler(root);
        httpServer.createContext("/", handler);
        httpServer.setExecutor(null); // creates a default executor
    }
    void run() {
        httpServer.start();
    }
    void stop(int x) {
        httpServer.stop(x);
    }
    void doScan(int[] ports, HttpExchange he) {
        portScan.doScan(ports, he);
    }

    public static void main(String[] args) throws Exception {
        // Get various OpenShift environment variables
        String repo = System.getenv("OPENSHIFT_REPO_DIR");
        if(repo == null) {
            repo = ".";
        }
        String ip = System.getenv("OPENSHIFT_INTERNAL_IP");
        if(ip == null) {
            ip = "localhost";
        }
        String ports = System.getenv("OPENSHIFT_INTERNAL_PORT");
        if(ports == null) {
            ports = "8080";
        }
        int port = Integer.decode(ports);
        InetAddress isa = InetAddress.getByName(ip);
        server = new MyHttpServer(isa, port, repo);
        server.run();
    }
}
