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
	
	//�������� ����
	if(gubun.equals("proxy_dt")){
		String proxy_dt	= request.getParameter("proxy_dt")	==null?"":request.getParameter("proxy_dt");
		flag1 = a_fdb.updateFineProxy_dt(m_id, l_cd, c_id, seq_no, proxy_dt);
		
	//���ο�û �޼��� �߼�	
	}else if(gubun.equals("send_msg")){
		String param	= request.getParameter("param")	==null?"":request.getParameter("param");
		String [] param_arr = param.split(",");
		String ids = "";
		for(int i=0; i<param_arr.length;i++){
			//�޼��� �߼۰����� ���¾�ü���� üũ �� id�� fetch
			Vector vt = umd.getOffUserList(param_arr[i]);
			if(vt.size()>0){
				for(int j=0; j<vt.size();j++){
					Hashtable ht = (Hashtable)vt.elementAt(j);
					ids += "<TARGET>"+String.valueOf(ht.get("ID"))+"</TARGET>";
					
					//�޼��� �߼��� ���¾�ü�� ���¾�üFMS�� �ش� ������ �޴��� �ڵ�����(20190918)
					umd.insertAuthUserCase(String.valueOf(ht.get("USER_ID")), "33", "01", "15", "1");
					System.out.println(ht.get("USER_ID"));
				}
			}
		}	
		String sub 	= "���·� ���ο�û ";
		String cont 	= "���·� ���ο�û���� �ֽ��ϴ�. Ȯ�ιٶ��ϴ�. &lt;br&gt; &lt;br&gt; ���¾�üFMS > Ź�۰��� > ��û���� > ���·���� ���� Ȯ�����ּ���.  &lt;br&gt; &lt;br&gt; " +
								"ó������ �� �޼����� ������ ��� FMS�� �α��εǾ� �ִٸ�, �޴������� ���� '��α���' ���ּ���.";
		
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
		alert('���� ó���Ǿ����ϴ�.');
		parent.opener.location.reload();
<%}else{%>
		alert('�����ͺ��̽� �����Դϴ�.');
<%}%>
	parent.window.close();
</script>
<body>
</body>
</html>