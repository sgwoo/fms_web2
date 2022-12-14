<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.car_sche.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.im_email.*, acar.tint.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	if(auth_rw.equals("")){	auth_rw = rs_db.getAuthRw(user_id, "01", "04", "08"); }	
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	//????????????
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")){ base.setCar_gu(base.getReg_id()); }
	
	//????????????
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//????????????
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//??????????????
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//????????NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//????????????
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//????????????
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//????????????
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//????????????
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//????????????
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//????????
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//????????
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//??????????????
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//????????+?????? ??????
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	//?????????? ??????
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//????????
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());

	//???????????? 20131101
	CarOffBean a_co_bean = new CarOffBean();
	
	if(!coe_bean.getAgent_id().equals("")){
		a_co_bean = cod.getCarOffBean(coe_bean.getAgent_id());
	}else{
		a_co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	}
	
	//????????????????
	Vector commis = a_db.getCommis(emp1.getEmp_id());
	int commi_size = commis.size();
	
	
	//??????????
	CommiBean emp4 	= a_db.getCommi(rent_mng_id, rent_l_cd, "4");
	
	CarOffEmpBean coe_bean4 = new CarOffEmpBean();
	
	if(!emp4.getEmp_id().equals("")){
		coe_bean4 = cod.getCarOffEmpBean(emp4.getEmp_id());
	}
	
	
	//????????
	DocSettleBean doc = new DocSettleBean();
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("1", rent_l_cd);
		doc_no = doc.getDoc_no();
	}else{
		doc = d_db.getDocSettle(doc_no);
	}
	
	//????????
	Vector vt = t_db.getTints(rent_mng_id, rent_l_cd);
	int vt_size = vt.size();
	
	//????	
	TintBean tint1 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "2");
	TintBean tint3 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "3");
	TintBean tint4 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "4");
	TintBean tint5 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "5");	
	TintBean tint6 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "6");
		
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	
	
	
	
	//????????????
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&from_page="+from_page+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&doc_no="+doc_no+"&mode="+mode+
				   	"";	
				   		
	String tint_sup_est_dt = "";
	String tint_sup_dt = "";
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "COMMI";
	String content_seq  = "";

	Vector attach_vt = new Vector();
	int attach_vt_size = 0;
	
	
	//??????????????
	Hashtable alink_lc_rent = ln_db.getAlinkEndLcRent(rent_l_cd, "1");	
	
	int b_agent_commi = 0;
	if(base.getBus_st().equals("7") && cont_etc.getBus_agnt_id().equals("")){
		b_agent_commi = 100000;   
    }
	if(String.valueOf(alink_lc_rent.get("RENT_L_CD")).equals(rent_l_cd)){
		b_agent_commi = 0;
	}
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//?????????? ????
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
		
	//?????????? ????
	function MM_openBrWindow(theURL,fileExtension,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		if(fileExtension == ''){
			theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		}else{
			theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+""+fileExtension;
		}		
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}
			
	//??????
	function list(){
		var fm = document.form1;			
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'commi_doc_frame.jsp';
		}
		fm.target = 'd_content';
		fm.submit();
	}	

	//????????????
	function view_emp(emp_id){
		var fm = document.form1;
		window.open("/acar/car_office/car_office_p_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_c_c_fee.jsp&cmd=view&emp_id="+emp_id, "VIEW_EMP", "left=50, top=50, width=850, height=600, scrollbars=yes");
	}
	
	//????????
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&emp_id=<%=emp1.getEmp_id()%>&from_page=/fms2/commi/commi_doc_u.jsp&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//????????
	function scan_del(file_st){
		var fm = document.form1;
		if(!confirm('?????????????????')){		return;	}
		fm.file_st.value = file_st;
		fm.target = "i_no"
		fm.action = "del_scan_a.jsp";
		fm.submit();
	}	

	//????????????
	function setCommi(){
		var fm = document.form1;
		
		var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));		
		var comm_r_rt 	= toFloat(fm.comm_r_rt.value);
		
		fm.comm_rt_amt.value 	= parseDecimal(th_round(toInt(parseDigit(fm.commi_car_amt.value))*toFloat(fm.comm_rt.value)/100));
		fm.comm_r_rt_amt.value 	= parseDecimal(th_round(toInt(parseDigit(fm.commi_car_amt.value))*toFloat(fm.comm_r_rt.value)/100));
		
		fm.commi.value = parseDecimal(th_round(car_price*comm_r_rt/100));
				
		set_amt();
	}
	
	//????????????
	function set_amt(){
		
		if('<%=emp1.getSup_dt()%>' != '' && '<%=user_id%>' != '000029'){
			return;
		}
		
		var fm = document.form1;
		var per = 1;
		
		if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == ''){
			alert('????1 ?????? ????????????.'); return;
		}
		
		if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == ''){
			alert('????2 ?????? ????????????.'); return;
		}
		
		if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == ''){
			alert('????3 ?????? ????????????.'); return;
		}				
		
				
		<%if(a_co_bean.getDoc_st().equals("2")){%>
			
			per = 0.1;
			
			fm.inc_per.value = 0;
			fm.res_per.value = 0;
			fm.vat_per.value = per*100;
			fm.tot_per.value = per*100;

			var tot_add1 = 0;//??????????
			var tot_add2 = 0;//??????????
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt1.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt2.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt3.value));
			if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt3.value));
			
			fm.dlv_con_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.dlv_con_commi.value))));
			fm.dlv_tns_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.dlv_tns_commi.value))));
			fm.agent_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.agent_commi.value))));
			
			fm.add_tot_amt.value = parseDecimal(toInt(parseDigit(fm.add_amt1.value)) + toInt(parseDigit(fm.add_amt2.value)) + toInt(parseDigit(fm.add_amt3.value))); 										
			fm.a_amt.value = parseDecimal(tot_add1);
			fm.b_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) + toInt(parseDigit(fm.dlv_con_commi.value)) + toInt(parseDigit(fm.dlv_tns_commi.value)) + toInt(parseDigit(fm.agent_commi.value)) + toInt(parseDigit(fm.a_amt.value))); 							
			
			fm.inc_amt.value = 0; 
			fm.res_amt.value = 0; 			

			fm.vat_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.b_amt.value))) * per )); 			

			fm.c_amt.value = fm.vat_amt.value; 
						
			fm.e_amt.value = parseDecimal(tot_add2);
			fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.b_amt.value)) + toInt(parseDigit(fm.c_amt.value)) + toInt(parseDigit(fm.e_amt.value))); 		
			
		<%}else{%>
				
			if(fm.rec_incom_st.value != ''){
				
				if(fm.rec_incom_st.value == '2'){
					per = 0.03;
				}else if(fm.rec_incom_st.value == '3'){
					 	per = 0.06;		//20180401???? 0.04->0.06 ????
					 	if(<%=AddUtil.getDate(4)%> > 20181231){
							per = 0.06;		//20190101???? 0.06->0.08 ???? -> 20190404 ?????????? 2019?? ???????? 70% ???????? ???????? [0.06]
						}
				}
			
				fm.inc_per.value = per*100;
				fm.res_per.value = per*10;
				fm.vat_per.value = 0;
				fm.tot_per.value = per*110;

				var tot_add1 = 0;//??????????
				var tot_add2 = 0;//??????????
				if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt1.value));
				if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt1.value));
				if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt2.value));
				if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt2.value));
				if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt3.value));
				if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt3.value));
			
				fm.dlv_con_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.dlv_con_commi.value))));
				fm.dlv_tns_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.dlv_tns_commi.value))));
				fm.agent_commi.value = parseDecimal(th_round(toInt(parseDigit(fm.agent_commi.value))));
			
				fm.add_tot_amt.value = parseDecimal(toInt(parseDigit(fm.add_amt1.value)) + toInt(parseDigit(fm.add_amt2.value)) + toInt(parseDigit(fm.add_amt3.value))); 										
				fm.a_amt.value = parseDecimal(tot_add1);
				fm.b_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) + toInt(parseDigit(fm.dlv_con_commi.value)) + toInt(parseDigit(fm.dlv_tns_commi.value)) + toInt(parseDigit(fm.agent_commi.value)) + toInt(parseDigit(fm.a_amt.value))); 							
			
				fm.inc_amt.value = parseDecimal(th_rnd((toInt(parseDigit(fm.b_amt.value))) * per )); 
				fm.res_amt.value = parseDecimal(th_rnd(toInt(parseDigit(fm.inc_amt.value)) * 0.1 )); 			
				fm.vat_amt.value = 0; 	
				fm.c_amt.value = parseDecimal(toInt(parseDigit(fm.inc_amt.value)) + toInt(parseDigit(fm.res_amt.value))); 
						
				fm.e_amt.value = parseDecimal(tot_add2);
				fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.b_amt.value)) - toInt(parseDigit(fm.c_amt.value)) + toInt(parseDigit(fm.e_amt.value))); 
			
			}else{
				alert('?????????? ?????????? ???????? ????????.');
			}
		<%}%>
	}
	
	//???????????? ????

 	var errfound = false;

	function jumin_No(){
		var fm = document.form1;
		
		var ssn = '';
		var ssn1 = '';
		var ssn2 = '';
		
		ssn = replaceString('-','',fm.rec_ssn.value);
		
		ssn1 = ssn.substr(0, 6);
		ssn2 = ssn.substr(6);

		var str_len ;
    		var str_no = ssn1+ssn2;

    		str_len = str_no.length;
    		
		var a1=str_no.substring(0,1);
		var a2=str_no.substring(1,2);
		var a3=str_no.substring(2,3);
		var a4=str_no.substring(3,4);
		var a5=str_no.substring(4,5);
		var a6=str_no.substring(5,6);

		var check_digit=a1*2+a2*3+a3*4+a4*5+a5*6+a6*7;

		var b1=str_no.substring(6,7);
		var b2=str_no.substring(7,8);
		var b3=str_no.substring(8,9);
		var b4=str_no.substring(9,10);
		var b5=str_no.substring(10,11);
		var b6=str_no.substring(11,12);
		var b7=str_no.substring(12,13);

		var check_digit=check_digit+b1*8+b2*9+b3*2+b4*3+b5*4+b6*5; 

		check_digit = check_digit%11;
		check_digit = 11 - check_digit;
		check_digit = check_digit%10;
			
		if (check_digit != b7){
			alert('?????? ??????????????????.');
			errfound = false;          
		}else{
			//alert('?????? ???????? ??????????.');
			errfound = true;
		}    		
				
		return errfound;

	
	}


		
	function save(mode){
		var fm = document.form1;
		
		if(mode == 'guar'){
		
		}else{
			
			// ???????????? ?????????? ???? ?? ?? ?????????????? 0???? ?????? ??????		2017. 12. 06
			var dlv_con_commi_yn = <%=cont_etc.getDlv_con_commi_yn().equals("Y")%>;	// ???????????? ????????
			var dlv_con_commi = $("#dlv_con_commi").val();													// ???????????? ????
						
			if(dlv_con_commi_yn && dlv_con_commi==0){
				alert('?????????????? 0???? ?? ????????. ????????????.'); return;
			}
			
			if(toFloat(parseDigit(fm.comm_r_rt.value))>0 && toInt(parseDigit(fm.commi_car_amt.value))==0){
				alert('???????? ????????????(????????)?? ?????? ???????????? ?????? ???? ???????? ?????? ????????. ????????????.'); return;
			}
					
			<%if(a_co_bean.getDoc_st().equals("2")){%>
		
			<%}else{%>			
				if(fm.emp_acc_nm.value == '')		{	alert('???????? ?????? ???????? ????????.'); 			return;		}
				if(fm.rel.value == '')			{	alert('?????????? ???????????? ?????? ???????? ????????.'); 	return;		}
				if(fm.rec_incom_yn.value == '')		{	alert('?????????? ???????????? ???????? ????????.'); 		return;		}
				if(fm.rec_incom_st.value == '')		{	alert('?????????? ?????????? ???????? ????????.'); 		return;		}
				if(fm.emp_bank_cd.value == '')		{	alert('?????? ?????? ???????? ????????.'); 			return;		}
				if(fm.emp_acc_no.value == '')		{	alert('?????? ?????????? ???????? ????????.'); 			return;		}
				if(fm.rec_ssn.value == '')		{	alert('?????????? ?????????? ???????? ????????.'); 		return;		}
				if(fm.t_zip.value == '')		{	alert('?????????? ?????????? ???????? ????????.'); 		return;		}
				if(fm.t_addr.value == '')		{	alert('?????????? ?????? ???????? ????????.'); 			return;		}
				
				//???????? ???? ????
				if(!jumin_No()){
					return;
				}
			<%}%>
			
			if(fm.b_amt.value == '0')			{	alert('?????????? ????????????.'); 				return;		}
			if(fm.c_amt.value == '0')			{	alert('?????????? ????????????.'); 				return;		}		
			if(fm.d_amt.value == '0')			{	alert('???????????? ????????????.'); 				return;		}		
			
			if(fm.dlv_con_commi.value != '0' && fm.dlv_tns_commi.value != '0'){
				alert('?????????????? ?????????????????? ???? ???????? ????????. ????????????.');
				return;
			}
			
			//????????(????????????)???? ?????????? ????.
			if(<%=base.getRent_dt()%> >= 20190610 && toInt(parseDigit(fm.commi.value))>0 && '<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && '<%=cont_etc.getDlv_con_commi_yn()%>' == 'Y' && '<%=cont_etc.getDir_pur_commi_yn()%>' == 'Y' && '<%=pur.getDir_pur_yn()%>' == 'Y'){
				alert('???????????? ???????????? ?????????????? ???? ?????????? ?????????? ????????.'); return;
			}				
			
			<%if(emp1.getCar_off_id().equals("03997")){%>
			if(fm.dlv_con_commi.value == 0){
				if(!confirm('(??)?????????? ?????????????? ????????. ???? ?????????????')){	
					return;
				}
			}
			<%}%>
			
			if(fm.email_1.value != '' && fm.email_2.value != ''){
				fm.emp_email.value = fm.email_1.value+'@'+fm.email_2.value;		
			}

		}
		
		if(<%=b_agent_commi%> == 0 && fm.agent_commi.value != '0'){
			alert('?????????????? ???? ????????.'); return;
		}
		
		set_amt();
		
		fm.mode.value = mode;
		
		if(confirm('???? ?????????????')){	
			fm.action='commi_doc_u_a.jsp';		
			fm.target='d_content';			
			fm.submit();
		}							
	}		
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		
		//????????(????????????)???? ?????????? ????.
		if(<%=base.getRent_dt()%> >= 20190610 && toInt(parseDigit(fm.commi.value))>0 && '<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && '<%=cont_etc.getDlv_con_commi_yn()%>' == 'Y' && '<%=cont_etc.getDir_pur_commi_yn()%>' == 'Y' && '<%=pur.getDir_pur_yn()%>' == 'Y'){
			alert('???????????? ???????????? ?????????????? ???? ?????????? ?????????? ????????.'); return;
		}	
		
		fm.doc_bit.value = doc_bit;
		
		set_amt();
				
		if(confirm('?????????????????')){	
			fm.action='commi_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}

	function doc_msg(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		fm.mode.value = 'msg';
		
		if(confirm('?????????????????')){	
			fm.action='commi_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}	
	
	function re_doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		fm.mode.value = 're_doc';		
		if(confirm('?????????????????')){	
			fm.action='commi_doc_re_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}		
	
	//????????????????????????
	function doc_email(){
		var fm = document.form1;
		if(fm.email_1.value != '' && fm.email_2.value != ''){
			fm.emp_email.value = fm.email_1.value+'@'+fm.email_2.value;		
		}
		if(fm.emp_email.value == ''){ alert('???????????? ????????????.'); return; }
		if(confirm('?????? ???????????????')){	
			fm.action='commi_doc_mail_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}											
	}

	//???????????????????????? ????
	function doc_email_view(){
		var fm = document.form1;
		fm.action="/mailing/s_man/c_trans.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";		
		fm.target="_blank";
		fm.submit();
	}	
	
	
	//???????? ????
	function search_bank_acc(){
		var fm = document.form1;
		window.open("s_emp_bank_acc.jsp?from_page=/fms2/commi/commi_doc_u.jsp&emp_id=<%=emp1.getEmp_id()%>", "SEARCH_EMP_ACC", "left=50, top=50, width=950, height=600, scrollbars=yes");		
	}
	
	
	//???????????? ????
	function dlv_con_commi(){
		var fm = document.form1;
				
		window.open('about:blank', "DlvConCommi", "left=0, top=0, width=500, height=600, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "DlvConCommi";				
		fm.action = '/acar/estimate_mng/view_dlv_con_commi.jsp';		
		fm.submit();	
	}	
	//???????????????? ????
	function dlv_tns_commi(){
		var fm = document.form1;
		
		window.open('about:blank', "DlvConCommi", "left=0, top=0, width=450, height=350, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "DlvConCommi";				
		fm.action = '/acar/estimate_mng/view_dlv_tns_commi.jsp';		
		fm.submit();	
	}	

	function reg_emp_proxy(){
		var fm = document.form1;	
		if(<%=b_agent_commi%> == 0 || fm.agent_commi.value != '0'){
			alert('?????????????? ???? ????????.'); return;
		}
		window.open('commi_doc_proxy_i.jsp<%=valus%>', "EmpProxy", "left=0, top=0, width=930, height=550, scrollbars=yes, status=yes, resizable=yes");				
	}
	function update_emp_proxy(){
		var fm = document.form1;
		if(<%=b_agent_commi%> == 0 || fm.agent_commi.value != '0'){
			alert('?????????????? ???? ????????.'); return;
		}
		window.open('commi_doc_proxy_u.jsp<%=valus%>', "EmpProxy", "left=0, top=0, width=930, height=550, scrollbars=yes, status=yes, resizable=yes");				
	}
	
	//?????? ????
	function doc_id_cng(doc_bit, doc_user){
		var fm = document.form1;	
		var width 	= 400;
		var height 	= 300;		
		window.open("/fms2/doc_settle/doc_user_cng.jsp<%=valus%>&doc_no=<%=doc_no%>&doc_bit="+doc_bit+"&doc_user="+doc_user, "CNG", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");			
	}	
	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="emp_id" 		value="<%=emp1.getEmp_id()%>">
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="gur_size" 		value="<%=gur_size%>">  
  <input type='hidden' name="mode" 		value="<%=mode%>">    
  <input type='hidden' name="file_st" 		value="">    
  <input type='hidden' name="doc_bit" 		value="">      
  <input type='hidden' name="s_file_name1"	value="">      
  <input type='hidden' name="s_file_name2"	value="">      
  <input type='hidden' name="s_file_gubun1"	value="">      
  <input type='hidden' name="s_file_gubun2"	value="">        
  <input type="hidden" name="rent_dt" value="<%=base.getDlv_dt()%>">
  <input type="hidden" name="car_id" value="<%=car.getCar_id()%>">
  <input type="hidden" name="car_seq" value="<%=car.getCar_seq()%>">
  <input type="hidden" name="car_amt" value="<%=car.getCar_cs_amt()+car.getCar_cv_amt()%>">
  <input type="hidden" name="opt_amt" value="<%=car.getOpt_cs_amt()+car.getOpt_cv_amt()%>">
  <input type="hidden" name="col_amt" value="<%=car.getClr_cs_amt()+car.getClr_cv_amt()%>">
  <input type='hidden' name="agent_doc_st"	value="<%=a_co_bean.getDoc_st()%>">
  <input type='hidden' name="auto_set_amt"	value="Y">
  <input type='hidden' name="dir_pur_commi_yn"	value="<%=cont_etc.getDir_pur_commi_yn()%>">
  <input type='hidden' name="client_st"	value="<%=client.getClient_st()%>">
  <input type='hidden' name="dir_pur_yn"	value="<%=pur.getDir_pur_yn()%>">
  
  
  
<% 			int commi_car_amt = car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt();
if(AddUtil.parseInt(base.getRent_dt()) >= 20190701 ){
	commi_car_amt = commi_car_amt -car.getTax_dc_s_amt()-car.getTax_dc_v_amt();
}

                	if(AddUtil.parseInt(base.getRent_dt())<20130321){
                    		if(car.getS_dc1_yn().equals("Y")){ commi_car_amt = commi_car_amt - car.getS_dc1_amt(); }
                    		if(car.getS_dc2_yn().equals("Y")){ commi_car_amt = commi_car_amt - car.getS_dc2_amt(); }
                    		if(car.getS_dc3_yn().equals("Y")){ commi_car_amt = commi_car_amt - car.getS_dc3_amt(); }
                    	}
%>  
  <input type="hidden" name="o_1" value="<%=commi_car_amt-car.getS_dc1_amt()-car.getS_dc2_amt()-car.getS_dc3_amt()%>">
    
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;???????? > ???????? > <span class=style1><span class=style5>????????????????</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%if(!mode.equals("view")){%>
    <tr>
	    <td align='right'><a href="javascript:list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
	</tr>
	<%}%>	
	<tr> 
        <td class=line2></td>
    </tr>	
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>????</td>
                    <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%>??????????</td>
                    <td width=15%>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
    		    </tr>	
                <tr> 
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>????<%}else if(car_st.equals("2")){%>????<%}else if(car_st.equals("3")){%>????<%}else if(car_st.equals("5")){%>????????<%}%></td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>??????<%}else if(rent_way.equals("3")){%>??????<%}else if(rent_way.equals("2")){%>??????<%}%></td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%=fee.getCon_mon()%>????</td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>??</td>
    		    </tr>	
                <tr>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_start_dt())%></td>
                    <td class=title width=10%>??????????</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeDate2(fee.getRent_start_dt())%></td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%if(cms.getCms_acc_no().equals("")){%>??????<%}else{%>CMS<%}%></td>
                    <td class=title width=10%>??????????</td>
                    <td width=15%>&nbsp;
        			  <%if(cont_etc.getRec_st().equals("") && client.getEtax_not_cau().equals("")){ 	cont_etc.setRec_st("1"); }
        			    if(cont_etc.getRec_st().equals("") && !client.getEtax_not_cau().equals("")){ cont_etc.setRec_st("2"); }
        				if(cont_etc.getRec_st().equals("1")){
        					out.print("????");
        				}else{
        					out.print("????");
        				}%>
        				</td>
    		    </tr>	
                <tr>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class=title width=10%>????????</td>
                    <td >&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class=title width=10%>????</td>
                     <td >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class=title width=10%>??????</td>
                    <td width=15%>&nbsp;<%=cm_bean.getDpm()%>cc</td>
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
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>??????</td>
                    <td width=15%>&nbsp;
        			  <%String pp_st = "";
        			  	int pp_amt = fee.getGrt_amt_s()+fee.getPp_s_amt()+fee.getIfee_s_amt();
        				int jan_amt = a_db.getPpNoPayAmt(rent_mng_id, rent_l_cd, "1", "");
        				int pay_amt = a_db.getPpPayAmt(rent_mng_id, rent_l_cd, "1", "");
        				if(pp_amt == 0){
        					pp_st = "????";
        				}else{
        					String pp_st1 = a_db.getPpPaySt(rent_mng_id, rent_l_cd, "1", "0");
        				  	String pp_st2 = a_db.getPpPaySt(rent_mng_id, rent_l_cd, "1", "1");
        				  	String pp_st3 = a_db.getPpPaySt(rent_mng_id, rent_l_cd, "1", "2");
        					if(pp_st1.equals("??????") || pp_st1.equals("????")){ pp_st = "????"; }
        					if(pp_st2.equals("??????") || pp_st2.equals("????")){ pp_st = "????"; }
        					if(pp_st3.equals("??????") || pp_st3.equals("????")){ pp_st = "????"; }
        					if(pp_st.equals("")){ pp_st = "????"; }
        				}%>
        				<input type='hidden' name='pp_st' value='<%=pp_st%>'>
        				<%if(jan_amt>0){%>????(<%=Util.parseDecimal(jan_amt)%>??)<%}else{%><%=pp_st%><%}%>
        				<%if(pay_amt>0 && pp_st.equals("????")){%>(<%=Util.parseDecimal(pay_amt)%>??)<%}%>
        			</td>
                    <td class=title width=10%>??????????</td>
                    <td width=15%>&nbsp;<input type='text' size='11' name='pp_est_dt' maxlength='10' class="whitetext" value='<%=AddUtil.ChangeDate2(fee.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title width=10%>????????</td>
                    <td width=40%>&nbsp;<input type='text' name='pp_etc' size='40' value='<%=fee.getPp_etc()%>' class='whitetext'></td>
    		    </tr>	
    		    <%%>
                <tr> 
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;
        			  <%String gi_st = "";
        			  	if(gins.getGi_st().equals("0") || gins.getGi_st().equals("")){
        					gi_st = "????";
        			  	}else{
        					if(gins.getGi_dt().equals("")){
        						gi_st = "????";
        					}else{
        						gi_st = "????";
        					}
        				}
        			  %>
        			  <input type='hidden' name='gi_st' value='<%=gi_st%>'>
        			  <%=gi_st%><%if(!gi_st.equals("????")){%>(<%=Util.parseDecimal(gins.getGi_amt())%>??)<%}%>
        			</td>
                    <td class=title width=10%>??????????</td>
                    <td width=15%>&nbsp;<input type='text' size='11' name='gi_est_dt' maxlength='10' class="whitetext" value='<%=AddUtil.ChangeDate2(gins.getGi_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title width=10%>????????</td>
                    <td width=40%>&nbsp;<input type='text' name='gi_etc' size='40' value='<%=gins.getGi_etc()%>' class='whitetext'></td>
    		    </tr>	
                <tr> 
                    <td rowspan="2" class=title width=10%>????????</td>
                    <td width=15%>&nbsp;
        			  <select name='guar_end_st'>
                          <option value="">????</option>
                          <option value="1" <%if(cont_etc.getGuar_end_st().equals("1")){%>selected<%}%>>????</option>
                          <option value="2" <%if(cont_etc.getGuar_end_st().equals("2")){%>selected<%}%>>????</option>
                        </select>
        			</td>
                    <td class=title width=10%>??????????</td>
                    <td width=15%>&nbsp;<input type='text' size='11' name='guar_est_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(cont_etc.getGuar_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title width=10%>????????</td>
                    <td width=40%>&nbsp;<input type='text' name='guar_etc' size='40' value='<%=cont_etc.getGuar_etc()%>' class='text'>
        			<%if(doc.getUser_id8().equals(user_id) || doc.getUser_id7().equals(user_id) || doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("??????",user_id)){%>
        			&nbsp;<a href="javascript:save('guar');"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
        			<%}%>
        			</td>
    		    </tr>			
    		    <tr>
        		    <td colspan="5">&nbsp;
        			?????? :
        			<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%>
        			????
        			<%}else{%>
        			????
        			<%}%>
        			 /
        			???????? :
        			<%if(cont_etc.getGuar_st().equals("1")){%>
        			???? (<%=gur_size%>)??
        			<%	if(gur_size > 0){
        		  			for(int i = 0 ; i < gur_size ; i++){
        						Hashtable gur = (Hashtable)gurs.elementAt(i);%>	
        					<%=gur.get("GUR_NM")%>&nbsp;
        					<%	}%>
        					
        			<%	}%>
        			<%}else{%>			
        			????
        			<%}%>
        			</td>
    		    </tr>  		
    		</table>
	    </td>
	</tr>  	    	  		
  	 
	<%if(vt_size>0){%>  
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<tr> 
        <td class=line2></td>
    </tr>   
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			tint_sup_est_dt = String.valueOf(ht.get("SUP_EST_DT"));
			tint_sup_dt 	= String.valueOf(ht.get("SUP_DT"));
	%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>			
                <tr>
                    <td width=10% class=title>????????</td>
                    <td width="15%">&nbsp;<%=ht.get("OFF_NM")%></td>
                    <td width="25%" class=title><span class="title">????????????????</span></td>
                    <td colspan="2"><span class="title">&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(ht.get("SUP_EST_DT")))%></span></td>
                </tr>				
                <tr> 
                    <td rowspan="2" class=title>????</td>
                    <td class=title>????</td>
                    <td class=title>??????</td>
                    <td width=25% class=title>??????????</td>
                    <td width=25% class=title>????</td>
                </tr>
                <tr>
                    <td>&nbsp;<%=ht.get("SUN_PER")%>%
                      <%if(String.valueOf(ht.get("FILM_ST")).equals("1")){%>
                      (????)
                      <%}%>
                      <%if(String.valueOf(ht.get("FILM_ST")).equals("2")){%>
                      (3M)
                      <%}%>
                      <%if(String.valueOf(ht.get("FILM_ST")).equals("3")){%>
                      (????)
                      <%}%>
					  <%if(String.valueOf(ht.get("FILM_ST")).equals("") && String.valueOf(ht.get("TINT_CAU")).equals("1") && pur.getCom_tint().equals("1")){%>
                      ??????????-<%if(pur.getCom_film_st().equals("1")){%>????<%}else if(pur.getCom_film_st().equals("2")){%>??????<%}%>????
                      <%}%>
                    </td>
                    <td>&nbsp;
                      <%if(String.valueOf(ht.get("CLEANER_ST")).equals("1")){%>
                      ????
                      <%}%>
					  <%if(String.valueOf(ht.get("CLEANER_ST")).equals("2") && String.valueOf(ht.get("TINT_CAU")).equals("1") && pur.getCom_tint().equals("2")){%>
                      ??????????-??????????
                      <%}%>
                      <%if(!String.valueOf(ht.get("CLEANER_ADD")).equals("")){%>
                      (<%=ht.get("CLEANER_ADD")%>)
                      <%}%>
                    </td>
                    <td>&nbsp; <%=ht.get("NAVI_NM")%>
                      <%if(!String.valueOf(ht.get("NAVI_EST_AMT")).equals("") && Long.parseLong(String.valueOf(ht.get("NAVI_EST_AMT")))>0){%>
                      (????:<%=AddUtil.parseDecimal(String.valueOf(ht.get("NAVI_EST_AMT")))%>)
                      <%}%>
                    </td>
                    <td>&nbsp;<%=ht.get("OTHER")%></td>
                </tr>
                <tr> 
                    <td class=title>????????????</td>
                    <td colspan='4'><%if(car.getTint_b_yn().equals("Y")){%>2???? ????????<%}%> 
                      &nbsp;
                      <%if(car.getTint_s_yn().equals("Y")){%>???? ????
                      &nbsp;
                                      ?????????????? : <%=car.getTint_s_per()%> %
                      <%}%>        	      
      		          &nbsp;
                      <%if(car.getTint_ps_yn().equals("Y")){%>???? ????
                      &nbsp;
                                      ???? : <%=car.getTint_ps_nm()%>, ???? : <%=AddUtil.parseDecimal(car.getTint_ps_amt())%>?? (??????????)
                      <%}%>
                      <%if(car.getTint_n_yn().equals("Y")){%>?????? ??????????<%}%>
                      &nbsp;
                      <%if(car.getTint_eb_yn().equals("Y")){%>?????? ??????<%}%>
                      &nbsp;
                      <%if(car.getTint_bn_yn().equals("Y")){%>???????? ?????? ???? (<%if(car.getTint_bn_nm().equals("1")){%>????????<%}else if(car.getTint_bn_nm().equals("2")){%>????????<%}else{%>????????,????????..<%}%>)<%}%> 
                      &nbsp;
                      <%if(car.getTint_cons_yn().equals("Y")){%>????????????
                      &nbsp;
                      <%=AddUtil.parseDecimal(car.getTint_cons_amt())%>??
                      <%}%> 
                      <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%>&nbsp;??????????????<%}%>
<%--                       <%if(car.getNew_license_plate().equals("1")){%>&nbsp;??????????????(??????)<%}%> --%>
<%--                       <%if(car.getNew_license_plate().equals("2")){%>&nbsp;??????????????(????/????/????/????)<%}%> --%>
                    </td>
                </tr>                  
                <%if(AddUtil.parseInt(String.valueOf(ht.get("REG_DT"))) < 20140801){%>
				<%if(!String.valueOf(ht.get("TOT_AMT")).equals("") && Long.parseLong(String.valueOf(ht.get("TOT_AMT")))>0){%>
                <tr>
                    <td class=title>????????</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("TINT_AMT")))%>??</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("CLEANER_AMT")))%>??</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("NAVI_AMT")))%>??</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%>??</td>
                </tr>
                <tr>
                    <td width=10% class=title>????????</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%>??</td>
                    <td class=title><span class="title">????????</span></td>
                    <td colspan="2"><span class="title">&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(ht.get("SUP_DT")))%></span></td>
                </tr>				
				<%}%>		
				<%if(!String.valueOf(ht.get("E_AMT")).equals("") && Long.parseLong(String.valueOf(ht.get("E_AMT")))>0){%>		
                <tr>
                    <td class=title>??????????????</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("E_AMT")))%>??</td>
                    <td colspan="3">??????????&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("E_SUB_AMT1")))%>?? ??????????&nbsp;<%=AddUtil.parseDecimal(String.valueOf(ht.get("E_SUB_AMT2")))%>??</td>
                </tr>
				<%}%>
		<%}%>
	        </table>
	    </td>
	</tr>  
	<%	}%>
	<%}else{%>
	<tr>
	    <td style='height:5'></td>
	</tr>	
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>????????????</td>
                    <td width='90%' >&nbsp;
                        <%if(car.getTint_b_yn().equals("Y")){%>2???? ????????<%}%> 
                      &nbsp;
                      <%if(car.getTint_s_yn().equals("Y")){%>???? ????
                      &nbsp;
                                      ?????????????? : <%=car.getTint_s_per()%> %
                      <%}%>        	      
      		          &nbsp;
                      <%if(car.getTint_ps_yn().equals("Y")){%>???? ????
                      &nbsp;
                                      ???? : <%=car.getTint_ps_nm()%>, ???? : <%=AddUtil.parseDecimal(car.getTint_ps_amt())%>?? (??????????)
                      <%}%>
                      <%if(car.getTint_n_yn().equals("Y")){%>?????? ??????????<%}%>
                      &nbsp;
                      <%if(car.getTint_eb_yn().equals("Y")){%>?????? ??????<%}%>
                      &nbsp;
                      <%if(car.getTint_bn_yn().equals("Y")){%>???????? ?????? ???? (<%if(car.getTint_bn_nm().equals("1")){%>????????<%}else if(car.getTint_bn_nm().equals("2")){%>????????<%}else{%>????????,????????..<%}%>)<%}%> 
                      &nbsp;
                      <%if(car.getTint_cons_yn().equals("Y")){%>????????????
                      &nbsp;
                      <%=AddUtil.parseDecimal(car.getTint_cons_amt())%>??
                      <%}%> 
                      <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%>&nbsp;??????????????<%}%>
