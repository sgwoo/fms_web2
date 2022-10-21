<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.credit.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.con_tax.*, acar.fee.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
		
	//�����⺻����
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//����������� ����Ʈ
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
	
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//fee ��Ÿ - ����Ÿ� �ʰ��� ���
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
	 // ���Կɼǽ�:  agree_dist_yn  1:���׸���,  2:50% ����,  3:100%����
	 
	  int  o_amt =   car1.getOver_run_amt();
	  
//	 out.println(o_p_m);
//	 out.println(fee_size);
		
	Vector ht = af_db.getFeeScdCng(rent_l_cd, Integer.toString(fee_size), "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//����� ����Ʈ
	Vector users1 = c_db.getUserList("", "", "SACTION");
	int user_size1 = users1.size();	
	
	//�⺻����
	Hashtable base1 = as_db.getSettleBaseRm(rent_mng_id, rent_l_cd, "", "");
	
	    	
	//���ຸ������
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//���뺸���� 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
	
	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;
		
	
	int pp_amt = AddUtil.parseInt((String)base1.get("PP_S_AMT"));
	
		//��å�� ��û���� ���� ����ó�� ���� ����
	int car_ja_no_amt =  ac_db.getCarServiceBillNo(rent_mng_id, rent_l_cd);
		
	Vector cms_bnk = c_db.getCmsBank();	//������� �����´�.
	int cms_bnk_size1 = cms_bnk.size();
	
	//cms ����
	Hashtable h_cms = c_db.getCmsBank_info(rent_l_cd);
	
	//card  cms ���� 
	Hashtable h1_cms = c_db.getCardCms_info(rent_l_cd);
	
	String re_bank = "";
	String re_acc_no = "";
	String re_acc_nm = "";
		
	re_bank = (String)h_cms.get("CBNK");
	re_acc_no = (String) h_cms.get("CBNO");
	re_acc_nm = (String) h_cms.get("CYJ");
	
	if ( h1_cms.get("CBNO")  == null  ) 	{
	} else{ 
		re_acc_no = (String) h1_cms.get("CBNO");
		re_acc_nm = (String) h1_cms.get("CYJ");
	}
	
	//������ ��ϵǾ����� ����
	int reg_cnt = 0;
	reg_cnt= ac_db.getClsEtcCnt(rent_mng_id, rent_l_cd);
		
		
	//�������� ����Ʈ
	Vector vt_ext = as_db.getClsList(base.getClient_id());
	int vt_size = vt_ext.size();
					
			//����Ʈ����
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
	
        //
   	String per = f_fee_rm.getAmt_per();
		
	//���뿩���� ������
	Hashtable day_pers = c_db.getEstiRmDayPers(per);

	int add_amt_d = 0;  //1�޹̸� ����� ��� ����� ( ȯ�ұݾ�: �뿩�� - �����)
	int r_day_per = 0;
	
	int day_per[] = new int[30];

	//�������� ī��Ʈ
	int day_cnt = 0;

	//�̿�Ⱓ
	int tot_months = AddUtil.parseInt((String)base1.get("R_MON"));  
	int tot_days = AddUtil.parseInt((String)base1.get("R_DAY"));  			
								
	for (int j = 0 ; j < 30 ; j++){
		day_per[j] = AddUtil.parseInt((String)day_pers.get("PER_"+(j+1)));
		
		if(j+1 == 30){
			if(day_per[j]>100) 	day_per[j] = 0;
		}else{
			if(day_per[j]>99) 	day_per[j] = 0;
		}
			
		if(day_per[j]>0) 	day_cnt++;	

		if(tot_months == 0){
			//������
			if(j+1 == tot_days)	r_day_per = 	day_per[j];	
		}		
	}			
	
//	out.println(day_cnt);
//	out.println(tot_days);
//	out.println(r_day_per);
      		
	if(tot_months == 0  ){		
	    if ( day_cnt >  tot_days ) {	
			add_amt_d = (new Double(AddUtil.parseInt((String)base1.get("FEE_S_AMT"))	)).intValue() * r_day_per / 100;
		}	

	}else if(tot_months > 0){				

	}
	
	 CodeBean[] goods = c_db.getCodeAll3("0027");
	int good_size = goods.length;           
	
	String a120_days = c_db.addDay(AddUtil.getDate(4) , 120) ; // 4 ������ 
		
		//ī�� cms ��ü�� ��� - ���̽��� ���ؼ� ����Ÿ�� ó���� ���  �Ǵ� 1ȸ���ΰ�� 
	Vector vt_card = ac_db.getCardCancel(rent_l_cd);
	int vt_c_size = vt_card.size();	
	
 //  int amt_2_over =  ac_db.getCardCancelAmt(rent_l_cd);  //card cms ���� �ƴϸ鼭 �������� �� check
 //   int amt_2_cnt =  ac_db.getCardCancelCnt(rent_l_cd);  //card cms ���� �ƴϸ鼭 �������� �� check
	
 // ����Ʈ �����Ա��� ��� ȯ�Ұ���ó�� - 20200911 �ֱ� 2������ �������� 
	String ip_chk = "";
 
 	Vector vt_ip = ac_db.getIpMethod(rent_l_cd);  
 	int vt_ip_size = vt_ip.size();
 	
	if ( vt_ip_size > 0) {
	 	for(int i = 0 ; i < 1 ; i++)
		{
			Hashtable ht_ip = (Hashtable) vt_ip.elementAt(i);	 
			
			if ( String.valueOf(ht_ip.get("IP_METHOD")).equals("1") ) {   //�������� �����ߴٸ� 
				ip_chk = "1";
			}			
		}	
 	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language="JavaScript">
<!--	
	
	//��ĵ���� ����
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
	
		
	//������ ��ȸ
	function car_search()
	{
		var fm = document.form1;
		window.open("search_ext_car.jsp", "EXT_CAR", "left=100, top=100, width=600, height=500, resizable=yes, scrollbars=yes, status=yes");
	}	

	//�� ����
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//����/���� ����
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}			

	//�ڵ���������� ����
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//�뿩���
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=50, top=50, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//�Է¿����� ���� ���� - �ŷ�ó�� ����, �뿩�������� ���� �ݾ׵� ����... ���
	function save1(){
		var fm = document.form1;
			
		if(fm.rent_start_dt.value != '')			{ alert('�뿩���ð��Դϴ�.'); 		fm.cls_dt.focus(); 		return;	}
												
		if(confirm('����Ÿ �����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cont_mon_rm_a.jsp';	
			fm.target='ii_no';
			fm.target='d_content';
			fm.submit();
		}		

	}
		
	function save(){
		var fm = document.form1;
		
		//alert�� 
		if ( toInt(replaceString("-","",fm.car_end_dt.value))  < toInt(replaceString("-","",fm.car_120_dt.value))  ) {
		   if ( '<%=cr_bean.getCar_end_yn()%>'  == 'Y'  ) { 
    		  alert('���ɸ������� 4�����̸��Դϴ�.  ������������ �Ű����� ó���ϼ���.'); 
    		}	  
    	 }
    	 
       if (  toInt(parseDigit(fm.tot_dist.value))  > 200000  ) { 
    		  alert('����Ÿ��� 20��km�̻��Դϴ�.  ������������ �Ű����� ó���ϼ���.'); 
    	}	  
    		
   
		if(fm.cls_st.value == '')				{ alert('���������� �����Ͻʽÿ�'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}
	
		if( toInt(parseDigit(fm.reg_cnt.value)) > 0 ) { 	 alert('�̹� ��ϵ� ���Դϴ�. Ȯ���Ͻʽÿ�!!'); 	fm.cls_st.focus(); 		return;	}	
	
		if ( fm.rent_start_dt.value != ''    ) {		
						
	//	if ( fm.cls_st.value == '14' ) {			
			//����ȸ�� ���� �� ȸ������, �԰����� �� check
			if(fm.reco_st[0].checked == true){  //ȸ�� ���ý� - ȸ������ �� ȸ����, �԰��� check
				  if(fm.reco_d1_st.value == "") {
				 		alert("ȸ�������� �����ϼž� �մϴ�.!!");
						return;
				  }	
				  
				 if(fm.reco_dt.value == '')				{ alert('ȸ�����ڸ� �Է��Ͻʽÿ�'); 		fm.reco_dt.focus(); 	return;	}
				 if(fm.ip_dt.value == '')				{ alert('�԰����ڸ� �Է��Ͻʽÿ�'); 		fm.ip_dt.focus(); 		return;	}
				
				 var s1_str = fm.reco_dt.value;
				 var s2_str = fm.ip_dt.value;
				 var e1_str = fm.cls_dt.value;
				 var  count1 = 0;	
				 var  count2 = 0;			
							   
				 var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(5,7) -1, s1_str.substring(8,10) );
				 var s2_date =  new Date (s2_str.substring(0,4), s2_str.substring(5,7) -1, s2_str.substring(8,10) );
				 var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
			
				 var diff1_date = e1_date.getTime() - s1_date.getTime();
				
				count1 = Math.floor(diff1_date/(24*60*60*1000));									
						
			  	if ( count1 >= 7 ) { // �뿩�Ḹ���ϰ� ������ �� (������ü�ϼ� ���)					  	   	
			  		alert("�������ڿ� ȸ�����ڰ� 1���� �̻� ���̳��ϴ�. ȸ�����ڸ� Ȯ���ϼ���.!!");			  	 
			  	}
			  	
				var diff2_date = e1_date.getTime() - s2_date.getTime();
				count2 = Math.floor(diff2_date/(24*60*60*1000));	
				
			 	if ( count2 >= 7 ) { // �뿩�Ḹ���ϰ� ������ �� (������ü�ϼ� ���)		
				 	alert("�������ڿ� �԰����ڰ� 1���� �̻� ���̳��ϴ�. �԰����ڸ� Ȯ���ϼ���.!!");
				}
								
				 if( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ){
					if(fm.est_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.est_dt.focus(); 		return;	}		
				 }
					
				 if( toInt(parseDigit(fm.tot_dist.value)) < 1 ) { 	 alert('����Ÿ��� �Է��Ͻʽÿ�'); 		fm.tot_dist.focus(); 		return;	}		
				 
				 if(fm.serv_gubun[0].checked == false && fm.serv_gubun[1].checked == false && fm.serv_gubun[2].checked == false ){
						alert("������ ���븦 �����ϼž� �մϴ�.!!");
						return;
				}		
				
		
			} else {
			  if(fm.reco_d2_st.value == "") {
			 		alert("��ȸ�������� �����ϼž� �մϴ�.!!");
					return;
			  }		
			}	
				
			if(fm.serv_st[0].checked == false && fm.serv_st[1].checked == false ){
				alert("������ ��밡���� �����ϼž� �մϴ�.!!");
				return;
			}	
			 
			//������ �����̸� ���ϼ� ����.
			if (fm.serv_st[1].checked == true && fm.park.value == "1"  ){
				alert("������ ������ ��������ġ�� �����������ϼ� �����ϴ�..!!");
				return;
			}	
			
				
		}
			
		//��������
		if( replaceString(' ', '',fm.cls_cau.value) == '' ){
				alert("���������� �Է��ϼž� �մϴ�.!!");
				return;
		}	
		
		if( get_length(Space_All(fm.cls_cau.value)) == 0 ) {
		 		alert("���������� �Է��ϼž� �մϴ�.!!");
				return;
		}	
	
		//��������
		if( replaceString(' ', '',fm.park.value) == '' ){
				alert("��������ġ��  �Է��ϼž� �մϴ�.!!");
				return;
		}				
			
		//��꼭�����Ƿ�
		if ( toInt(parseDigit(fm.dft_amt_1.value))  < 1 ) {
			if ( fm.tax_chk0.checked == true) {
				alert("�ߵ����� ������� Ȯ���ϼ���. ��꼭�����Ƿڸ� �� �� �����ϴ�..!!");
				return;
			 }	
		}
				
		if ( toInt(parseDigit(fm.etc_amt_1.value))  < 1 ) {
			if ( fm.tax_chk1.checked == true) {
				alert("����ȸ�����ֺ���� Ȯ���ϼ���. ��꼭�����Ƿڸ� �� �� �����ϴ�..!!");
				return;
			 }	
		}	
	
		if ( toInt(parseDigit(fm.etc2_amt_1.value))  < 1 ) {
			if ( fm.tax_chk2.checked == true) {
				alert("����ȸ���δ����� Ȯ���ϼ���. ��꼭�����Ƿڸ� �� �� �����ϴ�..!!");
				return;
			 }	
		}				
	 
		if ( toInt(parseDigit(fm.etc4_amt_1.value))  < 1 ) {
			if ( fm.tax_chk3.checked == true) {
				alert("��Ÿ���ع����� Ȯ���ϼ���. ��꼭�����Ƿڸ� �� �� �����ϴ�..!!");
				return;
			 }	
		}	
		
		/*
		if ( toInt(parseDigit(fm.over_amt_1.value))  < 1 ) {
			if ( fm.tax_chk4.checked == true) {
				alert("�ʰ�����δ���� Ȯ���ϼ���. ��꼭�����Ƿڸ� �� �� �����ϴ�..!!");
				return;
			 }	
		}	
		
		
		if ( toInt(parseDigit(fm.over_amt_1.value))  > 1 ) {
			if ( fm.tax_chk4.checked == true) {
			} else {
				alert("�ʰ�����δ���� Ȯ���ϼ���. ��꼭���� �ʼ��Դϴ�..!!");
				return;
			 }	
		}	*/
		
		
		// ���չ���	
		if ( fm.tax_reg_gu[1].checked == true ) {
		
			if ( toInt(parseDigit(fm.rifee_s_amt.value))  > 0 ) {
				alert("���ô뿩���ܾ��� �ֽ��ϴ�. �׸��ջ�û���Ƿڸ� �� �� �����ϴ�..!!");
				return;
		 	}
		 	
		 	if ( toInt(parseDigit(fm.rfee_s_amt.value))  > 0 ) {
				alert("�������ܾ��� �ֽ��ϴ�. �׸��ջ�û���Ƿڸ� �� �� �����ϴ�..!!");
				return;
		 	}		
		}
		
				
		// ȯ�ұݾ� �߻��� �����ȣ check
		if ( toInt(parseDigit(fm.fdft_amt2.value))  < 0 ) {
		  
		    if ( fm.re_acc_no.value  == 'null'  ) { 
				alert("ȯ�Ұ��¹�ȣ�� ��Ȯ�ϰ� �Է��ϼ���..!!");
				return;
		    }	
		    
		    if ( fm.re_acc_nm.value  == 'null') { 
				alert("ȯ�� �����ָ��� �Է��ϼ���..!!");
				return;
		    }					
		}		
		 			
			//ī�� cms ���ó������ - ȯ�Ұ��� �ּҽ�������� ����ο�û���� ó���ؾ� �� 
	   var len=fm.elements.length;
		var cnt=0;		
		var clen=0;
		var idnum="";
		var id="";
				
				
		//ȯ�Ұ��̰� ī�� cms ��� ������ ��� 		
		if (  toInt(parseDigit(fm.fdft_amt2.value))  < 0   ) {
		
		 	if ( <%=vt_c_size %> > 0  &&  fm.ip_chk.value == '' ) {	
		 				 	   		 	    
				for(var i=0 ; i<len ; i++){
					var ck=fm.elements[i];		
					if(ck.name == "t_card"){		
						if(ck.checked == true){
							cnt++;					
							idnum=ck.value;
						}
					}	
				}					
			
				if(cnt == 0){
				 	alert("���ó���� ī�带 �����ϼ���.");
					return;
				}	
			
				if(cnt >1){
				 	alert("1���̻� ������ �� �����ϴ�. !!!");
					return;
				}
				
				//�缳�� 
			   if (  toInt(parseDigit(fm.h5_amt.value)) > 0 &&   toInt(parseDigit(fm.h7_amt.value))  > 0    ) {
				    fm.jung_st.value = '3'; 
				}
							
		   }	//����� ī��ݾ� , ������� �ݾ� üũ 
		   
			if (  fm.ip_chk.value == '1' ) {		
				alert(" ȯ�Ұ��¸� ��������!!!!! ");		 			
			}
		} 						
			
			
		//�缳��  - 20171130
	   if (  toInt(parseDigit(fm.h5_amt.value)) > 0 &&   toInt(parseDigit(fm.h7_amt.value))  > 0    ) {
	         if  ( fm.jung_st.value != "3" ) {
	                fm.jung_st.value = "3"; 
	         }
				  
		}
									
					
		//cms�̸鼭 �̳��ݾ��� �ִ� ��� 	
		if ( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ) {		
		    if ( fm.re_acc_no.value   == 'null' ||  fm.re_acc_no.value   == ''  ) { 
		  } else {	   
		     if ( fm.cms_chk.checked == false ) {		   		  	
		   	  	   	alert("CMS������Ƿڷ� ����˴ϴ�. Ȯ���� �ٽ� �������ּ���.!!!.");
	        }  
	     }   
		}
										
										
		if(confirm('����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_rm_c_a.jsp';	
//			fm.target='ii_no';
			fm.target='d_content';
			fm.submit();
		}		

	}
	
	//���÷��� Ÿ��
	function cls_display(){
		var fm = document.form1;
	
	
		tr_ret.style.display		= '';	//����ȸ��		
		
		tr_refund.style.display		= 'none';	//ȯ������
		tr_scd_ext.style.display	= 'none';	//ȯ������
						
		//tot_dist �ʱ�ȭ 
		fm.tot_dist.value = "0";
															
		set_init();
		 
		set_day();
	
	}	

	//���÷��� Ÿ�� - ����ȸ������
	function cls_display2(){
		var fm = document.form1;
			
		if(fm.reco_st[1].checked == true){  //��ȸ�� ���ý�
			td_ret1.style.display 	= 'none';
			td_ret2.style.display 	= '';
		}else{
			td_ret1.style.display 	= '';
			td_ret2.style.display 	= 'none';
		}
	}	
	
	//���÷��� Ÿ��
	function cls_display3(){
		var fm = document.form1;
	
		if(fm.div_st.options[fm.div_st.selectedIndex].value == '2'){
			td_div.style.display 	= '';
		}else{
			td_div.style.display 	= 'none';
		}
	}	
	
	//���÷��� Ÿ��
	function cancel_display(){
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
		
			fm.cancel_yn.value = 'Y';
			alert('�ߵ���������ݾ��� '+fm.fdft_amt2.value+'������ ȯ���ؾ� �մϴ�. \n\n�̿� ���� ��쿡�� ������Ҹ� �����մϴ�.');
			return;			
		}
		
		if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'N'){
			td_cancel_n.style.display 		= 'none';  //��������
			td_cancel_y.style.display 		= '';  //�������
		} else {
			td_cancel_n.style.display 		= '';  //��������
			td_cancel_y.style.display 		= 'none';  //�������
		}	
	}	
	
	//����� �������ڷ� �ٽ� ���
	function set_day(){
		var fm = document.form1;	
		
		if(fm.cls_dt.value == ''){ 	alert('�������ڸ� �Է��Ͻʽÿ�'); 	fm.cls_dt.focus(); 	return;	}
	
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}	
					
		//tot_dist �ʱ�ȭ 
		fm.tot_dist.value = "0";
		
		fm.action='./lc_cls_rm_c_nodisplay.jsp';						
			
		fm.target='i_no';		
	//	fm.target='_blank';
		fm.submit();
	}	
		
	//�����ݾ� ���� : �ڵ����
	function set_cls_amt1(obj){
		var fm = document.form1;
			
		obj.value=parseDecimal(obj.value);
		
		if(obj == fm.r_day){ //�̿�Ⱓ �� 	
			set_init();
		}
		
		if(obj == fm.ifee_mon || obj == fm.ifee_day){ //���ô뿩�� ����Ⱓ
			if(fm.ifee_s_amt.value != '0'){		
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );		
		
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //����ݾ�
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //�ܾ�
							
			}
			
		}else if(obj == fm.ifee_ex_amt){ //���ô뿩�� ����ݾ�
			if(fm.ifee_s_amt.value != '0'){		
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );				
			}
		}else if(obj == fm.pded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //������ ��������
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
		
		if(fm.pp_s_amt.value != '0') {
	 	 
	    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //������
	    		
	    		fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;
	    	}   
	    }		
			
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // �����ݾ��� ����� ���
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
				
		fm.c_amt.value 					= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );					
		
		 //���ô뿩�ᰡ �� ����� ��� �ܿ����ô뿩��� �̳��뿩�ῡ�� ó��
	    if(fm.ifee_s_amt.value != '0') {
	    	 
	    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
	    		
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	      		fm.c_amt.value 	= parseDecimal( toInt(parseDigit(fm.grt_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
	    	}   
	    }			
	
		set_cls_s_amt();
	}	
	
	//�̳� �뿩�� ���� : �ڵ����
	function set_cls_amt2(obj){
		var fm = document.form1;
		
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // ���ô뿩�� �ܾ�
		var v_ifee_ex_amt = 0;  //���ô뿩�� ����ݾ�
		var  re_nfee_amt = 0;  //�������� �����쿡�� �ϼ� ����� �ݾ��� �ƴ� ��� check
									
		obj.value=parseDecimal(obj.value);
					
		//������ �� ���Աݰ��� vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		}
		 
		if ( fm.ex_di_amt_1.value == fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = fm.ex_di_v_amt.value ;
		}
		
					
		var no_v_amt = 0;
		var no_v_amt1 = 0;
	
		var c_fee_v_amt =  0;
		var c_fee_v_amt1 =  0;
		c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt.value)) * 0.1)) ;
		c_fee_v_amt1 = Math.round((toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)) ;
		
		// �ΰ��� ���߱� - 20190904 - �ܾ��� �ƴ� �̳��ݾ��� ���ٸ� (��ȸ���� ���)
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {
		 	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));	
		 	c_fee_v_amt1  = toInt(parseDigit(fm.nnfee_v_amt.value));		 		   
 	    }	
			 	   
		//���� �ΰ��� ����Ͽ� ���Ѵ�.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt  -  (toInt(parseDigit(fm.rfee_s_amt.value)) *0.1) -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 + ( toInt(parseDigit(fm.over_amt_1.value)) *0.1) - (toInt(parseDigit(fm.rfee_s_amt.value)) *0.1) -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		fm.rifee_v_amt.value = parseDecimal(  toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //���ô뿩�� 
	    fm.rfee_v_amt.value =  parseDecimal(  toInt(parseDigit(fm.rfee_s_amt.value)) *0.1 );    //������ 
	    
	    fm.dfee_v_amt.value =  parseDecimal(  toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt );  //���� �뿩�� �ΰ��� 	    
	    fm.dfee_v_amt_1.value = parseDecimal(  toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1 ); //Ȯ�� �뿩�� �ΰ��� 
		    
	    fm.over_v_amt.value =  '0';  //���� �ʰ����� �ΰ���  (0���� ó�� )
	    fm.over_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) *0.1 );  //Ȯ�� �ʰ����� �ΰ��� 
							
		fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		

		
		/*  2022-04 ������ 
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}		
			
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
			
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}	
									
		if ( fm.tax_chk3.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 
		}	*/
		
		/*
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 
		}	*/
		
		
	//	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
	
		set_cls_s_amt();
	}	
	
			
	//�̳� �ߵ���������� ���� : �ڵ����
	function set_cls_amt3(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		
	    if ( toInt(parseDigit(fm.add_amt_d.value))  < 1 )	{
			if(obj == fm.rcon_mon || obj == fm.rcon_day){ //�ܿ��뿩���Ⱓ
				if(fm.mfee_amt.value != '0'){		
					fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
					fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int_1.value)/100) );
				//	fm.tax_supply[0].value 	= fm.dft_amt_1.value;
				//	fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
				}
			}else if(obj == fm.dft_int_1){ //����� �������
				if(fm.trfee_amt.value != '0'){		
					fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int_1.value)/100) );
				//	fm.tax_supply[0].value 	= fm.dft_amt_1.value;
				//	fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
				}			
			}
	    }
	    
	//	fm.d_amt.value 						= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	//	fm.d_amt_1.value 					= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));	
		
		set_cls_s_amt();
	}		
	

						
	//Ȯ���ݾ� ����
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
		
		/* 2022-04  ������ 
		if(obj == fm.dft_amt_1){ //�ߵ�����
			fm.tax_supply[0].value 	= obj.value;
			if (fm.tax_chk0.checked == true) {
	 				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );		 		
			} else {
					fm.tax_value[0].value 	= '0';				
			}				
		
		}else if(obj == fm.etc_amt_1){ //ȸ�����ֺ��
			fm.tax_supply[1].value 	= obj.value;
			if (fm.tax_chk1.checked == true) {
				 fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 fm.tax_value[1].value 	= '0';
			}		
		
		}else if(obj == fm.etc2_amt_1){ //ȸ���δ���
			fm.tax_supply[2].value 	= obj.value;
			if (fm.tax_chk2.checked == true) {
					fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 	fm.tax_value[2].value 	= '0';
			}		
		
		}else if(obj == fm.etc4_amt_1){ //��Ÿ���ع���
			fm.tax_supply[3].value 	= obj.value;			
			if (fm.tax_chk3.checked == true) {
				 	fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			} else {
				 	fm.tax_value[3].value 	= '0';
			}
			
		}else 
		*/	
		if(obj == fm.m_over_amt){ //�ʰ�����δ�� ����		 
    		fm.j_over_amt.value =  toInt(parseDigit(fm.r_over_amt.value)) - toInt(parseDigit(obj.value)) ;  
			
			if (  toInt(parseDigit(fm.j_over_amt.value)) > 0) {
    		
				fm.over_amt.value =  '0';  
				fm.over_amt_1.value =  fm.j_over_amt.value ;  
			
				fm.tax_supply[4].value 	=  fm.j_over_amt.value;
					
				fm.tax_chk4.value  = 'Y' ;
				fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );
				fm.over_v_amt.value 	= '0';	 
				fm.over_v_amt_1.value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );	 
		  } else {
		  		fm.over_amt.value =  '0';  
				fm.over_amt_1.value =  '0' ;  
				fm.tax_supply[4].value 	=  '0';
			    fm.tax_chk4.value  = 'N' ;
				fm.tax_value[4].value 	= '0';
				fm.over_v_amt.value 	= '0';		 
				fm.over_v_amt_1.value 	= '0';	
		  }	
				
		}	
								
		var no_v_amt = 0;
			//���� �ΰ��� ����Ͽ� ���Ѵ�.	 
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)    -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		fm.rifee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //���ô뿩�� 
		fm.rfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) *0.1 );    //������ 
		    
		fm.dfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + (toInt(parseDigit(fm.nfee_amt.value)) * 0.1) );  //���� �뿩�� �ΰ��� 
		fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + (toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) );  //Ȯ�� �뿩�� �ΰ��� 
		    
		fm.over_v_amt.value =  '0';  //���� �ʰ����� �ΰ��� 
		fm.over_v_amt_1.value =  parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );  //Ȯ�� �ʰ����� �ΰ��� 
									
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt) );		
		
		/* 2022-04 ������ 
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 	= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));					
		}		
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}									
		if ( fm.tax_chk3.checked == true) {
			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));			  
		}*/
		
		/*	
		if ( fm.tax_chk4.checked == true) {
			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));			  
		}		
		*/
		
		set_cls_s_amt();		
	
	}	
		
	//Ȯ���ݾ� ����
	function set_cls_s_amt(){
		var fm = document.form1;	
					
	//	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	//  	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		
	  	fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
		
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.dfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))   + toInt(parseDigit(fm.over_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)));	 //Ȯ���ݾ�	
				
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );
			
			//������ �ݾ��� �ִٸ�
		if ( toInt(parseDigit(fm.fdft_amt2.value)) < 0 ) {
			 tr_refund.style.display		= '';	//ȯ������
			 tr_scd_ext.style.display		= '';	//�������������
			 if ( <%=vt_c_size%> > 0) {
				 	 tr_card.style.display		= '';	//ī������ 
				 	 set_card_amt();
				 //	 fm.h5_amt.value 			= parseDecimal( toInt(parseDigit(fm.t_amount.value )) );  //ī�� �����ݾ�  
				  	 fm.h7_amt.value 			= parseDecimal( toInt(parseDigit(fm.h5_amt.value)) + toInt(parseDigit(fm.fdft_amt2.value)) );  //ī�� �����ݾ� 
				  	 fm.jung_st.value = '3';
			 } 	 
			  	 
		} else {
			 tr_refund.style.display		= 'none';	//ȯ������
			 tr_scd_ext.style.display		= 'none';	//�������������
		  	 tr_card.style.display		= 'none';	// ī������
		  	 fm.h5_amt.value =0;
		  	 fm.h7_amt.value =0;
		  	 fm.jung_st.value = '1';		  
		}	
		
	}	
		

	//����ȸ�����
	function set_etc_amt(){
		var fm = document.form1;
		
		fm.etc_out_amt.value 		= parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)) + toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		fm.etc_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
	
		fm.etc_amt_1.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));			
		
		/* 2022-04 ������ 
				//�������ֺ��
		if(toInt(parseDigit(fm.etc_amt.value)) > 0){		
				fm.tax_g[1].value       = "ȸ�� �������ֺ��";
		   		fm.tax_supply[1].value 	= fm.etc_amt.value;
		   		
		   		if (fm.tax_chk1.checked == true) {
		   				fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt.value)) * 0.1 );
		   		} else {
		   				fm.tax_value[1].value 	= '0';
		   		}			
		}
					//�����δ���
		if(toInt(parseDigit(fm.etc2_amt.value)) > 0){
				fm.tax_g[2].value       = "ȸ�� �δ���";
		   		fm.tax_supply[2].value 	= fm.etc2_amt.value;
		   		
		   		if (fm.tax_chk2.checked == true) {
					fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt.value)) * 0.1 );
				} else {
				 	fm.tax_value[2].value 	= '0';
				}	
		}
		*/
			
		set_cls_s_amt();		
							
	}	
	
	
	//���ݰ�꼭 check ���� �ΰ��� - �����Ծ׿� �ΰ��� ��ŭ ���Ѵ�(�뿩��, ��å���� ���� (�̹� ��������)) - ���ݰ�꼭 ����Ǹ� �ܻ����ݰ��� 
	function set_vat_amt(obj){
		var fm = document.form1;
			
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
		
		/* 2022-04 ������ 
		if(obj == fm.tax_chk0){ // �����
		 
		 	if (obj.checked == true) {
		 			fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
		 			fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		 			fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[0].value)));		
			} else {
					fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
					fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[0].value)));		
			}	
	
		} else if(obj == fm.tax_chk1){ // ���ֺ��
			 if (obj.checked == true) {
			 		fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt_1.value)) * 0.1 );
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[1].value)));
			 } else {
			 		fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt_1.value)) * 0.1 );
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[1].value)));
			 }	
			 
		} else if(obj == fm.tax_chk2){ // �δ���
			 if (obj.checked == true) {
			 		fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value)) * 0.1 );
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[2].value)));
			 } else {
			 		fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value)) * 0.1 );
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[2].value)));
			 }	
			 
		} else if(obj == fm.tax_chk3){ // ��Ÿ���ع���
			 if (obj.checked == true) {
			 		fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value)) * 0.1 );			 	
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[3].value)));
			 } else {
			 		fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value)) * 0.1 );		
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[3].value)));
			 }	*/
			 
	/*		 
		} else if(obj == fm.tax_chk4){ // �ʰ����� �δ�� 
			 if (obj.checked == true) {
			 		fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );			 	
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[4].value)));
			 } else {
			 		fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );		
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[4].value)));
			 }		 
			
			 
		}  */
			
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );		
				
	}
	
			
	// cms ������ ���� - ȯ�ұݾ��� �ִ� ��� 
	function set_cms_value(obj){
		var fm = document.form1;

		if(obj == fm.re_cms_chk){ // �����
		 	if (obj.checked == true) {
		 	
		 	   <% if ( h_cms.get("CBNO")  == null  ) 	{ %>
		 		   	fm.re_bank.value 		=  "";	
					fm.re_acc_no.value 		=  "";
					fm.re_acc_nm.value 		=  "";		
		 	   <% } else { %>
		 	     	fm.re_bank.value 		= '<%=re_bank%>';	
		 			fm.re_acc_no.value 		= '<%=re_acc_no%>';	
				 	fm.re_acc_nm.value 		= '<%=re_acc_nm%>';	
				 <% } 	%>					 	
			} else {
					fm.re_bank.value 		=  "";	
					fm.re_acc_no.value 		=  "";
					fm.re_acc_nm.value 		=  "";		
		   }	
		}						
	}

    //Ư�̻���  ����
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}	
	
	
		//�ʰ���������Ÿ�
	function set_over_amt(){
		var fm = document.form1;
		
		var cal_rent_days = 0;
		var cal_dist  = 0;
		
		//�ʱ�ȭ 
		fm.m_reason.value 	=     "";	
		fm.m_over_amt.value 	=     "0";	
		fm.r_over_amt.value 	=     "0";	
		fm.j_over_amt.value 	=     "0";	
		fm.m_saction_id.value= "";
		fm.over_amt.value 	=     "0";	
		fm.over_amt_1.value 	=     "0";	
		fm.over_v_amt.value 	=     "0";	
		fm.over_v_amt_1.value 	=     "0";	
		
		if ( fm.rent_start_dt.value =="" ) {
		} else {
			if (  <%=base.getRent_dt()%>  > 20130604      ) {
				  if (  toInt(parseDigit(fm.sh_km.value)) > 0 ) {  //����Ÿ��� �Է��� �� ���??? 	
						  
				    // ����Ʈ�� 1���� 30�Ϸ� - 20191017	               
						cal_rent_days = toInt(fm.r_mon.value) * 30  + toInt(fm.r_day.value);				  			 
						fm.rent_days.value 		=     parseDecimal( cal_rent_days );	
					
				//     	cal_dist =   	toInt(fm.agree_dist.value) * toInt(fm.rent_days.value) / 30;
				     	cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 30;
				     		
				     	fm.cal_dist.value 		=     parseDecimal( cal_dist   );	
				
				//	fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
						
						fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
						fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );		  
						fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     );
								
						fm.add_dist.value 		=     parseDecimal( 0 );  //��񽺸��ϸ���
						
						fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
						      
								         
					   if ( 	toInt(parseDigit(fm.jung_dist.value))   > 0 ) {
								fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );								
								fm.j_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );								
								fm.tax_supply[4].value 	=  fm.j_over_amt.value;																
								fm.tax_chk4.value  = 'Y' ;
								fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );		
							
								    
					 	} else {
					 		fm.r_over_amt.value 	=      "0";						
							fm.j_over_amt.value 	=     "0";	
							fm.tax_supply[4].value 	=  '0';					 
							fm.tax_value[4].value 	= '0';		
							fm.tax_chk4.value  = 'N' ;	
						
					 	}					 			 	
				         		
				  }
			}
		}	
		
		fm.over_amt.value 		    = '0';
		fm.over_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)));	
		
		var no_v_amt = 0;
		var no_v_amt1 = 0;
		
		//���� �ΰ��� ����Ͽ� ���Ѵ�.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)    -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		fm.rifee_v_amt.value = parseDecimal(  toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //���ô뿩�� 
		fm.rfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) *0.1 );    //������ 
		    
		fm.dfee_v_amt.value   =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + (toInt(parseDigit(fm.nfee_amt.value)) * 0.1) );  //���� �뿩�� �ΰ��� 
		fm.dfee_v_amt_1.value =	 parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) +( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) );  //Ȯ�� �뿩�� �ΰ��� 
		    
		fm.over_v_amt.value =  '0';  //���� �ʰ����� �ΰ��� 
		fm.over_v_amt_1.value = parseDecimal(  toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );  //Ȯ�� �ʰ����� �ΰ��� 	
		
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
		
		/* 2022-04-20 ������
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}		
			
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
			
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}	
									
		if ( fm.tax_chk3.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));					 
		}	*/
		/*	
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}				
			*/
			
		set_cls_s_amt();
				
	}	
		
	function set_card_amt(){
		var fm = document.form1;
	
		var scd_size 	= toInt(fm.scd_size.value);		
		var t_p_amt = 0;
	   var r_date = "";
	   
	   var len=fm.elements.length;
		var cnt=0;		
		var clen=0;
		var idnum="";
		var id="";
					
		if ( <%=vt_c_size %> > 0  &&  fm.ip_chk.value == '' ) {	
		 					
			for(var i=0 ; i<len ; i++){
				var ck=fm.elements[i];		
				if(ck.name == "t_card"){		
					if(ck.checked == true){
						cnt++;					
						idnum=ck.value;
					}
				}	
			}			   
	  	  	
			if(cnt == 0){
			 	alert("���ó���� ī�带 �����ϼ���.");
				return;
			}	
		
			if(cnt >1){
			 	alert("1���̻� ������ �� �����ϴ�. !!!");
				return;
			}	
			   	   
		  	if ( scd_size < 2  ) {
				    if ( scd_size == 0 ) {			    
				    } else { 
					       if ( fm.t_card.checked == true) {
					    		t_p_amt =   t_p_amt + toInt(parseDigit(fm.t_c_amt.value));				
					    		r_date 	= 	 fm.t_card.value 	;   	
						  	 }  	 
					}    
			} else {
					for(var i = 0 ; i < scd_size ; i ++){			    
					     if ( fm.t_card[i].checked == true) {
								t_p_amt =   t_p_amt + toInt(parseDigit(fm.t_c_amt[i].value));		
					  			r_date 	= 	 fm.t_card[i].value 	 ; 
						 }
					}
			}	
							
			fm.r_date.value =  r_date;							
			fm.h5_amt.value  = parseDecimal ( t_p_amt )  ;
			fm.h7_amt.value  = parseDecimal ( t_p_amt +  toInt(parseDigit(fm.fdft_amt2.value)))  ;
		}	
				
	}	
	
	function view_car_service(car_id){
	  var fm = document.form1;
		window.open("/acar/secondhand_hp/service_history.jsp?c_id="+fm.car_mng_id.value+"&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, resizable=yes, scrollbars=yes, status=yes");		
	}
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>

