/**
 * �ڻ꺯������
 */
package acar.asset;
import java.util.*;

public class AssetVarBean {

	//Table : ASSETVAR
    private String a_a;		//�뿩����
    private String a_1;		//�ڻ�����ڵ�
    private String seq;		//����
    private float b_1;		//���뿬��
    private String b_2;		//���뱸��
    private String b_3;		//���������
    private String b_4;		//������
    private String b_5;		//����
    private String c_1;		//�󰢹��
    private float c_2;		//����
    private String c_3;		//���������
    private String c_4;		//������
    private String c_5;		//����
    private String d_1;		//�󰢺����
    private String d_2;		//��ȸ�����
    private String d_3;		//���������
    private String d_4;		//������
    private String d_5;		//����
                        
  

	// CONSTRCTOR            
    public AssetVarBean() {  
    	this.a_a = "";
    	this.a_1 = "";
    	this.seq = "";
    	this.b_1 = 0;
    	this.b_2 = "";
    	this.b_3 = "";
    	this.b_4 = "";
    	this.b_5 = "";
    	this.c_1 = "";
    	this.c_2 = 0;
    	this.c_3 = "";
    	this.c_4 = "";
    	this.c_5 = "";
    	this.d_1 = "";
    	this.d_2 = "";
    	this.d_3 = "";
    	this.d_4 = "";
    	this.d_5 = "";
    
	}

	// get Method
    public void setA_a(String val){		if(val==null) val="";	this.a_a = val;	}
    public void setA_1(String val){		if(val==null) val="";	this.a_1 = val;	}
    public void setSeq(String val){		if(val==null) val="";	this.seq = val;	}
    public void setB_1(float i){					this.b_1 = i;	}
    public void setB_2(String val){		if(val==null) val="";	this.b_2 = val;	}
    public void setB_3(String val){		if(val==null) val="";	this.b_3 = val;	}
    public void setB_4(String val){		if(val==null) val="";	this.b_4 = val;	}
    public void setB_5(String val){		if(val==null) val="";	this.b_5 = val;	}
    public void setC_1(String val){		if(val==null) val="";	this.c_1 = val;	}
    public void setC_2(float i){								this.c_2 = i;	}
    public void setC_3(String val){		if(val==null) val="";	this.c_3 = val;	}
    public void setC_4(String val){		if(val==null) val="";	this.c_4 = val;	}
    public void setC_5(String val){		if(val==null) val="";	this.c_5 = val;	}
    public void setD_1(String val){		if(val==null) val="";	this.d_1 = val;	}
    public void setD_2(String val){		if(val==null) val="";	this.d_2 = val;	}
    public void setD_3(String val){		if(val==null) val="";	this.d_3 = val;	}
    public void setD_4(String val){		if(val==null) val="";	this.d_4 = val;	}
    public void setD_5(String val){		if(val==null) val="";	this.d_5 = val;	}
        
	
	//Get Method
	public String getA_a(){			return a_a;	}
	public String getA_1(){			return a_1;	}
	public String getSeq(){			return seq;	}
	public float getB_1(){			return b_1;	}
	public String getB_2(){			return b_2;	}
	public String getB_3(){			return b_3;	}
	public String getB_4(){			return b_4;	}
	public String getB_5(){			return b_5;	}
	public String getC_1(){			return c_1;	}
	public float getC_2(){			return c_2;	}
	public String getC_3(){			return c_3;	}
	public String getC_4(){			return c_4;	}
	public String getC_5(){			return c_5;	}
	public String getD_1(){			return d_1;	}
	public String getD_2(){			return d_2;	}
	public String getD_3(){			return d_3;	}
	public String getD_4(){			return d_4;	}
	public String getD_5(){			return d_5;	}
					

}
