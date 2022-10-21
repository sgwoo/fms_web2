package acar.credit;

public class ClsEtcBean
{
	private String rent_mng_id;		//��������ȣ           		
	private String rent_l_cd;		//����ȣ               
	private String cls_st;			//�������� (1:���������, 2:�ߵ�����, 3:�������������, 4:�������������, 5:�����Һ���)   
	private String cls_st_r;			//��������
	private String term_yn;			//ó������               
	private String cls_dt;			//��������        
	private String reg_id;			//�Ƿ���ID               
	private String cls_cau;			//��������               

	private String trf_dt;			//�̰�����   
	private int    grt_amt;			//������            
	private int    ifee_s_amt;		//�ʱ�뿩��_���ް�      
	private int    ifee_v_amt;		//�ʱ�뿩��_�ΰ���      
	private String ifee_etc;		//�ʱ�뿩��_���       
	private int    pp_s_amt;		//������_���ް�          
	private int    pp_v_amt;		//������_�ΰ���          
	private String pp_etc;			//������_���            
	private int    pded_s_amt;		//�����ݿ�������_���ް�  
	private int    pded_v_amt;		//�����ݿ�������_�ΰ���  
	private String pded_etc;		//�����ݿ�������_���    
	private int    tpded_s_amt;		//�����ݰ����Ѿ�_���ް�  
	private int    tpded_v_amt;		//�����ݰ����Ѿ�_�ΰ���  
	private String tpded_etc;		//�����ݰ����Ѿ�_���    
	private int    rfee_s_amt;		//�ܿ��뿩��_���ް�      
	private int    rfee_v_amt;		//�ܿ��뿩��_�ΰ���      
	private String rfee_etc;		//�ܿ��뿩��_���        
	private String dfee_tm;			//��ü���뿩��_ȸ��      
	//private int    dfee_s_amt;		//��ü���뿩��_���ް�    
	private int    dfee_v_amt;		//��ü���뿩��_�ΰ���    
	private String nfee_tm;			//�̼��ݿ��뿩��_ȸ��    
	private int    nfee_s_amt;		//�̼��ݿ��뿩��_���ް�  
	private int    nfee_v_amt;		//�̼��ݿ��뿩��_�ΰ���  
	private String nfee_mon;		//�뿩��̳��̿�Ⱓ_����
	private String nfee_day;		//�뿩��̳��̿�Ⱓ_��
	private String nfee_days;		//�뿩��̳��̿�Ⱓ_��ü�ϼ�
	private int    nfee_amt;		//�̳��뿩��             		
	private int    tfee_amt;		//�뿩���Ѿ�             
	private int    mfee_amt;		//ȯ�����մ뿩��       
	private String rcon_mon;		//�ܿ����Ⱓ_����
	private String rcon_day;		//�ܿ����Ⱓ_��  
	private String rcon_days;		//�ܿ����Ⱓ_��ü�ϼ�
	private int    trfee_amt;		//�ܿ����Ⱓ�뿩���Ѿ� 
	private String dft_int;			//�����������           
	private int    dft_amt;			//�ߵ����������         
	private String no_dft_yn;		//����ݸ�������                                                                                                                              
	private String no_dft_cau;		//����ݸ�������                                                                                                                              
	private int    fdft_amt1;		//�̳��ݾ�                                                                                                                                
	private int    fdft_dc_amt;		//�����DC�ݾ�                                                                                                                                
	private int    fdft_amt2;		//���� ������ �ݾ�                                                                                                                       
	private String pay_dt;		   	//��������޹�ȯ����                                                                                                                      
	
	//2�� �߰�
	private String cls_est_dt;		//����� �Աݿ�����
	private String dly_days;		//����� ��ü�ϼ�
	private int dly_amt;			//����� ��ü�ݾ�
	private String vat_st;			//�ΰ���ġ�� ���� ����
	private String ext_dt;			//���ݰ�꼭 ������
	private String ext_id;			//���ݰ�꼭 ��������

	//3�� �߰�
	private String cls_doc_yn;	//�ߵ��������꼭 ����
	private String opt_per;		//���Կɼ���
	private int	   opt_amt;		//���Կɼǰ�
	private String opt_dt;		//��������
	private String opt_mng;		//������ϴ����
	private int	   no_v_amt;	//�̳��ΰ���
	
	private int	   car_ja_amt;	//��å��
	private String r_mon;		//���̿�Ⱓ
	private String r_day;		//���̿�Ⱓ
	private int	   fine_amt;	//�̳����·�
	private int    etc_amt;		//����ȸ�����ֺ�
	private int    etc2_amt;		//����ȸ���δ��
	private int    etc3_amt;		//������������
	private int    etc4_amt;		//��Ÿ���ع���	
	
	private int    cls_s_amt;	//��������� ���ް�
	private int    cls_v_amt;	//��������� �ΰ���
	private int    ex_di_amt;	//�������뿩�� ���ް�
	
	private String ifee_mon;	//���ô뿩�����Ⱓ
	private String ifee_day;	//���ô뿩�����Ⱓ
	private int    ifee_ex_amt;	//���ô뿩�����ݾ�
	private int    rifee_s_amt;	//���ô뿩���ܾױݾ�
	private int    rifee_v_amt;	//���ô뿩���ܾױݾ� �ΰ��� - 202204 �߰� 
	private String cancel_yn;	//������ҿ���
	private String reg_dt;
		
	private String  div_st;				    //���� 1:�ϳ�, 2:�г�  
	private int	 	div_cnt;			    //�г�Ƚ��  
	private String  est_dt;				    //ä���� �ڱ�å ������  
	private int 	est_amt;                //ä�Ǿ����ݾ�               
	private String 	est_nm;                 //������                   
	private String  gur_nm;                 //����������         
	private String  gur_rel_tel;            //���������� ����ó
	private String  gur_rel;                //���������� ����    
	private String  remark;                 //�ǰ�   
		  
