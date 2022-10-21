package acar.biz_partner;

import java.util.*;

public class ErpCardSettleDtlBean {

    //Table : erp_card_settle_dtl ī��û������
	private String	biz_reg_no;         	//����ڹ�ȣ                    
	private String	comp_name;          	//����ڸ�                      
	private String	card_inst_id;       	//ī��ȸ���ڵ�                  
	private String	card_inst_name;     	//ī��ȸ���                    
	private String	card_no;            	//ī���ȣ                      
	private String	settle_pay_month;   	//û�����                      
	private String	check_date;			 	//�ŷ�����         
	private String	check_date_seq;		 	//�ŷ������Ϸù�ȣ 
	private int   	check_amount;		 	//�̿�ݾ�         
	private String	check_member;		 	//��������         
	private String	check_type;			 	//����             
	private int   	check_pay_amount;	 	//���������       
	private int   	check_pay_fee;		 	//���������       
	private int   	check_allot_month;	 	//�ҺαⰣ         
	private String	erp_transfer_yn;    	//ERP ���� ����                 
	private String	erp_transfer_date;  	//ERP ���� �ð�                 

	
	public ErpCardSettleDtlBean() {  
		biz_reg_no				= "";
		comp_name				= "";
		card_inst_id			= "";
		card_inst_name			= "";
		card_no					= "";
		settle_pay_month		= "";
		check_date				= "";
		check_date_seq			= "";
		check_amount			= 0;
		check_member			= "";
		check_type				= "";
		check_pay_amount		= 0;
		check_pay_fee			= 0;
		check_allot_month		= 0;
		erp_transfer_yn    		= "";
		erp_transfer_date  		= "";

	}

	// set Method
	public void setBiz_reg_no				(String var){	biz_reg_no				= var;	}
	public void setComp_name				(String var){	comp_name				= var;	}
	public void setCard_inst_id				(String var){	card_inst_id			= var;	}
	public void setCard_inst_name			(String var){	card_inst_name			= var;	}
	public void setCard_no					(String var){	card_no					= var;	}
	public void setSettle_pay_month			(String var){	settle_pay_month		= var;	}
	public void setCheck_date				(String var){	check_date				= var;	}
	public void setCheck_date_seq			(String var){	check_date_seq			= var;	}
	public void setCheck_amount				(int    var){	check_amount			= var;	}
	public void setCheck_member				(String var){	check_member			= var;	}
	public void setCheck_type				(String var){	check_type				= var;	}
	public void setCheck_pay_amount			(int    var){	check_pay_amount		= var;	}
	public void setCheck_pay_fee			(int    var){	check_pay_fee			= var;	}
	public void setCheck_allot_month		(int    var){	check_allot_month		= var;	}
	public void setErp_transfer_yn			(String var){	erp_transfer_yn			= var;	}
	public void setErp_transfer_date		(String var){	erp_transfer_date		= var;	}

	//Get Method
	public String getBiz_reg_no				(){				return biz_reg_no;				}
	public String getComp_name				(){				return comp_name;				}
	public String getCard_inst_id			(){				return card_inst_id;			}
	public String getCard_inst_name			(){				return card_inst_name;			}
	public String getCard_no				(){				return card_no;					}
	public String getSettle_pay_month		(){				return settle_pay_month;		}
	public String getCheck_date				(){				return check_date;				}
	public String getCheck_date_seq			(){				return check_date_seq;			}
	public int    getCheck_amount			(){				return check_amount;			}
	public String getCheck_member			(){				return check_member;			}
	public String getCheck_type				(){				return check_type;				}
	public int    getCheck_pay_amount		(){				return check_pay_amount;		}
	public int    getCheck_pay_fee			(){				return check_pay_fee;			}
	public int    getCheck_allot_month		(){				return check_allot_month;		}
	public String getErp_transfer_yn		(){				return erp_transfer_yn;			}
	public String getErp_transfer_date		(){				return erp_transfer_date;		}

}
