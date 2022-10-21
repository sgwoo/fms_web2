<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, ax_hub.*, acar.coolmsg.*, acar.user_mng.*" %>
<jsp:useBean id="ax_db" scope="page" class="ax_hub.AxHubDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%
    /* ============================================================================== */
    /* =   PAGE : ���� ��û �� ��� ó�� PAGE                                       = */
    /* = -------------------------------------------------------------------------- = */
    /* =   ���� �߻��� �Ʒ��� �ּҿ��� ��ȸ�Ͻñ� �ٶ��ϴ�.                         = */
    /* =   http://testpay.kcp.co.kr/pgsample/FAQ/search_error.jsp                   = */
    /* = -------------------------------------------------------------------------- = */
    /* =   Copyright (c)  2010.02   KCP Inc.   All Rights Reserved.                 = */
    /* ============================================================================== */
	
    /* ============================================================================== */
    /* =   ȯ�� ���� ���� Include                                                   = */
    /* = -------------------------------------------------------------------------- = */
    /* =   �� �ʼ�                                                                  = */
    /* =   �׽�Ʈ �� �ǰ��� ������ site_conf_inc.jsp������ �����Ͻñ� �ٶ��ϴ�.     = */
    /* = -------------------------------------------------------------------------- = */
%>
	<%@ page import="com.kcp.*" %>
	<%@ page import="java.net.URLEncoder"%>
	<%@ include file="/ax_hub/cfg/site_conf_inc.jsp"%>
<%
    /* = -------------------------------------------------------------------------- = */
    /* =   ȯ�� ���� ���� Include END                                               = */
    /* ============================================================================== */
%>

<%!
    /* ============================================================================== */
    /* =   null ���� ó���ϴ� �޼ҵ�                                                = */
    /* = -------------------------------------------------------------------------- = */
        public String f_get_parm( String val )
        {
          if ( val == null ) val = "";
          return  val;
        }
    /* ============================================================================== */
