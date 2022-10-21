<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.debt.*, acar.bill_mng.*"%>
<%@ page import="acar.bank_mng.*,acar.client.*, acar.car_register.*, acar.car_mst.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	out.println("<<일괄처리>>"+"<br><br>");
	
	String vid[] = request.getParameterValues("ch_cd");
	
	String value1[] 	= request.getParameterValues("sh_base_dt1");
	String value2[] 	= request.getParameterValues("sh_base_dt2");
	String value3[] 	= request.getParameterValues("ven_code1");
	String value4[] 	= request.getParameterValues("ven_code2");
	String value5[] 	= request.getParameterValues("ac_neoe_yn");
	String value6[] 	= request.getParameterValues("sh_base_dt3");
	
	int vid_size = vid.length;
	out.println("* 선택건수="+vid_size+"<br><br>");
	
	String value[] = new String[10];
	
	String rent_mng_id	= "";
	String rent_l_cd 	= "";
	int idx 		= 0;
	
	int flag = 0;
	boolean flag4 = true;
	int count =0;
	
	
	//사용자정보-더존
	Hashtable per = neoe_db.getPerinfoDept(login.getAcarName(user_id));


	//[1단계] 거래명세서 리스트 생성
	
	for(int i=0; i < vid_size; i++){
		
		out.print("=============================================================");out.println("<br>");
		out.print(i+1+". ");
		
		StringTokenizer st = new StringTokenizer(vid[i],"/");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		rent_mng_id = value[0];
		rent_l_cd		= value[1];
		idx					= AddUtil.parseInt(value[2]);
		
		out.println(rent_mng_id+" ");
		out.println(rent_l_cd+" ");
		out.println(idx+" : ");
		
		
		//계약정보 cont
		ContBaseBean base 	= a_db.getCont(rent_mng_id, rent_l_cd);
		
		//차량기본정보 car_etc
		ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
		
		//출고정보 car_pur
		ContPurBean pur 	= a_db.getContPur(rent_mng_id, rent_l_cd);
		
		//고객정보
		ClientBean client = al_db.getNewClient(base.getClient_id());
		
		
		
		//자동차기본정보
		CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
		
		//자동차사 거래처정보
		Hashtable ven = neoe_db.getVendorCase(value3[idx]);
		String s_idno = ven.get("S_IDNO")==null?"":String.valueOf(ven.get("S_IDNO"));
		
		Hashtable ven2 = neoe_db.getVendorCase(value4[idx]);
		String s_idno2 = ven2.get("S_IDNO")==null?"":String.valueOf(ven2.get("S_IDNO"));
		
		out.print("value3[idx]="+value3[idx]+"=");
		out.print("s_idno="+s_idno);
		out.print("value4[idx]="+value4[idx]+"=");
		out.print("s_idno2="+s_idno2);
		//if(1==1)return;
		
		String node_code 	= rent_l_cd.substring(0,2)+"01";
		String acct_cont 	= "중고차대금-"+pur.getEst_car_no();
		
		if(!node_code.equals("S101")){
			node_code 	= "S101";
		}
		
		int amt 		= car.getCar_fs_amt();
		int amt2 		= car.getCar_fv_amt(); 
		int amt3		= car.getCommi_s_amt();
		int amt4		= car.getCommi_v_amt();
		int amt5		= car.getStorage_s_amt();
		int amt6		= car.getStorage_v_amt();
		String acct_cd1		= "현금";
		String acct_cd2		= "현금";
		
		out.println(amt+" ");
		out.println(amt2+" ");
		out.println(amt3+" ");
		out.println(amt4+" ");
		
		AutoDocuBean ad_bean = new AutoDocuBean();
		AutoDocuBean ad_bean2 = new AutoDocuBean();
		AutoDocuBean ad_bean3 = new AutoDocuBean();
		
		String  no_docu = "";
		
		if(value5[idx].equals("") || value5[idx].equals("1")){
		
		ad_bean.setWrite_dt		(value1[idx]);
		ad_bean.setNode_code	(node_code);
		ad_bean.setVen_code		(value3[idx]);
		ad_bean.setFirm_nm		(neoe_db.getCodeByNm("ven", value3[idx]));
		ad_bean.setAcct_cont	(acct_cont);
		ad_bean.setAmt				(amt);			//대여사업차량금액
		ad_bean.setAmt2				(amt2);			//부가세대급금금액
		ad_bean.setAmt3				(amt+amt2);	//미지급금금액
		ad_bean.setSa_code		(String.valueOf(per.get("SA_CODE")));
		ad_bean.setKname			(String.valueOf(per.get("KNAME")));
		ad_bean.setDept_code	(String.valueOf(per.get("DEPT_CODE")));
		ad_bean.setDept_name	(String.valueOf(per.get("DEPT_NAME")));
		ad_bean.setInsert_id	(String.valueOf(per.get("SA_CODE")));
		ad_bean.setCar_st			("1");
		ad_bean.setVen_type		("0");
		ad_bean.setS_idno			(s_idno);
		ad_bean.setCardnm1		(acct_cont);
		ad_bean.setNm_item		(cm_bean.getCar_nm()+" "+pur.getEst_car_no());

		no_docu = neoe_db.insertCarPurAmtAc1AutoDocu(ad_bean, pur);
		
		}

		acct_cont 	= "중고차 중개수수료-"+pur.getEst_car_no();
		
		String  no_docu2 = "";
		
		if(value5[idx].equals("") || value5[idx].equals("2")){
		
		ad_bean2.setWrite_dt	(value2[idx]);
		ad_bean2.setNode_code	(node_code);
		ad_bean2.setVen_code	(value4[idx]);
		ad_bean2.setFirm_nm		(neoe_db.getCodeByNm("ven", value4[idx]));
		ad_bean2.setAcct_cont	(acct_cont);
		ad_bean2.setAmt				(amt3);				//영업수당
		ad_bean2.setAmt2			(amt4);				//부가세대급금금액
		ad_bean2.setAmt3			(amt3+amt4);	//미지급금금액		
		ad_bean2.setSa_code		(String.valueOf(per.get("SA_CODE")));
		ad_bean2.setKname			(String.valueOf(per.get("KNAME")));
		ad_bean2.setDept_code	(String.valueOf(per.get("DEPT_CODE")));
		ad_bean2.setDept_name	(String.valueOf(per.get("DEPT_NAME")));
		ad_bean2.setInsert_id	(String.valueOf(per.get("SA_CODE")));
		ad_bean2.setCar_st		("1");
		ad_bean2.setVen_type	("0");
		ad_bean2.setS_idno		(s_idno2);
		ad_bean2.setCardnm1		(acct_cont);
		ad_bean2.setNm_item		(cm_bean.getCar_nm()+" "+pur.getEst_car_no());

		no_docu2 = neoe_db.insertCarPurAmtAc2AutoDocu(ad_bean2, pur);
		
		}
		
		acct_cont 	= "중고차 보관료-"+pur.getEst_car_no();
		
		String  no_docu3 = "";
		
		if(amt5 > 0 && (value5[idx].equals("") || value5[idx].equals("2"))){
		
		ad_bean3.setWrite_dt	(value6[idx]);
		ad_bean3.setNode_code	(node_code);
		ad_bean3.setVen_code	(value4[idx]);
		ad_bean3.setFirm_nm		(neoe_db.getCodeByNm("ven", value4[idx]));
		ad_bean3.setAcct_cont	(acct_cont);
		ad_bean3.setAmt				(amt5);				//영업수당
		ad_bean3.setAmt2			(amt6);				//부가세대급금금액
		ad_bean3.setAmt3			(amt5+amt6);	//미지급금금액		
		ad_bean3.setSa_code		(String.valueOf(per.get("SA_CODE")));
		ad_bean3.setKname			(String.valueOf(per.get("KNAME")));
		ad_bean3.setDept_code	(String.valueOf(per.get("DEPT_CODE")));
		ad_bean3.setDept_name	(String.valueOf(per.get("DEPT_NAME")));
		ad_bean3.setInsert_id	(String.valueOf(per.get("SA_CODE")));
		ad_bean3.setCar_st		("1");
		ad_bean3.setVen_type	("0");
		ad_bean3.setS_idno		(s_idno2);
		ad_bean3.setCardnm1		(acct_cont);
		ad_bean3.setNm_item		(cm_bean.getCar_nm()+" "+pur.getEst_car_no());

		no_docu3 = neoe_db.insertCarPurAmtAc2AutoDocu(ad_bean3, pur);
		
		}		
				
			
		if(!no_docu.equals("")){
			pur.setAutodocu_write_date(value1[idx]);
			pur.setAutodocu_data_no		(no_docu);
			
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
		}
		
		
		
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'pur_pay_autodocu_ac.jsp';
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
</form>
<script language='javascript'>
<!--
		go_step();
//-->
</script>
종료
</body>
</html>