<input type='hidden' name='car_gu' 	value='<%=base.getCar_gu()%>'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 	value='<%=user_id%>'>
<input type='hidden' name='br_id' 	value='<%=br_id%>'>
<input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
<input type='hidden' name='andor'	 	value='<%=andor%>'>
<input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
<input type='hidden' name="fee_size"			value="<%=fee_size%>">    
<input type='hidden' name='rent_start_dt' value='<%=base1.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base1.get("RENT_END_DT")%>'>  
<input type='hidden' name='car_mng_id' value='<%=base1.get("CAR_MNG_ID")%>'>
<input type='hidden' name='con_mon' value='<%=base1.get("CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FEE_S_AMT")))%>'> <!-- ���뿩��-->
<input type='hidden' name='pp_s_amt' value='<%=base1.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base1.get("IFEE_S_AMT")%>'>
<input type='hidden' name='fee_s_amt' value='<%=base1.get("FEE_S_AMT")%>'>
  
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 

<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'>   <!-- ��ü�� ���� ������¥ -->
 
<input type='hidden' name='cls_s_amt'  value=''>
<input type='hidden' name='cls_v_amt'  value='' >
<input type='hidden' name='car_ja_no_amt' value='<%=car_ja_no_amt%>' >

<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>'> <!--�������� ��ü���뿩�� -->
<input type='hidden' name='nnfee_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_V_AMT")))%>'>
<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_AMT")))%>'> <!--�������� ��ü���뿩�� -�ܾ� -->
<input type='hidden' name='s_mon' value='<%=base1.get("S_MON")%>'>
<input type='hidden' name='s_day' value='<%=base1.get("S_DAY")%>'> 

