package com.fepoc.vf.json.parser;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

public class JsonBlock {
private StringBuilder sb = new StringBuilder();
private List<JsonBlock> blocks = new CopyOnWriteArrayList<>();
private StringBuilder nameValueHolder;
private Map<String, List<Object>> nameValuePairMap = new HashMap<>();
private String currentName;

public StringBuilder getSb() {
return sb;
}
public void setSb(StringBuilder sb) {
this.sb = sb;
}
public List<JsonBlock> getBlocks() {
return blocks;
}
public void setBlocks(List<JsonBlock> blocks) {
this.blocks = blocks;
}


public StringBuilder getNameValueHolder() {
return nameValueHolder;
}
public void setNameValueHolder(StringBuilder nameValueHolder) {
this.nameValueHolder = nameValueHolder;
}

public void setName(String name) {
this.currentName = name;
this.nameValuePairMap.putIfAbsent(name, new ArrayList<>());
}
public List<Object> getValues() {
return this.nameValuePairMap.get(currentName);
}
public void processBlock() {
// TODO Auto-generated method stub

}


}