	//���Կɼ� ���        
	/*private String  sui_st;				    //���� Y:������Ϻ�� ����, N:������      
	private int	 	sui_d1_amt;			    //��ϼ� 
	private int	 	sui_d2_amt;			    //ä������      
	private int	 	sui_d3_amt;			    //��漼      
	private int	 	sui_d4_amt;			    //������      
	private int	 	sui_d5_amt;			    //������      
	private int	 	sui_d6_amt;			    //��ȣ�Ǵ�      
	private int	 	sui_d7_amt;			    //������ȣ�Ǵ�      
	private int	 	sui_d8_amt;			    //��ϴ����      
	private int	 	sui_d_amt;		*/	    //��     
        	
    //Ȯ���ݾ�, �󰢱ݾ�    	
   	private String  d_saction_id;             //Ȯ���ݾ� ������    
	private String  d_reason;                 //Ȯ���ݾ� ����   
	private int		dfee_amt;                 //�뿩��(�̳��뿩��+������)   
	private int		fine_amt_1;   
	private int		car_ja_amt_1;      
	private int		dly_amt_1;      
	private int		etc_amt_1;      
	private int		etc2_amt_1;      
	private int		dft_amt_1;     
	private int		ex_di_amt_1;      
	private int		nfee_amt_1;      
	private int		etc3_amt_1;      
	private int		etc4_amt_1;      
	 
	private int		no_v_amt_1;      
	private int		fdft_amt1_1;   
	private int		dfee_amt_1;      //������+�̳��뿩��   
	private int		dfee_v_amt_1;      //������+�̳��뿩��   �ΰ��� - 2022-04 �߰� 
		
	//���ݰ�꼭 ����  
	private String		tax_chk0;   //�ߵ���������� ���ݰ�꼭
	private String		tax_chk1;   //��Ÿ���ع��� ���ݰ�꼭   
	private String		tax_chk2;   //�ܿ����ô뿩�� ���ݰ�꼭
	private String		tax_chk3;   //�ܿ������� ���ݰ�꼭
	private String		tax_chk4;   //���ֺ�� ���ݰ�꼭  
	private String		tax_chk5;   //�δ��� ���ݰ�꼭  
	private String		tax_chk6;   //�뿩�� ���ݰ�꼭   	
  	 
	private int		rifee_s_amt_s;   //�ܿ����ô뿩�� ���ް�
	private int		rfee_s_amt_s;    //�ܿ������� ���ް�     
	private int		etc_amt_s;        //���ֺ�� ���ް�        
	private int		etc2_amt_s;       //�δ��� ���ް�        
	private int		dft_amt_s;        //�ߵ���������� ���ް�          
	private int		dfee_amt_s;       //�뿩�� ���ް�  
	private int		etc4_amt_s;       //��Ÿ���ع��� ���ް�  
	
	private int		rifee_s_amt_v;        //�ܿ����ô뿩�� �ΰ���    
	private int		rfee_s_amt_v;         //�ܿ������� �ΰ���  
	private int		etc_amt_v;             //���ֺ�� �ΰ���         
	private int		etc2_amt_v;            //�δ��� �ΰ���         
	private int		dft_amt_v;             //�ߵ���������� �ΰ���   
	private int		dfee_amt_v;            //�뿩�� �ΰ���           
	private int		etc4_amt_v;            //��Ÿ���ع��� �ΰ���   
	
	private String  upd_dt;       //������    
    private String  upd_id;       //������    
      
   	private int	   car_ja_no_amt;	//��å�� �� ���Աݵ� ��꼭 �̹���ݾ�
   	private String  autodoc_yn;       //ȸ��ó������(�������)  
   	
   	private String  dly_reason;       //��ü�� ���׵��� ����
   	private String  dft_reason;       //��������� ���׵��� ����  
   	private String  dly_saction_id;   //��ü�ᰨ�� ������    
   	private String  dft_saction_id;   //��������� ���� ������    
   	
   	private String dft_int_1;			//�����������    
   	private int	   fdft_amt3;		    // �����Ű��� �� ���Աݾ�     
   	
    private String  opt_ip_dt1;     //���Կɼ� �Ա��� 1  
  	private int		opt_ip_amt1;    // �Աݾ� 
    private String  opt_ip_bank1;      //�Ա�����    
    private String  opt_ip_bank_no1;     //�Աݱ���  
    
    
    private String  opt_ip_dt2;     //���Կɼ� �Ա��� 2    
  	private int		opt_ip_amt2;    //�߰��Աݾ� 
    private String  opt_ip_bank2;      //�Ա�����    
    private String  opt_ip_bank_no2;       //�Աݱ���  
    
    private String  re_bank;      //ȯ������    
    private String  re_acc_no;       //ȯ�� ���¹�ȣ  
    private String  re_acc_nm;      //ȯ�� �����ָ�    
       
    private String  dft_saction_dt;     //�ߵ����� ����� ������  
    private String  tax_reg_gu;      //���ݰ�꼭 ���չ���
    
    private int		tot_dist;    //����Ÿ� 
    private int		b_tot_dist;    //�߰��� ����Ÿ�  
    private String  cms_chk;      //��������� cms �����Ƿ�
    private String  ext_st;      //���Կɼǽ� ȯ�ҿ���
    
    private String  r_tax_dt;      //�������� �ƴ� ��꼭 ������
    
    private String  sb_saction_id;      //�Ͱ�������(����), ����������(�縮��)�� ��� ���� �����
    private String  sb_saction_dt;      //�Ͱ�������(����), ����������(�縮��)�� ��� ������
           
    private int		opt_s_amt;    //���Կɼ� ���ް��� 
    private int		opt_v_amt;    //���Կɼ� �ΰ����� 
    
    private String	 dft_cost_id;    //����� ���� ����ȿ�� �ͼӴ�� 
               	
    private String	 serv_st;    //������ ��밡��
     
     private int		over_amt;            //�ʰ����� ����           
     private int		over_v_amt;            //�ʰ����� ����     �ΰ��� - 2022-04 �߰�       
     private int	          over_amt_1;            //�ʰ����� Ȯ��   
     private int	          over_v_amt_1;            //�ʰ����� Ȯ��   �ΰ��� -2022-04 �߰� 
     private int	          over_amt_s;            //�ʰ����� ���ް�   
     private int	          over_amt_v;            //�ʰ����� �ΰ���   
     
      private String	 match;    //�����Ī
      
