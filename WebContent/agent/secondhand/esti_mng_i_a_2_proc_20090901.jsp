<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.cont.*, acar.car_mst.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String MEMBER_ID 	= request.getParameter("MEMBER_ID")	==null?"":request.getParameter("MEMBER_ID");
	String SAWON 		= request.getParameter("SAWON")		==null?"":request.getParameter("SAWON");
%>
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"1":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"1":request.getParameter("gubun4");
	String s_dt 		= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 		= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	
	String cmd 		= request.getParameter("cmd")		==null?"":request.getParameter("cmd");
	String e_page 		= request.getParameter("e_page")	==null?"":request.getParameter("e_page");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");
	String est_from 	= request.getParameter("est_from")	==null?"":request.getParameter("est_from");
	String esti_stat	= request.getParameter("esti_stat")	==null?"":request.getParameter("esti_stat");
	String l_cd 		= request.getParameter("l_cd")		==null?"":request.getParameter("l_cd");
	String m_id 		= request.getParameter("m_id")		==null?"":request.getParameter("m_id");
	String fee_rent_st 	= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	String add_rent_st 	= request.getParameter("add_rent_st")==null?"":request.getParameter("add_rent_st");
	String insur_per	= request.getParameter("insur_per")	==null?"":request.getParameter("insur_per");
	String one_self		= request.getParameter("one_self")	==null?"":request.getParameter("one_self");
	String reg_dt		= request.getParameter("reg_dt")	==null?"":request.getParameter("reg_dt");
	String action_st 	= request.getParameter("action_st")	==null?"":request.getParameter("action_st");
	String reg_code		= request.getParameter("reg_code")	==null?"":request.getParameter("reg_code");
	String est_code		= request.getParameter("est_code")	==null?"":request.getParameter("est_code");
	String esti_table	= request.getParameter("esti_table")==null?"":request.getParameter("esti_table");
	String opt_chk		= request.getParameter("opt_chk")	==null?"0":request.getParameter("opt_chk");	
	String fee_opt_amt	= request.getParameter("fee_opt_amt")==null?"0":request.getParameter("fee_opt_amt");
	String jg_b_dt		= "";
	String em_a_j		= "";
	String ea_a_j		= "";
	
	if(esti_table.equals("")) 	esti_table 	= "estimate_sh";
	if(!est_code.equals("")) 	reg_code 	= est_code;
	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	
	//System.out.println("**주요차종견적 reg_code="+reg_code+"-------------------------------");
	out.println("#### reg_code="+reg_code+"-------------------------------<br>");
	out.println("#### est_code="+est_code+"-------------------------------<br>");
	out.println("#### esti_table="+esti_table+"---------------------------<br>");
	out.println("#### l_cd="+l_cd+"-------------------------------<br>");
	out.println("#### m_id="+m_id+"-------------------------------<br>");
	out.println("#### fee_rent_st="+fee_rent_st+"---------------------------<br>");	
	
	
	
	String est_id[]  	= request.getParameterValues("est_id");
	int est_size 		= est_id.length;
	int count 			= 0;
	
	float bc_b_e1=0;
	int   bc_b_e2=0;
	
	
	if(cmd.equals("test") && !reg_code.equals("")){
		Vector vt = e_db.getEstiMateRegCodeList(reg_code, esti_table, "");
		int vt_size = vt.size();
		if(vt_size>0){
			est_size = vt_size;
			for(int i = 0 ; i < 1 ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				est_id[i] = String.valueOf(ht.get("EST_ID"));
			}
		}
	}
		
	EstimateBean o_bean = new EstimateBean();
	
	Hashtable esti_exam = new Hashtable();
	
	if(est_size>0){
		
		EstimateBean a_bean = new EstimateBean();
		a_bean = e_db.getEstimateCase(est_id[0]);
		
		
		//자동차기본정보
		CarMstBean cm_bean = cmb.getCarNmCase(a_bean.getCar_id(), a_bean.getCar_seq());
		
		//변수기준일자
		jg_b_dt = e_db.getVar_b_dt(cm_bean.getJg_code(), "jg", a_bean.getRent_dt());
		em_a_j 	= e_db.getVar_b_dt("em", a_bean.getRent_dt());
		ea_a_j 	= e_db.getVar_b_dt("ea", a_bean.getRent_dt());
		
		
		out.println("#### esti_mng_i_a_proc_20090901.jsp--------------------<br>");
		out.println("#### rent_dt="+a_bean.getRent_dt()+"------------------<br>");
		out.println("#### jg_b_dt="+jg_b_dt+"-------------------------------<br>");
		out.println("#### em_a_j="+em_a_j+"---------------------------------<br>");
		out.println("#### ea_a_j="+ea_a_j+"---------------------------------<br>");
		
		//20140424 보유차 기본정보 없으면 만들기(만기매칭대차의 경우)--------------------------		
		String  d_flag2 =  e_db.call_sp_esti_reg_sh_case_base(a_bean.getRent_dt(), a_bean.getMgr_nm(), user_id);
		
		//재리스 계산
		String  d_flag1 =  e_db.call_sp_esti_reg_sh_case(reg_code, jg_b_dt, em_a_j, ea_a_j);
		
		//원페이지에 값 넘기기
		o_bean = e_db.getEstimateCase(reg_code, "org");
		
		if(est_from.equals("tae_car")){
			o_bean = e_db.getEstimateCase(reg_code, "t");
		}
		
		esti_exam = e_db.getEstimateResultVar(o_bean.getEst_id(), "esti_exam");
		
	}
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(m_id, l_cd, fee_rent_st);
	
	bc_b_e1 = fee_etc.getBc_b_e1();
	bc_b_e2 = fee_etc.getBc_b_e2();	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="acar_id" value="<%=ck_acar_id%>">  
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">
  <input type="hidden" name="gubun4" value="<%=gubun4%>">
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">
  <input type="hidden" name="t_wd" value="<%=t_wd%>">
  <input type="hidden" name="est_size" value="<%=est_size%>">
  <input type="hidden" name="cmd" value="<%=cmd%>">  
  <input type="hidden" name="e_page" value="<%=e_page%>">
  <input type="hidden" name="from_page" value="<%=from_page%>">
  <input type="hidden" name="est_from" value="<%=est_from%>">  
  <input type="hidden" name="MEMBER_ID" value='<%=MEMBER_ID%>'>
  <input type="hidden" name="SAWON" value='<%=SAWON%>'>		    
  <input type="hidden" name="l_cd" value='<%=l_cd%>'>		    
  <input type="hidden" name="m_id" value='<%=m_id%>'>
  <input type="hidden" name="rent_mng_id" value='<%=m_id%>'>
  <input type="hidden" name="rent_l_cd" value='<%=l_cd%>'>		    
  <input type="hidden" name="rent_st" value='<%=fee_rent_st%>'>    
  <input type="hidden" name="add_rent_st" value='<%=add_rent_st%>'>    
  <input type="hidden" name="one_self" value="<%=one_self%>">   
  <input type="hidden" name="reg_dt" value='<%=reg_dt%>'>    
  <input type="hidden" name="reg_code" value='<%=reg_code%>'>          
  <input type="hidden" name="est_id" value='<%=est_id[0]%>'>  
  <input type="hidden" name="opt_chk" value="<%=opt_chk%>">                
  <input type="hidden" name="fee_opt_amt" value="<%=fee_opt_amt%>">                
