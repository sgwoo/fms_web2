<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.cus_samt.*"%>

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
	String chk 	= request.getParameter("chk")==null?"":request.getParameter("chk");  //
	
	String from_page = "/acar/cus_samt/cus_samt_n1_frame.jsp";
	
	if (chk.equals("pre")) from_page = "/acar/cus_samt/cus_samt_n2_frame.jsp";

	String set_dt 	= request.getParameter("set_dt")==null?"":request.getParameter("set_dt");
	String jung_st 	= request.getParameter("jung_st")==null?"":request.getParameter("jung_st");   //현재정산에서 가장 큰값???
	
	String pre_set_dt 	= request.getParameter("pre_set_dt")==null?"":request.getParameter("pre_set_dt");
	
	CusSamt_Database cs_db = CusSamt_Database.getInstance();	
	
	int flag = 0;
	int count =0;
	boolean flag1 = true;
			
	String value[] = new String[2];
		
	String car_mng_id	="";
	String serv_id 		="";

	String[] ch_call = request.getParameterValues("ch_cd");	

	int vid_size = ch_call.length;
			
	for(int i=0; i < vid_size; i++){
		
		StringTokenizer st = new StringTokenizer(ch_call[i],"^");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
			
		car_mng_id	= value[0];
		serv_id 	= value[1];
			
	//	System.out.println("car_mng_id="+car_mng_id);
	//	System.out.println("serv_id="+serv_id);
						
		//정비테이블에 정산일 및 회차 등록 		
		if(!serv_id.equals("")){			
			if (chk.equals("pre")) {
			  flag1 = cs_db.updateServicePreSetDt( car_mng_id, serv_id, pre_set_dt, user_id);	
		//		System.out.println("car_mng_id="+car_mng_id+ ": serv_id="+serv_id);
			} else {			
			  flag1 = cs_db.updateServiceSetDt( car_mng_id, serv_id, set_dt, jung_st, user_id);	
			}   
		}	
	}

//	System.out.println(end_dt);

%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('정비비 정산 에러입니다.\n\n확인하십시오');					<%		}	%>		
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