<input type='hidden' name='hs_mon' value='<%=base1.get("HS_MON")%>'>  <!-- �ܾ������� �̳����� -->
<input type='hidden' name='hs_day' value='<%=base1.get("HS_DAY")%>'> <!-- �ܾ������� �̳����� -->

<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_S_AMT")))%>'> <!--�������� �����뿩�� -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_V_AMT")))%>'>  
<input type='hidden' name='di_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'>  

<input type='hidden' name='reg_cnt' value='<%=reg_cnt%>'> <!-- ���Ͽ��� -->
<input type='hidden' name='cms_yn' value='<%=re_bank%>'>  
 
<input type='hidden' name='lfee_mon' value='<%=base1.get("LFEE_MON")%>'> <!--�뿩������ -->

 <input type='hidden' name='add_amt_d' value='<%=add_amt_d%>' >  <!--���̿�Ⱓ�� ���� ����ݾ� (1���� �̸� ����� ���) -->
 <input type='hidden' name='day_cnt' value='<%=day_cnt%>' >  <!--���̿�Ⱓ�� ����  �̿��ϼ� ����ǥ �� ���ϱ� -->
 
  
  <!--�ʰ����� �Ÿ� ��� -->
 <input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
 <input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
 <input type='hidden' name='over_run_day' value='<%=car1.getOver_run_day()%>'>
  
