package acar.settle_acc;

import java.util.*;

public class SettleStatBean {
	private String gubun;		//����:�뿩��,������,���·�,��å��,������,�ߵ����������
	private int su;				//�Ǽ�
    private int amt;			//�ݾ�
    private int dly_amt;		//��ü�ݾ�

	public SettleStatBean() {  
		gubun = "";
		su = 0;
		amt = 0;
		dly_amt = 0;
	}

	// set Method
	public void setGubun(String str){		gubun = str;	}
	public void setSu(int i){				su = i;			}
	public void setAmt(int i){				amt = i;		}
	public void setDly_amt(int i){			dly_amt = i;	}
	
	//Get Method
	public String getGubun(){			return gubun;		}
	public int getSu(){					return su;			}	
	public int getAmt(){				return amt;			}	
	public int getDly_amt(){			return dly_amt;		}	
}

