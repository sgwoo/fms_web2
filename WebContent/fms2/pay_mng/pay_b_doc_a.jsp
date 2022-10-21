<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
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
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	int flag = 0;
	
	
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	PayMngDatabase pm_db 	= PayMngDatabase.getInstance();
	PaySearchDatabase ps_db = PaySearchDatabase.getInstance();
	CarSchDatabase csd 		= CarSchDatabase.getInstance();
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
%>


<%

	if(String.valueOf(request.getParameterValues("ch_cd")).equals("") || String.valueOf(request.getParameterValues("ch_cd")).equals("null")){
		out.println("���õ� ����� �����ϴ�.");
		return;
	}	

	String req_dt 	= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String vid[] 	= request.getParameterValues("ch_cd");
	String reqseq 	= "";
	
	long total_amt1	= 0;
	long total_amt2	= 0;
	
	int vid_size = vid.length;
	
	String doc_code  = Long.toString(System.currentTimeMillis());
	int at_once = 0;
	
	
	
	for(int i=0;i < vid_size;i++){
		
		reqseq = vid[i];
		
		//1. ����ڵ����-------------------------------------------------------------------------------------------
		
		//��ݿ���
		PayMngBean pay 	= pm_db.getPay(reqseq);
		
		if(pay.getAmt()>0 && pay.getP_way().equals("5") && pay.getBank_no().equals("")){
			//������ü�ε� �Ա� ���¹�ȣ�� ������ �Ѿ�� �ʴ´�.
			flag2 = false;
			result++;
		}
		
		if(pay.getAmt()>0 && pay.getP_way().equals("2") && pay.getA_bank_no().equals("") && !pay.getCard_nm().equals("�������ī��")){
			//����ī���ε� ��� ���¹�ȣ�� ������ �Ѿ�� �ʴ´�.
			flag2 = false;
			result++;
		}
		
		if(pay.getAmt()>0 && pay.getP_way().equals("3") && pay.getA_bank_no().equals("") && !pay.getCard_nm().equals("�������ī��")){
			//�ĺ�ī���ε� ��� ���¹�ȣ�� ������ �Ѿ�� �ʴ´�.
			flag2 = false;
			result++;
		}
		
		if(pay.getAmt()>0 && pay.getP_way().equals("4") && pay.getA_bank_no().equals("")){
			//�ڵ���ü�ε� ��� ���¹�ȣ�� ������ �Ѿ�� �ʴ´�.
			flag2 = false;
			result++;
		}
		
		total_amt1 = 0;
		total_amt2 = 0;
		String p_gubun = "";
		
		//��ݿ��� ���� �׸�
		Vector vt =  pm_db.getPayItemList(reqseq);
		int vt_size = vt.size();
		total_amt1 	= pay.getAmt();
		for(int j = 0 ; j < vt_size ; j++){
			PayMngBean pm = (PayMngBean)vt.elementAt(j);
			total_amt2 	= total_amt2 + pm.getI_amt();
			p_gubun = pm.getP_gubun();
		}
		if(total_amt1 > total_amt2 || total_amt1 < total_amt2){
			//�̿��̸� �ȵȴ�.
			flag2 = false;
			result++;
		}
		
		if(!pay.getBank_nm().equals("") && pay.getBank_id().equals("")){
			Hashtable b_ht = ps_db.getBankCode("", pay.getBank_nm());
			if(String.valueOf(b_ht.get("CMS_BK")).equals("null")){
			}else{
				pay.setBank_cms_bk	(String.valueOf(b_ht.get("CMS_BK")));
				pay.setBank_id		(String.valueOf(b_ht.get("CMS_BK")));
			}
			if(!pm_db.updatePayA(pay)) flag += 1;
		}
		
		if(!pay.getA_bank_nm().equals("") && pay.getA_bank_id().equals("")){
			Hashtable b_ht = ps_db.getBankCode("", pay.getA_bank_nm());
			if(String.valueOf(b_ht.get("CMS_BK")).equals("null")){
			}else{
				pay.setA_bank_cms_bk(String.valueOf(b_ht.get("CMS_BK")));
				pay.setA_bank_id	(String.valueOf(b_ht.get("CMS_BK")));
			}
			if(!pm_db.updatePayA(pay)) flag += 1;
		}
		
		
		doc_code = "";//������ ���� �ʴ´�. ��ݹ�������Ҷ� ó����.
		
		if(total_amt1 ==0 || total_amt1 < 0){
			//����ȯ�ұ�&���°躸����&�����°躸����->ȸ��ó���� �ѱ��
			if(p_gubun.equals("31") || p_gubun.equals("33") || p_gubun.equals("34") || p_gubun.equals("37") || p_gubun.equals("35")){
				if(flag2)		flag1 = pm_db.updatePayDC(reqseq, req_dt);
			}else{
				//�ݾ��� 0�̸� �ȵȴ�.
				if(total_amt1 < 0){
					if(flag2)		flag1 = pm_db.updatePayDoccode(reqseq, doc_code, req_dt);
				}
			}
		}else{
			if(flag2)		flag1 = pm_db.updatePayDoccode(reqseq, doc_code, req_dt);
		}
		
		
		flag2 = true;
		
		
		//������ü ���ó���Ұ�
		if(pay.getAt_once().equals("Y") && pay.getP_way().equals("5")) at_once++;
		
	}
	
	
	
	
	//�ܱ��ڰ� ��û�� ��� �� ���� ȸ�����ڿ��� ������û�޼��� �߼�
	
	//�����
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	String target_id = nm_db.getWorkAuthUser("��������ȸ�������");
	

	
	//������ü ���ó���϶� ���� ��ݴ����(���ֿ�)���� ���� �߼�
	if(at_once>0){
		
		target_id = nm_db.getWorkAuthUser("��ݴ��");
		
		CarScheBean cs_bean = csd.getCarScheTodayBean(target_id);
		if(!cs_bean.getUser_id().equals("")){
			target_id = nm_db.getWorkAuthUser("CMS����");//�Աݴ��
		}
		
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String url 		= "/fms2/pay_mng/pay_d_frame.jsp";
		String sub 		= "��� ��ݰ��� ��û";
		String cont 	= "��� ��ݰ��� ��û�Ͽ��� ����Ͽ� ��� �������ּ���";
		String m_url = "/fms2/pay_mng/pay_d_frame.jsp";
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
	  				"    <SUB>"+sub+"</SUB>"+
  					"    <CONT>"+cont+"</CONT>"+
  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"&m_url="+m_url+"</URL>";
		
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
		
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("��޽���(��ݿ��� ��� ��ݰ����û)"+sender_bean.getUser_nm()+"-----------------------"+target_bean.getUser_nm());		
	}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>		alert('�����Դϴ�.\n\nȮ���Ͻʽÿ�');													<%		}	%>		
<%		if(result > 0){	%>	alert('���Ǻ����� '+<%=result%>+'�� �Դϴ�.\n\n�Ա������� ��������� Ȯ���ϼ���');		<%		}	%>		
</script>

<form name='form1' method='post'>
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
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>