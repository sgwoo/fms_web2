<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, acar.client.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String mode			= request.getParameter("mode")==null?"":request.getParameter("mode");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String accid_id 	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String rent_s_cd 	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	
	
	AddClientDatabase ac_db = AddClientDatabase.getInstance(); 
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();	
	
	
	Vector accids = null;
	Vector cars = null;
	Hashtable cons 	= null;
	Hashtable client = null;
	MyAccidBean ma_bean = null;
	InsurBean ins = null;
	int accid_size = 0;
	int car_size = 0;
	int cons_size = 0;
	int client_size = 0;
	String ins_st = "";
	
	if(mode.equals("sch_accid")){
		accids = as_db.getAccidSListPop(car_mng_id, accid_id);
		accid_size = accids.size();
	}else if(mode.equals("sch_accid_detail")){
		accids = as_db.getAccidSListPop(car_mng_id, accid_id);
		accid_size = accids.size();
		if(accid_size > 0){
			//보험청구내역(휴차/대차료)
			ma_bean = as_db.getMyAccid(car_mng_id, accid_id);
			for (int i = 0 ; i < accid_size ; i++){
				Hashtable accid = (Hashtable)accids.elementAt(i);
				client = ac_db.getClientOne(String.valueOf(accid.get("CLIENT_ID")));
				client_size = client.size();
			}
		}
	}else if(mode.equals("sch_car")){
		cars = as_db.getRentContCarPop(car_mng_id, rent_s_cd);
		//보험정보
		ins_st = ai_db.getInsSt(car_mng_id);
		ins = ai_db.getIns(car_mng_id, ins_st);
		car_size = cars.size();
		if(car_size > 0){
			for (int i = 0 ; i < car_size ; i++){
				Hashtable car = (Hashtable)cars.elementAt(i);
				client = ac_db.getClientOne(String.valueOf(car.get("CUST_ID")));
				client_size = client.size();
			}
		}
	}else if(mode.equals("sch_cons")){
		cons = as_db.getConsForAccidPop(car_mng_id);
		cons_size = cons.size();
		if(cons_size > 0){
			client = ac_db.getClientOne(String.valueOf(cons.get("CUST_ID")));
			client_size = client.size();
		}
	}
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<script type="text/javascript" src='/include/common.js'></script>
<script>
 function process(){
	var fm = document.form1;
	var o_fm = opener.form1;
	if(fm.mode.value=="sch_accid_detail"){
		o_fm.ac_accid_id.value 		= fm.accid_id.value;
		o_fm.ac_rent_mng_id.value 	= fm.rent_mng_id.value;
		o_fm.ac_rent_l_cd.value 	= fm.rent_l_cd.value;	
		o_fm.ins_com_id.value 		= fm.ins_com_id.value;
		o_fm.ins_com_nm.value 		= fm.ins_com_nm.value;
		o_fm.ac_client_id.value 	= fm.client_id.value;
		o_fm.ac_client_st.value 	= fm.client_st.value;
		o_fm.ac_client_nm.value 	= fm.client_nm.value;
		o_fm.ac_firm_nm.value 		= fm.firm_nm.value;
		if(fm.client_st.value=='2'){	o_fm.ac_birth.value = fm.birth.value.substr(0,6); 	}
		o_fm.ac_enp_no.value 		= fm.enp_no.value;
		o_fm.ac_zip.value 			= fm.zip.value;
		o_fm.ac_addr.value 			= fm.addr.value;
		if(fm.ins_req_amt.value!=''&&fm.ins_req_amt.value!='null'){	o_fm.ins_req_amt.value = fm.ins_req_amt.value;	}
		o_fm.ac_car_mng_id.value 	= fm.c_id.value;
		o_fm.ac_car_no.value	 	= fm.car_no.value;
		o_fm.ac_car_nm.value	 	= fm.car_nm.value;
		o_fm.accid_dt.value 		= fm.accid_dt.value;
		o_fm.ac_ot_fault_per.value 	= fm.ot_fault_per.value;
		o_fm.ins_day_amt.value 		= fm.ins_day_amt.value;
		o_fm.ins_use_st.value		= fm.i_start_dt.value;
		o_fm.use_st_h.value			= fm.i_start_h.value;
		o_fm.use_st_s.value			= fm.i_start_s.value;
		o_fm.ins_use_et.value		= fm.i_end_dt.value;
		o_fm.use_et_h.value			= fm.i_end_h.value;
		o_fm.use_et_s.value			= fm.i_end_s.value;
		o_fm.s_dt2.value	 		= fm.s_dt2.value;
		o_fm.e_dt2.value	 		= fm.e_dt2.value;
		
	}else if(fm.mode.value=="sch_car"){
		
		o_fm.ac_rent_mng_id.value 	= fm.rent_mng_id.value;
		o_fm.ac_rent_l_cd.value 	= fm.rent_l_cd.value;
		o_fm.ins_com_id.value 		= fm.ins_com_id.value;
		o_fm.ins_com_nm.value 		= fm.ins_com_nm.value;
		o_fm.ac_client_id.value 	= fm.client_id.value;
		o_fm.ac_client_st.value 	= fm.client_st.value;
		o_fm.ac_client_nm.value 	= fm.client_nm.value;
		o_fm.ac_firm_nm.value 		= fm.firm_nm.value;
		if(fm.client_st.value=='2'){	o_fm.ac_birth.value = fm.birth.value.substr(0,6); 	}
		o_fm.ac_enp_no.value 		= fm.enp_no.value;
		o_fm.ac_zip.value 			= fm.zip.value;
		o_fm.ac_addr.value 			= fm.addr.value;
		o_fm.ac_car_mng_id.value 	= fm.c_id.value;
		o_fm.ac_car_no.value	 	= fm.car_no.value;
		o_fm.ac_car_nm.value	 	= fm.car_nm.value;
		o_fm.sch_ac_car_no.value 	= fm.car_no.value;
		o_fm.sch_ac_c_id.value 		= fm.c_id.value;
		o_fm.s_dt1.value	 		= fm.s_dt1.value;
		o_fm.e_dt1.value	 		= fm.e_dt1.value;
		
	}else if(fm.mode.value=="sch_cons"){
		o_fm.s_dt3.value	 		= fm.s_dt3.value;
		for(var i=0; i<=1; i++){
			if(o_fm.cons_cau[i].value=="10"){
				o_fm.e_dt3.value = o_fm.from_req_dt[i].value.replace(/-/gi,"")+""+o_fm.from_req_h[i].value+""+o_fm.from_req_s[i].value;
			}
		}
	}
	
	self.close();
 }	
