<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*, acar.incom.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.fee.*, acar.bill_mng.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "":request.getParameter("t_wd");
		
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");		
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	
	if ( from_page.equals("")) from_page = "/fms2/account/incom_reg_step1.jsp" ;
	
	String rr 	= request.getParameter("rr")==null?"":request.getParameter("rr");	
	
	String t_ecar_chk 	= request.getParameter("t_ecar_chk")==null?"":request.getParameter("t_ecar_chk");	
				
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance(); 
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
		
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq			= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	long incom_amt			= request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	
		//����� ����Ʈ
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();
		
	int tot_line = 0;	
	long total_amt 	= 0;
		
	//���߼��õ� �ŷ�ó
	String all_cid 	= request.getParameter("all_cid")==null?"":request.getParameter("all_cid");
//	out.println("all_cid 1="+ all_cid);
			
//	System.out.println("length="+ all_cid.length());
	all_cid=AddUtil.substring(all_cid, all_cid.length() -1);
//	System.out.println("all_cid 2="+ all_cid);
	
	//������
	Vector grt_scds = new Vector();
	
	//������
	Vector pp_scds = new Vector();
	
	//���ô뿩��
	Vector rfee_scds = new Vector();
	
	//�°������
	Vector cha_scds = new Vector();
		
	//�뿩��
	Vector fee_scds = new Vector();
	
	//�뿩�Ῥü��
	Vector dly_scds = new Vector();
	
		//���·�
	Vector fine_scds = new Vector();	
	
	//��å��
	Vector serv_scds = new Vector();
	
	//��/������
	Vector insh_scds = new Vector();
	
	//���������
	Vector cls_scds = new Vector();
	
		
	//�ܱ� - 1�� ����Ʈ, �������
	Vector rent_scds = new Vector();
	
	
	//ģȯ���� ���Ǻ�����
	Vector green_scds = new Vector();
	
	
	//��üȽ��
	int dly_mon = 0;
	
	
	//��ü�� ���� - Ȯ���� ó��
	//if (!all_cid.equals("") ) {	
//			boolean dly_flag =  in_db.calReScdDly(all_cid);	
//	}

   if ( t_ecar_chk.equals("Y") ) {
    	green_scds = in_db.getFeeScdGreenChaClientList(all_cid);  //���ź�����
   } else {
     			
		if (!all_cid.equals("") ) {
		//������
			 grt_scds = in_db.getFeeScdGrtClientList(all_cid);	
			 pp_scds = in_db.getFeeScdPpClientList(all_cid);	
		     rfee_scds = in_db.getFeeScdRfeeClientList(all_cid);	
		     cha_scds = in_db.getFeeScdChaClientList(all_cid);  //�°������
		     green_scds = in_db.getFeeScdGreenChaClientList(all_cid);  //���ź�����
			 fee_scds = in_db.getFeeScdSettleClientList(all_cid, s_kd, t_wd);
			 dly_mon =  in_db.getFeeScdDlyClientCnt(all_cid, s_kd, t_wd);  //��üȽ��
			 dly_scds = in_db.getFeeScdDlyStatClient(all_cid, s_kd, t_wd);
			 fine_scds = in_db.getFineScdStatClient(all_cid, s_kd, t_wd);
	     	 serv_scds = in_db.getServScdStatClient(all_cid, s_kd, t_wd);
	         insh_scds = in_db.getServScdInshClient(all_cid, s_kd, t_wd); //20100101 ���� ó��
	         cls_scds = in_db.getServScdClsClient(all_cid);
	         rent_scds = in_db.getRentContScdClient(all_cid);  //�ܱ����Ʈ (1����_
	   
	    }
    
   }
   
    
   	int scd_size= 0; //total
   
   	int grt_size = grt_scds.size(); //������
   	int pp_size = pp_scds.size(); //������
   	int rfee_size = rfee_scds.size(); //���ô뿩��
   	int cha_size = cha_scds.size(); //�°������
   	int green_size = green_scds.size(); //���ź����� 
	int fee_size = fee_scds.size(); //��ü������
	int dly_size = dly_scds.size();
	int fine_size = fine_scds.size();
	int serv_size = serv_scds.size();	

	int insh_size = insh_scds.size();
	int cls_size = cls_scds.size();		
	int rent_size = rent_scds.size();	
				
	if(s_cnt.equals("") || s_cnt.equals("0")){
		if(dly_mon > 30) 		s_cnt=String.valueOf(dly_mon);
		else					s_cnt="30";
	}
		
