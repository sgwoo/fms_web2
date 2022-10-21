<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.debt.*, acar.bill_mng.*"%>
<%@ page import="acar.bank_mng.*,acar.client.*, acar.car_register.*"%>
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
	
	out.println("<<일괄처리>>"+"<br><br>");
	
	String vid[] = request.getParameterValues("ch_cd");
	
	String value1[] 	= request.getParameterValues("dlv_dt");
	String value2[] 	= request.getParameterValues("car_amt_dt");
	String value3[] 	= request.getParameterValues("pur_pay_dt");
	String value4[] 	= request.getParameterValues("dlv_ext_ven_code");
	String value5[] 	= request.getParameterValues("car_off_ven_code");
	String value6[] 	= request.getParameterValues("card_com_ven_code");
	String value7[] 	= request.getParameterValues("trf1_ven_code");
	String value8[]	 	= request.getParameterValues("trf2_ven_code");
	String value9[] 	= request.getParameterValues("trf3_ven_code");
	String value10[] 	= request.getParameterValues("trf4_ven_code");
	String value11[] 	= request.getParameterValues("car_tax_dt");
	
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
		
		rent_mng_id 	= value[0];
		rent_l_cd	= value[1];
		idx		= AddUtil.parseInt(value[2]);
		
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
		
		//자동차등록정보
		CarRegBean cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		
		//자동차사 거래처정보
		Hashtable ven = neoe_db.getVendorCase(value4[idx]);
		String s_idno = ven.get("S_IDNO")==null?"":String.valueOf(ven.get("S_IDNO"));
		
