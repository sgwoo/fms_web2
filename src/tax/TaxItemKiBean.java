package tax;

import java.util.*;

public class TaxItemKiBean {

	//Table : �ŷ����� ��Ÿ ����Ʈ
	private String item_id;			//������ȣ	
	private int    item_ki_seq;		//�Ϸù�ȣ
	private String item_ki_g;		//û������	
	private String item_ki_app;		//����	
	private int    item_ki_pr;		//�ݾ�		
	private String item_ki_bigo;	//���			

	// CONSTRCTOR            
	public TaxItemKiBean() {  
		item_id			= "";
		item_ki_seq		= 0;
		item_ki_g		= "";
		item_ki_app		= "";
		item_ki_pr		= 0;
		item_ki_bigo	= "";
	}

	//Set Method
	public void setItem_id			(String val){	if(val==null) val="";		item_id			= val;		}
	public void setItem_ki_seq		(int    val){								item_ki_seq		= val;		}
	public void setItem_ki_g		(String val){	if(val==null) val="";		item_ki_g		= val;		}
	public void setItem_ki_app		(String val){	if(val==null) val="";		item_ki_app		= val;		}
	public void setItem_ki_pr		(int    val){								item_ki_pr		= val;		}
	public void setItem_ki_bigo		(String val){	if(val==null) val="";		item_ki_bigo	= val;		}

	//Get Method
	public String getItem_id		(){		return		item_id;		}
	public int    getItem_ki_seq	(){		return		item_ki_seq;	}
	public String getItem_ki_g		(){		return		item_ki_g;		}
	public String getItem_ki_app	(){		return		item_ki_app;	}
	public int    getItem_ki_pr		(){		return		item_ki_pr;		}
	public String getItem_ki_bigo	(){		return		item_ki_bigo;	}

}