      private String	 ext_saction_id;    //�ĺ�ó������
      private String	 ext_reason;    //�ĺ�ó������
      
     private int	         m_o_amt;            //���Կɼ�
     private String	 serv_gubun;    //������ ��������
     
     private int	         cls_eff_amt;            //����ȿ�� �氨�ݾ�
     private String	 input_id;    //���� ����Ÿ �Է��� 
           	
	public ClsEtcBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";  
		cls_st		= "";     
		cls_st_r	= "";     
		term_yn		= "";    
		cls_dt		= "";     
		reg_id		= "";     
		cls_cau		= "";    
	
		trf_dt		= "";     
		ifee_s_amt	= 0;
		ifee_v_amt	= 0;   
		ifee_etc	= "";   
		pp_s_amt	= 0;     
		pp_v_amt	= 0;     
		pp_etc		= "";     
		pded_s_amt	= 0;   
		pded_v_amt	= 0;   
		pded_etc	= "";   
		tpded_s_amt	= 0;  
		tpded_v_amt	= 0;  
		tpded_etc	= "";  
		rfee_s_amt	= 0;   
		rfee_v_amt	= 0;   
		rfee_etc	= "";   
		dfee_tm		= "";    
	//	dfee_s_amt	= 0;   
		dfee_v_amt	= 0;   
		nfee_tm		= "";    
		nfee_s_amt	= 0;   
		nfee_v_amt	= 0;   
		nfee_mon	= "";
		nfee_day	= "";
		nfee_days	= "";
		nfee_amt	= 0;     
		tfee_amt	= 0;     
		mfee_amt	= 0;     
		rcon_mon	= "";
		rcon_day	= "";  
		rcon_days	= ""; 
		trfee_amt	= 0;    
		dft_int		= "";      
		dft_amt		= 0;      
		no_dft_yn	= "";    
		no_dft_cau	= "";   
		fdft_amt1	= 0;    
		fdft_dc_amt	= 0;  
		fdft_amt2	= 0;    
		pay_dt		= "";       
				
		cls_est_dt	= "";
		dly_days	= "";
		dly_amt		= 0;
		vat_st		= "";
		ext_dt		= "";
		ext_id		= "";
		grt_amt		= 0;
		cls_doc_yn	= "";
		opt_per		= "";
		opt_amt		= 0;
		opt_dt		= "";
		opt_mng		= "";
		no_v_amt	= 0;
		car_ja_amt	= 0;
		r_mon		= "";
		r_day		= "";
		fine_amt	= 0;
		etc_amt		= 0;
		etc2_amt	= 0;
		etc3_amt	= 0;
		etc4_amt	= 0;		
						
		cls_s_amt	= 0;
		cls_v_amt	= 0;
		ex_di_amt	= 0;
		ifee_mon	= "";
		ifee_day	= "";
		ifee_ex_amt	= 0;
		rifee_s_amt	= 0;
		rifee_v_amt	= 0;
		cancel_yn	= "";
		reg_dt		= "";
				
		div_st		= "";		
		div_cnt		= 0;       
	 	est_dt		= "";         
		est_amt		= 0;      
		est_nm		= "";         
		gur_nm		= "";        
		gur_rel_tel	= "";       
		gur_rel		= "";         
		remark		= "";     
			
	/*	sui_st		= "";	  
		sui_d1_amt	= 0;  
	 	sui_d2_amt	= 0;       
	 	sui_d3_amt	= 0;  
	 	sui_d4_amt	= 0;        
	 	sui_d5_amt	= 0;       
	 	sui_d6_amt	= 0;        
	 	sui_d7_amt	= 0;  
		sui_d8_amt	= 0;     
	 	sui_d_amt	= 0;  */
	 	
	 	d_saction_id= "";         
		d_reason	= ""; 
		dfee_amt	= 0;  
		fine_amt_1	= 0; 
		car_ja_amt_1= 0;     
		dly_amt_1	= 0;    
		etc_amt_1	= 0; 
		etc2_amt_1	= 0;   
		dft_amt_1	= 0;
		ex_di_amt_1 = 0;   
		nfee_amt_1	= 0;    
		etc3_amt_1	= 0;   
		etc4_amt_1	= 0;   
		
		no_v_amt_1	= 0;     
		fdft_amt1_1	= 0;    
		dfee_amt_1	= 0; 
		dfee_v_amt_1	= 0;  //2022-04 �߰� 
	
		tax_chk0 = "";   //�ߵ���������� ���ݰ�꼭 
		tax_chk1 = "";   //��Ÿ���ع��� ���ݰ�꼭   
		tax_chk2 = "";   //�ܿ����ô뿩�� ���ݰ�꼭 
		tax_chk3 = "";   //�ܿ������� ���ݰ�꼭
		tax_chk4 = "";   //���ֺ�� ���ݰ�꼭  
		tax_chk5 = "";   //�δ��� ���ݰ�꼭  
		tax_chk6 = "";   //�뿩�� ���ݰ�꼭   
		  	
		rifee_s_amt_s = 0;   //�ܿ����ô뿩�� ���ް�
		rfee_s_amt_s = 0;    //�ܿ������� ���ް�     
		
		etc_amt_s = 0;        //���ֺ�� ���ް�        
		etc2_amt_s = 0;       //�δ��� ���ް�        
		dft_amt_s = 0;        //�ߵ���������� ���ް�          
		dfee_amt_s = 0;       //�뿩�� ���ް�  
		
		etc4_amt_s = 0;       //��Ÿ���ع��� ���ް�  	
		
		rifee_s_amt_v = 0;        //�ܿ����ô뿩�� �ΰ���    
		rfee_s_amt_v = 0;         //�ܿ������� �ΰ���        
	      
		etc_amt_v = 0;             //���ֺ�� �ΰ���         
		etc2_amt_v = 0;            //�δ��� �ΰ���         
		dft_amt_v = 0;             //�ߵ���������� �ΰ���   
		dfee_amt_v = 0;            //�뿩�� �ΰ���           
		
		etc4_amt_v = 0;            //��Ÿ���ع��� �ΰ���   		
  
		upd_dt  = ""; 
   		upd_id  = "";  	 
   		    	
