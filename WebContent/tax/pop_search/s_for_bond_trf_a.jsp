<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, acar.client.*, acar.insur.*, acar.cont.* "%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="oa_bean" class="acar.accid.OtAccidBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String d_c_id 		= request.getParameter("d_c_id")==null?"":request.getParameter("d_c_id");
	String accid_id 	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String rent_s_cd 	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	
	
	AddClientDatabase ac_db = AddClientDatabase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	
	Vector accids = null;
	Vector cars = null;
	Hashtable cons 	= null;
	Hashtable client1 = null;
	Hashtable client2 = null;
	Hashtable client3 = null;
	MyAccidBean ma_bean = null;
	InsurBean ins = null;
	int accid_size = 0;
	int car_size = 0;
	int cons_size = 0;
	int client1_size = 0;
	int client2_size = 0;
	int client3_size = 0;
	String ins_st = "";
	
	//대차조회
	cars = as_db.getRentContCarPop(c_id, rent_s_cd);
	//보험정보
	ins_st = ai_db.getInsSt(c_id);
	ins = ai_db.getIns(c_id, ins_st);
	car_size = cars.size();
	if(car_size > 0){
		for (int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);
			client1 = ac_db.getClientOne(String.valueOf(car.get("CUST_ID")));
			client1_size = client1.size();
		}
	}
	
	//사고조회
	//accids = as_db.getAccidSListPop(d_c_id, accid_id);
	accids = as_db.getAccidentListPop(d_c_id, "", accid_id);
	accid_size = accids.size();
	if(accid_size > 0){
		
		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);
			client2 = ac_db.getClientOne(String.valueOf(accid.get("CLIENT_ID")));
			client2_size = client2.size();
		}
	}
	//상대차량 인적사항
	OtAccidBean oa_r [] = as_db.getOtAccid(d_c_id, accid_id);
	if(oa_r.length > 0){
    	oa_bean = oa_r[0];	
	}
	//보험청구내역(휴차/대차료)
	ma_bean = as_db.getMyAccid(d_c_id, accid_id);
	
	//탁송조회
	cons = as_db.getConsForAccidPop(c_id);
	cons_size = cons.size();
	if(cons_size > 0){
		client3 = ac_db.getClientOne(String.valueOf(cons.get("CUST_ID")));
		client3_size = client3.size();
	}
	
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<script type="text/javascript" src='/include/common.js'></script>
<script>
 function process(){
	var fm1 = document.form1;
	var fm2 = document.form2;
	var fm3 = document.form3;
	var o_fm = opener.form1;
	var o_o_fm = opener.opener.form1;
	var car_size = '<%=car_size%>';
	var accid_size = '<%=accid_size%>';
	var cons_size = '<%=cons_size%>';
	o_fm.s_dt1.value = "";
	o_fm.e_dt1.value = "";
	o_fm.s_dt2.value = "";
	o_fm.e_dt2.value = "";
	o_fm.s_dt3.value = "";
	o_fm.e_dt3.value = "";
	
 	if(car_size > 0){	
		
		o_fm.ac_rent_mng_id.value 	= fm1.rent_mng_id.value;
		o_fm.ac_rent_l_cd.value 		= fm1.rent_l_cd.value;
	//	o_fm.ins_com_id.value 		= fm1.ins_com_id.value;
	//	o_fm.ins_com_nm.value 		= fm1.ins_com_nm.value;
		o_fm.ac_client_id.value 		= fm1.client_id.value;
		o_fm.ac_client_st.value 		= fm1.client_st.value;
		o_fm.ac_client_nm.value 		= fm1.client_nm.value;
		o_fm.ac_firm_nm.value 		= fm1.firm_nm.value;
		if(fm1.client_st.value=='2'){	o_fm.ac_birth.value = fm1.birth.value.substr(0,6); 	}
		o_fm.ac_enp_no.value 			= fm1.enp_no.value;
		o_fm.ac_zip.value 				= fm1.zip.value;
		o_fm.ac_addr.value 				= fm1.addr.value;
		o_fm.ac_car_mng_id.value 	= fm1.c_id.value;
		o_fm.ac_car_st						= fm1.car_st.value;
		o_fm.ac_car_no.value	 		= fm1.car_no.value;
		o_fm.ac_car_nm.value	 		= fm1.car_nm.value;
	//	o_fm.sch_ac_car_no.value 	= fm1.car_no.value;
	//	o_fm.sch_ac_c_id.value 		= fm1.c_id.value;
		o_fm.s_dt1.value	 				= fm1.s_dt1.value;
		o_fm.e_dt1.value	 				= fm1.e_dt1.value;
		
 	}
 	
 	if(accid_size > 0){
 		
 		if(fm1.client_id.value =='' || fm1.client_id.value == fm2.client_id.value){
			o_fm.ac_client_id.value 	= fm2.client_id.value;
			o_fm.ac_client_st.value 	= fm2.client_st.value;
			o_fm.ac_client_nm.value 	= fm2.client_nm.value;
			o_fm.ac_firm_nm.value 		= fm2.firm_nm.value;
			if(fm2.client_st.value=='2'){	o_fm.ac_birth.value = fm2.birth.value.substr(0,6); 	}
			o_fm.ac_enp_no.value 		= fm2.enp_no.value;
			o_fm.ac_zip.value 			= fm2.zip.value;
			o_fm.ac_addr.value 			= fm2.addr.value;
 		}
		if(fm1.c_id.value =='' || fm1.c_id.value == fm2.c_id.value){
			o_fm.ac_rent_mng_id.value 	= fm2.rent_mng_id.value;
			o_fm.ac_rent_l_cd.value 		= fm2.rent_l_cd.value;	
			o_fm.ac_car_mng_id.value 	= fm2.c_id.value;
			o_fm.ac_car_no.value	 		= fm2.car_no.value;
			o_fm.ac_car_nm.value	 		= fm2.car_nm.value;
			o_fm.ac_accid_id.value 		= fm2.accid_id.value;
		//	if(fm1.ins_com_id.value==""){	o_fm.ins_com_id.value 		= fm2.ins_com_id.value;	}
			o_fm.ins_com_nm.value 		= fm2.ins_com_nm.value;	
			if(fm2.ins_req_amt.value!=''&&fm2.ins_req_amt.value!='null'){	o_fm.ins_req_amt.value = fm2.ins_req_amt.value;	}
			o_fm.accid_dt.value 				= fm2.accid_dt.value;
			o_fm.ac_ot_fault_per.value 	= fm2.ot_fault_per.value;
			o_fm.ins_day_amt.value 		= fm2.ins_day_amt.value;
 		}
	//	o_fm.ins_use_st.value		= fm2.i_start_dt.value;
	//	o_fm.use_st_h.value			= fm2.i_start_h.value;
	//	o_fm.use_st_s.value			= fm2.i_start_s.value;
	//	o_fm.ins_use_et.value		= fm2.i_end_dt.value;
	//	o_fm.use_et_h.value			= fm2.i_end_h.value;
	//	o_fm.use_et_s.value			= fm2.i_end_s.value;
		o_fm.s_dt2.value	 					= fm2.s_dt2.value;
		o_fm.e_dt2.value	 					= fm2.e_dt2.value;	
	}
 	if(cons_size > 0){
		o_fm.s_dt3.value	 		= fm3.s_dt3.value;
		for(var i=0; i<=1; i++){
			if(o_o_fm.cons_cau[i].value=="10"){
				o_fm.e_dt3.value = o_o_fm.from_req_dt[i].value.replace(/-/gi,"")+""+o_o_fm.from_req_h[i].value+""+o_o_fm.from_req_s[i].value;
			}
		}
	}
	opener.view_use_dt();
	self.close();
 }
 
