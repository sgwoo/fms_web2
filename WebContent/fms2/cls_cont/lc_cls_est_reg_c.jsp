<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.estimate_mng.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.credit.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.user_mng.*, acar.con_tax.*, acar.fee.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
  //�������꼭�� �ΰ��� �׸񺰷� ���� ���� ���� - 202204
  
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?acar_br:request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cls_dt =  request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
		
	if(rent_l_cd.equals("")) return;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();   //�ߵ����Կɼǰ��� ���� ������������ 
		
	//���⺻����
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
		
	if(base.getUse_yn().equals("N"))	return;
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//����Ÿ����
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. �� ---------------------------
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//�����⺻���� - �������� 
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
		
	//�ڵ����⺻����
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//�����������
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//�����������
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//����������� ����Ʈ
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();	
	
	//3. �뿩-----------------------------
	
	//�뿩�᰹����ȸ(���忩��)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	int fee_size_1 = fee_size - 1;  //fee-size���� ������ 
    int fee_size_1_opt_amt = 0;
    String fee_size_1_end_dt= "";
	
	//�����뿩����
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
		
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//fee ��Ÿ - ����Ÿ� �ʰ��� ���
//	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	ContCarBean  car1 = a_db.getContFeeEtc(rent_mng_id, rent_l_cd,"1"); //��������Ÿ��� 
	int  o_amt =   car1.getOver_run_amt();
	 	 
	String  agree_yn = car1.getAgree_dist_yn();
	 
	  // agree_dist_yn  1:���׸���,  2:50% ����,  3:100%����  : ����Ÿ��� �־�� ��� ���� 20130604  ������- 2016�� ���� ����.
	 	
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
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, "", "");
			
	String s_opt_per="";
		
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;
	String s_opt_end_dt = "";
		
	int pp_amt = AddUtil.parseInt((String)base1.get("PP_S_AMT"));
	
		//��å�� ��û���� ���� ����ó�� ���� ����
	int car_ja_no_amt =  ac_db.getCarServiceBillNo(rent_mng_id, rent_l_cd);
	
	//������ ��ϵǾ����� ����
	int reg_cnt = 0;
	reg_cnt= ac_db.getClsEstCnt(rent_mng_id, rent_l_cd);
					
	//��Ÿ��� ���񺸻�
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(base.getCar_mng_id(), "N");		
//	out.println(fuel_cnt);
	
	Hashtable  return1 =   new Hashtable();
		
    int  return_amt = 0;
	String return_remark = "";
	
	//   ��Ÿ�� ,���� , ���� - �Ѵ� �ش�, ȥ�ٴ� ���Կɼ��϶��� �ش� , 
    if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id(), "N");
	  	return_amt = Integer.parseInt(String.valueOf(return1.get("AMT")));
	  	return_remark = (String)return1.get("REMARK");
    }
  
   //car_price 
    int car_price =  car.getCar_cs_amt() + car.getCar_cv_amt() + car.getOpt_cs_amt() + car.getOpt_cv_amt() +  car.getClr_cs_amt()  +  car.getClr_cv_amt()  - car.getDc_cs_amt() - car.getDc_cv_amt(); 
//	int car_price =  car.getCar_cs_amt() + car.getCar_cv_amt() + car.getOpt_cs_amt() + car.getOpt_cv_amt() +  car.getClr_cs_amt()  +  car.getClr_cv_amt()  ; 
	float f_opt_per = 0;
		
		//�ߵ����Կɼ��� ��� ó������ ���� �������� - 20161024
    String a_a = "2";	//��Ʈ
	if(base.getCar_st().equals("3")) a_a = "1"; //����
		
	String a_j = "";
	if ( fee_size > 1  ) {  //�����̸� 
		a_j = e_db.getVar_b_dt("em", ext_fee.getRent_start_dt());   //   ���������Ϸ� ��ȸ (�����϶��� �뿩������)                
	 } else {
	 	a_j = e_db.getVar_b_dt("em", base.getRent_dt());   //   ���������Ϸ� ��ȸ (�����϶��� �뿩������)
	} 
		
    em_bean = e_db.getEstiCommVarCase(a_a, "", a_j);

