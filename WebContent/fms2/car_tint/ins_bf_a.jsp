<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<%
	int cnt = 6; //�˻� ���μ�
	int height = (cnt*sh_line_height)+(cnt*1)+30;
	
	String auth_rw 	= request.getParameter("auth_rw")	== null ? "" : request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")		== null ? "" : request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		== null ? "" : request.getParameter("br_id");
	
	String s_kd 				= request.getParameter("s_kd")				== null ? "" : request.getParameter("s_kd");
	String t_wd 				= request.getParameter("t_wd")				== null ? "" : request.getParameter("t_wd");
	String andor 				= request.getParameter("andor")				== null ? "" : request.getParameter("andor");
	String gubun1 			= request.getParameter("gubun1")				== null ? "" : request.getParameter("gubun1");
	String gubun2 			= request.getParameter("gubun2")				== null ? "" : request.getParameter("gubun2");
	String gubun3 			= request.getParameter("gubun3")				== null ? "" : request.getParameter("gubun3");
	String st_dt 				= request.getParameter("st_dt")				== null ? "" : request.getParameter("st_dt");
	String end_dt 				= request.getParameter("end_dt")				== null ? "" : request.getParameter("end_dt");
	String sort 					= request.getParameter("sort")					== null ? "" : request.getParameter("sort");
	String rent_or_lease	= request.getParameter("rent_or_lease")	== null ? "" : request.getParameter("rent_or_lease");
	String con_f 				= request.getParameter("con_f")				== null ? "" : request.getParameter("con_f");
	
	int sh_height = request.getParameter("sh_height") == null ? 0 : Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	Vector vt = t_db.getCarTintInsBlackFileList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort, rent_or_lease, con_f);
	int vt_size = vt.size();

	InsDatabase ins_db = InsDatabase.getInstance();
	InsComDatabase ins_com_db = InsComDatabase.getInstance();
	