</script>
</head>
<body onload="javascript:process();">
	<form name='form1' action='' method='post' target='d_content'>
	<%if(car_size > 0){	//대차정보
		for (int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);
			//계약기본정보
			ContBaseBean base1 = a_db.getCont(String.valueOf(car.get("RENT_MNG_ID")), String.valueOf(car.get("SUB_L_CD")));
	%>
			<input type='hidden' name='rent_mng_id' value='<%=car.get("RENT_MNG_ID")%>'>
			<input type='hidden' name='rent_l_cd' value='<%=car.get("SUB_L_CD")%>'>
			<%-- <input type='hidden' name='ins_com_id' value='<%=ins.getIns_com_id()%>'> --%>
			<%-- <input type='hidden' name='ins_com_nm' value='<%=ins.getIns_com_nm()%>'> --%>
			<input type='hidden' name='client_id' value='<%=client1.get("CLIENT_ID")%>'>
			<input type='hidden' name='client_st' value='<%=client1.get("CLIENT_ST")%>'>
			<input type='hidden' name='client_nm' value='<%=client1.get("CLIENT_NM")%>'>
			<input type='hidden' name='firm_nm' value='<%=client1.get("FIRM_NM")%>'>
			<input type='hidden' name='birth' value='<%=client1.get("SSN")%>'>
			<input type='hidden' name='enp_no' value='<%=client1.get("ENP_NO")%>'>
			<input type='hidden' name='zip' value=
				<%if(String.valueOf(client1.get("CLIENT_ST")).equals("1")){//법인 - 1순:사업장주소 2순:본점소재지 %>
					<%if(!String.valueOf(client1.get("O_ADDR")).equals("")){ %>
						'<%=client1.get("O_ZIP") %>'
					<%}else{ %>
						'<%=client1.get("HO_ZIP") %>'
					<%}%>
				<%}else if(String.valueOf(client1.get("CLIENT_ST")).equals("2")){//개인 - 1순:자택주소 2순:우편물주소 %>
					<%if(!String.valueOf(client1.get("HO_ADDR")).equals("")){ %>
						'<%=client1.get("HO_ZIP") %>'
					<%}else{%>
						'<%=base1.getP_zip()%>'
					<%}%>
				<%}else{//개인사업자 - 1순:사업장주소 2순:우편물주소 %>
					<%if(!String.valueOf(client1.get("O_ADDR")).equals("")){ %>
						'<%=client1.get("O_ZIP") %>'
					<%}else{%>
						'<%=base1.getP_zip()%>'
					<%}%>
				<%}%>
			<%-- <%=client1.get("O_ZIP")%> --%>
			>
			<input type='hidden' name='addr' value=
				<%if(String.valueOf(client1.get("CLIENT_ST")).equals("1")){//법인 - 1순:사업장주소 2순:본점소재지 %>
					<%if(!String.valueOf(client1.get("O_ADDR")).equals("")){ %>
						'<%=client1.get("O_ADDR") %>'
					<%}else{ %>
						'<%=client1.get("HO_ADDR") %>'
					<%}%>
				<%}else if(String.valueOf(client1.get("CLIENT_ST")).equals("2")){//개인 - 1순:자택주소 2순:우편물주소 %>
					<%if(!String.valueOf(client1.get("HO_ADDR")).equals("")){ %>
						'<%=client1.get("HO_ADDR") %>'
					<%}else{%>
						'<%=base1.getP_addr()%>'
					<%}%>
				<%}else{//개인사업자 - 1순:사업장주소 2순:우편물주소 %>
					<%if(!String.valueOf(client1.get("O_ADDR")).equals("")){ %>
						'<%=client1.get("O_ADDR") %>'
					<%}else{%>
						'<%=base1.getP_addr()%>'
					<%}%>
				<%}%>
				<%-- <%=client1.get("O_ADDR")%> --%>
			'>
			<input type='hidden' name='c_id' value='<%=car.get("D_CAR_MNG_ID")%>'> 
			<input type='hidden' name='car_no' value='<%=car.get("D_CAR_NO")%>'>
			<input type='hidden' name='car_nm' value='<%=car.get("D_CAR_NM")%>'>
			<input type='hidden' name='car_st' value='<%=car.get("D_CAR_ST")%>'>
			<input type='hidden' name='s_dt1' value='<%=car.get("RENT_START_DT")%>'>
			<input type='hidden' name='e_dt1' value='<%=car.get("RENT_END_DT")%>'> 
	<%	}
	}	%>
	</form>
	<form name='form2' action='' method='post' target='d_content'>