    	car_ja_no_amt = 0;   	
    	autodoc_yn = "";       //ȸ��ó������(�������)   	
    	
    	dly_reason = "";       //ȸ��ó������(�������)   	
    	dft_reason = "";       //ȸ��ó������(�������)   
    	dly_saction_id = "";
    	dft_saction_id = "";
    	dft_int_1		= "";    
    	
    	fdft_amt3 = 0;  	 	
    	
    	opt_ip_dt1 = "";     //���Կɼ� �Ա��� 1   
  		opt_ip_amt1 = 0;    //�߰��Աݾ� 
    	opt_ip_bank1 = "";       //�Ա�����    
    	opt_ip_bank_no1 = "";       //�Աݱ��� 
    	
    	opt_ip_dt2 = "";     //���Կɼ� �Ա���  2
  		opt_ip_amt2 = 0;    //�߰��Աݾ� 
    	opt_ip_bank2 = "";       //�Ա�����    
    	opt_ip_bank_no2 = "";       //�Աݱ��� 
    	
    	re_bank   = "";      //ȯ������    
        re_acc_no = "";       //ȯ�� ���¹�ȣ  
        re_acc_nm  = "";      //ȯ�� �����ָ�    
               
        dft_saction_dt = "";       //������  
        tax_reg_gu = "";
        tot_dist = 0;    //����Ÿ�
        b_tot_dist = 0;    //����Ÿ�
        cms_chk = "";
        ext_st = "";
        
        r_tax_dt = "";
        
        sb_saction_dt = "";
        sb_saction_id = "";
         
       	opt_s_amt = 0;    // 
       	opt_v_amt = 0;    // 
			
	dft_cost_id = "";

	serv_st = "";	
		
	over_amt	= 0;
	over_v_amt	= 0;
	over_amt_1	= 0;	
	over_v_amt_1	= 0;	
	over_amt_s	= 0;	
	over_amt_v	= 0;	
	match = "";	
	
	ext_saction_id = "";	
	ext_reason = "";	
	
