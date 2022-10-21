<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cus_reg.*"%>
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
	
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String set_dt 	= request.getParameter("set_dt")==null?"":request.getParameter("set_dt");
	
	
	int result = 0;
		
	CusReg_Database cr_db = CusReg_Database.getInstance();
		
	String vid[] 	= request.getParameterValues("ch_cd");
	String car_mng_id 	= "";
	String serv_id 	= "";
	int vid_size = vid.length;
	
	String value[] = new String[2];
	
	String req_code  = Long.toString(System.currentTimeMillis());
	
%>

<%
// 일괄처리
	for(int i=0;i < vid_size;i++){
		
		StringTokenizer st = new StringTokenizer(vid[i],"/");
		int s=0;
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		car_mng_id 		= value[0];
		serv_id		= value[1];
		
		if ( cmd.equals("d")) {
			result = cr_db.deleteScdServ(car_mng_id, serv_id);
			result = cr_db.delServ_item_all(car_mng_id, serv_id);
		//} else {
		//	result = cr_db.updateServiceSet(car_mng_id, serv_id, user_id , set_dt, req_code);	
		}	
	}

	System.out.println("협력업체 일괄처리 ->" + 	car_mng_id+ ":" + set_dt);
%>

<script language='javascript'>
<%	if( result  < 1 ){	%>	alert('수정 에러입니다.\n\n확인하십시오');					<%		}	%>		
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
	 alert('처리되었습니다');	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>

</body>
</html>