%>
<body leftmargin="15">
	<form action="" id="form1"  name="form1" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	
	<table border="1" cellspacing="0" cellpadding="0" width=1100>
		<tr style="height:20;">
			<td width='50' 	align='center' style="font-size : 8pt;">����</td>
			<td width='100' 	align='center' style="font-size : 8pt;">������ȣ</td>
			<td width='100' 	align='center' style="font-size : 8pt;">����������ȣ</td>
			<td width='100' 	align='center' style="font-size : 8pt;">���豸��</td>
			<td width='100' 	align='center' style="font-size : 8pt;">���ڽ� ������</td>
			<td width='100' 	align='center' style="font-size : 8pt;">���ڽ� �𵨸�</td>
			<td width='100' 	align='center' style="font-size : 8pt;">���ڽ� �Ϸù�ȣ</td>
			<td width='100' 	align='center' style="font-size : 8pt;">���ڽ���</td>
			<td width='100' 	align='center' style="font-size : 8pt;">���ڽ� ��ȣ</td>
			<td width='250' 	align='center' style="font-size : 8pt;">ó�����</td>
			<td width='50' 	align='center' style="font-size : 8pt;">���</td>
		</tr>
		<%
			int count = 0;
			int flag = 0;
			
			for(int i=0; i<vt.size(); i++){
				boolean result = false;
				++count;
				String result_value = "";
				Hashtable ht = (Hashtable) vt.elementAt(i);
				InsurExcelBean ins = new InsurExcelBean();
				
				String blackbox_nm	= ht.get("BLACKBOX_NM")	== null ? "" : String.valueOf(ht.get("BLACKBOX_NM"));
				String blackbox_no 	= ht.get("BLACKBOX_NO") 	== null ? "" : String.valueOf(ht.get("BLACKBOX_NO"));
				String com_nm 		= ht.get("COM_NM") 			== null ? "" : String.valueOf(ht.get("COM_NM"));
				String model_nm 	= ht.get("MODEL_NM") 		== null ? "" : String.valueOf(ht.get("MODEL_NM"));
				String serial_no 		= ht.get("SERIAL_NO") 		== null ? "" : String.valueOf(ht.get("SERIAL_NO"));
				String rent_mng_id	= ht.get("RENT_MNG_ID")	== null ? "" : String.valueOf(ht.get("RENT_MNG_ID"));
				String rent_l_cd 		= ht.get("RENT_L_CD") 		== null ? "" : String.valueOf(ht.get("RENT_L_CD"));
				String car_mng_id 	= ht.get("CAR_MNG_ID") 	== null ? "" : String.valueOf(ht.get("CAR_MNG_ID"));
				String ins_st 			= ht.get("INS_ST") 				== null ? "" : String.valueOf(ht.get("INS_ST"));
				String client_st 		= ht.get("CLIENT_ST") 		== null ? "" : String.valueOf(ht.get("CLIENT_ST"));
				
				String ins_value = "";
				String car_value = "";
				
				blackbox_nm = blackbox_nm.trim().replaceAll(" +", " "); // ���ӵ� ������ �� ������ ġȯ.
				if( blackbox_nm.contains(" ") ) blackbox_nm = blackbox_nm.replace(" ", "/");
				if( blackbox_nm.contains("-") ) blackbox_nm = blackbox_nm.replace("-", "/");
				
				if( !blackbox_nm.equals("") && !blackbox_no.equals("") )		 ins_value = "����/"+blackbox_nm + "/" + blackbox_no;
				else if( blackbox_nm.equals("") && blackbox_no.equals("") )	 ins_value = "������";
				else if( blackbox_nm.equals("") )	ins_value = "����/"+blackbox_no;
				else if( blackbox_no.equals("") )	ins_value = "����/"+blackbox_nm;
				
				if( !com_nm.equals("") && !model_nm.equals("") && !serial_no.equals("") ) 		car_value = "����/" + com_nm + "/" + model_nm + "/" + serial_no;
				else if( com_nm.equals("") && model_nm.equals("") && serial_no.equals("") ) 	car_value = "������";
				else if( com_nm.equals("") || model_nm.equals("") || serial_no.equals("") ){
					car_value = "����/";
					if( !com_nm.equals("") ) 	car_value += com_nm;
					if( !com_nm.equals("") && (!model_nm.equals("") || !serial_no.equals("")) ) car_value += "/";
					if( !model_nm.equals("") ) car_value += model_nm;
					if( !com_nm.equals("") || !model_nm.equals("") ) car_value += "/";
					if( !serial_no.equals("") ) car_value += serial_no;
				}
				
				if( serial_no.equals("") ){
					result_value = "�Ϸ� ��ȣ ����";
				}
				else if( serial_no.equals(blackbox_no) ){  // ��ݿ�. INSUR - CAR_TINT ���̺� ���ڽ� �Ϸù�ȣ ���� ���
					result_value = "��ݿ����� ó���� ���Դϴ�.";
				} 
				else if( ins_com_db.getCheckOverInsExcel(car_mng_id, ins_st, ins_value, car_value) > 0 ){ 	// �̹� ó���� �� -> CAR_TINT - INS_EXCEL
					result_value = "�̹� ó���� ���Դϴ�.";
				} 
				else { // insert ins_excel table
					String reg_code = "ICQ-B"+Long.toString(System.currentTimeMillis());
					ins.setReg_code(reg_code);		
					ins.setSeq(1); 						
					// ins.setGubun(null); 				
					ins.setValue01("���ڽ� ����");	
					ins.setValue02(rent_mng_id); 	
					ins.setValue03(rent_l_cd); 		
					ins.setValue04(client_st); 		
					
					SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
					String format_time = format.format(System.currentTimeMillis());
					ins.setValue05(format_time); 	// sysdate
					
					ins.setValue06("���ڽ�");		// ���� ������			
					ins.setValue07(ins_value); 		// insur ���̺� blackbox_nm/blackbox_no
					ins.setValue08(car_value);		// ����/car_tint ���̺� com_nm/medel_nm/serial_no
					ins.setValue09(rent_mng_id); 	// cont ���̺� rent_mng_id
					ins.setValue10(rent_l_cd); 		// cont ���̺� rent_l_cd
					ins.setValue11(car_mng_id); 	// insur ���̺� car_mng_id
					ins.setValue12(ins_st); 			// insur ���̺� ins_st
					
					result = ins_db.insertInsExcel(ins);
					if( result ){
						result_value = "���� ��ϵǾ����ϴ�.";
						++flag;
					} else{
						result_value = "��� �����Դϴ�.";
					}
				}
		%>
			<tr>
				<td width='50' 	align='center' style="font-size: 8pt;"><%= count %></td>
				<td width='100' 	align='center' style="font-size: 8pt;"><%= ht.get("CAR_NO")%></td>
				<td width='100' 	align='center' style="font-size: 8pt;"><%= ht.get("CAR_MNG_ID")%></td>
				<td width='100' 	align='center' style="font-size: 8pt;"><%= ht.get("INS_ST")%></td>
				<td width='100' 	align='center' style="font-size: 8pt;"><%= ht.get("COM_NM") %></td>
				<td width='100' 	align='center' style="font-size: 8pt;"><%= ht.get("MODEL_NM") %></td>
				<td width='100' 	align='center' style="font-size: 8pt;"><%= ht.get("SERIAL_NO") %></td>
				<td width='100' 	align='center' style="font-size: 8pt;"><%= ht.get("BLACKBOX_NM") %></td>
				<td width='100' 	align='center' style="font-size: 8pt;"><%= ht.get("BLACKBOX_NO") %></td>
				<td width='250' 	align='center' style="font-size: 8pt;"><%if(!result)%><font color = red><%= result_value %></font></td>
				<td width='50' 	align='center' style="font-size: 8pt;"><%= result %></td>
			</tr>
		<%} %>
		</table>
	</form>
</body>
<script language='javascript'>
 <!--
 	var flag = <%= flag %>
 	if( flag > 0 ){
 		alert('��ϵǾ����ϴ�.');
 	} else {
 		window.opener.location.reload();
 	}
 	
 //-->
</script>
</html>