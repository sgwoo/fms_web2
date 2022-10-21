<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.im_email.*, acar.user_mng.*, tax.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	int vid_size = request.getParameter("vid_size")==null?0:Util.parseInt(request.getParameter("vid_size"));
	
	ImEmailDatabase ie_db = ImEmailDatabase.getInstance();
	
	
	String dm_st[] 		= request.getParameterValues("st");
	String dmidx[] 		= request.getParameterValues("dmidx");
	String email[] 		= request.getParameterValues("email");
	String firm_nm[] 	= request.getParameterValues("firm_nm");
	int flag = 0;
	
		
	for(int i=0;i < vid_size;i++){
		
		Hashtable ht = ie_db.getIm_dmail_info(dmidx[i], dm_st[i]);
		
		String mailto 	= "\""+firm_nm[i]+"\"<"+email[i]+">";
		String content  =  ie_db.getIm_dmail_content(dmidx[i], dm_st[i]);
		String mailfrom = "tax@amazoncar.co.kr";
		
		if(dm_st[i].equals("3"))	mailfrom = "sales@amazoncar.co.kr";
		if(dm_st[i].equals("4"))	mailfrom = "tax200@amazoncar.co.kr";
		
		//보험안내문
		if(dm_st[i].equals("4") || dm_st[i].equals("8")){
			if(String.valueOf(ht.get("GUBUN")).equals("insur") || String.valueOf(ht.get("GUBUN")).indexOf("insreg") != -1){
				mailfrom = "34000233@amazoncar.co.kr";
			}
		}
		
		DmailBean d_bean = new DmailBean();
		d_bean.setSubject			(String.valueOf(ht.get("SUBJECT")));
		d_bean.setSql				("SSV:"+email[i].trim());
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailto			("\""+firm_nm[i]+"\"<"+email[i].trim()+">");
		d_bean.setMailfrom			(String.valueOf(ht.get("MAILFROM")));
		d_bean.setReplyto			("\"아마존카\"<no-reply@amazoncar.co.kr>");
		d_bean.setErrosto			("\"아마존카\"<return@amazoncar.co.kr>");			
		d_bean.setHtml				(1);
		d_bean.setEncoding			(0);
		d_bean.setCharset			("euc-kr");
		d_bean.setDuration_set		(1);
		d_bean.setClick_set			(0);
		d_bean.setSite_set			(0);
		d_bean.setAtc_set			(0);
		d_bean.setGubun				(String.valueOf(ht.get("GUBUN")));
		d_bean.setRname				("mail");
		d_bean.setMtype       		(0);
		d_bean.setU_idx       		(1);//admin계정
		d_bean.setG_idx				(1);//admin계정
		d_bean.setMsgflag     		(0);
		d_bean.setContent			(content);
		d_bean.setGubun2			(String.valueOf(ht.get("GUBUN2")));
		
		if(!ie_db.insertDEmail(d_bean, dm_st[i], "", "+7")) flag += 1;
		
		/*
		out.println("dm_st="+dm_st[i]);
		out.println("dmidx="+dmidx[i]);
		out.println("mailto="+mailto);
		out.println("content="+content);
		out.println("<br>");
//		if(1==1)return;
		*/
	}
	
	
%>


<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
<script language="JavaScript">
<!--
	<%if(flag==0){%>
	alert('정상 발송되었습니다.');
	<%}else{%>
	alert(<%=flag%>+'건이 발송되지 않았습니다.');	
	<%}%>
	
	parent.window.close();
//-->
</script>  
</form>	
</body>
</html>