//�ߵ����Կɼ� �ڵ����� tax_amt, ����: insure_amt, �Ϲݽ� ���: serv_amt ���ϱ� 
	Hashtable sale = ac_db.getVarAmt(rent_mng_id, rent_l_cd);
   
  	int e_tax_amt = AddUtil.parseInt((String)sale.get("TAX_AMT"));
  	int e_insur_amt = AddUtil.parseInt((String)sale.get("INSUR_AMT"));
  	int e_serv_amt = AddUtil.parseInt((String)sale.get("SERV_AMT")); 
  	
  	//���Ǻ����ΰ�� , ������ ���ؼ� - 20181012  	
  	if ( cont_etc.getInsur_per().equals("2")  ||  fee_size < 2   ) {
  	    e_insur_amt  =   fee.getIns_s_amt();
  	}
  	
  	 //�ߵ����Խ� ����������ȿ�� �ݾ� - 20191114���� 
    float f_grt_amt = 0;
    
    if ( em_bean.getA_f_2() > 0 ) {
 	   f_grt_amt = AddUtil.parseFloat((String)base1.get("GRT_AMT") ) *  em_bean.getA_f_2()/100 /12 ;
    } else {
 	   f_grt_amt = AddUtil.parseFloat((String)base1.get("GRT_AMT") ) *  em_bean.getA_f()/100 /12 ;
    }
  
   //�ߵ����Խ� ����������ȿ�� �ݾ�  
 //  f_grt_amt = AddUtil.parseFloat((String)base1.get("GRT_AMT") ) *  em_bean.getA_f()/100 /12 ;
    
   int  e_grt_amt =  (int)  f_grt_amt ; 	 	
   
  	int vt_size8 = 0;
		
	Vector vts8 = ac_db.getScdFeeList(rent_mng_id,  rent_l_cd);
	vt_size8 = vts8.size(); 	
	
	int t_fee_s_amt = 0;
	
		//�ܿ��뿩�Ⱓ ���ϱ� (function ���ó�� ) 	
	String r_ymd[] = new String[3]; 
	String rcon_mon = "";
	String rcon_day  = "";
		
	String rr_ymd =  String.valueOf(base1.get("R2_YMD"));
	
    StringTokenizer token1 = new StringTokenizer(rr_ymd,"^");
				
	while(token1.hasMoreTokens()) {
			
			r_ymd[0] = token1.nextToken().trim();	//��
			r_ymd[1] = token1.nextToken().trim();	//�� 
			r_ymd[2] = token1.nextToken().trim();	//�� 
	}	
		
	//�������� ���Ⱓ ������ ���	 
	if  (AddUtil.parseInt(r_ymd[0]) < 0 ||  AddUtil.parseInt(r_ymd[1]) < 0 || AddUtil.parseInt(r_ymd[2]) < 0 ) {		
	   rcon_mon =  "";
 	   rcon_day =  "";
	} else {
	   rcon_mon =  Integer.toString( AddUtil.parseInt(r_ymd[0])*12  + AddUtil.parseInt(r_ymd[1]));
	   rcon_day =   Integer.toString(  AddUtil.parseInt(r_ymd[2])) ;  	
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
	
		//���༱�ý� ���¹�ȣ ��������
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
		
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('����', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/fms2/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}
	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no.options[deposit_len-(i+1)] = null;
		}
	}
		
	function add_deposit(idx, val, str){
		document.form1.deposit_no[idx] = new Option(str, val);		
	}
	
	function save(){
		var fm = document.form1;
		
		if(fm.cls_st.value == '')				{ alert('���������� �����Ͻʽÿ�'); 		fm.cls_st.focus(); 		return;	}
		if(fm.cls_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.cls_dt.focus(); 		return;	}
		
		//������ ���� 2���� ������ ��� ���� 		
		var s_str = fm.today_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1, s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1 , e_str.substring(8,10) );
		
		var diff_date = e_date.getTime() - s_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
		
		if ( count > 61 ) { 
			alert("�������� ���糯¥�� 2�����̻� ���̽� ����� �� �����ϴ�.!!!"); 	
		    return;
		}	
		
		if( toInt(parseDigit(fm.reg_cnt.value)) > 0 ) { 	 alert('�̹� ��ϵ� ���Դϴ�. Ȯ���Ͻʽÿ�!!'); 	fm.cls_st.focus(); 		return;	}	
				
	    if( toInt(parseDigit(fm.tot_dist.value)) < 1 ) {
	    	   alert('����Ÿ��� �Է��Ͻʽÿ�'); 	
	    	 	fm.tot_dist.focus(); 
	    		fm.cls_st.value="";	
	    		fm.opt_amt.value=fm.mopt_amt.value;	
	    		cal_rc_rest_clear();
	    	 	return;
	    }		
			
		if( toInt(parseDigit(fm.fdft_amt2.value)) > 0 ){
		
			if(fm.est_dt.value == '')				{ alert('�������ڸ� �Է��Ͻʽÿ�'); 		fm.est_dt.focus(); 		return;	}		
		}
		
		//������ ���� ���� �ִ� ��� - �ڱ�å check
		if(fm.cls_st.value == '8'){ //���Կɼ� ���ý� ���÷���	
			if( toInt(parseDigit(fm.opt_amt.value)) == 0 ){ alert('���ԿɼǱݾ��� �Է��Ͻʽÿ�'); 		fm.cls_st.focus(); 	return;	}
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
				
		if(fm.cls_st.value == '8'){ //���Կɼ� ���ý� ���÷���	
			    var count =0;
	 			var s_str = fm.rent_end_dt.value;
				var e_str = fm.cls_dt.value;
				
				var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
				var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
				
				var diff_date = s_date.getTime() - e_date.getTime();
				
				count = Math.floor(diff_date/(24*60*60*1000));
			
				 if  ( toInt(fm.fee_size.value) < 2 ) { //������ �ƴϸ� 						
			    	   if (  toInt(fm.vt_size8.value)  >  1 ) {		 // �������� �ְ� ������ �ƴ�  ���  
			    			if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //������ ���� 
			    			   if ( count > 61) {
					    		  	if (  toInt(parseDigit(fm.t_cal_days.value)) <  1 ) { 
								    		alert("�ݾ�Ȯ���� Ŭ���ϼ���.!!");
											return;
								   	}
								}   	
						  }
					   }	    	
				} else {	  //������ ��� 	  
			   	       if (  toInt(fm.vt_size8.value)  >  1 ) {		 // �������� �ְ� ������ ���  
				 				    		
				    			if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //������ ����  - 30 �� �̻��̸� 
				        
					    			if ( count > 30 ) { 				
						    		  	if (  toInt(parseDigit(fm.t_cal_days.value)) <  1 ) { 
									    		alert("�ݾ�Ȯ���� Ŭ���ϼ���.!!");
												return;
									   	}
									}   	
							  }					    	
				  
				    }		  	
			  	}
			
			 	if (  toInt(parseDigit(fm.old_opt_amt.value)) >   0  ) { 
							   										
						 if ( toInt(parseDigit(fm.mopt_amt.value))  !=	 toInt(parseDigit(fm.old_opt_amt.value))   ) { 	
						 		alert('�ߵ����Կɼ� ����ݾ����̰� �߻��߽��ϴ�. ó������ �ٽ� �������ֽʽÿ�'); 	fm.cls_dt.focus(); 
						 		fm.opt_amt.value=fm.mopt_amt.value;
						 		fm.cls_st.value="";			 	
						 		return;		 
						 }	
						 
						if (  toInt(fm.r_mon.value)  <  12 ) {		
						  		alert("�ߵ����Կɼ� �ּ��̿�Ⱓ�� 1���̻��Դϴ�..!! ����������� �����ϼ���.!!");
								return;					
						}							
		   		} 	
	   		
		}		
		
		//������ �ִ� ��� �뿩�� ȯ�� -- warning !!!!
		if(toInt(parseDigit(fm.nfee_s_amt.value)) < toInt(parseDigit(fm.mfee_amt.value))){
			if ( toInt(fm.rent_end_dt.value)  < toInt(replaceString("-","",fm.cls_dt.value)) ) {	                
				//�������� 
				if( toInt(parseDigit(fm.rcon_mon.value)) < 1  && toInt(parseDigit(fm.rcon_day.value)) < 1 ){
					alert("!!!!!!!���뿩��� �ߵ���������� ���뿩��(ȯ��)�� Ʋ���ϴ�.!!!!!!\n\n�̳��� �ִ� ��� �ݵ�� �뿩�� ������ Ȯ�� �� �̳��ݾ��� ����Ͽ� ���� �����ϼ���!!!");		
				//	print_view();
				}	
			}
		} 				
					 
		if(confirm('����Ͻðڽ��ϱ�?')){	
			fm.action='lc_cls_est_reg_c_a.jsp';	
			fm.target='d_content';
			fm.submit();
		}				
	}
	
	//���÷��� Ÿ��
	function cls_display(){
		var fm = document.form1;
		
		//tot_dist �ʱ�ȭ 
		fm.tot_dist.value = "0";
		fm.over_amt.value 	=     "0";	
		fm.over_amt_1.value 	=     "0";	
		fm.over_v_amt.value 	=     "0";	
		fm.over_v_amt_1.value 	=     "0";	
				
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );				
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
									
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //���Կɼ� ���ý� ���÷���
		 	
			//�������� ��ุ���� 2������ ��� ���Կɼ� ��� �Ұ� -�ߵ����Կɼ����� ���� 61���̻� ��� 
			if ( count > 61 ) {  
		//	  	alert("�������� ��ุ���� 2���� ������ ��� ���Կɼ��� ����Ҽ� �����ϴ�..!!!");				 
			  	set_day();  
			  	return;				
			}
			
			if(fm.opt_chk.value != '1' ){ //���Կɼ� ���ý� ���÷���		
			  	alert("����� ���Կɼ� ������ �����ϴ�. �̰��� ��� ���Կɼ��� ����Ҽ� �����ϴ�..!!!");
			  	set_day();  
			  	return;				
			}			
		}
																
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //���Կɼ� ���ý� ���÷���
			tr_opt.style.display 		= '';  //���Կɼ�				
			tr_sale.style.display		= '';	//�����Ű�			
		}else{
			tr_opt.style.display 		= 'none';	//���Կɼ�			
			tr_sale.style.display		= 'none';	//�����Ű�		
			tr_cal_sale.style.display		= 'none';	//�ߵ����꼭 				
		}
		 
		fm.est_dt.value= fm.cls_dt.value;	   		
						
		set_init();
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
	   	fm.fdft_amt3.value='0';  //�����Ű�
	 
	   		
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){
			fm.opt_per.value=fm.mopt_per.value;
			fm.opt_amt.value=fm.mopt_amt.value;
								
			//�����Ϻ��� �������ڰ� ���� ��� �����Ϸ� �ٽ� ����
			if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 
					
				set_day_sui(fm.rent_end_dt.value);											
			}			
			set_sui_c_amt();
		}	
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
		
		if(fm.cancel_yn.options[fm.cancel_yn.selectedIndex].value == 'Y'){
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
		
		fm.cls_msg.value = "������Դϴ�. ��� ��ٷ��ֽʽÿ�.!!!";		
		
			//tot_dist �ʱ�ȭ 
		fm.tot_dist.value = "0";
		
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
					
		if(fm.cls_st.value == '8'){ //���Կɼ� ���ý� ���÷���
			
			fm.div_st.value="1";
			fm.est_dt.value= fm.cls_dt.value;				
	
			if(fm.opt_chk.value != '1' ){ //���Կɼ� ���ý� ���÷���		
				tr_opt.style.display 		= 'none';	//���Կɼ�
			  	alert("����� ���Կɼ� ������ �����ϴ�. �̰��� ��� ���Կɼ��� ����Ҽ� �����ϴ�..!!!");
			  	fm.action='./lc_cls_c_nodisplay.jsp';
				fm.cls_st.value="";				
			} else {
			 	if  ( toInt(fm.fee_size.value) < 2 ) {				 //
			  				
					//�������� ��ุ���� 2������ ��� ���Կɼ� ��� �Ұ�
					if ( count > 61 ) { 
				//		alert("�������� ��ุ���� 2���� ������ ��� ���Կɼ��� ����Ҽ� �����ϴ�.!!!!"); 	
						tr_opt.style.display 		= '';	//���Կɼ�
						tr_cal_sale.style.display		= '';	//�ߵ����꼭 				
						fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';										  			
					} else {					
						tr_cal_sale.style.display		= 'none';	//�ߵ����꼭
						if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 							
							fm.dly_c_dt.value=fm.cls_dt.value;								 
					  		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.dly_c_dt.value+'&cls_gubun=Y&cls_dt='+fm.rent_end_dt.value;
					    } else { 
					   		fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';
					    }
					}	
				} else {  //�����̸� 
				//�������� ��ุ���� 1�������� ū��� -�ߵ����Կɼ� ó��
					if ( count > 30 ) { 			
						tr_opt.style.display 		= '';	//���Կɼ�
						tr_cal_sale.style.display		= '';	//�ߵ����꼭 				
						fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';										  			
					} else {					
						tr_cal_sale.style.display		= 'none';	//�ߵ����꼭
						if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //�������� 							
							fm.dly_c_dt.value=fm.cls_dt.value;								 
					  		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.dly_c_dt.value+'&cls_gubun=Y&cls_dt='+fm.rent_end_dt.value;
					    } else { 
					   		fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';
					    }
					}			
				
				}							
				
			} //����� ���Կɼ� 
			
		}else {
		   	fm.action='./lc_cls_c_nodisplay.jsp';		
		}					
				
		fm.target='i_no';
		fm.submit();
	}	
	
		//����� �������ڷ� �ٽ� ���
	function set_day_sui(cls_dt){
		var fm = document.form1;	
					
		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.cls_dt.value+'&cls_gubun=Y&cls_dt='+cls_dt;		
		fm.target='i_no';
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
	    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //������	    		
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
	         set_init();	    // 20161216
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
		
		//���� �ΰ��� ����Ͽ� ���Ѵ�.	 	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt) );		
		/*
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
		}		
		*/
		
	//	if ( fm.tax_chk4.checked == true) {
	//			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
	//	}			
	
		set_cls_s_amt();
	}	
			
	//�̳� �ߵ���������� ���� : �ڵ����
	function set_cls_amt3(obj){
		var fm = document.form1;
	//	obj.value=parseDecimal(obj.value);
		
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //�ܿ��뿩���Ⱓ
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
				fm.tax_supply[0].value 	= fm.dft_amt_1.value;
				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
			}
		}else if(obj == fm.dft_int_1){ //����� �������
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
				fm.tax_supply[0].value 	= fm.dft_amt_1.value;
				fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
			}				
		}
		
		set_cls_s_amt();
	}		
	
	//������Ϻ��(���Կɼ�)
	function set_sui_c_amt(){
		
		var fm = document.form1;
								
		if (fm.cls_st.value  == '8' ) {
		  fm.dft_amt.value = '0'; //�ߵ����������
		  fm.dft_amt_1.value = '0'; //�ߵ����������Ȯ��
		  		  
		  fm.tax_supply[0].value 	= '0';
		  fm.tax_value[0].value 	= '0';	
		}	
		
		fm.div_st.value="1";
		fm.est_dt.value= fm.cls_dt.value;
		set_cls_s_amt();	
	}	
	
							
	//Ȯ���ݾ� ����
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
		
		/*
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
			
	//	}else if(obj == fm.over_amt_1){ //�ʰ�����δ�� ����		 
		}else */
		
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
			} else  { 						
					fm.over_amt.value =  '0';  
					fm.over_amt_1.value =  '0' ;  	
				 	fm.tax_supply[4].value 	= '0';
				 	fm.tax_chk4.value  = 'N' ;
				    fm.tax_value[4].value 	= '0';	
				    fm.over_v_amt.value 	= '0';		 
					fm.over_v_amt_1.value 	= '0';		 
			}		
					  	  							
		}	
											
		var no_v_amt = 0;
		var no_v_amt1 = 0;
			//���� �ΰ��� ����Ͽ� ���Ѵ�.	 
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1) + ( toInt(parseDigit(fm.over_amt.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		fm.rifee_v_amt.value =( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);  //���ô뿩�� 
		fm.rfee_v_amt.value = ( toInt(parseDigit(fm.rfee_s_amt.value)) *0.1);    //������ 
		    
		fm.dfee_v_amt.value =  toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1) ;  //���� �뿩�� �ΰ��� 
		fm.dfee_v_amt_1.value =toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) ;  //Ȯ�� �뿩�� �ΰ��� 
			  			
		fm.over_v_amt.value =  '0';  //���� �ʰ����� �ΰ��� 
		fm.over_v_amt_1.value = ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1);  //Ȯ�� �ʰ����� �ΰ��� 
		
		fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
		
		/*
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
		}		
		*/
		
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
		
	  	fm.dfee_amt.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
		
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.dfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value))  +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))  + toInt(parseDigit(fm.over_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value))  + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value)) + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)));	 //Ȯ���ݾ�	
			
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	 	 	
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
		   	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );					
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );						
	
		} 
			
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );		
	}	
	
		
	//��������û���ܾ�
	function set_gi_amt(){
		var fm = document.form1;
		
		if ( toInt(parseDigit(fm.gi_amt.value))  > 0  ) {
			if ( toInt(parseDigit(fm.fdft_amt2.value))  > 0  ) {
				fm.gi_j_amt.value 		= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.gi_amt.value)));
			}
		}
		if ( toInt(parseDigit(fm.gi_j_amt.value)) < 0  ) {
				fm.gi_j_amt.value  = "0";
		}
		
		//�������� û���� �������� �ݾ׸�ŭ �ڱ�å���� ������.
		fm.est_amt.value  = fm.gi_j_amt.value;  
				
	}	
	
		
	//���ݰ�꼭 check ���� �ΰ��� - �����Ծ׿� �ΰ��� ��ŭ ���Ѵ�(�뿩��, ��å���� ���� (�̹� ��������)) - ���ݰ�꼭 ����Ǹ� �ܻ����ݰ��� 
	function set_vat_amt(obj){
		var fm = document.form1;
			
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
		
		/*
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
			 } 
			 
			 
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
   			 
			 	 
		} */
		
		
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
		} 		
					
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
			
	}
	
	//Ư�̻���  ����
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}	
	
		//�ʰ���������Ÿ�
	function set_over_amt(){
		var fm = document.form1;
		
		var cal_dist  = 0;
		
		if(fm.cls_st.value == '')				{ 
				alert('���������� �����Ͻʽÿ�'); 
				fm.tot_dist.value = "";	
				fm.m_reason.value  = "";
				fm.m_over_amt.value =   "0";	
				fm.m_saction_id.value= "";
				fm.r_over_amt.value 	=     "0";	
				fm.j_over_amt.value 	=     "0";	
				fm.cls_st.focus(); 		
				return;
		}
			
		if ( fm.cls_st.value == '8' ) {  
				fm.t_s_cal_amt.value ='0';
				fm.t_r_fee_s_amt.value = '0';
				fm.t_r_fee_v_amt.value = '0';
				fm.t_r_fee_amt.value = '0';		
				fm.t_cal_days.value = '0';	
				fm.m_saction_id.value= "";
				
		}
		
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
		
		fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
		fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );		  
	
		cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;
		fm.cal_dist.value 		=     parseDecimal( cal_dist   );
		fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     )
	
	//	fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���
	//	fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
		
	
	//����� 20220414 ���ĸ� ȯ��
		if (  <%=base.getRent_dt()%>  > 20220414 ) {  
			// 2022-05 ����  over_dist��  0 ���� ũ�� 1000, 0  ������ -1000 ó�� - �⺻����ó���� 
			if ( -1000 <= toInt(parseDigit(fm.over_dist.value)) &&  toInt(parseDigit(fm.over_dist.value)) <= 1000  ) {
					fm.add_dist.value 		=  '0';  //�⺻����ó�� 
					fm.jung_dist.value 		=  '0';			
			} else {
					// 2022-05 ����  over_dist��  0 ���� ũ�� 1000, 0  ������ -1000 ó�� - �⺻����ó���� 
					if (toInt(parseDigit(fm.over_dist.value)) >= 0  ) {
						fm.add_dist.value 		=     parseDecimal( 1000  );  //�⺻����ó�� 			
					} else {
						fm.add_dist.value 		=     parseDecimal( -1000  );  //�⺻����ó�� 	
					}
					fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) - toInt(parseDigit(fm.add_dist.value))     );
			}
		} else {
			fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���	(�����ΰ�� �����Ⱓ ǥ��)
			fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );					
		}
			
			//�ߵ��ؾ�, ��ุ���� ���
		if ( fm.cls_st.value == '1' || fm.cls_st.value == '2'  ) { 
		       
			if ( (  <%=base.getRent_dt()%>  > 20130604  &&    <%=car1.getAgree_dist()%>  > 0   &&  <%=base.getCar_gu()%>  ==  '1' ) ||    (  <%=base.getRent_dt()%>  > 20140705  &&  <%=base.getCar_gu()%>  ==  '0' )   ) {  
						     
				 // fm.taecha_st_dt ���� �ִٸ� �����Ī - 20210330 ������ ���� �ʰ�����뿩�� �������� ���� - ���� �����Ī�� ��� ������ �ʰ�����δ�� �������� ó�� 
			//	if ( fm.taecha_st_dt.value  != "" )  {			
			//		var s1_str = fm.taecha_st_dt.value; 
			//		var e1_str = fm.cls_dt.value;
			//		var  count1 = 0;
					  
			//		var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );								
			//		var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1,  e1_str.substring(8,10) );	
																	
			//		var days = (e1_date - s1_date) / 1000 / 60 / 60 / 24; 		//1��=24�ð�*60��*60��*1000milliseconds
			//		var mons = (e1_date - s1_date) / 1000 / 60 / 60 / 24 / 30; 	//1��=24�ð�*60��*60��*1000milliseconds
			//	   	cal_dist  =      (    mons * toInt(fm.o_p_m.value)  ) + ( days * toInt(fm.o_p_d.value)  );/
			
			//	          var diff1_date = e1_date.getTime() - s1_date.getTime();
			//	 	count1 = Math.floor(diff1_date/(24*60*60*1000));			
			//		cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  * count1/ 365;
			//	} else {		
										  
			//		cal_dist =   	toInt(parseDigit(fm.agree_dist.value))  * toInt(parseDigit(fm.rent_days.value))   / 365;
					cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;
					
			//		cal_dist  =      (    toInt(fm.r_mon.value) * toInt(fm.o_p_m.value)  ) + (  toInt(fm.r_day.value) * toInt(fm.o_p_d.value)  );				
			//	}         	
								
				fm.cal_dist.value 		=     parseDecimal( Math.round(cal_dist)  );	
			
			//	fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
					
				fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
				fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );		  
				fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     );											
			//	fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���				
			//	fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
				
			//����� 20220414 ���ĸ� ȯ��
				if (  <%=base.getRent_dt()%>  > 20220414 ) {  
					// 2022-05 ����  over_dist��  0 ���� ũ�� 1000, 0  ������ -1000 ó�� - �⺻����ó���� 
					if ( -1000 <= toInt(parseDigit(fm.over_dist.value)) &&  toInt(parseDigit(fm.over_dist.value)) <= 1000  ) {
							fm.add_dist.value 		=  '0';  //�⺻����ó�� 
							fm.jung_dist.value 		=  '0';			
					} else {
							// 2022-05 ����  over_dist��  0 ���� ũ�� 1000, 0  ������ -1000 ó�� - �⺻����ó���� 
							if (toInt(parseDigit(fm.over_dist.value)) >= 0  ) {
								fm.add_dist.value 		=     parseDecimal( 1000  );  //�⺻����ó�� 			
							} else {
								fm.add_dist.value 		=     parseDecimal( -1000  );  //�⺻����ó�� 	
							}
							fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) - toInt(parseDigit(fm.add_dist.value))     );
					}
				} else {
					fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���	(�����ΰ�� �����Ⱓ ǥ��)
					fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );					
				}
						
				//	alert(		toInt(parseDigit(fm.jung_dist.value))  );
				if ( 	toInt(parseDigit(fm.jung_dist.value))   > 0   ) {
					fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );								
					fm.j_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );
					fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
					fm.tax_chk4.value  = 'Y' ;
				    fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );				
				
				}  else if ( toInt(parseDigit(fm.jung_dist.value))  == 0   ) {
				    
					fm.r_over_amt.value 	=      "0";				
					fm.j_over_amt.value 	=     "0";	
					fm.tax_supply[4].value 	=  '0';					 
					fm.tax_value[4].value 	=  '0';		
					fm.tax_chk4.value  = 'N' ;					
				}  else  {	
				
				    fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.rtn_run_amt.value)   );								
					fm.j_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.rtn_run_amt.value)   );
					fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
					fm.tax_chk4.value  = 'Y' ;
				    fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );		
				
			 	}								
			}		
		} //��ุ��, �ߵ����� 
				
		//���Կɼ��� ��� - 50% ������ ��츸 �ش�  (�Ϲݽ�, �⺻���� 100%���� )  : 202204���� 40% ���� �Ǵ� ȯ��
		if ( fm.cls_st.value == '8'   &&  (  fm.agree_yn.value == '2'  ||  fm.agree_yn.value == '3' )  ) { 
		  		   	     
			if ( (  <%=base.getRent_dt()%>  > 20130604  &&    <%=car1.getAgree_dist()%>  > 0   &&  <%=base.getCar_gu()%>  ==  '1' ) ||    (  <%=base.getRent_dt()%>  > 20140705  &&  <%=base.getCar_gu()%>  ==  '0' )   ) {  
			
				 // fm.taecha_st_dt ���� �ִٸ� �����Ī - 20210330 ������ ���� �ʰ�����뿩�� �������� ���� - ���� �����Ī�� ��� ������ �ʰ�����δ�� �������� ó�� 
			//	if ( fm.taecha_st_dt.value  != "" )  {			
			//		var s1_str = fm.taecha_st_dt.value; 
			//		var e1_str = fm.cls_dt.value;
			//		var  count1 = 0;
					  
			//		var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );								
			//		var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1,  e1_str.substring(8,10) );	
																	
			//		var days = (e1_date - s1_date) / 1000 / 60 / 60 / 24; 		//1��=24�ð�*60��*60��*1000milliseconds
			//		var mons = (e1_date - s1_date) / 1000 / 60 / 60 / 24 / 30; 	//1��=24�ð�*60��*60��*1000milliseconds
			//	         	cal_dist  =      (    mons * toInt(fm.o_p_m.value)  ) + ( days * toInt(fm.o_p_d.value)  );/
			
			//	   var diff1_date = e1_date.getTime() - s1_date.getTime();
			//	 	count1 = Math.floor(diff1_date/(24*60*60*1000));
			//		cal_dist =   	toInt(fm.agree_dist.value) * count1/ 365;
			//	} else {				  
				//	cal_dist =   	toInt(parseDigit(fm.agree_dist.value))  * toInt(parseDigit(fm.rent_days.value))   / 365;
					cal_dist =   	 Math.floor(parseDigit(fm.agree_dist.value))  *Math.floor(parseDigit(fm.rent_days.value))   / 365;
			//		cal_dist  =      (    toInt(fm.r_mon.value) * toInt(fm.o_p_m.value)  ) + (  toInt(fm.r_day.value) * toInt(fm.o_p_d.value)  );				
			//	}         	
				
				fm.cal_dist.value 		=     parseDecimal( cal_dist   );	
			
			//	fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
					
				fm.last_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value))   );	
				fm.real_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.tot_dist.value)) -   toInt(parseDigit(fm.first_dist.value))     );		  
				fm.over_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.real_dist.value)) -   toInt(parseDigit(fm.cal_dist.value))     );								
			//	fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���
			//	fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );
				
			  	if (  <%=base.getRent_dt()%>  > 20220414 ) {  //����� 20220414 ���ĸ� ȯ��
					if ( -1000 <= toInt(parseDigit(fm.over_dist.value)) &&  toInt(parseDigit(fm.over_dist.value)) <= 1000  ) {
						fm.add_dist.value 		=  '0';  //�⺻����ó�� 
						fm.jung_dist.value 		=  '0';			
					} else {
						// 2022-05 ����  over_dist��  0 ���� ũ�� 1000, 0  ������ -1000 ó�� - �⺻����ó���� 
						if (toInt(parseDigit(fm.over_dist.value)) >= 0  ) {
							fm.add_dist.value 		=     parseDecimal( 1000  );  //�⺻����ó�� 			
						} else {
							fm.add_dist.value 		=     parseDecimal( -1000  );  //�⺻����ó�� 	
						}
						fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) - toInt(parseDigit(fm.add_dist.value))     );
					}
			    } else {
			    	fm.add_dist.value 		=     parseDecimal( 1000  );  //��񽺸��ϸ���	(�����ΰ�� �����Ⱓ ǥ��)
					fm.jung_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.over_dist.value)) -   toInt(parseDigit(fm.add_dist.value))     );	
			    }
			  
								
				//�⺻�� 100% ����,  //�Ϲݽĸ� ��� 
				<%    if ( fee.getRent_way().equals("1") )  { %>
							
					   if ( toInt(parseDigit(fm.jung_dist.value))   > 0   ) {
					   		
							fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );
							
							if (  <%=base.getRent_dt()%>  > 20220414 ) {
								fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.6 );	
								fm.m_reason.value        =   "���Կɼ� 60% ����";
							} else {
								fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.5 );	
								fm.m_reason.value       =   "���Կɼ� 50% ����";
							}
							
							fm.j_over_amt.value 	=      parseDecimal(  toInt(parseDigit(fm.r_over_amt.value)) -   toInt(parseDigit(fm.m_over_amt.value))    );	 //����
						
							fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
							fm.tax_chk4.value  = 'Y' ;
						    fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );				
						
						}  else if ( toInt(parseDigit(fm.jung_dist.value))  == 0   ) {				    
							fm.r_over_amt.value 	=      "0";				
							fm.j_over_amt.value 	=     "0";	
							fm.tax_supply[4].value 	=  '0';					 
							fm.tax_value[4].value 	=  '0';		
							fm.tax_chk4.value  = 'N' ;					
						}  else  {	
							
							if (  <%=base.getRent_dt()%>  > 20220414 ) {  //����� 20220414 ���ĸ� ȯ��
								fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.rtn_run_amt.value)   );				
								fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.6  );	
								fm.m_reason.value       =   "���Կɼ� 40% ȯ��";	
								fm.j_over_amt.value 	=      parseDecimal(  toInt(parseDigit(fm.r_over_amt.value)) -   toInt(parseDigit(fm.m_over_amt.value))   );	 //ȯ��
														
								fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
								fm.tax_chk4.value  = 'Y' ;
							    fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );		
							} else {
								fm.r_over_amt.value 	=      "0";				
								fm.j_over_amt.value 	=     "0";	
								fm.tax_supply[4].value 	=  '0';					 
								fm.tax_value[4].value 	=  '0';		
								fm.tax_chk4.value  = 'N' ;			
								
							}     
							
						}
							
					 	/*
						if ( 	toInt(parseDigit(fm.jung_dist.value))   > 0   &&  fm.agree_yn.value == '2'   ) {
						
							fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );	
							fm.m_over_amt.value 	=     parseDecimal(   toInt(parseDigit(fm.r_over_amt.value)) * 0.5 );	
							fm.j_over_amt.value 	=      parseDecimal(  toInt(parseDigit(fm.r_over_amt.value)) -   toInt(parseDigit(fm.m_over_amt.value))     );	 //����
							fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
							fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );	
						
							fm.tax_chk4.value  = 'Y' ;
							fm.m_reason.value            =   "���Կɼ� 50% ����";
							
						} else {
							fm.r_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );	
											
							fm.j_over_amt.value 	=     parseDecimal(    toInt(parseDigit(fm.jung_dist.value)) * toInt(fm.over_run_amt.value)   );		
						
							fm.tax_supply[4].value 	=  fm.j_over_amt.value;			
							fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.j_over_amt.value)) * 0.1 );		
						
							fm.tax_chk4.value  = 'Y' ;	
								
					 	} */
					 
				<% } %>
							 	
			 	/*if ( 	toInt(parseDigit(fm.jung_dist.value))   < 0 ) {
			 		fm.r_over_amt.value 	=      "0";
				
					fm.j_over_amt.value 	=     "0";	
					fm.m_over_amt.value 	=     "0";	
					fm.tax_supply[4].value 	=  '0';		
					fm.tax_value[4].value 	= '0';											
					fm.tax_chk4.value  = 'N' ;
					fm.m_reason.value            =  "";					
			   }      		*/
			   
			}
		}
									
		fm.over_amt.value 		    = '0';
		fm.over_amt_1.value 		    = parseDecimal( toInt(parseDigit(fm.j_over_amt.value)));			
		
		var no_v_amt = 0;
		var no_v_amt1 = 0;
		var   c_pp_s_amt = 0;
		var   c_rfee_s_amt = 0;
		var   c_over_s_amt = 0;
		
		c_pp_s_amt = toInt(parseDigit(fm.rfee_s_amt.value))*0.1;
		c_rfee_s_amt = toInt(parseDigit(fm.rifee_s_amt.value)) *0.1;
		c_over_s_amt = toInt(parseDigit(fm.over_amt_1.value)) *0.1;
					
		var c_fee_v_amt =  0;
		var c_fee_v_amt1 =  0;
		c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt.value)) * 0.1)) ;
		c_fee_v_amt1 = Math.round((toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)) ;
		
		// �ΰ��� ���߱� - 20190904 - �ܾ��� �ƴ� �̳��ݾ��� ���ٸ� (��ȸ���� ���)
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {
	    	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));		 
	    	c_fee_v_amt1  = toInt(parseDigit(fm.nnfee_v_amt.value));		 
 	    }	
		
			//���Կɼ��� ���� Ʋ��.
		if ( fm.cls_st.value == '8') { //���Կɼ� 		
			    //����� 0
			  fm.dft_amt.value 			= '0';
			  fm.dft_amt_1.value 	   = '0';			  		  
	   }
		 
		//���� �ΰ��� ����Ͽ� ���Ѵ�.	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt   -  c_pp_s_amt  - c_rfee_s_amt ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1  + c_over_s_amt -  c_pp_s_amt  - c_rfee_s_amt ;
						
		fm.rifee_v_amt.value = c_rfee_s_amt;  //���ô뿩�� 
		fm.rfee_v_amt.value = c_pp_s_amt;    //������ 
		    
		fm.dfee_v_amt.value =  toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt;  //���� �뿩�� �ΰ��� 
		fm.dfee_v_amt_1.value =toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt1;  //Ȯ�� �뿩�� �ΰ��� 
			    
		fm.over_v_amt.value =  '0';  //���� �ʰ����� �ΰ��� 
		fm.over_v_amt_1.value = c_over_s_amt;  //Ȯ�� �ʰ����� �ΰ��� 
					
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
	
		/*
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
		} */
		
		/*
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}				
		*/	
		
		set_cls_s_amt();				
	}	
		
	//�ߵ������ �ݾ׼���  - �����ΰ�� ���ԿɼǱݾ��� ����.- 20161117
	function cal_rc_rest(){
		var fm = document.form1;
		
		 fm.dft_amt.value = '0'; //�ߵ����������
		 fm.dft_amt_1.value = '0'; //�ߵ����������Ȯ��
		 fm.mt.value ='0' ;  
		 	
		var scd_size 	= toInt(fm.vt_size8.value);	
	    var a_f = fm.a_f.value;
	       
		var e_str = fm.cls_dt.value;
		var s_str ;
		var diff_date ;
		var count=0;
				
		var s_date = "";
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
		
		var s_rc_rate;	
		var t_cal_days = 0;				
						
		//������ �ƴѰ�츸 �ش�� - �����ΰ��� �����ϱ��� �뿩�Ḹ ����� 				
			   
		for(var i = 0 ; i < scd_size ; i ++){
		
				s_str = fm.s_r_fee_est_dt[i].value; // �����ҳ�¥ 
				s_date =  new Date (s_str.substring(0,4), s_str.substring(5,7) -1 , s_str.substring(8,10) ); 
										
				diff_date = s_date.getTime() - e_date.getTime();
			    count = Math.floor(diff_date/(24*60*60*1000));					
				
				fm.s_cal_days[i].value = parseDecimal(count);			//�����ϴ�� ����ϼ�
				
				if  ( toInt(fm.fee_size.value) < 2 ) 	{		
				
					 fm.mt.value ='1' ;
						   
						  	//������  ����ȿ�� ��� - ����ϼ��� 30�Ϻ��� ���� ���� �ݾ� /30 * ����ϼ��� ��� ( 0���� ���� ���� 0���� )								
			         var cc_grt_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_grt_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_grt_amt.value)) );
			         cc_grt_amt = ( cc_grt_amt < 0 ? 0 : cc_grt_amt );
			            
			          //������ȸ���ΰ��� ������ ����*�뿩��/���뿩�� 
			         if ( i == scd_size - 1 ) 	cc_grt_amt =   toInt(parseDigit(fm.e_grt_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ;
			                  
			          fm.s_grt_amt[i].value = parseDecimal(cc_grt_amt) ;     
				
						//�ڵ�����, �����, ������ ���ϱ� - ����ϼ��� 30�Ϻ��� ���� ���� �ݾ� /30 * ����ϼ��� ��� ( 0���� ���� ���� 0���� )								
			         var cc_tax_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_tax_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_tax_amt.value)) );
			         cc_tax_amt = ( cc_tax_amt < 0 ? 0 : cc_tax_amt );
			         
			         	//������ȸ���ΰ��� ������ ����*�뿩��/���뿩�� 
			         if ( i == scd_size - 1 ) 	cc_tax_amt =   toInt(parseDigit(fm.e_tax_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ;
			                  
				         fm.s_tax_amt[i].value = parseDecimal(cc_tax_amt) ;  
				              
				         var cc_insur_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_insur_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_insur_amt.value)) );
				         cc_insur_amt = ( cc_insur_amt < 0 ? 0 : cc_insur_amt );         
				         	//������ȸ���ΰ��� ������ ������*�뿩��/���뿩�� 
				          if ( i == scd_size - 1 ) 	 cc_insur_amt =  toInt(parseDigit(fm.e_insur_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ; 	
				         	
				         var cc_serv_amt = ( toInt(parseDigit(fm.s_cal_days[i].value)) <30  ? toInt(parseDigit(fm.e_serv_amt.value))/30 * toInt(parseDigit(fm.s_cal_days[i].value))    :  toInt(parseDigit(fm.e_serv_amt.value)) );
				         cc_serv_amt = ( cc_serv_amt < 0 ? 0 : cc_serv_amt );           
				         	//������ȸ���ΰ��� ������ ����*�뿩��/���뿩�� 
				         	  if ( i == scd_size - 1 ) 	cc_serv_amt =  toInt(parseDigit(fm.e_serv_amt.value)) *    toInt(parseDigit(fm.s_fee_s_amt[i].value))    /   toInt(parseDigit(fm.fee_s_amt.value)) ;
				         	    
				         var cc_is_amt ;
				                  
				         //�Ϲݽ��ΰ�� ������ �߰�
				   <%     if ( fee.getRent_way().equals("1") )  { %>
				         		 cc_is_amt  = cc_insur_amt + cc_serv_amt;
				     <%    } else {  %>
				         		  cc_is_amt  = cc_insur_amt ;
				    <%     }  %>
				    
				         fm.s_is_amt[i].value = parseDecimal(cc_is_amt) ;
				         
				              //������ ����ȿ�� �ݿ�         
			 			  fm.s_g_fee_amt[i].value =    parseDecimal( toInt(parseDigit(fm.s_fee_s_amt[i].value))   +   toInt(parseDigit(fm.s_grt_amt[i].value))  ) ;
				
						  fm.s_cal_amt[i].value =    parseDecimal( toInt(parseDigit(fm.s_g_fee_amt[i].value))   -   toInt(parseDigit(fm.s_tax_amt[i].value))  -   toInt(parseDigit(fm.s_is_amt[i].value)) ) ;
						     
				 //        fm.s_cal_amt[i].value =    parseDecimal( toInt(parseDigit(fm.s_fee_s_amt[i].value))   -   toInt(parseDigit(fm.s_tax_amt[i].value))  -   toInt(parseDigit(fm.s_is_amt[i].value)) ) ;
					      						      
					      s_rc_rate =  (1/ Math.pow(  1+a_f/100/12, count/365*12) ).toFixed(5);
					    
				     	  fm.s_rc_rate[i].value = s_rc_rate;
				     	  
				     	  if ( s_rc_rate > 1) {  //�̳��� ���� �뿩�� 
					     		fm.s_r_fee_s_amt[i].value = parseDecimal(toInt(parseDigit(fm.s_cal_amt[i].value)) * 1) ;
					      } else {
					     		 fm.s_r_fee_s_amt[i].value = parseDecimal(toInt(parseDigit(fm.s_cal_amt[i].value)) *s_rc_rate) ;
					      }
				     	 				        	  	        		
				   //   	  fm.s_r_fee_s_amt[i].value = parseDecimal(toInt(parseDigit(fm.s_cal_amt[i].value)) *s_rc_rate) ;
				      	  fm.s_r_fee_v_amt[i].value =  parseDecimal(toInt(parseDigit(fm.s_r_fee_s_amt[i].value))    * 0.1 )  ;
				      		
				      	  fm.s_r_fee_amt[i].value =  parseDecimal(  toInt(parseDigit(fm.s_r_fee_s_amt[i].value) ) +   toInt(parseDigit(fm.s_r_fee_v_amt[i].value)) ) ;   
			
				} else {
					s_rc_rate = 1;  //���簡ġ �� 1 ( ������ ���)				
				}		
				
		}							
		
		   //���Կɼ� ���簡ġ 
		 fm.cls_cau.value = "�ߵ����Կɼ�,  ����  ���ԿɼǺ��:" +  parseDecimal( toInt(parseDigit(fm.opt_amt.value)) ) ;
		 fm.old_opt_amt.value =  toInt(parseDigit(fm.opt_amt.value)) ;    
		 
		 //�����ΰ��� ���������ԿɼǱݾ��� �ݿ��Ͽ� �ٽ� ����ؾ� ��. - 20161117
		 var recal_opt_amt;
		 	 		 
		 var e1_end_str  = fm.fee_size_1_end_dt.value; //������ ���� ������
		 var e_end_str  = 	 fm.s_opt_end_dt.value;   //������ ������ 
		 
		 var e1_end_date = "";
		var e_end_date = "";
		
		var diff1_date ;
		var diff2_date ;
		var count1=0;
		var count2=0;
				
		var s_rc_rate;	
		
		e1_end_date =  new Date (e1_end_str.substring(0,4), e1_end_str.substring(4,6) -1 , e1_end_str.substring(6,8) );  //���� -1 ������ 
		e_end_date =  new Date (e_end_str.substring(0,4), e_end_str.substring(4,6) -1 , e_end_str.substring(6,8) );   //���常���� 
				
		diff1_date = e_date.getTime() - e1_end_date.getTime();
		count1 = Math.floor(diff1_date/(24*60*60*1000));					
		
		diff2_date = e_end_date.getTime() - e1_end_date.getTime();
	    count2 = Math.floor(diff2_date/(24*60*60*1000));			
			 
		if  ( toInt(fm.fee_size.value) < 2 ) { //������ �ƴϸ� 
		} else {			
			recal_opt_amt =   toInt(parseDigit(fm.fee_size_1_opt_amt.value))  - ( ( toInt(parseDigit(fm.fee_size_1_opt_amt.value))  -  toInt(parseDigit(fm.opt_amt.value)) ) *  count1 / count2   ) ; 
	//	  alert(recal_opt_amt);
			 fm.opt_amt.value = parseDecimal(recal_opt_amt);	
			 fm.mt.value ='2' ;		
			 fm.count1.value =count1 ;
			 fm.count2.value =count2 ;
		}
				 		 	
		 fm.opt_amt.value =  parseDecimal( toInt(parseDigit(fm.opt_amt.value)) * s_rc_rate) ;    			
	     fm.rc_rate.value = s_rc_rate;
		   //���Կɼ� ���簡ġ 
	    if  ( toInt(fm.fee_size.value) < 2 ) { //������ �ƴϸ� 
	    	 fm.cls_cau.value = "�ߵ����Կɼ�,  ����  ���ԿɼǺ��:" +  parseDecimal( toInt(parseDigit(fm.old_opt_amt.value)) ) + " , ���Կɼ�����ġ: " +  parseDecimal( toInt(parseDigit(fm.opt_amt.value)) )  ;
	    }
		   
		 if ( toInt(parseDigit(fm.mopt_amt.value))  !=	 toInt(parseDigit(fm.old_opt_amt.value))   ) { 	
		 		alert('�ߵ����Կɼ� ����ݾ����̰� �߻��߽��ϴ�. ó������ �ٽ� �������ֽʽÿ�'); 	fm.cls_dt.focus(); 
		 		fm.cls_st.value = "";
		 		fm.opt_amt.value=fm.mopt_amt.value;		 
		 		fm.t_s_cal_amt.value ='0';
				fm.t_s_grt_amt.value ='0';
		 		fm.t_s_g_fee_amt.value ='0';
				fm.t_r_fee_s_amt.value = '0';
				fm.t_r_fee_v_amt.value = '0';
				fm.t_r_fee_amt.value = '0';		
				fm.t_cal_days.value = '0';		
		 		return;	
		 
		 }
		
		for(var i = 0 ; i < scd_size ; i ++){
			t_cal_days 	= t_cal_days + toInt(parseDigit(fm.s_cal_days[i].value));							
		}
		fm.t_cal_days.value = parseDecimal(t_cal_days);  //�Ѱ���ϼ���� 
		 	 			 	
		//�հ�� ǥ�� 
		if  ( toInt(fm.fee_size.value) < 2 ) {					
			 cal_tot_set();
		} 			
		
		 set_cls_s_amt()	; //�ݾ����� 		 		
	}
		
	//�ߵ������ �ݾ׼��� 
	function cal_rc_rest_clear(){
		var fm = document.form1;
		
		 fm.dft_amt.value = '0'; //�ߵ����������
		 fm.dft_amt_1.value = '0'; //�ߵ����������Ȯ��
		 fm.mt.value= '0'; // ���Կɼ� Ÿ��
			
		var scd_size 	= toInt(fm.vt_size8.value);	
	    var a_f = fm.a_f.value;
	       
		var e_str = fm.cls_dt.value;
		var s_str ;
		var diff_date ;
		var count=0;
				
		var s_date = "";
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
		
		var s_rc_rate;	
						
		for(var i = 0 ; i < scd_size ; i ++){

		   s_str = fm.s_r_fee_est_dt[i].value; // �����ҳ�¥ 
		   s_date =  new Date (s_str.substring(0,4), s_str.substring(5,7) -1 , s_str.substring(8,10) ); 
									
		   diff_date = s_date.getTime() - e_date.getTime();
		   count = Math.floor(diff_date/(24*60*60*1000));					
			
		   fm.s_cal_days[i].value = '0';			//�����ϴ�� ����ϼ�
			
		   fm.s_grt_amt[i].value ='0';  
		   fm.s_g_fee_amt[i].value ='0';  
		   fm.s_tax_amt[i].value ='0';  
		   fm.s_cal_amt[i].value ='0';  
		   fm.s_r_fee_s_amt[i].value ='0';  
		   fm.s_r_fee_v_amt[i].value ='0';  
		   fm.s_r_fee_amt[i].value ='0';  
       }
       
      	fm.t_s_grt_amt.value = '0';
      	fm.t_s_g_fee_amt.value = '0';
      	fm.t_s_cal_amt.value = '0';
		fm.t_r_fee_s_amt.value = '0';
		fm.t_r_fee_v_amt.value = '0';
		fm.t_r_fee_amt.value = '0'; 
		fm.t_cal_days.value = '0';		
   }      	
	
	function cal_tot_set(){
		var fm = document.form1;
	
		var t_s_grt_amt = 0;
		var t_s_g_fee_amt = 0;
		var t_s_cal_amt = 0;
		var t_r_fee_s_amt = 0;
		var t_r_fee_v_amt = 0;
		var t_r_fee_amt = 0;
		
		var m_r_fee_s_amt = 0;
		var m_r_fee_v_amt = 0;
		var m_r_fee_amt = 0;
		
		var recal_opt_amt;
		
		var scd_size 	= toInt(fm.vt_size8.value);	
				
		for(var i = 0 ; i < scd_size ; i ++){
			
			t_s_grt_amt 	= t_s_grt_amt + toInt(parseDigit(fm.s_grt_amt[i].value));	
			t_s_g_fee_amt 	= t_s_g_fee_amt + toInt(parseDigit(fm.s_g_fee_amt[i].value));	
			t_s_cal_amt 	= t_s_cal_amt + toInt(parseDigit(fm.s_cal_amt[i].value));		
			t_r_fee_s_amt = t_r_fee_s_amt + toInt(parseDigit(fm.s_r_fee_s_amt[i].value));			
			t_r_fee_v_amt = t_r_fee_v_amt + toInt(parseDigit(fm.s_r_fee_v_amt[i].value));			
			t_r_fee_amt 	= t_r_fee_amt + toInt(parseDigit(fm.s_r_fee_amt[i].value));			
		
		}

		fm.t_s_grt_amt.value = parseDecimal(t_s_grt_amt);
		fm.t_s_g_fee_amt.value = parseDecimal(t_s_g_fee_amt);
		fm.t_s_cal_amt.value = parseDecimal(t_s_cal_amt);
		fm.t_r_fee_s_amt.value = parseDecimal(t_r_fee_s_amt);
		fm.t_r_fee_v_amt.value = parseDecimal(t_r_fee_v_amt);
		fm.t_r_fee_amt.value = parseDecimal(t_r_fee_amt);	
	  
		//�̷��뿩�Ḹ ��� - ���簡ġ�� �Ǵ�   
	   for(var i = 0 ; i < scd_size ; i ++){
			
		   if ( toInt(parseDigit(fm.s_rc_rate[i].value)) < 1 ) {
				m_r_fee_s_amt = m_r_fee_s_amt + toInt(parseDigit(fm.s_r_fee_s_amt[i].value));			
				m_r_fee_v_amt = m_r_fee_v_amt + toInt(parseDigit(fm.s_r_fee_v_amt[i].value));			
				m_r_fee_amt 	= m_r_fee_amt + toInt(parseDigit(fm.s_r_fee_amt[i].value));		
				
		   }	
		}
		   
	   //���ԿɼǱݾ׿� �뿩�� ������ �� 
	   recal_opt_amt =  toInt(parseDigit(fm.opt_amt.value)) +   m_r_fee_amt; 
	   fm.m_r_fee_amt.value = m_r_fee_amt;  //�ߵ����Կɼǿ� ���Ե� �뿩��
	
	   fm.opt_amt.value = parseDecimal(recal_opt_amt);	
					   
		//�뿩�Ḧ ���Ȱ����� ���� 		- Ȯ���� 
	//	 fm.ex_di_v_amt.value = '0'; //������
	//	 fm.ex_di_amt.value = '0'; //������		 
		 fm.ex_di_v_amt_1.value = '0'; //������
		 fm.ex_di_amt_1.value = '0'; //������
		 
		 fm.nfee_mon.value = '0'; // �̳��Ⱓ
		 fm.nfee_day.value = '0'; //�̳��Ⱓ
			 
	// ���簡ġ �뿩��..
	//	 fm.nfee_amt.value =  parseDecimal(toInt(parseDigit(fm.t_r_fee_s_amt.value))  -  m_r_fee_s_amt); 
		 fm.nfee_amt_1.value =  parseDecimal(toInt(parseDigit(fm.t_r_fee_s_amt.value))  -  m_r_fee_s_amt); 

		 var no_v_amt = 0;		
		
		//���� �ΰ��� ����Ͽ� ���Ѵ�.
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  + ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		if ( fm.mt.value == '1' ) {
	   	   
	         if (   Math.abs(toInt(parseDigit(fm.t_r_fee_v_amt.value)) - no_v_amt) < 100  ) {
					no_v_amt =   toInt(parseDigit(fm.t_r_fee_v_amt.value));						 					 						 		
			 } 				
	   } 
	  	
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt) );	
		
		/*
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
		}		
		*/
		
		/*
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}				
		*/
			
		set_cls_s_amt();		 
		
	}	
	
		//�뿩�� ������ �μ�ȭ��
	function print_view(mode)
	{
		var fm = document.form1;
		var m_id = fm.rent_mng_id.value;
		var l_cd = fm.rent_l_cd.value;
		var b_dt=  fm.b_dt.value;
		var cls_chk;
	    var mode;
	  	     
		window.open("/fms2/con_fee/fee_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk+"&mode="+mode, "PRINT_VIEW", "left=50, top=50, width=770, height=640, scrollbars=yes");
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
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FEE_S_AMT")))%>'>
<input type='hidden' name='pp_s_amt' value='<%=base1.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base1.get("IFEE_S_AMT")%>'>
<input type='hidden' name='fee_s_amt' value='<%=base1.get("FEE_S_AMT")%>'>
  
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 

<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'> 

<input type='hidden' name='r_con_mon' value='<%=base1.get("R_CON_MON")%>'> <!--�����ϱ��� ������Ⱓ -->

<input type='hidden' name='bank_code2' 	value=''>
<input type='hidden' name='deposit_no2' 	value=''>
<input type='hidden' name='bank_name' 	value=''>  
 
<input type='hidden' name='cls_s_amt' value='' >
<input type='hidden' name='cls_v_amt' value='' >
<input type='hidden' name='car_ja_no_amt' value='<%=car_ja_no_amt%>' >
<input type='hidden' name='opt_chk' value='<%=ext_fee.getOpt_chk()%>'>

<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>'>
<input type='hidden' name='nnfee_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_V_AMT")))%>'>
<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_AMT")))%>'> <!--�������� ��ü���뿩�� -�ܾ� -->

<input type='hidden' name='s_mon' value='<%=base1.get("S_MON")%>'>
<input type='hidden' name='s_day' value='<%=base1.get("S_DAY")%>'> 

<!-- <input type='hidden' name='m_mon' value='<%=base1.get("M_MON")%>'> -->
<!-- <input type='hidden' name='m_day' value='<%=base1.get("M_DAY")%>'> -->

<input type='hidden' name='hs_mon' value='<%=base1.get("HS_MON")%>'>  <!-- �ܾ������� �̳����� -->
<input type='hidden' name='hs_day' value='<%=base1.get("HS_DAY")%>'> <!-- �ܾ������� �̳����� -->

<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_S_AMT")))%>'> <!--�������� �����뿩�� -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_V_AMT")))%>'>  
<input type='hidden' name='di_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'>  

