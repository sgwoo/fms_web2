<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.tire.*, acar.master_car.*, acar.user_mng.*, acar.customer.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tire.TireDatabase"/>
<jsp:useBean id="cu_db" class="acar.customer.Customer_Database" scope="page"/>
<%@ include file="/off/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String tire_gubun = request.getParameter("tire_gubun")==null?"":request.getParameter("tire_gubun");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag6 = true;
	int flag = 0;
	int error = 0;
	int result = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
%>

<%
	String serv_id 		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");

	String dtire_item1 = request.getParameter("dtire_item1")==null?"":request.getParameter("dtire_item1");
	int dtire_item_amt1 = request.getParameter("dtire_item_amt1")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_amt1"));
	String dtire_item2 = request.getParameter("dtire_item2")==null?"":request.getParameter("dtire_item2");
	int dtire_item_amt2 = request.getParameter("dtire_item_amt2")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_amt2"));
	String dtire_item3 = request.getParameter("dtire_item3")==null?"":request.getParameter("dtire_item3");
	int dtire_item_amt3 = request.getParameter("dtire_item_amt3")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_amt3"));
	String dtire_item4 = request.getParameter("dtire_item4")==null?"":request.getParameter("dtire_item4");
	int dtire_item_amt4 = request.getParameter("dtire_item_amt4")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_amt4"));
	String dtire_item5 = request.getParameter("dtire_item5")==null?"":request.getParameter("dtire_item5");
	int dtire_item_amt5 = request.getParameter("dtire_item_amt5")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_amt5"));
	String dtire_item6 = request.getParameter("dtire_item6")==null?"":request.getParameter("dtire_item6");
	int dtire_item_amt6 = request.getParameter("dtire_item_amt6")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_amt6"));
	String dtire_gb = request.getParameter("dtire_gb")==null?"":request.getParameter("dtire_gb");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	
	int dtire_item_s_amt1 = request.getParameter("dtire_item_s_amt1")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_s_amt1"));
	int dtire_item_s_amt2 = request.getParameter("dtire_item_s_amt2")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_s_amt2"));
	int dtire_item_s_amt3 = request.getParameter("dtire_item_s_amt3")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_s_amt3"));
	int dtire_item_s_amt4 = request.getParameter("dtire_item_s_amt4")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_s_amt4"));
	int dtire_item_s_amt5 = request.getParameter("dtire_item_s_amt5")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_s_amt5"));
	int dtire_item_s_amt6 = request.getParameter("dtire_item_s_amt6")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_s_amt6"));
	
	int dtire_item_v_amt1 = request.getParameter("dtire_item_v_amt1")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_v_amt1"));
	int dtire_item_v_amt2 = request.getParameter("dtire_item_v_amt2")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_v_amt2"));
	int dtire_item_v_amt4 = request.getParameter("dtire_item_v_amt4")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_v_amt4"));
	int dtire_item_v_amt3 = request.getParameter("dtire_item_v_amt3")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_v_amt3"));
	int dtire_item_v_amt5 = request.getParameter("dtire_item_v_amt5")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_v_amt5"));
	int dtire_item_v_amt6 = request.getParameter("dtire_item_v_amt6")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_v_amt6"));
	
	int dtire_item_t_amt1 = request.getParameter("dtire_item_t_amt1")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_t_amt1"));
	int dtire_item_t_amt2 = request.getParameter("dtire_item_t_amt2")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_t_amt2"));
	int dtire_item_t_amt3 = request.getParameter("dtire_item_t_amt3")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_t_amt3"));
	int dtire_item_t_amt4 = request.getParameter("dtire_item_t_amt4")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_t_amt4"));
	int dtire_item_t_amt5 = request.getParameter("dtire_item_t_amt5")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_t_amt5"));
	int dtire_item_t_amt6 = request.getParameter("dtire_item_t_amt6")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_t_amt6"));
	
	int dtire_item_su1 = request.getParameter("dtire_item_su1")==null?0:AddUtil.parseDigit(request.getParameter("dtire_item_su1"));
	String r_dc_per = request.getParameter("r_dc_per")==null?"":request.getParameter("r_dc_per");
	
	int dtire_price = request.getParameter("dtire_price")==null?0:AddUtil.parseDigit(request.getParameter("dtire_price"));
	int dtire_price2 = request.getParameter("dtire_price2")==null?0:AddUtil.parseDigit(request.getParameter("dtire_price2"));
	int dtire_price3 = request.getParameter("dtire_price3")==null?0:AddUtil.parseDigit(request.getParameter("dtire_price3"));
	int dtire_price4 = request.getParameter("dtire_price4")==null?0:AddUtil.parseDigit(request.getParameter("dtire_price4"));
	int dtire_price5 = request.getParameter("dtire_price5")==null?0:AddUtil.parseDigit(request.getParameter("dtire_price5"));
	int dtire_price6 = request.getParameter("dtire_price6")==null?0:AddUtil.parseDigit(request.getParameter("dtire_price6"));
	
	TireBean tire_mm 		= t_db.getDtireMM(seq, c_id);
	//serv_item 
