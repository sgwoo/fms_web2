package acar.biz_partner;

import java.util.*;

public class ErpCardSettleBean {

    //Table : erp_card_settle ī��û���ݾ�
	private String	biz_reg_no;         	//����ڹ�ȣ                    
	private String	comp_name;          	//����ڸ�                      
	private String	card_inst_id;       	//ī��ȸ���ڵ�                  
	private String	card_inst_name;     	//ī��ȸ���                    
	private String	card_no;            	//ī���ȣ                      
	private String	settle_pay_month;   	//û�����                      
	private int		settle_tot_amt;     	//���������                    
	private int		settle_year_fee;    	//��ȸ��                        
	private int		settle_none_settle; 	//�����̰����ݾ�-����(��ü����) 
	private int		settle_delay_fee;   	//�����̰����ݾ�-��ü������     
	private int		settle_onetime;     	//����Ͻú�                    
	private int		settle_allot;       	//����Һ�                      
	private int		settle_service;     	//�������                    
	private int		settle_oversea;     	//����ؿܻ��                  
	private int		settle_revol_amount;	//���ȸ��������                
	private int		settle_revol_fee;   	//���ȸ������������            
	private int		settle_pre_amount;  	//���Աݱݾ�                    
	private int		settle_fee;         	//��������                      
	private String	erp_transfer_yn;    	//ERP ���� ����                 
	private String	erp_transfer_date;  	//ERP ���� �ð�                 

	
	public ErpCardSettleBean() {  
		biz_reg_no         	= "";
		comp_name          	= "";
		card_inst_id       	= "";
		card_inst_name     	= "";
		card_no            	= "";
		settle_pay_month   	= "";
		settle_tot_amt     	= 0;
		settle_year_fee    	= 0;
		settle_none_settle 	= 0;
		settle_delay_fee   	= 0;
		settle_onetime     	= 0;
		settle_allot       	= 0;
		settle_service     	= 0;
		settle_oversea     	= 0;
		settle_revol_amount	= 0;
		settle_revol_fee   	= 0;
		settle_pre_amount  	= 0;
		settle_fee         	= 0;
		erp_transfer_yn    	= "";
		erp_transfer_date  	= "";

	}

	// set Method
	public void setBiz_reg_no				(String var){	biz_reg_no				= var;	}
	public void setComp_name				(String var){	comp_name				= var;	}
	public void setCard_inst_id				(String var){	card_inst_id			= var;	}
	public void setCard_inst_name			(String var){	card_inst_name			= var;	}
	public void setCard_no					(String var){	card_no					= var;	}
	public void setSettle_pay_month			(String var){	settle_pay_month		= var;	}
	public void setSettle_tot_amt			(int    var){	settle_tot_amt			= var;	}
	public void setSettle_year_fee			(int    var){	settle_year_fee			= var;	}
	public void setSettle_none_settle		(int    var){	settle_none_settle		= var;	}
	public void setSettle_delay_fee			(int    var){	settle_delay_fee		= var;	}
	public void setSettle_onetime			(int    var){	settle_onetime			= var;	}
	public void setSettle_allot				(int    var){	settle_allot			= var;	}
	public void setSettle_service			(int    var){	settle_service			= var;	}
	public void setSettle_oversea			(int    var){	settle_oversea			= var;	}
	public void setSettle_revol_amount		(int    var){	settle_revol_amount		= var;	}
	public void setSettle_revol_fee			(int    var){	settle_revol_fee		= var;	}
	public void setSettle_pre_amount		(int    var){	settle_pre_amount		= var;	}
	public void setSettle_fee				(int    var){	settle_fee				= var;	}
	public void setErp_transfer_yn			(String var){	erp_transfer_yn			= var;	}
	public void setErp_transfer_date		(String var){	erp_transfer_date		= var;	}

	//Get Method
	public String getBiz_reg_no				(){				return biz_reg_no;				}
	public String getComp_name				(){				return comp_name;				}
	public String getCard_inst_id			(){				return card_inst_id;			}
	public String getCard_inst_name			(){				return card_inst_name;			}
	public String getCard_no				(){				return card_no;					}
	public String getSettle_pay_month		(){				return settle_pay_month;		}
	public int    getSettle_tot_amt			(){				return settle_tot_amt;			}
	public int    getSettle_year_fee		(){				return settle_year_fee;			}
	public int    getSettle_none_settle		(){				return settle_none_settle;		}
	public int    getSettle_delay_fee		(){				return settle_delay_fee;		}
	public int    getSettle_onetime			(){				return settle_onetime;			}
	public int    getSettle_allot			(){				return settle_allot;			}
	public int    getSettle_service			(){				return settle_service;			}
	public int    getSettle_oversea			(){				return settle_oversea;			}
	public int    getSettle_revol_amount	(){				return settle_revol_amount;		}
	public int    getSettle_revol_fee		(){				return settle_revol_fee;		}
	public int    getSettle_pre_amount		(){				return settle_pre_amount;		}
	public int    getSettle_fee				(){				return settle_fee;				}
	public String getErp_transfer_yn		(){				return erp_transfer_yn;			}
	public String getErp_transfer_date		(){				return erp_transfer_date;		}

}
