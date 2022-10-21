<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cooperation.*, acar.coolmsg.*"%>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>	

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CooperationDatabase cp_db = CooperationDatabase.getInstance();
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	int seq 			= request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	String sub_id 		= request.getParameter("sub_id")==null?"":request.getParameter("sub_id");
	
	String sender_id = "";
	String target_id = "";
	
	int count = 0;
	boolean flag6 = true;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	cp_bean = cp_db.getCooperationBean(seq);
	
	out.println("sub_id="+cp_bean.getSub_id());
		
	cp_bean.setSub_id	(sub_id);//처리담당자
	
	out.println("seq="+cp_bean.getSeq());
	out.println("in_dt="+cp_bean.getIn_dt());
	out.println("sub_id="+cp_bean.getSub_id());
	
//	if(1==1)return;
	
	count = cp_db.updateSubid(cp_bean);
	
	
	sender_id = cp_bean.getIn_id();
	target_id = cp_bean.getSub_id();
	
	UsersBean sender_bean 	= umd.getUsersBean(sender_id);
	UsersBean target_bean 	= umd.getUsersBean(target_id);
	
	if (from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")) {
		String sub 		= "FMS업무협조 담당자 배정";
		String cont 	= "["+sender_bean.getUser_nm()+"]님이 FMS업무협조를 요청하셨습니다. 확인바랍니다.";
		String url 		= "/fms2/cooperation/cooperation_it_frame.jsp";
		String m_url  = "/fms2/cooperation/cooperation_it_frame.jsp";
		String xml_data = "";
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  	 </ALERTMSG>"+
	  				"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		flag6 = cm_db.insertCoolMsg(msg);
		
	} else {
		String sub 		= "업무협조 등록";
		String cont 	= "["+sender_bean.getUser_nm()+"]님이 업무협조를 요청하셨습니다. 확인바랍니다.";
		String url 		= "/fms2/cooperation/cooperation_frame.jsp";
		
		String xml_data = "";
		
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
	  				"<BACKIMG>4</BACKIMG>"+
	  				"<MSGTYPE>104</MSGTYPE>"+
	  				"<SUB>"+sub+"</SUB>"+
	  				"<CONT>"+cont+"</CONT>"+
	  				"<URL>http://fms2.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
	  				"    <MSGICON>10</MSGICON>"+
	  				"    <MSGSAVE>1</MSGSAVE>"+
	  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
	  				"  	 </ALERTMSG>"+
	  				"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		flag6 = cm_db.insertCoolMsg(msg);
	}
	
	String valus = "?gubun=it&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&s_year="+s_year+"&s_mon="+s_mon+"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
		   	"&sh_height="+sh_height+"";
%>


<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST" enctype="">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_year' 	value='<%=s_year%>'>
  <input type='hidden' name='s_mon' 	value='<%=s_mon%>'>  
  <input type='hidden' name='s_kd' 		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>  
  <input type='hidden' name='gubun1'	value='<%=gubun1%>'>    
  <input type='hidden' name='gubun2'	value='<%=gubun2%>'>    
  <input type='hidden' name='gubun3'	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4'	value='<%=gubun4%>'>          
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
  <input type='hidden' name='from_page' value='<%=from_page%>'>           
  <input type='hidden' name='seq' 		value='<%=seq%>'>     
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<%	if(count>0){%>
		alert("정상적으로 등록되었습니다.");		
		fm.action='cooperation_u.jsp';	
		fm.target='COOPERATION';
		fm.submit();
		//parent.close();
		
		<%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){%>
		parent.opener.location.href = "cooperation_c_sc.jsp";	
		<%}else if(from_page.equals("/fms2/cooperation/cooperation_n_sc.jsp")){%>
		parent.opener.location.href = "cooperation_n_sc.jsp";	
		<%}else if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){%>
		parent.opener.location.href = "cooperation_it_sc.jsp<%=valus%>";	
		<%}else{%>
		parent.opener.location.href = "cooperation_sc.jsp";	
		<%}%>
				
<%	}else{%>
		alert("에러발생!!");
<%	}%>
//-->
</script>

</body>
</html>