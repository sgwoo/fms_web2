<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.cont.*, acar.car_mst.*" %>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

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
	String car_st		= request.getParameter("car_st")	==null?"0":request.getParameter("car_st");	
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
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/estimate.js'></script>
<script language="JavaScript">
<!--
	function go_sp_esti(){
		var fm = document.form1;
		fm.from_page.value = '/fms2/lc_rent/lc_s_frame.jsp';
		fm.action = "/acar/secondhand_hp/estimate.jsp";
		fm.target = '_blank';
		fm.submit();
	}
	
	function go_sp_esti_fms(){
		var fm = document.form1;
		fm.from_page.value = '/fms2/lc_rent/lc_s_frame.jsp';
		fm.action = "/acar/secondhand_hp/estimate_fms.jsp";
		fm.target = '_blank';
		fm.submit();
	}	
	
	function go_sp_esti_fms_ym(){
		var fm = document.form1;
		fm.from_page.value = '/fms2/lc_rent/lc_s_frame.jsp';
		fm.action = "/acar/secondhand_hp/estimate_fms_ym.jsp";
		fm.target = '_blank';
		fm.submit();
	}		
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
	<%if(from_page.equals("main_car")){%>
	
		<%if(action_st.equals("")){%>		
		alert('견적완료');			
		document.form1.target = 'd_content';		
		document.form1.action = '/acar/main_car/main_car_upd_20090901.jsp';
		document.form1.submit();
		<%}else if(action_st.equals("h")||action_st.equals("r")){%>
		parent.window.close();
		<%}else if(action_st.equals("h_a")||action_st.equals("r_a")){%>
		alert('견적완료');			
		parent.location.href = '/acar/main_car/main_car_frame.jsp';
		parent.window.close();
		<%}%>
		
	<%}else{%>
		<%if(!o_bean.getEst_id().equals("")){%>
			alert('견적완료');
				
		//결과값 처리하기---------------------------------------------------------------
		
		
		<%	if(est_from.equals("cmpadd")){%>
		
				document.form1.target = 'd_content';
			
				if(document.form1.add_rent_st.value == 'a'){
					document.form1.action = "/fms2/lc_rent/lc_bc_add_u.jsp";
				}else if(document.form1.add_rent_st.value == 's'){
					document.form1.action = "/fms2/lc_rent/lc_bc_cls_u.jsp";
				}else if(document.form1.add_rent_st.value.indexOf('im') != -1){
					document.form1.action = "/fms2/lc_rent/lc_bc_im_u.jsp";
				}
							
				document.form1.submit();		
		
		<%	}else if(est_from.equals("cmp")){//영업효율결과값등록%>
				parent.document.form1.o_13.value 			= <%=o_bean.getO_13()%>;
				parent.document.form1.ro_13.value 			= <%=o_bean.getRo_13()%>;			
				parent.document.form1.ro_13_amt.value 		= parseDecimal(<%=o_bean.getRo_13_amt()%>);
				parent.opt_display();		
		<%	}else if(est_from.equals("tae_car")){//출고지연대차결과값등록%>
				parent.document.form1.tae_rent_inv_s.value 	= parseDecimal(<%=o_bean.getFee_s_amt()%>);
				parent.document.form1.tae_rent_inv_v.value 	= parseDecimal(<%=o_bean.getFee_v_amt()%>);		
				parent.document.form1.tae_rent_inv.value 	= parseDecimal(<%=o_bean.getFee_s_amt()+o_bean.getFee_v_amt()%>);
				parent.document.form1.tae_est_id.value 		= '<%=o_bean.getEst_id()%>';
				
				parent.document.form1.tae_rent_fee_s.value 	= parseDecimal(sup_amt(toInt(parseDigit(parent.document.form1.tae_rent_fee.value))));
				parent.document.form1.tae_rent_fee_v.value 	= parseDecimal(toInt(parseDigit(parent.document.form1.tae_rent_fee.value)) - toInt(parseDigit(parent.document.form1.tae_rent_fee_s.value)));
			
		<%	}else{%>
		<%		if(from_page.equals("car_rent")){//계약관리에서 호출%>
		<%			if(esti_stat.equals("account")){//견적하기%>
		
						parent.document.form1.max_ja.value 		= <%=o_bean.getO_13()%>;
		<%				if(o_bean.getO_13()==o_bean.getRo_13()){%>
							parent.document.form1.ja_amt.value 		= parseDecimal(<%=o_bean.getRo_13_amt()%>);
		<%				}else{%>
							parent.document.form1.ja_amt.value 		= parseDecimal(<%=o_bean.getO_1()%>*<%=o_bean.getO_13()%>/100);
		<%				}%>			
						parent.document.form1.ja_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(parent.document.form1.ja_amt.value))));
						parent.document.form1.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(parent.document.form1.ja_amt.value)) - toInt(parseDigit(parent.document.form1.ja_s_amt.value)));
			
						parent.document.form1.app_ja.value 		= <%=o_bean.getRo_13()%>;
			
						if(parent.document.form1.app_ja.value == parent.document.form1.opt_per.value){
							parent.document.form1.ja_r_amt.value 	= parent.document.form1.opt_amt.value;
							parent.document.form1.ja_r_s_amt.value 	= parent.document.form1.opt_s_amt.value;
							parent.document.form1.ja_r_v_amt.value 	= parent.document.form1.opt_v_amt.value;
						}else{
							parent.document.form1.ja_r_amt.value 	= parseDecimal(<%=o_bean.getRo_13_amt()%>);
							parent.document.form1.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(parent.document.form1.ja_r_amt.value))));
							parent.document.form1.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(parent.document.form1.ja_r_amt.value)) - toInt(parseDigit(parent.document.form1.ja_r_s_amt.value)));
						}
						parent.document.form1.inv_s_amt.value 	= parseDecimal(<%=o_bean.getFee_s_amt()%>);
						parent.document.form1.inv_v_amt.value 	= parseDecimal(<%=o_bean.getFee_v_amt()%>);
						parent.document.form1.inv_amt.value 	= parseDecimal(<%=o_bean.getFee_s_amt()+o_bean.getFee_v_amt()%>);
			
			
						if(<%=o_bean.getRent_dt()%> >= 20150217){
							parent.document.form1.e_over_run_amt.value 	= parseDecimal(<%=o_bean.getOver_run_amt()%>);
							parent.document.form1.e_agree_dist.value 	= parseDecimal(<%=o_bean.getB_agree_dist()%>);
							parent.document.form1.r_agree_dist.value 	= parseDecimal(<%=o_bean.getAgree_dist()%>);
							if(<%=o_bean.getRent_dt()%> >= 20220415){
								parent.document.form1.e_rtn_run_amt.value 	= parseDecimal(<%=o_bean.getRtn_run_amt()%>);
							}	
						}			
			
						//20150512 DC율 계산해서 넘기기
						if(<%=o_bean.getRent_dt()%> >= 20150512){
							var dc_ra 	= 0;
							var fee_s_amt 	= toInt(parseDigit(parent.document.form1.fee_s_amt.value));
							var inv_s_amt 	= <%=o_bean.getFee_s_amt()%>;
							var ins_s_amt 	= toInt(parseDigit(parent.document.form1.ins_s_amt.value));
							var driver_add_s_amt 	= toInt(parseDigit(parent.document.form1.driver_add_amt.value));
							inv_s_amt = inv_s_amt+ins_s_amt+driver_add_s_amt;							
							var k_so 	= toInt('<%=String.valueOf(esti_exam.get("K_SO"))==null?"0":String.valueOf(esti_exam.get("K_SO"))%>');
							var ax117 	= toInt('<%=String.valueOf(esti_exam.get("AX117"))==null?"0":String.valueOf(esti_exam.get("AX117"))%>');
							if(fee_s_amt  > 0 && inv_s_amt> 0){
								dc_ra = (inv_s_amt-fee_s_amt) / (inv_s_amt-k_so-ax117) *100;
								parent.document.form1.dc_ra.value = parseFloatCipher3(dc_ra,1);
								parent.document.form1.dc_ra_amt.value = parseDecimal((inv_s_amt-fee_s_amt)*1.1);
							}
													
							
						}else{
							parent.dc_fee_amt();
						}
			
						parent.document.form1.bc_b_e1.value 	= <%=bc_b_e1%>;
						parent.document.form1.bc_b_e2.value 	= parseDecimal(<%=bc_b_e2%>);
						parent.setTinv_amt();
						
						if('<%=o_bean.getEst_st()%>' == '1' || '<%=o_bean.getEst_st()%>' == '4'){
							parent.document.form1.cls_per.value 		= <%=o_bean.getCls_per()%>;
							parent.document.form1.cls_n_per.value 		= <%=o_bean.getCls_n_per()%>;
							if(<%=o_bean.getCls_per()%>>100 && <%=o_bean.getFee_s_amt()%> == -1){
								alert('위약금율이 100%를 초과하였습니다. 위약금율이 100% 이내가 되도록 보증금을 줄여주세요.');
							}
						}
						
						
						
			
		<%			}else if(esti_stat.equals("view")){//보기%>
		<%			}%>
		<%		}else if(from_page.equals("car_esti")){//연장견적%>
					parent.document.form1.max_ja.value 		= <%=o_bean.getO_13()%>;
		<%			if(o_bean.getO_13()==o_bean.getRo_13()){%>
						parent.document.form1.ja_amt.value 		= parseDecimal(<%=o_bean.getRo_13_amt()%>);
		<%			}else{%>
						parent.document.form1.ja_amt.value 		= parseDecimal(<%=o_bean.getO_1()%>*<%=o_bean.getO_13()%>/100);
		<%			}%>			
						parent.document.form1.ja_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(parent.document.form1.ja_amt.value))));
						parent.document.form1.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(parent.document.form1.ja_amt.value)) - toInt(parseDigit(parent.document.form1.ja_s_amt.value)));
						
						parent.document.form1.app_ja.value 		= <%=o_bean.getRo_13()%>;
			
					if(parent.document.form1.app_ja.value == parent.document.form1.opt_per.value){
						parent.document.form1.ja_r_amt.value 	= parent.document.form1.opt_amt.value;
						parent.document.form1.ja_r_s_amt.value 	= parent.document.form1.opt_s_amt.value;
						parent.document.form1.ja_r_v_amt.value 	= parent.document.form1.opt_v_amt.value;
					}else{
						parent.document.form1.ja_r_amt.value 	= parseDecimal(<%=o_bean.getRo_13_amt()%>);
						parent.document.form1.ja_r_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(parent.document.form1.ja_r_amt.value))));
						parent.document.form1.ja_r_v_amt.value 	= parseDecimal(toInt(parseDigit(parent.document.form1.ja_r_amt.value)) - toInt(parseDigit(parent.document.form1.ja_r_s_amt.value)));
					}
					parent.document.form1.inv_s_amt.value 	= parseDecimal(<%=o_bean.getFee_s_amt()%>);
					parent.document.form1.inv_v_amt.value 	= parseDecimal(<%=o_bean.getFee_v_amt()%>);
					parent.document.form1.inv_amt.value 	= parseDecimal(<%=o_bean.getFee_s_amt()+o_bean.getFee_v_amt()%>);
			
					go_sp_esti_fms();	
			
		<%		}else if(from_page.equals("car_esti_s")){//연장견적2%>
					go_sp_esti_fms_ym();	
		<%		}%>		
		<%	}%>
		
		<%}else{%>		
		alert('견적오류발행!!');
		<%}%>
		
	<%}%>
//-->
</script>
</body>
</html>