</form>
<script>
<!--
	
		<%if(!o_bean.getEst_id().equals("")){%>
		
		alert('견적완료');
				
		//결과값 처리하기---------------------------------------------------------------
		
		

		<%	if(est_from.equals("tae_car")){//출고지연대차결과값등록%>
		
			parent.document.form1.tae_rent_inv_s.value 	= parseDecimal(<%=o_bean.getFee_s_amt()%>);
			parent.document.form1.tae_rent_inv_v.value 	= parseDecimal(<%=o_bean.getFee_v_amt()%>);		
			parent.document.form1.tae_rent_inv.value 	= parseDecimal(<%=o_bean.getFee_s_amt()+o_bean.getFee_v_amt()%>);
			parent.document.form1.tae_est_id.value 		= '<%=o_bean.getEst_id()%>';
			
			parent.document.form1.tae_rent_fee_s.value 	= parseDecimal(sup_amt(toInt(parseDigit(parent.document.form1.tae_rent_fee.value))));
			parent.document.form1.tae_rent_fee_v.value 	= parseDecimal(toInt(parseDigit(parent.document.form1.tae_rent_fee.value)) - toInt(parseDigit(parent.document.form1.tae_rent_fee_s.value)));
			
		<%	}%>

		
		<%}else{%>		
		alert('견적오류발행!!');
		<%}%>
		
	
//-->
</script>
</body>
</html>