<input type='hidden' name='dly_c_dt' value='' >

<input type='hidden' name='reg_cnt' value='<%=reg_cnt%>'> <!-- ���Ͽ��� -->

<input type='hidden' name='lfee_mon' value='<%=base1.get("LFEE_MON")%>'> <!--�뿩������ -->
 
   <!--�ʰ����� �Ÿ� ��� -->
<input type='hidden' name='agree_dist' value='<%=car1.getAgree_dist()%>'>
<input type='hidden' name='over_run_amt' value='<%=car1.getOver_run_amt()%>'>
<input type='hidden' name='over_run_day' value='<%=car1.getOver_run_day()%>'>
 <input type='hidden' name='agree_yn' value='<%=car1.getAgree_dist_yn()%>'>
  
<input type='hidden' name='rc_s_amt' value='<%=base1.get("RC_S_AMT")%>'> <!--���� �ݾ� --> 
<input type='hidden' name='rc_v_amt' value='<%=base1.get("RC_V_AMT")%>'> <!-- ���� �ݾ� --> 
<input type='hidden' name='rr_s_amt' value='<%=base1.get("RR_S_AMT")%>'> <!-- ���� �ݾ� --> 
<input type='hidden' name='rr_v_amt' value='<%=base1.get("RR_V_AMT")%>'> <!-- ���� �ݾ� --> 
<input type='hidden' name='rr_amt' value='<%=base1.get("RR_AMT")%>'> <!-- ���� �ݾ� --> 

           
<input type='hidden' name='a_f' value='<%=em_bean.getA_f()%>'>  <!-- ������ --> 