<input type='hidden' name='sh_km' value='<%=car1.getSh_km()%>'>

<input type='hidden' name='rc_s_amt' value='<%=base1.get("RC_S_AMT")%>'> <!--���� �ݾ� --> 
<input type='hidden' name='rc_v_amt' value='<%=base1.get("RC_V_AMT")%>'> <!-- ���� �ݾ� --> 
<input type='hidden' name='rr_s_amt' value='<%=base1.get("RR_S_AMT")%>'> <!-- ���� �ݾ� --> 
<input type='hidden' name='rr_v_amt' value='<%=base1.get("RR_V_AMT")%>'> <!-- ���� �ݾ� -->
<input type='hidden' name='rr_amt' value='<%=base1.get("RR_AMT")%>'> <!-- ���� �ݾ� --> 

<input type='hidden' name='cons_s_amt' value='<%=f_fee_rm.getCons1_s_amt() + f_fee_rm.getCons2_s_amt()%>'> <!-- �������  -->
<input type='hidden' name='cons_v_amt' value='<%=f_fee_rm.getCons1_v_amt() + f_fee_rm.getCons2_v_amt()%>'> <!-- �������  -->

<input type='hidden' name='car_end_dt' value='<%=cr_bean.getCar_end_dt()%>'>
<input type='hidden' name='car_120_dt' value='<%=a120_days%>'>

<input type='hidden' name='scd_size' value='<%=vt_c_size%>'>
<input type='hidden' name='ip_chk' value='<%=ip_chk%>'>
 