if(cmd.equals("RN")){
	
	serv_id = cu_db.getServ_id(c_id);
	Customer_Bean cuBn = new Customer_Bean();	
	
	if(!dtire_item1.equals("")){
		cuBn.setLabor		(0);
		cuBn.setCar_mng_id	(c_id);
		cuBn.setServ_id		(serv_id);
		cuBn.setItem_st		("주작업");
		cuBn.setItem		("타이어: "+dtire_item1);
		cuBn.setCount		(dtire_item_su1);
		cuBn.setAmt			(dtire_item_s_amt1);
		cuBn.setPrice		(dtire_price);
		cuBn.setBpm			("2");
		cuBn.setReg_id		(user_id);
		
		//중복체크
		if(cu_db.getServ_itemCheck(cuBn.getCar_mng_id(), cuBn.getServ_id(), cuBn.getItem(), cuBn.getLabor(), cuBn.getAmt()) == 0){
			if(cu_db.insertServItem(cuBn) == 0) error++;
		}
		
	}
	if(!dtire_item2.equals("")){
		cuBn.setLabor			(0);
		cuBn.setCar_mng_id	(c_id);
		cuBn.setServ_id		(serv_id);
		cuBn.setItem_st		("주작업");
		cuBn.setItem		("휠얼라이먼트: "+dtire_item2);
		cuBn.setCount		(1);
		cuBn.setAmt			(dtire_item_s_amt2);
		cuBn.setPrice		(dtire_price2);
		cuBn.setBpm			("2");
		cuBn.setReg_id		(user_id);
		
		//중복체크
		if(cu_db.getServ_itemCheck(cuBn.getCar_mng_id(), cuBn.getServ_id(), cuBn.getItem(), cuBn.getLabor(), cuBn.getAmt()) == 0){
			if(cu_db.insertServItem(cuBn) == 0) error++;
		}
	}
	if(!dtire_item3.equals("")){
		cuBn.setLabor		(0);
		cuBn.setCar_mng_id	(c_id);
		cuBn.setServ_id		(serv_id);
		cuBn.setItem_st		("주작업");
		cuBn.setItem		("엔진오일: "+dtire_item3);
		cuBn.setCount		(1);
		cuBn.setAmt			(dtire_item_s_amt3);
		cuBn.setPrice		(dtire_price3);
		cuBn.setBpm			("2");
		cuBn.setReg_id		(user_id);
		
		//중복체크
		if(cu_db.getServ_itemCheck(cuBn.getCar_mng_id(), cuBn.getServ_id(), cuBn.getItem(), cuBn.getLabor(), cuBn.getAmt()) == 0){
			if(cu_db.insertServItem(cuBn) == 0) error++;
		}
	}
	if(!dtire_item4.equals("")){
		cuBn.setLabor		(0);
		cuBn.setCar_mng_id	(c_id);
		cuBn.setServ_id		(serv_id);
		cuBn.setItem_st		("주작업");
		cuBn.setItem		("윈도우브러쉬: "+dtire_item4);
		cuBn.setCount		(1);
		cuBn.setAmt			(dtire_item_s_amt4);
		cuBn.setPrice		(dtire_price4);
		cuBn.setBpm			("2");
		cuBn.setReg_id		(user_id);
		
		//중복체크
		if(cu_db.getServ_itemCheck(cuBn.getCar_mng_id(), cuBn.getServ_id(), cuBn.getItem(), cuBn.getLabor(), cuBn.getAmt()) == 0){
			if(cu_db.insertServItem(cuBn) == 0) error++;
		}
	}
	if(!dtire_item5.equals("")){
		cuBn.setLabor		(0);
		cuBn.setCar_mng_id	(c_id);
		cuBn.setServ_id		(serv_id);
		cuBn.setItem_st		("주작업");
		cuBn.setItem		("브레이크라이닝: "+dtire_item5);
		cuBn.setCount		(1);
		cuBn.setAmt			(dtire_item_s_amt5);
		cuBn.setPrice		(dtire_price5);
		cuBn.setBpm			("2");
		cuBn.setReg_id		(user_id);
		
		//중복체크
		if(cu_db.getServ_itemCheck(cuBn.getCar_mng_id(), cuBn.getServ_id(), cuBn.getItem(), cuBn.getLabor(), cuBn.getAmt()) == 0){
			if(cu_db.insertServItem(cuBn) == 0) error++;
		}
	}
	if(!dtire_item6.equals("")){
		cuBn.setLabor		(0);
		cuBn.setCar_mng_id	(c_id);
		cuBn.setServ_id		(serv_id);
		cuBn.setItem_st		("주작업");
		cuBn.setItem		("기타: "+dtire_item6);
		cuBn.setCount		(1);
		cuBn.setAmt			(dtire_item_s_amt6);
		cuBn.setPrice		(dtire_price6);
		cuBn.setBpm			("2");
		cuBn.setReg_id		(user_id);
		
		//중복체크
		if(cu_db.getServ_itemCheck(cuBn.getCar_mng_id(), cuBn.getServ_id(), cuBn.getItem(), cuBn.getLabor(), cuBn.getAmt()) == 0){
			if(cu_db.insertServItem(cuBn) == 0) error++;
		}
	}	
	
	String req_nm = request.getParameter("req_nm")==null?"":request.getParameter("req_nm");
	String rep_cont = request.getParameter("rep_cont")==null?"":request.getParameter("rep_cont");
	String tot_dist = 	request.getParameter("dtire_km")==null?"":request.getParameter("dtire_km");
	String dtire_dt	=	request.getParameter("dtire_dt")==null?"":request.getParameter("dtire_dt");
	
	String chk_ids = "";
	int amt = 0;
	
	UsersBean mng_bean 	= umd.getUsersBean(req_nm);
	String mng_nm	=	mng_bean.getUser_id();
	//service
	
	//Hashtable ht2 = cu_db.getServ_id_tire(c_id, serv_id);
	Hashtable ht2;
	if(tire_gubun.equals("000156")){
	ht2 = cu_db.getServ_id2(c_id, serv_id);}
	else{
	ht2 = cu_db.getServ_id_tire(c_id, serv_id);
	}
	
	String serv_id2 = String.valueOf(ht2.get("SERV_ID"));
//	amt = AddUtil.parseInt(String.valueOf(ht2.get("AMT")));
//	long samt = Math.round(amt / 1.1);
//	long damt = Math.round(amt - samt);
	
	String serv_st = "";
	
	//dtire_gb 가 3:재리스정비 일때 serv_st = "7"로 바꿔서 등록. 그외에는 2:일반정비로 등록.
	if(dtire_gb.equals("3")){
		serv_st = "7";
	}else if(dtire_gb.equals("2")){
		serv_st = "13";
	}else{
		serv_st = "2";
	}
	
//	System.out.println("l_cd: "+l_cd);
//	System.out.println("rent_l_cd: "+rent_l_cd);
	
	if(!serv_id2.equals("null")){//serv_id2가 null이 아닐때만 실행
		
	ServInfoBean siBn = new ServInfoBean();
	siBn.setCar_mng_id(c_id);
	siBn.setServ_id(serv_id2);
	siBn.setRent_mng_id(rent_mng_id);
	
	siBn.setRent_l_cd(rent_l_cd);
	siBn.setServ_st(serv_st);
	if(tire_gubun.equals("000256")){
			siBn.setOff_id("008634");
		}
		if(tire_gubun.equals("000148")){
			siBn.setOff_id("000092");
		}
		if(tire_gubun.equals("000156")){
			siBn.setOff_id("006470");
		}
	if(dtire_gb.equals("2")){
			siBn.setAccid_id(accid_id);
			
	}
	siBn.setServ_dt(dtire_dt);
	siBn.setChecker(mng_nm);
	siBn.setSpdchk_dt(dtire_dt);
	siBn.setTot_dist(tot_dist);
	siBn.setRep_cont(request.getParameter("dtire_note")==null?"":request.getParameter("dtire_note"));
	siBn.setTot_amt(request.getParameter("dtire_amt")==null?0:AddUtil.parseDigit(request.getParameter("dtire_amt")));
	siBn.setRep_amt(request.getParameter("dtire_amt")==null?0:AddUtil.parseDigit(request.getParameter("dtire_amt")));
	
	siBn.setR_amt(request.getParameter("dtire_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("dtire_s_amt")));
	siBn.setR_j_amt(request.getParameter("dtire_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("dtire_s_amt")));   //무조건 부품으로 (공급가)
	
	siBn.setSup_amt(request.getParameter("dtire_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("dtire_s_amt")));  //공급가
	siBn.setAdd_amt(request.getParameter("dtire_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("dtire_v_amt")));  // 부가세

	siBn.setChecker_st("1");
	siBn.setSpd_chk(chk_ids);
	siBn.setReg_id(user_id);
	
	
	//중복체크
		if(cu_db.getServiceCheck(siBn.getCar_mng_id(), siBn.getServ_id()) == 0){
			int result1 = cu_db.insertService(siBn);
		}
	
	}

//정비분류가 사고수리가 아닌 경우에만 정비항목에 등록(SERVICE, SERV_ITEM)
tire_mm.setSeq		(seq);
	tire_mm.setCar_mng_id		(c_id);
	tire_mm.setRent_l_cd		(l_cd);

	flag1 = t_db.updateDtireYn(tire_mm);
}else if(cmd.equals("YN")){

	tire_mm.setSeq		(seq);
	tire_mm.setCar_mng_id		(c_id);
	tire_mm.setRent_l_cd		(l_cd);

	flag1 = t_db.updateDtireYn(tire_mm);
	
}else if(cmd.equals("D")){

	tire_mm.setSeq		(seq);
	tire_mm.setCar_mng_id		(c_id);
	tire_mm.setRent_l_cd		(l_cd);

	flag1 = t_db.updateDtireDel(tire_mm);
	
}

	%>
<form name='form1' method='post'>
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
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='seq' 	value='<%=seq%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>    
  <input type='hidden' name='mode' 		value='<%=mode%>'>      
</form>
<script language='javascript'>
	var flag = 0;	
<%		if(result>0){	%>	alert('등록 에러입니다.\n\n확인하십시오');		flag = 1;<%		}	%>
<%		if(!flag1){		%>	alert('수정 에러입니다.\n\n확인하십시오');		flag = 1;<%		}	%>

	if(flag == 0){
		alert('처리되었습니다.');
		var fm = document.form1;	
		fm.action = '<%=from_page%>';		
		fm.target = 'd_content';
		fm.submit();		
		
		parent.window.close();
	}
</script>
</body>
</html>

