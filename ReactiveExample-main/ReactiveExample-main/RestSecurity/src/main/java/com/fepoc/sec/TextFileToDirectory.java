package com.fepoc.sec;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Reader;

/**
 *
 * @author Administrator
 */
public class TextFileToDirectory {
    public static void main(String [] args) throws IOException{
        File outputFolder = new File("C:\\Users\\cw22is2\\Workspaces\\angular-projects");
        FileReader reader = new FileReader("C:\\Users\\cw22is2\\Documents\\hdrive\\poc\\pw.txt");
        new TextFileToDirectory().convert(outputFolder, reader);
    }
    public void convert(File outputFolder, Reader reader){
        FileWriter writer = null;
        boolean fw = false;
        boolean fwc = false;
        try(BufferedReader brd = new BufferedReader(reader)){
            String line;
            while((line=brd.readLine())!=null){
                if(line.startsWith("[dir:")){
                    outputFolder = createDir(outputFolder, line.replace("[dir:", "").replace("]", ""));
                }
                else if(line.equals("[return]")){
                    outputFolder = new File(outputFolder.getParent());
                }
                else if(line.startsWith("[file:")){
                    fw = true;
                    writer = new FileWriter(new File(outputFolder.getAbsolutePath().concat("/").concat(line.replace("[file:", "").replace("]", ""))));
                }
                else if(fw && writer!=null){
                    if(line.equals("[")){
                        fwc = true;
                    }
                    else if(line.equals("]")){
                        writer.close();
                        fwc = false;
                        fw=false;
                    }
                    else if(fwc){
                        writer.write(line);
                        writer.write("\n");
                    }
                }
            }
        }
        catch(IOException ex){
            
        }
    }

    private File createDir(File outputFolder, String dir) {
        File nd = new File(outputFolder.getAbsolutePath().concat("/").concat(dir));
        nd.mkdir();
        return nd;
    }
}