</script>
</head>
<body onload="javascript:process();">
<form name='form1' action='' method='post' target='d_content'>
	<input type='hidden' name='accid_size' value='<%=accid_size%>'>
	<input type='hidden' name='mode' value='<%=mode%>'>
	<%if(mode.equals("sch_accid")||mode.equals("sch_accid_detail")){%>
	<%	if(accid_size > 0){	
			for (int i = 0 ; i < accid_size ; i++){
				Hashtable accid = (Hashtable)accids.elementAt(i);	
				//대차료
				String i_start_dt = String.valueOf(accid.get("USE_ST"));
			   	String i_start_h 	= "00";
			   	String i_start_s 	= "00";
			   	String get_start_dt = String.valueOf(accid.get("USE_ST"));
			   	String deli_dt 		= String.valueOf(accid.get("DELI_DT"));
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
				if(AddUtil.parseInt(String.valueOf(accid.get("INS_REQ_AMT")))==0 && get_start_dt.length() == 8 
					&& !String.valueOf(accid.get("CAR_MNG_ID")).equals("") && get_start_dt.equals(deli_dt_d)){
					i_start_h 	= deli_dt_h;
			    	i_start_s	= deli_dt_s;
				}		         			
				String i_end_dt 	= String.valueOf(accid.get("USE_ET"));
			   	String i_end_h 		= "00";
			   	String i_end_s 		= "00";
			   	String get_end_dt 	= String.valueOf(accid.get("USE_ET"));
			   	String ret_dt 		= String.valueOf(accid.get("RET_DT"));
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
			   	if(AddUtil.parseInt(String.valueOf(accid.get("INS_REQ_AMT")))==0 && get_end_dt.length() == 8 
			   		&& !String.valueOf(accid.get("CAR_MNG_ID")).equals("") && get_end_dt.equals(ret_dt_d)){
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
				<input type='hidden' name='ins_com_id' value='<%=ma_bean.getIns_com_id()%>'>
				<input type='hidden' name='ins_com_nm' value='<%=ma_bean.getIns_com()%>'>
				<input type='hidden' name='client_id' value='<%=client.get("CLIENT_ID")%>'>
				<input type='hidden' name='client_st' value='<%=client.get("CLIENT_ST")%>'>
				<input type='hidden' name='client_nm' value='<%=client.get("CLIENT_NM")%>'>
				<input type='hidden' name='firm_nm' value='<%=client.get("FIRM_NM")%>'>
				<input type='hidden' name='birth' value='<%=client.get("SSN")%>'>
				<input type='hidden' name='enp_no' value='<%=client.get("ENP_NO")%>'>
				<input type='hidden' name='zip' value='<%=client.get("O_ZIP")%>'>
				<input type='hidden' name='addr' value='<%=client.get("O_ADDR")%>'>
				<input type='hidden' name='ins_req_amt' value='<%=ma_bean.getIns_req_amt()%>'>
				<input type='hidden' name='c_id' value='<%=accid.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='car_no' value='<%=accid.get("CAR_NO")%>'>
				<input type='hidden' name='car_nm' value='<%=accid.get("CAR_NM")%>'>
				<input type='hidden' name='accid_dt' value='<%=accid.get("ACCID_DT")%>'>
				<input type='hidden' name='ot_fault_per' value='0'>
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
	<%}else if(mode.equals("sch_car")){ %>
		<%	if(car_size > 0){	
			for (int i = 0 ; i < car_size ; i++){
				Hashtable car = (Hashtable)cars.elementAt(i);
	%>
				<input type='hidden' name='rent_mng_id' value='<%=car.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=car.get("SUB_L_CD")%>'>
				<input type='hidden' name='ins_com_id' value='<%=ins.getIns_com_id()%>'>
				<input type='hidden' name='ins_com_nm' value='<%=ins.getIns_com_nm()%>'>
				<input type='hidden' name='client_id' value='<%=client.get("CLIENT_ID")%>'>
				<input type='hidden' name='client_st' value='<%=client.get("CLIENT_ST")%>'>
				<input type='hidden' name='client_nm' value='<%=client.get("CLIENT_NM")%>'>
				<input type='hidden' name='firm_nm' value='<%=client.get("FIRM_NM")%>'>
				<input type='hidden' name='birth' value='<%=client.get("SSN")%>'>
				<input type='hidden' name='enp_no' value='<%=client.get("ENP_NO")%>'>
				<input type='hidden' name='zip' value='<%=client.get("O_ZIP")%>'>
				<input type='hidden' name='addr' value='<%=client.get("O_ADDR")%>'>
				<input type='hidden' name='c_id' value='<%=car.get("D_CAR_MNG_ID")%>'>
				<input type='hidden' name='car_no' value='<%=car.get("D_CAR_NO")%>'>
				<input type='hidden' name='car_nm' value='<%=car.get("D_CAR_NM")%>'>
				<input type='hidden' name='s_dt1' value='<%=car.get("RENT_START_DT")%>'>
				<input type='hidden' name='e_dt1' value='<%=car.get("RENT_END_DT")%>'>
		<%	}
		}	%>
	<%}else if(mode.equals("sch_cons")){ %>
		<%	if(cons_size > 0){	%>
				<input type='hidden' name='rent_mng_id' value='<%=cons.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=cons.get("RENT_L_CD")%>'>
				<input type='hidden' name='client_id' value='<%=client.get("CLIENT_ID")%>'>
				<input type='hidden' name='client_st' value='<%=client.get("CLIENT_ST")%>'>
				<input type='hidden' name='client_nm' value='<%=client.get("CLIENT_NM")%>'>
				<input type='hidden' name='firm_nm' value='<%=client.get("FIRM_NM")%>'>
				<input type='hidden' name='birth' value='<%=client.get("SSN")%>'>
				<input type='hidden' name='enp_no' value='<%=client.get("ENP_NO")%>'>
				<input type='hidden' name='zip' value='<%=client.get("O_ZIP")%>'>
				<input type='hidden' name='addr' value='<%=client.get("O_ADDR")%>'>
				<input type='hidden' name='c_id' value='<%=cons.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='car_no' value='<%=cons.get("CAR_NO")%>'>
				<input type='hidden' name='car_nm' value='<%=cons.get("CAR_NM")%>'>
				<input type='hidden' name='s_dt3' value='<%=cons.get("T_DT")%>'>
				<input type='hidden' name='e_dt3' value=''>
		<%	} %>
	<%} %>
</form>
</body>
</html>