	m_o_amt	= 0;	
	serv_gubun = "";	
	cls_eff_amt	= 0;	
	input_id = "";	

	}

	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}
	public void setCls_st(String str)		{	cls_st		= str; 	}       
	public void setCls_st_r(String str)		{	cls_st_r	= str; 	}       
	public void setTerm_yn(String str)		{	term_yn		= str; 	}
	public void setCls_dt(String str)		{	cls_dt		= str; 	}
	public void setReg_id(String str)		{	reg_id		= str; 	}
	public void setCls_cau(String str)		{	cls_cau		= str; 	}

	public void setTrf_dt(String str)		{	trf_dt		= str; 	}
	public void setIfee_s_amt(int i)		{	ifee_s_amt	= i;   	}
	public void setIfee_v_amt(int i)		{	ifee_v_amt	= i;   	}
	public void setIfee_etc(String str)		{	ifee_etc	= str; 	}
	public void setPp_s_amt(int i)			{	pp_s_amt	= i; 	}
	public void setPp_v_amt(int i)			{	pp_v_amt	= i; 	}
	public void setPp_etc(String str)		{	pp_etc		= str; 	}
	public void setPded_s_amt(int i)		{	pded_s_amt	= i; 	}
	public void setPded_v_amt(int i)		{	pded_v_amt	= i; 	}
	public void setPded_etc(String str)		{	pded_etc	= str; 	}
	public void setTpded_s_amt(int i)		{	tpded_s_amt	= i; 	}
	public void setTpded_v_amt(int i)		{	tpded_v_amt	= i; 	}
	public void setTpded_etc(String str)	{	tpded_etc	= str; 	}
	public void setRfee_s_amt(int i)		{	rfee_s_amt	= i; 	}
	public void setRfee_v_amt(int i)		{	rfee_v_amt	= i; 	}
	public void setRfee_etc(String str)		{	rfee_etc	= str; 	}
	public void setDfee_tm(String str)		{	dfee_tm		= str; 	}
	//public void setDfee_s_amt(int i)		{	dfee_s_amt	= i; 	}
	public void setDfee_v_amt(int i)		{	dfee_v_amt	= i; 	}
	public void setNfee_tm(String str)		{	nfee_tm		= str; 	}
	public void setNfee_s_amt(int i)		{	nfee_s_amt	= i; 	}
	public void setNfee_v_amt(int i)		{	nfee_v_amt	= i; 	}
	public void setNfee_mon(String str)		{	nfee_mon 	= str; 	}
	public void setNfee_day(String str)		{	nfee_day	= str; 	}
	public void setNfee_days(String str)	{	nfee_days	= str; 	}
	public void setNfee_amt(int i)			{	nfee_amt	= i; 	}
	public void setTfee_amt(int i)			{	tfee_amt	= i; 	}
	public void setMfee_amt(int i)			{	mfee_amt	= i; 	}
	public void setRcon_mon(String str)		{	rcon_mon 	= str; 	}
	public void setRcon_day(String str)		{	rcon_day	= str; 	}
	public void setRcon_days(String str)	{	rcon_days	= str; 	}
	public void setTrfee_amt(int i)			{	trfee_amt	= i; 	}
	public void setDft_int(String str)		{	dft_int		= str; 	}
	public void setDft_amt(int i)			{	dft_amt		= i; 	}
	public void setNo_dft_yn(String str)	{	no_dft_yn	= str; 	}
	public void setNo_dft_cau(String str)	{	no_dft_cau	= str; 	}
	public void setFdft_amt1(int i)			{	fdft_amt1	= i; 	}
	public void setFdft_dc_amt(int i)		{	fdft_dc_amt	= i; 	}
	public void setFdft_amt2(int i)			{	fdft_amt2	= i; 	}
	public void setPay_dt(String str)		{	pay_dt		= str; 	}
	
	public void setCls_est_dt(String str)	{	cls_est_dt	= str; 	}
	public void setDly_days(String str)		{	dly_days	= str; 	}
	public void setDly_amt(int i)			{	dly_amt		= i; 	}
	public void setVat_st(String str)		{	vat_st		= str; 	}
	public void setExt_dt(String str)		{	ext_dt		= str; 	}
	public void setExt_id(String str)		{	ext_id		= str; 	}
	public void setGrt_amt(int i)			{	grt_amt		= i;   	}
	public void setCls_doc_yn(String str)	{	cls_doc_yn	= str; 	}
	public void setOpt_per(String str)		{	opt_per		= str; 	}
	public void setOpt_amt(int i)			{	opt_amt		= i;   	}
	public void setOpt_dt(String str)		{	opt_dt		= str; 	}
	public void setOpt_mng(String str)		{	opt_mng		= str; 	}
	public void setNo_v_amt(int i)			{	no_v_amt	= i;   	}
	public void setCar_ja_amt(int i)		{	car_ja_amt	= i;   	}
	public void setR_mon(String str)		{	r_mon		= str; 	}
	public void setR_day(String str)		{	r_day		= str; 	}
	public void setFine_amt(int i)			{	fine_amt	= i;   	}
	public void setEtc_amt(int i)			{	etc_amt		= i;   	}
	public void setEtc2_amt(int i)			{	etc2_amt	= i;   	}
	public void setEtc3_amt(int i)			{	etc3_amt	= i;   	}
	public void setEtc4_amt(int i)			{	etc4_amt	= i;   	}
						
	public void setCls_s_amt(int i)			{	cls_s_amt	= i;   	}
	public void setCls_v_amt(int i)			{	cls_v_amt	= i;   	}
	public void setEx_di_amt(int i)			{	ex_di_amt	= i;   	}
	public void setIfee_mon(String str)		{	ifee_mon	= str; 	}
	public void setIfee_day(String str)		{	ifee_day	= str; 	}
	public void setIfee_ex_amt(int i)		{	ifee_ex_amt	= i;   	}
	public void setRifee_s_amt(int i)		{	rifee_s_amt	= i;   	}
	public void setRifee_v_amt(int i)		{	rifee_v_amt	= i;   	}
	public void setCancel_yn(String str)	{	cancel_yn	= str; 	}
	public void setReg_dt(String str)		{	reg_dt		= str; 	}

	public void setDiv_st(String str)		{	div_st		= str; 	}
	public void setDiv_cnt(int i)			{	div_cnt		= i; 	}
	public void setEst_dt(String str)		{	est_dt		= str; 	}
	public void setEst_amt(int i)			{	est_amt		= i; 	}
	public void setEst_nm(String str)		{	est_nm		= str; 	}
	public void setGur_nm(String str)		{	gur_nm		= str; 	}
	public void setGur_rel_tel(String str)	{	gur_rel_tel	= str; 	}
	public void setGur_rel(String str)		{	gur_rel		= str; 	}
	public void setRemark(String str)		{	remark		= str; 	}

	/*public void setSui_st(String str)		{	sui_st		= str; 	}
	public void setSui_d1_amt(int i)		{	sui_d1_amt		= i; 	}
	public void setSui_d2_amt(int i)		{	sui_d2_amt		= i; 	}
	public void setSui_d3_amt(int i)		{	sui_d3_amt		= i; 	}
	public void setSui_d4_amt(int i)		{	sui_d4_amt		= i; 	}
	public void setSui_d5_amt(int i)		{	sui_d5_amt		= i; 	}
	public void setSui_d6_amt(int i)		{	sui_d6_amt		= i; 	}
	public void setSui_d7_amt(int i)		{	sui_d7_amt		= i; 	}
	public void setSui_d8_amt(int i)		{	sui_d8_amt		= i; 	}
	public void setSui_d_amt(int i)			{	sui_d_amt		= i; 	}	*/	
	
	public void setD_saction_id(String str)	{	d_saction_id	= str; 	}
	public void setD_reason(String str)		{	d_reason		= str; 	}
	public void setDfee_amt(int i)			{	dfee_amt		= i; 	}	
	public void setFine_amt_1(int i)		{	fine_amt_1		= i; 	}	
	public void setCar_ja_amt_1(int i)		{	car_ja_amt_1	= i; 	}	
	public void setDly_amt_1(int i)			{	dly_amt_1		= i; 	}	
	public void setEtc_amt_1(int i)			{	etc_amt_1		= i; 	}	
	public void setEtc2_amt_1(int i)		{	etc2_amt_1		= i; 	}	
	public void setDft_amt_1(int i)			{	dft_amt_1		= i; 	}	
	public void setEx_di_amt_1(int i)		{	ex_di_amt_1		= i; 	}	
	public void setNfee_amt_1(int i)		{	nfee_amt_1		= i; 	}	
	public void setEtc3_amt_1(int i)		{	etc3_amt_1		= i; 	}	
	public void setEtc4_amt_1(int i)		{	etc4_amt_1		= i; 	}	
	public void setNo_v_amt_1(int i)		{	no_v_amt_1		= i; 	}	
	public void setFdft_amt1_1(int i)		{	fdft_amt1_1		= i; 	}	
	public void setDfee_amt_1(int i)		{	dfee_amt_1		= i; 	}	
	public void setDfee_v_amt_1(int i)		{	dfee_v_amt_1		= i; 	}	 //2022-04 �߰� 
	
	public void setTax_chk0(String str)		{	tax_chk0		= str; 	}
	public void setTax_chk1(String str)		{	tax_chk1		= str; 	}
	public void setTax_chk2(String str)		{	tax_chk2		= str; 	}
	public void setTax_chk3(String str)		{	tax_chk3		= str; 	}
	public void setTax_chk4(String str)		{	tax_chk4		= str; 	}
	public void setTax_chk5(String str)		{	tax_chk5		= str; 	}
	public void setTax_chk6(String str)		{	tax_chk6		= str; 	}
	
	public void	setRifee_s_amt_s(int i)		{  rifee_s_amt_s	= i;    }
	public void	setRfee_s_amt_s(int i)		{  rfee_s_amt_s		= i;    }		
	
	public void setEtc_amt_s(int i)			{	etc_amt_s		= i; 	}	
	public void setEtc2_amt_s(int i)		{	etc2_amt_s		= i; 	}	
	public void setDft_amt_s(int i)			{	dft_amt_s		= i; 	}	
	public void setDfee_amt_s(int i)		{	dfee_amt_s		= i; 	}	
	
	public void setEtc4_amt_s(int i)		{	etc4_amt_s		= i; 	}	
	
	
	public void	setRifee_s_amt_v(int i)		{  rifee_s_amt_v	= i;    }
	public void	setRfee_s_amt_v(int i)		{  rfee_s_amt_v		= i;    }		
	
	public void setEtc_amt_v(int i)			{	etc_amt_v		= i; 	}	
	public void setEtc2_amt_v(int i)		{	etc2_amt_v		= i; 	}	
	public void setDft_amt_v(int i)			{	dft_amt_v		= i; 	}	
	public void setDfee_amt_v(int i)		{	dfee_amt_v		= i; 	}	
	
	public void setEtc4_amt_v(int i)		{	etc4_amt_v		= i; 	}	
	
	public void setUpd_dt(String str)		{	upd_dt			= str; 	}	 
	public void setUpd_id(String str)		{	upd_id			= str; 	}	 
	
	public void setCar_ja_no_amt(int i)		{	car_ja_no_amt	= i; 	}	
	public void setAutodoc_yn(String str)	{	autodoc_yn		= str; 	}
	
	public void setDly_reason(String str)	{	dly_reason		= str; 	}
	public void setDft_reason(String str)	{	dft_reason		= str; 	}
	public void setDly_saction_id(String str)	{	dly_saction_id	= str; 	}
	public void setDft_saction_id(String str)	{	dft_saction_id	= str; 	}
	
	public void setDft_int_1(String str)	{	dft_int_1		= str; 	}
	
	public void setFdft_amt3(int i)			{	fdft_amt3	= i;   	}
	
	public void setOpt_ip_dt1(String str)		{	opt_ip_dt1		= str; 	}	 
	public void setOpt_ip_amt1(int i)			{	opt_ip_amt1		= i; 	}
	public void setOpt_ip_bank1(String str)		{	opt_ip_bank1	= str; 	}	 
	public void setOpt_ip_bank_no1(String str)	{	opt_ip_bank_no1	= str; 	}	 
		
	public void setOpt_ip_dt2(String str)		{	opt_ip_dt2		= str; 	}	 
	public void setOpt_ip_amt2(int i)			{	opt_ip_amt2		= i; 	}
	public void setOpt_ip_bank2(String str)		{	opt_ip_bank2	= str; 	}	 
	public void setOpt_ip_bank_no2(String str)	{	opt_ip_bank_no2	= str; 	}	
	
	public void setRe_bank(String str)		{	re_bank	= str; 	}	
	public void setRe_acc_no(String str)	{	re_acc_no	= str; 	}	
	public void setRe_acc_nm(String str)	{	re_acc_nm	= str; 	}	
		
	public void setDft_saction_dt(String str)	{	dft_saction_dt	= str; 	}
	public void setTax_reg_gu(String str)	{	tax_reg_gu	= str; 	}
	public void setTot_dist(int i)			{	tot_dist	= i; 	}
	public void setB_tot_dist(int i)			{	b_tot_dist	= i; 	}
	public void setCms_chk(String str)		{	cms_chk	= str; 	}
	public void setExt_st(String str)		{	ext_st	= str; 	}
		
	public void setR_tax_dt(String str)		{	r_tax_dt	= str; 	}		
	
	public void setSb_saction_id(String str)	{	sb_saction_id	= str; 	}		
	public void setSb_saction_dt(String str)	{	sb_saction_dt	= str; 	}	
			
	public void setOpt_s_amt(int i)			{	opt_s_amt		= i; 	}
	public void setOpt_v_amt(int i)			{	opt_v_amt		= i; 	}
	
	public void setDft_cost_id(String str)	{	dft_cost_id	= str; 	}	 	
		
	public void setServ_st(String str)	{	serv_st	= str; 	}	
	
	public void setOver_amt(int i)		{	over_amt		= i; 	}	
	public void setOver_v_amt(int i)		{	over_v_amt		= i; 	}	//2022-04 �߰� 
	public void setOver_amt_1(int i)		{	over_amt_1		= i; 	}
	public void setOver_v_amt_1(int i)		{	over_v_amt_1		= i; 	} //2022-04 �߰� 
	public void setOver_amt_s(int i)		{	over_amt_s		= i; 	}	
	public void setOver_amt_v(int i)		{	over_amt_v		= i; 	}
	
	public void setMatch(String str)	{	match	= str; 	}		
	
	public void setExt_saction_id(String str)	{	ext_saction_id	= str; 	}		
	public void setExt_reason(String str)	{	ext_reason	= str; 	}	
	
	public void setM_o_amt(int i)		{	m_o_amt		= i; 	}	
	public void setServ_gubun(String str)	{	serv_gubun	= str; 	}	
	public void setCls_eff_amt(int i)		{	cls_eff_amt		= i; 	}	
	public void setInput_id(String str)	{	input_id	= str; 	}	
									
				
	public String getRent_mng_id()	{	return rent_mng_id;    	}  
	public String getRent_l_cd()	{	return rent_l_cd;      	}    
	public String getCls_st()		{	return cls_st;         	}         
	public String getCls_st_r()		{	return cls_st_r;       	}         
	public String getTerm_yn()		{	return term_yn;        	}      
	public String getCls_dt()		{	return cls_dt;         	}       
	public String getReg_id()		{	return reg_id;         	}       
	public String getCls_cau()		{	return cls_cau;        	}      

	public String getTrf_dt()		{	return trf_dt;         	}       
	public int    getIfee_s_amt()	{	return ifee_s_amt;     	}   
	public int    getIfee_v_amt()	{	return ifee_v_amt;     	}   
	public String getIfee_etc()		{	return ifee_etc;       	}     
	public int    getPp_s_amt()		{	return pp_s_amt;       	}     
	public int    getPp_v_amt()		{	return pp_v_amt;       	}     
	public String getPp_etc()		{	return pp_etc;         	}       
	public int    getPded_s_amt()	{	return pded_s_amt;     	}	   
	public int    getPded_v_amt()	{	return pded_v_amt;     	}   
	public String getPded_etc()		{	return pded_etc;       	}     
	public int    getTpded_s_amt()	{	return tpded_s_amt;    	}  
	public int    getTpded_v_amt()	{	return tpded_v_amt;    	}  
	public String getTpded_etc()	{	return tpded_etc;      	}    
	public int    getRfee_s_amt()	{	return rfee_s_amt;     	}   
	public int    getRfee_v_amt()	{	return rfee_v_amt;     	}   
	public String getRfee_etc()		{	return rfee_etc;       	}     
	public String getDfee_tm()		{	return dfee_tm;        	}      
