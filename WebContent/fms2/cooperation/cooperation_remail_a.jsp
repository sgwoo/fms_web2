<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cooperation.*, acar.im_email.*, tax.*"%>
<jsp:useBean id="cp_bean" class="acar.cooperation.CooperationBean" scope="page"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

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
	String out_content 	= request.getParameter("out_content")==null?"":request.getParameter("out_content");
	String title	 	= request.getParameter("title")==null?"":request.getParameter("title");
	String agnt_nm 		= request.getParameter("agnt_nm")==null?"":request.getParameter("agnt_nm");
	String agnt_m_tel	= request.getParameter("agnt_m_tel")==null?"":request.getParameter("agnt_m_tel");
	String agnt_email	= request.getParameter("agnt_email")==null?"":request.getParameter("agnt_email");
	String firm_nm		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	String sender_id = "";
	String target_id = "";
	
	int count = 0;
	int flag = 0;
	boolean flag6 = true;
	
	
	
	cp_bean = cp_db.getCooperationBean(seq);
	
	cp_bean.setAgnt_nm		(agnt_nm);
	cp_bean.setAgnt_m_tel	(agnt_m_tel);
	cp_bean.setAgnt_email	(agnt_email);
	
	count = cp_db.updateCooperation(cp_bean);
	
	
	//고객요청인 경우 완료메일 발송
	if(cp_bean.getReq_st().equals("2") && from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){
		
		if(!agnt_email.equals("")){
		
			//	1. d-mail 등록-------------------------------
			
			DmailBean d_bean = new DmailBean();
			d_bean.setSubject			(firm_nm+"님, 아마존카에 요청하신 사항이 완료되었습니다.");
			d_bean.setSql				("SSV:"+agnt_email.trim());
			d_bean.setReject_slist_idx	(0);
			d_bean.setBlock_group_idx	(0);
			d_bean.setMailfrom			("\"아마존카\"<tax200@amazoncar.co.kr>");
			d_bean.setMailto			("\""+firm_nm+"\"<"+agnt_email.trim()+">");
			d_bean.setReplyto			("\"아마존카\"<tax200@amazoncar.co.kr>");
			d_bean.setErrosto			("\"아마존카\"<tax200@amazoncar.co.kr>");
			d_bean.setHtml				(1);
			d_bean.setEncoding			(0);
			d_bean.setCharset			("euc-kr");
			d_bean.setDuration_set		(1);
			d_bean.setClick_set			(0);
			d_bean.setSite_set			(0);
			d_bean.setAtc_set			(0);
			d_bean.setGubun				(seq+"cooperation");
			d_bean.setRname				("mail");
			d_bean.setMtype       		(0);
			d_bean.setU_idx       		(1);//admin계정
			d_bean.setG_idx				(1);//admin계정
			d_bean.setMsgflag     		(0);
			d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/ask/re_ask.jsp?seq="+seq);
			d_bean.setGubun2			(cp_bean.getClient_id());
			if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
			
		}
		
		if(!agnt_m_tel.equals("")){
		
			String msg_body = firm_nm+"님, 아마존카에 요청하신 사항이 완료되었습니다.";
			IssueDb.insertsendMail_V5_H("02-757-0802", "(주)아마존카", agnt_m_tel, agnt_nm, "", "", "0", "", msg_body, "", cp_bean.getClient_id(), ck_acar_id, "4");
		}
	}
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
  <input type='hidden' name='seq' 		value='<%=count%>'>             
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<%	if(count>0){%>
		alert("정상적으로 처리되었습니다.");		
		parent.window.close();		
		
		<%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){%>
		parent.opener.location.href = "cooperation_c_sc.jsp";	
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