<input type='hidden' name='vt_size8' value='<%=vt_size8%>' >  <!--�ߵ������ �̳������� -->

<input type='hidden' name='e_grt_amt' value='<%=e_grt_amt%>' >
<input type='hidden' name='e_tax_amt' value='<%=AddUtil.parseInt((String)sale.get("TAX_AMT"))%>' >
<input type='hidden' name='e_insur_amt' value='<%=AddUtil.parseInt((String)sale.get("INSUR_AMT"))%>' >
<input type='hidden' name='e_serv_amt' value='<%=AddUtil.parseInt((String)sale.get("SERV_AMT"))%>' >

<input type='hidden' name='mt'  value='0' >  <!-- ���Կɼ�Ÿ��  0:����, 1:�ߵ����� 2:�����ߵ����� --> 
<input type='hidden' name='b_dt' size='10' value='<%=Util.getDate()%>' >
<input type='hidden' name='taecha_st_dt' value='<%=taecha.getCar_rent_st()%>'><!--���� ������ -->
<input type='hidden' name='taecha_et_dt' value='<%=taecha.getCar_rent_et()%>'><!--���� ������ -->

<input type='hidden' name='rc_rate'  value=''  >  <!-- ���Կɼ�Ÿ��  ���簡ġ�� --> 
<input type='hidden' name='count1' value='' >   
<input type='hidden' name='count2' value='' >  
<input type='hidden' name='m_r_fee_amt' value=''>  <!--  �ߵ����Կɼǽ� �뿩�� �ݿ��� -->