<%--                       <%if(car.getNew_license_plate().equals("1")){%>&nbsp;??????????????(??????)<%}%> --%>
<%--                       <%if(car.getNew_license_plate().equals("2")){%>&nbsp;??????????????(????/????/????/????)<%}%> --%>
                    </td>
                </tr>
	      </table>
	    </td>
	</tr>   	
	<%}%>	
	  <input type='hidden' name="tint_sup_est_dt"	value="<%=tint_sup_est_dt%>">      
          <input type='hidden' name="tint_sup_dt"	value="<%=tint_sup_dt%>">      
          
	<%if(tint1.getTint_yn().equals("Y") || tint2.getTint_yn().equals("Y") || tint3.getTint_yn().equals("Y") || tint4.getTint_yn().equals("Y") || tint5.getTint_yn().equals("Y")){%>
	<tr>
	    <td> <span class=style2>????(??????/????)</span></td>
	</tr>  				                 	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan='2' class='title'>????????</td>
                    <td width='40%' >&nbsp;
                        <%if(tint1.getTint_yn().equals("Y")){%>??????<%}%>
                        <%if(tint1.getTint_yn().equals("Y") && tint2.getTint_yn().equals("Y")){%>+<%}%>
                        <%if(tint2.getTint_yn().equals("Y")){%>????<%}%>
                        <%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("N")){%>????????????<%}%>
                    </td>
                    <td colspan='2' class='title'>????????</td>
                    <td colspan='2' width='40%'>&nbsp;
                        <%=tint1.getOff_nm()%><%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("Y")){%><%=tint2.getOff_nm()%><%}%></td>
                </tr>
                <%if(tint1.getTint_yn().equals("Y") || tint2.getTint_yn().equals("Y")){%>
                <tr> 
                    <td rowspan='2' width='5%' class='title'>????????</td>
                    <td width='5%' class='title'>??????</td>
                    <td>&nbsp;
        		<%if(tint1.getFilm_st().equals("2")){%>3M
        		<%}else if(tint1.getFilm_st().equals("3")){%>????
        		<%}else if(tint1.getFilm_st().equals("5")){%>????????
        		<%}else if(tint1.getFilm_st().equals("6")){%>????
        		<%}else{%>????(<%=tint1.getFilm_st()%>)
        		<%}%>
                    </td>
                    <td rowspan='2' width='5%' class='title'>????????<br>??????</td>
                    <td width='5%' class='title'>??????</td>
                    <td>&nbsp;
                        <%=tint1.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td class='title'>????</td>
                    <td>&nbsp;
        		<%if(tint2.getFilm_st().equals("2")){%>3M
        		<%}else if(tint2.getFilm_st().equals("3")){%>????
        		<%}else if(tint2.getFilm_st().equals("5")){%>????????
        		<%}else if(tint2.getFilm_st().equals("6")){%>????
        		<%}else{%>????(<%=tint2.getFilm_st()%>)
        		<%}%>                    
                    </td>
                    <td class='title'>????</td>
                    <td>&nbsp;
                        <%=tint2.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td rowspan='2' width='5%' class='title'>????????</td>
                    <td width='5%' class='title'>??????</td>
                    <td>&nbsp;
        		<%if(tint1.getCost_st().equals("1")){%>????
        		<%}else if(tint1.getCost_st().equals("2")){%>????
        		<%}else if(tint1.getCost_st().equals("4")){%>????
        		<%}else if(tint1.getCost_st().equals("5")){%>????????
        		<%}%>                       
                    </td>
                    <td rowspan='2' width='5%' class='title'>????????</td>
                    <td width='5%' class='title'>??????</td>
                    <td>&nbsp;
        		<%if(tint1.getEst_st().equals("Y")){%>???? &nbsp;<%=AddUtil.parseDecimal(tint1.getEst_m_amt())%>??
        		<%}else if(tint1.getEst_st().equals("N")){%>??????
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td class='title'>????</td>
                    <td>&nbsp;
        		<%if(tint2.getCost_st().equals("1")){%>????
        		<%}else if(tint2.getCost_st().equals("2")){%>????
        		<%}else if(tint2.getCost_st().equals("4")){%>????
        		<%}else if(tint2.getCost_st().equals("5")){%>????????
        		<%}%>                                           
                    </td>
                    <td class='title'>????</td>
                    <td>&nbsp;
        		<%if(tint2.getEst_st().equals("Y")){%>???? &nbsp;<%=AddUtil.parseDecimal(tint2.getEst_m_amt())%>??
        		<%}else if(tint2.getEst_st().equals("N")){%>??????
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td rowspan='2' class='title'>????????</td>
                    <td class='title'>??????</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint1.getSup_est_dt())%>???? ??????</td>
                    <td rowspan='2' class='title'>????????</td>
                    <td class='title'>??????</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint1.getTint_amt())%>??</td>
                </tr>
                <tr> 
                    <td class='title'>????</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint2.getSup_est_dt())%>???? ??????</td>
                    <td class='title'>????</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint2.getTint_amt())%>??</td>
                </tr>
                <%}%>
            </table>
	</td>
    </tr>      
	<tr>
	    <td> <span class=style2>????????</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>????????</td>
                    <td width='40%' >&nbsp;
                        <%if(tint3.getTint_yn().equals("Y")){%>????<%}%>
                        <%if(tint3.getTint_yn().equals("N")){%>????????????<%}%>
                    </td>
                    <td width='10%' class='title'>????????</td>
                    <td width='40%'>&nbsp;
                        <%=tint3.getOff_nm()%></td>
                </tr>
                <%if(tint3.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>????????</td>
                    <td>&nbsp;
                        <%if(tint3.getModel_st().equals("1")){%>????????<%}%>
                        <%if(!tint3.getModel_st().equals("") && !tint3.getModel_st().equals("1")){%>????????????(<%=tint3.getModel_st()%>)<%}%>                    
                    </td>
                    <td class='title'>????????</td>
                    <td>&nbsp;
                        <%if(tint3.getChannel_st().equals("1")){%>1????<%}%>
                        <%if(tint3.getChannel_st().equals("2")){%>2????<%}%>                    
                    </td>
                </tr>
                <tr> 
                    <td class='title'>????????</td>
                    <td>&nbsp;
                        <%=tint3.getCom_nm()%></td>
                    <td class='title'>??????</td>
                    <td>&nbsp;
                        <%=tint3.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>????????</td>
                    <td>&nbsp;
        		<%if(tint3.getCost_st().equals("1")){%>????
        		<%}else if(tint3.getCost_st().equals("2")){%>????(????)
        		<%}else if(tint3.getCost_st().equals("3")){%>????(????)
        		<%}else if(tint3.getCost_st().equals("4")){%>????
        		<%}else if(tint3.getCost_st().equals("5")){%>????????
        		<%}%>                       
                    </td>
                    <td class='title'>????????</td>
                    <td>&nbsp;
        		<%if(tint3.getEst_st().equals("Y")){%>???? &nbsp;<%=AddUtil.parseDecimal(tint3.getEst_m_amt())%>??
        		<%}else if(tint3.getEst_st().equals("N")){%>??????
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>????????????????</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint3.getSup_est_dt())%>???? ??????
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>          	
	<tr>
	    <td> <span class=style2>??????????</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>????????</td>
                    <td width='40%' >&nbsp;
                        <%if(tint4.getTint_yn().equals("Y")){%>????<%}%>
                        <%if(tint4.getTint_yn().equals("N")){%>????????????<%}%>
                    </td>
                    <td width='10%' class='title'>????????</td>
                    <td width='40%'>&nbsp;
                        <%=tint4.getOff_nm()%></td>
                </tr>
                <%if(tint4.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>????????</td>
                    <td>&nbsp;
                        <%=tint4.getCom_nm()%></td>
                    <td class='title'>??????</td>
                    <td>&nbsp;
                        <%=tint4.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>????????</td>
                    <td>&nbsp;
        		<%if(tint4.getCost_st().equals("1")){%>????
        		<%}else if(tint4.getCost_st().equals("2")){%>????        		
        		<%}else if(tint4.getCost_st().equals("4")){%>????
        		<%}else if(tint4.getCost_st().equals("5")){%>????????
        		<%}%>                       
                    </td>
                    <td class='title'>????????</td>
                    <td>&nbsp;
        		<%if(tint4.getEst_st().equals("Y")){%>???? &nbsp;<%=AddUtil.parseDecimal(tint4.getEst_m_amt())%>??
        		<%}else if(tint4.getEst_st().equals("N")){%>??????
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>????????????????</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint4.getSup_est_dt())%>???? ??????
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>       	
	<tr>
	    <td> <span class=style2>????????</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>??????</td>
                    <td width='40%' >&nbsp;
                        <%=tint5.getCom_nm()%>&nbsp;<%=tint5.getModel_nm()%></td>
                    <td width='10%' class='title'>????????</td>
                    <td width='40%'>&nbsp;
                        <%=tint5.getOff_nm()%></td>
                </tr>
                <%if(!tint5.getModel_nm().equals("")){%>
                <tr> 
                    <td class='title'>????</td>
                    <td colspan='3'>&nbsp;
                        <%=tint5.getEtc()%></td>
                </tr>   
                <tr> 
                    <td class='title'>????????</td>
                    <td>&nbsp;
        		<%if(tint5.getCost_st().equals("1")){%>????
        		<%}else if(tint5.getCost_st().equals("2")){%>????        		
        		<%}else if(tint5.getCost_st().equals("4")){%>????
        		<%}else if(tint5.getCost_st().equals("5")){%>????????
        		<%}%>                       
                    </td>
                    <td class='title'>????????</td>
                    <td>&nbsp;
        		<%if(tint5.getEst_st().equals("Y")){%>???? &nbsp;<%=AddUtil.parseDecimal(tint5.getEst_m_amt())%>??
        		<%}else if(tint5.getEst_st().equals("N")){%>??????
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>????????????????</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint5.getSup_est_dt())%>???? ??????
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>
    <!-- ?????? ??????(??????) -->
    <%if(ej_bean.getJg_g_7().equals("3")){ %>
    <tr>
	    <td> <span class=style2>?????? ??????</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>????????</td>
                    <td width='40%' >&nbsp;
                        <%if(tint6.getTint_yn().equals("Y")){%>????<%}%>
                        <%if(tint6.getTint_yn().equals("N")){%>????????????<%}%>
                    </td>
                    <td width='10%' class='title'>????????</td>
                    <td width='40%'>&nbsp;
                        <%=tint6.getOff_nm()%></td>
                </tr>
                <%if(tint6.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>????????</td>
                    <td>&nbsp;
                        <%=tint6.getCom_nm()%></td>
                    <td class='title'>??????</td>
                    <td>&nbsp;
                        <%=tint6.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>????????</td>
                    <td>&nbsp;
        		<%if(tint6.getCost_st().equals("1")){%>????
        		<%}else if(tint6.getCost_st().equals("2")){%>????        		
        		<%}else if(tint6.getCost_st().equals("4")){%>????
        		<%}else if(tint6.getCost_st().equals("5")){%>????????
        		<%}%>                       
                    </td>
                    <td class='title'>????????</td>
                    <td>&nbsp;
        		<%if(tint6.getEst_st().equals("Y")){%>???? &nbsp;<%=AddUtil.parseDecimal(tint6.getEst_m_amt())%>??
        		<%}else if(tint6.getEst_st().equals("N")){%>??????
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>????????????????</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint6.getSup_est_dt())%>???? ??????
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>
    <%}%>    		
<%}%>
	          
	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 
	<tr> 
        <td class=line2></td>
    </tr> 	 	  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>             
            <td colspan='5'>&nbsp;
              <%if(String.valueOf(alink_lc_rent.get("RENT_L_CD")).equals(rent_l_cd)){%>[??????????]<%}%>
            </td>            
    		</tr>	                  
                <tr> 
                    <td class=title width=10%>????????</td>
                    <td>&nbsp;<%if(pur.getOne_self().equals("Y")){%>????????<%}else if(pur.getOne_self().equals("N")){%>????????????<%}%>
                    </td>
                    <td class=title width=10%>????????????</td>
                    <td colspan="2">&nbsp;<%=emp2.getCar_off_nm()%></td>
    		</tr>	                        
                <tr> 
                    <td class=title width=10%>????????</td>
                    <td>&nbsp;<%String pur_bus_st = pur.getPur_bus_st();%><%if(pur_bus_st.equals("1")){%>????????<%}else if(pur_bus_st.equals("2")){%>????????????<%}else if(pur_bus_st.equals("3")){%>????????<%}else if(pur_bus_st.equals("4")){%>????????<%}%>
                        <%if(!pur_bus_st.equals("4") && base.getBus_st().equals("7")){%>(????????)<%}%>
                    </td>
                    <td class=title width=10%>??????????</td>
                    <td colspan="2">&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%></td>
    		</tr>	                        
                <tr> 
                    <td class=title width=10%>????????</td>
                    <td width=30%>&nbsp;????????</td>
                    <td class=title width=10%>????</td>
                    <td class=title width=25%>????</td>
                    <td class=title width=25%>????</td>
    		    </tr>	
                <tr> 
                    <td class=title>????????</td>
                    <td>&nbsp;<input type='text' size='11' name='car_ft_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt()-car.getDc_cs_amt()-car.getDc_cv_amt())%>'>??</td>			
        			<td class=title>??????</td>		
                    <td>&nbsp;<input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum' <%if(!nm_db.getWorkAuthUser("??????",user_id)){%>readonly<%}%>>%</td>
                    <td>&nbsp;<input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='whitenum' <%if(!nm_db.getWorkAuthUser("??????",user_id)){%>readonly<%}else{%>onBlur='javascript:setCommi()'<%}%>>%</td>
    		    </tr>	
                <tr> 
                    <td class=title>????????????</td>
                    <td>&nbsp;<input type='text' size='11' name='commi_car_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">??
                    	(????????:<%=AddUtil.parseDecimal(commi_car_amt)%>??)
                    	
                    	<%
				content_code = "LC_SCAN";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+"1";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
						<br>
			    			<%	for (int j = 0 ; j < 1 ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='????' ><%=ht.get("FILE_NAME")%></a>
    						<%	}%>		
    						<%}%>    
                    </td>
        			<td class=title>????????</td>		
                    <td>&nbsp;<input type='text' size='11' name='comm_rt_amt' maxlength='11' class='whitenum' value=''>??</td>
                    <td>&nbsp;<input type='text' size='11' name='comm_r_rt_amt' maxlength='11' class='whitenum' value=''>??</td>
    		    </tr>
    		    <tr>
    		    	<td class=title width=10%>???????????? ????????</td>
    		    	<td colspan="4">&nbsp;<%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>????<%}else{%>????<%}%>
    		    	    &nbsp;<%if(cont_etc.getDir_pur_commi_yn().equals("Y")){%>:: ????????(????????????)<%}else if(cont_etc.getDir_pur_commi_yn().equals("N")){%>:: ????????(??????????????)<%}else if(cont_etc.getDir_pur_commi_yn().equals("2")){%>:: ??????????????????<%}%>
    		    	</td>
    		    </tr>
                <tr> 
                    <td class=title width=10%>????<br>(???????? ???? ?? ???????????? ???? ????)</td>
                    <td>&nbsp;<%=fee.getFee_cdt()%></td>
                    <td class=title width=10%>?????? ???????? ???? ????</td>
                    <td colspan="2">&nbsp;<%=fee_etc.getCon_etc()%></td>                    
    		</tr>	           		    
    		</table>
	    </td>
	</tr>  	
	<tr>
	    <td align="right">&nbsp;</td>
	<tr> 
	<tr>
	    <td style='background-color:#d5d5d5; height=1;'></td>
	</tr> 
	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 	          
	<tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<a href="javascript:view_emp('<%=emp1.getEmp_id()%>');"><%=emp1.getEmp_nm()%></a></td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%=emp1.getCar_off_nm()%></td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%if(coe_bean.getJob_st().equals("1")){%>??????<%}else if(coe_bean.getJob_st().equals("2")){%>????????<%}%>
        			<%if(coe_bean.getJob_st().equals("")){%>
        			<%if(coe_bean.getCust_st().equals("2")){%>????????<%}else if(coe_bean.getCust_st().equals("3")){%>??????<%}%>
        			<%}%>
        			</td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%if(coe_bean.getCust_st().equals("2")){%>????????<%}else if(coe_bean.getCust_st().equals("3")){%>????????????<%}%></td>
    		    </tr>	
    		    <tr>
        		    <td class=title>????</td>
        			<td colspan='7'><%=emp1.getCh_remark()%></td>
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
    <%if(a_co_bean.getDoc_st().equals("2")){ //????????-?????????? ??????%>
    <input type="hidden" name="rel" value="????????">
    <input type="hidden" name="rec_incom_yn" value="">
    <input type="hidden" name="rec_incom_st" value="">
    <input type="hidden" name="rec_ssn" value="<%=a_co_bean.getEnp_no()%>">
    <input type="hidden" name="emp_bank" value="<%=a_co_bean.getBank()%>">
    <input type="hidden" name="emp_bank_cd" value="<%=a_co_bean.getBank_cd()%>">
    <input type="hidden" name="emp_acc_no" value="<%=a_co_bean.getAcc_no()%>">
    <input type="hidden" name="emp_acc_nm" value="<%=a_co_bean.getAcc_nm()%>">
    <input type="hidden" name="t_zip" value="<%=a_co_bean.getCar_off_post()%>">
    <input type="hidden" name="t_addr" value="<%=a_co_bean.getCar_off_addr()%>">
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>??<br>??<br>??<br>??</td>
                    <td class=title width=7%>????/????</td>
                    <td width=15%>&nbsp;<%=a_co_bean.getCar_off_nm()%></td>
                    <td class=title width=10%>????</td>
                    <td width=15%>&nbsp;
                        <%if(a_co_bean.getCar_off_st().equals("3")){%>????<%}%>
                    	<%if(a_co_bean.getCar_off_st().equals("4")){%>??????????<%}%>
                    </td>
                    <td class=title width=10%>??????/????????</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeEnpH(a_co_bean.getEnp_no())%></td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;
        		<%if(a_co_bean.getDoc_st().equals("1")){%>????????<%}%>
                    	<%if(a_co_bean.getDoc_st().equals("2")){%>??????????<%}%>
                    </td>
		        </tr>	
                <tr> 
                    <td class=title>????????</td>
                    <td width=15%>&nbsp;<%=a_co_bean.getBank()%></td>
                    <td class=title width=10%>????????</td>
                    <td>&nbsp;<%=a_co_bean.getAcc_no()%></td>
                    <td class=title width=10%>??????</td>
                    <td colspan="3">&nbsp;<%=a_co_bean.getAcc_nm()%></td>                    
		</tr>	
                <tr> 
                    <td class=title>????</td>
                    <td colspan="7">&nbsp;<%=a_co_bean.getCar_off_post()%>
        			   &nbsp;<%=a_co_bean.getCar_off_addr()%></td>
		        </tr>	
		    </table>
	    </td>
	</tr> 
    <tr> 
        <td class=h></td>
    </tr>	 				 	 	    
    <%}else{%>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>??<br>
                      ??<br>
                      ??<br>
                    ??</td>
                    <td class=title width=7%>????????</td>
                    <td width=15%>&nbsp;<input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="12" class='text'>					  
					  <a href="javascript:search_bank_acc()"><span title="<%=emp1.getEmp_nm()%> ?????????? ?????????? ??????????."><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></span></a>					  
		    </td>
                    <td class=title width=10%>????</td>
                    <td width=15%>&nbsp;<input type='text' name="rel" value='<%=emp1.getRel()%>' size="16" class='text'></td>
                    <td class=title width=10%>??????</td>
                    <td width=15%>
        			  &nbsp;<select name="rec_incom_yn">
                        <option value="">==????==</option>
        				<option value="1" <%if(emp1.getRec_incom_yn().equals("1")){%> selected <%}%>>??</option>
        				<option value="2" <%if(emp1.getRec_incom_yn().equals("2")){%> selected <%}%>>??</option>							
        			  </select>
        			</td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>
        			  &nbsp;<select name="rec_incom_st" onchange="javascript:set_amt();">
                        <option value="">==????==</option>
        				<option value="2" <%if(emp1.getRec_incom_st().equals("2")){%> selected <%}%>>????????</option>
        				<option value="3" <%if(emp1.getRec_incom_st().equals("3")){%> selected <%}%>>????????????</option>							
        			  </select>
                    </td>
    		    </tr>	
                <tr> 
                    <td width=7% class=title>????????</td>
                    <td width=15%>&nbsp;
                    	<input type='hidden' name="emp_bank" 			value="<%=emp1.getEmp_bank()%>">
                    	<select name='emp_bank_cd'>
                        <option value=''>????</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												//?????????? ?????????? ????
																if(bank.getUse_yn().equals("N")){	 continue; }
        								%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                      </select></td>
                    <td class=title width=10%>????????</td>
                    <td colspan="3">&nbsp;<input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="30" class='text'></td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<input type='text' name="rec_ssn" value='<%=emp1.getRec_ssn()%>' size="16" class='text'></td>
    		    </tr>	
                <tr> 
                    <td width=7% class=title>????</td>
					<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
					<script>
						function openDaumPostcode() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip').value = data.zonecode;
									document.getElementById('t_addr').value = data.address;
									
								}
							}).open();
						}
					</script>
                    <td colspan="3">&nbsp;
						<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value='<%=emp1.getRec_zip()%>'>
						<input type="button" onclick="openDaumPostcode()" value="???????? ????"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="55" value='<%=emp1.getRec_addr()%>'>
					</td>
                    <td class=title width=10%>??????????</td>
                    <td width=15%>&nbsp;
                    	<%
				content_code = "COMMI";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+"1";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='????' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>   
    						<a href="javascript:scan_reg('1')"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;                                                                    
    						<%}%>                    
                        
                    </td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;
                    	<%
				content_code = "COMMI";
				content_seq  = rent_mng_id+""+rent_l_cd+"1"+"2";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='????' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%> 
    						<a href="javascript:scan_reg('2')"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;                                                                                          
    						<%}%>                    
                    
                        
                    </td>
    		</tr>	
   	    </table>
	    </td>
	</tr>  
    <tr> 
        <td>?? ???????? ???????? : ???????????? ???? ???????? ???? ?????? ???? ?????? ?????? ?????? ?????????? ?????? ?? ????????. ???? ?????????? ???????????? ?????????????? ?????????????? ??????(????????, ???????? ????).
