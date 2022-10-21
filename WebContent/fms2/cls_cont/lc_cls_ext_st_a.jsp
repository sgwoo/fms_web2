<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.common.*, acar.credit.*, acar.fee.*,  acar.user_mng.*, acar.cls.*,  acar.cont.*, tax.*, acar.bill_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
//	System.out.println("lc_cls_cont_autodoc user_id="+ user_id);
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	String firm_nm = request.getParameter("firm_nm")==null?"":	request.getParameter("firm_nm");
	 	
	int	flag = 0;
	int	count = 0;
	
	String from_page 	= "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	UsersBean user_bean 	= umd.getUsersBean(user_id);
	
	//네오엠

	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
	String insert_id = String.valueOf(per.get("SA_CODE"));
	String dept_code = String.valueOf(per.get("DEPT_CODE"));
	String node_code = "S101";
		
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String cls_dt = request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 	= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String client_id 	= "";
	String site_id 		= "";
	
		
	//선수금 입금일
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
	
		//매입옵션일 (sui)
	String m_sui_dt = request.getParameter("m_sui_dt")==null?"":request.getParameter("m_sui_dt");
	
	String real_date = "";
  	int opt_ip_amt = 0;  
	
		//해지의뢰정보
	ClsEtcBean clse = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
//	String ext_st = clse.getExt_st();  //매입옵션 과입금액 환불여부
	
	String ext_st 	= request.getParameter("ext_st")==null?"":request.getParameter("ext_st");
		
   //해지정보					
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);	
		
	cls_st = "8";
	
	real_date = cls.getCls_dt();
			
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	}
		
//	if ( !m_sui_dt.equals("") ) {
//		 real_date = m_sui_dt;	
//	} else {
		if ( !opt_ip_dt1.equals("") ) {	    	    	
				if ( !cls.getCls_dt().equals(opt_ip_dt1) ) {
				   real_date = opt_ip_dt1;
				} else {
				   real_date = cls.getCls_dt();
				}		   		
		}		
//	}

  	
   opt_ip_amt =   AddUtil.parseDigit(request.getParameter("opt_ip_amt1"))  + AddUtil.parseDigit(request.getParameter("opt_ip_amt2")) - AddUtil.parseDigit(request.getParameter("fdft_amt2")) - AddUtil.parseDigit(request.getParameter("opt_amt"))  -  AddUtil.parseDigit(request.getParameter("sui_d_amt")) ;
    
   System.out.println("매입옵션 차액 =" +opt_ip_amt);
      

   //매입옵션 고객환불인 경우 scd_ext에 등록
  	int cls_ma_cnt = 0;  
  
  //해지의뢰서브내역 저장	
	if(!ac_db.updateClsEtcExtSt(rent_mng_id, rent_l_cd, ext_st))	flag += 1;
	
    if ( ext_st.equals("1")  &&  opt_ip_amt > 0 ) {  //매입옵션 고객환불
	  		cls_ma_cnt = ac_db.getScdExtClsCnt(rent_mng_id, rent_l_cd);
	  		if ( cls_ma_cnt < 1 ) {
	  			if(!ac_db.insertScdExtCls8(rent_mng_id, rent_l_cd, opt_ip_amt, real_date,  user_id)) flag += 1;  
	  		} else {
	  			if(!ac_db.updateScdExtCls8(rent_mng_id, rent_l_cd, opt_ip_amt, real_date,  user_id)) flag += 1;  
	  		}	  		
	}	
	  		  	
	  	
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='cont_st' value=''>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 저장 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 저장 성공.. %>
	
    alert('처리되었습니다');				
	fm.s_kd.value = '2';
//	fm.t_wd.value = fm.rent_l_cd.value;
    fm.action ='<%=from_page%>';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
