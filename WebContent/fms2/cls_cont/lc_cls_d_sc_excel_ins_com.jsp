<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.insur.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String car_mng_id 	= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	String car_no 	= "";
	String ins_com_no="";
	int    count = 0;
	int flag = 0;
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	 Date d = new Date();
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
 	 int sysdate =   Integer.parseInt(sdf.format(d));	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<body>
<table border="1" cellspacing="0" cellpadding="0" width=700>
	<tr>
		<td width='50' align='center' style="font-size : 8pt;">����</td>
		<td width='100' align='center' style="font-size : 8pt;">������ȣ</td>
		<td width='100' align='center' style="font-size : 8pt;">���ǹ�ȣ</td>
	  <td width='100' align='center' style="font-size : 8pt;">���������ڵ�</td>
		<td width='150' align='center' style="font-size : 8pt;">����ȣ</td>
	  <td width='500' align='center' style="font-size : 8pt;">ó�����</td>
	</tr>
	<%	for(int i=0;i < vid_size;i++){
	
				vid_num = vid[i];
				
				rent_mng_id 	= vid_num.substring(0,6);
				rent_l_cd 		= vid_num.substring(6,19);
				
				String gubun = "�輭";
				String car_num = "";
				String result = "";
				
				//����翢�������� ���
				Hashtable ht2 = d_db.getClsDocExcel(rent_mng_id, rent_l_cd);
						
				InsurExcelBean ins = new InsurExcelBean();
				
				car_no = String.valueOf(ht2.get("CAR_NO"));
				car_mng_id = String.valueOf(ht2.get("CAR_MNG_ID"));
				ins_com_no = String.valueOf(ht2.get("INS_CON_NO"));
				
				ins.setReg_code		(reg_code);
				ins.setSeq				(count+1);
				ins.setReg_id			(ck_acar_id);
				ins.setGubun			(gubun);
				ins.setRent_mng_id(rent_mng_id);
				ins.setRent_l_cd	(rent_l_cd);
				ins.setCar_mng_id	(String.valueOf(ht2.get("CAR_MNG_ID")));
				ins.setIns_st			(String.valueOf(ht2.get("INS_ST")));
						
				ins.setValue01		(String.valueOf(ht2.get("CAR_NO")));
				ins.setValue02		(String.valueOf(ht2.get("INS_CON_NO")));
				ins.setValue03		("(��)�Ƹ���ī");
				ins.setValue04		(String.valueOf(ht2.get("CAR_NM")));
				ins.setValue05		("1288147957");
				ins.setValue06		(String.valueOf(ht2.get("INS_START_DT")));
				ins.setValue07		(String.valueOf(ht2.get("INS_EXP_DT")));
				
				String tempGubun="����";
				
				String before = String.valueOf(ht2.get("FIRM_NM2")) +"/"+ String.valueOf(ht2.get("ENP_NO2"))
				 				+"/"+ String.valueOf(ht2.get("AGE_SCP")) +"/"+ String.valueOf(ht2.get("VINS_GCP_KD"))
				 				+"/"+ String.valueOf(ht2.get("BEFORE_EMP_YN")) +"/"+ String.valueOf(ht2.get("RENT_START_DT"))
				 				+"/"+ String.valueOf(ht2.get("RENT_START_DT"));
				
				
				String after1 ="";
				if(!String.valueOf(ht2.get("AGE_SCP")).equals("26���̻�")){
					tempGubun = "����";
					after1 = "26���̻�";
				}
				if(!String.valueOf(ht2.get("VINS_GCP_KD")).equals("1���")){
					if(!after1.equals("")){
						tempGubun = tempGubun+"/"+"�빰";
						after1 = after1+"/"+"1���";
					}else{
						tempGubun = "�빰";
						after1 = "1���";
					}
				}
				if(!String.valueOf(ht2.get("BEFORE_EMP_YN")).equals("�̰���")){
					if(!after1.equals("")){
						tempGubun = tempGubun+"/"+"������";
						after1 = after1+"/"+"�̰���";
					}else{
						tempGubun = "������";
						after1 = "�̰���";
					}
				}
				ins.setValue08	(tempGubun);
				ins.setValue09	(before);
				String after2 =  "�Ƹ���ī/1288147957/26���̻�/1���/�̰���/"+String.valueOf(ht2.get("RENT_START_DT"));
				ins.setValue10	(after1);
				ins.setValue35	(after2);
				
				ins.setValue11		("��������� ����, ����");
				ins.setValue12		(AddUtil.getDate(4));
				
				ins.setValue14		(String.valueOf(ht2.get("INS_COM_ID")));
				ins.setValue28		("N");	
				ins.setValue36		("�Ƹ���ī");
			//	ins.setValue39		("N"); //Hook_yn 
				ins.setValue40		("N"); //Legal_yn 
				
				if(String.valueOf(ht2.get("INS_CON_NO")).equals("")||String.valueOf(ht2.get("INS_CON_NO")).equals("null")){
					result = "������ ������ �����ϴ�.";
				}else{
				 	//ins_excel_com �ߺ�üũ
					int over_cnt = ic_db.getCheckOverInsExcelCom(gubun, "", rent_mng_id, rent_l_cd, ins.getCar_mng_id(), ins.getIns_st(), ins.getValue08(), ins.getValue09(), ins.getValue10(), ins.getValue11(), ins.getValue12());
					
					/*	
					//ins_excel_com �űԺ��迡 ���� �輭��Ȳ�� �ߺ�üũ �� ����
					if(over_cnt == 0){
						int ins_st = Integer.parseInt(ins.getIns_st());
						over_cnt = ic_db.getCheckOverInsExcelCom(ins.getCar_mng_id(), Integer.toString(ins_st));
						if(over_cnt == 1){
							boolean flag1 = ic_db.deleteInsExcelCom(ins.getCar_mng_id(), Integer.toString(ins_st));
							if(flag1){
								result = "�輭��Ȳ "+ins.getValue01()+"������ ������ ���� �� ��� �Ǿ����ϴ�.";
								over_cnt = 0;
							}else{
								result = "�輭��Ȳ "+ins.getValue01()+"������ ������ ������ �����Ͽ����ϴ�.";
							}
						}
						
					}
					
					//ins_excel �űԺ��迡 ���� �輭2����Ʈ�� �ߺ�üũ �� �輭2����Ʈ���� ���� 
					if(over_cnt == 0){
						int ins_st = Integer.parseInt(ins.getIns_st());
						over_cnt = ic_db.getCheckOverInsExcel(ins.getCar_mng_id(), Integer.toString(ins_st));
						if(over_cnt == 1){
							boolean flag1 = ic_db.deleteInsExcel(ins.getCar_mng_id(), Integer.toString(ins_st));
							if(flag1){
								result = "�輭2����Ʈ "+ins.getValue01()+"���� ������ ���� �� ��� �Ǿ����ϴ�.";
								over_cnt = 0;
							}else{
								result = "�輭2����Ʈ "+ins.getValue01()+"���� ������ ������ �����Ͽ����ϴ�.";
							}
						}
					}
					 */
					 
					//1. �輭2 ����Ʈ�� �ְ�, ���ǹ�ȣ�� ���� ���(������ȣ, ���ǹ�ȣ)
					if(over_cnt == 0){
						int ins_st = Integer.parseInt(ins.getIns_st());
						over_cnt = ic_db.getCheckOverInsExcel(ins.getCar_mng_id(), Integer.toString(ins_st));
						if(over_cnt >0){
							result = "����輭2�� �̹� ��ϵǾ� �ֽ��ϴ�.";
						}
					}
					
					//2. �輭2 ����Ʈ�� �ְ�, ���ǹ�ȣ�� �ٸ� ��, ���踶������ ���� ���
					if(over_cnt == 0){
						int ins_exp_dt = Integer.parseInt(ins.getValue07()); 
						if(ins_exp_dt < sysdate){
							over_cnt = 1;
							result = "�̹� ���踶������ ���� ���Դϴ�.";
						}
					}
					
					//3. �̹� �Ϸ�ó�� �Ǿ���, ���ǹ�ȣ�� ���� ���(������ȣ, ���ǹ�ȣ)
					if(over_cnt == 0){
						int ins_st = Integer.parseInt(ins.getIns_st());
						over_cnt = ic_db.getCheckOverInsExcelCom(ins.getCar_mng_id(), Integer.toString(ins_st));
						if(over_cnt == 1){
							result = "�̹� �Ϸ�ó�� �Ǿ����ϴ�.";
						}
					}
					//4. �̹� �Ϸ�ó�� �Ǿ���,���ǹ�ȣ�� �ٸ� ��, ���踶������ ���� ��� =  2�� ������ ���� 
					
					
					//5. ������/����� ���� ���� ó��
					if(String.valueOf(ht2.get("CLS_ST")).equals("7")){
						over_cnt = 1;
						result = "����� ���� �� �Դϴ�.";
					}		
					
					if(String.valueOf(ht2.get("CLS_ST")).equals("10")){
						over_cnt = 1;
						result = "������ ���� �� �Դϴ�.";
					}
					
					//6. ����ȭ���̸鼭 �����ΰ͵�(����ȭ�� ��ȣ/����ڸ� ����Ȱ�)
					 if(!String.valueOf(ht2.get("INS_CON_NO")).contains("P") && tempGubun.equals("����")){
						over_cnt = 1;
						result = "����ȭ���̸鼭 ��ȣ/����ڹ�ȣ�� ����� �� �Դϴ�.";
					} 
							
					if(over_cnt > 0){
						if(result.equals("")) result = "�̹� ��ϵǾ� �ֽ��ϴ�.";
					}else{
						 if(!ic_db.insertInsExcelCom(ins)){
							flag += 1;
							result = "��Ͽ����Դϴ�.";
						}else{
							if(result.equals("")) result = "���� ��ϵǾ����ϴ�.";
							count++;
						} 
					if(result.equals("")) result = "���� ��ϵǾ����ϴ�.";
					}
					 
					
					
				}
	%>
	<tr>
		<td align='center' style="font-size : 8pt;"><%=i+1%></td>
		<td align='center' style="font-size : 8pt;"><%=car_no%></td>
		<td align='center' style="font-size : 8pt;"><%=ins_com_no%></td>
		<td align='center' style="font-size : 8pt;"><%=car_mng_id%></td>
    <td align='center' style="font-size : 8pt;"><%=rent_l_cd%></td>
    <td align='center' style="font-size : 8pt;"><%if(!result.equals("���� ��ϵǾ����ϴ�.")){%><font color=red><%=result%></font><%}else{%><%=result%><%}%></td>
	</tr>
	<%	}%>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