?????? ???????????? ???????? ?? ?????? ???????????? ?????? ???? ????????.</td>
    </tr>
    <%}%>		
    <%if(base.getBus_st().equals("7") && cont_etc.getBus_agnt_id().equals("")){%>	  
	<%if(emp4.getEmp_id().equals("")){%>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>????????</td>
                    <td>&nbsp;<a href="javascript:reg_emp_proxy()"><img src=/acar/images/center/button_in_reg.gif border=0 align=absmiddle></a></td>
                </tr>	
    		</table>
	    </td>
	</tr>  	
	<%}else{%>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width=3% rowspan="3" class=title>??<br>??<br>??<br>??</td>
                    <td class=title width=7%>????????</td>
                    <td width=15%>&nbsp;<%=emp4.getEmp_acc_nm()%></td>
                    <td class=title width=10%>????</td>
                    <td width=15%>&nbsp;<%=emp4.getRel()%></td>
                    <td class=title width=10%>??????</td>
                    <td width=15%>&nbsp;<%if(emp4.getRec_incom_yn().equals("1")){%>??<%}else if(emp4.getRec_incom_yn().equals("2")){%>??<%}%></td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%if(emp4.getRec_incom_st().equals("2")){%>????????<%}else if(emp4.getRec_incom_st().equals("3")){%>????????????<%}%></td>
		</tr>	
                <tr> 
                    <td class=title>????????</td>
                    <td width=15%>&nbsp;<%=emp4.getEmp_bank()%></td>
                    <td class=title width=10%>????????</td>
                    <td colspan="3">&nbsp;<%=emp4.getEmp_acc_no()%></td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;<%=AddUtil.ChangeEnpH(emp4.getRec_ssn())%></td>
		        </tr>	
                <tr> 
                    <td class=title>????</td>
                    <td colspan="3">&nbsp;<%=emp4.getRec_zip()%>&nbsp;<%=emp4.getRec_addr()%></td>
                    <td class=title width=10%>??????????</td>
                    <td width=15%>&nbsp;
                    	<%
				content_code = "COMMI";
				content_seq  = rent_mng_id+""+rent_l_cd+"4"+"1";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='????' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}%>                      
                    
                        
                    </td>
                    <td class=title width=10%>????????</td>
                    <td width=15%>&nbsp;
                    	<%
				content_code = "COMMI";
				content_seq  = rent_mng_id+""+rent_l_cd+"4"+"2";

				attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();		                    	
                    	%>
                    	
						<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);    						
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='????' ><%=ht.get("FILE_NAME")%></a>
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}%>                      
                    
                        
                    </td>
		</tr>	
	    </table>
	    </td>
	</tr> 
	<%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	<tr>
	    <td align="right"><a href="javascript:update_emp_proxy()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>			
	<%}%>
	<%	}%>	
	<%}%>	
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>
	<%if(!emp4.getEmp_id().equals("")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>??????????</span></td>
	</tr>  		
	<%}%>		
	<tr> 
        <td class=line2></td>
    </tr>
    
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td colspan="2" class=title>????</td>
                    <td class=title width=12%>????</td>
                    <td class=title width=10%>????</td>
                    <td width=3% rowspan="<%if(a_co_bean.getDoc_st().equals("2")){%>7<%}else{%>9<%}%>" class=title>??<br>??<br></td>
                    <td class=title width=12%>????</td>
                    <td class=title width=10%>????</td>			
                    <td class=title width=50%>????</td>
                </tr>	
                <tr>
                    <td width="3%" rowspan="6" class=title><%if(a_co_bean.getDoc_st().equals("2")){%>??<br>??<br>??<br>??<br>??<br><%}else{%>??<br>
                      ??<br>??<br>??<br><%}%></td> 
                    <td width="10%" class=title>????????</td>
                    <td align="center"><input type='text' name='commi' maxlength='10' value='<%=Util.parseDecimal(emp1.getCommi())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;
        			  <select name="add_st1" onchange="javascript:set_amt()">
                        <option value="">==????==</option>
        				<option value="1" <%if(emp1.getAdd_st1().equals("1"))%>selected<%%>>????</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2" <%if(emp1.getAdd_st1().equals("2"))%>selected<%%>>????</option><%}%>							
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt1' maxlength='10' value='<%=Util.parseDecimal(emp1.getAdd_amt1())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                    <input name="add_cau1" type="text" class="text" value="<%=emp1.getAdd_cau1()%>" size="50"></td>
                </tr>
                <tr>
                    <td class=title style="font-size : 8pt;">????????????</td>
                    <td align="center"><input type='text' name='dlv_con_commi' id='dlv_con_commi' maxlength='8' value='<%=Util.parseDecimal(emp1.getDlv_con_commi())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td align="center">
                        <%//if( (cont_etc.getDlv_con_commi_yn().equals("Y") || cont_etc.getDir_pur_commi_yn().equals("Y") || cont_etc.getDir_pur_commi_yn().equals("2") || pur.getPur_bus_st().equals("2") || pur.getPur_bus_st().equals("4")) && pur.getOne_self().equals("Y") ){%>
                        <%if(cont_etc.getDlv_con_commi_yn().equals("Y") && pur.getOne_self().equals("Y")){ %>
                            <a href="javascript:dlv_con_commi();"><img src=/acar/images/center/button_sd_cg.gif align=absmiddle border=0 alt='????????????'></a>
                        <%}%>
                    </td>
                    <td align="center">&nbsp;
        			  <select name="add_st2" onchange="javascript:set_amt()">
                        <option value="">==????==</option>
        				<option value="1" <%if(emp1.getAdd_st2().equals("1")){%>selected<%}%>>????</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2" <%if(emp1.getAdd_st2().equals("2")){%>selected<%}%>>????</option><%}%>							
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt2' maxlength='10' value='<%=Util.parseDecimal(emp1.getAdd_amt2())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                    <input name="add_cau2" type="text" class="text" value="<%=emp1.getAdd_cau2()%>" size="50"></td>
                </tr>
                <tr>
                    <td class=title style="font-size : 8pt;">????????????????</td>
                    <td align="center"><input type='text' name='dlv_tns_commi' maxlength='8' value='<%=Util.parseDecimal(emp1.getDlv_tns_commi())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td align="center"><%if(pur.getPur_bus_st().equals("3") && (pur.getDlv_brch().equals("B2B??????????")||pur.getDlv_brch().equals("??????")||pur.getDlv_brch().equals("??????????")||pur.getDlv_brch().equals("??????????"))){%><a href="javascript:dlv_tns_commi();"><img src=/acar/images/center/button_sd_sjig.gif align=absmiddle border=0 alt='????????????????'></a><%}%></td>
                    <td align="center">&nbsp;
        			  <select name="add_st3" onchange="javascript:set_amt()">
                        <option value="">==????==</option>
        				<option value="1" <%if(emp1.getAdd_st3().equals("1")){%>selected<%}%>>????</option>
        				<%if(!a_co_bean.getDoc_st().equals("2")){%><option value="2" <%if(emp1.getAdd_st3().equals("2")){%>selected<%}%>>????</option><%}%>							
        			  </select>
        			</td>			
                    <td align="center"><input type='text' name='add_amt3' maxlength='10' value='<%=Util.parseDecimal(emp1.getAdd_amt3())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;
                    <input name="add_cau3" type="text" class="text" value="<%=emp1.getAdd_cau3()%>" size="50"></td>
                </tr>
    	       <tr>
                    <td class=title style="font-size : 8pt;">????????????</td>
                    <td align="center"><input type='text' name='agent_commi' maxlength='8' value='<%=Util.parseDecimal(emp1.getAgent_commi())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;-</td>			
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>                
                <tr>
                    <td class=title>??????????</td>
                    <td align="center"><input type='text' name='a_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;-</td>			
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>????</td>
                    <td align="center"><input type='text' name='b_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">-</td>			
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <%if(a_co_bean.getDoc_st().equals("2")){%>
                <tr>
                    <td colspan="2" class=title>VAT</td>
                    <td align="center"><input type='text' name='vat_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getVat_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                    <td align="center"><input type='text' name='vat_per' maxlength='3' value='<%=emp1.getVat_per()%>' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td width=3% class=title>????</td>
                    <td>&nbsp;</td>
                    <td align="center"><input type='text' name='add_tot_amt' maxlength='10' value='<%=Util.parseDecimal(emp1.getAdd_amt1()+emp1.getAdd_amt2()+emp1.getAdd_amt3())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;</td>                    
                </tr> 
                <input type="hidden" name="inc_amt" value="<%=Util.parseDecimal(emp1.getInc_amt())%>">
                <input type="hidden" name="inc_per" value="<%=emp1.getInc_per()%>">
                <input type="hidden" name="res_amt" value="<%=Util.parseDecimal(emp1.getRes_amt())%>">
                <input type="hidden" name="res_per" value="<%=emp1.getRes_per()%>">
                <input type="hidden" name="c_amt" value="<%=Util.parseDecimal(emp1.getTot_amt())%>">
                <input type="hidden" name="tot_per" value="<%=emp1.getTot_per()%>">
                <input type="hidden" name="e_amt" value="">
                <%}else{%>                     
                <tr>
                    <td rowspan="3" class=title>??<br>
                      ??<br>
                      ??<br>
                      ??</td>
                    <td class=title>??????</td>
                    <td align="center"><input type='text' name='inc_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getInc_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' set_amt();></td>
                    <td align="center"><input type='text' name='inc_per' maxlength='3' value='<%=emp1.getInc_per()%>' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>??????????</td>
                    <td align="center"><input type='text' name='res_amt' maxlength='8' value='<%=Util.parseDecimal(emp1.getRes_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);' set_amt();></td>
                    <td align="center"><input type='text' name='res_per' maxlength='3' value='<%=emp1.getRes_per()%>' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>????</td>
                    <td align="center"><input type='text' name='c_amt' maxlength='10' value='<%=Util.parseDecimal(emp1.getTot_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td align="center"><input type='text' name='tot_per' maxlength='3' value='<%=emp1.getTot_per()%>' class='num' size='3' onBlur='javascript:this.value=parseDecimal(this.value);'>%</td>
                    <td width=3% class=title>????</td>
                    <td align="center">-</td>			
                    <td align="center"><input type='text' name='add_tot_amt' maxlength='10' value='<%=Util.parseDecimal(emp1.getAdd_amt1()+emp1.getAdd_amt2()+emp1.getAdd_amt3())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'></td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2" class=title>??????????</td>
                    <td align="center"><input type='text' name='e_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
                    <td colspan="5">&nbsp;</td>
                </tr>
                <input type="hidden" name="vat_amt" value="<%=Util.parseDecimal(emp1.getVat_amt())%>">
                <input type="hidden" name="vat_per" value="<%=emp1.getVat_per()%>">
                <%}%>
                <tr>
                    <td colspan="2" class=title>????????</td>
                    <td align="center"><input type='text' name='d_amt' maxlength='10' value='' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                    <td colspan="5">&nbsp;???????? = ?????????? - ???????????? + ??????????</td>
                </tr>	
    		</table>
	    </td>
	</tr>  
	<%if(!emp4.getEmp_id().equals("")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>????????</span></td>
	</tr>  		
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td colspan="2" class=title>????</td>
                    <td class=title width=12%>????</td>
                    <td class=title width=10%>????</td>
                    <td width=3% rowspan="<%if(emp4.getInc_amt()==0 && emp4.getVat_amt()>0){%>4<%}else{%>6<%}%>" class=title>??<br>??<br></td>
                    <td class=title width=12%>????</td>
                    <td class=title width=10%>????</td>			
                    <td class=title width=40%>????</td>
                </tr>	
                <%
                	int tot_add1 = 0;
                	int tot_add2 = 0;
                	
                	if(emp4.getAdd_st1().equals("1")){ tot_add1 = tot_add1+emp4.getAdd_amt1(); }
                	if(emp4.getAdd_st2().equals("1")){ tot_add1 = tot_add1+emp4.getAdd_amt2(); }
                	if(emp4.getAdd_st3().equals("1")){ tot_add1 = tot_add1+emp4.getAdd_amt3(); }
                	if(emp4.getAdd_st1().equals("2")){ tot_add2 = tot_add2+emp4.getAdd_amt1(); }
                	if(emp4.getAdd_st2().equals("2")){ tot_add2 = tot_add2+emp4.getAdd_amt2(); }
                	if(emp4.getAdd_st3().equals("2")){ tot_add2 = tot_add2+emp4.getAdd_amt3(); }
                %>
                <tr> 
                    <td width="3%" rowspan="3" class=title>??<br>
                      ??<br>??<br>??<br></td>
                    <td width="10%" class=title>????????????</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getCommi())%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;<%if(emp4.getAdd_st1().equals("1")){%>????<%}%>
        				<%if(emp4.getAdd_st1().equals("2")){%>????<%}%>
        	    </td>			
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getAdd_amt1())%></td>
                    <td>&nbsp;<%=emp4.getAdd_cau1()%></td>
                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">??????????</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(tot_add1)%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;<%if(emp4.getAdd_st2().equals("1")){%>????<%}%>
        				<%if(emp4.getAdd_st2().equals("2")){%>????<%}%></td>			
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getAdd_amt2())%></td>
                    <td>&nbsp;<%=emp4.getAdd_cau2()%></td>

                </tr>
                <tr>
                  <td class=title style="font-size : 8pt;">????</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getCommi()+emp4.getAdd_amt1()+emp4.getAdd_amt2()+emp4.getAdd_amt3())%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;<%if(emp4.getAdd_st3().equals("1")){%>????<%}%>
        				<%if(emp4.getAdd_st3().equals("2")){%>????<%}%></td>			
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getAdd_amt3())%></td>
                    <td>&nbsp;<%=emp4.getAdd_cau3()%></td>
                </tr>
                <%if(emp4.getInc_amt()==0 && emp4.getVat_amt()>0){ // ?????????? ???????? ????%>
                <tr>
                    <td class=title>??????</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getVat_amt())%></td>
                    <td align="center">&nbsp;<%=emp4.getVat_per()%>%</td>
                    <td width=3% class=title>????</td>
                    <td>&nbsp;</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getAdd_amt1()+emp4.getAdd_amt2()+emp4.getAdd_amt3())%></td>
                    <td>&nbsp;</td>
                </tr>                
                <%}else{%>                
                <tr>
                    <td rowspan="3" class=title>??<br>??<br>??<br>??</td>
                    <td class=title>??????</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getInc_amt())%></td>
                    <td align="center">&nbsp;<%=emp4.getInc_per()%>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>??????</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getRes_amt())%></td>
                    <td align="center">&nbsp;<%=emp4.getRes_per()%>%</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class=title>????</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getTot_amt())%></td>
                    <td align="center">&nbsp;<%=emp4.getTot_per()%>%</td>
                    <td width=3% class=title>????</td>
                    <td>&nbsp;</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getAdd_amt1()+emp4.getAdd_amt2()+emp4.getAdd_amt3())%></td>
                    <td>&nbsp;</td>
                </tr>
                <%}%>
                <tr>
                    <td colspan="2" class=title>??????????</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(tot_add2)%></td>
                    <td colspan="5">&nbsp;  </td>
                </tr>
                <tr>
                  <td colspan="2" class=title>????????</td>
                  <td align="right">&nbsp;<%=Util.parseDecimal(emp4.getCommi()+tot_add1-emp4.getTot_amt()+tot_add2)%></td>
                  <td colspan="5">&nbsp;????????  = ?????????? -  ???????????? + ??????????</td>
                </tr>	
		    </table>
	    </td>
	</tr>  	
	<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	<tr>
	    <td align="right"><a href="javascript:update_emp_proxy()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>				
	<%}%>
	<%}%>	
	<%if(pur.getDlv_brch().equals("B2B??????????")||pur.getDlv_brch().equals("??????")||pur.getDlv_brch().equals("??????????")||pur.getDlv_brch().equals("??????????")){%>
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* ???????????? : ?????????????? ????????-???????? ?????????? ?????????????? ???? ????</span> </td>
	</tr>			  	
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* ???????????????? : ?????????????? ????????-???????? ?????????? ?????????? ???? ????</span> </td>
	</tr>
	<%}else{%>					 
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;</span> </td>
	</tr>
	<%}%>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>????????</td>
                    <td>&nbsp;
        			  
					<%	String email_1 = "";
						String email_2 = "";
						if(!coe_bean.getEmp_email().equals("")){
							int mail_len = coe_bean.getEmp_email().indexOf("@");
							if(mail_len > 0){
								email_1 = coe_bean.getEmp_email().substring(0,mail_len);
								email_2 = coe_bean.getEmp_email().substring(mail_len+1);
							}
						}
					%>						  
        			  ???????? : 
					  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
					  		    <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
								  <option value="" selected>??????????</option>
								  <option value="hanmail.net">hanmail.net</option>
								  <option value="naver.com">naver.com</option>
								  <option value="nate.com">nate.com</option>
								  <option value="bill36524.com">bill36524.com</option>
								  <option value="gmail.com">gmail.com</option>
								  <option value="paran.com">paran.com</option>
								  <option value="yahoo.com">yahoo.com</option>
								  <option value="korea.com">korea.com</option>
								  <option value="hotmail.com">hotmail.com</option>
								  <option value="chol.com">chol.com</option>
								  <option value="daum.net">daum.net</option>
								  <option value="hanafos.com">hanafos.com</option>
								  <option value="lycos.co.kr">lycos.co.kr</option>
								  <option value="dreamwiz.com">dreamwiz.com</option>
								  <option value="unitel.co.kr">unitel.co.kr</option>
								  <option value="freechal.com">freechal.com</option>
								  <option value="">???? ????</option>
							    </select>
						        <input type='hidden' name='emp_email' value='<%=coe_bean.getEmp_email()%>'>
					  <!--<input type='text' name='emp_email' size='30' value='<%=coe_bean.getEmp_email()%>' class='text'>-->&nbsp;
        			  ?? ?? ?? : <input type='text' name='emp_m_tel' size='13' value='<%=coe_bean.getEmp_m_tel()%>' class='text'>&nbsp;
					  <%if(doc.getDoc_step().equals("3")){%>
					  <%	if(nm_db.getWorkAuthUser("????????",user_id) || nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("????????????",user_id)){  %>
        			  <a href="javascript:doc_email()"><img src=/acar/images/center/button_in_s.gif align=absmiddle border=0></a>&nbsp;
        			  <a href="javascript:doc_email_view()"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
					  <%	}%>
        			  <%}%>
        			  <%if(!emp1.getSeqidx().equals("")){%>
        			  <hr>
        			  <%	Vector dmails = ImEmailDb.getMailHistoryList("4", rent_l_cd+"commi");
        					int dmail_size = dmails.size();
        					for(int i = 0 ; i < dmail_size ; i++){
        			      		Hashtable dmail = (Hashtable)dmails.elementAt(i);%>		
        			  			<%=AddUtil.ChangeDate3(String.valueOf(dmail.get("STIME")))%>&nbsp;&nbsp;<%=dmail.get("EMAIL")%>
        			  			<%if(i+1 < dmail_size){%><br><%}%>
        			  <%	}%>
        			  <%}%>
        			</td>
                </tr>	
				<%if(doc.getDoc_step().equals("3")){%>
					  <%	if(nm_db.getWorkAuthUser("????????",user_id) || nm_db.getWorkAuthUser("??????",user_id)){  %>
                <tr> 					
                    <td class=title width=10%>????????</td>
                    <td>&nbsp;
        			  <%if(emp1.getData_no().equals("")){%>
					        			  
        			  <%}else{%>
        			  <%=emp1.getSup_dt()%>&nbsp;(<%=emp1.getData_no()%>)
        			  <%}%>
        			</td>
                </tr>	
				<%	}%>
        			  <%}%>
    		</table>
	    </td>
	</tr>  	  		
	<tr>
	    <td style='height:18'><span class=style4>&nbsp;* ?????? ?????? ???? ???? ?????? ?????????????????? ?????? ??????????.</span> </td>
	</tr>			  		 	
	
	<%if(doc.getUser_dt8().equals("") || nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("??????????????????",user_id) || nm_db.getWorkAuthUser("??????????",user_id) || nm_db.getWorkAuthUser("????????????",user_id)){%>
	<tr>
	    <td align="right">&nbsp;</td>
	<tr> 
	<%		if((!doc.getDoc_step().equals("3") && !mode.equals("view")) || user_id.equals("000029") ){%> 	
    <tr>
	    <td align='center'>	 
	<%			if(  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	        <a href="javascript:save('');"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
	 <% 		} %>       
	    </td>
	</tr>			  
	<%		}%>
	<%}%>
	
	<%if(!emp1.getSup_dt().equals("") && nm_db.getWorkAuthUser("??????",user_id)){
		//????????
		String modify_deadline = emp1.getSup_dt();
		
		//???????????? ????25??
		if(emp1.getVat_amt() >0){
			modify_deadline = AddUtil.replace(c_db.addMonth(modify_deadline, 1),"-","").substring(0,6)+"25";	
		//???????????? ????10??	
		}else{
			modify_deadline = AddUtil.replace(c_db.addMonth(modify_deadline, 1),"-","").substring(0,6)+"10";
		}
		
		String today = AddUtil.getDate(4);
		
		if(AddUtil.parseInt(modify_deadline) < AddUtil.parseInt(today)){
	%>
    <tr>
	    <td align="right">&nbsp;</td>
	</tr>  
	<tr>
	    <td align='center'>
	    	<input type="button" class="button" value="?????????? ???????? ???? -> ???? ??????????" onclick="javascript:re_doc_sanction(6);">&nbsp;	    
	    </td>
	</tr>			  	
	<%}}%>
	<%if(emp1.getSup_dt().equals("") && doc.getDoc_step().equals("3") && nm_db.getWorkAuthUser("??????",user_id)){
	%>
    <tr>
	    <td align="right">&nbsp;</td>
	</tr>  
	<tr>
	    <td align='center'>
	    	<input type="button" class="button" value="?????? ????????????" onclick="javascript:re_doc_sanction(0);">&nbsp;	    
	    </td>
	</tr>			  	
	<%}%>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>  
	<tr> 
        <td class=line2></td>
    </tr> 	
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">????</td>
                    <td class=title width=15%>??????</td>
                    <td class=title width=18%><%=doc.getUser_nm1()%></td>
                    <td class=title width=18%><%=doc.getUser_nm2()%></td>
                    <td class=title width=18%><%=doc.getUser_nm3()%></td>
                    <td class=title width=21%><%=doc.getUser_nm4()%></td>
    		    </tr>	
                <tr> 
                    <td align="center"><%if(user_bean.getDept_id().equals("1000")){%><%=user_bean.getDept_nm()%><%}else{%><%=user_bean.getBr_nm()%><%}%></td>
                    <td align="center"><!--??????--><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%></td>
                    <td align="center"><!--??????--><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%>
        			  <%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("") && !doc.getUser_id2().equals("XXXXXX")){%>
        			  <%	String user_id2 = doc.getUser_id2();
        			  		CarScheBean cs_bean = csd.getCarScheTodayBean(user_id2);
        			  		if(!cs_bean.getWork_id().equals("")){ user_id2 = cs_bean.getWork_id();}
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals("")){
        						user_id2 = doc.getUser_id3();
        						CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);
        			  			if(!cs_bean2.getWork_id().equals("")){ user_id2 = cs_bean2.getWork_id(); }
        						if(!cs_bean2.getUser_id().equals("") && cs_bean2.getWork_id().equals("")){	user_id2 = "000004"; }//??????
        					}
        					%>
        			  <%	if(doc.getUser_id2().equals(user_id) || user_id2.equals(user_id) || nm_db.getWorkAuthUser("??????",user_id)){%>
        			    <a href="javascript:doc_sanction('2')"><img src=/acar/images/center/button_in_gj.gif align=absmiddle border=0></a>
        			  <%	}%>
        			  <br>&nbsp;
        			  <%}%>			
        			  </td>
                    <td align="center"><!--????????--><%=c_db.getNameById(doc.getUser_id3(),"USER_PO")%><br><%=doc.getUser_dt3()%>
        			  <%if(!doc.getUser_dt1().equals("") && doc.getUser_dt3().equals("") && !doc.getUser_id3().equals("XXXXXX")){%>
        			  <%	String user_id3 = doc.getUser_id3();
        			  		CarScheBean cs_bean = csd.getCarScheTodayBean(user_id3);
        			  		if(!cs_bean.getWork_id().equals("")){ user_id3 = cs_bean.getWork_id(); }
        					if(!cs_bean.getUser_id().equals("") && cs_bean.getWork_id().equals("")) {	user_id3 = "000004"; }//??????
        					%>			  
        			  <%	if(doc.getUser_id3().equals(user_id) || user_id3.equals(user_id) || nm_db.getWorkAuthUser("??????",user_id)){%>
        			    <a href="javascript:doc_sanction('3')"><img src=/acar/images/center/button_in_gj.gif align=absmiddle border=0></a>
        			  <%	}%><br>&nbsp;
        			  <%}%>
        			  </td>
                    <td align="center">&nbsp;<br>&nbsp;<br>&nbsp;<br></td>
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
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">????</td>
                    <td class=title width=15%><%=doc.getUser_nm6()%></td>
                    <td class=title width=18%><%=doc.getUser_nm7()%></td>
                    <td class=title width=18%><%=doc.getUser_nm8()%></td>
                    <td class=title width=18%>&nbsp;</td>
                    <td class=title width=21%><%=doc.getUser_nm9()%></td>
                </tr>	
                <tr> 
                    <td align="center"><!--??????????--><%=c_db.getNameById(doc.getUser_id6(),"USER_PO")%><br><%=doc.getUser_dt6()%>
        			  <%if(doc.getUser_dt6().equals("")){%>
        			  <%	String user_id6 = doc.getUser_id6();
        			  		CarScheBean cs_bean = csd.getCarScheTodayBean(user_id6);
        			  		if(!cs_bean.getUser_id().equals("")){ 	user_id6 = cs_bean.getWork_id(); }
        			  %>
        			  <%	if(doc.getUser_id6().equals(user_id) || user_id6.equals(user_id) || nm_db.getWorkAuthUser("??????",user_id)  || nm_db.getWorkAuthUser("??????????????",user_id)  || nm_db.getWorkAuthUser("??????????",user_id) || nm_db.getWorkAuthUser("????????????",user_id) || nm_db.getWorkAuthUser("????????????????",user_id) || nm_db.getWorkAuthUser("????????????????",user_id)){%>
        			    <a href="javascript:doc_sanction('6')"><img src=/acar/images/center/button_in_gj.gif align=absmiddle border=0></a>        			    
        			    <br>&nbsp;<br><a href="javascript:doc_id_cng('6', '<%=doc.getUser_id6()%>');" onMouseOver="window.status=''; return true" onFocus="this.blur()">.</a>        			    
        			  <%	}%>
        			  <br>&nbsp;
        			  <%}%>        			  
        			  
        			</td>
                    <td align="center"><!--??????????--><%=c_db.getNameById(doc.getUser_id7(),"USER_PO")%><br><%=doc.getUser_dt7()%>
        			  <%if(!doc.getUser_dt6().equals("") && doc.getUser_dt7().equals("")){%>
        			  <%	String user_id7 = doc.getUser_id7();
        			  		CarScheBean cs_bean = csd.getCarScheTodayBean(user_id7);
							if(!cs_bean.getUser_id().equals("")){ 	user_id7 = cs_bean.getWork_id(); }
        			  %>
        			  <%	if(doc.getUser_id7().equals(user_id) || user_id7.equals(user_id) || nm_db.getWorkAuthUser("??????",user_id)  || nm_db.getWorkAuthUser("??????????????????",user_id) || nm_db.getWorkAuthUser("??????????????",user_id) || nm_db.getWorkAuthUser("??????????",user_id) || nm_db.getWorkAuthUser("??????????",user_id) || nm_db.getWorkAuthUser("??????????",user_id)){%>
        			    <a href="javascript:doc_sanction('7')"><img src=/acar/images/center/button_in_gj.gif align=absmiddle border=0></a>        			    
        			    <br>&nbsp;<br><a href="javascript:doc_id_cng('7', '<%=doc.getUser_id7()%>');" onMouseOver="window.status=''; return true" onFocus="this.blur()">.</a>        			    
        			  <%	}%>
        			  <br>&nbsp;
        			  <%}%>
        			  
        			</td>
                    <td align="center"><!--????--><%=c_db.getNameById(doc.getUser_id8(),"USER_PO")%><br><%=doc.getUser_dt8()%>
					  <%if(!doc.getUser_id8().equals("XXXXXX")){%>
        			  <%if(!doc.getUser_dt7().equals("") && doc.getUser_dt8().equals("")){%>
        			  <%	String user_id8 = doc.getUser_id8();
        			  		CarScheBean cs_bean = csd.getCarScheTodayBean(user_id8);
        			  		if(!cs_bean.getWork_id().equals("")){ user_id8 = cs_bean.getWork_id(); }
        					%>
        			  <%	if(doc.getUser_id8().equals(user_id) || user_id8.equals(user_id) || nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("????????????",user_id) || nm_db.getWorkAuthUser("??????????????", user_id)){%>
        			    <a href="javascript:doc_sanction('8')"><img src=/acar/images/center/button_in_gj.gif align=absmiddle border=0></a>        			    
        			    
        			    <%		if(nm_db.getWorkAuthUser("??????",user_id)  || nm_db.getWorkAuthUser("??????????????",user_id)  || nm_db.getWorkAuthUser("??????????",user_id) || nm_db.getWorkAuthUser("????????????",user_id) || nm_db.getWorkAuthUser("????????????????",user_id) || nm_db.getWorkAuthUser("????????????????",user_id)){%>
        			    <br>&nbsp;<br><a href="javascript:doc_id_cng('8', '<%=doc.getUser_id8()%>');" onMouseOver="window.status=''; return true" onFocus="this.blur()">.</a>        			    
        			    <%		}%>
        			  <%	}%>
        			  <br>&nbsp;
        			  <%}%>
					  <%}else{%>-<%}%>
        			</td>
                    <td align="center">&nbsp;<br>&nbsp;<br>&nbsp;<br></td>
                    <td align="center">&nbsp;</td>
    		    </tr>	
    		</table>
	    </td>
	</tr>  	  
	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 	
	
    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>	
	<tr>
	    <td style='background-color:#d5d5d5; height=1;'></td>
	<tr>  
	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 
	<tr> 
        <td class=line2></td>
    </tr> 	
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10% rowspan="3">????</td>
                    <td class=title colspan="4">????????</td>
                    <td class=title colspan="3">????(????????)</td>
    		    </tr>	
                <tr> 
                    <td class=title width=15%>????????</td>
                    <td class=title width=10%>????????</td>
                    <td class=title width=15%>????????????</td>
                    <td class=title width=10%>????</td>
                    <td class=title width=15%>????????</td>
                    <td class=title width=10%>????????</td>
                    <td class=title width=15%>????(????????????)</td>
    		    </tr>	
                <tr> 
                    <td align="center"><input type='text' name='now_val1' value='' class='whitenum' size='10'></td>
                    <td align="center"><input type='text' name='now_val2' value='' class='whitenum' size='10'></td>
                    <td align="center"><input type='text' name='now_val3' value='' class='whitenum' size='10'></td>
                    <td align="center"><input type='text' name='now_val4' value='' class='whitenum' size='10'></td>
                    <td align="center"><input type='text' name='old_val1' value='' class='whitenum' size='10'></td>
                    <td align="center"><input type='text' name='old_val2' value='' class='whitenum' size='10'></td>
                    <td align="center"><input type='text' name='old_val3' value='' class='whitenum' size='10'></td>
    		    </tr>	
    		</table>
	    </td>
	</tr>  	  
    <tr>
	    <td align='center'>&nbsp;</td>
	</tr>	
	<%	int now_val1 = 0;
		long now_val2 = 0;
		long now_val3 = 0;
		int now_val4 = 0;
		int old_val1 = 0;
		long old_val2 = 0;
	%>
	<%if(commi_size > 0){%>
	<tr> 
        <td class=line2></td>
    </tr>
	<tr>
	    <td class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
    		    <tr>
                    <td class=title width=4%>????</td>
                    <td class=title width=10%>????????</td>
                    <td class=title width=15%>????</td>
                    <td class=title width=9%>????????</td>			
                    <td class=title width=8%>????????</td>
                    <td class=title width=4%>??????</td>
                    <td class=title width=9%>????????</td>
                    <td class=title width=7%>????????</td>
                    <td class=title width=7%>??????</td>
                    <td class=title width=6%>??????</td>
                    <td class=title width=7%>??????</td>
                    <td class=title width=4%>????</td>
                    <td class=title width=10%>????????</td>																								
    		    </tr>
    		
              <%long commi_total_amt	= 0;
			  	
			  	for(int i = 0 ; i < commi_size ; i++){
    				Hashtable commi = (Hashtable)commis.elementAt(i);
    				int car_commi_amt= AddUtil.parseInt(String.valueOf(commi.get("COMMI_CAR_AMT")));
    				int commi_amt	= AddUtil.parseInt(String.valueOf(commi.get("COMMI")));
    				int add_amt 	= AddUtil.parseInt(String.valueOf(commi.get("ADD_AMT1")))+AddUtil.parseInt(String.valueOf(commi.get("ADD_AMT2")))+AddUtil.parseInt(String.valueOf(commi.get("ADD_AMT3")));
    				int tot_amt 	= AddUtil.parseInt(String.valueOf(commi.get("TOT_AMT")));
    				int inc_amt 	= AddUtil.parseInt(String.valueOf(commi.get("INC_AMT")));
    				int res_amt 	= AddUtil.parseInt(String.valueOf(commi.get("RES_AMT")));
    				int vat_amt 	= AddUtil.parseInt(String.valueOf(commi.get("VAT_AMT")));
    				int dif_amt 	= AddUtil.parseInt(String.valueOf(commi.get("DIF_AMT")));
    				String tax_per	= String.valueOf(commi.get("TOT_PER"));
				if(tax_per.equals("")){
					tax_per	= AddUtil.parseFloatCipher2((float)tot_amt/(commi_amt+add_amt)*100,1);
					if(tax_per.equals("3.2")){ tax_per = "3.3"; }
					if(tax_per.equals("5.4")){ tax_per = "5.5"; }
				}    				
    				String dlv_dt 	= String.valueOf(commi.get("DLV_DT"));
    				if(dlv_dt.length()>0){
    					if(dlv_dt.substring(0,4).equals(AddUtil.getDate(1))){
    						now_val1 = now_val1 + 1;
    						if(!String.valueOf(commi.get("SUP_DT")).equals("")){
    							now_val2 = now_val2 + Long.parseLong(String.valueOf(commi.get("DIF_AMT")));
    						}else{
    							now_val3 = now_val3 + Long.parseLong(String.valueOf(commi.get("DIF_AMT")));
    						}
    					}else{
    						old_val1 = old_val1 + 1;
    						old_val2 = old_val2 + Long.parseLong(String.valueOf(commi.get("DIF_AMT")));
    					}
    				}
					commi_total_amt 	= commi_total_amt + Long.parseLong(String.valueOf(commi.get("COMMI")));
    				%>
                <tr> 
                    <td align='center'><%=commi_size-i%></td>
                    <td align='center'><%=commi.get("RENT_L_CD")%></td>
                    <td align='left'><span title='<%=commi.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(commi.get("FIRM_NM")), 5)%></span></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(commi.get("SUP_DT")))%></td>			
                    <td align='right'><%=Util.parseDecimal(car_commi_amt)%></td>		
                    <td align='center'><%=commi.get("COMM_R_RT")%></td>
                    <td align='right'><%=Util.parseDecimal(commi_amt)%></td>
                    <td align='right'><%=Util.parseDecimal(add_amt)%></td>
                    <td align='right'><%=Util.parseDecimal(inc_amt)%></td>
                    <td align='right'><%=Util.parseDecimal(res_amt)%></td>
                    <td align='right'><%=Util.parseDecimal(vat_amt)%></td>
                    <td align='center'><%=tax_per%></td>
                    <td align='right'><%=Util.parseDecimal(dif_amt)%></td>												
                </tr>
              <%}%>
			  <tr>
			    <td colspan="6" class=title>&nbsp;</td>
			    <td class=title style='text-align:right'><%=Util.parseDecimalLong(commi_total_amt)%></td>
			    <td colspan="6" class=title>&nbsp;</td>				
			  </tr>
            </table>
	    </td>
	<tr>  	
	<%}%>
