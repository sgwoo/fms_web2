<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.receive.*,  acar.user_mng.*"%>
<jsp:useBean id="rc_db" scope="page" class="acar.receive.ReceiveDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
			
	String cmd	 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	int flag = 0;
	int count = 1;	
	
	boolean flag1 = true;
	boolean flag2 = true;
		
	ClsGuarBean cls = new ClsGuarBean();	

	if (cmd.equals("D")) {
		if(!rc_db.deleteClsGuarIp(rent_mng_id, rent_l_cd ))	flag += 1;	
	} else  {		
		
		cls.setRent_mng_id(rent_mng_id);
		cls.setRent_l_cd(rent_l_cd);
		cls.setIp_dt(request.getParameter("ip_dt"));  //입금일자
	//	cls.setReq_amt(request.getParameter("req_amt")==null?0:			AddUtil.parseDigit(request.getParameter("req_amt"))); //청구금액
		cls.setIp_amt(request.getParameter("ip_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ip_amt"))); //입금금액
		cls.setUpd_id(user_id); //			
		cls.setRemark(request.getParameter("remark")==null?"":request.getParameter("remark"));
			
		if(!rc_db.updateClsGuarIp(cls))	flag += 1;
	}

	
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//보증보험 테이블에 저장 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//보증보함심테이블에 저장 성공.. %>

    alert('처리되었습니다');		
  	top.window.close();				
	fm.s_kd.value = '5';
//	fm.t_wd.value = fm.rent_l_cd.value;
    fm.action='/fms2/receive/gua_d_frame.jsp';
 
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
