<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.forfeit_mng.*, acar.user_mng.*, acar.coolmsg.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  	==null?acar_br:request.getParameter("br_id");
	
	String m_id 		= request.getParameter("m_id")		==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")		==null?"":request.getParameter("l_cd");
	String c_id 		= request.getParameter("c_id")		==null?"":request.getParameter("c_id");
	String seq_no 	= request.getParameter("seq_no")	==null?"":request.getParameter("seq_no");
	String gubun 	= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String mode 		= request.getParameter("mode")		==null?"":request.getParameter("mode");
	
	boolean flag1 = false;
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//납부일자 수정
	if(gubun.equals("proxy_dt")){
		String proxy_dt	= request.getParameter("proxy_dt")	==null?"":request.getParameter("proxy_dt");
		flag1 = a_fdb.updateFineProxy_dt(m_id, l_cd, c_id, seq_no, proxy_dt);
		
	//납부요청 메세지 발송	
	}else if(gubun.equals("send_msg")){
		String param	= request.getParameter("param")	==null?"":request.getParameter("param");
		String [] param_arr = param.split(",");
		String ids = "";
		for(int i=0; i<param_arr.length;i++){
			//메세지 발송가능한 협력업체인지 체크 후 id를 fetch
			Vector vt = umd.getOffUserList(param_arr[i]);
			if(vt.size()>0){
				for(int j=0; j<vt.size();j++){
					Hashtable ht = (Hashtable)vt.elementAt(j);
					ids += "<TARGET>"+String.valueOf(ht.get("ID"))+"</TARGET>";
					
					//메세지 발송할 협력업체는 협력업체FMS에 해당 페이지 메뉴를 자동오픈(20190918)
					umd.insertAuthUserCase(String.valueOf(ht.get("USER_ID")), "33", "01", "15", "1");
					System.out.println(ht.get("USER_ID"));
				}
			}
		}	
		String sub 	= "과태료 납부요청 ";
		String cont 	= "과태료 납부요청건이 있습니다. 확인바랍니다. &lt;br&gt; &lt;br&gt; 협력업체FMS > 탁송관리 > 요청관리 > 과태료관리 에서 확인해주세요.  &lt;br&gt; &lt;br&gt; " +
								"처음으로 이 메세지를 수신한 경우 FMS에 로그인되어 있다면, 메뉴오픈을 위해 '재로그인' 해주세요.";
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"    <BACKIMG>4</BACKIMG>"+
			  				"    <MSGTYPE>104</MSGTYPE>"+
			  				"    <SUB>"+sub+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
			 				"    <URL></URL>";
		xml_data += ids;
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
		
		flag1 = cm_db.insertCoolMsg(msg);
	}
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 	value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 	value="<%=user_id%>">
  <input type="hidden" name="br_id" 	value="<%=br_id%>">    
  <input type="hidden" name="m_id" 		value="<%=m_id%>">
  <input type='hidden' name='c_id' 		value='<%=c_id%>'>
  <input type='hidden' name='l_cd' 		value='<%=l_cd%>'>
  <input type="hidden" name="seq_no" 	value="<%=seq_no%>">
</form>
<script language='javascript'>
<%if(flag1){%>
		alert('정상 처리되었습니다.');
		parent.opener.location.reload();
<%}else{%>
		alert('데이터베이스 에러입니다.');
<%}%>
	parent.window.close();
</script>
<body>
</body>
</html>