package acar.blackbox;

import java.util.*;

/*
 * 블랙박스 모델 Bean
 * */
public class BBModelBean {
    
    private String model_id;
    private String off_id;
    private String off_nm;
    private String bidding_id;
    private String model_nm;
    private int price;
    private int quantity;
    private String spec;
    private String etc;
    private String reg_dt;
    private String serial_num;
    
    //constructor
    public BBModelBean(){
        this.model_id = "";
        this.off_id = "";
        this.bidding_id = "";
        this.model_nm = "";
        this.price = 0;
        this.quantity = 0;
        this.spec = "";
        this.etc = "";
        this.reg_dt = "";
        this.off_nm = "";
        this.serial_num = "";
    }
    
    //setter
    public void setModel_id(String val){
        if(val==null) val="";
        this.model_id = val;
    }
    
    public void setOff_id(String val){
        if(val==null) val="";
        this.off_id = val;
    }
    
    public void setOff_nm(String val){
        if(val==null) val="";
        this.off_nm = val;
    }
    
    public void setBidding_id(String val){
        if(val==null) val="";
        this.bidding_id = val;
    }
    
    public void setModel_nm(String val){
        if(val==null) val="";
        this.model_nm = val;
    }
    
    public void setPrice(int val){
        this.price = val;
    }
    
    public void setQuantity(int val){
        this.quantity = val;
    }
    
    public void setSpec(String val){
        if(val==null) val="";
        this.spec = val;
    }
    
    public void setEtc(String val){
        if(val==null) val="";
        this.etc = val;
    }
    
    public void setReg_dt(String val){
        if(val==null) val="";
        this.reg_dt = val;
    }
    
    public void setSerial_num(String val){
        if(val==null) val="";
        this.serial_num = val;
    }
    
    
    //getter
    public String getModel_id(){
        return model_id;
    }
    
    public String getOff_id(){
        return off_id;
    }
    
    public String getOff_nm(){
        return off_nm;
    }
    
    public String getBidding_id(){
        return bidding_id;
    }
    
    public String getModel_nm(){
        return model_nm;
    }
    
    public int getPrice(){
        return price;
    }
    
    public int getQuantity(){
        return quantity;
    }

    public String getSpec(){
        return spec;
    }
    
    public String getEtc(){
        return etc;
    }
    
    public String getReg_dt(){
        return reg_dt;
    }
    
    public String getSerial_num(){
        return serial_num;
    }
}