<%	if(accid_size > 0 && ma_bean!=null){	//사고정보
		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);
			//계약기본정보
			ContBaseBean base2 = a_db.getCont(String.valueOf(accid.get("RENT_MNG_ID")), String.valueOf(accid.get("RENT_L_CD")));
			
			//대차료
		//	String i_start_dt = String.valueOf(accid.get("USE_ST"));
			String i_start_dt 	= ma_bean.getIns_use_st();
		   	String i_start_h 	= "00";
		   	String i_start_s 	= "00";
		// 	String get_start_dt = String.valueOf(accid.get("USE_ST"));
		//	String deli_dt 		= String.valueOf(accid.get("DELI_DT"));
		   	String get_start_dt = ma_bean.getIns_use_st();
		   	String deli_dt 		= ma_bean.getIns_use_st();
		   	String deli_dt_d	= "00"; 
			String deli_dt_h 	= "00";
			String deli_dt_s	= "00";				
			if(deli_dt.length()==12){
		    	deli_dt_d	= deli_dt.substring(0,8); 
				deli_dt_h 	= deli_dt.substring(8,10);
				deli_dt_s 	= deli_dt.substring(10,12);
			}
		   	if(get_start_dt.length() == 12){
		   		i_start_dt 	= get_start_dt.substring(0,8);
		   		i_start_h 	= get_start_dt.substring(8,10);
		   		i_start_s	= get_start_dt.substring(10,12);
		   	}
		   	if(get_start_dt.length() == 10){
		   		i_start_dt 	= get_start_dt.substring(0,8);
		   		i_start_h 	= get_start_dt.substring(8,10);
		   	}
		//	if(AddUtil.parseInt(String.valueOf(accid.get("INS_REQ_AMT")))==0 && get_start_dt.length() == 8 
		//		&& !String.valueOf(accid.get("CAR_MNG_ID")).equals("") && get_start_dt.equals(deli_dt_d)){
			if(ma_bean.getIns_req_amt()==0 && get_start_dt.length() == 8
				&& !ma_bean.getCar_mng_id().equals("") && get_start_dt.equals(deli_dt_d)){
				i_start_h 	= deli_dt_h;
		    	i_start_s	= deli_dt_s;
			}		         			
		//	String i_end_dt 	= String.valueOf(accid.get("USE_ET"));
			String i_end_dt 	= ma_bean.getIns_use_et();
		   	String i_end_h 		= "00";
		   	String i_end_s 		= "00";
		// 	String get_end_dt 	= String.valueOf(accid.get("USE_ET"));
		// 	String ret_dt 		= String.valueOf(accid.get("RET_DT"));
		   	String get_end_dt 	= ma_bean.getIns_use_et();
		   	String ret_dt 		= ma_bean.getIns_use_et();
		   	String ret_dt_d		= "00"; 
			String ret_dt_h 	= "00";
			String ret_dt_s		= "00";
			if(ret_dt.length()==12){
				ret_dt_d	= ret_dt.substring(0,8); 
				ret_dt_h 	= ret_dt.substring(8,10);
				ret_dt_s 	= ret_dt.substring(10,12);
			}
		   	if(get_end_dt.length() == 12){
		   		i_end_dt 	= get_end_dt.substring(0,8);
		   		i_end_h 	= get_end_dt.substring(8,10);
		   		i_end_s		= get_end_dt.substring(10,12);
		   	}
		   	if(get_end_dt.length() == 10){
		   		i_end_dt 	= get_end_dt.substring(0,8);
		   		i_end_h 	= get_end_dt.substring(8,10);
		   	}
		// 	if(AddUtil.parseInt(String.valueOf(accid.get("INS_REQ_AMT")))==0 && get_end_dt.length() == 8 
		// 		&& !String.valueOf(accid.get("CAR_MNG_ID")).equals("") && get_end_dt.equals(ret_dt_d)){
	   		if(ma_bean.getIns_req_amt()==0 && get_end_dt.length() == 8 
		   		&& !ma_bean.getCar_mng_id().equals("") && get_end_dt.equals(ret_dt_d)){	
		   	
				i_end_h 	= ret_dt_h;
		   		i_end_s		= ret_dt_s;
			}		       					
		   	//사고대차회수	
		   	
			//상대과실률 (이시점에서는 상대과실률 계산않기로(100%고객과실))
			//int ot_fault_per = accid.get("OT_FAULT_PER")==null?0:AddUtil.parseInt(String.valueOf(accid.get("OT_FAULT_PER")));
			//if(ot_fault_per==0) ot_fault_per = Math.abs(AddUtil.parseInt(String.valueOf(accid.get("OUR_FAULT_PER")))-100);
