<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.cont.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.coolmsg.*, acar.accid.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//�ڵ���������ȣ
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//��������ȣ
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//��������ȣ
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//����ȣ
	
	boolean flag=false;
	boolean msg_flag =false;
	String gubun_nm = "";
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//�Ҽ�	
	AccidSuitBean as_bean = as_db.getAccidSuitBean(c_id, accid_id);
		
	String reg_id = nm_db.getWorkAuthUser("�����������");  //target 
		
	UserMngDatabase um = UserMngDatabase.getInstance();
	UsersBean suser  = um.getUsersBean(ck_acar_id);
	UsersBean tuser  = um.getUsersBean(reg_id);
	
	String target_id = tuser.getId();
   	String target_nm = tuser.getUser_nm();
	
	String title = "���Ǻ�����Ȯ���Ҽ۰���";
   	String sender_id = suser.getId();
   	String sender_nm = suser.getUser_nm();
	
   	String content= "��ȣ "+cont.get("CLIENT_NM")+" &lt;br&gt; &lt;br&gt; ������ȣ "+cont.get("CAR_NO")+" &lt;br&gt; &lt;br&gt; "+
   				 "������ : "+AddUtil.parseDecimal(as_bean.getSuit_amt())+"�� &lt;br&gt; &lt;br&gt; "+
   				 "������ : "+AddUtil.parseDecimal(as_bean.getLoan_amt())+"�� &lt;br&gt; &lt;br&gt; "+
   				 "�ѼҼ۱ݾ�   : "+AddUtil.parseDecimal(as_bean.getReq_amt())+"�� &lt;br&gt; &lt;br&gt; "+
   				 "Ȯ�� ���Ǻ���  ��� "+as_bean.getOur_fault_per() +" : "+as_bean.getJ_fault_per() +" ���� &lt;br&gt; &lt;br&gt; "+
   				 "�Աݾ�  : "+AddUtil.parseDecimal(as_bean.getPay_amt())+"�� &lt;br&gt; &lt;br&gt; "+
   				 "�ԱݵǾ����� Ȯ�κ�Ź�帮�ڽ��ϴ�.\n";
   	
   	
   	
   	String url ="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url=/fms2/settle_acc/fault_bad_complaint_frame.jsp";
/*    	String url ="http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?"+
   				"id=%ID&pass=%PASS&url=/acar/accid_mng/accid_u_frame.jsp?"+
   				"go_url=/fms2/settle_acc/fault_bad_complaint_frame.jsp&"+
   				"c_id"+c_id+"&"+
   				"accid_id"+accid_id+"&"+
   				"m_id"+m_id+"&"+
   				"l_cd"+l_cd+"&"; */

	String xml_data = "";
	xml_data =  "<COOLMSG>"+
  				"<ALERTMSG>"+
 					"    <BACKIMG>4</BACKIMG>"+
 					"    <MSGTYPE>104</MSGTYPE>"+
 					"    <SUB>"+title+"</SUB>"+
  				"    <CONT>"+content+"</CONT>"+
					"    <URL>"+url+"</URL>";
	xml_data += "    <TARGET>"+target_id+"</TARGET>";
	xml_data += "    <TARGET>2006007</TARGET>";
	xml_data += "    <SENDER>"+sender_id+"</SENDER>"+
 					"    <MSGICON>10</MSGICON>"+
 					"    <MSGSAVE>1</MSGSAVE>"+
 					"    <LEAVEDMSG>1</LEAVEDMSG>"+
  				"    <FLDTYPE>1</FLDTYPE>"+
 					"  </ALERTMSG>"+
 					"</COOLMSG>"; 
	
	CdAlertBean msg = new CdAlertBean();
	msg.setFlddata(xml_data);
	msg.setFldtype("1"); 
	
	CoolMsgDatabase cm_db = CoolMsgDatabase.getInstance();
	msg_flag = cm_db.insertCoolMsg(msg); 
	
%>

<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
	var flag = '<%=flag%>';
	var msg_flag = '<%=msg_flag%>';
	
	if(flag == 'true'){
		 opener.location.reload();
		 alert("���� �Ǿ����ϴ�.");
		 window.close();
	}else if(msg_flag == 'true'){
		 opener.location.reload();
		 alert("�޼����� ���� �Ǿ����ϴ�.");
		 window.close();
	}else{
		
	}
</script>
<body>
</body>
</head>
</html>