//	if (fee_size == 0) s_cnt="0";

	if (fee_size <= AddUtil.parseInt(s_cnt) ) s_cnt=Integer.toString(fee_size);
	
	dly_mon = AddUtil.parseInt(s_cnt); // �뿩�� �κ�
 
 	
	scd_size = grt_size + pp_size + rfee_size + cha_size  + green_size + dly_mon + dly_size + fine_size + serv_size + insh_size + cls_size + rent_size;
	
		//�Աݰŷ����� ����
	IncomBean base = in_db.getIncomBase(incom_dt, incom_seq);
	long ip_amt = base.getIncom_amt();	
	String jung_type = base.getJung_type();	
	String ip_method = base.getIp_method();
		
	String value[] = new String[2];
	StringTokenizer st = new StringTokenizer(base.getBank_nm(),":");
	int s=0; 
	while(st.hasMoreTokens()){
		value[s] = st.nextToken();
		s++;
	}
	
	ClientBean client = new ClientBean();	
	
	String i_agnt_email = "";
	String i_agnt_nm    = "";
	String i_agnt_m_tel = "";	
	
	String ven_code = "";
	String ven_name = "";
	
	String fine_yn = "";
	
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	
		
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search_client();
	}			
	
	//����/���� ��ȸ
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}
		window.open("/fms2/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}	
			
	//����/���� ����
	function view_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}
		if(fm.site_id.value == "")	{ alert("����/������ ���� �����Ͻʽÿ�."); return;}		
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}		

	//�� ��ȸ
	function search_client()
	{
		fm = document.form1;			
					
		window.open("/fms2/account/s_cont.jsp?rr=<%=rr%>&s_cnt="+fm.s_cnt.value+"&incom_dt=<%=incom_dt%>&incom_seq=<%=incom_seq%>&incom_amt=<%=incom_amt%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_scd_step2.jsp", "CLIENT", "left=10, top=10, width=500, height=300, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	function cal_rc_rest(){
		var fm = document.form1;
	
		var scd_size 	= toInt(fm.scd_size.value);	
	       
		var rc_amt 		= toInt(parseDigit(fm.incom_amt.value));  //���� �Աݾ�
		var t_pay_amt 	= 0;
		
		var est_amt = 0;
		
		if ( scd_size < 2  ) {
			est_amt = toInt(parseDigit(fm.est_amt.value));
			
			if(rc_amt < est_amt){
					fm.pay_amt.value = parseDecimal(rc_amt);
					fm.cls_amt.value = '0';
					rc_amt 		= rc_amt - toInt(parseDigit(fm.pay_amt.value));				
			}else{
					fm.pay_amt.value = parseDecimal(est_amt);
					fm.cls_amt.value = '0';
					rc_amt = rc_amt - toInt(parseDigit(fm.pay_amt.value));				
			}			
			t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt.value));		
		
		} else {
		
			for(var i = 0 ; i < scd_size ; i ++){
	
				est_amt = toInt(parseDigit(fm.est_amt[i].value));				
				
				if(rc_amt < est_amt){
					fm.pay_amt[i].value = parseDecimal(rc_amt);
					fm.cls_amt[i].value = '0';
					rc_amt 		= rc_amt - toInt(parseDigit(fm.pay_amt[i].value));				
				}else{
					fm.pay_amt[i].value = parseDecimal(est_amt);
					fm.cls_amt[i].value = '0';
					rc_amt = rc_amt - toInt(parseDigit(fm.pay_amt[i].value));				
				}			
				t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt[i].value));			
			}
		}
			
		fm.t_pay_amt.value = parseDecimal(t_pay_amt);
		fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.incom_amt.value))-t_pay_amt);
		
	}
	
	function cal_rest(){
		var fm = document.form1;
	
		var scd_size 	= toInt(fm.scd_size.value);		
		
		var rc_amt 		= toInt(parseDigit(fm.incom_amt.value));
		var t_pay_amt 	= 0;

		if ( scd_size < 2  ) {
			t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt.value));		
		} else {
			for(var i = 0 ; i < scd_size ; i ++){
				t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt[i].value));			
			}
		}	
		
	
		fm.t_pay_amt.value = parseDecimal(t_pay_amt);
		fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.incom_amt.value))-t_pay_amt);
	}	
	
	function cal_cls_rest(){
		var fm = document.form1;
		
		var scd_size 	= toInt(fm.scd_size.value);		
		var rc_amt 		= toInt(parseDigit(fm.incom_amt.value));
		var t_pay_amt 	= 0;

		if ( scd_size < 2  ) {
			t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt.value));		
		} else {
			for(var i = 0 ; i < scd_size ; i ++){
				t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt[i].value));			
			}
		}	
		fm.t_pay_amt.value = parseDecimal(t_pay_amt);
		fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.incom_amt.value))-t_pay_amt);
	}	
	
	
	function save()
	{
		var fm = document.form1;
					
		//���·� ������ 		
		var scd_size 	= toInt(fm.scd_size.value);		
		var fine_chk_amt = 0;
		
		
		var cls_chk_amt = 0;
		
		if(fm.not_yet.checked == true){ 		//��Ȯ���Ա�
		
		} else {
			
			//��Ÿ �Աݺ�
			if (toInt(parseDigit(fm.ip_acct_amt.value)) > 0 ) {
			  if(fm.ip_acct.value == '')	{ alert('�׸��� �����Ͻʽÿ�.'); 	return;}
			 
			  if ( fm.n_ven_code.value == "" ) {
			   	 alert('�ŷ�ó�� �����ϼž� �մϴ�.');
				 return;
			  }			
			}
			
			//ī�� ��� ���̳ʽ� - �����ޱ�
			if (  toInt(parseDigit(fm.incom_amt.value)) <0 ) {
			
			 	if (  toInt(parseDigit(fm.incom_amt.value))  !=  toInt(parseDigit(fm.t_pay_amt.value))  ) {
					alert('�Ա�ó����(���)�� Ȯ���ϼ���');
					return;
				 }
			
			} else {
			
				if ( toInt(parseDigit(fm.t_pay_amt.value)) + toInt(parseDigit(fm.ip_acct_amt.value)) + toInt(parseDigit(fm.card_tax.value)) < 1) {
					alert('�Ա�ó������ Ȯ���ϼ���');
					return;
				}
			
			}
		
			
			//����					
			if( fm.ip_acct.value == '2' ){
			   if( toInt(parseDigit(fm.ip_acct_amt.value)) < 1 )
			   {
					alert('�ݾ��� Ȯ���ϼ���');
					return;
			   }	
			   if(toInt(parseDigit(fm.incom_amt.value)) + toInt(parseDigit(fm.ip_acct_amt.value)) !=  toInt(parseDigit(fm.t_pay_amt.value)) )
			   {
					alert('�Ա�ó���ݾ��� Ȯ���ϼ���');
					return;
			   }
			   
			} else if ( fm.ip_acct.value == '3'  || fm.ip_acct.value == '7'  ) {
			  if( toInt(parseDigit(fm.ip_acct_amt.value)) < 1 )
			   {
					alert('�ݾ��� Ȯ���ϼ���');
					return;
			   }	
			   if(toInt(parseDigit(fm.incom_amt.value)) != toInt(parseDigit(fm.ip_acct_amt.value)) +  toInt(parseDigit(fm.t_pay_amt.value)) )
			   {
					alert('�Ա�ó���ݾ��� Ȯ���ϼ���');
					return;
			   }
			
		
			} else {
				if(toInt(parseDigit(fm.incom_amt.value)) != toInt(parseDigit(fm.t_pay_amt.value)) + toInt(parseDigit(fm.card_tax.value)) + toInt(parseDigit(fm.ip_acct_amt.value)) ) 
				{
						alert('�Ա�ó���ݾ��� Ȯ���ϼ���');
						return;
				}			
			} 			
			
			if ( scd_size < 2  ) {
			    if ( scd_size == 0 ) {			    
			    } else { 
				    if ( fm.gubun.value == 'scd_cls') {
				    	 if ( toInt(fm.pay_amt.value) > 0 ) { //û���Ȱ� �߿���
					   		 if ( toInt(parseDigit(fm.cls_amt.value)) < 1 ) {
					  			   	  cls_chk_amt = 1;					  			    
					  	   	 }
					  	 }  	 
				    }	
				}    
			} else {
				for(var i = 0 ; i < scd_size ; i ++){			    
				     if ( fm.gubun[i].value == 'scd_cls') {
				    	if ( toInt(fm.pay_amt[i].value) > 0  ) {  //û���Ȱ� �߿���
					 		if ( toInt(parseDigit(fm.cls_amt[i].value)) < 1  ) {
				  			        cls_chk_amt = cls_chk_amt + 1;				 
				  			}
				  		}	  
					 }
				}
			}	
			
			if( cls_chk_amt > 0 ) {
				alert('����������� �ٽ� Ȯ���ϼ���');
				return;
			}	
			
			
			if ( scd_size < 2  ) {
			    if ( scd_size == 0 ) {			    
			    } else { 
				    if ( fm.fine_chk.value == '����û��') {
				    	 if ( toInt(fm.fine_dt.value) > 0 ) { //û���Ȱ� �߿���
					   		 if ( toInt(fm.incom_dt.value) >=  toInt(fm.fine_dt.value) ) {
					  			   if ( toInt(parseDigit(fm.pay_amt.value)) < 1 ) {
					  			   	  fine_chk_amt = 1;	
					  			   } 
					  	   	 }
					  	 }  	 
				    }	
				}    
			} else {
				for(var i = 0 ; i < scd_size ; i ++){			    
				     if ( fm.fine_chk[i].value == '����û��') {
				    	if ( toInt(fm.fine_dt[i].value) > 0 ) {  //û���Ȱ� �߿���
					 		if ( toInt(fm.incom_dt.value) >=  toInt(fm.fine_dt[i].value) ) {
					 			if ( toInt(parseDigit(fm.pay_amt[i].value)) < 1  ) {
				  			         fine_chk_amt = fine_chk_amt + 1;						 
				  			    }
				  			}   
				  		}	  
					 }
				}
			}	
		
			if(fm.fine_incom.checked == true){ 		//���·� ��������			
			} else {
				if( fine_chk_amt > 0 ) {
					alert('���·� ����û������ Ȯ���ϼ���');
					return;
				}	
			}	
		}
			   
			   
		if(confirm('3�ܰ� �Ա�ó���Ͻðڽ��ϱ�?'))
		{		
			fm.target = 'i_no';			
			fm.action = 'incom_reg_scd_step2_a.jsp'
			fm.submit();
		}		
	}	
	
	//���
	function del_incom()
	{
		var fm = document.form1;
							
		if(confirm('����ó���Ͻðڽ��ϱ�?'))
		{		
			fm.target = 'i_no';
			fm.action = 'incom_reg_step2_del_a.jsp'
			fm.submit();
		}		
	
	}
	
	//���
	function go_to_list(from_page)
	{
		var fm = document.form1;
		
		if (from_page == '/fms2/account/f_incom_frame.jsp' ) {
			fm.action = "./f_incom_frame.jsp";
		} else {
			fm.action = "./incom_r_frame.jsp";
		}
		
		fm.target = 'd_content';
		fm.submit();
	}
		
	//�������� �󼼳���
	function detail_list( seq, rent_mng_id, rent_l_cd, incom_amt)
	{
		fm = document.form1;			
		
	
		//ä���߽��� ���
		if ( fm.pay_gur[3].checked == true ) { 
			window.open("/fms2/account/cls_sub_list.jsp?pay_gur=Y&scd_size="+fm.scd_size.value+"&seq="+seq+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&incom_amt="+incom_amt, "de_list", "left=10, top=10, width=550, height=550, scrollbars=yes, status=yes, resizable=yes");		
		} else {			
			window.open("/fms2/account/cls_sub_list.jsp?pay_gur=N&scd_size="+fm.scd_size.value+"&seq="+seq+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&incom_amt="+incom_amt, "de_list", "left=10, top=10, width=550, height=550, scrollbars=yes, status=yes, resizable=yes");
		}
	}	
		
	//�ŷ�ó��ȸ�ϱ�
	function search(idx){
		var fm = document.form1;	
		var t_wd;
		if(fm.n_ven_name.value != ''){	fm.t_wd.value = fm.n_ven_name.value;		}
		else{ 							alert('��ȸ�� �ŷ�ó���� �Է��Ͻʽÿ�.'); 	fm.n_ven_name.focus(); 	return;}
		window.open("vendor_list.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=350, top=150, width=700, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
	}	
	
	function view_memo(m_id, l_cd)
	{
//		window.open("/fms2/con_fee/fee_memo_frame_s.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "FEE_MEMO", "left=0, top=0, width=850, height=750, resizable=yes, scrollbars=yes, status=yes");
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, resizable=yes, scrollbars=yes, status=yes");
	}	

	function view_dly(m_id, l_cd)
	{
		window.open("/fms2/account/re_cal_dly.jsp?incom_dt=<%=incom_dt%>&m_id="+m_id+"&l_cd="+l_cd, "dly_memo", "left=50, top=150, width=300, height=150, resizable=yes, scrollbars=yes, status=yes");
	}
	
	
		
	//���÷��� Ÿ��
	function cls_display(){
		var fm = document.form1;
				
		if ( fm.n_ven_code.value == '006371'  ||  fm.n_ven_code.value == '114764'   || fm.n_ven_code.value == '006328'  || fm.n_ven_code.value == '005481' || fm.n_ven_code.value == '608892' || fm.n_ven_code.value == '995578' || fm.n_ven_code.value == '608959' || fm.n_ven_code.value == '108454'  || fm.n_ven_code.value == '996115'  || fm.n_ven_code.value == '996126' || fm.n_ven_code.value == '107776' ||  fm.n_ven_code.value == '028641'   ||  fm.n_ven_code.value == '007812' ) { 
	                      
			if (fm.ip_acct.value == '15' ) {  //�����ݿ��� �̼������� ���� - 20190917
				 fm.remark.value = "��ü���ĳ�������";			
			} else {
				 fm.remark.value = "";		
			}				
		}			
			
	}	
	
	
		
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15" >
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
 <!-- <input type='hidden' name="from_page" 	value="/fms2/account/incom_reg_step1.jsp"> -->
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type="hidden" name="incom_dt" 			value="<%=incom_dt%>">
  <input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
  <input type="hidden" name="incom_amt" 		value="<%=ip_amt%>">
  <input type="hidden" name="client_id" >
  <input type='hidden' name='scd_size' value='<%=scd_size%>'>
  <input type='hidden' name='bank_code2' 	value='<%=value[0]%>'>
  <input type='hidden' name='deposit_no2' 	value='<%=base.getBank_no()%>'>
  <input type='hidden' name='bank_name' 	value='<%=value[1]%>'>   
  <input type='hidden' name='ip_method' 	value='<%=base.getIp_method()%>'>
  <input type="hidden" name="t_wd" value="">  
 <input type="hidden" name="rr" value="<%=rr%>">  
 
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	 
  	<tr> 
 		 <td align=right>
 		 &nbsp; <input type='text' name='s_cnt' size='2' value='<%=s_cnt%>' class='text'>�� 
 		 <a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_search.gif" align=absmiddle border="0"></a>
 		  <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%> 
 		 <% if ( jung_type.equals("0") || jung_type.equals("2") ) { %>&nbsp;<a href="javascript:del_incom()"><img src="/acar/images/center/button_delete.gif" align=absmiddle border="0"></a><% } %>
 		 <% } %>
 		 &nbsp;<a href="javascript:go_to_list('<%=from_page%>')"><img src="/acar/images/center/button_list.gif" align=absmiddle border="0"></a></td>
    </tr> 	
    
    <tr></tr><tr></tr><tr></tr>
      
    <tr id=tr_acct1 style="display:<%if( base.getJung_type().equals("2") ){%>none<%}else{%>''<%}%>"> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
    		<tr>  
		         <td class=title width=13%>������</td>
		         <td>&nbsp;<input type="checkbox" name="not_yet" value="1" >��Ȯ���Ա�
			  	</td>
			  	<td class=title width=13%>����</td>
            	<td>&nbsp;<input type='text' name='not_yet_reason' size='100' class='text' value=""></td>
			</tr>
		</table>
	  </td>		  	
	</tr>		      	 
 
    <tr>
      <td>&nbsp;</td>
    </tr>
         
  	<tr id=tr_acct2 style="display:''">
       <td>
	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 	 	
			<tr>
			 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������&nbsp;</span></td>
			</tr>	
			<tr>
		        <td class=line2></td>
		    </tr>
		    <!-- �߽��� ��� ������ ���� -->
		    <tr>
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 
		            <td class=title width=13%>��������</td>
		            <td colspan=3 >&nbsp;
					  <input type="radio" name="pay_gur" value="0" checked>����
					  <input type="radio" name="pay_gur" value="1">���뺸����
					  <input type="radio" name="pay_gur" value="2">��������
					  <input type="radio" name="pay_gur" value="3">ä���߽�
					  <input type="radio" name="pay_gur" value="4">��Ÿ
					</td>
								  
		          </tr>		  
		          <tr> 
		            <td class=title width=13%>��ȣ/����</td>
		            <td width=37%>&nbsp;
					  <input type='text' name='pay_gur_nm' size='50' class='text' value="">
					</td>					  
		            <td class=title width=13%>����/����</td>
		            <td width=40%>&nbsp;
					  <input type='text' name='pay_gur_rel' size='50' class='text' value="">
					</td>
		          </tr>		  
		        </table>
			  </td>
		    </tr>
		  
		</table>
	   </td>  	
    </tr>	  	    
	
	<tr>
	  <td><hr></td>
	</tr>	
		
    <tr> 
        <td align="right">&nbsp;<a href='javascript:cal_rc_rest()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_hj_bill.gif" align=absmiddle border="0"></a>&nbsp;&nbsp;(�Աݿ�����, ������ڼ�)</td>
    </tr>
        
    <tr>
        <td class=line2></td>
    </tr>
    
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                 	<td class="title" width='4%'>����</td>
                    <td class="title" width='17%'>��ȣ/����û��</td>
                    <td class="title" width='11%'>������ȣ</td>
                    <td class="title" width='21%'>����/����ȣ</td>					
                    <td class="title" width='4%'>ȸ��</td>
                    <td class="title" width='12%'>����</td>					
                    <td class="title" width='9%'>�Աݿ�����</td>
                    <td class="title" width='11%'>�����ݾ�</td>
                    <td class="title" width='11%'>�Ա�ó���ݾ�</td>
                  
                </tr>
				<%	if(grt_size > 0){
						for(int i = 0 ; i < grt_size ; i++){
							Hashtable grt_scd = (Hashtable)grt_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(grt_scd.get("EXT_AMT")));
					
							client = al_db.getNewClient(String.valueOf(grt_scd.get("CLIENT_ID")));
							i_agnt_nm		= client.getCon_agnt_nm();
							i_agnt_email	= client.getCon_agnt_email();
							i_agnt_m_tel	= client.getCon_agnt_m_tel();												
							scd_size++;
				%>
				<input type='hidden' name='gubun' value='scd_grt'>
				<input type='hidden' name='rent_mng_id' value='<%=grt_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=grt_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=grt_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=grt_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=grt_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=grt_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=grt_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=grt_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%//=grt_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=grt_scd.get("CLIENT_ID")%>'>
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>		
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=grt_scd.get("RENT_MNG_ID")%>', '<%=grt_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ȭ����'><%=i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=grt_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=grt_scd.get("CAR_NO")%></td>
                    <td align="center"><%=grt_scd.get("CAR_NM")%>&nbsp;<%=grt_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=grt_scd.get("EXT_TM")%></td>
                    <td align="center"><%=grt_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(grt_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(grt_scd.get("EXT_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>��</td>
                   
                </tr>							
				<%		}
					}%>		
				
				<%	if(pp_size > 0){
						for(int i = 0 ; i < pp_size ; i++){
							Hashtable pp_scd = (Hashtable)pp_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(pp_scd.get("EXT_AMT")));
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_pp'>
				<input type='hidden' name='rent_mng_id' value='<%=pp_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=pp_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=pp_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=pp_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=pp_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=pp_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=pp_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=pp_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%//=pp_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=pp_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>	
				<input type='hidden' name='rent_s_cd' value=''>	
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=pp_scd.get("RENT_MNG_ID")%>', '<%=pp_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ȭ����'><%=grt_size+i+1%></a></td>
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=pp_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=pp_scd.get("CAR_NO")%></td>
                    <td align="center"><%=pp_scd.get("CAR_NM")%>&nbsp;<%=pp_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=pp_scd.get("EXT_TM")%></td>
                    <td align="center"><%=pp_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(pp_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(pp_scd.get("EXT_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>��</td>
                   
                </tr>							
				<%		}
					}%>							
			
				<%	if(rfee_size > 0){
						for(int i = 0 ; i < rfee_size ; i++){
							Hashtable rfee_scd = (Hashtable)rfee_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(rfee_scd.get("EXT_AMT")));
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_rfee'>
				<input type='hidden' name='rent_mng_id' value='<%=rfee_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=rfee_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=rfee_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=rfee_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=rfee_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=rfee_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=rfee_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=rfee_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%//=rfee_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=rfee_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=rfee_scd.get("RENT_MNG_ID")%>', '<%=rfee_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ȭ����'><%=grt_size+pp_size+i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=rfee_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=rfee_scd.get("CAR_NO")%></td>
                    <td align="center"><%=rfee_scd.get("CAR_NM")%>&nbsp;<%=rfee_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=rfee_scd.get("EXT_TM")%></td>
                    <td align="center"><%=rfee_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(rfee_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(rfee_scd.get("EXT_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>��</td>
                  
                </tr>							
				<%		}
					}%>	
					
					
				<%	if(cha_size > 0){
						for(int i = 0 ; i < cha_size ; i++){
							Hashtable cha_scd = (Hashtable)cha_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(cha_scd.get("EXT_AMT")));
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_cha'>
				<input type='hidden' name='rent_mng_id' value='<%=cha_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=cha_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=cha_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=cha_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=cha_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=cha_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=cha_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=cha_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%//=cha_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=cha_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
                <tr>
                	<td align="center"><%=grt_size+pp_size+rfee_size+i+1%></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=cha_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=cha_scd.get("CAR_NO")%></td>
                    <td align="center"><%=cha_scd.get("CAR_NM")%>&nbsp;<%=cha_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=cha_scd.get("EXT_TM")%></td>
                    <td align="center"><%=cha_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(cha_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(cha_scd.get("EXT_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>��</td>
                  
                </tr>	
                
                			<%		}
					}%>	
				
				<%	if(fine_size > 0){
						for(int i = 0 ; i < fine_size ; i++){
							Hashtable fine_scd = (Hashtable)fine_scds.elementAt(i);
							
							fine_yn =  ad_db.getClientFineYn(String.valueOf(fine_scd.get("CLIENT_ID")));
														
							if ( String.valueOf(fine_scd.get("V_GUBUN")).equals("3") ) {
								fine_yn = "";
							}					
							
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_fine'>
				<input type='hidden' name='rent_mng_id' value='<%=fine_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=fine_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value=''>
				<input type='hidden' name='rent_seq' value=''>
				<input type='hidden' name='fee_tm' value=''>
				<input type='hidden' name='tm_st1' value=''>
				<input type='hidden' name='tm_st2' value='<%=fine_scd.get("SEQ_NO")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=fine_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value=''>
				<input type='hidden' name='rtn_client_id' value='<%=fine_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
				
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=fine_scd.get("RENT_MNG_ID")%>', '<%=fine_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ȭ����'><%=grt_size+pp_size+rfee_size+cha_size+i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='<%=fine_yn%>'><%=fine_scd.get("FIRM_NM")%>&nbsp;&nbsp;<%=fine_yn%></td>		
					<td align="center"><%=fine_scd.get("CAR_NO")%></td>
                    <td align="center"><%=fine_scd.get("CAR_NM")%>&nbsp;<%=fine_scd.get("RENT_L_CD")%>&nbsp;<%=fine_scd.get("VIO_CONT")%></td>					
                    <td align="center"><%=fine_scd.get("SEQ_NO")%></td>
                    <td align="center">���·�&nbsp;&nbsp;<%=fine_scd.get("RES_ST")%></td>				
                    <td align="center"><input type='hidden' name='fine_dt' value='<%=String.valueOf(fine_scd.get("PROXY_DT"))%>'><%=AddUtil.ChangeDate2(String.valueOf(fine_scd.get("PROXY_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fine_scd.get("PAID_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>��</td>
               	
                </tr>	
                	
				<%		}
					}%>										
				
				<%	if(dly_mon > 0){
						if(fee_size > AddUtil.parseInt(s_cnt))	fee_size = AddUtil.parseInt(s_cnt);
						for(int i = 0 ; i <fee_size ; i++){
							Hashtable fee_scd = (Hashtable)fee_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(fee_scd.get("FEE_AMT")));
							scd_size++;
							
							String fee_ven_code = "";
							String fee_site_id = "";
							
							
							//�׿����ŷ�ó
							client = al_db.getNewClient(String.valueOf(fee_scd.get("CLIENT_ID")));
							fee_ven_code = client.getVen_code();
													
							if ( !String.valueOf(fee_scd.get("R_SITE")).equals("") ) {
								//���⺻����
							//	ContBaseBean base2 = a_db.getCont(String.valueOf(fee_scd.get("RENT_MNG_ID")), String.valueOf(fee_scd.get("RENT_L_CD")));
									
							//	fee_site_id = base2.getR_site();	
							         fee_site_id = String.valueOf(fee_scd.get("R_SITE"));
							         
							       	ClientSiteBean site = al_db.getClientSite(String.valueOf(fee_scd.get("CLIENT_ID")), fee_site_id);
						  		 if (!site.getVen_code().equals("")) fee_ven_code = site.getVen_code();  
							  								
							}
							//���⺻����
							//ContBaseBean base2 = a_db.getCont(String.valueOf(fee_scd.get("RENT_MNG_ID")), String.valueOf(fee_scd.get("RENT_L_CD")));
									
							//fee_site_id = base2.getR_site();	
						
							//ClientSiteBean site = al_db.getClientSite(String.valueOf(fee_scd.get("CLIENT_ID")), fee_site_id);
						         //if (!site.getVen_code().equals("")) fee_ven_code = site.getVen_code();
				
				%>				
				<input type='hidden' name='gubun' value='scd_fee'>
				<input type='hidden' name='rent_mng_id' value='<%=fee_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=fee_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=fee_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=fee_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=fee_scd.get("FEE_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=fee_scd.get("TM_ST1")%>'>
				<input type='hidden' name='tm_st2' value='<%=fee_scd.get("TM_ST2")%>'>
				<input type='hidden' name='car_mng_id' value='<%=fee_scd.get("CAR_MNG_ID")%>'>	
				<input type='hidden' name='accid_id' value='<%//=serv_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=fee_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>	
				<input type='hidden' name='rent_s_cd' value=''>			
                <tr>
                    <td align="center"><a href="javascript:view_memo('<%=fee_scd.get("RENT_MNG_ID")%>', '<%=fee_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ȭ����'><%=grt_size+pp_size+rfee_size+cha_size+fine_size+ i+1%></a></td>		
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=fee_scd.get("FIRM_NM")%>(<%=fee_ven_code%>)</td>		
                    <td align="center"><%=fee_scd.get("CAR_NO")%></td>
                    <td align="center"><%=fee_scd.get("CAR_NM")%>&nbsp;<%=fee_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=fee_scd.get("FEE_TM")%></td>
                    <td align="center"><%=fee_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(fee_scd.get("R_FEE_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' readonly size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fee_scd.get("FEE_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>��</td>
               		
                </tr>							
								
		<%		}
				}%>
					
				<%	if(dly_size > 0){
						for(int i = 0 ; i < dly_size ; i++){
							Hashtable dly_scd = (Hashtable)dly_scds.elementAt(i);
							
							int dly_jan_amt = 0;
							
						//	dly_jan_amt = AddUtil.parseInt(String.valueOf(dly_scd.get("JAN_AMT")));
						//	total_amt 	= total_amt + Long.parseLong(String.valueOf(dly_scd.get("JAN_AMT")));
							//��ü���ڸ� �Ա��Ϸ� ����Ѱ� ������ 	- 202202-16 ����						
							dly_jan_amt = in_db.getReCalDelayAmt(String.valueOf(dly_scd.get("RENT_MNG_ID")), String.valueOf(dly_scd.get("RENT_L_CD")), incom_dt);		
							total_amt 	= total_amt + Long.parseLong(Integer.toString(dly_jan_amt));
							
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_dly'>
				<input type='hidden' name='rent_mng_id' value='<%=dly_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=dly_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%//=dly_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%//=dly_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%//=dly_scd.get("FEE_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%//=dly_scd.get("TM_ST1")%>'>
				<input type='hidden' name='tm_st2' value='<%//=dly_scd.get("TM_ST2")%>'>	
				<input type='hidden' name='car_mng_id' value='<%=dly_scd.get("CAR_MNG_ID")%>'>	
				<input type='hidden' name='accid_id' value='<%//=dly_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=dly_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
							
                <tr>
                    <td align="center"><a href="javascript:view_dly('<%=dly_scd.get("RENT_MNG_ID")%>', '<%=dly_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ü����'><%=grt_size+pp_size+rfee_size+cha_size+fine_size+dly_mon + i+1%></a></td>	
		  <td align="center"><input type='hidden' name='fine_chk' value='N'><%=dly_scd.get("FIRM_NM")%></td>		
                    <td align="center"><%=dly_scd.get("CAR_NO")%>&nbsp;<% if (dly_scd.get("USE_YN").equals("N") ) {%>����<%} %> </td>
                    <td align="center"><%=dly_scd.get("CAR_NM")%>&nbsp;<%=dly_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%//=fee_scd.get("FEE_TM")%>-</td>
                    <td align="center"><%//=fee_scd.get("TM_ST1_NM")%>�뿩�� ��ü��</td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%//=AddUtil.ChangeDate2(String.valueOf(fee_scd.get("R_FEE_EST_DT")))%>-</td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(dly_jan_amt)%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>��</td>
                	
                </tr>				
                											
				<%		}
					}%>	
					
				<%	if(serv_size > 0){
						for(int i = 0 ; i < serv_size ; i++){
							Hashtable serv_scd = (Hashtable)serv_scds.elementAt(i);
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_serv'>
				<input type='hidden' name='rent_mng_id' value='<%=serv_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=serv_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=serv_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=serv_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=serv_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=serv_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=serv_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=serv_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%=serv_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=serv_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
				
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=serv_scd.get("RENT_MNG_ID")%>', '<%=serv_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ȭ����'><%=grt_size+pp_size+rfee_size+cha_size+fine_size + dly_mon+dly_size+ i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=serv_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=serv_scd.get("CAR_NO")%></td>
                    <td align="center"><%=serv_scd.get("CAR_NM")%>&nbsp;<%=serv_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=serv_scd.get("EXT_TM")%></td>
                    <td align="center"><%=serv_scd.get("TM_ST1_NM")%>&nbsp;&nbsp;<%=serv_scd.get("RES_ST")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(serv_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(serv_scd.get("EXT_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>��</td>
               	
                </tr>							
				<%		}
					}%>			
				<!--  ������� �Ƹ���ī �޴�����, ������� ���� -->	
				<%	if(insh_size > 0){
						for(int i = 0 ; i < insh_size ; i++){
							Hashtable insh_scd = (Hashtable)insh_scds.elementAt(i);
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_insh'>
				<input type='hidden' name='rent_mng_id' value='<%=insh_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=insh_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=insh_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=insh_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=insh_scd.get("EXT_TM")%>'>
						
				<input type='hidden' name='tm_st2' value='<%=insh_scd.get("SEQ_NO")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=insh_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%=insh_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=insh_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value='<%=insh_scd.get("ITEM_ID")%>'>  <!--  item_id�� 1�̸� ������ ,2�� ������   -->	
				<input type='hidden' name='rent_s_cd' value='<%=insh_scd.get("RENT_S_CD")%>'>	
				
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=insh_scd.get("RENT_MNG_ID")%>', '<%=insh_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ȭ����'><%=grt_size+pp_size+rfee_size+cha_size+fine_size+dly_mon + dly_size+serv_size+i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=insh_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=insh_scd.get("CAR_NO")%></td>
                    <td align="center"><%=insh_scd.get("CAR_NM")%>&nbsp;<%=insh_scd.get("RENT_L_CD")%>-<%=insh_scd.get("REQ_GU")%>-<%=insh_scd.get("INS_COM")%>-<%=String.valueOf(insh_scd.get("ACCID_DT")).substring(0,8)%></td>					
                    <td align="center"><%=insh_scd.get("SEQ_NO")%></td>
                    <td align="center"> 
                      <select name="tm_st1">
                        <option value="2">������</option>
                        <option value="1">������</option>                      
                      </select>
                      &nbsp;<%=insh_scd.get("TM_ST1_NM")%>
                    </td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(insh_scd.get("REQ_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(insh_scd.get("REQ_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>��</td>
               		
                </tr>							
				<%		}
					}%>		
							
				<!--  ����������ϰ��Ա�ó������Ʈ - ���·�, ��å��, �뿩��, �뿩������, ���������, ����ȸ�����ֺ��, ����ȸ���δ���, ��Ÿ���ع��� -->	
				<%	if(cls_size > 0){
						for(int i = 0 ; i < cls_size ; i++){
							Hashtable cls_scd = (Hashtable)cls_scds.elementAt(i);
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_cls'>
				<input type='hidden' name='rent_mng_id' value='<%=cls_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=cls_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value=''>
				<input type='hidden' name='rent_seq' value=''>
				<input type='hidden' name='fee_tm' value='<%=cls_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value=''> 
				<input type='hidden' name='tm_st2' value=''>				
				<input type='hidden' name='car_mng_id' value='<%=cls_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value=''>
				<input type='hidden' name='rtn_client_id' value='<%=cls_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
				
				
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=cls_scd.get("RENT_MNG_ID")%>', '<%=cls_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='��ȭ����'><%=grt_size+pp_size+rfee_size+cha_size+dly_mon+dly_size+fine_size+serv_size+insh_size+i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=cls_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=cls_scd.get("CAR_NO")%></td>
                    <td align="center"><%=cls_scd.get("CAR_NM")%>&nbsp;<%=cls_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=cls_scd.get("EXT_TM")%></td>
                    <td align="center"><%=cls_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(cls_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(cls_scd.get("EXT_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' readonly class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��
                    &nbsp;<a href="javascript:detail_list('<%=grt_size+pp_size+rfee_size+cha_size+dly_mon+dly_size+fine_size+serv_size+insh_size+i+1%>','<%=cls_scd.get("RENT_MNG_ID")%>','<%=cls_scd.get("RENT_L_CD")%>', '<%=incom_amt%>' );"><img src="/images/esti_detail.gif" align="absmiddle" border="0" alt="�󼼳�������"></a>	
                    </td>
               		
                </tr>		
                					
				<%		}
					}%>	
					
		<!--  ����Ʈ, �������   �ϰ��Ա�ó������Ʈ -->	
				<%	if(rent_size > 0){
						for(int i = 0 ; i < rent_size ; i++){
							Hashtable rent_scd = (Hashtable)rent_scds.elementAt(i);
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_rent'>
				<input type='hidden' name='rent_mng_id' value=''>
				<input type='hidden' name='rent_l_cd' value=''>
				<input type='hidden' name='rent_st' value='<%=rent_scd.get("RENT_ST")%>'> <!-- scd_rent�� rent_st 3:�뿩�� 6:������ -->
				<input type='hidden' name='rent_seq' value=''>
				<input type='hidden' name='fee_tm' value='<%=rent_scd.get("TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=rent_scd.get("PAID_ST")%>'>  <!--1:����(��ü),  2:ī��  -->
				<input type='hidden' name='tm_st2' value=''>		
				<input type='hidden' name='car_mng_id' value='<%=rent_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value=''>
				<input type='hidden' name='rtn_client_id' value='<%=rent_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value='<%=rent_scd.get("RENT_S_CD")%>'>	<!--����Ʈ -->
				
				
                <tr>                            
                	<td align="center"><%=grt_size+pp_size+rfee_size+cha_size+dly_mon+dly_size+fine_size+serv_size+insh_size+cls_size+i+1%></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=rent_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=rent_scd.get("CAR_NO")%></td>
                    <td align="center"><%=rent_scd.get("CAR_NM")%>&nbsp;<%=rent_scd.get("RENT_S_CD")%></td>					
                    <td align="center"><%=rent_scd.get("TM")%></td>
                    <td align="center"><%=rent_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(rent_scd.get("EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(rent_scd.get("EXT_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>��</td>
               		
                </tr>							
				<%		}
					}%>	
					
					<!--  ���ź�����  �ϰ��Ա�ó������Ʈ -->	
				<%	if(green_size > 0){
						for(int i = 0 ; i < green_size ; i++){
							Hashtable green_scd = (Hashtable)green_scds.elementAt(i);
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_green'>
				<input type='hidden' name='rent_mng_id' value='<%=green_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=green_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=green_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=green_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=green_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=green_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=green_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=green_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%//=green_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=green_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
                <tr>
                	<td align="center"><%=grt_size+pp_size+rfee_size+cha_size+dly_mon+dly_size+fine_size+serv_size+insh_size+cls_size+rent_size+i+1%></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=green_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=green_scd.get("CAR_NO")%></td>
                    <td align="center"><%=green_scd.get("CAR_NM")%>&nbsp;<%=green_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=green_scd.get("EXT_TM")%></td>
                    <td align="center"><%=green_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(green_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(green_scd.get("EXT_AMT")))%>'>��</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>��</td>
                  
                </tr>	
				<%		}
					}%>		
					
											
		 <tr>
                    <td colspan="7" class=title>�հ�</td>
                    <td class=title><input type='text' name='t_est_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt)%>'>��</td>
                    <td class=title><input type='text' name='t_pay_amt' size='10' class='fixnum' value=''>��</td>
                  
                </tr>																																				
                <tr>
                    <td colspan="7" class=title>�ܾ�</td>
                    <td class=title><input type="checkbox" name="s_neom" value="Y" checked >��ǥ����</td>
                    <td class=title><input type='text' name='t_jan_amt' size='10' class='fixnum' value=''>��</td>
                  
                </tr>																																				
            </table>
        </td>
    </tr>	
  
    <!-- ī���� ��� ī�� ������ -->
    <tr>
        <td class=h></td>
    </tr>  

   	<tr id=tr_card style="display:<%if( ip_method.equals("2") ){%>''<%}else{%>none<%}%>">    	
   	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ī�������&nbsp;</span></td>
 	 	  </tr>  
	      <tr>
	        <td class=line2></td>
	      </tr>
	      <tr>
	        <td class=line>
	          <table width=100% border=0 cellspacing=1 cellpadding=0>
	                <tr>	       
			            <td class=title width=13%>ī�������</td>
			            <td colspan="5">&nbsp;
						   <input type='text' name='card_tax' size='25' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
		         	</tr>
		       
		        </table>
			  </td>
		    </tr>		  
		</table>
	   </td>  
	   	
    </tr>	  	    
    
    <tr>
        <td class=h></td>
    </tr>  
    
   	<tr id=tr_acct8 style="display:''">
       <td>
	    <table border="0" cellspacing="0" cellpadding="0" width=100%> 	 	
			<tr>
			 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ÿ&nbsp;</span></td>
			</tr>	
			<tr>
		        <td class=line2></td>
		    </tr>
		 
		    <tr>
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		      
		          <tr> 
		            <td class=title width=13%>�ŷ�ó</td>
		            <td >&nbsp;
		            	<input name="n_ven_name" type="text" class="text" value="<%=ven_name%>" size="35" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">
						&nbsp;&nbsp;&nbsp;* �׿����ڵ� : &nbsp;	        
						<input type="text" readonly name="n_ven_code" value="<%=ven_code%>" class='whitetext' >
					       	<input type="hidden" name="n_ven_nm_cd"  value="">&nbsp;			
						<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> 				
					</td>	         
					<td class=title width=13%>�ݾ�</td>
		            <td >&nbsp;
					   <input type='text' name='ip_acct_amt' size='25' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>
					</td> 
		          </tr>	
		          <tr> 
		            <td class=title width=13%>�׸�</td>
		            <td colspan= >&nbsp;
		            <select name='ip_acct'  onChange='javascript:cls_display()'>
			              <option value=''>-����-</option>
		                      <option value='0'>������</option>		         
		                      <option value='15'>�̼���</option>           
		                      <option value='3'>��ȯ��</option>
		                      <option value='26'>�ǹ������</option>
		                      <option value='4'>��å��</option>
		                      <option value='5'>������</option>		                      
		                      <option value='6'>ī��ĳ����</option>
		                      <option value='17'>������ĳ����</option>
		                      <option value='7'>���ݰ�����</option>
		                      <option value='8'>�ܻ�����</option>
		                      <option value='9'>���޼�����</option>
		                      <option value='10'>�����ޱ�</option>    
		                      <option value='11'>�����ޱ�</option>    
		                      <option value='12'>������</option>  
		                      <option value='13'>���·�̼���</option>     
		                      <option value='14'>���ޱ�</option>  		              
		                      <option value='16'>�ܱ����Ա�</option>      
		                      <option value='18'>���ڼ���</option>     
		                     <option value='1'>���°������</option>
		                     <option value='2'>ä���߽ɼ�����</option>        
		                     <option value='19'>��������</option>       
		                     <option value='20'>��ݺ�</option>                
		                     <option value='21'>�������</option>              
		                     <option value='22'>�����޿�</option>    
		                     <option value='23'>���������</option>   
		                     <option value='24'>������������Ա�</option>   
		                     <option value='25'>����ȸ��������Ա�</option>                                 
                   	 </select> 
                    
		   	  <td class=title width=13%>��/����</td>
		            <td>&nbsp;
			  			<input type="radio" name="acct_gubun" value="C" checked >�뺯 
			  			<input type="radio" name="acct_gubun" value="D" >���� 
                 		   </td>
			  
		          </tr>	
		          <tr> 
		            <td class=title width=13%>Ư�̻���</td>
		            <td colspan=3 >&nbsp;
		                <input name="remark" type="text"   class="text" size="80" >	
		      	&nbsp;&nbsp;
						<input type="checkbox" name="neom" value="Y" checked >��ǥ����   
				&nbsp;&nbsp;
						<input type="checkbox" name="cool" value="Y" >�޼���������</td>	    		  						
		          </tr>				    
		        </table>
			  </td>
		    </tr>
		  
		</table>
	   </td>  	
    </tr>	  	    
    
    <tr>
        <td>&nbsp;</td>
    </tr>      
    
    <tr>    	
   	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
        
	      <tr>
	        <td class=line2></td>
	      </tr>
	      <tr>
	        <td class=line>
	          <table width=100% border=0 cellspacing=1 cellpadding=0>
	                <tr>	       
			            <td class=title width=13%>���·Ό��</td>
			            <td colspan="5">&nbsp;
						  <input type="checkbox" name="fine_incom" value="Y" >����</td>
		         	</tr>
		       
		        </table>
			  </td>
		    </tr>		  
		</table>
	   </td>  	
    </tr>	  	    
    
    <!--			
	<tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td  class=title width=10%>��������<br>������</td>
                    <td  width=12%>&nbsp;
						  <select name='dly_saction_id'>
			                <option value="">--����--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
			              </select>
			        </td>
                    <td class=title width=12%>�������� ����</td>
                    <td colspan=3>&nbsp;<textarea name="dly_reason" cols="105" class="text" style="IME-MODE: active" rows="2"></textarea></td> 
			
                </tr>
       		</table>
       	</td>
    </tr>
    -->   		         

	<tr>
      <td>&nbsp;</td>
    </tr>

   	<tr id=tr_ebill style="display:<%if( grt_size > 0 ){%>''<%}else{%>none<%}%>">    	
   	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ա�ǥ&nbsp;</span></td>
 	 	  </tr>  
	      <tr>
	        <td class=line2></td>
	      </tr>
	      <tr>
	        <td class=line>
	          <table width=100% border=0 cellspacing=1 cellpadding=0>
	                <tr>	       
			            <td class=title width=13%>�����Ա�ǥ</td>
			            <td colspan="5">&nbsp;
						  <input type="checkbox" name="ebill" value="Y" <%if(!i_agnt_email.equals(""))%>checked<%%>> ����</td>
		         	</tr>
		       
		        </table>
			  </td>
		    </tr>		  
		</table>
	   </td>  	
    </tr>	  	    
      		    
    <tr>
      <td>&nbsp;</td>
    </tr>
    
    <% if (nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id)  || nm_db.getWorkAuthUser("�������ⳳ",user_id)  || nm_db.getWorkAuthUser("�λ��ⳳ",user_id) || user_id.equals("000177") ){%>

    <tr>
		<td align="right">		
		 <a href="javascript:save();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>	
		</td>
	</tr>	
	<%}%>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--

//-->
</script>
</body>
</html>