<input type='hidden' name='rifee_v_amt' value=''> <!-- �ΰ��� ����  -->
<input type='hidden' name='rfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt' value=''>
<input type='hidden' name='dfee_v_amt_1' value=''>
<input type='hidden' name='over_v_amt' value=''>
<input type='hidden' name='over_v_amt_1' value=''>

<input type='hidden' name='today_dt' value='<%=AddUtil.getDate(4)%>'>
 
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
            <td class=title width=13%>����ȣ</td>
            <td width=24%>&nbsp;<%=rent_l_cd%>&nbsp;&nbsp;<a href="javascript:view_cng_etc('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='Ư�̻���'><img src=/acar/images/center/button_tish.gif align=absmiddle border=0></a>
               &nbsp;<a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='��ĵ����'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>
             &nbsp;<a href="javascript:print_view('');" title='�⺻' onMouseOver="window.status=''; return true">[������]</a>
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
            <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>���ͳ�<%}else if(bus_st.equals("2")){%>�������<%}else if(bus_st.equals("3")){%>��ü�Ұ�<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>��ȭ���<%}else if(bus_st.equals("6")){%>������ü<%}else if(bus_st.equals("7")){%>������Ʈ<%}else if(bus_st.equals("8")){%>�����<%}%></td>
          </tr>
          <tr> 
            <td class=title>��������</td>
            <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>�縮��<%}else if(car_gu.equals("1")){%>����<%}else if(car_gu.equals("2")){%>�߰���<%}%></td>
            <td class=title>�뵵����</td>
            <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>��Ʈ<%}else if(car_st.equals("2")){%>����<%}else if(car_st.equals("3")){%>����<%}else if(car_st.equals("5")){%>�����뿩<%}%></td>
            <td class=title>��������</td>
            <td>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>�Ϲݽ�<%}else if(rent_way.equals("3")){%>�⺻��<%}%></td>
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
            <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=cr_bean.getCar_no()%></a></td>
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
            <td style="font-size : 9pt;" width="6%" class=title rowspan="2">���Ⱓ</td>
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
				
			//	s_opt_per = fees.getOpt_per(); // ��������� ���� 
				s_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
				s_opt_s_amt = fees.getOpt_s_amt();
				s_opt_end_dt= fees.getRent_end_dt();
				
			   f_opt_per  = (float) s_opt_amt  / car_price * 100 ;
			   			 			   
			   f_opt_per =  AddUtil.parseFloatCipher(f_opt_per,1);
			   			   	   			   
			   //  fee_size - 1�ΰ� (�����ΰ�쿡 ���ؼ� ) 
			   if ( fee_size_1 > 0 ) {
			        if ( i+1 == fee_size_1 ) { 
						      fee_size_1_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
			   					fee_size_1_end_dt= fees.getRent_end_dt();
   					}   
			   }
				
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
            <td style="font-size : 9pt;" align="center"><%=f_opt_per%></td>
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
			       <option value="1">��ุ��</option>             
                <option value="2">�ߵ��ؾ�</option>            
                <option value="8">���Կɼ�</option>   
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
		       <input type='text' name='r_mon' class='text' size='2' readonly  value='<%=base1.get("R_MON")%>' >����&nbsp;<input type='text' name='r_day' size='2' class='text' value='<%=base1.get("R_DAY")%>' onBlur='javascript:set_cls_amt1(this);'>��&nbsp;</td>
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
                  <option value="Y" selected>�������</option>
                  <option value="N">��������</option>
              </select>
		    </td>
		    		   
            <td  colspan="6" align=left>&nbsp;�� ����� ��꼭�� ���� �Ǵ� ��ҿ��� �� Ȯ���� �ʿ�, ������ҽ� ���̳ʽ� ���ݰ�꼭 ���� </td>
          </tr>
          
           <tr>      
		            <td width='13%' class='title'>����Ÿ�</td>
		            <td width=12% >&nbsp; <input type='text' name='tot_dist' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);  set_over_amt();'>&nbsp;km </td>
                  <td colspan=6>&nbsp;�� ���Կɼǽ� ��������Ÿ� </td>
		     </tr>        
              	   
        </table>
      </td>
    </tr>
    
  
   	 <tr>
     		 <td>&nbsp;</td>
     </tr>
               
     <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ������ ���Կɼ� ����ϴ�   ��� �ּ� �̿�Ⱓ�� 1�� �̻��Դϴ�.</td>
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">*** ���°��� 3���� �Ŀ� ���Կɼ� ��簡 �����մϴ� !!!</font></td>
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ������ ���Կɼ� ����ϴ� ��� �뿩��� ��ุ���ϱ��� �ڵ� ���˴ϴ�.</td>
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ���Կɼ� �Է½� �������ڴ� ���Կɼ� �Աݿ������� �Է��ϼž� �մϴ�. </td>
    </tr>
    <tr>
        <td>&nbsp;<font color="#FF0000">***</font> ������ ���Կɼ��ΰ�� ���Կɼ����� ���ϳ�¥���� ū ��� ��ü�ᰡ ���Ǵ� ����ٶ��ϴ�. </td>        
    </tr>
     <tr>
        <td>&nbsp;<font color="#FF0000">*** �뿩�� ������ Ȯ���Ͽ� �ּ���.!! </font></td>
    </tr>
    
    <tr>
      <td>&nbsp;</td>
    </tr>
    
 	<tr id=tr_opt style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���Կɼ�</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 		<tr> 
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>          	
		          	<input type='hidden' name='mopt_per' value='<%=f_opt_per%>'>
		          	<input type='hidden' name='mopt_amt' value='<%=AddUtil.parseDecimal(s_opt_amt)%>'>
		          	<input type='hidden' name='mopt_s_amt' value='<%=s_opt_s_amt%>'>
		          	<input type='hidden' name='old_opt_amt' >
		          	<input type='hidden' name='fee_size_1_opt_amt' value='<%=fee_size_1_opt_amt%>'>  <!--�����ΰ�� �ߵ����Կɼǽ� �ʿ��� ���� ���� -->
		           	<input type='hidden' name='fee_size_1_end_dt' value='<%=fee_size_1_end_dt%>'>
		          	<input type='hidden' name='s_opt_end_dt' value='<%=s_opt_end_dt%>'>
		          	<input type='hidden' name='sui_st ' value='N'>
		          	<input type='hidden' name='sui_d_amt' value='0'>
		 	 	     <td class='title' width="12%">���Կɼ���</td>
		             <td width="12%">&nbsp;<input type='text' name='opt_per' value='<%=f_opt_per%>' size='5' class='num' maxlength='4'>%</td>
		             <td class='title' width="12%">���Կɼǰ�</td>
		             <td colspan=5 width="26%">&nbsp;<input type='text' name='opt_amt'size='13' class='num' value="<%=AddUtil.parseDecimal(s_opt_amt)%>" onBlur='javascript:this.value=parseDecimal(this.value); set_sui_c_amt();'>&nbsp;(VAT����)</td> 
		    	           
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
		                    <input type='text' name='grt_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
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
		                    <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
		                  <td>=���ô뿩�᡿����Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>�ܿ� ���ô뿩��(B)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rifee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
		                  <td class='title'>=���ô뿩��-����ݾ�</td>
		                </tr>
		                <tr> 
		                  <td class='title' rowspan="3">��<br>
		                    ��<br>
		                    ��</td>
		                  <td align='center'>�������� </td>
		                  <td align="center"> 
		                    <input type='text' name='pded_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>=�����ݡ����Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td align='center'>������ �����Ѿ� </td>
		                  <td align="center"> 
		                    <input type='text' name='tpded_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                  <td>=�������ס����̿�Ⱓ</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right'>�ܿ� ������(C)</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='rfee_s_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'></td>
		                  <td class='title'>=������-������ �����Ѿ�</td>
		                </tr>
		                <tr> 
		                  <td class='title' align='right' colspan="3">��</td>
		                  <td class='title' align="center"> 
		                    <input type='text' name='c_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
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
              <input type='text' name='fine_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>' size='15' class='num' ></td>
              <td  align="center" class="title"> 
               <input type='text' name='fine_amt_1' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("FINE_AMT")))%>'  size='15' class='num'  ></td>
              <td class="title"><font color="#66CCFF"><%=base1.get("FINE_CNT")%>��</font></td>
             </tr>
             <tr> 
              <td class="title" colspan="3">�ڱ��������ظ�å��(E)</td>
              <td width='19%' align="center" class="title"> 
                <input type='text' name='car_ja_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>' size='15' class='num' ></td>
              <td width='19%' align="center" class="title">
              <input type='text' name='car_ja_amt_1' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("CAR_JA_AMT")))%>'  size='15' class='num'  ></td>                   
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
                <input type='text' name='ex_di_amt' readonly value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' ></td>
              <td class='' align="center"> 
                <input type='hidden' name='ex_di_v_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>' >
                <input type='text' name='ex_di_amt_1'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_S_AMT"))+AddUtil.parseInt((String)base1.get("DI_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>              
            
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
                <input type='text' size='15' name='nfee_amt'  readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' ></td>
              <td align="center"> 
                <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>  
              <td>������꼭�� ���� �Ǵ� ��ҿ��θ� Ȯ��
                 </td>
            </tr>      
            <tr> 
              <td class="title" colspan="2">�Ұ�(F)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt'  readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
                <td class='title' align="center" class="title"> 
                <input type='text' size='15' name='dfee_amt_1' readonly  class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
              
                 <td class='title'>&nbsp;=������ + �̳�</td>
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
                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base1.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>=������+���뿩���Ѿ�</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">���뿩��(ȯ��)</td>
              <td class='' colspan=2 align="center"> 
                <input type='text' name='mfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>=�뿩���Ѿס����Ⱓ</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">�ܿ��뿩���Ⱓ</td>
              <td class=''  colspan=2  align="center"> 
                <input type='text' name='rcon_mon' readonly  size='3' value='<%=rcon_mon%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                ����&nbsp;&nbsp;&nbsp; 
                <input type='text' name='rcon_day' readonly size='3' value='<%=rcon_day%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this);'>
                ��</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title">�ܿ��Ⱓ �뿩�� �Ѿ�</td>
              <td class=''  colspan=2 align="center"> 
                <input type='text' name='trfee_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> ����� 
                �������</td>
              <td class=''  align="center"> 
                <input type='text' name='dft_int' readonly value='<%=base1.get("CLS_R_PER")%>' size='5' class='num'  maxlength='5'>
                %</td>
                <td class=''  align="center"> 
                <input type='text' name='dft_int_1' value='<%=base1.get("CLS_R_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='5'>
                %</td>
           
              <td>����� ��������� ��༭�� Ȯ��</td>
            </tr>
            <tr> 
              <td  class="title" colspan="2">�ߵ����������(G)</td>
              <td  align="center" class="title"> 
                <input type='text' name='dft_amt'  readonly size='15' class='num' value='' ></td>
               <td align="center" class="title"> 
                <input type='text' name='dft_amt_1' size='15' class='num' value='' onBlur='javascript:set_cls_amt(this)'></td>
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
                <td class="title">&nbsp;<input type='hidden' name='tax_chk0' value='N' ><!--��꼭�����Ƿ�--></td>
            </tr>      
       
            <tr> 
              <td class="title" rowspan="6"><br>
                ��<br>
                Ÿ</td> 
             
              <td colspan="2" class="title">��ü��(H)</td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' ></td>
              <td class='title' align="center" class="title"> 
                <input type='text' name='dly_amt_1' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'></td>
             
              <td class='title'>&nbsp;</td>
            </tr>
            <tr>
              <td class="title" colspan="2">����ȸ�����ֺ��(I)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
               <td  align="center" class="title"> 
                <input type='text' name='etc_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;<input type='hidden' name='tax_chk1' value='N' ></td>
            </tr>
            <tr> 
              <td class="title" colspan="2">����ȸ���δ���(J)</td>
              <td  align="center" class="title"> 
                <input type='text' name='etc2_amt' value='' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
              <td align="center" class="title"> 
                <input type='text' name='etc2_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>  
              <td class="title">&nbsp;<input type='hidden' name='tax_chk2' value='N' ></td>
            </tr>
            <tr> 
              <td colspan="2" class="title">������������(K)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
              <td align="center" class="title"> 
                <input type='text' name='etc3_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
              <td class="title">&nbsp;</td>
            </tr>
            <tr> 
              <td class="title" colspan="2">��Ÿ���ع���(L)</td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'></td>
              <td align="center" class="title"> 
                <input type='text' name='etc4_amt_1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
              <td class="title">&nbsp;<input type='hidden' name='tax_chk3' value='N' ><!--��꼭�����Ƿ�--></td>
            </tr>
               <tr> 
              <td class="title" colspan="2">�ʰ�����뿩��(M)</td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt' readonly value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
              <td align="center" class="title"> 
                <input type='text' name='over_amt_1'  readonly  value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
                <input type='hidden' name='tax_supply' readonly  size='15' class='num' >  
                <input type='hidden' name='tax_value' readonly  size='15' class='num' > 
                <input type='hidden' name='tax_g' size='20' class='text' value=''>
                <input type='hidden' name='tax_chk4'  class='text' value=''>
                 <td class="title">&nbsp;<!--<input type='checkbox' name='tax_chk4' value='Y' onClick="javascript:set_vat_amt(this);">��꼭�����Ƿ�--></td>         
            </tr>       
            <tr> 
              <td class="title" colspan="3">�ΰ���(N)</td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt' value='' readonly size='15' class='num' ></td>
              <td align="center" class="title"> 
                <input type='text' name='no_v_amt_1' value='' readonly size='15' class='num' ></td>  
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
	               <input type='text' name='fdft_amt1' value='' readonly  size='15' class='num' ></td>
              <td class='title_p' align="center"> 
                <input type='text' name='fdft_amt1_1' value='' readonly  size='15' class='num' ></td>  
              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M+N)</td>
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
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt2'  size='15' class='num' readonly  ></td>
                    <td colspan=6>&nbsp;�� �̳��Աݾװ� - ȯ�ұݾװ�</td>
              </tr>
          
              </table>
         </td>       
    <tr>
       
    <tr></tr><tr></tr><tr></tr>
    <tr id=tr_sale style='display:none'> 
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=10% >���Կɼǽ�<br>�����Աݾ�</td>
                    <td width=12% >&nbsp;<input type='text' name='fdft_amt3'  size='15' class='num' readonly  ></td>
                    <td colspan=6>&nbsp;�� �����Աݾ�  + ���Կɼǰ� + ������Ϻ��(�߻��� ���)</td>
              </tr>
                       
              </table>
         </td>       
    <tr>
  
      <tr>
        <td>&nbsp;</td>
    </tr>
     
    
   <!-- �ߵ����꼭�� ����  block none  �뿩���Ⱑ 2�����̻� ������ ���  -->
    
   	<tr id=tr_cal_sale style='display:none'> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td height=22><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�ߵ� ���꼭 </span></td>
 	 		 <td align="right">&nbsp;<a href='javascript:cal_rc_rest()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_hj_bill.gif" align=absmiddle border="0"></a>&nbsp;&nbsp;</td>
 	 	  </tr>
 	 	    
 	 	  <tr>
      		 <td colspan="2" class=line2></td>
   		  </tr>	
 	 	 	 	
 	 	  <tr> 
        <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr>        
               <td class="title"  rowspan="2"  width='3%'>ȸ��</td>
              <td class="title"  rowspan="2" width='8%'>�����ҳ�¥</td>                
              <td class="title"  rowspan="2" width='8%'>���뿩��<br>(���ް�)</td>
              <td class="title"  rowspan="2" width='8%'>���뿩�� ������ <br>������ ����ȿ��</td>
              <td class="title"  rowspan="2" width='8%'>������ ����ȿ�� �ݿ���<br> ���뿩��(���ް�)</td>                  
              <td class="title"  rowspan="2" width='8%'>�ڵ�����</td>                
              <td class="title"  rowspan="2" width='8%'>�����+<br>������</td>
              <td class="title"  rowspan="2" width='8%'>�ڵ�����,�����<br> ���ܿ��<br>(���ް�)</td>                
              <td class="title"  width='25%' colspan=3>�ڵ�����,����� ���ܿ���� ���簡ġ</td>             
              <td class="title"  width='16%' colspan=2>���簡ġ ���� �����ڷ�<br>(������: �� <%=em_bean.getA_f()%>%)</td>                         
            </tr>          
            
            <tr> 
              <td class="title"  width='8%' >���ް�</td>
              <td class="title"  width='8%'>�ΰ���</td>
              <td class="title"  width='9%'>�հ�</td>
              <td class="title"  width='8%'>���簡ġ��</td>
              <td class="title"  width='8%'>�����ϴ��<br>����ϼ�</td>
             </tr>  
             <tr> 
              <td>&nbsp;</td>
              <td>&nbsp;</td>
                  <td align="center"> (1) </td>
              <td align="center"> (2) </td>
              <td align="center"> (3) = (1) + (2)</td>
              <td align="center"> (4) </td>
              <td align="center"> (5) </td>
              <td align="center"> (6) = (3) - (4) - (5) </td>
              <td align="center"> (7) = (6) * (10) </td>
              <td align="center"> (8) = (7) * 0.1</td>
              <td align="center"> (9) = (7) + (8)</td>
              <td align="center"> (10) </td>
              <td align="center"> (11) </td>                                    
             </tr>              
             
