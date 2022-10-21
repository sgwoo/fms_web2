<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.*, acar.util.*, acar.user_mng.*, acar.parking.*, acar.cus_reg.*, acar.car_service.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="pbean" scope="page" class="acar.parking.ParkBean"/> 
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");


	String wash_pay = request.getParameter("wash_pay")==null?"":request.getParameter("wash_pay"); // �����ݾ�
	String inclean_pay = request.getParameter("inclean_pay")==null?"":request.getParameter("inclean_pay"); // �ǳ�ũ���׺�
	int park_seq = request.getParameter("park_seq")==null?0:Util.parseInt(request.getParameter("park_seq"));
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String gubun_st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st");
	String wash_etc = request.getParameter("wash_etc")==null?"":request.getParameter("wash_etc");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	
	SimpleDateFormat form = new SimpleDateFormat ( "yyyy-MM-dd HH:mm");
	Date time = new Date();
	String timeform = form.format(time);
	String d_user_nm= "";
	String d_user_tel= "";
	String at_cont= "";
	
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	user_bean = umd.getUsersBean(reg_id);
	
	
	int count = 0;
	ParkIODatabase piod = ParkIODatabase.getInstance();
	
	/* �޼��� ���� ����  */
	String wash_gubun = "����";
	String req_dt =  timeform ;
	String request_nm = user_bean.getUser_nm();
	String phone_num = user_bean.getUser_m_tel();
	if(wash_etc.equals("")){
		wash_etc = " ���� ";
	}			
	String send_tel = "02-392-4242";
		 
	List<String> fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );

	if(wash_pay.equals("0") && inclean_pay.equals("")){
		
		wash_gubun = "����";
		fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
		
		//�۾����ü� ��Ͻ� ����õ������ ����
		d_user_nm 	= "����õ";		// ����� ����
		d_user_tel 	= "010-3383-5843";	// ����ڿ���ó
		//d_user_tel 	= "010-9497-6266";	// ����ڿ���ó
		
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
	 	
		//�۾����ü� ��Ͻ�  ����������ڿ��� ����
		d_user_nm 	= "������";		// ����� ����
		d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
		
		//�˸��� acar0211 �뿩���þȳ�
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
		
		//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
		d_user_nm 	= "�ڽù�";		// ����� ����
		d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
		
		//�˸��� acar0211 �뿩���þȳ�
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
		
			
		
	}else if(wash_pay.equals("") && inclean_pay.equals("0")){
		
		wash_gubun = "�ǳ�ũ���� �� ���� ���Ÿ�";
		fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
		
		//�۾����ü� ��Ͻ� ����õ������ ����
		d_user_nm 	= "����õ";		// ����� ����
		d_user_tel 	= "010-3383-5843";	// ����ڿ���ó
		//d_user_tel 	= "010-9497-6266";	// ����ڿ���ó
		
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
	 	
		//�۾����ü� ��Ͻ�  ����������ڿ��� ����
		d_user_nm 	= "������";		// ����� ����
		d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
		
		//�˸��� acar0211 �뿩���þȳ�
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
		
		//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
		d_user_nm 	= "�ڽù�";		// ����� ����
		d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
		
		//�˸��� acar0211 �뿩���þȳ�
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
		
	}else if(wash_pay.equals("0") && inclean_pay.equals("0")){
		
		
		wash_gubun = "�ǳ�ũ���� �� ���� ���ſ�\n����";
		fieldList = Arrays.asList(wash_gubun, car_no, req_dt, request_nm, phone_num, wash_etc );
		
		//�۾����ü� ��Ͻ� ����õ������ ����
		d_user_nm 	= "����õ";		// ����� ����
		d_user_tel 	= "010-3383-5843";	// ����ڿ���ó
		//d_user_tel 	= "010-9497-6266";	// ����ڿ���ó
		
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
	 	
		//�۾����ü� ��Ͻ�  ����������ڿ��� ����
		d_user_nm 	= "������";		// ����� ����
		d_user_tel 	= "010-4503-2121";	// ����ڿ���ó
		
		//�˸��� acar0211 �뿩���þȳ�
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
		
		//�۾����ü� ��Ͻ� �ڽù澾���� ģ���� ����
		d_user_nm 	= "�ڽù�";		// ����� ����
		d_user_tel 	= "010-5838-6899";	// ����ڿ���ó
		
		//�˸��� acar0211 �뿩���þȳ�
		at_db.sendMessageReserve("acar0240", fieldList, d_user_tel, send_tel, null, d_user_nm, user_id);
	}
	
	count = piod.updateParkWashGubun(park_seq, wash_pay, inclean_pay, gubun_st);
			

%>
<html>
<head>
<title>FMS</title>
</head>
<script>
var fm = document.form1;
 <%	if(count==1){ %>

		<% 	if (park_seq==0) { %>
					alert("���������� ��ϵǾ����ϴ�.");
		<% 	} else { %>
					alert("���������� �����Ǿ����ϴ�.");
		<% 	} %>
		parent.window.close();
		parent.opener.location.reload();
		
<%}else{%>
		alert('������ �߻��Ͽ����ϴ�. �����ڿ��� ������ �ּ���.');
		parent.window.document.getElementById("loader").style.visibility="hidden";
<%}%> 

</script>
</body>
</html>