%>
<%
	request.setCharacterEncoding ( "euc-kr" ) ;
    /* ============================================================================== */
    /* =   01. ���� ������ �¾� (��ü�� �°� ����)                                  = */
    /* = -------------------------------------------------------------------------- = */
    	String g_conf_log_level = "3";                                                  // ����Ұ�
    	int    g_conf_tx_mode   = 0;                                                    // ����Ұ�
    /* ============================================================================== */


    /* ============================================================================== */
    /* =   02. ���� ��û ���� ����                                                  = */
    /* = -------------------------------------------------------------------------- = */
    	String req_tx         	= f_get_parm( request.getParameter( "req_tx"         ) ); 	// ��û ����
    	String tran_cd        	= f_get_parm( request.getParameter( "tran_cd"        ) ); 	// ó�� ����
    /* = -------------------------------------------------------------------------- = */
    	String cust_ip        	= f_get_parm( request.getRemoteAddr()                  ); 	// ��û IP
    	String ordr_idxx      	= f_get_parm( request.getParameter( "ordr_idxx"      ) ); 	// ���θ� �ֹ���ȣ
    	String good_name      	= f_get_parm( request.getParameter( "good_name"      ) ); 	// ��ǰ��
    	String good_mny       	= f_get_parm( request.getParameter( "good_mny"       ) ); 	// ���� �ѱݾ�
    /* = -------------------------------------------------------------------------- = */
    	String res_cd         	= "";                                                     	// �����ڵ�
    	String res_msg        	= "";                                                     	// ���� �޼���
    	String tno            	= f_get_parm( request.getParameter( "tno"            ) ); 	// KCP �ŷ� ���� ��ȣ
    /* = -------------------------------------------------------------------------- = */
    	String buyr_name      	= f_get_parm( request.getParameter( "buyr_name"      ) ); 	// �ֹ��ڸ�
    	String buyr_tel1      	= f_get_parm( request.getParameter( "buyr_tel1"      ) ); 	// �ֹ��� ��ȭ��ȣ
    	String buyr_tel2      	= f_get_parm( request.getParameter( "buyr_tel2"      ) ); 	// �ֹ��� �ڵ��� ��ȣ
    	String buyr_mail      	= f_get_parm( request.getParameter( "buyr_mail"      ) ); 	// �ֹ��� E-mail �ּ�
    /* = -------------------------------------------------------------------------- = */
	String  mod_type      	= f_get_parm( request.getParameter( "mod_type"	     ) ); 	// ����TYPE(������ҽ� �ʿ�)
    	String  mod_desc      	= f_get_parm( request.getParameter( "mod_desc"	     ) ); 	// �������
    /* = -------------------------------------------------------------------------- = */
    	String use_pay_method 	= f_get_parm( request.getParameter( "use_pay_method" ) ); 	// ���� ���
    	String bSucc          	= "";                                                     	// ��ü DB ó�� ���� ����
    /* = -------------------------------------------------------------------------- = */
    	String app_time       	= "";                                                     	// ���νð� (��� ���� ���� ����)
	String amount	      	= "";								// KCP ���� �ŷ��ݾ�         
	String total_amount   	= "0";								// ���հ����� �� �ŷ��ݾ�
    /* = -------------------------------------------------------------------------- = */
	String card_cd        	= "";                                                     	// �ſ�ī�� �ڵ�
 	String card_name      	= "";                                                     	// �ſ�ī�� ��
    	String app_no         	= "";                                                     	// �ſ�ī�� ���ι�ȣ
    	String noinf          	= "";                                                     	// �ſ�ī�� ������ ����
    	String quota          	= "";                                                     	// �ſ�ī�� �Һΰ���
	String partcanc_yn    	= "";								// �κ���� ��������
	String card_bin_type_01 = "";								// ī�屸��1
	String card_bin_type_02 = "";								// ī�屸��2
    /* = -------------------------------------------------------------------------- = */
	String bank_name      	= "";                                                     	// �����
    	String bank_code      	= "";                                                     	// �����ڵ�
    /* = -------------------------------------------------------------------------- = */
    	String bankname       	= "";                                                     	// �Ա� �����
    	String depositor      	= "";                                                     	// �Ա� ���� ������ ����
    	String account        	= "";                                                     	// �Ա� ���� ��ȣ
	String va_date	      	= "";								// ������� �Աݸ����ð�
    /* = -------------------------------------------------------------------------- = */
    	String pnt_issue      	= "";                                                     	// ���� ����Ʈ�� �ڵ�
    	String pt_idno        	= "";                                                     	// ���� �� ���� ���̵�
	String pnt_amount     	= "";                                                     	// �����ݾ� or ���ݾ�
	String pnt_app_time   	= "";                                                     	// ���νð�
	String pnt_app_no     	= "";                                                     	// ���ι�ȣ
    	String add_pnt        	= "";                                                     	// �߻� ����Ʈ
	String use_pnt        	= "";                                                     	// ��밡�� ����Ʈ
	String rsv_pnt        	= "";                                                     	// �� ���� ����Ʈ
    /* = -------------------------------------------------------------------------- = */
	String commid         	= "";								// ��Ż��ڵ�
	String mobile_no      	= "";								// �޴�����ȣ
    /* = -------------------------------------------------------------------------- = */
	String tk_shop_id	= f_get_parm( request.getParameter( "tk_shop_id"     ) ); 	// ������ �� ���̵�
	String tk_van_code	= "";								// �߱޻��ڵ�
	String tk_app_no	= "";								// ���ι�ȣ
    /* = -------------------------------------------------------------------------- = */
    	String cash_yn        	= f_get_parm( request.getParameter( "cash_yn"        ) ); 	// ���� ������ ��� ����
    	String cash_authno    	= "";                                                     	// ���� ������ ���� ��ȣ
    	String cash_tr_code   	= f_get_parm( request.getParameter( "cash_tr_code"   ) ); 	// ���� ������ ���� ����
    	String cash_id_info   	= f_get_parm( request.getParameter( "cash_id_info"   ) ); 	// ���� ������ ��� ��ȣ
    
    
    	//�Ƹ���ī ����
    	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
    	
    	String am_ax_code   	= f_get_parm( request.getParameter( "am_ax_code"     ) ); 	// ������ȣ
    	String am_m_tel   	= f_get_parm( request.getParameter( "am_m_tel"     ) ); 	// ������ȣ
    	String am_card_kind   	= f_get_parm( request.getParameter( "am_card_kind"     ) ); 	// ī������
    	String am_card_sign   	= f_get_parm( request.getParameter( "am_card_sign"     ) ); 	// ī��ȸ������
    	String am_card_rel   	= f_get_parm( request.getParameter( "am_card_rel"     ) ); 	// ����ڿ��ǰ���
    	
    	String tax_flag   	= f_get_parm( request.getParameter( "tax_flag"       ) ); 	// order���� �ɼ�
    	String comm_tax_mny   	= f_get_parm( request.getParameter( "comm_tax_mny"   ) ); 	// order���� �ɼ�
    	String comm_fee_mny   	= f_get_parm( request.getParameter( "comm_fee_mny"   ) ); 	// order���� �ɼ�
    	String comm_vat_mny   	= f_get_parm( request.getParameter( "comm_vat_mny"   ) ); 	// order���� �ɼ�
    	//String good_cd   	= f_get_parm( request.getParameter( "good_cd"        ) ); 	// order���� �ɼ�
    	//String good_expr   	= f_get_parm( request.getParameter( "good_expr"      ) ); 	// order���� �ɼ�
    	
    	boolean am_flag = true;
    					    	
    /* ============================================================================== */
    /* =   02. ���� ��û ���� ���� END
    /* ============================================================================== */


    /* ============================================================================== */
    /* =   03. �ν��Ͻ� ���� �� �ʱ�ȭ(���� �Ұ�)                                   = */
    /* = -------------------------------------------------------------------------- = */
    /* =       ������ �ʿ��� �ν��Ͻ��� �����ϰ� �ʱ�ȭ �մϴ�.                     = */
    /* = -------------------------------------------------------------------------- = */
    	C_PP_CLI c_PayPlus = new C_PP_CLI();

    	c_PayPlus.mf_init( g_conf_home_dir, g_conf_gw_url, g_conf_gw_port, g_conf_key_dir, g_conf_log_dir, g_conf_tx_mode );
    	c_PayPlus.mf_init_set();
    /* ============================================================================== */
    /* =   03. �ν��Ͻ� ���� �� �ʱ�ȭ END                                          = */
    /* ============================================================================== */


    /* ============================================================================== */
    /* =   04. ó�� ��û ���� ����			                            = */
    /* = -------------------------------------------------------------------------- = */
    /* = -------------------------------------------------------------------------- = */
    /* =   04-1. ���� ��û ���� ����                                                = */
    /* = -------------------------------------------------------------------------- = */
    	if ( req_tx.equals( "pay" ) )
    	{
            	c_PayPlus.mf_set_enc_data( f_get_parm( request.getParameter( "enc_data" ) ),
                                           f_get_parm( request.getParameter( "enc_info" ) ) );    


		//�����ݾ� ��/���� ���� ��� ���� �ҽ� �߰�
		if(good_mny.trim().length() > 0){
		
			int ordr_data_set_no;
			
			ordr_data_set_no = c_PayPlus.mf_add_set("ordr_data");
			
			c_PayPlus.mf_set_us(ordr_data_set_no, "ordr_mony","1004");
		
		}                           
                                           
                                           
                                           
                                                                                          
    	}

    /* = -------------------------------------------------------------------------- = */
    /* =   04-2. ���/���� ��û                                                     = */
    /* = -------------------------------------------------------------------------- = */
    	else if ( req_tx.equals( "mod" ) )
    	{
        	int     mod_data_set_no;

        	tran_cd = "00200000";
        	mod_data_set_no = c_PayPlus.mf_add_set( "mod_data" );

        	c_PayPlus.mf_set_us( mod_data_set_no, "tno",      request.getParameter( "tno"       ) ); // KCP ���ŷ� �ŷ���ȣ
       		c_PayPlus.mf_set_us( mod_data_set_no, "mod_type", mod_type                            ); // ���ŷ� ���� ��û ����
        	c_PayPlus.mf_set_us( mod_data_set_no, "mod_ip",   cust_ip                             ); // ���� ��û�� IP
        	c_PayPlus.mf_set_us( mod_data_set_no, "mod_desc", mod_desc			      ); // ���� ����                        
    }
    /* = -------------------------------------------------------------------------- = */
    /* =   04. ó�� ��û ���� ���� END                                              = */
    /* = ========================================================================== = */


    /* = ========================================================================== = */
    /* =   05. ����                                                                 = */
    /* = -------------------------------------------------------------------------- = */
    	if ( tran_cd.length() > 0 )
    	{
        	c_PayPlus.mf_do_tx( g_conf_site_cd, g_conf_site_key, tran_cd, cust_ip, ordr_idxx, g_conf_log_level, "0" );
		
		
	    	res_cd  = c_PayPlus.m_res_cd;  // ��� �ڵ�
		res_msg = c_PayPlus.m_res_msg; // ��� �޽���
	}
    	else
    	{
        	c_PayPlus.m_res_cd  = "9562";
        	c_PayPlus.m_res_msg = "���� ����|Payplus Plugin�� ��ġ���� �ʾҰų� tran_cd���� �������� �ʾҽ��ϴ�.";
    	}

    /* = -------------------------------------------------------------------------- = */
    /* =   05. ���� END                                                             = */
    /* ============================================================================== */


    /* ============================================================================== */
    /* =   06. ���� ��� �� ����                                                    = */
    /* = -------------------------------------------------------------------------- = */
    	if ( req_tx.equals( "pay" ) )
    	{
        	if ( res_cd.equals( "0000" ) )
        	{
            		tno		= c_PayPlus.mf_get_res( "tno"	    ); 	// KCP �ŷ� ���� ��ȣ
            		amount	  	= c_PayPlus.mf_get_res( "amount"    ); 	// KCP ���� �ŷ� �ݾ�
	    		pnt_issue 	= c_PayPlus.mf_get_res( "pnt_issue" ); 	// ���� ����Ʈ�� �ڵ�
	    
	    

    			/* = -------------------------------------------------------------------------- = */
    			/* =   06-1. �ſ�ī�� ���� ��� ó��                                            = */
    			/* = -------------------------------------------------------------------------- = */
            		if ( use_pay_method.equals( "100000000000" ) )
            		{
                		card_cd   		= c_PayPlus.mf_get_res( "card_cd"          ); 	// ī��� �ڵ�
                		card_name 		= c_PayPlus.mf_get_res( "card_name"        ); 	// ī��� ��
                		app_time  		= c_PayPlus.mf_get_res( "app_time"         ); 	// ���νð�
                		app_no    		= c_PayPlus.mf_get_res( "app_no"           ); 	// ���ι�ȣ
                		noinf     		= c_PayPlus.mf_get_res( "noinf"            ); 	// ������ ����
                		quota     		= c_PayPlus.mf_get_res( "quota"            ); 	// �Һ� ���� ��
				partcanc_yn 		= c_PayPlus.mf_get_res( "partcanc_yn"      ); 	// �κ���� ��������
				card_bin_type_01 	= c_PayPlus.mf_get_res( "card_bin_type_01" ); 	// ī�屸��1
				card_bin_type_02 	= c_PayPlus.mf_get_res( "card_bin_type_02" ); 	// ī�屸��2

				/* = -------------------------------------------------------------- = */
                		/* =   06-1.1. ���հ���(����Ʈ+�ſ�ī��) ���� ��� ó��             = */
                		/* = -------------------------------------------------------------- = */
                		if ( pnt_issue.equals( "SCSK" ) || pnt_issue.equals( "SCWB" ) )
                		{
                    			pt_idno      = c_PayPlus.mf_get_res( "pt_idno"      ); // ���� �� ���� ���̵�
                    			pnt_amount   = c_PayPlus.mf_get_res( "pnt_amount"   ); // �����ݾ� or ���ݾ�
	                		pnt_app_time = c_PayPlus.mf_get_res( "pnt_app_time" ); // ���νð�
	                		pnt_app_no   = c_PayPlus.mf_get_res( "pnt_app_no"   ); // ���ι�ȣ
	                		add_pnt      = c_PayPlus.mf_get_res( "add_pnt"      ); // �߻� ����Ʈ
                    			use_pnt      = c_PayPlus.mf_get_res( "use_pnt"      ); // ��밡�� ����Ʈ
                    			rsv_pnt      = c_PayPlus.mf_get_res( "rsv_pnt"      ); // �� ���� ����Ʈ
					total_amount = amount + pnt_amount;		       // ���հ����� �� �ŷ��ݾ�
                		}
            		}

		}
	}

    /* = -------------------------------------------------------------------------- = */
    /* =   06. ���� ��� ó�� END                                                   = */
    /* ============================================================================== */



    
    /* = ========================================================================== = */
    /* =   07. ���� �� ���� ��� DB ó��                                            = */
    /* = -------------------------------------------------------------------------- = */
    /* =      ����� ��ü ��ü������ DB ó�� �۾��Ͻô� �κ��Դϴ�.                 = */
    /* = -------------------------------------------------------------------------- = */

	if ( req_tx.equals( "pay" ) )
    	{

    		/* = -------------------------------------------------------------------------- = */
    		/* =   07-1. ���� ��� DB ó��(res_cd == "0000")                                = */
    		/* = -------------------------------------------------------------------------- = */
    		/* =        �� ���������� �����Ͻþ� DB ó���� �Ͻñ� �ٶ��ϴ�.                 = */
    		/* = -------------------------------------------------------------------------- = */
    		
        	if ( res_cd.equals( "0000" ) )
        	{
            		// 07-1-1. �ſ�ī��
            		if ( use_pay_method.equals( "100000000000" ) )
            		{
            
		    		/* = -------------------------------------------------------------------------- = */
    				/* =   *** �Ƹ���ī ������ ���                                               = */
    				/* = -------------------------------------------------------------------------- = */
    				/* =        ���� �������� ���, �ѹ��� �Աݴ���� �޽����߼�                    = */
    				/* = -------------------------------------------------------------------------- = */
            			
				
				
            			
            			
            			
            			AxHubBean ax_bean = ax_db.getAxHubCase(am_ax_code);
            			
            							

				//������û
				ax_bean.setReq_tx		(req_tx				);	
				ax_bean.setOrdr_idxx		(ordr_idxx			);	
				ax_bean.setPay_method		(use_pay_method			);	
				ax_bean.setGood_name		(good_name			);	
				ax_bean.setGood_mny		(AddUtil.parseInt(good_mny)	);	
				ax_bean.setBuyr_name		(buyr_name			);	
				ax_bean.setBuyr_tel1		(buyr_tel1			);	
				ax_bean.setBuyr_tel2		(buyr_tel2			);	
				ax_bean.setBuyr_mail		(buyr_mail			);	
				ax_bean.setTax_flag		(tax_flag			);	
				ax_bean.setComm_tax_mny		(AddUtil.parseInt(comm_tax_mny)	);	
				ax_bean.setComm_fee_mny		(AddUtil.parseInt(comm_fee_mny)	);	
				ax_bean.setComm_vat_mny		(AddUtil.parseInt(comm_vat_mny)	);	
				//�������(�ſ�ī�������)
				ax_bean.setTno			(tno				);	
				ax_bean.setAmount		(AddUtil.parseInt(amount)	);	
				ax_bean.setCard_cd		(card_cd			);	
				ax_bean.setCard_name		(card_name			);	
				ax_bean.setApp_time		(app_time			);	
				ax_bean.setApp_no		(app_no				);					
				ax_bean.setNoinf		(noinf				);	
				ax_bean.setQuota		(quota				);	
				//�Ƹ���ī ī������ �߰�����
				ax_bean.setAm_card_kind		(am_card_kind			);
				ax_bean.setAm_card_sign		(am_card_sign			);
				ax_bean.setAm_card_rel		(am_card_rel			);
				
				
				if(ax_bean.getGood_mny() > ax_bean.getAmount() || ax_bean.getGood_mny() < ax_bean.getAmount()){
					am_flag = false;
				}else{
					am_flag = ax_db.updateAxHub(ax_bean);	
				}
				
				
				
				 				
				//������� �� �Աݴ���ڿ��� �޽��� �뺸
				
				
				Hashtable ht_target_user1 = new Hashtable();
				Hashtable ht_target_user2 = new Hashtable();
				Hashtable ht_target_user3 = new Hashtable();
				
				String am_sub 	= "�ſ�ī������뺸";
				String am_cont 	= "["+good_name+" "+good_mny+"��] �ſ�ī�� ������ �Ǿ����� Ȯ���Ͻñ� �ٶ��ϴ�.";
				String am_url 	= "/fms2/ax_hub/ax_hub_c.jsp?am_ax_code="+am_ax_code;
				
				//������ȣ������
				ht_target_user1 	= ax_db.getUserCase(ax_bean.getReg_id());
				
				//�Աݴ����
				ht_target_user2 	= ax_db.getUserCase(nm_db.getWorkAuthUser("�Աݴ��"));
				
				//�ſ�ī������
				ht_target_user3 	= ax_db.getUserCase(nm_db.getWorkAuthUser("���ݰ�꼭�����"));
				
				String xml_data = "";
				
				xml_data =  "<COOLMSG>"+
  						"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
  						"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+am_sub+"</SUB>"+
  						"    <CONT>"+am_cont+"</CONT>"+
  						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+am_url+"</URL>";
	
				//�޴»��1
				xml_data += "    <TARGET>"+String.valueOf(ht_target_user1.get("ID"))+"</TARGET>";
								
				//�޴»��2
				xml_data += "    <TARGET>"+String.valueOf(ht_target_user2.get("ID"))+"</TARGET>";
				
				//�޴»��3
				xml_data += "    <TARGET>"+String.valueOf(ht_target_user3.get("ID"))+"</TARGET>";

				//�������
				xml_data += "    <SENDER>SYSTEM</SENDER>"+
	
		  				"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
		  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
  						"    <FLDTYPE>1</FLDTYPE>"+
		  				"  </ALERTMSG>"+
  						"</COOLMSG>";
	
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");
	
				boolean am_msg_flag = cm_db.insertCoolMsg(msg);
				
				//�޸�߼�
				boolean mm_flag1 = ax_db.sendMemo("999999", String.valueOf(ht_target_user1.get("USER_ID")), am_sub, am_cont);
				boolean mm_flag2 = ax_db.sendMemo("999999", String.valueOf(ht_target_user2.get("USER_ID")), am_sub, am_cont);
				boolean mm_flag3 = ax_db.sendMemo("999999", String.valueOf(ht_target_user3.get("USER_ID")), am_sub, am_cont);												
				            			
            			
		    		/* = -------------------------------------------------------------------------- = */
    				/* =   *** �Ƹ���ī ������ ���  END                                          = */
    				/* = -------------------------------------------------------------------------- = */
            			
            	
                		// 07-1-1-1. ���հ���(�ſ�ī��+����Ʈ)
                		if ( pnt_issue.equals( "SCSK" ) || pnt_issue.equals( "SCWB" ) )
                		{
				
                		}
			}
			

		}

        	/* = -------------------------------------------------------------------------- = */
        	/* =   07-2. ���� ���� DB ó��(res_cd != "0000")                                = */
        	/* = -------------------------------------------------------------------------- = */
		if( !"0000".equals ( res_cd ) )
		{
		
		
		}
	}	
    /* = -------------------------------------------------------------------------- = */
    /* =   07. ���� �� ���� ��� DB ó�� END                                        = */
    /* = ========================================================================== = */



    /* = ========================================================================== = */
    /* =   08. ���� ��� DB ó�� ���н� : �ڵ����                                  = */
    /* = -------------------------------------------------------------------------- = */
    /* =      ���� ����� DB �۾� �ϴ� �������� ���������� ���ε� �ǿ� ����         = */
    /* =      DB �۾��� �����Ͽ� DB update �� �Ϸ���� ���� ���, �ڵ�����          = */
    /* =      ���� ��� ��û�� �ϴ� ���μ����� �����Ǿ� �ֽ��ϴ�.                   = */
    /* =                                                                            = */
    /* =      DB �۾��� ���� �� ���, bSucc ��� ����(String)�� ���� "false"        = */
    /* =      �� ������ �ֽñ� �ٶ��ϴ�. (DB �۾� ������ ��쿡�� "false" �̿���    = */
    /* =      ���� �����Ͻø� �˴ϴ�.)                                              = */
    /* = -------------------------------------------------------------------------- = */

    	// ���� ��� DB ó�� ������ bSucc���� false�� �����Ͽ� �ŷ����� ��� ��û
	bSucc = ""; 
	
	
	
	//�Ƹ���ī DB ó�� ������ - �ڵ����� ������ҿ�û ���μ��� ����		
	if(!am_flag) bSucc = "false"; 
	
	
	

	if (req_tx.equals("pay") )
	{
		if (res_cd.equals("0000") )
		{
            		if ( bSucc.equals("false") )
            		{
                		int mod_data_set_no;

                		c_PayPlus.mf_init_set();

                		tran_cd = "00200000";

                		mod_data_set_no = c_PayPlus.mf_add_set( "mod_data" );

                		c_PayPlus.mf_set_us( mod_data_set_no, "tno",      tno      ); // KCP ���ŷ� �ŷ���ȣ
                		c_PayPlus.mf_set_us( mod_data_set_no, "mod_type", "STSC"   ); // ���ŷ� ���� ��û ����
                		c_PayPlus.mf_set_us( mod_data_set_no, "mod_ip",   cust_ip  ); // ���� ��û�� IP
                		c_PayPlus.mf_set_us( mod_data_set_no, "mod_desc", "������ ��� ó�� ���� - ���������� ��� ��û"  ); // ���� ����

				c_PayPlus.mf_do_tx( g_conf_site_cd, g_conf_site_key, tran_cd, cust_ip, ordr_idxx, g_conf_log_level, "0" );

                		res_cd  = c_PayPlus.m_res_cd;								  // ��� �ڵ�
                		res_msg = c_PayPlus.m_res_msg;								  // ��� �޽���
            		}
        	}
	}
	// End of [res_cd = "0000"]
    /* = -------------------------------------------------------------------------- = */
    /* =   08. ���� ��� DB ó�� END                                                = */
    /* = ========================================================================== = */


    /* ============================================================================== */
    /* =   09. �� ���� �� ��������� ȣ��                                           = */
    /* -----------------------------------------------------------------------------= */
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
    <head>
        <title>*** KCP [AX-HUB Version] ***</title>
        <script type="text/javascript">
            function goResult()
            {
                var openwin = window.open( 'proc_win.html', 'proc_win', '' )
                document.pay_info.submit()
                openwin.close()
            }

            // ���� �� ���ΰ�ħ ���� ���� ��ũ��Ʈ
            function noRefresh()
            {
                /* CTRL + NŰ ����. */
                if ((event.keyCode == 78) && (event.ctrlKey == true))
                {
                    event.keyCode = 0;
                    return false;
                }
                /* F5 ��Ű ����. */
                if(event.keyCode == 116)
                {
                    event.keyCode = 0;
                    return false;
                }
            }
            document.onkeydown = noRefresh ;
        </script>
    </head>

    <body onload="goResult()">
    <form name="pay_info" method="post" action="./result.jsp">
	<input type="hidden" name="site_cd"         value="<%= g_conf_site_cd	        %>">    <!-- ����Ʈ �ڵ� -->
	<input type="hidden" name="req_tx"          value="<%= req_tx			%>">    <!-- ��û ���� -->
        <input type="hidden" name="use_pay_method"  value="<%= use_pay_method	        %>">    <!-- ����� ���� ���� -->
        <input type="hidden" name="bSucc"           value="<%= bSucc			%>">    <!-- ���θ� DB ó�� ���� ���� -->

        <input type="hidden" name="res_cd"          value="<%= res_cd			%>">    <!-- ��� �ڵ� -->
        <input type="hidden" name="res_msg"         value="<%= res_msg			%>">    <!-- ��� �޼��� -->
        <input type="hidden" name="ordr_idxx"       value="<%= ordr_idxx		%>">    <!-- �ֹ���ȣ -->
        <input type="hidden" name="tno"             value="<%= tno			%>">    <!-- KCP �ŷ���ȣ -->
        <input type="hidden" name="good_mny"        value="<%= good_mny			%>">    <!-- �����ݾ� -->
        <input type="hidden" name="good_name"       value="<%= good_name		%>">    <!-- ��ǰ�� -->
        <input type="hidden" name="buyr_name"       value="<%= buyr_name		%>">    <!-- �ֹ��ڸ� -->
        <input type="hidden" name="buyr_tel1"       value="<%= buyr_tel1		%>">    <!-- �ֹ��� ��ȭ��ȣ -->
        <input type="hidden" name="buyr_tel2"       value="<%= buyr_tel2		%>">    <!-- �ֹ��� �޴�����ȣ -->
        <input type="hidden" name="buyr_mail"       value="<%= buyr_mail		%>">    <!-- �ֹ��� E-mail -->

	<input type="hidden" name="app_time"        value="<%= app_time			%>">	<!-- ���νð� -->
	
	<!-- �ſ�ī�� ���� -->
        <input type="hidden" name="card_cd"         value="<%= card_cd			%>">    <!-- ī���ڵ� -->
        <input type="hidden" name="card_name"       value="<%= card_name		%>">    <!-- ī���̸� -->
        <input type="hidden" name="app_no"          value="<%= app_no			%>">    <!-- ���ι�ȣ -->
	<input type="hidden" name="noinf"	    value="<%= noinf			%>">    <!-- �����ڿ��� -->
        <input type="hidden" name="quota"           value="<%= quota			%>">    <!-- �Һΰ��� -->
        <input type="hidden" name="partcanc_yn"     value="<%= partcanc_yn              %>">    <!-- �κ���Ұ������� -->
        <input type="hidden" name="card_bin_type_01" value="<%= card_bin_type_01        %>">    <!-- ī�屸��1 -->
        <input type="hidden" name="card_bin_type_02" value="<%= card_bin_type_02        %>">    <!-- ī�屸��2 -->



	<!-- ������ü ���� -->
        <input type="hidden" name="bank_name"       value="<%= bank_name		%>">    <!-- ����� -->
        <input type="hidden" name="bank_code"       value="<%= bank_code		%>">    <!-- �����ڵ� -->
	<!-- ������� ���� -->
        <input type="hidden" name="bankname"        value="<%= bankname			%>">    <!-- �Ա� ���� -->
        <input type="hidden" name="depositor"       value="<%= depositor		%>">    <!-- �Աݰ��� ������ -->
        <input type="hidden" name="account"         value="<%= account			%>">    <!-- �Աݰ��� ��ȣ -->
        <input type="hidden" name="va_date"         value="<%= va_date			%>">    <!-- ������� �Աݸ����ð� -->
	<!-- ����Ʈ ���� -->
	<input type="hidden" name="pnt_issue"	    value="<%= pnt_issue		%>">	<!-- ����Ʈ ���񽺻� -->
	<input type="hidden" name="pt_idno"	    value="<%= pt_idno			%>">	<!-- ���� �� ���� ���̵� -->
	<input type="hidden" name="pnt_app_time"    value="<%= pnt_app_time		%>">	<!-- ���νð� -->
        <input type="hidden" name="pnt_app_no"      value="<%= pnt_app_no		%>">	<!-- ���ι�ȣ -->
        <input type="hidden" name="pnt_amount"      value="<%= pnt_amount		%>">	<!-- �����ݾ� or ���ݾ� -->
        <input type="hidden" name="add_pnt"         value="<%= add_pnt			%>">	<!-- �߻� ����Ʈ -->
        <input type="hidden" name="use_pnt"         value="<%= use_pnt			%>">	<!-- ��밡�� ����Ʈ -->
        <input type="hidden" name="rsv_pnt"         value="<%= rsv_pnt			%>">	<!-- �� ���� ����Ʈ -->
	<!-- �޴��� ���� -->
        <input type="hidden" name="commid"          value="<%= commid			%>">	<!-- ��Ż� �ڵ� -->
        <input type="hidden" name="mobile_no"       value="<%= mobile_no		%>">	<!-- �޴��� ��ȣ -->
        <!-- ��ǰ�� ���� -->
        <input type="hidden" name="tk_van_code"     value="<%= tk_van_code		%>">	<!-- �߱޻� �ڵ� -->
        <input type="hidden" name="tk_app_no"       value="<%= tk_app_no		%>">	<!-- ���� ��ȣ -->
        <!-- ���ݿ����� ���� -->
        <input type="hidden" name="cash_yn"         value="<%= cash_yn			%>">	<!-- ���ݿ����� ��� ���� -->
        <input type="hidden" name="cash_authno"     value="<%= cash_authno		%>">	<!-- ���� ������ ���� ��ȣ -->
        <input type="hidden" name="cash_tr_code"    value="<%= cash_tr_code		%>">	<!-- ���� ������ ���� ���� -->
        <input type="hidden" name="cash_id_info"    value="<%= cash_id_info		%>">	<!-- ���� ������ ��� ��ȣ -->
        
        <input type="hidden" name="am_ax_code"        value="<%= am_ax_code   	%>" />   
        
    </form>
    </body>
</html>