<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.consignment.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
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
	String cons_no 	= request.getParameter("cons_no")==null?"":request.getParameter("cons_no");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	System.out.println(" Ź�۰����� ���� ��� (conf) <br> ");
%>


<%

if(cmd.equals("cancel")){ //20111208 Ź�۰����� ���� ��� 

	DocSettleBean doc = d_db.getDocSettleCommi("2", cons_no);
	
	String doc_bit 	= "5";
	String doc_step = "2";

	//=====[doc_settle] update=====
	flag2 = d_db.updateDocSettleClr(doc.getDoc_no(), user_id, doc_bit, doc_step);
	
	out.println(" Ź�۰����� ���� ��� <br> ");
}else{
	
	String req_dt 	= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String vid[] 	= request.getParameterValues("ch_cd");
	String vid_num 	= "";
//	String cons_no 	= "";
	String seq = "";
	int vid_size = vid.length;
	
	String req_code  = Long.toString(System.currentTimeMillis());
	
	//out.println("���ðǼ�="+vid_size+"<br><br>");
	
	for(int i=0;i < vid_size;i++){
		
		vid_num = vid[i];
		
		cons_no 		= vid_num.substring(0,12);
		
		//1. Ź���Ƿ� ����-------------------------------------------------------------------------------------------
		
		flag1 = cs_db.updateConsignmentReqDt(cons_no, req_dt);
		
		
		//2. ����ó���� ����ó��-------------------------------------------------------------------------------------------
		
		//����ǰ��-Ȯ��
		DocSettleBean doc = d_db.getDocSettleCommi("2", cons_no);
		
		String doc_bit 	= "7";
		String doc_step = "3";
		
		//=====[doc_settle] update=====
		flag2 = d_db.updateDocSettle(doc.getDoc_no(), user_id, doc_bit, doc_step);
		out.println(" ����ó���� ���� <br> ");
		
	}
	
	
		//3. ��޽��� �˶� ���----------------------------------------------------------------------------------------
		
		String url 		= "/fms2/consignment_new/cons_conf_frame.jsp";
		String sub 		= "Ź��û��Ȯ�οϷ�";
		String cont 	= "Ź��û�� Ȯ�� �Ϸ�Ǿ����ϴ�. ����ó�� ���縦 ��û�մϴ�.";
		String target_id = "";
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		if(sender_bean.getBr_id().equals("B1"))			target_id = nm_db.getWorkAuthUser("�λ�������");
		else if(sender_bean.getBr_id().equals("D1"))		target_id = nm_db.getWorkAuthUser("����������");
		else if(sender_bean.getBr_id().equals("G1"))		target_id = nm_db.getWorkAuthUser("�뱸������");
		else if(sender_bean.getBr_id().equals("J1"))		target_id = nm_db.getWorkAuthUser("����������");
		else							target_id = nm_db.getWorkAuthUser("�����������");
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
  					"    <CONT>"+cont+"</CONT>"+
  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
		
		//�޴»��
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		
		//�������
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
		
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		//flag2 = cm_db.insertCoolMsg(msg);
		//out.println("��޽��� ����<br>");
		System.out.println("��޽���(Ź�۹��������û)"+req_dt+"-----------------------"+target_bean.getUser_nm());
		
}
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('Ź�� ���� �����Դϴ�.\n\nȮ���Ͻʽÿ�');					<%		}	%>		
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
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>