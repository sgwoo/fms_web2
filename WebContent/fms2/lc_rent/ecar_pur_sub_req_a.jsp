<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.ext.*"%>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 		= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String ext_est_dt = request.getParameter("ext_est_dt")==null?"":request.getParameter("ext_est_dt");
	
	boolean flag = true;
	

	
	String vid[] 	= request.getParameterValues("ch_cd");
	
	String vid_num 	= "";
	String ch_m_id		= "";
	String ch_l_cd		= "";
	
	int vid_size = vid.length;
	
	
	for(int i=0;i < vid_size;i++){
		
		vid_num 	= vid[i];
		
		ch_m_id 		= vid_num.substring(0,6);
		ch_l_cd 		= vid_num.substring(6,19);
		
		//car_etc
		ContCarBean car 	= a_db.getContCarNew(ch_m_id, ch_l_cd);
	
		//친환경차 구매보조금
		ExtScdBean ecar_pur = ae_db.getAGrtScd(ch_m_id, ch_l_cd, "1", "7", "1");//기존 등록 여부 조회
		int ecar_pur_gbn = 1;	//기존
		if(ecar_pur == null || ecar_pur.getRent_l_cd().equals("")){
			ecar_pur_gbn = 0;	//신규
			ecar_pur = new ExtScdBean();
			ecar_pur.setRent_mng_id	(ch_m_id);
			ecar_pur.setRent_l_cd		(ch_l_cd);
			ecar_pur.setRent_st			("1");
			ecar_pur.setRent_seq		("1");
			ecar_pur.setExt_id			("0");
			ecar_pur.setExt_st			("7");
			ecar_pur.setExt_tm			("1");
			ecar_pur.setExt_s_amt		(car.getEcar_pur_sub_amt());
			ecar_pur.setExt_v_amt		(0);
		}
		ecar_pur.setUpdate_id			(user_id);
		ecar_pur.setExt_est_dt		(ext_est_dt);
		
		//=====[scd_ext] update=====
		if(ecar_pur_gbn == 1)	flag = ae_db.updateGrt(ecar_pur);
		else									flag = ae_db.insertGrt(ecar_pur);
		
	}
	
%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<script language='javascript'>
<%		if(!flag){	%>	alert('구매보조금 청구 에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'> 
  <input type='hidden' name='gubun6' 	value='<%=gubun6%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>