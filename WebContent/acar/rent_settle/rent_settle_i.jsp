<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*, acar.cont.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	//�α���ID&������ID&����
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "02", "01");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"i":request.getParameter("mode");
	String disabled = "";
	String white = "";
	String readonly = "";
	int pay_tot_amt = 0;
	int pay_tot_s_amt = 0;
	int pay_tot_v_amt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	

	//����� ����Ʈ
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	//�����縮��Ʈ
	CodeBean[] banks = c_db.getCodeAll("0003"); 
	int bank_size = banks.length;	
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
	//�ܱ������-���뺸����
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	//�ܱ�뿩����
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	//����������
	ScdRentBean sr_bean0 = rs_db.getScdRentCase(s_cd, "6");
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//�Աݽ�����
	Vector conts = rs_db.getScdRentList(s_cd);
	int cont_size = conts.size();
	//�̼�ä��
	Vector conts2 = rs_db.getScdRentNoList(s_cd);
	int cont_size2 = conts2.size();
	
	//������
	Vector exts = rs_db.getRentContExtList(s_cd);
	int ext_size = exts.size();
	//�̼����·�
	Vector settle_fine = rs_db.getFineSettleList(s_cd);
	int settle_fine_size = settle_fine.size();
	
		
	if(rf_bean.getFee_s_amt()>0 && rf_bean.getInv_s_amt()==0){
		rf_bean.setInv_s_amt(rf_bean.getFee_s_amt());
		rf_bean.setInv_v_amt(rf_bean.getFee_v_amt());
	}
	
	int ext_pay_rent_s_amt = 0;
	int ext_pay_rent_v_amt = 0;
	if(cont_size > 0){
		for(int i = 0 ; i < cont_size ; i++){
    			Hashtable sr = (Hashtable)conts.elementAt(i);
    			if(String.valueOf(sr.get("RENT_ST")).equals("5")){
    				ext_pay_rent_s_amt = ext_pay_rent_s_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
    				ext_pay_rent_v_amt = ext_pay_rent_v_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    			}
    		}
    	}
    	
    	
    	int ext_fee_s_amt = 0;
    	
    	int settle_fine_amt = 0;
	if(settle_fine_size > 0){
		for(int i = 0 ; i < settle_fine_size ; i++){
    			Hashtable ht = (Hashtable)settle_fine.elementAt(i);    			
			settle_fine_amt = settle_fine_amt + AddUtil.parseInt(String.valueOf(ht.get("PAID_AMT")));
    		}
    	}
    	
	//�ڵ���ü�� ���� cont ���� �����
	String rm_rent_mng_id = c_id;
	String rm_rent_l_cd   = "RM00000"+s_cd;
	
	//cms_mng
	ContCmsBean cms = a_db.getCmsMng(rm_rent_mng_id, rm_rent_l_cd);
	
	
	//���꼭�����ϰ��
	if(rc_bean.getUse_st().equals("2")){
		rc_bean.setRet_dt(request.getParameter("h_ret_dt")==null?"":AddUtil.replace(request.getParameter("h_ret_dt"),"-",""));
		rc_bean.setCls_dt(request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt"));
		rc_bean.setCls_st(request.getParameter("cls_st")==null?"":request.getParameter("cls_st"));
	}
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//�˾������� ����
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;		
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}		
		popObj.location = theURL;
		popObj.focus();	
	}
	
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}		
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();		
	}			


	//�ܱ�뿩---------------------------------------------------------------------------------------------------------
			
	//�뿩�ϼ� ���ϱ�
	function getRentTime() {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//��
		l  = 24*60*60*1000;  		// 1��
		lh = 60*60*1000;  			// 1�ð�
		lm = 60*1000;  	 	 		// 1��
		var rent_time = "";
		var d1;
		var d2;
		var d3;
		var d4;		
		var t1;
		var t2;
		var t3;
		var t4;
		var t5;
		var t6;

		d1 = fm.h_rent_start_dt.value;
		d2 = fm.h_rent_end_dt.value;		
		d3 = fm.h_deli_dt.value;
		d4 = fm.h_ret_dt.value;	
		
		<%if(rent_st.equals("12") && ext_size > 0){
    			for(int i = 0 ; i < ext_size ; i++){
    				Hashtable ext = (Hashtable)exts.elementAt(i);
    				if(AddUtil.parseInt(String.valueOf(ext.get("PAY_AMT"))) > 0){
    		%>	
    					d2 = '<%=ext.get("RENT_END_DT")%>';	
    		<%		}
    			}
    	  	}
    		%>			
											
		t1 = getDateFromString(d1).getTime();
		t2 = getDateFromString(d2).getTime();
		t3 = t2 - t1;	
		t4 = getDateFromString(d3).getTime();
		t5 = getDateFromString(d4).getTime();
		t6 = t5 - t4;	

        if (d4 == "") {  //������ ���� ��� skip
        
        } else {
          	if(t3 == t6){
				fm.add_months.value 	= 0;
				fm.add_days.value 	= 0;
				fm.add_hour.value 	= 0;
				fm.tot_months.value 	= fm.rent_months.value;
				fm.tot_days.value 	= fm.rent_days.value;
				fm.tot_hour.value 	= fm.rent_hour.value;
		}else{//�ʰ� or �̸�
				
				fm.add_months.value 	= parseInt((t6-t3)/m);
				fm.add_days.value 	= parseInt(((t6-t3)%m)/l);
				fm.add_hour.value 	= parseInt((((t6-t3)%m)%l)/lh);						
				fm.tot_months.value 	= parseInt(t6/m);
				fm.tot_days.value 	= parseInt((t6%m)/l);
				fm.tot_hour.value 	= parseInt(((t6%m)%l)/lh);				
		}
        }
        				
					
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}
	
	//����뿩�� �ڵ����
	function getFee_sam(){
		var fm = document.form1;
		fm.action = '/acar/rent_settle/short_fee_nodisplay.jsp';
		<%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
		fm.action = '/acar/rent_settle/short_fee_nodisplay2.jsp';
		<%}%>
		fm.target = 'i_no';
		if(fm.user_id.value == '000029'){
			//fm.target = '_blank';
		}
		fm.submit();
		
		fm.fee_sam_yn.value = 'Y';
	}
	
	//�ݾ� ����	
	function set_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		<%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
		
		if(obj==fm.fee_s_amt){
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_v_amt){
			fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));
		}else if(obj==fm.fee_amt){
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));		
		}else if(obj==fm.cons1_s_amt){
			fm.cons1_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) * 0.1) ;
			fm.cons1_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));
		}else if(obj==fm.cons1_v_amt){
			fm.cons1_s_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_v_amt.value)) / 0.1) ;
			fm.cons1_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)));
		}else if(obj==fm.cons1_amt){
			fm.cons1_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.cons1_amt.value))));
			fm.cons1_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons1_amt.value)) - toInt(parseDigit(fm.cons1_s_amt.value)));		
		}else if(obj==fm.cons2_s_amt){
			fm.cons2_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) * 0.1) ;
			fm.cons2_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));
		}else if(obj==fm.cons2_v_amt){
			fm.cons2_s_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_v_amt.value)) / 0.1) ;
			fm.cons2_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_s_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)));
		}else if(obj==fm.cons2_amt){
			fm.cons2_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.cons2_amt.value))));
			fm.cons2_v_amt.value = parseDecimal(toInt(parseDigit(fm.cons2_amt.value)) - toInt(parseDigit(fm.cons2_s_amt.value)));			
		}	
		
		//�Ѱ���ݾ�											
		fm.rent_tot_s_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.cons1_s_amt.value)) + toInt(parseDigit(fm.cons2_s_amt.value)) );
		fm.rent_tot_v_amt.value = parseDecimal(	toInt(parseDigit(fm.fee_v_amt.value)) + toInt(parseDigit(fm.cons1_v_amt.value)) + toInt(parseDigit(fm.cons2_v_amt.value)) );
		fm.rent_tot_amt.value 	= parseDecimal(	toInt(parseDigit(fm.fee_amt.value))   + toInt(parseDigit(fm.cons1_amt.value))   + toInt(parseDigit(fm.cons2_amt.value))   );
			
		
		<%}else{%>	
			
		//����
		if(obj==fm.ag_inv_s_amt){
			fm.ag_inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_inv_s_amt.value)) * 0.1) ;
			fm.ag_inv_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_inv_s_amt.value)) + toInt(parseDigit(fm.ag_inv_v_amt.value)));
		}else if(obj==fm.ag_fee_s_amt){
			fm.ag_fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) * 0.1) ;
			fm.ag_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.ag_fee_v_amt.value)));
		}else if(obj==fm.ag_navi_s_amt){
			fm.ag_navi_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_navi_s_amt.value)) * 0.1) ;
			fm.ag_navi_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_navi_s_amt.value)) + toInt(parseDigit(fm.ag_navi_v_amt.value)));
		}else if(obj==fm.ag_etc_s_amt){
			fm.ag_etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) * 0.1) ;
			fm.ag_etc_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) + toInt(parseDigit(fm.ag_etc_v_amt.value)));
		}else if(obj==fm.ag_cons1_s_amt){
			fm.ag_cons1_v_amt.value = parseDecimal(toInt(parseDigit(fm.ag_cons1_s_amt.value)) * 0.1) ;
			fm.ag_cons1_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_cons1_s_amt.value)) + toInt(parseDigit(fm.ag_cons1_v_amt.value)));
		}else if(obj==fm.ag_cons2_s_amt){
			fm.ag_cons2_v_amt.value = parseDecimal(toInt(parseDigit(fm.ag_cons2_s_amt.value)) * 0.1) ;
			fm.ag_cons2_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_cons2_s_amt.value)) + toInt(parseDigit(fm.ag_cons2_v_amt.value)));			
		//�߰�
		}else if(obj==fm.add_inv_s_amt){
			fm.add_inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_inv_s_amt.value)) * 0.1) ;
			fm.add_inv_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_inv_s_amt.value)) + toInt(parseDigit(fm.add_inv_v_amt.value)));
		}else if(obj==fm.add_fee_s_amt){
			fm.add_fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) * 0.1) ;
			fm.add_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_v_amt.value)));
		}else if(obj==fm.add_navi_s_amt){
			fm.add_navi_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_navi_s_amt.value)) * 0.1) ;
			fm.add_navi_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_navi_s_amt.value)) + toInt(parseDigit(fm.add_navi_v_amt.value)));
		}else if(obj==fm.add_etc_s_amt){
			fm.add_etc_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_etc_s_amt.value)) * 0.1) ;
			fm.add_etc_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_v_amt.value)));
		}else if(obj==fm.add_cons1_s_amt){
			fm.add_cons1_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_cons1_s_amt.value)) * 0.1) ;
			fm.add_cons1_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_cons1_s_amt.value)) + toInt(parseDigit(fm.add_cons1_v_amt.value)));
		}else if(obj==fm.add_cons2_s_amt){
			fm.add_cons2_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_cons2_s_amt.value)) * 0.1) ;
			fm.add_cons2_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_cons2_s_amt.value)) + toInt(parseDigit(fm.add_cons2_v_amt.value)));			
			
		//�δ���
		}else if(obj==fm.cls_s_amt){
			fm.cls_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.cls_s_amt.value)) * 0.1) ;
			if(fm.cls_vat.checked == true){ 
				fm.cls_v_amt.value 	= '0' ;
			}
			fm.cls_amt.value 	= parseDecimal(toInt(parseDigit(fm.cls_s_amt.value)) + toInt(parseDigit(fm.cls_v_amt.value)));
		}else if(obj==fm.ins_m_s_amt){		
			fm.ins_m_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) * 0.1) ;
			if(fm.ins_m_vat.checked == true){ 
				fm.ins_m_v_amt.value 	= '0' ;
			}
			fm.ins_m_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)));
		}else if(obj==fm.ins_h_s_amt){
			fm.ins_h_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_h_s_amt.value)) * 0.1) ;
			if(fm.ins_h_vat.checked == true){ 
				fm.ins_h_v_amt.value 	= '0' ;
			}			
			fm.ins_h_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)));
		}else if(obj==fm.oil_s_amt){
			fm.oil_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.oil_s_amt.value)) * 0.1) ;
			if(fm.oil_vat.checked == true){ 
				fm.oil_v_amt.value 	= '0' ;
			}						
			fm.oil_amt.value 	= parseDecimal(toInt(parseDigit(fm.oil_s_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));
		}else if(obj==fm.km_s_amt){
			fm.km_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.km_s_amt.value)) * 0.1) ;
			fm.km_amt.value 	= parseDecimal(toInt(parseDigit(fm.km_s_amt.value)) + toInt(parseDigit(fm.km_v_amt.value)));
						
		//�뿪���1
		}else if(obj==fm.d_pay_amt1 || obj==fm.d_pay_amt2){
			fm.d_pay_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.d_pay_amt1.value)) + toInt(parseDigit(fm.d_pay_amt2.value)));
		}
		

			//�����հ�
			fm.ag_t_fee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_s_amt.value)) 	+ toInt(parseDigit(fm.ag_navi_s_amt.value))	+ toInt(parseDigit(fm.ag_etc_s_amt.value))	+ toInt(parseDigit(fm.ag_ins_s_amt.value))	);
			fm.ag_t_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_v_amt.value)) 	+ toInt(parseDigit(fm.ag_navi_v_amt.value))	+ toInt(parseDigit(fm.ag_etc_v_amt.value))		);
			fm.ag_t_fee_amt.value   	= parseDecimal( toInt(parseDigit(fm.ag_inv_amt.value)) 		+ toInt(parseDigit(fm.ag_navi_amt.value))	+ toInt(parseDigit(fm.ag_etc_amt.value))	+ toInt(parseDigit(fm.ag_ins_s_amt.value))	);		
			fm.ag_tot_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_s_amt.value))	);
			fm.ag_tot_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_amt.value)) 		+ toInt(parseDigit(fm.ag_cons1_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_amt.value))	);
		
						
			//�߰��հ�
			fm.add_t_fee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.add_inv_s_amt.value)) 	+ toInt(parseDigit(fm.add_navi_s_amt.value))	+ toInt(parseDigit(fm.add_etc_s_amt.value))	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
			fm.add_t_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.add_inv_v_amt.value)) 	+ toInt(parseDigit(fm.add_navi_v_amt.value))	+ toInt(parseDigit(fm.add_etc_v_amt.value))		);
			fm.add_t_fee_amt.value   	= parseDecimal( toInt(parseDigit(fm.add_inv_amt.value)) 	+ toInt(parseDigit(fm.add_navi_amt.value))	+ toInt(parseDigit(fm.add_etc_amt.value))	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);		
			if(obj==fm.add_inv_s_amt || obj==fm.navi_s_amt || obj==fm.etc_s_amt || obj==fm.ins_s_amt){
				//�߰� �뿩���Ѿ�, �հ�
				var fee_s_amt 		= toInt(parseDigit(fm.add_t_fee_s_amt.value));			
				if(toInt(fm.add_months.value)+toInt(fm.add_days.value)>0){
					//fee_s_amt 	= parseDecimal( (fee_s_amt*toInt(fm.add_months.value)) + (fee_s_amt/30*toInt(fm.add_days.value)) );			
				}
				fm.add_fee_s_amt.value 	= parseDecimal( fee_s_amt ) ;						
				fm.add_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.add_fee_s_amt.value)) * 0.1 ) ;			
				fm.add_fee_amt.value 	= parseDecimal( toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_v_amt.value)) );				
			}		
			fm.add_tot_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.add_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_s_amt.value))	);
			fm.add_tot_amt.value 		= parseDecimal( toInt(parseDigit(fm.add_fee_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_amt.value))	);

			//����
			fm.tot_inv_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_inv_s_amt.value)) 	+ toInt(parseDigit(fm.add_inv_s_amt.value))	);
			fm.tot_fee_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_fee_s_amt.value))	);
			fm.tot_t_fee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_t_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_s_amt.value))	);
			fm.tot_navi_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_navi_s_amt.value)) 	+ toInt(parseDigit(fm.add_navi_s_amt.value))	);
			fm.tot_etc_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_etc_s_amt.value)) 	+ toInt(parseDigit(fm.add_etc_s_amt.value))	);
			fm.tot_ins_s_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
			fm.tot_cons1_s_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_s_amt.value))	);
			fm.tot_cons2_s_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons2_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_s_amt.value))	);
			
			fm.tot_inv_v_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_inv_v_amt.value)) 	+ toInt(parseDigit(fm.add_inv_v_amt.value))	);
			fm.tot_fee_v_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_v_amt.value)) 	+ toInt(parseDigit(fm.add_fee_v_amt.value))	);
			fm.tot_t_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_t_fee_v_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_v_amt.value))	);
			fm.tot_navi_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_navi_v_amt.value)) 	+ toInt(parseDigit(fm.add_navi_v_amt.value))	);
			fm.tot_etc_v_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_etc_v_amt.value)) 	+ toInt(parseDigit(fm.add_etc_v_amt.value))	);
			fm.tot_cons1_v_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons1_v_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_v_amt.value))	);
			fm.tot_cons2_v_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons2_v_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_v_amt.value))	);		

			fm.tot_inv_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_inv_amt.value)) 		+ toInt(parseDigit(fm.add_inv_amt.value))	);
			fm.tot_fee_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_fee_amt.value)) 		+ toInt(parseDigit(fm.add_fee_amt.value))	);
			fm.tot_t_fee_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_t_fee_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_amt.value))	);
			fm.tot_navi_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_navi_amt.value)) 	+ toInt(parseDigit(fm.add_navi_amt.value))	);
			fm.tot_etc_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_etc_amt.value)) 		+ toInt(parseDigit(fm.add_etc_amt.value))	);
			fm.tot_ins_amt.value 		= parseDecimal( toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
			fm.tot_cons1_amt.value		= parseDecimal( toInt(parseDigit(fm.ag_cons1_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_amt.value))	);
			fm.tot_cons2_amt.value		= parseDecimal( toInt(parseDigit(fm.ag_cons2_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_amt.value))	);		
		
			//�����հ�
			fm.rent_tot_s_amt.value = parseDecimal( toInt(parseDigit(fm.tot_fee_s_amt.value)) 	+ toInt(parseDigit(fm.tot_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.tot_cons2_s_amt.value))	);
			fm.rent_tot_amt.value 	= parseDecimal( toInt(parseDigit(fm.tot_fee_amt.value)) 	+ toInt(parseDigit(fm.tot_cons1_amt.value)) 	+ toInt(parseDigit(fm.tot_cons2_amt.value))	);

			//�δ����հ�
			fm.etc_tot_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_s_amt.value)) 		+ toInt(parseDigit(fm.ins_m_s_amt.value)) 	+ toInt(parseDigit(fm.ins_h_s_amt.value)) 	+ toInt(parseDigit(fm.oil_s_amt.value)) 	+ toInt(parseDigit(fm.km_s_amt.value)) 	+ toInt(parseDigit(fm.fine_s_amt.value))	);		
			fm.etc_tot_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_amt.value)) 		+ toInt(parseDigit(fm.ins_m_amt.value)) 	+ toInt(parseDigit(fm.ins_h_amt.value)) 	+ toInt(parseDigit(fm.oil_amt.value)) 		+ toInt(parseDigit(fm.km_amt.value)) 	+ toInt(parseDigit(fm.fine_s_amt.value))	);		
						
			if(fm.rent_st.value == '1' || fm.rent_st.value == '12'){
				fm.rent_sett_amt.value = parseDecimal( toInt(parseDigit(fm.rent_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)) - toInt(parseDigit(fm.t_dc_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
			}else{
				fm.rent_sett_amt.value = parseDecimal( toInt(parseDigit(fm.rent_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)) - toInt(parseDigit(fm.t_dc_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)));
			}
			
			fm.rent_sett_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.rent_sett_amt.value))));
			fm.rent_sett_v_amt.value = parseDecimal(toInt(parseDigit(fm.rent_sett_amt.value)) - toInt(parseDigit(fm.rent_sett_s_amt.value)));
			
		<%}%>	
					
		
	}			

	//�뿪���:���� ���÷���
	function driv_display(){
		var fm = document.form1;
		if(fm.driv_serv_st.options[fm.driv_serv_st.selectedIndex].value == '2'){
			tr_drv2.style.display	= '';						
		}else{
			tr_drv2.style.display	= 'none';
			fm.d_paid_dt1.value = '';
			fm.d_paid_dt2.value = '';
			fm.d_pay_amt1.value = '0';
			fm.d_pay_amt2.value = '0';
			fm.d_pay_tot_amt.value = '0';			
		}	
	}	
	
	//�ݾ� ����	
	function pay_set_amt(){
		var fm = document.form1;	
		if(fm.mode.value != 'u') return;		
		fm.rest_amt1.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value))) ;
		fm.rest_amt2.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value)) - toInt(parseDigit(fm.pay_amt2.value))) ;
	}			
	


	
	// ��Ÿ ------------------------------------------------------------------------------------------------
	
	//������ġ ��ȸ
	function car_map(){
/*		var fm = document.form1;
		var SUBWIN="car_map.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarMap", "left=50, top=50, width=730, height=530, scrollbars=yes");
*/		
	}

	//����������Ȳ ��ȸ
	function car_reserve(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserve", "left=50, top=50, width=820, height=400, scrollbars=yes");
	}

	//��������������Ȳ ��ȸ
	function car_reserve2(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve_dk.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserveDK", "left=50, top=50, width=820, height=400, scrollbars=yes");
	}


	//����ϱ�
	function all_reset(){
		var fm = document.form1;	
		fm.reset();
	}
	
	//�����ϱ�
	function save(){
		var fm = document.form1;
		if(fm.sett_dt.value == ''){ alert('�������ڸ� Ȯ���Ͻʽÿ�'); fm.sett_dt.focus(); return; }
		if(fm.run_km.value == ''){ alert('��������Ÿ��� Ȯ���Ͻʽÿ�'); fm.run_km.focus(); return; }
		if(fm.rent_st.value == '1' && (fm.add_months.value != '0' || fm.add_days.value != '0' || fm.add_hour.value != '0') && fm.add_fee_s_amt.value == '0'){
//			alert('�ڵ������ �Ͻʽÿ�'); return;
		}
		
		<%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
		
		<%}else{%>

			var sett_amt 	= toInt(parseDigit(fm.rent_sett_amt.value));
			var sett_s_amt 	= toInt(parseDigit(fm.rent_sett_s_amt.value));
			var sett_v_amt 	= toInt(parseDigit(fm.rent_sett_v_amt.value));
		
			if(fm.rent_st.value == '12' && <%=rf_bean.getFee_s_amt()%> == 0){
				alert('�뿩���Ѿ��� �����ϴ�. Ȯ���Ͻʽÿ�.');	
			}
		
		
			if(sett_amt > (sett_s_amt+sett_v_amt) || sett_amt < (sett_s_amt+sett_v_amt)){
				alert('������ݰ� ���ް�+�ΰ��� ���� �ٸ��ϴ�. Ȯ���Ͻʽÿ�.'); return;
			}
		
			<%if(rc_bean.getCls_st().equals("2")){%>
			if(fm.rent_st.value == 11 && sett_amt ==0){
				alert('�ߵ������ε� ������� �����ϴ�. Ȯ���Ͻʽÿ�.');	return;
			}	
			<%}%>

			if(fm.fee_sam_yn.value == ''){
				alert('�ڵ������� �ʾҽ��ϴ�. �ڵ�����Ͻʽÿ�.'); return;
			}
		
		<%}%>
		
		
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}
	
		fm.action = 'rent_settle_i_a.jsp';
