<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.client.*, acar.user_mng.*, acar.car_office.*, acar.coolmsg.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 		= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");


	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String cng_item 	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String cng_size 	= request.getParameter("cng_size")==null?"":request.getParameter("cng_size");
	

	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	int result = 0;
	
	String msg_yn = "N"; 
	String target2_yn = "N"; 
	
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	
	
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	
	//car_pur
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd); 
	
	String dlv_est_dt 	= request.getParameter("dlv_est_dt")==null?"":request.getParameter("dlv_est_dt");
	
	if(dlv_est_dt.equals("null")){
		pur.setDlv_est_dt	("");		
	}
	
	pur.setPur_com_firm(request.getParameter("pur_com_firm")	==null?"":request.getParameter("pur_com_firm"));
	
	//=====[CAR_PUR] update=====
	flag4 = a_db.updateContPur(pur);
	
	
	String sub 	= "";
	String cont 	= "";	
	
	
	UsersBean target_bean 	= umd.getUsersBean(base.getBus_id());
	UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("출고관리자"));
	
	if(!client.getClient_st().equals("1") && !client.getFirm_nm().equals(pur.getPur_com_firm())){
		msg_yn 	= "Y"; 
	}
%>


<%
	if(msg_yn.equals("Y")){
	

			
		//쿨메신저 메세지 전송------------------------------------------------------------------------------------------

		sub 	= "계출관리 자동차납품 상호변경";
		cont 	= "[ "+rent_l_cd+" "+request.getParameter("firm_nm")+" -> "+pur.getPur_com_firm()+" ] 계출관리 상호변경되었습니다.";
				
		String url 	= "/fms2/pur_com/lc_rent_c.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|com_con_no="+com_con_no;
		String m_url = "/fms2/pur_com/lc_rent_frame.jsp";
		if(com_con_no.equals("")){
			url 	= "/fms2/pur_com/lc_rent_i.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|com_con_no="+com_con_no;
		}
		
						
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
  						"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
						"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";	 
 						
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		if(target2_yn.equals("Y")){
			xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
		}
		
		xml_data += "    <SENDER></SENDER>"+
  						"    <MSGICON>10</MSGICON>"+
  						"    <MSGSAVE>1</MSGSAVE>"+
  						"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
  						"  </ALERTMSG>"+
  						"</COOLMSG>";
			
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		System.out.println("쿨메신저(계출관리)"+cont+"-----------------------"+target_bean.getUser_nm());
			
		flag2 = cm_db.insertCoolMsg(msg);
	}


%>
<script language='javascript'>
<%		if(!flag4){	%>	alert('계출관리 처리 에러입니다.\n\n확인하십시오');		<%}%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='sort'	value='<%=sort%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'> 
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='from_page'	   value='<%=from_page%>'>   
  <input type='hidden' name='rent_mng_id'  value='<%=rent_mng_id%>'>  
  <input type='hidden' name='rent_l_cd'	   value='<%=rent_l_cd%>'> 
  <input type='hidden' name="com_con_no"   value="<%=com_con_no%>">  
</form>
<script language='javascript'>
	<%if(flag1){%>
	alert('처리되었습니다.');
	<%}%>
	
	<%if(client.getClient_st().equals("1") && com_con_no.equals("")){%>
	<%}else{%>
	parent.self.close();
	<%}%>
	
	var fm = document.form1;	
	fm.action = 'lc_rent_c.jsp';
	if(fm.com_con_no.value == ''){
		fm.action = 'lc_firm_frame.jsp';
	} 
	fm.target = 'd_content';
	fm.submit();
	
</script>
</body>
</html>