<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.cont.*, tax.*, acar.user_mng.*, acar.car_sche.*"%>
<%@ page import="acar.coolmsg.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
String su 	= request.getParameter("su")==null?"":request.getParameter("su");
String msg 	= request.getParameter("msg")==null?"":request.getParameter("msg");
String gubun 	= request.getParameter("s_destphone")==null?"":request.getParameter("s_destphone");

String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
String sendname 	= request.getParameter("sendname")==null?"":request.getParameter("sendname");
String sendphone	= request.getParameter("sendphone")==null?"":request.getParameter("sendphone");
String destphone	= "010-3866-6959";
String msglen 		= request.getParameter("msglen")==null?"":request.getParameter("msglen");
String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
String auto_yn 		= request.getParameter("auto_yn")==null?"":request.getParameter("auto_yn");
String req_dt	 	= request.getParameter("req_dt")==null?"":AddUtil.replace(request.getParameter("req_dt"),"-","");
String req_dt_h 	= request.getParameter("req_dt_h")==null?"":request.getParameter("req_dt_h");
String req_dt_s 	= request.getParameter("req_dt_s")==null?"":request.getParameter("req_dt_s");
String msg_type 	= request.getParameter("msg_type")==null?"0":request.getParameter("msg_type");
String msg_subject 	= request.getParameter("msg_subject")==null?"":request.getParameter("msg_subject");

String msg2 ="";

	//���⺻����
	//ContBaseBean base = a_db.getCont(m_id, l_cd);	
	
if(gubun.equals("��ȭ")){
	gubun = "��ȭ-�۷κ�";
}else if(gubun.equals("�д�")){
	gubun = "�д�-�۷κ�";
}else if(gubun.equals("010-9026-1853")){
	gubun = "�������̼�ī(��)";
}
	
CommonDataBase c_db = CommonDataBase.getInstance();
UserMngDatabase umd = UserMngDatabase.getInstance();
MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
CarSchDatabase csd = CarSchDatabase.getInstance();

//Hashtable watch = c_db.getWatch_user_list("�뱸");	

if(!destphone.equals("") && destphone.length() > 9){
				
	msg2 = gubun +" ��������� ������ Ź������ ����Ʈ �Դϴ�. "+msg;
	
	String rqdate = "";
			
	firm_nm = "����Ź";
	destphone	= "010-3866-6959";
	
	//�˸���
	String auction_name = gubun;										// ����� �̸�
	String car_num_name_arr = msg;									// ��ǰ��������
	String car_num_name_arr_count = su;							// ��ǰ�������� ���
	String auction_date = AddUtil.getDate();				// ��ǰ����
		
	
	List<String> fieldList = Arrays.asList(auction_name, car_num_name_arr, car_num_name_arr_count, auction_date, sendname, sendphone);
	at_db.sendMessageReserve("acar0107", fieldList, destphone,  sendphone, null , firm_nm,  ck_acar_id);

boolean flag2 = true;
	
	String sub 		= "�����Ź�������ȳ�";
	String cont = "�ȳ��Ͻʴϱ�. �Ƹ���ī�Դϴ�. &lt;br&gt; &lt;br&gt; "+ 
	 		 "������ "+auction_name+" ����忡 ��ǰ����(Ź�ۿ�û) �ڵ��� ����Դϴ�. &lt;br&gt; &lt;br&gt; "+ 
	 		 "�� ��ǰ�������� : "+car_num_name_arr+", �̻� "+car_num_name_arr_count+"��  &lt;br&gt; &lt;br&gt; "+
	  		 "�� ��ǰ���� : "+auction_date+" &lt;br&gt; &lt;br&gt; "+
	  		 "�� ����� : "+sendname+"  ("+sendphone+")  &lt;br&gt; &lt;br&gt; "+
	  		 "(��)�Ƹ���ī (www.amazoncar.co.kr) ";
	
	
	List<String> list = new ArrayList<>();
	list.add("000258"); //�۽¿�
	list.add("000259");	//������
	list.add("000305");	//����


	for(String target_id : list){
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);
		if(!cs_bean2.getWork_id().equals("")) target_id = cs_bean2.getWork_id();
			
			
		UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
							"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
							"    <CONT>"+cont+"</CONT>"+
							"    <URL></URL>";
			
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
			
		CdAlertBean msg3 = new CdAlertBean();
		msg3.setFlddata(xml_data);
		msg3.setFldtype("1");
			
		flag2 = cm_db.insertCoolMsg(msg3);
		
	}
	/*  - �˸��� ����
	if(!destphone.equals((String)watch.get("M_TEL")) && String.valueOf(watch.get("M_TEL")).length() > 9){
		destphone = (String)watch.get("M_TEL");
		firm_nm = (String)watch.get("USER_NM");
		
		
		at_db.sendMessageReserve("acar0107", fieldList, destphone,  sendphone, null , firm_nm,  ck_acar_id);
	}else{
		System.out.println("�ߺ�");
	}
	*/
}

UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������������"));
UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ�������"));
UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("�뱸������"));
UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body onLoad="javascript:print(document)">
<form name='form1' method='post'>

<table table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td align="center"><a href="javascript:print(document)"><img src=/acar/images/button_print.gif border=0></a></td>
	</tr>
	<tr>
		<td class="h"></td>
	</tr>
	<%if(gubun.equals("")){%>
	<tr>
		<td><img src=/acar/images/center/glovis.jpg border=0 align=absmiddle>[�� ����� ���������ڵ�������� ��ǰ�� ����Դϴ�.]</td>
	</tr>
	<%}%>
	<tr>
        <td colspan="2" class=line2></td>
    </tr>
	<tr>
		<td colspan="2" class='line' width=100%>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
				  <td class='title' colspan="4" rowspan="1"><font size="6">Ź �� �� û ��</font></td>
				</tr>
				<tr>
				  <td class='title' colspan="1" rowspan="3" width="12%">�� �� �� ��<br>(��������<br>�ΰ���)</td>
				  <td class='title' colspan="2" rowspan="1">����</td>
				  <td align="center"><input type='text' size='30' name='' value='(��)�Ƹ���ī' maxlength='100' class='text' style = "border : none;font:11pt ����"></td>
				</tr>
				<tr>
				  <td class='title' colspan="1" rowspan="2" width="12%">����ó</td>
				  <td class='title' width="15%">��ȭ��ȣ</td>
				  <td align="center"><input type='text' size='30' name='' value='053-582-2998' maxlength='100' class='text' style = "border : none;font:11pt ����"></td>
				</tr>
				<tr>
				  <td class='title' width="15%">����ڸ�</td>
				  <td align="center"><input type='text' size='30' name='' value='<%=udt_mng_bean_g.getUser_nm()%> (���� 30�� �� �� �������!)' maxlength='100' class='text' style = "border : none;font:11pt ����"></td>
				</tr>
				<tr>
				  <td class='title' colspan="4" rowspan="1" align="left">�ذ������� ���� ������ �����Ͻô� ���� ������ �����Ͽ� �ֽʽÿ�</td>
				</tr>
				<tr>
				  <td class='title' colspan="1" rowspan="2">��������</td>
				  <td class='title'>������</td>
				  <td colspan="2" rowspan="2" align="center"><br><textarea name='msg' rows='14' cols='50' class='text' style='IME-MODE: active; overflow:hidden; border:none; font:11pt ����;'><%=msg%></textarea></td>
				</tr>
				<tr>
				  <td class='title'>������ȣ</td>
				</tr>
				<tr>
				  <td colspan="2" rowspan="1"class='title' >�൵</td>
				  <td colspan="2" rowspan="1" align="center">�� <%=su%>��</td>
				</tr>
				<tr>
				  <td colspan="4" rowspan="1"><img src=/acar/images/center/gyg.jpg align=absmiddle border=0 width=500 height=450></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='h'></td>
	</tr>
<%if(gubun.equals("")){%>	
	<tr>
		<td>
		�� Ź�۷� �Աݽ� �Աݰ��� �� ����ó(�Ա��� �ݵ�� ������ �ؼ� Ȯ���� �ؾ��մϴ�.)<br>
		�� �� �� �� �� : ��ȯ(05) 174-18-35675-8(������:�ڴ���)<br>
		�� Ź �� �� ü : 031)766-7217, 031)760-5397 (���:����ȣ �����) F:031-766-6131<br>
		�� �� �� �� �� : 031)760-5360~61 031)760-5356~57 (���:������, �������)
		</td>
	</tr>
<!-- 	<tr>
		<td >�� Ź�۷� �Աݽ� �Աݰ��� �� ����ó(�Ա��� �ݵ�� ������ �ؼ� Ȯ���� �ؾ��մϴ�.)</td>
	</tr>
	<tr>
		<td >�� �� �� �� �� : ��ȯ(05) 174-18-35675-8(������:�ڴ���)</td>
	</tr>
	<tr>
		<td >�� Ź �� �� ü : 031)766-7217, 031)760-5397 (���:����ȣ �����) F:031-766-6131</td>
	</tr>
	<tr>
		<td >�� �� �� �� �� : 031)760-5360~61 031)760-5356~57 (���:������, �������)</td>
	</tr> -->
<%}%>	
</table>

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--


//-->
</script>
</body>
</html>