//		fm.target = 'd_content';
		fm.target='i_no';
		fm.submit();
	}
	
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;						
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;		
		var brch_id = fm.brch_id.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var s_cc 	= fm.s_cc.value;
		var s_year 	= fm.s_year.value;				
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		location = "/acar/rent_settle/rent_se_frame_s.jsp?auth_rw="+auth_rw+"&gubun1="+gubun1+"&gubun2="+gubun2+"&brch_id="+brch_id+"&s_kd="+s_kd+"&t_wd="+t_wd+"&s_cc="+s_cc+"&s_year="+s_year+"&sort_gubun="+sort_gubun+"&asc="+asc;
	}	
	
	
	//�̼����·Ḯ��Ʈ
	function viewSettleFine(){
		var fm = document.form1;
		var SUBWIN="/acar/rent_settle/view_settle_fine.jsp?c_id="+fm.c_id.value+"&s_cd="+fm.s_cd.value;	
		window.open(SUBWIN, "ViewSettleFine", "left=50, top=50, width=820, height=400, scrollbars=yes");		
	}
	
	//��ĵ���
	function scan_reg(file_st){
		window.open("/acar/res_stat/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=c_id%>&rent_l_cd=<%=s_cd%>&from_page=/acar/res_mng/res_rent_u.jsp&file_st="+file_st, "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}	
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.run_km.focus();">

<form action="rent_settle_i_a.jsp" name="form1" method="post" >
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun1' value='<%=gubun1%>'>  
 <input type='hidden' name='gubun2' value='<%=gubun2%>'>   
 <input type='hidden' name='brch_id' value='<%=brch_id%>'>
 <input type='hidden' name='start_dt' value='<%=start_dt%>'> 
 <input type='hidden' name='end_dt' value='<%=end_dt%>'>
 <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
 <input type='hidden' name='t_wd' value='<%=t_wd%>'>
 <input type='hidden' name='code' value='<%=code%>'>  
 <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
 <input type='hidden' name='s_cc' value='<%=s_cc%>'>
 <input type='hidden' name='s_year' value='<%=s_year%>'>
 <input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
 <input type='hidden' name='asc' value='<%=asc%>'>
 <input type='hidden' name='mode' value='<%=mode%>'> 
 
 <input type='hidden' name='c_id' value='<%=c_id%>'>
 <input type='hidden' name='s_cd' value='<%=s_cd%>'> 
 <input type='hidden' name='rent_st' value='<%=rent_st%>'>
 <input type='hidden' name='use_st' value='<%=use_st%>'>
 <input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
 <input type='hidden' name='cust_id' value='<%=rc_bean.getCust_id()%>'> 
 <input type='hidden' name='sub_c_id' value='<%=rc_bean.getSub_c_id()%>'>
 <input type='hidden' name='h_rent_start_dt' value='<%=rc_bean.getRent_start_dt()%>'>
 
 <%if(ext_size > 0){
 	String h_rent_end_dt = "";
    	for(int i = 0 ; i < ext_size ; i++){
    		Hashtable ext = (Hashtable)exts.elementAt(i);
    		if(AddUtil.parseInt(String.valueOf(ext.get("PAY_AMT"))) > 0){
    			h_rent_end_dt = String.valueOf(ext.get("RENT_END_DT"));
    		}
    	}%>
 <input type='hidden' name='h_rent_end_dt' value='<%=h_rent_end_dt%><%=rc_bean.getRent_end_dt_h()%><%=rc_bean.getRent_end_dt_s()%>'>    		
 <%}else{%>   	
 <input type='hidden' name='h_rent_end_dt' value='<%=rc_bean.getRent_end_dt()%>'>  
 <%}%>  
 
 <input type='hidden' name='h_deli_dt' value='<%=rc_bean.getDeli_dt()%>'>
 <input type='hidden' name='h_ret_dt' value='<%=rc_bean.getRet_dt()%>'> 
 <input type='hidden' name='section' value='<%=reserv.get("SECTION")%>'> 
 <input type='hidden' name='ins_yn' value='<%=rf_bean.getIns_yn()%>'>   
 
 <input type='hidden' name='car_no' value='<%=reserv.get("CAR_NO")%>'>        
 <input type='hidden' name='c_firm_nm' value='<%=rc_bean2.getFirm_nm()%>'>         
 <input type='hidden' name='c_client_nm' value='<%=rc_bean2.getCust_nm()%>'>          
 <input type='hidden' name='fee_sam_yn' value=''>          
 <input type='hidden' name='day_s_amt' value='<%=rf_bean.getInv_s_amt()%>'>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>����ý��� > �繫ȸ�� > ������� > <span class=style5>������ 
                        ( 
                       <%if(rent_st.equals("1")){%>
                �ܱ�뿩 
                <%}else if(rent_st.equals("2")){%>
                ������� 
                <%}else if(rent_st.equals("3")){%>
                ������ 
                <%}else if(rent_st.equals("9")){%>
                ������� 
                <%}else if(rent_st.equals("10")){%>
                �������� 
                <%}else if(rent_st.equals("4")){%>
                �����뿩 
                <%}else if(rent_st.equals("5")){%>
                �������� 
                <%}else if(rent_st.equals("6")){%>
                �������� 
                <%}else if(rent_st.equals("7")){%>
                �������� 
                <%}else if(rent_st.equals("8")){%>
                ������ 
                <%}else if(rent_st.equals("11")){%>
                �����
                <%}else if(rent_st.equals("12")){%>
                ����Ʈ
                <%}%>	
                        )</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td width="30%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
        <td align="right" width="70%">
            <%	//���꼭�����ϰ��
		if(rc_bean.getUse_st().equals("2")){%>
	    <%  }else{%>	
                <%if(!rent_st.equals("12")){%>	
	            <img src=/acar/images/center/arrow.gif> <%=reserv.get("CAR_NO")%> �뿩����Ʈ <a href="javascript:car_reserve();"><img src="/acar/images/center/button_see.gif" align="absmiddle" border="0"></a>
		    &nbsp;&nbsp;&nbsp;<a href="javascript:car_reserve2();"><img src="/acar/images/center/button_list_dg.gif" align="absmiddle" border="0"></a>&nbsp;
	        <%}%>	
                <a href='javascript:go_to_list();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a><a href='javascript:save();'></a>		
            <%}%>
	    </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                <td class=title>������ȣ</td>
                <td>&nbsp;<%=reserv.get("CAR_NO")%></td>
                <td class=title>����</td>
                <td colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                <td class=title>�����ȣ</td>
                <td colspan="3">&nbsp;<%=reserv.get("CAR_NUM")%></td>
              </tr>
              <tr> 
                <td class=title width=10%>���ʵ����</td>
                <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                <td class=title width=10%>�������</td>
                <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
                <td class=title width=11%>��ⷮ</td>
                <td width=10%>&nbsp;<%=reserv.get("DPM")%>cc</td>
                <td class=title width=10%>Į��</td>
                <td width=10%>&nbsp;<%=reserv.get("COLO")%></td>
                <td class=title width=9%>����</td>
                <td width=10%>&nbsp;<%=reserv.get("FUEL_KD")%></td>
              </tr>
              <tr> 
                <td class=title>���û��</td>
                <td colspan="3">&nbsp;<%=reserv.get("OPT")%></td>
                <td class=title>���翹������Ÿ�</td>
                <td>&nbsp;<%=Util.parseDecimal(String.valueOf(reserv.get("TODAY_DIST")))%>km</td>
                <td class=title>����������</td>
                <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("SERV_DT")))%></td>
              </tr>
            </table>
      </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("12")){%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
        <td align="right"></td>
    </tr>
    <%if(rent_st.equals("1") || rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("9") || rent_st.equals("10") || rent_st.equals("12")){%>
     <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%><%=rc_bean2.getCust_st()%></td>
                    <td class=title width=10%>����</td>
                    <td width=10%>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title width=10%>�������</td>
                    <td width=11%>&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%></td>
                    <td class=title width=10%>��ȣ</td>
                    <td width=18%>&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                    <td class=title width=11%>����ڵ�Ϲ�ȣ</td>
                    <td width=10%>&nbsp;<%=rc_bean2.getEnp_no()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("4") || rent_st.equals("5")){%>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>����</td>
                    <td class=title width=10%>����</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(rc_bean2.getCust_id(),"USER")%></td>
                    <td class=title width=10%>�����Ҹ�</td>
                    <td width=15%>&nbsp;<%=rc_bean2.getBrch_nm()%></td>
                    <td class=title width=10%>�μ���</td>
                    <td width=30%>&nbsp;<%=rc_bean2.getDept_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}%>
    <%if(rent_st.equals("2")){
		//�����������
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());
		//�������
		Hashtable cont_view = a_db.getContViewCase("", rc_bean.getSub_l_cd());%>
		
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=25%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%>����������ȣ</td>
                    <td width=16%>&nbsp;<%=serv.get("CAR_NO")%></td>
                    <td class=title width=10%>����</td>
                    <td width=29%>&nbsp;<%=serv.get("CAR_NM")%></td>
                </tr>
                <tr>
                    <td class=title width="10%">�뿩���</td>
                    <td colspan='5'>&nbsp;<%=cont_view.get("RENT_WAY")%>&nbsp;(<%=cont_view.get("RENT_START_DT")%>~)
                    </td>
                </tr>                     
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}else if(rent_st.equals("3")){
		//����������
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=25%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=10%>����������ȣ</td>
                    <td width=16%>&nbsp;<%=accid.get("CAR_NO")%></td>
                    <td class=title width=10%>����</td>
                    <td width=29%>&nbsp;<%=accid.get("CAR_NM")%></td>
                </tr>
                <tr> 
                    <td class=title>������ȣ</td>
                    <td>&nbsp;<%=accid.get("P_NUM")%></td>
                    <td class=title>�����ں����</td>
                    <td>&nbsp;<%=accid.get("G_INS")%></td>
                    <td class=title>�����</td>
                    <td>&nbsp;<%=accid.get("G_INS_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rent_st.equals("9")){
		//�����������
		RentInsBean ri_bean = rs_db.getRentInsCase(rc_bean.getRent_s_cd());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title> ������ȣ</td>
                    <td>&nbsp;<%=ri_bean.getIns_num()%></td>
                    <td class=title>�����</td>
                    <td colspan="5"> 
                      &nbsp;<select name='ins_com_id' disabled>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ri_bean.getIns_com_id().equals(ic.getIns_com_id()))%>selected<%%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>�����</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_nm()%></td>
                    <td class=title width=10%>����ó��</td>
                    <td width=16%>&nbsp;<%=ri_bean.getIns_tel()%></td>
                    <td class=title width=10%>����ó��</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_tel2()%></td>
                    <td class=title width=10%>�ѽ�</td>
                    <td width=14%>&nbsp;<%=ri_bean.getIns_fax()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>		
    <%}else if(rent_st.equals("6")){
		//������������
		Hashtable serv = rs_db.getInfoServ(c_id, rc_bean.getServ_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=41%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%> ��������</td>
                    <td width=39%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}else if(rent_st.equals("7")){%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>�˻���ȿ�Ⱓ</td>
                    <td width=90%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
                    </td>
              </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}else if(rent_st.equals("8")){
		//����������
		Hashtable accid = rs_db.getInfoAccid(c_id, rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=25%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=10%>�������</td>
                    <td width=16%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%></td>
                    <td class=title width=10%>�����</td>
                    <td width=29%>&nbsp;<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>�����</td>
                    <td colspan="5">&nbsp;<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>����ȣ</td>
                    <td width=10%>&nbsp;<%=rc_bean.getRent_s_cd()%></td>
                    <td class=title width=10%>�������</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
                    <td class=title width=11%>������</td>
                    <td width=10%>&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(), "BRCH")%></td>
                    <td width=10% class=title><%if(rent_st.equals("12")){%>���ʿ�����<%}else{%>�����<%}%></td>
                    <td>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>��Ÿ</td>
                    <td colspan="7">&nbsp;<%=rc_bean.getEtc()%></td>
                </tr>
                <tr> 
                    <td class=title>�����Ⱓ</td>
                    <td colspan="7">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>~ 
                      <%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%></td>
                </tr>
    		  <%
    			if(ext_size > 0){
    				for(int i = 0 ; i < ext_size ; i++){
    					Hashtable ext = (Hashtable)exts.elementAt(i);%>		  
                <tr> 
                    <td class=title>���� [<%=i+1%>]</td>
                    <td colspan="7">&nbsp; 
                        ������� : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_DT")))%> &nbsp;&nbsp;
                        | �뿩�Ⱓ : <%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ext.get("RENT_END_DT")))%> &nbsp;&nbsp; 
                        (<%=ext.get("RENT_MONTHS")%>����<%=ext.get("RENT_DAYS")%>��)                   	
                    </td>
                </tr>
    		  <%		
    		  		}
    		  	}%> 	                
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr id=tr_cont style="display:<%if(rent_st.equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>�������</td>
                    <td width=10%> 
                      <%if(rf_bean.getDriver_yn().equals("Y")){%>
                      &nbsp;���� 
                      <%}else{%>
                      &nbsp;������ 
                      <%}%>
                    </td>
                    <td class=title width=10%>���ú���</td>
                    <td> 
                      <%if(rf_bean.getIns_yn().equals("Y")){%>
                      &nbsp;���� 
                      <%}else{%>
                      &nbsp;�̰��� 
                      <%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����/����</span></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>�����Ͻ�</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class=title>�����Ͻ�</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>���ʾ����ð�</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="2" class=whitenum >
                      �ð� 
                      <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=whitenum >
                      �� 
                      <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="2" class=whitenum >
                      ���� </td>
                    <td class=title width=10%>�߰��̿�ð�</td>
                    <td width=21%> 
                      &nbsp;<input type="text" name="add_hour" value="" size="2" class=num >
                      �ð� 
                      <input type="text" name="add_days" value="" size="2" class=num >
                      �� 
                      <input type="text" name="add_months" value="" size="2" class=num >
                      ���� </td>
                    <td class=title width=10%>���̿�ð�</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="tot_hour" value="" size="2" class=num >
                      �ð� 
                      <input type="text" name="tot_days" value="" size="2" class=num >
                      �� 
                      <input type="text" name="tot_months" value="" size="2" class=num >
                      ���� </td>
                </tr>
                <tr> 
                    <td class=title>���</td>
                    <td colspan="5"> 
                      &nbsp;<input type="text" name="etc" value="" size="130" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>
    <tr><td class=h></td></tr>
    <tr id=tr_sett_nm style="display:''"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩��� ����</span></td>
        <td align="right">
          <a href="javascript:getFee_sam();"><img src=/acar/images/center/button_jdgs.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding=0" width=100%>
            	<tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=41%> 
                        &nbsp;<input type="text" name="sett_dt" value="<%=rc_bean.getCls_dt()%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>                        
                        <%if(rent_st.equals("12")){%>
                        	&nbsp;
                        	<%if(rc_bean.getCls_st().equals("1")){%>��������<%}%>
                        	<%if(rc_bean.getCls_st().equals("2")){%>�ߵ�����<%}%>  
                        	<input type='hidden' name='cls_st' value='<%=rc_bean.getCls_st()%>'>                      
                        <%}%>
                    </td>
                    <td class=title width=10%>��������Ÿ�</td>
                    <td width=39%> 
                        &nbsp;<input type="text" name="run_km" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr id=tr_sett1 style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10% rowspan="2" class=title>����</td>
                    <td colspan="5" class=title>���뿩��(���ް�)</td>
                    <td width=10% rowspan="2" class=title>�뿩���Ѿ�<br>(���ް�)</td>                    
                    <td width=7% rowspan="2" class=title>������<br>(���ް�)</td>
                    <td width=7% rowspan="2" class=title>������<br>(���ް�)</td>
                    <td width=11% rowspan="2" class=title>�հ�<br>(���ް�)</td>
                    <td width=11% rowspan="2" class=title>�հ�<br>(VAT����)</td>
                </tr>
                <tr>
                  <td width=9% class=title>����</td>
                  <td width=8% class=title>������̼�</td>
                  <td width=9% class=title>��Ÿ</td>
                  <td width=9% class=title>���ú����</td>
                  <td width=9% class=title>�հ�</td>
                </tr>
                <tr> 
                    <td class=title>����</td>
                    <td align="center">
                      <input type="text" name="ag_inv_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+ext_pay_rent_s_amt)%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_inv_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_inv_amt'   value='<%=rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_navi_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_navi_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>'>			 
                      <input type='hidden' name='ag_navi_amt'   value='<%=rf_bean.getNavi_s_amt()+rf_bean.getNavi_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_etc_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>'>			 
                      <input type='hidden' name='ag_etc_amt'   value='<%=rf_bean.getEtc_s_amt()+rf_bean.getEtc_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_ins_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center">
                      <input type="text" name="ag_t_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getIns_s_amt()+ext_pay_rent_s_amt)%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_t_fee_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_t_fee_amt'   value='<%=rf_bean.getInv_s_amt()-rf_bean.getDc_s_amt()+rf_bean.getNavi_s_amt()+rf_bean.getEtc_s_amt()+rf_bean.getIns_s_amt()+rf_bean.getInv_v_amt()-rf_bean.getDc_v_amt()+rf_bean.getNavi_v_amt()+rf_bean.getEtc_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>                      
                    <td align="center">
                      <input type="text" name="ag_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+ext_pay_rent_s_amt)%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_fee_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+ext_pay_rent_v_amt)%>'>			 
                      <input type='hidden' name='ag_fee_amt'   value='<%=rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="ag_cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_cons1_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>'>			 
                      <input type='hidden' name='ag_cons1_amt'   value='<%=rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt()%>'>
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='ag_cons2_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>'>			 
                      <input type='hidden' name='ag_cons2_amt'   value='<%=rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt()%>'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="ag_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt()+ext_pay_rent_s_amt)%>" size="10" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type="text" name="ag_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt()+ext_pay_rent_s_amt+ext_pay_rent_v_amt)%>" size="10" class=whitenum readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                </tr>
                <tr>
                  <td class=title>�߰�</td> 
                    <td align="center">
                      <input type="text" name="add_inv_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_inv_v_amt' value='0'>
                      <input type='hidden' name='add_inv_amt'   value='0'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_navi_s_amt" value="0" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_navi_v_amt' value='0'>
                      <input type='hidden' name='add_navi_amt'   value='0'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_etc_s_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_etc_v_amt' value='0'>
                      <input type='hidden' name='add_etc_amt'   value='0'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="add_ins_s_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center">
                      <input type="text" name="add_t_fee_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_t_fee_v_amt' value='0'>
                      <input type='hidden' name='add_t_fee_amt'   value='0'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_fee_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_fee_v_amt' value='0'>
                      <input type='hidden' name='add_fee_amt'   value='0'>
                    </td>
                    <td align="center">
                      <input type="text" name="add_cons1_s_amt" value="0" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_cons1_v_amt' value='0'>
                      <input type='hidden' name='add_cons1_amt'   value='0'>
                    </td>                      
                    <td align="center">
                      <input type="text" name="add_cons2_s_amt" value="0" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='add_cons2_v_amt' value='0'>
                      <input type='hidden' name='add_cons2_amt'   value='0'>
                    </td>                      
                    <td align="center"> 
                      <input type="text" name="add_tot_s_amt" value="0" size="10" class=num readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                    <td align="center"> 
                      <input type="text" name="add_tot_amt" value="0" size="10" class=num readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                    </td>
                </tr>
                
                <tr>
                  <td class=title >����</td> 
                    <td align="center" > 
                      <input type="text" name="tot_inv_s_amt" value="0" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_inv_v_amt' value='0'>
                      <input type='hidden' name='tot_inv_amt' value='0'>
                    </td>
                    <td align="center" > 
                      <input type="text" name="tot_navi_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_navi_v_amt' value='0'>
                      <input type='hidden' name='tot_navi_amt' value='0'>
                    </td>
                    <td align="center" > 
                      <input type="text" name="tot_etc_s_amt" value="0" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_etc_v_amt' value='0'>
                      <input type='hidden' name='tot_etc_amt' value='0'>
                    </td>
                    <td align="center" > 
                      <input type="text" name="tot_ins_s_amt" value="0" size="7" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_ins_v_amt' value='0'>
                      <input type='hidden' name='tot_ins_amt' value='0'>
                    </td>
                    <td align="center" > 
                      <input type="text" name="tot_t_fee_s_amt" value="0" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_t_fee_v_amt' value='0'>
                      <input type='hidden' name='tot_t_fee_amt' value='0'>
                    </td>
                    <td align="center" > 
                      <input type="text" name="tot_fee_s_amt" value="0" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_fee_v_amt' value='0'>
                      <input type='hidden' name='tot_fee_amt' value='0'>
                    </td>
                    <td align="center" > 
                      <input type="text" name="tot_cons1_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_cons1_v_amt' value='0'>
                      <input type='hidden' name='tot_cons1_amt' value='0'>
                    </td>
                    <td align="center" > 
                      <input type="text" name="tot_cons2_s_amt" value="0" size="6" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='tot_cons2_v_amt' value='0'>
                      <input type='hidden' name='tot_cons2_amt' value='0'>
                    </td>
                    <td align="center" >                       
                      <input type="text" name="rent_tot_s_amt" value="0" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��
                      <input type='hidden' name='rent_tot_v_amt' value='0'>
                    </td>
                    <td align="center">                       
                      <input type="text" name="rent_tot_amt" value="0" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr></tr><tr></tr>            
    <tr id=tr_sett3 style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                <tr> 
                    <td class=title width=10% rowspan="2">�δ���</td>
                    <td class=title width=9%>�����</td>
                    <td class=title width=8%>��å��</td>
                    <td class=title width=9%>������</td>
                    <td class=title width=9%>������</td>
                    <td class=title width=9%>km�ʰ�����</td>
                    <td class=title width=10%>�̼����·�</td>
                    <td class=title width=7%>-</td>
                    <td class=title width=7%>-</td>
                    <td class=title width=11%>�հ�<br>(���ް�)</td>
                    <td class=title width=11%>�հ�<br>(VAT����)</td>
                </tr>
                <tr>                  
                    <td align="center"> 
                      <input type='hidden' name='cls_amt' value='0'>
                      <input type='hidden' name='cls_v_amt' value='0'>
                      <input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      	��
                    </td>                    
                    <td align="center"><input type='hidden' name='ins_m_amt' value='0'>
                      <input type='hidden' name='ins_m_v_amt' value='0'>
                      <input type="text" name="ins_m_s_amt" value="0" size="6" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		    </td>                  
                    <td align="center"><input type='hidden' name='ins_h_amt' value='0'>
                      <input type='hidden' name='ins_h_v_amt' value='0'>
                      <input type="text" name="ins_h_s_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		    </td>
                    <td align="center"><input type='hidden' name='oil_amt' value='0'>
                      <input type='hidden' name='oil_v_amt' value='0'>
                      <input type="text" name="oil_s_amt" value="0" size="7" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		    </td>
                    <td align="center"><input type='hidden' name='km_amt' value='0'>
                      <input type='hidden' name='km_v_amt' value='0'>
                      <input type="text" name="km_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		    </td>
		    <td align="center">
                      <input type="text" name="fine_s_amt" value="<%=AddUtil.parseDecimal(settle_fine_amt)%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		    </td>	
		    <td align="center">-</td>	
		    <td align="center">-</td>	
                    <td align="center"><input type="text" name="etc_tot_s_amt" value="0" size="10" readonly class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		    </td>                  
                    <td align="center"><input type="text" name="etc_tot_amt" value="0" size="10" readonly class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
			��
		    </td>                  
                </tr>                   
                <tr>
                    <td class=title>VAT</td>
                    <td align="center"><input type="checkbox" name="cls_vat" value="N"  onClick="javascript:set_amt(document.form1.cls_s_amt);">������</td>
                    <td align="center"><input type="checkbox" name="ins_m_vat" value="N"  onClick="javascript:set_amt(document.form1.ins_m_s_amt);">������</td>
                    <td align="center"><input type="checkbox" name="ins_h_vat" value="N"  onClick="javascript:set_amt(document.form1.ins_h_s_amt);">������</td>
                    <td align="center"><input type="checkbox" name="oil_vat" value="N"  onClick="javascript:set_amt(document.form1.oil_s_amt);">������</td>
                    <td></td>
                    <td align="center">
                        <%if(settle_fine_amt>0){%>
                        <a href="javascript:viewSettleFine();"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
                        <%}%>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <!--
                <tr>
                  <td class=title>1�����̻�<br>�������</td> 
                    <td align="center">                      
                      <input type="text" name="t_dc_amt" value="<%=AddUtil.parseDecimal(rf_bean.getT_dc_amt())%>" size="10" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center" colspan='9'> 
                    </td>
                </tr>                             
                -->
                <input type='hidden' name='t_dc_amt' value='0'>
            </table>
        </td>
    </tr>
	<%if(rent_st.equals("12")){%>	
	<tr>
	  <td colspan="2"><font color='red'><b>* �뿩���-������ ���� �����ݾ��Դϴ�. �����Է½� �뿩���-�߰����� �߰� �߻��� �ݾ��� �־��ּ���. ȯ�޺��� ��� �ݾ׾տ� -�� �ٿ��ּ���.</b></font></td>
	</tr>	
	<tr>
	  <td colspan="2"><font color='red'><b>* ȯ�ޱݾ��� ���̿�ð����� �߰��ݾ��� �߰��̿�ð��� ����,�Ϸ� �ڵ������ �˴ϴ�. �̿�ð��� �����ϼ���.</b></font></td>
	</tr>	
	<%}%> 
    <tr><td class=h></td></tr>
    <tr id=tr_pay_nm style="display:<%if(cont_size > 0){%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ա�ó��</span></td>
    </tr>
    <tr id=tr_pay1 style="display:<%if(cont_size > 0){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
                    <td class=line2 colspan=5 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=20%>����</td>
                    <td class=title width=20%> 
                        <p>�������</p>
                    </td>
                    <td class=title width=20%>��������</td>
                    <td class=title width=20%>�ݾ�</td>
                    <td class=title width=20%>���</td>
                </tr>
    		  <%
    			if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable sr = (Hashtable)conts.elementAt(i);
    					
    					if(String.valueOf(sr.get("RENT_ST")).equals("7")) continue;
    					
    					%>		  
                <tr> 
                    <td class=title> 
                      <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>
                      ����� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>
                      �����뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>
                      �뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("5")){
                      		ext_fee_s_amt = AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
                      %>
                      ����뿩��<input type='hidden' name='ext_fee_s_amt' value='<%=ext_fee_s_amt%>'>
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>
                      ����� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("6")){%>
                      ������
                      <%}%>
                    </td>
                    <td align="center">
        			<%if(String.valueOf(sr.get("PAID_ST")).equals("1")){%>
        			����
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("2")){%>
        			�ſ�ī��
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("3")){%>
        			�ڵ���ü
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("4")){%>
        			������
        			<%}%>				
        			</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%></td>
                    <td align="center"><input type="text" name="pay_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">-</td>
                </tr>
    		  <%			pay_tot_amt   = pay_tot_amt + AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  			pay_tot_s_amt = pay_tot_s_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
    		  			pay_tot_v_amt = pay_tot_v_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    		  			
    		  		}
    		  	}%> 			  
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center"><input type="text" name="pay_tot_amt" value="<%=Util.parseDecimal(pay_tot_amt)%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_drv_nm style="display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿪���(�������)</span></td>
    </tr>
    <tr id=tr_drv1 style="display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
                    <td class=line2 colspan=3 style='height:1'></td>
                </tr>
                <tr> 
                    <td class="title" width=10%>�������</td>
                    <td> 
                      <select name="driv_serv_st" onchange="javascript:driv_display();">
                        <option value="">����</option>
                        <option value="1">�Ҽӿ뿪ȸ��� ���� ����</option>
                        <option value="2">�뿩�� ����� �ջ�</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_drv2 style="display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=20%>����</td>
                    <td class=title width=20%>��������</td>
                    <td class=title width=20%>��������</td>
                    <td class=title width=20%>�ݾ�</td>
                    <td class=title width=20%>���</td>
                </tr>
                <tr id=tr_scd style="display:''"> 
                    <td align="center">�Ա� 
                        <input type="hidden" name="d_rent_st1" value="1">
                    </td>
                    <td align="center"> 
                        <select name="d_paid_st1">
                            <option value="1">����</option>
                            <option value="2">ī��</option>                       
                            <option value="3">�ڵ���ü</option>
                        </select>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=text name="d_pay_dt1" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=num name="d_pay_amt1" value=""onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                        ��</td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td align="center">
                        <input type="hidden" name="d_rent_st2" value="2">
                    </td>
                    <td align="center"> 
                        <select name="d_paid_st2">
                            <option value="1">����</option>
                            <option value="2">ī��</option>                       
                            <option value="3">�ڵ���ü</option>
                        </select>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=text name="d_pay_dt2" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=num name="d_pay_amt2" value="" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                        ��</td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class="title"> �հ�</td>
                    <td align="center">&nbsp; </td>
                    <td align="center">&nbsp; </td>
                    <td align="center"> 
                        <input type='text' size='12' class=whitenum name="d_pay_tot_amt" value="0" readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
                        ��</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_drv3 style="display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class="title" width=10%>���</td>
                    <td> 
                      <input type='text' size='90' class=text name="driv_serv_etc" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr><td class=h></td></tr>
    <tr id=tr_sett_nm2 style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�������</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id=tr_sett2 style="display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10% rowspan='3'>�������</td>
                    <td class=title_p style='text-align:left'> 
                      &nbsp;&nbsp;<input type='text' size='12' class=num name="rent_sett_amt" value="" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      �� (����뿩�� �հ� + �δ��� �հ�  - �Ա�ó�� �հ�, �������/�뿩������� �ջ��� ��� : �뿪��� �հ� ����)</td>
                </tr>
                <tr>                     
                    <td class=title_p style='text-align:left'> 
                      &nbsp;&nbsp;���ް� : <input type='text' size='12' class=num name="rent_sett_s_amt" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      �� 
                      &nbsp;&nbsp;�ΰ��� : <input type='text' size='12' class=num name="rent_sett_v_amt" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��
                </tr>
                <tr>                     
                    <td class=title_p style='text-align:left'>                       
                      &nbsp;&nbsp;������� : 
                      <select name="paid_st">                	          
                	          <option value="1" selected>����</option>
                    	          <option value="2">�ſ�ī��</option>                    	          
                    	          <option value="3" >�ڵ���ü</option>					                      	          
                    	          <option value="4">�������Ա�</option>					  					  
        	                </select> 
        	                <%if(AddUtil.parseInt(rc_bean.getRent_dt()) >= 20121201 && cms.getSeq().equals("")){%>
        	                (������ ������� �ְ�, ��������� �ڵ���ü�� ������ ��� CMS�ڵ���ü ��û ���ϴ�.)
        	                <%}%>
                    </td>
                </tr>
                <tr> 
                    <td class=title>�ڵ���ü</td>
                    <td > 
                      &nbsp;<img src=/acar/images/center/arrow.gif> ����:&nbsp; 
                      <select name='cms_bank'>
                        <option value=''>����</option>
                        <%	if(bank_size > 0){
        				for(int i = 0 ; i < bank_size ; i++){
        					CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(rf_bean.getCms_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        			}%>
                      </select>
                      &nbsp;&nbsp; <img src=/acar/images/center/arrow.gif> ���¹�ȣ:&nbsp; 
                      <input type='text' name='cms_acc_no' value='<%=rf_bean.getCms_acc_no()%>' size='20' class='text'>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ������:&nbsp; 
                      <input type='text' name='cms_dep_nm' value='<%=rf_bean.getCms_dep_nm()%>' size='20' class='text'>
                      &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> ������ �������/����ڹ�ȣ:&nbsp; 
                      <input type='text' name='cms_dep_ssn' value='<%if(rc_bean2.getCust_st().equals("����")){%><%if(!rc_bean2.getSsn().equals("")) out.println(rc_bean2.getSsn().substring(0,6));%><%}else{%><%=rc_bean2.getEnp_no()%><%}%>' size='15' class='text'>
                      <br>&nbsp;(ȯ�޽� ��ü�� Ȥ�� �ڵ���ü ��û�� �����Դϴ�.)
                    </td>
                </tr>                   
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class="title" width=10%>ȯ�޿�û��Ʈ</td>
                    <td> 
                        <textarea rows='5' cols='90' name='coolmsg_cont'>����Ʈ �����Ǿ� ������� ȯ��(<%=reserv.get("CAR_NO")%> <%=rc_bean2.getFirm_nm()%>)�ؾ� �ϴ� Ȯ���Ͻñ� �ٶ��ϴ�.</textarea>                      
                        &nbsp;(ȯ�ޱݾ��� ���� ��� �ѹ����� �߼��ϴ� �޽���)
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
    <tr> 
        <td colspan='2'>�� ���뿩 ���� 2�������� ����� ���� �⺻�� ���� ��������� ��� ��� ��û�������� �Է��ϰ�, �ݾ��� 0������ �Է��Ͻʽÿ�.</td>
    </tr> 
    <tr><td class=h></td></tr>
    <tr id=tr_sett_nm style="display:''"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�뿩��� ����</span></td>
        <td align="right">
          <a href="javascript:getFee_sam();"><img src=/acar/images/center/button_jdgs.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding=0" width=100%>
            	<tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>��������</td>
                    <td width=41%> 
                        &nbsp;<input type="text" name="sett_dt" value="<%=rc_bean.getCls_dt()%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>                        
                        <%if(rent_st.equals("12")){%>
                        	&nbsp;
                        	<%if(rc_bean.getCls_st().equals("1")){%>��������<%}%>
                        	<%if(rc_bean.getCls_st().equals("2")){%>�ߵ�����<%}%>  
                        	<input type='hidden' name='cls_st' value='<%=rc_bean.getCls_st()%>'>                      
                        <%}%>
                    </td>
                    <td class=title width=10%>��������Ÿ�</td>
                    <td width=39%> 
                        &nbsp;<input type="text" name="run_km" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>��������</td>
                    <td colspan='4'>&nbsp;
                        <select name="paid_st">
                    	              <option value="">==����==</option>			  
                        	      <option value="1" <%if(rf_bean.getPaid_st().equals("1")){%>selected<%}%>>����</option>
                            	      <option value="2" <%if(rf_bean.getPaid_st().equals("2")){%>selected<%}%>>�ſ�ī��</option>
                            	      <option value="3" <%if(rf_bean.getPaid_st().equals("3")){%>selected<%}%>>�ڵ���ü</option>
                            	      <option value="4" <%if(rf_bean.getPaid_st().equals("4")){%>selected<%}%>>�������Ա�</option>
                	                </select>
		        &nbsp;&nbsp;<input type='checkbox' name='fee_r_yn' value="Y" >&nbsp;�뿩�������Ͽ� ��ݿ�û       	
                      </td>                      
                </tr>
                <tr> 
                    <td class=title>û������</td>
                    <td colspan='4'>&nbsp;1�� <%=AddUtil.parseDecimal(rf_bean.getInv_s_amt())%>�� (���ް�)
                      </td>                      
                </tr>       	
                <tr> 
                    <td class=title>����</td>                    
                    <td width="11%" class=title>�뿩���Ѿ�</td>
                    <td width="8%" class=title>������</td>
                    <td width="8%" class=title>������</td>
                    <td width="11%" class=title>�Ѱ���ݾ�</td>
                </tr>            
                <tr> 
                    <td class=title width="10%">���ް�</td>
                    <td align="center"> 
                      <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getCons1_s_amt()+rf_bean.getCons2_s_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�ΰ���</td>
                    <td align="center"> 
                      <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_v_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()+rf_bean.getCons1_v_amt()+rf_bean.getCons2_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr>
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center"> 
                      <input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()+rf_bean.getFee_v_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons1_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt()+rf_bean.getCons1_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="cons2_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt()+rf_bean.getCons2_v_amt())%>" size="6" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      ��</td>
                </tr> 
            </table>
        </td>
    </tr>   
    <tr> 
        <td colspan='2'>�� �̿� ���� ��� ��� : 24�ð� �̳� �ݳ� - 1��ġ ��� ����, 24�ð� �̻� �̿�� - 12�ð� ������ �뿩��� ����</td>
    </tr>     
    <tr><td class=h></td></tr>
    <tr id=tr_pay_nm style="display:<%if(cont_size > 0){%>''<%}else{%>none<%}%>">	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ա�ó��</span></td>
    </tr>
    <tr id=tr_pay1 style="display:<%if(cont_size > 0){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
                    <td class=line2 colspan=5 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=20%>����</td>
                    <td class=title width=20%> 
                        <p>�������</p>
                    </td>
                    <td class=title width=20%>��������</td>
                    <td class=title width=20%>�ݾ�</td>
                    <td class=title width=20%>���</td>
                </tr>
    		  <%
    			if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable sr = (Hashtable)conts.elementAt(i);
    					
    					if(String.valueOf(sr.get("RENT_ST")).equals("7")) continue;
    					
    					%>		  
                <tr> 
                    <td class=title> 
                      <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>
                      ����� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>
                      �����뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>
                      �뿩�� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("5")){
                      		ext_fee_s_amt = AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
                      %>
                      ����뿩��<input type='hidden' name='ext_fee_s_amt' value='<%=ext_fee_s_amt%>'>
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>
                      ����� 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("6")){%>
                      ������
                      <%}%>
                    </td>
                    <td align="center">
        			<%if(String.valueOf(sr.get("PAID_ST")).equals("1")){%>
        			����
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("2")){%>
        			�ſ�ī��
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("3")){%>
        			�ڵ���ü
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("4")){%>
        			������
        			<%}%>				
        			</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%></td>
                    <td align="center"><input type="text" name="pay_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">-</td>
                </tr>
    		  <%			pay_tot_amt   = pay_tot_amt + AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  			pay_tot_s_amt = pay_tot_s_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_S_AMT")));
    		  			pay_tot_v_amt = pay_tot_v_amt + AddUtil.parseInt(String.valueOf(sr.get("RENT_V_AMT")));
    		  			
    		  		}
    		  	}%> 			  
                <tr> 
                    <td class=title>�հ�</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center"><input type="text" name="pay_tot_amt" value="<%=Util.parseDecimal(pay_tot_amt)%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      ��</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>       

    <tr></tr><tr></tr>    
    <%}%>
    <tr><td class=h></td></tr>	        
    <tr> 
        <td align="right"  colspan="2">
            <%	//���꼭�����ϰ��
		if(rc_bean.getUse_st().equals("2")){%>
	    <%  }else{%>	        
                <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                    <a href='javascript:save();'> <img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
                <%}%>
            <%	}%>    
	</td>
    </tr>  
    <tr>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��༭ ��ĵ����</span>
        </td>
    </tr>  
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=line2 colspan=5 style='height:1'></td>
                </tr>
                <tr>
                    <td width="10%" class=title>����</td>
                    <td width="25%" class=title>����</td>                    
                    <td width="25%" class=title>��ĵ����</td>
                    <td width="25%" class=title>�������</td>
                    <td width="15%" class=title>����</td>		  
                </tr>
                
		<% 	
                   	int scan_num = 0;
                   	String file_st = "";
                   
                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
			String content_code = "SC_SCAN";
			String content_seq  = c_id+""+s_cd; 
			
			Vector attach_vt = new Vector();
			int attach_vt_size = 0;                   
                %>                
                   
                   
                <!-- �⺻�� ���� ������� ������ -->   
                <%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
                                                
                <% 	scan_num++; 
                	file_st = "28";                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�⺻�������������������</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�⺻�������������������</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <%}%>
                                
                                
                <%if(rent_st.equals("1") || rent_st.equals("9") || rent_st.equals("12")){//�ܱ�뿩,�������,����Ʈ%>
                
                <%	scan_num++;%>
                   
                <!-- �ڵ����뿩�̿��༭ -->
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�ڵ����뿩�̿��༭</td>
                    <td align="center">
                        <%if(rent_st.equals("12")){%>
                            <%if(AddUtil.parseInt(rc_bean.getRent_dt()) > 20120830){%>
                    	        (��) <a href='/acar/secondhand_hp/rm_car_doc_new.jsp?rent_s_cd=<%=s_cd%>&car_mng_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                    	    <%}else{%>
                    	        (��) <a href='/acar/secondhand_hp/rm_car_doc.jsp?rent_s_cd=<%=s_cd%>&car_mng_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                    	    <%}%>
                        <%}else{%>
                            (��) <a href='res_rent_p.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp; 		      
                        <%}%>
                    </td>
                    <td align="center">��������</td>		  
                    <td align="center"></td>		  
                </tr>  
                                
                <!-- ��༭(��)-jpg���� -->
                <% 	scan_num++; 
                	file_st = "17";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">��༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">��༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                
                <!-- ��༭(��)-jpg���� -->
                <% 	scan_num++; 
                	file_st = "18";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">��༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">��༭(��)-jpg����</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                
                                
                <!-- ����ڵ����jpg -->
                <%	if(!rc_bean2.getEnp_no().equals("")){ //����,���λ����%>
                <% 		scan_num++; 
                		file_st = "2";                                      	
                
                		content_seq  = c_id+""+s_cd+""+file_st;
                
                		attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                		attach_vt_size = attach_vt.size();
                	
                		if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">����ڵ����jpg</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%			}
                		}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">����ڵ����jpg</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%		}%>
                <%	}%>

                <%	if(rc_bean2.getCust_st().equals("����")){%>
                
                <!-- ���ε��ε -->    
                <% 		scan_num++; 
                		file_st = "3";                                      	
                
                		content_seq  = c_id+""+s_cd+""+file_st;
                
                		attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                		attach_vt_size = attach_vt.size();
                	
                		if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">���ε��ε</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%			}
                		}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">���ε��ε</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%		}%>
                
                <!-- �����ΰ����� -->    
                <% 		scan_num++; 
                		file_st = "6";                                      	
                
                		content_seq  = c_id+""+s_cd+""+file_st;
                
                		attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                		attach_vt_size = attach_vt.size();
                	
                		if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�����ΰ�����</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%			}
                		}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�����ΰ�����</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%		}%>                
                                            
                <%	}%>   
                

                <!-- �ź���jpg -->
                <% 	scan_num++; 
                	file_st = "4";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�ź���jpg</td>
                    <td align="center"><a href="javascript:isView2('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�ź���jpg</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
          
                <!-- �ֿ����ڿ��������� -->
                <% 	scan_num++; 
                	file_st = "24";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�ֿ����ڿ���������</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�ֿ����ڿ���������</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>       
                
                <!-- �߰������ڿ��������� -->
                <% 	scan_num++; 
                	file_st = "27";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�߰������ڿ���������</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�߰������ڿ���������</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                      
                
                <!-- ����纻 -->
                <% 	scan_num++; 
                	file_st = "9";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">����纻</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">����纻</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                          
                
                <%}%>    
                

                <!-- ���������ε��� -->
                <% 	scan_num++; 
                	file_st = "25";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">���������ε���</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">���������ε���</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>         
                
                <!-- ���������μ��� -->
                <% 	scan_num++; 
                	file_st = "26";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">���������μ���</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">���������μ���</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                                         
                
                
                <!-- ��Ÿ -->
                <% 	scan_num++; 
                	file_st = "5";                                      	
                
                	content_seq  = c_id+""+s_cd+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">��Ÿ</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">��Ÿ</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                   
                

                <!-- �߰� -->
                <% 	scan_num++; 
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">�߰�</td>
                    <td align="center"><a href="javascript:scan_reg('')" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr> 
            </table>
        </td>
    </tr>                        