<!-- scd_fee���� ����Ÿ �����ͼ� ó�� --> 
              
<%	
		
	for(int i = 0 ; i < vt_size8 ; i++){
					Hashtable ht8 = (Hashtable)vts8.elementAt(i); 					
										
					t_fee_s_amt += AddUtil.parseInt(String.valueOf(ht8.get("FEE_S_AMT")));
					
%>       
	 		   <tr>
                    <td>&nbsp;<input type='text' name='s_fee_tm'  readonly value='<%=ht8.get("FEE_TM")%>' size='4' class='text' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_est_dt'  readonly value='<%=AddUtil.ChangeDate2(String.valueOf(ht8.get("R_FEE_EST_DT")))%>' size='12' class='text' > </td>
                    <td>&nbsp;<input type='text' name='s_fee_s_amt'  readonly value='<%=AddUtil.parseDecimal(String.valueOf(ht8.get("FEE_S_AMT")))%>' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_grt_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_g_fee_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_tax_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_is_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_cal_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_s_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_v_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_r_fee_amt'  readonly value='' size='12' class='num' > </td>
                    <td>&nbsp;<input type='text' name='s_rc_rate'  readonly value='' size='10' class='num' > </td> 
                    <td>&nbsp;<input type='text' name='s_cal_days'  readonly value='' size='8' class='num' > </td>
                 
                   
               </tr>
<% } %>
               
               <tr>
                    <td colspan="2" class=title>�հ�</td>
                    <td class=title><input type='text' name='t_fee_s_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(t_fee_s_amt)%>'></td>
                    <td class=title><input type='text' name='t_s_grt_amt' size='10' class='fixnum' value=''></td>
                    <td class=title><input type='text' name='t_s_g_fee_amt' size='10' class='fixnum' value=''></td>
                    <td class=title></td>
                    <td class=title></td>
                    <td class=title><input type='text' name='t_s_cal_amt' size='10' class='fixnum' value=''></td>
                    <td class=title><input type='text' name='t_r_fee_s_amt' size='10' class='fixnum' value=''></td>
                    <td class=title><input type='text' name='t_r_fee_v_amt' size='10' class='fixnum' value=''></td>
                    <td class=title><input type='text' name='t_r_fee_amt' size='10' class='fixnum' value=''></td>
                    <td class=title></td>
                    <td class=title><input type='text' name='t_cal_days' size='10' class='fixnum' value=''></td>                   
                  
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
        
    <!-- �ʰ�����δ�ݿ� ����  block none-->
    
   	<tr id=tr_over style='display:none'> 
 	   <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> ȯ��/�ʰ����� �뿩��[���ް�]</span></td>
 	 	  </tr>
 	 	  <tr>
      		 <td class=line2></td>
   		  </tr>
 	 	 	 	
 	 	   <tr> 
 	      <td colspan="2" class='line'> 
          <table border="0" cellspacing="1" cellpadding="0" width=100%>
           <tr> 
              <td class="title"  colspan="5"  width='34%'>����</td>
              <td class="title" width='20%'>����</td>                
              <td class="title" width='46%'>����</td>
            </tr>
            <tr> 
              <td class="title"  rowspan="7" >��<br>��<br>��<br>��</td>   
              <td class="title"  rowspan=4>��<br>��</td>
              <td class="title"  colspan=3>���Ⱓ</td>
              <td align="center" >&nbsp;<%=AddUtil.ChangeDate2((String) base1.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String) base1.get("RENT_END_DT"))%> </td>
              <td align="left" >&nbsp;���ʰ��Ⱓ</td>
             </tr>
             <tr> 
              <td class="title" rowspan=3>����<br>�Ÿ�<br>����</td>
              <td class="title"  colspan=2>���������Ÿ� (��)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getAgree_dist() )%> km</td>
              <td align="left" >&nbsp;</td>
             </tr>  
             <tr> 
              <td class="title" rowspan=2>�ܰ�<br>(1km) </td>
              <td class="title" >ȯ�޴뿩�� (a1)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getRtn_run_amt() )%>��</td>
              <td align="left" >&nbsp;�����Ÿ� ���Ͽ���</td>
             </tr>            
             <tr> 
              <td class="title" >�ʰ�����뿩��(a2)</td>
              <td align="right" ><%=AddUtil.parseDecimal(car1.getOver_run_amt() )%>��</td>
               <td align="left" >&nbsp;�����Ÿ� �ʰ�����</td>
            </tr>           
            <tr> 
              <td class="title"  rowspan=3>��<br>��</td>
              <td class="title"  rowspan=2>�̿�<br>�Ⱓ</td>  
              <td class="title"  colspan=2 >���̿�Ⱓ	</td>     
              <td align="center">&nbsp;</td>
              <td align="left" >&nbsp;�����뿩�Ⱓ</td>
            </tr>   
            <tr> 
              <td class="title"  colspan=2 >���̿��ϼ�	(��)</td>
              <td align="right" > <input type='text' name='rent_days' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("RENT_DAYS")))%>' size='7' class='whitenum' > �� </td>
              <td align="left" >&nbsp;</td>
             </tr>
             <tr> 
              <td class="title"  colspan=3 >�����Ÿ�(�ѵ�)(c)</td>
              <td align="right" ><input type='text' name='cal_dist' readonly   size='7' class='whitenum' > km</td>
               <td align="left" >&nbsp;=(��)x(��) / 365</td>
             </tr>
             <tr> 
              <td class="title"  rowspan="6" >��<br>��<br>��<br>��</td>      
              <td class="title"  rowspan=3>��<br>��</td>
              <td class="title"  colspan=3 >��������Ÿ���(d)</td>
             <td align="right" ><input type='text' name='first_dist' readonly  value = '<%=AddUtil.parseDecimal(car1.getSh_km() )%>'  size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;����(�� �ε����� ����Ÿ�) , ������ (��༭�� ��õ� ����Ÿ�)</td>
             </tr>   
             <tr> 
              <td class="title"  colspan=3>��������Ÿ���(e)</td>
              <td align="right" ><input type='text' name='last_dist' readonly   size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;</td>
             </tr>              
             <tr> 
              <td class="title"  colspan=3 >�ǿ���Ÿ�(f)</td>
              <td align="right" ><input type='text' name='real_dist' readonly    size='7' class='whitenum' > km</td>
              <td align="left" >&nbsp;=(e)-(d) </td>
             </tr>                          
             <tr> 
              <td class="title"  rowspan=3>��<br>��</td>
              <td class="title"   colspan=3 >������ؿ���Ÿ�	(g)</td>
              <td align="right" ><input type='text' name='over_dist' readonly    size='7' class='whitenum' > km</td> 
              <td align="left" >&nbsp;=(f)-(c) </td>
             </tr>
              <tr> 
              <td class="title"   colspan=3 >�⺻�����Ÿ�</td>
              <% if (  AddUtil.parseInt(base.getRent_dt()) > 20220414 ) { %>             
              <td align="right" >&nbsp;��1,000 km</td>
            <% } else { %>
              <td align="right" >&nbsp;1,000 km</td>
            <% }  %>  
            
                <td align="left" >&nbsp;<input type='hidden' name='add_dist'  readonly class='whitenum' > </td>
             </tr>      
              <tr> 
              <td class="title"  colspan=3 >�뿩��������ؿ���Ÿ�	(b)</td>
              <td align="right" ><input type='text' name='jung_dist' readonly    size='7' class='whitenum' > km</td>
                <% if (  AddUtil.parseInt(base.getRent_dt())  > 20220414 ) { %>  
              <td align="left" >&nbsp;(g)�� ��1,000km �̳��̸� ������(0km) , (g)��  ��1,000km�� �ƴϸ� (g)���⺻�����Ÿ� </td>
                <% } else { %>
               <td align="left" >&nbsp;</td> 
                <% }  %>
             
             </tr>  
             <tr> 
              <td class="title"  rowspan=3>��<br>��<br>��</td>
              <td class="title"  rowspan=2>��<br>��</td>
              <td class="title"  colspan=3 >����ݾ�(h)</td>
              <td align="right" ><input type='text' name='r_over_amt' readonly    size='10' class='whitenum' >��</td>
              <td align="left" >&nbsp;(b)��  0km �̸��̸� (a1)*(b), (b)�� 1km�̻��̸� (a2)*(b)</td>
             </tr>
             <tr> 
              <td class="title"   colspan=3 >������(i)</td>
              <td align="right"><input type='text' name='m_over_amt'   size='10' class='num'   onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'> ��</td>
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
              <td class="title"  colspan=4 >����(�ΰ�/ȯ�޿���)�ݾ�</td>
              <td align="right" ><input type='text' name='j_over_amt' readonly    size='10' class='whitenum' >��</td>
              <td align="left" >&nbsp;=(h)-(i), ȯ��(-)</td>
             </tr>  
            </table>
           </td>       
         </tr>         
  
     	</table>
      </td>	 
    </tr>	
    
     <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>    
      	 	    
  
     <%	//���ຸ������
			//	ContGiInsBean gins = a_db.getContGiIns(m_id, l_cd);
         		 ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
				
	%>		
		
     <tr> 
          <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������� ����</span></td>
     </tr>
           
      <tr> 
          <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
              <tr> 
                <td class='title' width="10%"> 
                  <%if(gins.getGi_st().equals("1")){%>����<%}else if(gins.getGi_st().equals("0")){ gins.setGi_amt(0);%>����<%}%>
                </td>
                <td class='title' width="15%" align="center"> 
                  <input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' maxlength='15'>
                  </td>
                <td class='title' width="65%"></td>
              </tr>
            </table>
          </td>
    </tr>
          
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>    
    
    <tr>
        <td>&nbsp;</td>
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
			                    <td>&nbsp;<input type='text' name='est_amt' size='15' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'></td>
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
    
    <tr>
	  <td align="center">&nbsp;<input type="text" name="cls_msg"  size="80" readonly  class=text> </td>
	</tr>		   
    
    <tr>
	  <td align="center">&nbsp;<a href="javascript:save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
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
		var re_nfee_amt = 0;  //�������� �����쿡�� �ϼ� ����� �ݾ��� �ƴ� ��� check
 		var santafe_amt = 0; 	 	
 		 	
 		fm.cls_msg.value="";
 		//�ѻ���ϼ� �ʱ� ����		
		if(fm.r_day.value == '30'){
			fm.r_mon.value = toInt(fm.r_mon.value) + 1;
			fm.r_day.value = '0';			
		}
		
		  //�Ѵ뿩�Ⱓ, �ܿ��Ⱓ �� ���   - 20191219 ���� ��� 
	 	if(fm.r_day.value != '0'){
			if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //��������
					
			} else { //�뿩�������� ���ڰ� �ִ���.. �ܿ��뿩�Ⱓ��� ����2010-07-06  - 30�ϱ������� ���
			 	  if (	toInt(fm.r_day.value) + toInt(fm.rcon_day.value) == 31 ) {
			 	//	 if ( toInt(fm.rent_start_dt.value) <= 20170420 ) {	//20170420���� �����+1�� ���� 31���� ���� �� ����.		 		
					    	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);
				// 	  }	
			 	     // 	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);	
				  } else  if (toInt(fm.r_day.value) + toInt(fm.rcon_day.value) < 30 ) {
				    	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);	
				  }
				
			//	fm.rcon_mon.value 		= toInt(fm.con_mon.value) - toInt(fm.r_mon.value) - 1;
			//	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);
			}	
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
				
			//���Կɼ��� ��� �������� setting
		if ( fm.cls_st.value == '8') { //���Կɼ� 
			fm.cancel_yn.value = 'N';
			td_cancel_n.style.display 		= 'none';  //��������
			td_cancel_y.style.display 		= '';  //�������
			tr_sale.style.display 		= '';  //�����Ű��� �����Աݾ�
		}
			
	
		if ( fm.cls_st.value == '8') { //���Կɼ� 
				//�ʰ�����δ�� 2 �ΰ�� - 50% ���� , 3�̸� ����ݾ�
				if ( fm.agree_yn.value == '2'   ||  fm.agree_yn.value == '3'  ) {	
					if ( <%= o_amt%> > 0   ) {
						tr_over.style.display 		= '';  //�ʰ�����δ��
						if (<%=car1.getOver_bas_km()%>  > 0 ) {
							 fm.first_dist.value='<%=car1.getOver_bas_km()%>';				
					
						} else {
							 fm.first_dist.value='<%=car1.getSh_km()%>';		
					
						}	
							
				//		alert( fm.first_dist.value );
						fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.first_dist.value))   );	
					}
				}		
		} else {		     
				     //�ʰ�����δ��	
				if ( <%= o_amt%> > 0 ) {
					tr_over.style.display 		= '';  //�ʰ�����δ��
					if (<%=car1.getOver_bas_km()%>  > 0 ) {
						 fm.first_dist.value='<%=car1.getOver_bas_km()%>';				
					
					} else {
						 fm.first_dist.value='<%=car1.getSh_km()%>';		
				
					}	
						
					fm.first_dist.value 		=     parseDecimal(  toInt(parseDigit(fm.first_dist.value))   );	
				}						
		}		
				
			
		if ( fm.cls_st.value == '8') { //���Կɼ� 
			<% if  ( fuel_cnt > 0) { %>   
			 <%    if ( return_remark.equals("��Ÿ��") ) {%>  				
			 					fm.remark.value="���Կɼ�"; 	
					 	 		fm.cls_cau.value = "��Ÿ�� ���񺸻� ��� ����. ���Կɼ�";
					 	 		fm.etc3_amt_1.value = '-400,000';
			 <%    } else if ( return_remark.equals("ȥ��") ) {%> 
			 					fm.remark.value="���Կɼ�";		 				
					 	 		fm.cls_cau.value = "ȥ�� Ư������ ��� ����. ���Կɼ�";
					 	 		fm.etc3_amt_1.value = '<%=return_amt %>';
					 	 		fm.etc3_amt_1.value =  parseDecimal(  toInt(parseDigit(fm.etc3_amt_1.value)) * (-1)  );	     
			 <%    } else if ( return_remark.equals("����") ) {%> 
								fm.remark.value="���Կɼ�";		 				
					 	 		fm.cls_cau.value = "���� ���񺸻� ��� ����. ���Կɼ�";
					 	 		fm.etc3_amt_1.value = '<%=return_amt %>';
					 	 		fm.etc3_amt_1.value =  parseDecimal(  toInt(parseDigit(fm.etc3_amt_1.value)) * (-1)  );	       
			 <%    } else if ( return_remark.equals("����") ) {%> 
								fm.remark.value="���Կɼ�";		 				
					 	 		fm.cls_cau.value = "���� ���񺸻� ��� ����. ���Կɼ�";
					 			fm.etc3_amt_1.value = '-520,000';		 	 		
									 	 				  	 	 		
		      	<% }%> 	 	 	 		
	 	 	<% }  else { %> 
	 	 		fm.remark.value="���Կɼ�";
		 		fm.cls_cau.value="���Կɼ�";
		 		fm.opt_amt.value = fm.mopt_amt.value;
		 		fm.t_cal_days.value = '0';
	 		<% }%> 	 
 			
 		} else {
 			<% if  ( fuel_cnt > 0   && return_remark.equals("��Ÿ��")  ) {%>
 				fm.cls_cau.value="��Ÿ�� ���񺸻� ��� ����";
 				
	 		   	var s1_str = fm.rent_start_dt.value;
			   	var e1_str = fm.cls_dt.value;
			    var  count1 = 0;
										   
			    var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
			    var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
						
			    var diff1_date = e1_date.getTime()  - s1_date.getTime();					
			 						
	 	 		fm.remark.value = "��Ÿ�� ���񺸻� ��� ����  80000/365*" +count1 ; // 30���ڰ� �ƴ� �ǻ���ϼ��� ����
	 	 		
	 	 	//	santafe_amt = 80000/365 *( ( toInt(parseDigit(fm.r_mon.value)) * 30 ) +   toInt(parseDigit(fm.r_day.value)) );
	 	 		santafe_amt = 80000/365 * count1;
	 	 	//	alert(santafe_amt);	 	 	 
	 	 	     	 	     	 	 	 	 	          	 	     	 	 	 	 	          	 	    
	 	 	    if ( fm.r_mon.value == '36' && fm.r_day.value == '0' )  	 	santafe_amt = 240000;	 
	 	 	    if ( fm.r_mon.value == '48' && fm.r_day.value == '0' )  	 	santafe_amt = 320000;	 	 	          
	 	 	 	 	 	 	          	 	          	 	         	 	
	 	 		if ( santafe_amt > 400000) {
	 	 			santafe_amt = 400000;
	 	 		}  
	 	 		
	 	 		//3���̸� 240000, 4���̸� 320000, 5���̻�:400000
	 	 		
	 	 		fm.etc3_amt_1.value = parseDecimal(santafe_amt * (-1) ); 
 	
	 		<% }%> 	 
	 		<% if  ( fuel_cnt > 0   && return_remark.equals("����")  ) {%>
					fm.cls_cau.value="���� ���񺸻� ��� ����";
				
				   var s1_str = fm.rent_start_dt.value;
				   var e1_str = fm.cls_dt.value;
				   var  count1 = 0;
										   
				   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
				   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
						
				   var diff1_date = e1_date.getTime()  - s1_date.getTime();					
			 						
			 		fm.remark.value = "���� ���񺸻� ��� ����  259,750/365*" +count1 ; // 30���ڰ� �ƴ� �ǻ���ϼ��� ����
			 		
			 	//	santafe_amt = 80000/365 *( ( toInt(parseDigit(fm.r_mon.value)) * 30 ) +   toInt(parseDigit(fm.r_day.value)) );
			 		santafe_amt = 259750/365 * count1;
			 	//	alert(santafe_amt);	 	 	 
			 	     	 	     	 	 	 	 	          	 	     	 	 	 	 	          	 	    
			 	          if ( fm.r_mon.value == '36' && fm.r_day.value == '0' )  	 	santafe_amt = 779250;	 
			 	          if ( fm.r_mon.value == '48' && fm.r_day.value == '0' )  	 	santafe_amt = 1039000;	 	 	          
			 	 	 	 	 	          	 	          	 	         	 	
			 		if ( santafe_amt > 1298748) {
			 			santafe_amt = 1298748;
			 		}  
			 		
			 		//3���̸� 779250, 4���̸� 1039000, 5���̻�:1298748
			 		
			 		fm.etc3_amt_1.value = parseDecimal(santafe_amt * (-1) ); 
	
			<% }%> 
			<% if  ( fuel_cnt > 0   && return_remark.equals("����")  ) {%>
			fm.cls_cau.value="���� ���񺸻� ��� ����";
		
		   var s1_str = fm.rent_start_dt.value;
		   var e1_str = fm.cls_dt.value;
		   var  count1 = 0;
								   
		   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
		   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
				
		   var diff1_date = e1_date.getTime()  - s1_date.getTime();					
	 						
	 		fm.remark.value = "���� ���񺸻� ��� ����  104,000/365*" +count1 ; // 30���ڰ� �ƴ� �ǻ���ϼ��� ����
	 		
	 	//	santafe_amt = 80000/365 *( ( toInt(parseDigit(fm.r_mon.value)) * 30 ) +   toInt(parseDigit(fm.r_day.value)) );
	 		santafe_amt = 104000/365 * count1;
	 	//	alert(santafe_amt);	 	 	 
	 	     	 	     	 	 	 	 	          	 	     	 	 	 	 	          	 	    
	 	          if ( fm.r_mon.value == '36' && fm.r_day.value == '0' )  	 	santafe_amt = 312000;	 
	 	          if ( fm.r_mon.value == '48' && fm.r_day.value == '0' )  	 	santafe_amt = 416000;	 	 	          
	 	 	 	 	 	          	 	          	 	         	 	
	 		if ( santafe_amt > 520000) {
	 			santafe_amt = 520000;
	 		}  
	 		
	 		//3���̸� 312000, 4���̸� 416000, 5���̻�:520000
	 		
	 		fm.etc3_amt_1.value = parseDecimal(santafe_amt * (-1) ); 

			<% }%> 	 
 		}
		
	 		
		//�ܿ����ô뿩�� 
		if(toInt(fm.ifee_s_amt.value)  != 0){
				
	//	if(fm.ifee_s_amt.value != '0'){
		//	ifee_tm = parseDecimal((toInt(parseDigit(fm.ifee_s_amt.value))+1) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
			ifee_tm = Math.round(( toInt(parseDigit(fm.ifee_s_amt.value))+1) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
			pay_tm =  parseDecimal(toInt(fm.con_mon.value)-ifee_tm) ;
			
		//	alert(pay_tm);
			if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
				fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
				fm.ifee_day.value 	= fm.r_day.value;
					
			} else {
			   	 fm.ifee_mon.value = "0";  //�ʱ�ȭ
		   		 fm.ifee_day.value  = "0";			
			}
		
			fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
			fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
											
			v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //����ݾ�
			v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //�ܾ�
			
		    if (v_rifee_s_amt == -1 || v_rifee_s_amt == 1 ) v_rifee_s_amt = 0;  //����
		    
		   	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //��������  - ���ô뿩�� ��ü �� ������
		    		
		    		fm.ifee_ex_amt.value = '0';
		    		fm.rifee_s_amt.value = '0'; 		    		
		    		v_rifee_s_amt = 0;		    		
		   	} 
		   		   		     	
		   	if ( v_rifee_s_amt == 0) { //�������� 
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	    		v_rifee_s_amt = 0;	  
	    	}	
		}
		
		//���ô뿩�ᰡ �������� �뿩�Ḧ ���� ������ ��� ó�� - 20100924 �߰�
		if(toInt(fm.ifee_s_amt.value)  != 0){	
			if ( toInt(fm.rent_end_dt.value) == toInt(fm.use_e_dt.value) ) {
		   		   if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� ���� ���
		   		   		fm.ifee_mon.value 	= '';
						fm.ifee_day.value 	= '';	
		   		   		fm.ifee_ex_amt.value = '0';
		   		   		fm.rifee_s_amt.value = parseDecimal(fm.ifee_s_amt.value) ; 
		   		   }
		   	} 
	    }

		//�ܿ�������
		if(fm.pp_s_amt.value != '0'){			
			if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //������	    		
		    	   fm.pded_s_amt.value 	= 0;
				   fm.tpded_s_amt.value 	= 0;
				   fm.rfee_s_amt.value 	= 0;
		    } else { 			
					fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.lfee_mon.value) );
					fm.rfee_s_amt.value     = parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );  //�ܿ��뿩�Ⱓ���� ��� - 20190827
					fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.rfee_s_amt.value)) ); 
		    }						
			
		  //fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.m_mon.value)+toInt(fm.m_day.value)/30) );
		  //fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );   //+ toInt(parseDigit(fm.ifee_s_amt.value)) 
		
		}
						
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // �����ݾ��� ����� ��� (���Ⱓ�� ����� ���)
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
							
		//���Կɼ��� ���
		//������, ���ô뿩�ᰡ ���� �ִ� ��� -  ���� �� �ߵ����Կɼ� - �ܾ��� 0���� ����, ����� �����Ѵ� ���� �ܾ� �߻�����  ���� ���� 
		if ( fm.cls_st.value == '8') { //���Կɼ� 
	    	 if  ( toInt(fm.fee_size.value) < 2 ) { //������ �ƴϸ� 	 - ������ 0ó��	
	    		   fm.ifee_mon.value = '';  //�ʱ�ȭ
			   	   fm.ifee_day.value  = '';			
				   fm.ifee_ex_amt.value = 0;
		    	   fm.rifee_s_amt.value = 0; 
		    	   v_rifee_s_amt = 0;	  
	    		   fm.pded_s_amt.value 	= 0;
				   fm.tpded_s_amt.value = 0;
				   fm.rfee_s_amt.value 	= 0;	
	    	 }
		
	    	 if ( v_rifee_s_amt > 0 ) {
	    	     alert("���ô뿩�� �ܾ��� �ֽ��ϴ�. ����� �����ϼ��� !!!") ;
	  		     fm.cls_st.options[0].selected = true;
	  		     fm.cls_cau.value = "";		  		 		  		      		  
	  		 } else {		   	
	    	 	fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 		    		
	    		v_rifee_s_amt = 0;
	    	 }
		
	  		 if (toInt(parseDigit(fm.rfee_s_amt.value)) > 0 ) {
	  		     alert("������ �ܾ��� �ֽ��ϴ�. ����� �����ϼ��� !!!") ;
	  		     fm.cls_st.options[0].selected = true;
	  		     fm.cls_cau.value = "";		  		 		  		      		  
	  		 } else {		   	
	  			fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;		
	    	}			    
	   	}
		
		//�����ݾ�	
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );
    	 
				
		//�̳��Աݾ� ���� �ʱ� ����		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}	 

			//���ô뿩�ᰡ ���� ��� 		 -- nnfee_s_amt : �̳��ݾ�(�ܾ׾ƴ�). di_amt :�ܾ׹̳��ݾ�  	  -- �뿩���ð� �� ���    
		if(toInt(fm.ifee_s_amt.value)  == 0){		
  	//	if(fm.ifee_s_amt.value == '0' ) {
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
		   	 		//������ ����������� �ȵ� - �Ѵ޹̸��� ��� 
		   	 		   	  if ( toInt(fm.s_mon.value) == 0 &&  fm.nnfee_s_amt.value  == '0' ) {
						   		fm.nfee_day.value 	= 	fm.r_day.value;
						  }
		   	 		     
		   	 		  } 
		   	 	
		    }  else {//�������� ����. 
			   	 if  (  toInt(parseDigit(fm.di_amt.value))  > 0  ) { //�̳��� �ִٸ� (1���� �̸� �̸� �̳��� ���ؼ� )
			   	//	 alert("c");
			   	     if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1 ) {
			   		  	if ( toInt(parseDigit(fm.hs_mon.value)) < 1  &&  toInt(parseDigit(fm.hs_day.value)) > 1 ) {  // �ܾ� �����쿡 �������� ���ԵǴ� ���
							fm.nfee_day.value = toInt(fm.hs_day.value); 
						 }
			   	    }
		
		       } 
	      } //�������� �� ũ�� 	  
		
		} //���ô뿩�ᰡ ���� ���	 	   		   		
		
		
		 //�̳��ܾ��� �ְ� , �� �̳��� �߻��� ��� 
		 if (  toInt(parseDigit(fm.di_amt.value)) > 0  ) {					  
		    if ( toInt(fm.s_mon.value) - 1  >= 0 ) {
		         fm.nfee_mon.value 	= 	 toInt(fm.s_mon.value) - 1;  //�ܾ��� �ִ� �̳����� ������.		     
		    } 		
		 }    
	
		 if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
	   	    	if (  toInt(parseDigit(fm.di_amt.value)) > 0  &&  toInt(parseDigit(fm.nfee_amt.value)) == 0 ) {  //�ܾ��� �ְ� �̳��� ���ٸ�   	    	 
	   	    	      if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1 ) {  //�������� ���̸鼭 �ϴ��� �̳��뿩�ᵵ �ߺ����� ������ ��� - 20170324  	   	    				
	   	    			//	fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );  //�����ݾ�  - �����ݾ�    		
			      	 	    fm.nfee_amt.value = fm.nnfee_s_amt.value;    
			      	 	//    fm.ex_di_v_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_v_amt.value))  -    toInt(parseDigit(fm.rc_v_amt.value)) );  //�����ݾ�  - �����ݾ�    		
			      	 	//    fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
							if (fm.nfee_amt.value == '0' ) {
				 	       			fm.nfee_day.value = 0;
				 	      	}
				 	 }  
				  	
	   	    	}	   	   	
     	}  	   	
		 
		/*
	 	  	if ( toInt(fm.rent_end_dt.value) > toInt(replaceString("-","",fm.cls_dt.value)) ) {
	   	   	    	if (  toInt(parseDigit(fm.di_amt.value)) > 0 ) {  //�ܾ��� �ִٸ� 
	   	   	    	   if ( toInt(parseDigit(fm.hs_mon.value)) < 1  &&  toInt(parseDigit(fm.hs_day.value)) < 1 ) {  // �ܾ� �����쿡 �������� ���ԵǴ� ���
	   	   	    	      if ( toInt(parseDigit(fm.s_day.value)) > 1 &&  toInt(parseDigit(fm.s_mon.value)) < 1 ) {  //�������� ���̸鼭 �ϴ��� �̳��뿩�ᵵ �ߺ����� ������ ��� - 20170324
	   	   	    				
	   	   	    				 	fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );  //�����ݾ�  - �����ݾ�    		
					      	 	   fm.nfee_amt.value = fm.nnfee_s_amt.value;    
					      	 	   fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
									if (fm.nfee_amt.value == '0' ) {
						 	       			fm.nfee_day.value = 0;
						 	      	}
						 	 }     		
						}
						
						 if ( toInt(parseDigit(fm.hs_mon.value)) >0  &&  toInt(parseDigit(fm.hs_day.value)) > 0 ) {  // �ܾ� �����쿡 �������� ���ԵǴ� ���
					 			 fm.nfee_mon.value 	= 	 toInt(fm.hs_mon.value);  //�ܾ��� �ִ� �̳����� ������.
					   	    	  
					   	    	 if  ( fm.nnfee_s_amt.value  != '0' ) {
					   	    		 	  fm.nfee_day.value 	= 	 toInt(fm.hs_day.value);  //�ܾ��� �ִ� �̳����� ������.	
					   	    	 }						 
						 } 	       	
	   	   	    	}	   	   	
	   }  
		
	*/
			   		
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
		
	  		 	
		//������ȸ���ΰ��(�ϼ� ����� �Ѱ��)�� �����쿡 �����ִ� �ݾ����� ó�� ..	
		if(toInt(fm.ifee_s_amt.value)  == 0){	
	//	if (fm.ifee_s_amt.value == '0' ) {	
		   	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
		   	 	
		   		if ( (toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_oe_dt .value)) ||  (toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_e_dt .value)) ) {  //���Ⱓ��  ���������� ������ ����� ������ 
		   	//	if ( toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_e_dt .value)  ) {  //���Ⱓ�� ������ ����� ������ 
				        if  ( fm.nfee_amt.value  != '0' ) {
					          if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
				 	       		fm.nfee_amt.value = fm.nnfee_s_amt.value;
				 	       		if (fm.nfee_amt.value == '0' ) {
				 	       			fm.nfee_day.value = 0;
				 	       		}	
					 	       }	
					     }	 
			    }		    	
	    	}	    	
	    } 	 			
			
		 // ���ô뿩�� �ִ� ��쿡 ����. (�������� �뿩�Ⱓ�� ����� ��쿡 ���� )	 
	 // 	if(fm.ifee_s_amt.value != '0' ) {
	 	if(toInt(fm.ifee_s_amt.value)  != 0){	
		   	if (v_rifee_s_amt <= 0 ) {  //���ô뿩�Ḧ �� ������ ���  -���ô뿩�� ���� ���� ���� 
		   	      	fm.ifee_mon.value 	= '0';
			  		fm.ifee_day.value 	= '0';
			  		
			  	   if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //�������� �뿩�� �������� ������ ��� 			  		  	     
				        if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
			   	          //   alert(" ���ô뿩�� ����, ������ �뿩�ὺ������ ����, ������ ���� �̳����� �ִ� ���");
			   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	
			   	       	   
				  		 } else {  //�̳��� ���� ���  		
				  		  	  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
				  		      
				  		           var s1_str = fm.rent_end_dt.value;
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
							  	   					  	   
							  	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 			  		 
				  		      }			  		
				  		}	
			  	  } else {  //���ô뿩�� ������ ������ ���� �ȵ�.   			  	  
			  	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���   +  ����и�ŭ �뿩�� ��� 
		   		//	       alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� �ִ� ���");			   	    
				   	     	 var r_tm = 0;     
				   	     	 if  ( toInt(parseDigit(fm.di_amt.value)) > 0 &&  toInt(fm.s_mon.value) > 0 ) {						 
						   	 	r_tm 			    = 	toInt(fm.s_mon.value)  - ifee_tm ;	// �ѹ̳��ῡ�� - ���ô뿩�� ����  , �ܾ��� �߻��Ǿ��⿡ 1�� ���� 
						 //  	 } else {
						//   	 	r_tm 			    = 	toInt(fm.s_mon.value)  - ifee_tm ;	// �ѹ̳��ῡ�� - ���ô뿩�� ����   
						   	 }
				   					   				   	
						   	 fm.nfee_mon.value 	= r_tm;
						   	 fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ;	// �ѹ̳��ῡ�� - ���ô뿩�� ����   
				  	
						  	 // �����ϰ� �������� ���� ��� - ���ڰ��� ��� �߻� 20110524						  	 
							 if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
							     if  ( fm.nfee_amt.value  != '0' ) {
								     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
								 		fm.nfee_amt.value = fm.nnfee_s_amt.value;						 		
								 	 }	
								 }	 
							 }			   	         
			   	      }else {
			   	       //    alert(" ������ �뿩�ὺ������ ���� �ȵ�, ������ ���� �̳����� ���� ���");			   	      
			   	           if ( toInt(fm.r_mon.value) > 0 ||  toInt(fm.r_day.value) > 0 ) { 
				   	       	       fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //����ϼ� ǥ��
					   	      	   fm.nfee_day.value 	= 	fm.r_day.value;
					   	      	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30)  ) ; 
				   	   		}
				   	   }
			  	  
			  	  }
			  	  
			  }  else {  //���ô뿩�ᰡ ���� ��� (�ߵ������Ǵ� ��� )		
				  	     
				  	     if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //������ ������ �̳����� �ִ� ���  
				  	     	  if ( toInt(fm.use_e_dt.value) <= toInt(replaceString("-","",fm.cls_dt.value)) ) {  // ���ô뿩�� �������� 
				  	     	 
					  	     	   if  ( fm.nfee_amt.value  != '0' ) {
							          if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
						 	       		fm.nfee_amt.value =    fm.nnfee_s_amt.value;
						 	       		if (fm.nfee_amt.value == '0' ) {
						 	       			fm.nfee_day.value = 0;
						 	       		}	
							 	       }	
							      }	
						        			  	     	 
				  	     	 }  else { 	   
				  	            
				  	            fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// �ѹ̳��ῡ�� - ���ô뿩�� ����
				  	       }  
				  	     } 
				  	     
				  	     if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   > 0    ) { //
				   	 		    // alert("d1");		   	 		
				   	 		     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // �ܾ��� �߻��Ǿ��⿡ 1�� ����
				   	 		     	
								  if ( toInt(fm.nfee_mon.value) < 0 ) {
								  	 	   	  fm.nfee_mon.value = '0';
								  }
						  }			
								 	 
			 } 
	 	}   
	 	
			
			//������ȸ���ΰ��(�ϼ� ����� �Ѱ��)�� �����쿡 �����ִ� �ݾ����� ó�� ..
		//���Կɼ��� ���� Ʋ��.					 	    		   
	  if ( fm.cls_st.value == '8') { //���Կɼ� 	
	         var count ;
	  			var s_str = fm.rent_end_dt.value;
				var e_str = fm.cls_dt.value;
				
				var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
				var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
				
				var diff_date = s_date.getTime() - e_date.getTime();
				
				count = Math.floor(diff_date/(24*60*60*1000));
				    
		//	if (fm.ifee_s_amt.value == '0' ) {	
				if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
						if ( toInt(fm.rent_end_dt.value)  ==   toInt(fm.use_e_dt .value) ) {  //���Ⱓ�� ������ ����� ������ 
			    	 
					        if  ( fm.nfee_amt.value  != '0' ) {
						          if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
					 	       		fm.nfee_amt.value = fm.nnfee_s_amt.value;
					 	       		if (fm.nfee_amt.value == '0' ) {
					 	       			fm.nfee_day.value = 0;
					 	       		}	
						 	       }	
						     }	 
				    	}		    	
		    	}
					
				if ( toInt(fm.rent_end_dt.value) > toInt(replaceString("-","",fm.cls_dt.value)) ) {
				      if (toInt(fm.fee_size.value) < 2 ) {  //������� �ƴϸ� 
					      if  ( fm.nfee_amt.value  != '0' ) {
							     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
							 		fm.nfee_amt.value = fm.nnfee_s_amt.value;							 		
							 	 }	
				 			}	 
						} else {  //������ ���� 30�� �̳��� ����� ó�� 
							if ( count > 30 ) { 			
							
							} else {
							    if  ( fm.nfee_amt.value  != '0' ) {
								     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
								 			fm.nfee_amt.value = fm.nnfee_s_amt.value;							 		
								 	 }	
				 				}	 
							
							}
												
						}					
						  	 
				 }  				 		
		}			
			 	
		 //�����뿩��� 30�ϱ��� ���???  -
		 //��� //�ѻ���ϼ� �ʱ� ����		//�ܿ��뿩�� �ϼ��� �ٽ� ��� ( 
		// ȯ���� ���)  rcon_mon, rcon_day:�ܿ��뿩�Ⱓ  r_mon, r_day :�̿�Ⱓ 			    
	
		  //ȯ���ΰ�� ��� -  ���������� ������ 
		 if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {	 
		 
		          //���� �����ΰ�� ���� ���Ǵ� ��쵵 ����.
		        if ( toInt(fm.rent_end_dt.value)  != toInt(replaceString("-","",fm.cls_dt.value)) ) {
		                     
				      fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );
				      fm.ex_di_v_amt.value  =   parseDecimal(  toInt(parseDigit(fm.rr_amt.value))   -  toInt(parseDigit(fm.rc_s_amt.value)) -  toInt(parseDigit(fm.rc_v_amt.value)) -   toInt(parseDigit(fm.ex_di_amt.value))  );	
				      fm.nfee_mon.value = '0';
				      fm.nfee_day.value = '0';				      
				      fm.nfee_amt.value = '0';	
			    }	      		         
		 }
				 
		   
	// 	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));   	
	   	fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
	     		   	
	    fm.nfee_amt_1.value 		= fm.nfee_amt.value; 
	    fm.ex_di_amt_1.value 		= fm.ex_di_amt.value; 
	    fm.ex_di_v_amt_1.value 		= fm.ex_di_v_amt.value; 
	   
	  //	fm.d_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)));
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
				
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
		fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
			
		//������ �ִ� ��� �뿩�� ȯ�� 
		if(toInt(parseDigit(fm.nfee_s_amt.value)) < toInt(parseDigit(fm.mfee_amt.value))){
			if ( toInt(fm.rent_end_dt.value)  < toInt(replaceString("-","",fm.cls_dt.value)) ) {	                
				//�������� 
				if( toInt(parseDigit(fm.rcon_mon.value)) < 1  && toInt(parseDigit(fm.rcon_day.value)) < 1 ){
					alert("!!!!!!!���뿩��� �ߵ���������� ���뿩��(ȯ��)�� Ʋ���ϴ�.!!!!!!\n\n�̳��� �ִ� ��� �ݵ�� �뿩�� ������ Ȯ�� �� �̳��ݾ��� ����Ͽ� ���� �����ϼ���!!!");		
					print_view();
				}	
			}
		}
				
			//���� �ΰ��� ����Ͽ� ���Ѵ�.	 		
		var no_v_amt =0;
		var no_v_amt1 =0;

		var c_fee_v_amt =  0;
		
		c_fee_v_amt = Math.round((toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)) ;
		
		// �ΰ��� ���߱� - 20190904 - �ܾ��� �ƴ� �̳��ݾ��� ���ٸ� (��ȸ���� ���)
		if ( toInt(parseDigit(fm.nfee_amt_1.value))  == toInt(parseDigit(fm.nnfee_s_amt.value)) ) {
	    	c_fee_v_amt  = toInt(parseDigit(fm.nnfee_v_amt.value));		   
 	    }	
		
		var   c_pp_s_amt = 0;
		var   c_rfee_s_amt = 0;
		var   c_over_s_amt = 0;
		
		c_pp_s_amt   = toInt(parseDigit(fm.rfee_s_amt.value))*0.1;
		c_rfee_s_amt = toInt(parseDigit(fm.rifee_s_amt.value))*0.1;
		c_over_s_amt = toInt(parseDigit(fm.over_amt_1.value)) * 0.1;
			 		
			//���Կɼ��� ���� Ʋ��.
		if ( fm.cls_st.value == '8') { //���Կɼ� 	
			   fm.dft_amt.value 	= '0';
			   fm.dft_amt_1.value 	= '0';	
	   }
		 	 
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + c_fee_v_amt -  c_pp_s_amt  -  c_rfee_s_amt ;
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + c_fee_v_amt  + c_over_s_amt -  c_pp_s_amt  -  c_rfee_s_amt ;
		
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 		= parseDecimal( toInt(no_v_amt1) );		
		
		set_tax_init();
		
		/*
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}		
			
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
			
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}	
									
		if ( fm.tax_chk3.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.tax_value[3].value)));					 
		}			
		*/
		
		/*
		if ( fm.tax_chk4.checked == true) {
				    fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.tax_value[4].value)));					 
		}				
      */
      
        //�̳��ݾװ�
	    fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value))  + toInt(parseDigit(fm.over_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));
          
		//Ȯ���ݾ� �����ֱ�
		fm.dly_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dly_amt.value))) ;
		fm.dft_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.dft_amt.value)));
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
		
	//	fm.no_v_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)));	
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.dfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value)) +  toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))  + toInt(parseDigit(fm.over_amt_1.value))  + toInt(parseDigit(fm.no_v_amt_1.value)) );	 //Ȯ���ݾ�	
								
		//���� ������ �ݾ� �ʱ� ����	(���ԿɼǱݾ��� ǥ�� ����)		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
					
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
		}
		
		if (fm.cls_st.value  == '8' ) {	//���Կɼ�
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );										
	}
	
	//���ݰ�꼭
	function set_tax_init(){
		var fm = document.form1;
	
		/*
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
