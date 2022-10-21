<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*,tax.*, acar.user_mng.*,acar.cont.*, acar.client.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>


<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id"); //�����
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd"); //����ȣ
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");	
	
	String m1_chk = request.getParameter("m1_chk")==null?"":request.getParameter("m1_chk");
	String m1_content = request.getParameter("m1_content")==null?"":request.getParameter("m1_content");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	
	
	String sms_yn =  request.getParameter("sms_yn")==null?"":request.getParameter("sms_yn");
		
	boolean flag1 = true;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	String m1_no= "";
	
	int count = 1;
	
	int result = 0;
	
	count = rs_db.updateCarReqMaster1(c_id, m1_chk);
	
	String off_nm = "�����ڵ���";
	String off_id = "007410"; //�����ڵ��� setting  005591 -> 007410,  �λ� - ������Ƽ�ڸ���(�λ�) 008411
	
	if ( m1_chk.equals("5")) {	
		off_id = "008411";      //�ϵ�����Ź��
		off_nm = "������Ƽ�ڸ���";
	} 
	
	if ( m1_chk.equals("6")) {	// �λ�˻�(20160224)
		off_id = "009620";      //�̽��͹ڴ븮
		off_nm = "�̽��͹ڴ븮";
	} 
	
	if ( m1_chk.equals("8")) {	// �λ�˻�(20160224)
		off_id = "011614";      //�̽��͹ڴ븮
		off_nm = "����";
	} 
		
	if ( m1_chk.equals("A")) {	// �뱸�˻�(202008224)
		off_id = "008462";      //�̽��͹ڴ븮
		off_nm = "��������";
	} 
	
	//1. �ڵ����˻� ���----------------------------------------------------------------------------------------	
			
	CarMaintReqBean cons = new CarMaintReqBean();
				
	cons.setMng_id			(mng_id);
	cons.setCar_mng_id		(c_id);
	cons.setRent_l_cd		(l_cd);
	cons.setM1_chk			(m1_chk);
	cons.setM1_content		(m1_content);
	cons.setOff_id			(off_id);
	cons.setOff_nm			(off_nm);
	cons.setGubun			(gubun);	
	
	m1_no = rs_db.insertCarMaintReq(cons);
	
	if(m1_no.equals("")){
		result++;
	}
	
	
	//�ȳ����� �����̿��ڿ��� ���ڹ߼� 20170125�����߰�
	
	String reg_id = ck_acar_id;
	
	//�α���
	UsersBean user_bean2 = umd.getUsersBean(reg_id);
	
	//���⺻����
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//������
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//��������
	Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	
	//���������
	UsersBean user_bean = umd.getUsersBean(base.getMng_id());
	
	if(base.getCar_st().equals("4")){
		user_bean = umd.getUsersBean(base.getMng_id2());
	}
	//�ܱ����� ��� ������ �߽���
	//if(!user_bean2.getLoan_st().equals("")){
	//	user_bean = user_bean2;
	//}
	String sendphone= user_bean.getUser_m_tel();
	String sendname=user_bean.getUser_nm();
	String destphone="";
	String firm_nm= client.getFirm_nm();
	String msg_subject="���� �˻� �ȳ� ����";
	
	for(int i = 0 ; i < mgr_size ; i++){
    	CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
       if(mgr.getMgr_st().equals("�����̿���")){
			destphone = mgr.getMgr_m_tel()+"";
       }
   }
	
	if(sms_yn.equals("Y")){
			
			if(!destphone.equals("") && AddUtil.lengthb(destphone) > 9){						
				String sms_content =firm_nm+"���� �ȳ��Ͻʴϱ�. ģ���� �ŷڷ� ��ô� �Ƹ���ī�Դϴ�.\n\n������ �̿����� �ڵ���("+car_no+")�˻� �ǽø� ����  ��� ���¾�ü���� ���Կ��� �����帱 �����Դϴ�.\n������ ������ ���������� ���� ���� ��Ź�帳�ϴ�. �����մϴ�.\n\n";
				sms_content= sms_content+"(��)�Ƹ���ī www.amazoncar.co.kr";
			
				int i_msglen = AddUtil.lengthb(sms_content);		
				String msg_type = "0";		
				//80�̻��̸� �幮��
				if(i_msglen>80) msg_type = "5";			
				String rqdate = "";
				
				
				//�˸��� �׽�Ʈ
		//		destphone = "01023542348";
					
				//�˸��� acar0051 ���� �˻� �ȳ� ����
				String customer_name 	= firm_nm;				// ���̸�
				String car_num 				= car_no;					// ������ȣ
				
				String etc1 = l_cd;
				String etc2 = reg_id ;
				
 				//acar0051 -> acar0070 -> acar0208 ��������
				List<String> fieldList = Arrays.asList(customer_name, car_num, sendname, sendphone);
				at_db.sendMessageReserve("acar0208", fieldList, destphone, sendphone, null,  etc1, etc2 );
			}	
	
	}
	
%>
<script language='javascript'>
<%	if(result  == 0){%>
		alert('���������� ó���Ǿ����ϴ�');
		parent.window.close();
		parent.opener.location.reload();
<%	}else{ //����%>
		alert('ó������ �ʾҽ��ϴ�\n\n�����߻�!');
<%	}%>
</script>
</body>
</html>
