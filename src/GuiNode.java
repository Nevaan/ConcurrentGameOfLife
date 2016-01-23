package pwir.project.gameOfLife;

import java.awt.Color;
import java.awt.Graphics;
import java.io.IOException;

import javax.swing.JFrame;
import javax.swing.JPanel;

import com.ericsson.otp.erlang.OtpErlangAtom;
import com.ericsson.otp.erlang.OtpErlangDecodeException;
import com.ericsson.otp.erlang.OtpErlangExit;
import com.ericsson.otp.erlang.OtpErlangObject;
import com.ericsson.otp.erlang.OtpErlangString;
import com.ericsson.otp.erlang.OtpErlangTuple;
import com.ericsson.otp.erlang.OtpMbox;
import com.ericsson.otp.erlang.OtpNode;
 
public class GuiNode extends JPanel{
    static String server = "gameOfLife";
    static boolean grid[][] = new boolean[5][5];
    
    public static void main(String[] _args) throws Exception {
 
    	
        OtpNode self = null;
        OtpMbox mbox = null;
        try {
            self = new OtpNode("guiNode", "cookie");
            mbox = self.createMbox("facserver");
 
            if (self.ping(server, 2000)) {
                System.out.println("Connecting with erlang node succeed!");
            } else {
                System.out.println("Erlang node is probably down, shutting down...");
                return;
            }

        } catch (IOException e1) {
            e1.printStackTrace();
        }
        
        
        JFrame frame = new JFrame();
        frame.setSize(600,600);
        frame.getContentPane().add(new GuiNode());
        frame.setBackground(Color.LIGHT_GRAY);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
        
 
        OtpErlangObject[] msg = new OtpErlangObject[2];
        msg[0] = mbox.self();
        msg[1] = new OtpErlangAtom("gui");
        OtpErlangTuple tuple = new OtpErlangTuple(msg);
        mbox.send("gameOfLifeNode", server, tuple);
        
        while (true)
            try {
                OtpErlangString robj =  (OtpErlangString) mbox.receive();
                System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~");              
                System.out.println(robj.stringValue());    
                stringToBoolean(robj.stringValue());
                frame.revalidate();
                frame.repaint();
 
            } catch (OtpErlangExit e) {
                e.printStackTrace();
                break;
            } catch (OtpErlangDecodeException e) {
                e.printStackTrace();
            }
    } 
    
    
    
    public void paint(Graphics g){ 
    	g.setColor(Color.BLACK);
    	g.fillRect(0, 0, 500, 500);
    		for(int i=0;i<5;i++) {
    			for (int j=0;j<5;j++) {
    				if (grid[i][j]) {
    					g.clearRect(i*100, j*100, 100, 100);
    				}
    			}
    		}
    }
    
    public static void stringToBoolean(String input) {

    	input = input.replace("\n", "").replace("\r", "");
    	for (int i=0;i<input.length();i++) {
    		grid[i%5][i/5] = input.charAt(i) == '0' ? false : true;
    	}
    
    }
}
