<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.consignment.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*, acar.memo.*, acar.car_office.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
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
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;		// 2018.03.26
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
%>


<%
		
	Vector vt2 = cs_db.getConsReqDocSmsConfList_SU(s_kd, t_wd, gubun1);

	int vt2_size = vt2.size();
	
	for(int i = 0 ; i < vt2_size ; i++){
		Hashtable ht2 = (Hashtable)vt2.elementAt(i);
		String sb = "";
		if(String.valueOf(ht2.get("OFF_NM")).equals("(��)�Ƹ���Ź��")){
			sb = "000223";
		}else if(String.valueOf(ht2.get("OFF_NM")).equals("����ī��(����)")||String.valueOf(ht2.get("OFF_NM")).equals("����ī��(�λ�)")){
			sb = "000139";
		//}else if(String.valueOf(ht2.get("OFF_NM")).equals("������Ƽ�ڸ���(�뱸)")||String.valueOf(ht2.get("OFF_NM")).equals("������Ƽ�ڸ���(����)")||String.valueOf(ht2.get("OFF_NM")).equals("������Ƽ�ڸ���(�λ�)")){
		}else if(String.valueOf(ht2.get("OFF_NM")).equals("������Ƽ�ڸ���(�뱸)")||String.valueOf(ht2.get("OFF_NM")).equals("������Ƽ�ڸ���(����)")||String.valueOf(ht2.get("OFF_NM")).equals("������Ƽ�ڸ���(�λ�)")
				||String.valueOf(ht2.get("OFF_NM")).equals("�ϵ�����Ź��(�λ�)")||String.valueOf(ht2.get("OFF_NM")).equals("�ϵ�����Ź��(�뱸)")||String.valueOf(ht2.get("OFF_NM")).equals("�ϵ�����Ź��(����)")){
			sb = "000196";
		}else if(String.valueOf(ht2.get("OFF_NM")).equals("(��)����Ư��")){
			sb = "000187";
		}else if(String.valueOf(ht2.get("OFF_NM")).equals("������TS")){
			sb = "000263";
		}else if(String.valueOf(ht2.get("OFF_NM")).equals("�۽�Ʈ����̺�")){
			sb = "000328";
		}
		
		UsersBean mms_target_bean 	= umd.getUsersBean(String.valueOf(ht2.get("USER_ID1")));
		UsersBean mms_sender_bean 	= umd.getUsersBean(sb);
		
		
		
		String mms_sub 			= "Ź��Ȯ�ο�û";
		String mms_cont 		= String.valueOf(ht2.get("SU"))+"���� ����� ��Ȯ��Ź���� �ֽ��ϴ�. ���! ����ó�� �ٶ�. ���ֱݿ��� �������̸� Ȯ�οϷ��� ������޵�.["+String.valueOf(ht2.get("OFF_NM"))+"]";
		
		String su			=	String.valueOf(ht2.get("SU"));
		String off_nm	=	String.valueOf(ht2.get("OFF_NM"));
	
		//SMS ���� �߼�-------------------------------------------------------------
		if(!mms_target_bean.getUser_m_tel().equals("") || !String.valueOf(ht2.get("AGENT_EMP_ID")).equals("")){
			String sendphone 	= mms_sender_bean.getUser_m_tel();
			String sendname 	= mms_sender_bean.getUser_nm();
			String destphone 	= mms_target_bean.getUser_m_tel();
			String destname 	= mms_target_bean.getUser_nm();
			
			//������Ʈ ���Ƿ������� ��û
			if(mms_target_bean.getDept_id().equals("1000") && !String.valueOf(ht2.get("AGENT_EMP_ID")).equals("")){
				CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(String.valueOf(ht2.get("AGENT_EMP_ID")));
				destname 	= a_coe_bean.getEmp_nm();
				destphone 	= a_coe_bean.getEmp_m_tel();
			}
			
			List<String> fieldList = Arrays.asList(off_nm, su);
			
			// �ű�
			flag7 = at_db.sendMessageReserve("acar0134", fieldList, destphone, "02-392-4243", null, sb, ck_acar_id);
		}
		
		//��Ȯ������ ������Ʈ�� ������ ������,�ǿ�Ŀ��Ե� �޽��� ������
		if(mms_target_bean.getDept_id().equals("1000")){
			mms_sub  = "������Ʈ Ź��Ȯ�ο�û";
			mms_cont = mms_target_bean.getUser_nm()+" ������Ʈ Ź�� ��Ȯ�ΰ��� �ֽ��ϴ�.  &lt;br&gt; &lt;br&gt; Ȯ�ο�û �ٶ��ϴ�.  &lt;br&gt; &lt;br&gt; "+mms_cont;
			
			UsersBean target_bean1 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����2"));//���ؼ�(20180601)
			//UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����"));//���缮(20180601)
			//UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����3"));//��μ�(20190102)
			
			//��޽��� �޼��� ����-----------------------------------------------------
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+mms_sub+"</SUB>"+
	  				"    <CONT>"+mms_cont+"</CONT>"+
 					"    <URL></URL>";
			xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
			//xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
			//xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
			xml_data += "    <SENDER>"+mms_sender_bean.getId()+"</SENDER>"+
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>";
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
			flag3 = cm_db.insertCoolMsg(msg);
		}
	}
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('Ź�� ���� �����Դϴ�.\n\nȮ���Ͻʽÿ�');							<%		}	%>
<%		if(!flag7){	%>	alert('�˸��� ���ۿ� �����Ͽ����ϴ�.\n\n����ڿ��� �������ֽʽÿ�');	<%		}	%>
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