//		out.print("value4[idx]="+value4[idx]+"=");		
//		out.print("s_idno="+s_idno);				
//		if(1==1)return;
		
		String dlv_dt 		= value1[idx];
		String car_tax_dt	= value11[idx]==null?"":value11[idx];
		String node_code 	= rent_l_cd.substring(0,2)+"01";
		String acct_cont 	= "차량대금-"+client.getFirm_nm()+" "+cr_bean.getCar_no();
		
		if(!car_tax_dt.equals("")){
			dlv_dt 		= car_tax_dt;
		}
		
		if(!node_code.equals("S101") && AddUtil.parseInt(AddUtil.replace(dlv_dt,"-","")) > 20090631){
			node_code 	= "S101";
		}
		
		int amt 		= car.getCar_fs_amt()+car.getSd_cs_amt()-car.getDc_cs_amt();
		int amt2 		= car.getCar_fv_amt()+car.getSd_cv_amt()-car.getDc_cv_amt(); 
		int amt3		= pur.getCon_amt();
		int amt4		= pur.getTrf_amt1();
		int amt5		= pur.getTrf_amt2();
		int amt6		= pur.getTrf_amt3();
		int amt7		= pur.getTrf_amt4();
		String acct_cd1		= "";
		String acct_cd2		= "";
		String acct_cd3		= "";
		String acct_cd4		= "";
		if(pur.getTrf_st1().equals("1")) acct_cd1 = "현금";
		if(pur.getTrf_st2().equals("1")) acct_cd2 = "현금";
		if(pur.getTrf_st3().equals("1")) acct_cd3 = "현금";
		if(pur.getTrf_st4().equals("1")) acct_cd4 = "현금";
		if(pur.getTrf_st1().equals("2")) acct_cd1 = "선불카드";
		if(pur.getTrf_st2().equals("2")) acct_cd2 = "선불카드";
		if(pur.getTrf_st3().equals("2")) acct_cd3 = "선불카드";
		if(pur.getTrf_st4().equals("2")) acct_cd4 = "선불카드";
		if(pur.getTrf_st1().equals("3")) acct_cd1 = "후불카드";
		if(pur.getTrf_st2().equals("3")) acct_cd2 = "후불카드";
		if(pur.getTrf_st3().equals("3")) acct_cd3 = "후불카드";
		if(pur.getTrf_st4().equals("3")) acct_cd4 = "후불카드";
		if(pur.getTrf_st1().equals("4")) acct_cd1 = "대출";
		if(pur.getTrf_st2().equals("4")) acct_cd2 = "대출";
		if(pur.getTrf_st3().equals("4")) acct_cd3 = "대출";
		if(pur.getTrf_st4().equals("4")) acct_cd4 = "대출";
		if(pur.getTrf_st1().equals("5")) acct_cd1 = "포인트";
		if(pur.getTrf_st2().equals("5")) acct_cd2 = "포인트";
		if(pur.getTrf_st3().equals("5")) acct_cd3 = "포인트";
		if(pur.getTrf_st4().equals("5")) acct_cd4 = "포인트";
		if(pur.getTrf_st1().equals("6")) acct_cd1 = "구매보조금";
		if(pur.getTrf_st2().equals("6")) acct_cd2 = "구매보조금";
		if(pur.getTrf_st3().equals("6")) acct_cd3 = "구매보조금";
		if(pur.getTrf_st4().equals("6")) acct_cd4 = "구매보조금";
		if(pur.getTrf_st1().equals("7")) acct_cd1 = "카드할부";
		if(pur.getTrf_st2().equals("7")) acct_cd2 = "카드할부";
		if(pur.getTrf_st3().equals("7")) acct_cd3 = "카드할부";
		if(pur.getTrf_st4().equals("7")) acct_cd4 = "카드할부";

		
		out.println(amt+" ");
		out.println(amt2+" ");
		
		AutoDocuBean ad_bean = new AutoDocuBean();
		
		ad_bean.setWrite_dt		(dlv_dt);
		ad_bean.setNode_code		(node_code);
		ad_bean.setVen_code		(value4[idx]);
		ad_bean.setFirm_nm		(neoe_db.getCodeByNm("ven", value4[idx]));
		ad_bean.setVen_code2		(value5[idx]);
		ad_bean.setFirm_nm2		(neoe_db.getCodeByNm("ven", value5[idx]));
		ad_bean.setVen_code3		(value6[idx]);
		ad_bean.setFirm_nm3		(neoe_db.getCodeByNm("ven", value6[idx]));
		ad_bean.setAcct_dt		(dlv_dt);
		ad_bean.setAcct_cd1		(acct_cd1);
		ad_bean.setAcct_cd2		(acct_cd2);
		ad_bean.setAcct_cd3		(acct_cd3);
		ad_bean.setAcct_cd4		(acct_cd4);
		ad_bean.setAcct_cont		(acct_cont);
		ad_bean.setAmt			(amt);					//대여사업차량금액
		ad_bean.setAmt2			(amt2);					//부가세대급금금액
		ad_bean.setAmt3			(amt3);					//계약금-계약금 현금지급
		ad_bean.setAmt4			(pur.getTrf_amt1());	//잔금1
		ad_bean.setAmt5			(pur.getTrf_amt2());	//잔금2
		ad_bean.setAmt6			(pur.getTrf_amt3());	//잔금3
		ad_bean.setAmt7			(pur.getTrf_amt4());	//잔금4
		ad_bean.setSa_code		(String.valueOf(per.get("SA_CODE")));
		ad_bean.setKname		(String.valueOf(per.get("KNAME")));
		ad_bean.setDept_code		(String.valueOf(per.get("DEPT_CODE")));
		ad_bean.setDept_name		(String.valueOf(per.get("DEPT_NAME")));
		ad_bean.setInsert_id		(String.valueOf(per.get("SA_CODE")));
		ad_bean.setCar_st		(cr_bean.getCar_use());
		ad_bean.setVen_type		("0");
		ad_bean.setS_idno		(s_idno);
		ad_bean.setCardno1		(pur.getCardno1());
		ad_bean.setCardno2		(pur.getCardno2());
		ad_bean.setCardno3		(pur.getCardno3());
		ad_bean.setCardno4		(pur.getCardno4());
		ad_bean.setCardnm1		(pur.getTrf_cont1());
		ad_bean.setCardnm2		(pur.getTrf_cont2());
		ad_bean.setCardnm3		(pur.getTrf_cont3());
		ad_bean.setCardnm4		(pur.getTrf_cont4());
		ad_bean.setVen_code4	(value7[idx]==null? "":value7[idx]);
		ad_bean.setFirm_nm4		(neoe_db.getCodeByNm("ven", value7[idx]));
		ad_bean.setVen_code5	(value8[idx]==null? "":value8[idx]);
		ad_bean.setFirm_nm5		(neoe_db.getCodeByNm("ven", value8[idx]));
		ad_bean.setVen_code6	(value9[idx]==null? "":value9[idx]);
		ad_bean.setFirm_nm6		(neoe_db.getCodeByNm("ven", value9[idx]));
		ad_bean.setVen_code7	(value10[idx]==null? "":value10[idx]);
		ad_bean.setFirm_nm7		(neoe_db.getCodeByNm("ven", value10[idx]));
		ad_bean.setNm_item		(cr_bean.getCar_nm()+" "+cr_bean.getCar_no());
		
		if(ad_bean.getVen_code().equals("995476")) {	ad_bean.setVen_code("996214");	}
		if(ad_bean.getVen_code2().equals("995476")){	ad_bean.setVen_code2("996214");	}
		if(ad_bean.getVen_code3().equals("995476")){	ad_bean.setVen_code3("996214");	}
		if(ad_bean.getVen_code4().equals("995476")){	ad_bean.setVen_code4("996214");	}
		if(ad_bean.getVen_code5().equals("995476")){	ad_bean.setVen_code5("996214");	}
		if(ad_bean.getVen_code6().equals("995476")){	ad_bean.setVen_code6("996214");	}
		if(ad_bean.getVen_code7().equals("995476")){	ad_bean.setVen_code7("996214");	}
		
		
		String  no_docu = neoe_db.insertCarPurAmtAutoDocu(ad_bean, pur);
		
		
		//if(data_no >0){
		
		if(!no_docu.equals("")){
			pur.setDlv_ext_ven_code		(value4[idx]);
			pur.setCar_off_ven_code		(value5[idx]);
			pur.setCard_com_ven_code	(value6[idx]);
			pur.setAutodocu_write_date	(dlv_dt);
			//pur.setAutodocu_data_no	(Integer.toString(data_no));
			pur.setAutodocu_data_no		(no_docu);
			
			//=====[CAR_PUR] update=====
			flag4 = a_db.updateContPur(pur);
		}
		/*
		out.println("<br>");
		out.println("<br>");
		out.println("ad_bean.setWrite_dt	]"+ad_bean.getWrite_dt		());out.println("<br>");
		out.println("ad_bean.setNode_code	]"+ad_bean.getNode_code		());out.println("<br>");
		out.println("ad_bean.setVen_code	]"+ad_bean.getVen_code		());out.println("<br>");
		out.println("ad_bean.setFirm_nm		]"+ad_bean.getFirm_nm		());out.println("<br>");
		out.println("ad_bean.setVen_code2	]"+ad_bean.getVen_code2		());out.println("<br>");
		out.println("ad_bean.setFirm_nm2	]"+ad_bean.getFirm_nm2		());out.println("<br>");
		out.println("ad_bean.setVen_code3	]"+ad_bean.getVen_code3		());out.println("<br>");
		out.println("ad_bean.setFirm_nm3	]"+ad_bean.getFirm_nm3		());out.println("<br>");
		out.println("ad_bean.setAcct_dt		]"+ad_bean.getAcct_dt		());out.println("<br>");
		out.println("ad_bean.setAcct_cd1	]"+ad_bean.getAcct_cd1		());out.println("<br>");
		out.println("ad_bean.setAcct_cd2	]"+ad_bean.getAcct_cd2		());out.println("<br>");
		out.println("ad_bean.setAcct_cd3	]"+ad_bean.getAcct_cd3		());out.println("<br>");
		out.println("ad_bean.setAcct_cd4	]"+ad_bean.getAcct_cd4		());out.println("<br>");
		out.println("ad_bean.setAcct_cont	]"+ad_bean.getAcct_cont		());out.println("<br>");
		out.println("ad_bean.setAmt			]"+ad_bean.getAmt			());out.println("<br>");
		out.println("ad_bean.setAmt2		]"+ad_bean.getAmt2			());out.println("<br>");
		out.println("ad_bean.setAmt3		]"+ad_bean.getAmt3			());out.println("<br>");
		out.println("ad_bean.setAmt4		]"+ad_bean.getAmt4			());out.println("<br>");
		out.println("ad_bean.setAmt5		]"+ad_bean.getAmt5			());out.println("<br>");
		out.println("ad_bean.setAmt6		]"+ad_bean.getAmt6			());out.println("<br>");
		out.println("ad_bean.setAmt7		]"+ad_bean.getAmt7			());out.println("<br>");
		out.println("ad_bean.setSa_code		]"+ad_bean.getSa_code		());out.println("<br>");
		out.println("ad_bean.setKname		]"+ad_bean.getKname			());out.println("<br>");
		out.println("ad_bean.setDept_code	]"+ad_bean.getDept_code		());out.println("<br>");
		out.println("ad_bean.setDept_name	]"+ad_bean.getDept_name		());out.println("<br>");
		out.println("ad_bean.setInsert_id	]"+ad_bean.getInsert_id		());out.println("<br>");
		out.println("ad_bean.setCar_st		]"+ad_bean.getCar_st		());out.println("<br>");
		out.println("ad_bean.setVen_type	]"+ad_bean.getVen_type		());out.println("<br>");
		out.println("ad_bean.setS_idno		]"+ad_bean.getS_idno		());out.println("<br>");
		if(1==1)return;
		*/
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'pur_pay_autodocu.jsp';
//		fm.target = '_parent';
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
