package acar.incom;

import java.util.*;

public class IncomItemBean {
    //Table : incom_item
	private String incom_dt;		//�ŷ�����
	private int incom_seq;			//�ŷ�����
	private int seq_id;			//�Ϸù�ȣ
	private String item_nm;		
    private String item_dt;	 //������	
    private int item_seq;	 //���ݼ���(ī���)
  
	
	public IncomItemBean() {  
		incom_dt = "";
		incom_seq = 0;
		seq_id = 0;
		item_nm = "";
		item_dt = "";
		item_seq = 0;
		
	}

	// set Method
	public void setIncom_dt(String str){		incom_dt = str;	}
	public void setIncom_seq(int i){			incom_seq = i;	}
	public void setSeq_id(int i){				seq_id = i;	}
	public void setItem_nm(String str){			item_nm = str;	}
	public void setItem_dt(String str){			item_dt = str;	}
	public void setItem_seq(int i){				item_seq = i;	}
	
	
	//Get Method
	public String getIncom_dt(){		return incom_dt;	}
	public int getIncom_seq(){			return incom_seq;	}	
	public int getSeq_id(){			return seq_id;	}	
	public String getItem_nm(){			return item_nm;		}
	public String getItem_dt(){			return item_dt;		}
	public int getItem_seq(){			return item_seq;	}	
	

}