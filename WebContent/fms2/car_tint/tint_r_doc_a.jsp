<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.tint.*, acar.doc_settle.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	
	
%>


<%
	String req_dt 	= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String vid[] 	= request.getParameterValues("ch_cd");
	String vid_num 	= "";
	String tint_no 	= "";
	String off_id 	= "";
	String seq = "";
	String value[] = new String[10];
	
	int vid_size = vid.length;
	
	
	
	out.println("선택건수="+vid_size+"<br><br>");
	
	for(int i=0;i < vid_size;i++){
		
		StringTokenizer st = new StringTokenizer(vid[i],"/");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		tint_no 		= value[0];
		off_id 			= value[1];
		
		//용품관리
		TintBean tint 	= t_db.getCarTint(tint_no);
		
		
		//1. 문서처리전 결재처리-------------------------------------------------------------------------------------------
		
		//문서품의
		DocSettleBean doc = d_db.getDocSettleCommi("6", tint.getDoc_code());
		
		String doc_bit 	= "6";
		String doc_step = "3";
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc.getDoc_no(), user_id, doc_bit, doc_step);
		out.println("문서처리전 결재<br>");



		//2. 용품의뢰 청구일자 수정-------------------------------------------------------------------------------------------
		
		if(!tint.getReg_st().equals("A") && !tint.getRent_l_cd().equals("")){
			TintBean tint1 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "1");
			TintBean tint2 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "2");
			TintBean tint3 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "3");
			TintBean tint4 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "4");
			TintBean tint5 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "5");	
			TintBean tint6 	= t_db.getCarTint(tint.getRent_mng_id(), tint.getRent_l_cd(), "6");	

			//=====[tint] update=====
			if(off_id.equals(tint1.getOff_id()) && tint.getDoc_code().equals(tint1.getDoc_code()) && tint1.getReq_dt().equals("")) 	flag1 = t_db.updateCarTintReqDt(tint1.getTint_no(), req_dt);
			if(off_id.equals(tint2.getOff_id()) && tint.getDoc_code().equals(tint2.getDoc_code()) && tint2.getReq_dt().equals("")) 	flag1 = t_db.updateCarTintReqDt(tint2.getTint_no(), req_dt);
			if(off_id.equals(tint3.getOff_id()) && tint.getDoc_code().equals(tint3.getDoc_code()) && tint3.getReq_dt().equals("")) 	flag1 = t_db.updateCarTintReqDt(tint3.getTint_no(), req_dt);
			if(off_id.equals(tint4.getOff_id()) && tint.getDoc_code().equals(tint4.getDoc_code()) && tint4.getReq_dt().equals("")) 	flag1 = t_db.updateCarTintReqDt(tint4.getTint_no(), req_dt);
			if(off_id.equals(tint5.getOff_id()) && tint.getDoc_code().equals(tint5.getDoc_code()) && tint5.getReq_dt().equals("")) 	flag1 = t_db.updateCarTintReqDt(tint5.getTint_no(), req_dt);
			if(off_id.equals(tint6.getOff_id()) && tint.getDoc_code().equals(tint6.getDoc_code()) && tint6.getReq_dt().equals("")) 	flag1 = t_db.updateCarTintReqDt(tint6.getTint_no(), req_dt);
		}else{
			//=====[tint] update=====
			flag1 = t_db.updateCarTintReqDt(tint_no, req_dt);	
		}			
				
	}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('용품 수정 에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

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
  <input type='hidden' name="mode" 				value="<%=mode%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>