</table>
</form>
<script language='javascript'>
<!--
	var fm = document.form1;	
	
	
	<%if(rent_st.equals("12") && ext_size > 0){
    		for(int i = 0 ; i < ext_size ; i++){
    			Hashtable ext = (Hashtable)exts.elementAt(i);
    			if(AddUtil.parseInt(String.valueOf(ext.get("PAY_AMT"))) > 0){
    	%>	
    				fm.rent_months.value 	= toInt(fm.rent_months.value)	+ <%=ext.get("RENT_MONTHS")%>;
    				fm.rent_days.value 	= toInt(fm.rent_days.value)	+ <%=ext.get("RENT_DAYS")%>;
    	<%		}
    		}
    	  }
    	%>		
    					
	//�̿�Ⱓ ����	
	getRentTime();
	
	
	if(fm.rent_st.value == '1' || fm.rent_st.value == '9' || fm.rent_st.value == '12'){

		if(fm.add_hour.value == '0' && fm.add_days.value == '0' && fm.add_months.value == '0'){
			fm.add_fee_s_amt.value 	= '0';
			fm.add_ins_s_amt.value 	= '0';
			fm.add_etc_s_amt.value 	= '0';
			fm.add_tot_s_amt.value 	= '0';
			fm.add_tot_amt.value 	= '0';		
		}	
		
		if(<%=rf_bean.getFee_s_amt()%> == 0){
			alert('�뿩���Ѿ��� �����ϴ�. Ȯ���Ͻʽÿ�.');	
		}
		
		
		//����		
		fm.tot_inv_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_s_amt.value)) 	+ toInt(parseDigit(fm.add_inv_s_amt.value))	);
		fm.tot_fee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_fee_s_amt.value))	);
		fm.tot_navi_s_amt.value = parseDecimal( toInt(parseDigit(fm.ag_navi_s_amt.value)) 	+ toInt(parseDigit(fm.add_navi_s_amt.value))	);
		fm.tot_etc_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_etc_s_amt.value)) 	+ toInt(parseDigit(fm.add_etc_s_amt.value))	);
		fm.tot_ins_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
		fm.tot_t_fee_s_amt.value = parseDecimal( toInt(parseDigit(fm.ag_t_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_s_amt.value))	);
		fm.tot_cons1_s_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_s_amt.value))	);
		fm.tot_cons2_s_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons2_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_s_amt.value))	);
		
		fm.tot_inv_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_v_amt.value)) 	+ toInt(parseDigit(fm.add_inv_v_amt.value))	);
		fm.tot_fee_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_fee_v_amt.value)) 	+ toInt(parseDigit(fm.add_fee_v_amt.value))	);
		fm.tot_t_fee_v_amt.value = parseDecimal( toInt(parseDigit(fm.ag_t_fee_v_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_v_amt.value))	);
		fm.tot_navi_v_amt.value = parseDecimal( toInt(parseDigit(fm.ag_navi_v_amt.value)) 	+ toInt(parseDigit(fm.add_navi_v_amt.value))	);
		fm.tot_etc_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_etc_v_amt.value)) 	+ toInt(parseDigit(fm.add_etc_v_amt.value))	);
		fm.tot_cons1_v_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons1_v_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_v_amt.value))	);
		fm.tot_cons2_v_amt.value= parseDecimal( toInt(parseDigit(fm.ag_cons2_v_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_v_amt.value))	);		

		fm.tot_inv_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_inv_amt.value)) 		+ toInt(parseDigit(fm.add_inv_amt.value))	);
		fm.tot_fee_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_fee_amt.value)) 		+ toInt(parseDigit(fm.add_fee_amt.value))	);
		fm.tot_t_fee_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_t_fee_amt.value)) 	+ toInt(parseDigit(fm.add_t_fee_amt.value))	);
		fm.tot_navi_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_navi_amt.value)) 	+ toInt(parseDigit(fm.add_navi_amt.value))	);
		fm.tot_etc_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_etc_amt.value)) 		+ toInt(parseDigit(fm.add_etc_amt.value))	);
		fm.tot_ins_amt.value 	= parseDecimal( toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value))	);
		fm.tot_cons1_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons1_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_amt.value))	);
		fm.tot_cons2_amt.value	= parseDecimal( toInt(parseDigit(fm.ag_cons2_amt.value)) 	+ toInt(parseDigit(fm.add_cons2_amt.value))	);		
		
		fm.rent_tot_s_amt.value = parseDecimal( toInt(parseDigit(fm.tot_fee_s_amt.value)) 	+ toInt(parseDigit(fm.tot_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.tot_cons2_s_amt.value))	);
		fm.rent_tot_amt.value 	= parseDecimal( toInt(parseDigit(fm.tot_fee_amt.value)) 	+ toInt(parseDigit(fm.tot_cons1_amt.value)) 	+ toInt(parseDigit(fm.tot_cons2_amt.value))	);


		//�δ���
		fm.etc_tot_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_s_amt.value)) 		+ toInt(parseDigit(fm.ins_m_s_amt.value)) 	+ toInt(parseDigit(fm.ins_h_s_amt.value)) 	+ toInt(parseDigit(fm.oil_s_amt.value)) 	+ toInt(parseDigit(fm.km_s_amt.value))		+ toInt(parseDigit(fm.fine_s_amt.value))	);		
		fm.etc_tot_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_amt.value)) 		+ toInt(parseDigit(fm.ins_m_amt.value)) 	+ toInt(parseDigit(fm.ins_h_amt.value)) 	+ toInt(parseDigit(fm.oil_amt.value)) 		+ toInt(parseDigit(fm.km_amt.value))		+ toInt(parseDigit(fm.fine_s_amt.value))	);		
		
		
		
				
		if(fm.rent_st.value == '1' || fm.rent_st.value == '12'){
			fm.rent_sett_amt.value 	 = parseDecimal( toInt(parseDigit(fm.rent_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)) - toInt(parseDigit(fm.t_dc_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
			
			<%if(pay_tot_amt==pay_tot_s_amt+pay_tot_v_amt){%>
			fm.rent_sett_s_amt.value = parseDecimal( toInt(parseDigit(fm.rent_tot_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)) - <%=pay_tot_s_amt%>);
			<%}else{%>
			fm.rent_sett_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.rent_sett_amt.value))));
			<%}%>
			fm.rent_sett_v_amt.value = parseDecimal( toInt(parseDigit(fm.rent_sett_amt.value)) - toInt(parseDigit(fm.rent_sett_s_amt.value)));
			
		}else{
			fm.rent_sett_amt.value   = parseDecimal( toInt(parseDigit(fm.rent_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)) - toInt(parseDigit(fm.t_dc_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)));
			fm.rent_sett_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.rent_sett_amt.value))));
			fm.rent_sett_v_amt.value = parseDecimal(toInt(parseDigit(fm.rent_sett_amt.value)) - toInt(parseDigit(fm.rent_sett_s_amt.value)));
		}
		
	}
	
	<%if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){%>
	getFee_sam();
	<%}%>
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