</table>
</form>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	
	fm.comm_rt_amt.value 	= parseDecimal(th_round(toInt(parseDigit(fm.commi_car_amt.value))*toFloat(fm.comm_rt.value)/100));
	fm.comm_r_rt_amt.value 	= parseDecimal(th_round(toInt(parseDigit(fm.commi_car_amt.value))*toFloat(fm.comm_r_rt.value)/100));

	
	fm.now_val1.value = '<%=now_val1%>';
	fm.now_val2.value = '<%=Util.parseDecimalLong(now_val2)%>';
	fm.now_val3.value = '<%=Util.parseDecimalLong(now_val3)%>';
	fm.now_val4.value = '<%=Util.parseDecimalLong(now_val2+now_val3)%>';
	fm.old_val1.value = '<%=old_val1%>';
	fm.old_val2.value = '<%=Util.parseDecimalLong(old_val2)%>';
	fm.old_val3.value = '<%=d_db.getCommiEmpRank(emp1.getEmp_id())%>';		
	
	var tot_add1 = 0;//??????????
	var tot_add2 = 0;//??????????
	if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt1.value));
	if(toInt(parseDigit(fm.add_amt1.value)) != 0 && fm.add_st1.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt1.value));
	if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt2.value));
	if(toInt(parseDigit(fm.add_amt2.value)) != 0 && fm.add_st2.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt2.value));
	if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '1')	tot_add1 = tot_add1 + toInt(parseDigit(fm.add_amt3.value));
	if(toInt(parseDigit(fm.add_amt3.value)) != 0 && fm.add_st3.value == '2')	tot_add2 = tot_add2 + toInt(parseDigit(fm.add_amt3.value));
	
	fm.a_amt.value = parseDecimal(tot_add1);
	fm.b_amt.value = parseDecimal(toInt(parseDigit(fm.commi.value)) + toInt(parseDigit(fm.dlv_con_commi.value)) + toInt(parseDigit(fm.dlv_tns_commi.value)) + toInt(parseDigit(fm.a_amt.value)) + toInt(parseDigit(fm.agent_commi.value))); 										
	fm.e_amt.value = parseDecimal(tot_add2);
	
	<%if(a_co_bean.getDoc_st().equals("2")){%>
		fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.b_amt.value)) + toInt(parseDigit(fm.c_amt.value)) + toInt(parseDigit(fm.e_amt.value))); 
	<%}else{%>
		fm.d_amt.value = parseDecimal(toInt(parseDigit(fm.b_amt.value)) - toInt(parseDigit(fm.c_amt.value)) + toInt(parseDigit(fm.e_amt.value))); 
	<%}%>
	
	//????????
	var s_fm = parent.top_menu.document.form1;
	s_fm.auth_rw.value 		= fm.auth_rw.value;
	s_fm.user_id.value 		= fm.user_id.value;
	s_fm.br_id.value 		= fm.br_id.value;		
	s_fm.m_id.value 		= fm.rent_mng_id.value;
	s_fm.l_cd.value 		= fm.rent_l_cd.value;	
	s_fm.c_id.value 		= "<%=base.getCar_mng_id()%>";
	s_fm.client_id.value 		= "<%=base.getClient_id()%>";	
	s_fm.accid_id.value 		= "";
	s_fm.serv_id.value 		= "";
	s_fm.seq_no.value 		= "";			
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