//	public int    getDfee_s_amt()	{	return dfee_s_amt;     	}   
	public int    getDfee_v_amt()	{	return dfee_v_amt;     	}   
	public String getNfee_tm()		{	return nfee_tm;        	}      
	public int    getNfee_s_amt()	{	return nfee_s_amt;     	}   
	public int    getNfee_v_amt()	{	return nfee_v_amt;     	}   
	public String getNfee_mon()		{	return nfee_mon;		}  
	public String getNfee_day()		{	return nfee_day;    	}  
	public String getNfee_days()	{	return nfee_days;    	}  
	public int    getNfee_amt()		{	return nfee_amt;       	}     
	public int    getTfee_amt()		{	return tfee_amt;       	}     
	public int    getMfee_amt()		{	return mfee_amt;       	}     
	public String getRcon_mon()		{	return rcon_mon;  		}  
	public String getRcon_day()		{	return rcon_day;    	}  
	public String getRcon_days()	{	return rcon_days;    	}  
	public int    getTrfee_amt()	{	return trfee_amt;      	}    
	public String getDft_int()		{	return dft_int;        	}      
	public int    getDft_amt()		{	return dft_amt;        	}      
	public String getNo_dft_yn()	{	return no_dft_yn;      	}    
	public String getNo_dft_cau()	{	return no_dft_cau;     	}   
	public int    getFdft_amt1()	{	return fdft_amt1;      	}    
	public int    getFdft_dc_amt()	{	return fdft_dc_amt;    	}  
	public int    getFdft_amt2()	{	return fdft_amt2;      	}    
	public String getPay_dt()		{	return pay_dt;         	}       
	public String getCls_est_dt()	{	return cls_est_dt;		}       
	public String getDly_days()		{	return dly_days;		}       
	public int    getDly_amt()		{	return dly_amt;      	}    
	public String getVat_st()		{	return vat_st;			}       
	public String getExt_dt()		{	return ext_dt;			}       
	public String getExt_id()		{	return ext_id;			}       
	public int    getGrt_amt()		{	return grt_amt;     	}   
	public String getCls_doc_yn()	{	return cls_doc_yn;		}       
	public String getOpt_per()		{	return opt_per;			}       
	public int    getOpt_amt()		{	return opt_amt;     	}   
	public String getOpt_dt()		{	return opt_dt;			}       
	public String getOpt_mng()		{	return opt_mng;			}   
	public int    getNo_v_amt()		{	return no_v_amt;     	}   
	public int    getCar_ja_amt()	{	return car_ja_amt;     	}   
	public String getR_mon()		{	return r_mon;			}   
	public String getR_day()		{	return r_day;			}   
	public int    getFine_amt()		{	return fine_amt;     	}   
	public int    getEtc_amt()		{	return etc_amt;     	}   
	public int    getEtc2_amt()		{	return etc2_amt;     	}   
	public int    getEtc3_amt()		{	return etc3_amt;     	}   
	public int    getEtc4_amt()		{	return etc4_amt;     	}   
	
	public int    getCls_s_amt()	{	return cls_s_amt;     	}   
	public int    getCls_v_amt()	{	return cls_v_amt;     	}   
	public int    getEx_di_amt()	{	return ex_di_amt;     	}   
	public String getIfee_mon()		{	return ifee_mon;		}   
	public String getIfee_day()		{	return ifee_day;		}   
	public int    getIfee_ex_amt()	{	return ifee_ex_amt;    	}   
	public int    getRifee_s_amt()	{	return rifee_s_amt;    	}  
	public int    getRifee_v_amt()	{	return rifee_v_amt;    	}  //���ô뿩�� �ܾ� �ΰ��� 2022-04 �߰� 
	public String getCancel_yn()	{	return cancel_yn;		}   
	public String getReg_dt()		{	return reg_dt;			}   
						
	public String getDiv_st()		{	return  div_st; 	   	}
	public int	  getDiv_cnt()		{	return  div_cnt; 	    }
	public String getEst_dt()		{	return  est_dt; 		}
	public int 	  getEst_amt()		{	return  est_amt;	 	}
	public String getEst_nm()		{	return  est_nm; 		}
	public String getGur_nm()		{	return  gur_nm; 		}
	public String getGur_rel_tel()	{	return  gur_rel_tel; 	}	
	public String getGur_rel()		{	return  gur_rel; 		}
	public String getRemark()		{	return  remark; 		}
		
	/*public String getSui_st()		{	return  sui_st; 	   	}
	public int	  getSui_d1_amt()	{	return  sui_d1_amt;     }
	public int	  getSui_d2_amt()	{	return  sui_d2_amt;     }
	public int	  getSui_d3_amt()	{	return  sui_d3_amt;     }
	public int	  getSui_d4_amt()	{	return  sui_d4_amt;     }
	public int	  getSui_d5_amt()	{	return  sui_d5_amt;     }
	public int	  getSui_d6_amt()	{	return  sui_d6_amt;     }
	public int	  getSui_d7_amt()	{	return  sui_d7_amt;     }
	public int	  getSui_d8_amt()	{	return  sui_d8_amt;     }
	public int	  getSui_d_amt()	{	return  sui_d_amt;      }*/
	
	
	public String getD_saction_id()	{	return  d_saction_id;	}
	public String getD_reason()		{	return  d_reason; 		}
	public int	  getDfee_amt()		{	return  dfee_amt;       }		
	public int	  getFine_amt_1()	{	return  fine_amt_1;      }
	public int	  getCar_ja_amt_1()	{	return  car_ja_amt_1;    }
	public int	  getDly_amt_1()	{	return  dly_amt_1;       }
	public int	  getEtc_amt_1()	{	return  etc_amt_1;       }
	public int	  getEtc2_amt_1()	{	return  etc2_amt_1;      }
	public int	  getDft_amt_1()	{	return  dft_amt_1;       }
	public int	  getEx_di_amt_1()	{	return  ex_di_amt_1;      }
	public int	  getNfee_amt_1()	{	return  nfee_amt_1;      }
	public int	  getEtc3_amt_1()	{	return  etc3_amt_1;      }
	public int	  getEtc4_amt_1()	{	return  etc4_amt_1;      }
	
	public int	  getNo_v_amt_1()	{	return  no_v_amt_1;      }
	public int	  getFdft_amt1_1()	{	return  fdft_amt1_1;     }
	public int	  getDfee_amt_1()	{	return  dfee_amt_1;      }  //������+�̳��뿩��
	public int	  getDfee_v_amt_1()	{	return  dfee_v_amt_1;      }  //������+�̳��뿩�� - 2022-04 �߰� 

	public String getTax_chk0()		{	return  tax_chk0; 	   	}
	public String getTax_chk1()		{	return  tax_chk1; 	   	}
	public String getTax_chk2()		{	return  tax_chk2; 	   	}
	public String getTax_chk3()		{	return  tax_chk3; 	   	}
	public String getTax_chk4()		{	return  tax_chk4; 	   	}
	public String getTax_chk5()		{	return  tax_chk5; 	   	}
	public String getTax_chk6()		{	return  tax_chk6; 	   	}
	
	public int	  getRifee_s_amt_s(){	return  rifee_s_amt_s;    }
	public int	  getRfee_s_amt_s()	{	return  rfee_s_amt_s;    }		

	public int	  getEtc_amt_s()	{	return  etc_amt_s;       }
	public int	  getEtc2_amt_s()	{	return  etc2_amt_s;      }
	public int	  getDft_amt_s()	{	return  dft_amt_s;       }
	public int	  getDfee_amt_s()	{	return  dfee_amt_s;      }
	
	public int	  getEtc4_amt_s()	{	return  etc4_amt_s;      }
		
	public int	  getRifee_s_amt_v(){	return  rifee_s_amt_v;   }
	public int	  getRfee_s_amt_v()	{	return  rfee_s_amt_v;    }		
	
	public int	  getEtc_amt_v()	{	return  etc_amt_v;       }
	public int	  getEtc2_amt_v()	{	return  etc2_amt_v;      }
	public int	  getDft_amt_v()	{	return  dft_amt_v;       }
	public int	  getDfee_amt_v()	{	return  dfee_amt_v;      }
	
	public int	  getEtc4_amt_v()	{	return  etc4_amt_v;      }
	
	public String getUpd_dt()		{	return 	upd_dt;			 }    
	public String getUpd_id()		{	return 	upd_id; 		 }    
		
	public int    getCar_ja_no_amt(){	return car_ja_no_amt;    }    
	public String getAutodoc_yn()	{	return autodoc_yn;		 }	
	
	public String getDly_reason()	{	return dly_reason;		 }	
	public String getDft_reason()	{	return dft_reason;		 }	
	public String getDly_saction_id()	{	return  dly_saction_id;	}
	public String getDft_saction_id()	{	return  dft_saction_id;	}
	
	public String getDft_int_1()	{	return dft_int_1;        	}      
	public int	  getFdft_amt3()	{	return  fdft_amt3;      }
	
	public String getOpt_ip_dt1()		{	return opt_ip_dt1;	  	 }	 
	public int	  getOpt_ip_amt1()		{	return opt_ip_amt1;		 }
	public String getOpt_ip_bank1()		{	return opt_ip_bank1;	 }	 
	public String getOpt_ip_bank_no1()	{	return opt_ip_bank_no1;	 }	
	
	public String getOpt_ip_dt2()		{	return opt_ip_dt2;	  	 }	 
	public int	  getOpt_ip_amt2()		{	return opt_ip_amt2;		 }
	public String getOpt_ip_bank2()		{	return opt_ip_bank2;	 }	 
	public String getOpt_ip_bank_no2()	{	return opt_ip_bank_no2;	 }	
	
	public String getRe_bank()			{	return re_bank;	 		}	
	public String getRe_acc_no()		{	return re_acc_no;	 	}	
	public String getRe_acc_nm()		{	return re_acc_nm;	 	}	
	
	public String getDft_saction_dt()	{	return  dft_saction_dt;	}	
	public String getTax_reg_gu()	{	return  tax_reg_gu;	}		
	public int	  getTot_dist()		{	return  tot_dist;		 }
	public int	  getB_tot_dist()		{	return  b_tot_dist;		 }
	public String getCms_chk()		{	return  cms_chk;	}	
	public String getExt_st()		{	return  ext_st;	}	
	
	public String getR_tax_dt()		{	return  r_tax_dt;	}	
	
	public String getSb_saction_id()		{	return  sb_saction_id;	}	
	public String getSb_saction_dt()		{	return  sb_saction_dt;	}	
		
	public int	  getOpt_s_amt()		{	return opt_s_amt;		 }
	public int	  getOpt_v_amt()		{	return opt_v_amt;		 }
	
	public String getDft_cost_id()		{	return dft_cost_id;	} 
		
	public String getServ_st()		{	return serv_st;	} 
	 
	public int	  getOver_amt()	{	return  over_amt;      }
	public int	  getOver_v_amt()	{	return  over_v_amt;      }
	public int	  getOver_amt_1()	{	return  over_amt_1;      }
	public int	  getOver_v_amt_1()	{	return  over_v_amt_1;      }
	public int	  getOver_amt_s()	{	return  over_amt_s;      }
	public int	  getOver_amt_v()	{	return  over_amt_v;      }
	
	 public String getMatch()		{	return match;	} 
	 
 	 public String getExt_saction_id()		{	return ext_saction_id;	} 
 	 public String getExt_reason()		{	return ext_reason;	} 
 	 
 	public int	  getM_o_amt()	{	return  m_o_amt;      }
 	public String getServ_gubun()		{	return serv_gubun;	} 
 	
 	public int	  getCls_eff_amt()	{	return  cls_eff_amt;      }
	public String getInput_id()		{	return input_id;	} 
	 
}