%>
			<input type='hidden' name='accid_id' value='<%=accid.get("ACCID_ID")%>'>
			<input type='hidden' name='rent_mng_id' value='<%=accid.get("RENT_MNG_ID")%>'>
			<input type='hidden' name='rent_l_cd' value='<%=accid.get("RENT_L_CD")%>'>
			<%-- <input type='hidden' name='ins_com_id' value='<%=ma_bean.getIns_com_id()%>'> --%>
			<input type='hidden' name='ins_com_nm' value='<%if(String.valueOf(accid.get("ACCID_ST")).equals("6")||String.valueOf(accid.get("ACCID_ST")).equals("8")){%><%=client1.get("FIRM_NM")%><%}else{%><%=oa_bean.getOt_ins()%><%}%>'>
			<input type='hidden' name='client_id' value='<%=client2.get("CLIENT_ID")%>'>
			<input type='hidden' name='client_st' value='<%=client2.get("CLIENT_ST")%>'>
			<input type='hidden' name='client_nm' value='<%=client2.get("CLIENT_NM")%>'>
			<input type='hidden' name='firm_nm' value='<%=client2.get("FIRM_NM")%>'>
			<input type='hidden' name='birth' value='<%=client2.get("SSN")%>'>
			<input type='hidden' name='enp_no' value='<%=client2.get("ENP_NO")%>'>
			<input type='hidden' name='zip' value=
				<%if(String.valueOf(client2.get("CLIENT_ST")).equals("1")){//법인 - 1순:사업장주소 2순:본점소재지 %>
					<%if(!String.valueOf(client2.get("O_ADDR")).equals("")){ %>
						'<%=client2.get("O_ZIP") %>'
					<%}else{ %>
						'<%=client2.get("HO_ZIP") %>'
					<%}%>
				<%}else if(String.valueOf(client2.get("CLIENT_ST")).equals("2")){//개인 - 1순:자택주소 2순:우편물주소 %>
					<%System.out.println("start!"); %>
					<%if(!String.valueOf(client2.get("HO_ADDR")).equals("")){ %>
						<%System.out.println("1 "+client2.get("HO_ADDR")); %>
						'<%=client2.get("HO_ZIP") %>'
					<%}else{%>
												<%System.out.println("2 "+base2.getP_zip()); %>
						'<%=base2.getP_zip()%>'
					<%}%>
				<%}else{//개인사업자 - 1순:사업장주소 2순:우편물주소 %>
					<%if(!String.valueOf(client2.get("O_ADDR")).equals("")){ %>
						'<%=client2.get("O_ZIP") %>'
					<%}else{%>
						'<%=base2.getP_zip()%>'
					<%}%>
				<%}%>
				<%-- <%=client2.get("O_ZIP")%> --%>
			>
			<input type='hidden' name='addr' value=
				<%if(String.valueOf(client2.get("CLIENT_ST")).equals("1")){//법인 - 1순:사업장주소 2순:본점소재지 %>
					<%if(!String.valueOf(client2.get("O_ADDR")).equals("")){ %>
						'<%=client2.get("O_ADDR") %>'
					<%}else{ %>
						'<%=client2.get("HO_ADDR") %>'
					<%}%>
				<%}else if(String.valueOf(client2.get("CLIENT_ST")).equals("2")){//개인 - 1순:자택주소 2순:우편물주소 %>
					<%if(!String.valueOf(client2.get("HO_ADDR")).equals("")){ %>
						'<%=client2.get("HO_ADDR") %>'
					<%}else{%>
						'<%=base2.getP_addr()%>'
					<%}%>
				<%}else{//개인사업자 - 1순:사업장주소 2순:우편물주소 %>
					<%if(!String.valueOf(client2.get("O_ADDR")).equals("")){ %>
						'<%=client2.get("O_ADDR") %>'
					<%}else{%>
						'<%=base2.getP_addr()%>'
					<%}%>
				<%}%>
				<%-- <%=client2.get("O_ADDR")%> --%>
			>
			<input type='hidden' name='ins_req_amt' value='<%=ma_bean.getIns_req_amt()%>'>
			<input type='hidden' name='c_id' value='<%=accid.get("CAR_MNG_ID")%>'>
			<input type='hidden' name='car_no' value='<%=accid.get("CAR_NO")%>'>
			<input type='hidden' name='car_nm' value='<%=accid.get("CAR_NM")%>'>
			<input type='hidden' name='accid_dt' value='<%=String.valueOf(accid.get("ACCID_DT")).substring(0,8)%>'>
			<input type='hidden' name='ot_fault_per' value='100'>
			<input type='hidden' name='ins_day_amt' value='<%=ma_bean.getIns_day_amt()%>'>
			<input type="hidden" name="i_start_dt" value="<%=i_start_dt%>">
			<input type="hidden" name="i_start_h" value="<%=i_start_h%>">
			<input type="hidden" name="i_start_s" value="<%=i_start_s%>">
			<input type="hidden" name="i_end_dt" value="<%=i_end_dt%>">
			<input type="hidden" name="i_end_h" value="<%=i_end_h%>">
			<input type="hidden" name="i_end_s" value="<%=i_end_s%>">
			<input type="hidden" name="s_dt2" value="<%=i_start_dt+i_start_h+i_start_s%>">
			<input type="hidden" name="e_dt2" value="<%=i_end_dt+i_end_h+i_end_s%>">	
						
	<%	}
	}	%>
	</form>
	<form name='form3' action='' method='post' target='d_content'>
	<%	if(cons_size > 0){	//탁송정보
		ContBaseBean base3 = a_db.getCont(String.valueOf(cons.get("RENT_MNG_ID")), String.valueOf(cons.get("RENT_L_CD")));
	%>
			<input type='hidden' name='rent_mng_id' value='<%=cons.get("RENT_MNG_ID")%>'>
			<input type='hidden' name='rent_l_cd' value='<%=cons.get("RENT_L_CD")%>'>
			<input type='hidden' name='client_id' value='<%=client3.get("CLIENT_ID")%>'>
			<input type='hidden' name='client_st' value='<%=client3.get("CLIENT_ST")%>'>
			<input type='hidden' name='client_nm' value='<%=client3.get("CLIENT_NM")%>'>
			<input type='hidden' name='firm_nm' value='<%=client3.get("FIRM_NM")%>'>
			<input type='hidden' name='birth' value='<%=client3.get("SSN")%>'>
			<input type='hidden' name='enp_no' value='<%=client3.get("ENP_NO")%>'>
			<input type='hidden' name='zip' value=
				<%if(String.valueOf(client3.get("CLIENT_ST")).equals("1")){//법인 - 1순:사업장주소 2순:본점소재지 %>
					<%if(!String.valueOf(client3.get("O_ADDR")).equals("")){ %>
						'<%=client3.get("O_ZIP") %>'
					<%}else{ %>
						'<%=client3.get("HO_ZIP") %>'
					<%}%>
				<%}else if(String.valueOf(client3.get("CLIENT_ST")).equals("2")){//개인 - 1순:자택주소 2순:우편물주소 %>
					<%if(!String.valueOf(client3.get("HO_ADDR")).equals("")){ %>
						'<%=client3.get("HO_ZIP") %>'
					<%}else{%>
						'<%=base3.getP_zip()%>'
					<%}%>
				<%}else{//개인사업자 - 1순:사업장주소 2순:우편물주소 %>
					<%if(!String.valueOf(client3.get("O_ADDR")).equals("")){ %>
						'<%=client3.get("O_ZIP") %>'
					<%}else{%>
						'<%=base3.getP_zip()%>'
					<%}%>
				<%}%>
				<%-- <%=client3.get("O_ZIP")%> --%>
			>
			<input type='hidden' name='addr' value=
				<%if(String.valueOf(client3.get("CLIENT_ST")).equals("1")){//법인 - 1순:사업장주소 2순:본점소재지 %>
					<%if(!String.valueOf(client3.get("O_ADDR")).equals("")){ %>
						'<%=client3.get("O_ADDR") %>'
					<%}else{ %>
						'<%=client3.get("HO_ADDR") %>'
					<%}%>
				<%}else if(String.valueOf(client3.get("CLIENT_ST")).equals("2")){//개인 - 1순:자택주소 2순:우편물주소 %>
					<%if(!String.valueOf(client3.get("HO_ADDR")).equals("")){ %>
						'<%=client3.get("HO_ADDR") %>'
					<%}else{%>
						'<%=base3.getP_addr()%>'
					<%}%>
				<%}else{//개인사업자 - 1순:사업장주소 2순:우편물주소 %>
					<%if(!String.valueOf(client3.get("O_ADDR")).equals("")){ %>
						'<%=client3.get("O_ADDR") %>'
					<%}else{%>
						'<%=base3.getP_addr()%>'
					<%}%>
				<%}%>
				<%-- <%=client3.get("O_ADDR")%> --%>
			>
			<input type='hidden' name='c_id' value='<%=cons.get("CAR_MNG_ID")%>'>
			<input type='hidden' name='car_no' value='<%=cons.get("CAR_NO")%>'>
			<input type='hidden' name='car_nm' value='<%=cons.get("CAR_NM")%>'>
			<input type='hidden' name='s_dt3' value='<%=cons.get("T_DT")%>'>
			<input type='hidden' name='e_dt3' value=''>
	<%	} %>
	
	</form>
</body>
</html>