<input type='hidden' name='rifee_v_amt' value=''> <!-- �ΰ��� ����  -->
<input type='hidden' name='rfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt_1' value=''>
<input type='hidden' name='over_v_amt' value=''>
<input type='hidden' name='over_v_amt_1' value=''>
 
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
 	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=12%>����ȣ</td>
            <td width=24%>&nbsp;<%=rent_l_cd%>&nbsp;&nbsp;<a href="javascript:view_cng_etc('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='Ư�̻���'><img src=/acar/images/center/button_tish.gif align=absmiddle border=0></a>
            &nbsp;<a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='��ĵ����'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
            </td>
            <td class=title width=10%>��������</td>
            <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
            <td class=title width=10%>��������</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
          </tr>
          <tr> 
            <td class=title>���ʿ�����</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
            <td class=title>�����븮��</td>
            <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
            <td class=title>���������</td>
            <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
          </tr>
          <tr>
            <td class=title>�������</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
            <td class=title>��౸��</td>
            <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>�ű�<%}else if(rent_st.equals("3")){%>����<%}else if(rent_st.equals("4")){%>����<%}%></td>
            <td class=title>��������</td>
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("4")){%>����Ʈ<%} %></td>
          </tr>
        
          <tr>
            <td class=title>��ȣ</td>
            <td>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=client.getFirm_nm()%></a></td>
            <td class=title>��ǥ��</td>
            <td>&nbsp;<%=client.getClient_nm()%></td>
            <td class=title>����/����</td>
            <td>&nbsp;<a href="javascript:view_site('<%=client.getClient_id()%>','<%=base.getR_site()%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=site.getR_site()%></a></td>
          </tr>
          <tr>
            <td class=title>������ȣ</td>
            <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a>
             &nbsp;<font color="red">(����: <%=base1.get("CAR_MON")%>����, ���ɸ�����:<%=cr_bean.getCar_end_dt()%> ) 
             <% if ( cr_bean.getCar_end_yn().equals("Y") )  {%>��������<%} %>
              </font>            
            
            </td>
            <td class=title width=10%>����</td>
            <td colspan="3" >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
			<font color="#999999">(�����ڵ�:<%=cm_bean.getJg_code()%>)</font>
			</td>
          </tr>		  
        </table>
	  </td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
          <tr>
            <td style="font-size : 9pt;" width="3%" class=title rowspan="2">����</td>
            <td style="font-size : 9pt;" width="10%" class=title rowspan="2">�������</td>
            <td style="font-size : 9pt;" width="6%" class=title rowspan="2">�̿�Ⱓ</td>
            <td style="font-size : 9pt;" width="8%" class=title rowspan="2">�뿩������</td>
            <td style="font-size : 9pt;" width="8%" class=title rowspan="2">�뿩������</td>
            <td style="font-size : 9pt;" width="7%" class=title rowspan="2">�����</td>
            <td style="font-size : 9pt;" width="9%" class=title rowspan="2">���뿩��</td>
            <td style="font-size : 9pt;" class=title colspan="2">������</td>
            <td style="font-size : 9pt;" width="10%" class=title rowspan="2">������</td>
            <td style="font-size : 9pt;" class=title colspan="2">���ô뿩��</td>
            <td style="font-size : 9pt;" class=title colspan="2">���Կɼ�</td>
          </tr>
          <tr>
            <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 9pt;" width="3%" class=title>�°�</td>
            <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 9pt;" width="3%" class=title>�°�</td>
            <td style="font-size : 9pt;" width="10%" class=title>�ݾ�</td>
            <td style="font-size : 9pt;" width="3%" class=title>%</td>			
          </tr>
		  <%for(int i=0; i<fee_size; i++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(i+1));
				if(!fees.getCon_mon().equals("")){
				
				s_opt_per = fees.getOpt_per();
				s_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
				s_opt_s_amt = fees.getOpt_s_amt();
			%>	
          <tr>
            <td style="font-size : 9pt;" align="center"><%=i+1%></td>
            <td style="font-size : 9pt;" align="center"><a href="javascript:view_fee('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=fees.getRent_st()%>')"><%=AddUtil.ChangeDate2(fees.getRent_dt())%></a></td>
            <td style="font-size : 9pt;" align="center"><%=fees.getCon_mon()%>����</td>
            <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
            <td style="font-size : 9pt;" align="center"><%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
            <td style="font-size : 9pt;" align="center"><%if(i==0){%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}else{%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}%></td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>�°�<%}else if(fees.getGrt_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>			
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>�°�<%}else if(fees.getIfee_suc_yn().equals("1")){%>����<%}else{%>-<%}%></td>
            <td style="font-size : 9pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>��&nbsp;</td>
            <td style="font-size : 9pt;" align="center"><%=fees.getOpt_per()%></td>
          </tr>
		  <%}}%>
        </table>
	  </td>
	</tr>
	<tr>
        <td></td>
    </tr>
    <tr>
        <td colspan="2" style='background-color:bebebe; height:1;'></td>
    </tr>
    <tr>
        <td></td>
    </tr>		
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='13%' class='title'>��������</td>
            <td width="13%">&nbsp; 
			  <select name="cls_st" onChange='javascript:cls_display()'>
			    <option value="">---����---</option>
                		    <option value="14">����Ʈ����</option>                            
              </select> </td>
            
            <td width='13%' class='title'>�Ƿ���</td>
            <td width="13%">&nbsp;
              <select name='reg_id'>
                <option value="">����</option>
                <%	if(user_size > 0){
						for(int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%		}
					}%>
              </select></td>	
                      
            <td width='13%' class='title'>��������</td>
            <td width="13%">&nbsp;
			  <input type='text' name='cls_dt' value='<%=AddUtil.getDate()%>' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'></td> 
		    <td width='13%' class='title'>�̿�Ⱓ</td>
		    <td >&nbsp;
		       <input type='text' name='r_mon' class='text' size='2' readonly  value='<%=base1.get("R_MON")%>' >����&nbsp;
		      <input type='text' name='r_day' size='2' class='text' value='<%= base1.get("R_DAY")%>' onBlur='javascript:set_cls_amt1(this);'>��&nbsp;</td>
         
            </td>
          </tr>
          <tr> 
            <td class='title'>���� </td>
            <td colspan="7">&nbsp;
			  <textarea name="cls_cau" cols="140" class="text" style="IME-MODE: active" rows="3"></textarea> 
            </td>
          </tr>
          <tr>                                                      
            <td class=title >�ܿ�������<br>������ҿ���</td>
     	    <td>&nbsp; 
			  <select name="cancel_yn" onChange='javascript:cancel_display()'>
                <option value="N">��������</option>
                <option value="Y" selected>�������</option>
              </select>
		    </td>
		    <td  class=title width=10%>�����������</td>
            <td  width=12%>&nbsp;
				  <select name='sb_saction_id'>
	                <option value="">--����--</option>
	                <option value="000052">�ڿ���</option>
	                <option value="000053">������</option>	       
	                <option value="000054">����Ź</option>
	                <option value="000118">�̼���</option>
	              </select>
			</td>			        
          <td  colspan="4" align=left>&nbsp;�� ����� ��꼭�� ���� �Ǵ� ��ҿ��� �� Ȯ���� �ʿ�, ������ҽ� ���̳ʽ� ���ݰ�꼭 ���� </td>
          </tr>
          <tr>      
		            <td width='13%' class='title'>����Ÿ�</td>
		            <td width='18%' >&nbsp;
					  <input type='text' name='tot_dist' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_over_amt();'>&nbsp;km 
					     &nbsp;<a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="���񳻿�����"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a>		  
    	    		   </td>
		            <td  colspan=6  align=left>&nbsp;�� �ߵ����� �� ����� ��������Ÿ� </td>
		     </tr>                
        </table>
      </td>
    </tr>
  
    <tr>
      <td>&nbsp;</td>
    </tr>
    
    
  	<tr id=tr_ret style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����ȸ��</span></td>
			</tr>
			<tr>
		        <td class=line2></td>
		    </tr>
		    
			<tr> 
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 
			            <td width='13%' class='title'>ȸ������</td>
			            <td width="20%">&nbsp;<input type="radio" name="reco_st" value="Y" checked onClick='javascript:cls_display2()'>ȸ��
	                            <input type="radio" name="reco_st" value="N"  onClick='javascript:cls_display2()'>��ȸ��</td>
	                    <td width='13%' class='title'>����</td>
	                    
	                    <td id=td_ret1 style="display:''">&nbsp; 
						  <select name="reco_d1_st" >
						    <option value="">---����---</option>
			                <option value="1">����ȸ��</option>
			                <option value="2">����ȸ��</option>
			                <option value="3">����ȸ��</option>
			               </select>       
			            </td>
			            
			            <td id=td_ret2 style='display:none'>&nbsp; 
						  <select name="reco_d2_st" >
						    <option value="">---����---</option>
						    <option value="1">����</option>
						    <option value="2">Ⱦ��</option>
						    <option value="3">���</option>
						   </select>       
			            </td>
			            
			            <td class='title' width='13%' >����</td>
						<td>&nbsp;
						<input type="text" name="reco_cau" size=30 maxlength=100 >
						</td>				        		         
		         </tr>
		                   
		         <tr>      
		            <td width='10%' class='title'>ȸ������</td>
		            <td>&nbsp;
					  <input type='text' name='reco_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		            <td width='10%' class='title'>ȸ�������</td>
		            <td>&nbsp;
					  <select name='reco_id'>
		                <option value="">����</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
		  
		                <%		}
							}%>
		              </select>
		            </td>
		            <td width='10%' class='title'>�԰�����</td>
		            <td>&nbsp;
					  <input type='text' name='ip_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
		            </td>
		          </tr>
		     	          
		          
		          <tr>		          
		        		   <td class=title>��������ġ</td>
	                    <td colspan=5> 
	                      &nbsp;<SELECT NAME="park" >
	                        <%if(good_size > 0){ 			
	                   			   for(int i = 0 ; i < good_size ; i++){
                  								CodeBean good = goods[i];%>
                        <option value='<%= good.getNm_cd()%>' ><%= good.getNm()%></option>		                 
                   		   <%	}                      
								  } %>           		
	        		        </SELECT>
						<input type="text" name="park_cont" value="" size="40" class=text style='IME-MODE: active'>
						   (��Ÿ���ý� ����)
	                    </td>
	                </tr>  
	                
	                
		     			 <tr>	         
		                  <td class=title>������ ��밡��</td>
	                      <td> &nbsp;<input type="radio" name="serv_st" value="Y" >��ð���
	                            <input type="radio" name="serv_st" value="N"  >������ ����</td>	            
	                      <td class=title>������ ����</td>
	                      <td colspan=3> &nbsp;<input type="radio" name="serv_gubun" value="1" >�縮��/����Ʈ
	                            &nbsp;<input type="radio" name="serv_gubun" value="3"  >����Ʈ
	                            &nbsp;<input type="radio" name="serv_gubun" value="2"  >�Ű� </td>	              
	                                 
		 	  			</tr>
		 	  	                 
		    			<tr>      
			            <td width='10%' class='title'>���ֺ��</td>
			            <td>&nbsp;
						   <input type='text' name='etc_d1_amt' size='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> ��</td>
			            </td>
			            <td width='10%' class='title'>�δ���</td>
			            <td>&nbsp;
						   <input type='text' name='etc2_d1_amt' size='12' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> ��</td>
			            </td>
			            <td width='10%' class='title'>����</td>
			            <td>&nbsp;
						 <input type='text' name='etc_out_amt' size='12' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
			            </td>
		          </tr>
		     
		        </table>
		      </td>
		    </tr>
		    <tr>
		      <td>&nbsp;</td>
		    </tr>	
		</table>
      </td>	 
    </tr>	     
		    
    <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ݾ� ����</span>[���ް�]</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr> 
		            <td  colspan="2" class='line'> 
		              <table border="0" cellspacing="1" cellpadding="0" width="100%">
		                <tr> 
		                  <td class='title' align='right' colspan="3">�׸�</td>
		                  <td class='title' width='38%' align="center">����</td>
		                  <td class='title' width="40%">���</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="7" width=4%>ȯ<br>
		                    ��<br>
		                    ��<br>
		                    ��</td>
		                  <td class='title' colspan="2">������(A)</td>
		                  <td class='title' > 
		                    <input type='text' name='grt_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    ��</td>
		                  <td class='title'>&nbsp;</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3" width=4%>��<br>
		                    ��<br>
		                    ��<br>
		                    ��<br>
		                    ��</td>
		                  <td width="14%" align="center" >����Ⱓ</td>
		                  <td align="center"> 
		                    <input type='text' size='3' name='ifee_mon' readonly  value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
		                    ����&nbsp;&nbsp;&nbsp; 
		                    <input type='text' size='3' name='ifee_day' readonly  value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
		                    ��</td>
		                  <td>&nbsp;</td>
		                </tr>
		                <tr>
		                  <td align="center" >����ݾ�</td>
		                  <td align="center"> 
		                    <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    ��</td>
		                  <td>=���ô뿩�᡿����Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>�ܿ� ���ô뿩��(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    ��</td>
		                  <td class='title'>=���ô뿩��-����ݾ�</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">��<br>
		                    ��<br>
		                    ��</td>
		                  <td align='center'>�������� </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    ��</td>
		                  <td>=�����ݡ����Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td align='center'>������ �����Ѿ� </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    ��</td>
		                  <td>=�������ס����̿�Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>�ܿ� ������(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
		                    ��</td>
		                  <td class='title'>=������-������ �����Ѿ�</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">��</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='c_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
		                    ��</td>
		                  <td class='title'>=(A+B+C)</td>
		                </tr>
		              </table>
		            </td>
			     </tr>
    
            </table>
        </td>
    </tr>
   	<tr></tr><tr></tr><tr></tr>
  
    <input type='hidden' name='ex_ip_amt'  value='0'> 
    <input type='hidden' name='ex_ip_dt' > 
    <input type='hidden' name='bank_code' > 
    <input type='hidden' name='deposit_no' > 
         
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̳��ݾ� ����</span>[���ް�]</td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    
    <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr> 
              <td class="title" colspan="4" rowspan=2>�׸�</td>
              <td class="title" width='38%' colspan=2> ä��</td>                
              <td class="title" width='40%' rowspan=2>���</td>
            </tr>
            <tr>                 
              <td class="title"'> ���ʱݾ�</td>
              <td class="title"'> Ȯ���ݾ�</td>
            </tr>
            <tr> 
              <td class="title" rowspan="19" width="4%">��<br>
                ��<br>
                ��<br>
                ��<br>
                ��</td>
              <td class="title" colspan="3">���·�/��Ģ��(D)</td>
              <td align="center" class="title"> 
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>' size='15' class='num' >
               ��</td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>'  size='15' class='num'  > 
               ��</td>
              <td class="title"><font color="#66CCFF"><%=base1.get("FINE_CNT")%>��</font></td>
             </tr>
             <tr> 
              <td class="title" colspan="3">�ڱ��������ظ�å��(E)</td>
              <td width='19%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>' size='15' class='num' >
                ��</td>
              <td width='19%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>'  size='15' class='num'  > 
                ��</td>                   
              <td width='40%' class="title"><font color="#66CCFF"><%=base1.get("SERV_CNT")%>��</font></td>
            </tr>
            <tr>
              <td class="title" rowspan="4" width="4%"><br>
                ��<br>
                ��<br>
                ��</td>
              <td align="center" colspan="2" class="title">������</td>   
               <td class='' align="center"> 
                <input type='hidden' name='ex_di_v_amt' readonly value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'  >
                <input type='text' name='ex_di_amt' readonly value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' >
                ��</td>
              <td class='' align="center"> 
                <input type='hidden' name='ex_di_v_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>' >
                <input type='text' name='ex_di_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> ��</td>              
            
              <td>&nbsp; </td>
            </tr>
          
            <tr> 
              <td rowspan="2" align="center" class="title" width="4%">��<br>
                ��</td>
              <td width='10%' align="center" class="title">�Ⱓ</td>
              <td class='' colspan=2  align="center"> 
                <input type='text' size='3' name='nfee_mon'  value='<%=AddUtil.parseInt((String)base1.get("S_MON"))%>' readonly class='num' maxlength='4' >
                ����&nbsp;&nbsp;&nbsp; 
                <input type='text' size='3' name='nfee_day'  value='<%=AddUtil.parseInt((String)base1.get("S_DAY"))%>' readonly class='num' maxlength='4' >
                ��</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" class="title">�ݾ�</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt'  readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' > ��</td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> ��</td>  
              <td>������꼭�� ���� �Ǵ� ��ҿ��θ� Ȯ��</td>
            </tr>
         
            <tr> 
              <td class="title" colspan="2">�Ұ�(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt' value='' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>  
              <td class='title'>&nbsp;=������ + �̳���</td>
   	        </tr>                    
            <input type='hidden' size='15' name='d_amt' value='' readonly class='num' >
            <input type='hidden' size='15' name='d_amt_1' readonly value='' class='num' >  
            
            <tr> 
              <td rowspan="6" class="title">��<br>
                ��<br>
                ��<br>
                ��<br>
                ��<br>
                ��<br>
                ��</td>
              <td align="center" colspan="2" class="title">�뿩���Ѿ�</td>
              <td class='' colspan=2  align="center"> 
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base1.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>
              <td>=������+���뿩���Ѿ�</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">���뿩��(ȯ��)</td>
              <td class='' colspan=2 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>
              <td>=�뿩���Ѿס����Ⱓ</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">�ܿ��뿩���Ⱓ</td>
              <td class=''  colspan=2  align="center"> 
                <input type='text' name='rcon_mon' readonly  size='3' value='<%=AddUtil.parseInt((String)base1.get("N_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                ����&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day'  size='3' value='<%=AddUtil.parseInt((String)base1.get("N_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                ��</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
              <td class=''  colspan=2 align="center"> 
                <input type='text' name='trfee_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> ����� 
                �������</td>
              <td class=''  align="center"> 
                <input type='text' name='dft_int' readonly value='<%=base1.get("CLS_R_PER")%>' size='5' class='num'  maxlength='4'>
                %</td>
                <td class=''  align="center"> 
                <input type='text' name='dft_int_1' value='<%=base1.get("CLS_R_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
                %</td>
           
              <td>*����� ��������� ��༭�� Ȯ�� <!--<br><font color=red>*</font>��������� ������ �߻��� ����ȿ������ڸ� �ݵ�� ����--></td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">�ߵ����������(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='' >
                ��</td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' size='15' class='num' value='' onBlur='javascript:set_cls_amt(this)'>
                ��</td>
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
                <td class="title">
                <input type='hidden' name='tax_chk0' value='N' onClick="javascript:set_vat_amt(this);"><!--��꼭�����Ƿ�-->
                <!--
                &nbsp;<font color="#FF0000">*</font>����ȿ�������: 
                      <select name='dft_cost_id'>
		                <option value="">����</option>
		                <%	if(user_size > 0){
								for(int i = 0 ; i < user_size ; i++){
									Hashtable user = (Hashtable)users.elementAt(i); %>
		                <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
		  
		                <%		}
							}%>
		              </select>
	    -->	              
                </td>
 
            </tr>      
       
            <tr> 
              <td class="title" rowspan="6"><br>
                ��<br>
                Ÿ</td>               
              <td colspan="2" align="center" class="title">��ü��(H)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' > ��</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> ��</td>
             
              <td class='title'>&nbsp;</td>
            </tr>
            <tr>
              <td class="title" colspan="2">����ȸ�����ֺ��(I)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                ��</td>
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                ��</td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;<input type='hidden' name='tax_chk1' value='N' ></td>
            </tr>
            <tr> 
              <td class="title" colspan="2">����ȸ���δ���(J)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc2_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                ��</td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>  
              <td class="title">&nbsp;<input type='hidden' name='tax_chk2' value='N'></td>
            </tr>
            <tr> 
              <td colspan="2" class="title">������������(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                ��</td>  
              <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">��Ÿ���ع���(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                ��</td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;
              <font color="#FF0000">*</font>���谡�Ը�å��:&nbsp;<input type='text' class='num' name='car_ja' size='7' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' readonly ><input type='hidden' name='tax_chk3' value='N' ><input type='hidden' name='tax_chk3' value='N' onClick="javascript:set_vat_amt(this);"><!--��꼭�����Ƿ�--></td>
            </tr>
            
            <tr> 
              <td class="title" colspan="2">�ʰ�����뿩��(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt_1'  readonly  value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                ��</td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
                 <input type='hidden' name='tax_chk4'  value=''>
                 <td class="title">&nbsp;<!--<input type='checkbox' name='tax_chk4' value='Y' onClick="javascript:set_vat_amt(this);">��꼭�����Ƿ� --></td>
            </tr> 
                   
            <tr> 
              <td class="title" colspan="3">�ΰ���(N)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='' readonly size='15' class='num' >
                ��</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='' readonly size='15' class='num' >
                ��</td>  
              <td > 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
                    <td id=td_cancel_n style="display:''" class="title">=(F+M-B-C)��10%  </td>
                    <td id=td_cancel_y style='display:none' class='title'>=(F+M-B-C)��10% </td>
                  </tr>
                </table>
              </td>
            </tr>
            
            <tr> 
              <td class="title_p" colspan="4">��</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1' value='' readonly  size='15' class='num' >
                ��</td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='' readonly  size='15' class='num' >
                ��</td>  
              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M+N)&nbsp;&nbsp;
               <br>�� ��꼭:&nbsp;             
                <input type="radio" name="tax_reg_gu" value="N" checked >�׸񺰰�������
                <input type="radio" name="tax_reg_gu" value="Y" >�׸����չ���(1��)
              </td>
            </tr>
          </table>
        </td>
         
    </tr>
    <tr></tr><tr></tr><tr></tr>
    
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >�����Աݾ�</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2'  size='15' class='num' readonly  > ��</td>           
                              
                    <% if ( re_acc_no == null   || re_acc_no.equals("")  ) {%>
                    <td colspan=6>&nbsp;�� �̳��Աݾװ� - ȯ�ұݾװ� </td>
                    <% } else { %>                  
                  	<td class=title width=12% ><input type='checkbox' name='cms_chk' value='Y'  checked >CMS�����Ƿ�</td>
                 	<td colspan=5>&nbsp;�� �̳��Աݾװ� - ȯ�ұݾװ�</td>                   	
                    <% } %>
                    
              </tr>
          
              </table>
         </td>       
    <tr>
    
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ����������� CMS(ī��CMS)�� �����ϴ°��� CMS�����Ƿڿ� check �ϼ���. </td>
    </tr>    
    <tr>
        <td>&nbsp;<font color="#FF0000">*** �̿�Ⱓ 1���� �̸��� ȯ���� �߻��� ��� ī����ι�ȣ Ȯ���Ͽ� ī������� �ش��ϱ��� �̿�ݾ��� �ٽ� ī�� �����ϼž� �մϴ�. ī��������� �ݾ��� �ݵ�� Ȯ���ϼ���!!! </font></td>
    </tr> 


 <!-- ȯ�ұݾ��� �ִ� ��쿡 ���� -->
        
   	<tr id=tr_card style='display:none'> 
   	
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ī������</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	
         	 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                 <tr>
                   <td width='5%' class='title' >����</td>	
                   <td width='5%' class='title' >����</td>	
                   <td width='10%' class='title' >1ȸ������ </td>	
                   <td width='15%' class='title'>������</td>
        		      <td width='10%' class='title'>���αݾ�</td>
		            <td width="10%" class='title'>���ι�ȣ</td>		           
				           	
				     </tr>	
                </table>
            </td>
         </tr>             
         
<% if (    vt_c_size   > 0 && ip_chk.equals("") ) { %>
		 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
<%
		for(int i = 0 ; i < vt_c_size ; i++)
		{
				Hashtable htc = (Hashtable) vt_card.elementAt(i);	%>               
              <tr>
                    <td width='5%' align='center'><input type='checkbox' name='t_card' value='<%=htc.get("R_DATE")%>'  onClick="javascript:set_card_amt();"  ></td>		
                      <td width='5%' align='center'><%=i+1%><input type="hidden" name="t_card_c" value='<%=htc.get("CARD")%>' ></td>
                      <td width='10%' align='center'><input type="hidden" name="t_f_tm_chk" value="<%=htc.get("F_TM_CHK")%>"><%=htc.get("F_TM_CHK")%></td>
        		         <td width='15%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(htc.get("R_DATE")))%></td>
		               <td width="10%" align='center'><input type="hidden" name="t_c_amt" value="<%=htc.get("R_AMOUNT")%>"><%=Util.parseDecimal(String.valueOf(htc.get("R_AMOUNT")))%></td>
		               <td width='10%' align='center' ><%=htc.get("APPR_NO")%></td>						             	
				   </tr>	
		<%		}    %>  		
                </table>
            </td>
         </tr>             
	<%		}    %>  	
         
          <tr></tr><tr></tr><tr></tr>     
         <tr>
         <input type='hidden' name='r_date'   >       
 		  <input type="hidden" name="jung_st"  >
          
          <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10%>ī�� ��ұݾ�</td>
                    <td width=12% >&nbsp;<input type='text' name='h5_amt'  readonly   size='15' class='num'  > ��</td>        
                    
                     <td class=title width=10%>ī��(��)��ݾ�</td>
                    <td width=12% >&nbsp;<input type='text' name='h7_amt'    size='15' class='num'  > ��</td>                 
                             
                   	<td colspan=4>&nbsp;                
                  </td>             		     
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
    
    <tr></tr><tr></tr><tr></tr>
    
  
     <!-- �ʰ�����δ�ݿ� ����  block none-->
    
   	<tr id=tr_over style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ʰ�����뿩��</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	 	 	
 	 	   <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  colspan="3"  width='34%'>�׸�</td>
              <td class="title" width='20%'>����</td>                
              <td class="title" width='46%'>���</td>
            </tr>
            <tr> 
              <td class="title"  rowspan="6" >��<br>��<br>��<br>��</td>   
              <td class="title"  rowspan=3>��೻��</td>
              <td class="title" >���Ⱓ</td>
              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%>  </td>
              <td align="left" >&nbsp;���ʰ��Ⱓ</td>
             </tr>
              <tr> 
              <td class="title" >�����Ÿ� (��)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
              <td align="left" >&nbsp;����</td>
             </tr>      
              <tr> 
              <td class="title" > �ܰ�(�δ��) (a)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>��</td>
               <td align="left" >&nbsp;=1km</td>
             </tr>           
            <tr> 
              <td class="title"  rowspan=3>�������</td>
              <td class="title" >�뿩�Ⱓ</td>
              <td align="right">&nbsp;</td>
              <td align="left" >&nbsp;�����뿩�Ⱓ</td>
             </tr>   
              <tr> 
              <td class="title" >�뿩�ϼ�(��)</td>
              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("RENT_DAYS")))%>' size='7' class='whitenum' > �� </td>
              <td align="left" >&nbsp;</td>
             </tr>
             <tr> 
              <td class="title" >�����Ÿ�(�ѵ�)(c)</td>
              <td align="right" ><input type='text' name='cal_dist' readonly   size='7' class='whitenum' > km</td>
               <td align="left" >&nbsp;=(��)x(��) / 30</td>
             </tr>
             <tr> 
              <td class="title"  rowspan="6" >��<br>��<br>��<br>��</td>      
               <td class="title"  rowspan=3>����Ÿ�</td>
              <td class="title" >��������Ÿ���(d)</td>
             <td align="right" ><input type='text' name='first_dist' readonly  value = '<%=AddUtil.parseDecimal(car1.getSh_km() )%>'  size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;����(�� �ε����� ����Ÿ�) , ������ (��༭�� ��õ� ����Ÿ�)</td>
             </tr>   
             <tr> 
              <td class="title" >��������Ÿ���(e)</td>
              <td align="right" ><input type='text' name='last_dist' readonly   size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>              
             <tr> 
              <td class="title" >�ǿ���Ÿ�(f)</td>
              <td align="right" ><input type='text' name='real_dist' readonly    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(e)-(d) </td>
             </tr>                          
              <tr> 
              <td class="title"  rowspan=3>�������</td>
              <td class="title" >�ʰ�����Ÿ�(g)</td>
              <td align="right" ><input type='text' name='over_dist' readonly    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(f)-(c) </td>
             </tr>
              <tr> 
              <td class="title" >���񽺸��ϸ���</td>
              <td align="right" ><input type='text' name='add_dist' readonly    size='7' class='whitenum' > km</td>
                <td align="left" >&nbsp;</td>
             </tr>      
              <tr> 
              <td class="title" >�������(b)</td>
              <td align="right" ><input type='text' name='jung_dist' readonly    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>  
             <tr> 
              <td class="title"  rowspan=3>��<br>��</td>
              <td class="title" colspan=2 >����ݾ�(h)</td>
              <td align="right" ><input type='text' name='r_over_amt' readonly    size='10' class='whitenum' >��</td>
              <td align="left" >&nbsp;=(a)x(b)</td>
             </tr>
              <tr> 
              <td class="title"   colspan=2 >����(i)</td>
              <td align="right"> <input type='text' name='m_over_amt'   size='10' class='num'   onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> ��</td>
              <td align="left" >&nbsp;�����ڹ׻���:
                <select name='m_saction_id'>
			                <option value="">--����--</option>
			                <%	if(user_size1 > 0){
									for(int i = 0 ; i < user_size1 ; i++){
										Hashtable user1 = (Hashtable)users1.elementAt(i); %>
							<option value='<%=user1.get("USER_ID")%>'><%=user1.get("USER_NM")%></option>

			  
			                <%		}
								}%>
		 </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="m_reason" cols="55" class="text" style="IME-MODE: active" rows="2"></textarea> </td>
             </tr>      
              <tr> 
              <td class="title"   colspan=2 >����(����)�ݾ�</td>
              <td align="right" ><input type='text' name='j_over_amt' readonly    size='10' class='whitenum' >��</td>
              <td align="left" >&nbsp;=(h)-(i)</td>
             </tr>  
                </table>
            </td>
         </tr>         
  
     	</table>
      </td>	 
    </tr>	
    	      
	<!-- ����ä���� �ִ� ��� -->
    <tr id=tr_get style="display:''"> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>  
		    <tr>
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ä���� �ڱ�å</span></td>
		    </tr>
		    <tr>
		        <td class=line2></td>
		    </tr>
		    <tr>
		        <td class=line>
		            <table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
		                    <td class=title width=12%>����</td>
		                    <td colspan=7>&nbsp; 
								  <select name="div_st" onChange='javascript:cls_display3()'>
								    <option value="">---����---</option>
					                <option value="1">�Ͻó�</option>
					                <option value="2">�г�</option>
					              </select>             
					              <table width="100%" border="0" cellspacing="0" cellpadding="0">
					                        <tr> 
					                         
					                           <td id='td_div' style='display:none'>&nbsp;�г�Ƚ��&nbsp;  
					                             <select name="div_cnt">
												    <option value="">---����---</option>
									                <option value="2">2</option>
									                <option value="3">3</option>
									                <option value="4">4</option>
									                <option value="5">5</option>
									                <option value="6">6</option>
									                <option value="7">7</option>
									                <option value="8">8</option>
									                <option value="9">9</option>
									                <option value="10">10</option>
									                <option value="11">11</option>
									                <option value="12">12</option>
									              </select>
					                            </td>
					                        </tr>
					                </table>
					         	</td>
					    	</tr>
					  
		                	<tr>
			                    <td class=title width=13%>����</td>
			                    <td class=title width=12%>������</td>
			                    <td>&nbsp;<input type='text' name='est_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'> 
			                    <td class=title width=12%>�����ݾ�</td>
			                    <td>&nbsp;<input type='text' name='est_amt' size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'> ��</td>
			                    <td class=title width=12%>������</td>
			                    <td>&nbsp;<input type='text' name='est_nm' size='15' class='text'></td>
		                	</tr>
		             	                
		            	</td>
		        	</tr>
		    	</table>
		  		</td>
		    </tr>
			<tr></tr><tr></tr><tr></tr><tr></tr>
			<tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>
							           <td class=title width=13%>����������</td>
								  <td width=12%>&nbsp;<input type='text' name='gur_nm' size='15' class='text'></td>
						                     <td width=12% class=title>����ó</td>
						                     <td>&nbsp;<input type='text' name='gur_rel_tel' size='30' class='text'></td>
						                     <td width=12% class=title>����ڿ��ǰ���</td>  
						                     <td colspan=3>&nbsp;<input type='text' name='gur_rel' size='30' class='text'></td>     		           			             
		               			    </tr>
		               			 </table>
		               		</td>
		                </tr>
		             </table>
		          </td>
		    </tr>
		   	<tr></tr><tr></tr><tr></tr>
			<tr>
				<td>
					<table width=100%  border=0 cellspacing=1 cellpadding=0>
		                <tr>
					        <td class=line colspan=8>
					            <table width=100%  border=0 cellspacing=1 cellpadding=0>
					                <tr>              
					                    <td class=title style='height:44' width=13%>ó���ǰ�/���û���/<br>����</td>
					                    <td colspan=7>&nbsp;
					                    <textarea name="remark" cols="140" class="text" style="IME-MODE: active" rows="3"></textarea> 
					                    </td>
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
       	</table>
      </td>	 
    </tr>	  	   
    
    <!-- ȯ�ұݾ��� �ִ� ��쿡 ���� -->
        
   	<tr id=tr_refund style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ȯ������</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	
 	 	 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                    <tr> 
                        <td class="title"> �ڵ���ü </td>
                        <td >&nbsp; <input type="checkbox" name="re_cms_chk" value='Y' onClick="javascript:set_cms_value(this);">����</td>
                        <td class="title">�����ָ�</td>
                        <td >&nbsp; <input type="text" name="re_acc_nm" value="" size="30" class=text></td>
                    </tr>
                        
                    <tr> 
                        <td width=15% class="title">�����</td>
                        <td width=35%>&nbsp; <select name="re_bank" style="width:135">
                            <option value="">==����==</option>
			      <% if(cms_bnk_size1 > 0){
						for(int i = 0 ; i < cms_bnk_size1 ; i++){
							Hashtable h_c_bnk = (Hashtable)cms_bnk.elementAt(i); %>  
					    	<option value='<%=h_c_bnk.get("BCODE")%>'><%=h_c_bnk.get("BNAME")%></option> 	
                     
				              <%		}
							}%>
				              </select></td>
                        <td width=15% class="title">���¹�ȣ</td>
                        <td width=35%>&nbsp; <input type="text" name="re_acc_no" value="" size="30" class=text></td>
                    </tr>
                  
                </table>
            </td>
         </tr>             
                            
         <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	    
    
    <!-- ȯ�ұݾ��� �ִ� ��쿡 ���� -->
        
   	<tr id=tr_scd_ext style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ���������</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>	
 	 	
 	 	 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                 <tr>
                    <td width='5%' class='title' >����</td>					
		            <td width='14%' class='title'>����ȣ</td>
        		    <td width='10%' class='title'>������</td>
		            <td width="28%" class='title'>��</td>
		            <td width='10%' class='title'>������ȣ</td>		
				    <td width='15%' class='title'>����</td>	
				    <td width='9%' class='title'>�ݾ�</td>		
				    <td width='9%' class='title'>�������</td>		                	
				</tr>	
                </table>
            </td>
         </tr>             
 <%
	if(vt_size > 0)
	{	
%>     
		 <tr> 
            <td class="line">
                <table width="100%" border="0" cellspacing="1" cellpadding="0">
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht_ext = (Hashtable) vt_ext.elementAt(i);	%>                
                 <tr>
                    <td width='5%' align='center'><%=i+1%></td>					
		            <td width='14%' align='center'><%=ht_ext.get("RENT_L_CD")%></td>
        		    <td width='10%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht_ext.get("CLS_DT")))%></td>
		            <td width="28%" align='center'><%=ht_ext.get("FIRM_NM")%></td>
		            <td width='10%' align='center' ><%=ht_ext.get("CAR_NO")%></td>		
				    <td width='15%' align='center'><%=ht_ext.get("CAR_NM")%></td>	
				    <td width='9%' align='right'><%=Util.parseDecimal(String.valueOf(ht_ext.get("CLS_AMT")))%></td>		
				    <td width='9%' align='center'><%=c_db.getNameById(String.valueOf(ht_ext.get("BUS_ID2")),"USER")%></td>		                	
				</tr>	
		<%		}    %>  		
                </table>
            </td>
         </tr>             
     
<%	}  %>	
                      
         <tr>
     		 <td>&nbsp;</td>
     	 </tr>
     	</table>
      </td>	 
    </tr>	  	 	    
        
    <tr>
      	<td align="center">&nbsp;
      	<% if (nm_db.getWorkAuthUser("������",user_id)) {%>
      	<a href="javascript:save1();">�Է¿����� ó��</a>  &nbsp; 
      	<% } %>
      	<%// if (nm_db.getWorkAuthUser("����������",user_id) || nm_db.getWorkAuthUser("�������ⳳ",user_id) || nm_db.getWorkAuthUser("�������������",user_id) || nm_db.getWorkAuthUser("����������ΰ���",user_id)) { %>
      	<%//} else { %>
      	<a href="javascript:save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle>
      	<%// } %>
	  <td align="center"></td>
	</tr>	
  
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // ���ô뿩�� �ܾ�
		var v_ifee_ex_amt = 0;  //���ô뿩�� ����ݾ�
		var  re_nfee_amt = 0;  //�������� �����쿡�� �ϼ� ����� �ݾ��� �ƴ� ��� check
 	 	 	 	
 	   	 fm.h5_amt.value =0;
		 fm.h7_amt.value =0;
		  	 
		  	 	
 	 	//�ѻ���ϼ� �ʱ� ����		
		if(fm.r_day.value == '30'){
			fm.r_mon.value = toInt(fm.r_mon.value) + 1;
			fm.r_day.value = '0';			
		}
				    
 		//0 ���� ���� ���	
		if(toInt(fm.r_day.value)  <0){
			fm.r_day.value = '0';			
		}	 
 			 				
 		if(toInt(fm.nfee_day.value)  <0){
			fm.nfee_day.value = '0';			
		}		    
				
		//�������� ��ุ���Ϻ��� ū ��� �������� setting
		if ( toInt(fm.rent_end_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
			fm.cancel_yn.value = 'N';
			td_cancel_n.style.display 		= 'none';  //��������
			td_cancel_y.style.display 		= '';  //�������
		}
		
		//�ʰ�����δ��	
		if ( <%= o_amt%> > 0 ) {
			tr_over.style.display 		= '';  //�ʰ�����δ��
		}
				
	
		//�ܿ�������?
		if(fm.pp_s_amt.value != '0'){		
			fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
			fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
			fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );   //+ toInt(parseDigit(fm.ifee_s_amt.value)) 
	
		}else{
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;
		}
			
		
		if(fm.pp_s_amt.value != '0') {
	 	 
	 	 	if ( fm.cls_st.value == '7' || fm.cls_st.value == '10') { //���������(����) , �縮��(����������)
	  		} else {
		    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //������
		    		
		    		fm.pded_s_amt.value 	= 0;
					fm.tpded_s_amt.value 	= 0;
					fm.rfee_s_amt.value 	= 0;
		    	}   
		    }	
	    }	
	    
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // �����ݾ��� ����� ���
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
	
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );

	 
		//�̳��Աݾ� ���� �ʱ� ����		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}
			
	          //����Ʈ ȯ��ݾ� - 2�����̸��ΰ�� ���뿩��� ���
		if( toInt(fm.r_mon.value)   < 2 )  {
		     	   fm.mfee_amt.value = fm.nfee_s_amt.value;
	     } else {
	        	     fm.nfee_s_amt.value = fm.mfee_amt.value;  //2�����̻��� ���� 5% dc�� ���ش뿩��	          
	   }
	   
	     //���ô뿩�ᰡ ���� ��� 		 -- nnfee_s_amt : �̳��ݾ�(�ܾ׾ƴ�). di_amt :�ܾ׹̳��ݾ�  	  -- �뿩���ð� �� ���     	
	   if(fm.ifee_s_amt.value == '0' ) {
		   	 // ������������� �������� �� ū ��� 
	     if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 		
		   	 	//	  alert("a");
		   	 		  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
		   	 		//    	 alert("b");
		   	 		    	var s1_str = fm.use_e_dt.value;
							var e1_str = fm.cls_dt.value;
							var  count1 = 0;
								
									   
							var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
							var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
					
							var diff1_date = e1_date.getTime() - s1_date.getTime();
					
							count1 = Math.floor(diff1_date/(24*60*60*1000));									
								
					  	   	if ( count1 >= 0 ) { // �뿩�Ḹ���ϰ� ������ �� (������ü�ϼ� ���)					  	   	
					  	   		 fm.nfee_mon.value = parseInt(count1 / 30); 
					  	   		 fm.nfee_day.value  =  parseInt(count1 % 30); 					  	 
					  	   }
		   	 		 
		   	 		  }  else  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   > 0    ) { //
		   	 	//	     alert("c");
		   	 		     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // �ܾ��� �߻��Ǿ��⿡ 1�� ����
		   	 		      if ( toInt(fm.nfee_mon.value) < 0 ) {
						  	 	   	  fm.nfee_mon.value = '0';
						  }
		   	 		     
		   	 		  } 
		   	 	
		   	} //�������� ����.  		  
		
		} //���ô뿩�ᰡ ���� ���	 	   		   		
		
								       			
		//�̳��ݾ�  - ���ô뿩�ᰡ �ִ� ��� ���ô뿩�Ḹŭ �������� �̻���, ������ ���� �������� ������ ���̶�� ������ ������� �̳��ݾ� ����ϰ�,
		//            ������ �������� ���� ���� ������ô�Ḧ ����Ͽ� �̳��ݾ��� �����
		//�����ٻ����ȵ� ����ϼ� �� ���
		//�뿩�ᰡ 100������ ��� ���� ó�� - 2011-01-24.	
			
	
	if ( toInt(parseDigit(fm.nfee_s_amt.value)) < 100 ) {
		  if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
		   		fm.nfee_day.value = '0';
		  } 
		  fm.nfee_amt.value 			= parseDecimal( ( toInt(parseDigit(fm.pp_s_amt.value))/toInt(parseDigit(fm.lfee_mon.value)) )  * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
	   } else {
		  fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
	    }
	
		if (fm.ifee_s_amt.value == '0' ) {	
		  	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
		      if  ( fm.nfee_amt.value  != '0' ) {
			     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
		 	    	fm.nfee_amt.value = fm.nnfee_s_amt.value;
			 	 }	
			  }	 
		    }
		
		}     		   				
		
		//�뿩���ð� �ȵ� ��
		if(fm.rent_start_dt.value == '')	{		  
		   fm.nfee_mon.value = '0';
		   fm.nfee_day.value  = '0' ;
		   fm.nfee_amt.value  = '0' ;				
		}
		     
	       	  //����Ʈ ���� �߰�		
	   	//1�޹̸� ������ ���. ��¥�� ������꿡 ����.
	   	//�ѻ���ϼ� �ʱ� ����		
		if(fm.r_mon.value  == '0' )  {
		          if ( toInt(parseDigit(fm.nfee_amt.value))  > 0 ) {  //�̳��� �ִٸ�  (�����ε� ���ܷ� �ĳ���)
			 	   fm.nfee_amt.value 	=   parseDecimal(  toInt(parseDigit(fm.add_amt_d.value)) ) ; 	    
			 }      
			     	
			   			   
				       //�����뿩�� - ���������� ������ 
			   if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {	 
			            
					   if ( toInt(parseDigit(fm.day_cnt.value)) >   toInt(parseDigit(fm.r_day.value))  ) {	  
					   	  	  fm.ex_di_amt.value       =   parseDecimal( ( toInt(parseDigit(fm.fee_s_amt.value))  -  toInt(parseDigit(fm.add_amt_d.value))) * (-1)  ) ; 					   	  	  
					   	   	 fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		 
					   	   	 fm.nfee_mon.value = '0';
							 fm.nfee_day.value = '0';
							 fm.nfee_amt.value = '0';			            
				       }   	 
					 				 
			  } 
		   	
		   	
		//	   alert(  parseDecimal( ( toInt(parseDigit(fm.fee_s_amt.value))  -  toInt(parseDigit(fm.add_amt_d.value))) * (-1)  ) );
			 
		} else {   //�ܿ��뿩�� �ϼ��� �ٽ� ��� ( ȯ���� ���)  rcon_mon, rcon_day:�ܿ��뿩�Ⱓ  r_mon, r_day :�̿�Ⱓ 
		 		 //����Ʈ�� ������   - ������ ���� �Աݰ��� �ִٸ�  
			    // �Ϻ��� �ȵȰ��� ���� ������ �ϴ� ó�� - �������� ���� ���
			       			        
				          if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {
				                    
				                    //1���̰� ������� ������  ������� �߰��ؼ� 
				                       if ( toInt(parseDigit(fm.cons_s_amt.value))  > 0  &&  fm.r_mon.value  == '1'  && fm.r_day.value  == '0'   ) {
				                            fm.ex_di_amt.value      = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  +  toInt(parseDigit(fm.cons_s_amt.value))   -    toInt(parseDigit(fm.rc_s_amt.value)) );	 
				        		         fm.ex_di_v_amt.value  =   parseDecimal(  toInt(parseDigit(fm.rr_amt.value))    +  toInt(parseDigit(fm.cons_s_amt.value)) +  toInt(parseDigit(fm.cons_v_amt.value))    -  toInt(parseDigit(fm.rc_s_amt.value)) -  toInt(parseDigit(fm.rc_v_amt.value)) -   toInt(parseDigit(fm.ex_di_amt.value))  );	       
				                       				                                       
				                       } else {
				                       					                       	
				        		      fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );	 
				        		      fm.ex_di_v_amt.value  =   parseDecimal(  toInt(parseDigit(fm.rr_amt.value))   -  toInt(parseDigit(fm.rc_s_amt.value)) -  toInt(parseDigit(fm.rc_v_amt.value)) -   toInt(parseDigit(fm.ex_di_amt.value))  );	       
						     }
						      fm.nfee_mon.value = '0';
						      fm.nfee_day.value = '0';
						      fm.nfee_amt.value = '0';
						
					//	      alert(	 fm.rr_s_amt.value  );	
					//	      alert(	 fm.rr_amt.value  );	
						      	         
				          }
			
		}	
					
	 //       alert( fm.ex_s_amt.value );	
	         
	 //  	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	 	
	   	fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		   	
		fm.nfee_amt_1.value 		= fm.nfee_amt.value; 
		fm.ex_di_amt_1.value 		= fm.ex_di_amt.value; 
		    
		fm.ex_di_v_amt_1.value 		= fm.ex_di_v_amt.value; 	    
	   
	//  	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)));
	
		if(toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.mfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.tfee_amt.value)) / toInt(fm.con_mon.value) );		
		}
		fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
		
		if(toInt(parseDigit(fm.trfee_amt.value)) < 0){
			fm.rcon_mon.value = "0";
			fm.rcon_day.value = "0";		
			fm.trfee_amt.value = "0";					
		}	
			
		
		if(fm.dft_int.value == '' || fm.dft_int.value == '0' ) {
			fm.dft_int.value 			= 10;			
			fm.dft_int_1.value 			= 10;			
		}	
			
			
		if (  toInt(fm.rent_start_dt.value) < 1 ) {
			fm.dft_amt.value 			= "0"; 
			fm.dft_amt_1.value 			= "0";
			
		} else {	
			if ( fm.cls_st.value == '7' || fm.cls_st.value == '10' ) { //���������(����)�� ��� ��������� 0
				fm.dft_amt.value 			= "0"; 
				fm.dft_amt_1.value 			= "0";			
			} else { 	
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int_1.value)/100) );
				
			}	
	        }
		
						
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
		
		//����Ʈ-   �ѻ���ϼ� �ʱ� ����	- ����Ʈ�ΰ�� 1���� �̸��� ��� ���� ���� - 1���� ���� ���� �ߵ����� ����� �߻�				
		if(fm.r_mon.value  == '0' )  {
		     if ( toInt(parseDigit(fm.day_cnt.value)) >   toInt(parseDigit(fm.r_day.value))  ) {	  
				 	fm.dft_amt.value 			= '0';
		      }
		}      
		        				
		var no_v_amt =0;  //�ΰ����� ������ ���
		var no_v_amt1 =0;  //�ΰ����� ������ ���				
						
		no_v_amt 	= toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value))  + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) + (toInt(parseDigit(fm.over_amt_1.value)) * 0.1 ) -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
		
				
	//  �ΰ��� ���� - 20220420 �߰� 
	    fm.rifee_v_amt.value = parseDecimal( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //���ô뿩�� 
	    fm.rfee_v_amt.value = parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value))*0.1 );    //������ 
	    
	    fm.dfee_v_amt.value =  parseDecimal( toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1) );  //���� �뿩�� �ΰ��� 
	    fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) );  //Ȯ�� �뿩�� �ΰ��� 
	    
	    fm.over_v_amt.value =   '0';  //���� �ʰ����� �ΰ��� 
	    fm.over_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );  //Ȯ�� �ʰ����� �ΰ��� 
	    			
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
	
        //�̳��ݾװ�
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.dfee_amt.value)) +  toInt(parseDigit(fm.dly_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.over_amt.value))   + toInt(parseDigit(fm.no_v_amt.value)));
		
		//Ȯ���ݾ� �����ֱ�
		fm.dly_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dly_amt.value))) ;
		fm.dft_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dft_amt.value)));
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
	
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) +  toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))  + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)) );	 //Ȯ���ݾ�	
				
		set_tax_init();
			
		//���� ������ �ݾ� �ʱ� ����	(���ԿɼǱݾ��� ǥ�� ����)
		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );		
		
		//������ �ݾ��� �ִٸ�
		if ( toInt(parseDigit(fm.fdft_amt2.value)) < 0 ) {
			 tr_refund.style.display		= '';	//ȯ������
			 tr_scd_ext.style.display		= '';	//�������������
			 if ( <%=vt_c_size%> > 0 ) {
				 tr_card.style.display		= '';	//ī������ 
				 set_card_amt();
			// 	 fm.h5_amt.value 			= parseDecimal( toInt(parseDigit(fm.t_amount.value )) );  //ī�� �����ݾ�  
			//  	 fm.h7_amt.value 			= parseDecimal( toInt(parseDigit(fm.h5_amt.value)) + toInt(parseDigit(fm.fdft_amt2.value)) );  //ī�� �����ݾ� 
			  	 fm.jung_st.value = '3';
			}	 
		} else {
			 tr_refund.style.display		= 'none';	//ȯ������
			 tr_scd_ext.style.display		= 'none';	//�������������
		  	 tr_card.style.display		= 'none';	// ī������
		  	 fm.h5_amt.value =0;
		  	 fm.h7_amt.value =0;
		  	 fm.jung_st.value = '1';
		  
		}	
	
	}
	
	//���ݰ�꼭
	function set_tax_init(){
		var fm = document.form1;
		
		/* 2022-04 ������
			//�ߵ����������
		if(toInt(parseDigit(fm.dft_amt.value)) > 0){
				fm.tax_g[0].value       = "�ߵ����� �����";
				fm.tax_supply[0].value 	= fm.dft_amt.value;
				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt.value)) * 0.1 );
		}			
		
			//�������ֺ��
		if(toInt(parseDigit(fm.etc_amt.value)) > 0){
				fm.tax_g[1].value       = "ȸ�� �������ֺ��";
		   		fm.tax_supply[1].value 	= fm.etc_amt.value;
				fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt.value)) * 0.1 );
	
		}
		
			//�����δ���
		if(toInt(parseDigit(fm.etc2_amt.value)) > 0){
				fm.tax_g[2].value       = "ȸ�� �δ���";
		   		fm.tax_supply[2].value 	= fm.etc2_amt.value;
				fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt.value)) * 0.1 );
	
		}
		
			//��Ÿ���ع���
		if(toInt(parseDigit(fm.etc4_amt.value)) > 0){
				fm.tax_g[3].value       = "��Ÿ���ع���";
		   		fm.tax_supply[3].value 	= fm.etc4_amt.value;
				fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt.value)) * 0.1 );
	
		}
		*/
		
				//�ʰ�����δ��
		if(toInt(parseDigit(fm.over_amt_1.value)) > 0){
				fm.tax_g[4].value       = "�ʰ�����뿩��";
		   		fm.tax_supply[4].value 	= fm.over_amt_1.value;
				fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );
	
		}	
		
	}	
	
//-->
</script>
</body>
</html>
