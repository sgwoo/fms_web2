package acar.biz_partner;

import java.util.*;

public class ErpCardApprBean {

    //Table : erp_demand_current �뷮��ü
	private String	biz_reg_no;             	//����ڹ�ȣ               
	private String	comp_name;            		//����ڸ�                 
	private String	card_inst_id;           	//ī��ȸ���ڵ�             
	private String	card_inst_name;				//ī��ȸ���               
	private String	card_no;					//ī���ȣ                 
	private String	appr_date;              	//��������                 
	private String	appr_date_seq;          	//�������ں� ������        
	private String	card_owner_name;        	//ī���ָ�                 
	private String	card_user_name;         	//ī�����ڸ�             
	private String	appr_member;            	//��������                 
	private int	  	appr_amount;            	//���ξ�                   
	private String	appr_allot_type;        	//���Ÿ��                 
	private int	  	appr_allot_month;       	//�Һΰ�����               
	private String	appr_cancel_yn;         	//������ҿ���             
	private String	appr_no;                	//���ι�ȣ                 
	private String	erp_transfer_yn;        	//ERP ���� ����            
	private String	erp_transfer_date;      	//ERP ���� �ð�            
	private String	member_no;              	//����������ڹ�ȣ         
	private String	member_type;            	//����������               
	private String	member_post;            	//�����������ȣ           
	private String	member_addr;            	//������ �ּ�              
	private String	member_tel;             	//������ ��ȭ��ȣ          
	private String	member_code;            	//��������ȣ               
	private String	member_owner_name;      	//������ ��ǥ�ڸ�          
	private String	member_tax_status;      	//�ΰ��� ��������          
	private String	member_type_code;       	//�����������ڵ�           
	private float	appr_oversea_amount;    	//���αݾ�(��ȭ)           
	private String	appr_rate;              	//��ȭ�ŷ���ȯ��           
	private String	appr_sele_type;         	//��������                 
	private String	appr_currency;          	//��ȭ�ŷ������ڵ�         
	private String	appr_country;           	//��ȭ�ŷ�������           


	
	public ErpCardApprBean() {  
		biz_reg_no          = "";
		comp_name           = "";
		card_inst_id        = "";
		card_inst_name      = "";
		card_no             = "";
		appr_date           = "";
		appr_date_seq       = "";
		card_owner_name     = "";
		card_user_name      = "";
		appr_member         = "";
		appr_amount         = 0;
		appr_allot_type     = "";
		appr_allot_month    = 0;
		appr_cancel_yn      = "";
		appr_no             = "";
		erp_transfer_yn     = "";
		erp_transfer_date   = "";
		member_no           = "";
		member_type         = "";
		member_post         = "";
		member_addr         = "";
		member_tel          = "";
		member_code         = "";
		member_owner_name   = "";
		member_tax_status   = "";
		member_type_code    = "";
		appr_oversea_amount = 0;
		appr_rate           = "";
		appr_sele_type      = "";
		appr_currency       = "";
		appr_country        = "";

	}

	// set Method
	public void setBiz_reg_no				(String var){	biz_reg_no				= var;	}
	public void setComp_name				(String var){	comp_name				= var;	}
	public void setCard_inst_id				(String var){	card_inst_id			= var;	}
	public void setCard_inst_name			(String var){	card_inst_name			= var;	}
	public void setCard_no					(String var){	card_no					= var;	}
	public void setAppr_date				(String var){	appr_date				= var;	}
	public void setAppr_date_seq			(String var){	appr_date_seq			= var;	}
	public void setCard_owner_name			(String var){	card_owner_name			= var;	}
	public void setCard_user_name			(String var){	card_user_name			= var;	}
	public void setAppr_member				(String var){	appr_member				= var;	}
	public void setAppr_amount				(int	var){	appr_amount				= var;	}
	public void setAppr_allot_type			(String	var){	appr_allot_type			= var;	}
	public void setAppr_allot_month			(int	var){	appr_allot_month		= var;	}
	public void setAppr_cancel_yn			(String var){	appr_cancel_yn			= var;	}
	public void setAppr_no					(String var){	appr_no					= var;	}
	public void setErp_transfer_yn			(String var){	erp_transfer_yn			= var;	}
	public void setErp_transfer_date		(String var){	erp_transfer_date		= var;	}
	public void setMember_no				(String var){	member_no				= var;	}
	public void setMember_type				(String var){	member_type				= var;	}
	public void setMember_post				(String var){	member_post				= var;	}
	public void setMember_addr				(String var){	member_addr				= var;	}
	public void setMember_tel				(String var){	member_tel				= var;	}
	public void setMember_code				(String var){	member_code				= var;	}
	public void setMember_owner_name		(String var){	member_owner_name		= var;	}
	public void setMember_tax_status		(String var){	member_tax_status		= var;	}
	public void setMember_type_code			(String var){	member_type_code		= var;	}
	public void setAppr_oversea_amount		(float	 var){	appr_oversea_amount		= var;	}
	public void setAppr_rate				(String var){	appr_rate				= var;	}
	public void setAppr_sele_type			(String var){	appr_sele_type			= var;	}
	public void setAppr_currency			(String var){	appr_currency			= var;	}
	public void setAppr_country				(String var){	appr_country			= var;	}

	//Get Method
	public String getBiz_reg_no				(){		return biz_reg_no;				}
	public String getComp_name				(){		return comp_name;				}
	public String getCard_inst_id			(){		return card_inst_id;			}
	public String getCard_inst_name			(){		return card_inst_name;			}
	public String getCard_no				(){		return card_no;					}
	public String getAppr_date				(){		return appr_date;				}
	public String getAppr_date_seq			(){		return appr_date_seq;			}
	public String getCard_owner_name		(){		return card_owner_name;			}
	public String getCard_user_name			(){		return card_user_name;			}
	public String getAppr_member			(){		return appr_member;				}
	public int	  geAppr_amount				(){		return appr_amount;				}
	public String getAppr_allot_type		(){		return appr_allot_type;			}
	public int	  geAppr_allot_month		(){		return appr_allot_month;		}
	public String getAppr_cancel_yn			(){		return appr_cancel_yn;			}
	public String getAppr_no				(){		return appr_no;					}
	public String getErp_transfer_yn		(){		return erp_transfer_yn;			}
	public String getErp_transfer_date		(){		return erp_transfer_date;		}
	public String getMember_no				(){		return member_no;				}
	public String getMember_type			(){		return member_type;				}
	public String getMember_post			(){		return member_post;				}
	public String getMember_addr			(){		return member_addr;				}
	public String getMember_tel				(){		return member_tel;				}
	public String getMember_code			(){		return member_code;				}
	public String getMember_owner_name		(){		return member_owner_name;		}
	public String getMember_tax_status		(){		return member_tax_status;		}
	public String getMember_type_code		(){		return member_type_code;		}
	public float  getAppr_oversea_amount	(){		return appr_oversea_amount;		}
	public String getAppr_rate				(){		return appr_rate;				}
	public String getAppr_sele_type			(){		return appr_sele_type;			}
	public String getAppr_currency			(){		return appr_currency;			}
	public String getAppr_country			(){		return appr_country;         	}

}
