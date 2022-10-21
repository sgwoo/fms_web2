<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String set_code  = Long.toString(System.currentTimeMillis());
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=inside_req_list8_2_excel_"+set_code+".xls");
%>
<%@ page import="java.util.*,acar.util.*, java.net.*"%>
<%@ page import="acar.admin.*,acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>


<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");	
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String jg_code 	= request.getParameter("jg_code")	==null?"":request.getParameter("jg_code");
	String car_nm 	= request.getParameter("car_nm")	==null?"":request.getParameter("car_nm");
	if(!car_nm.equals("")) car_nm = URLEncoder.encode(car_nm, "EUC-KR");

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector jarr = ad_db.getInsideReq08_2(start_dt, end_dt, jg_code, car_nm);
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

  <table border="1" cellspacing="0" cellpadding="0" width=7308>
	<tr>
  <td width=56 style='border-left:none;width:42pt'>����</td>
  <td width=105 style='border-left:none;width:79pt'>�븮��</td>
  <td width=175 style='border-left:none;width:131pt'>�����ȣ</td>
  <td width=77 style='border-left:none;width:58pt'>��������</td>
  <td width=105 style='border-left:none;width:79pt'>�����ڵ�</td>
  <td width=112 style='border-left:none;width:84pt'>�������ڵ�</td>
  <td width=161 style='border-left:none;width:121pt'>����</td>
  <td width=105 style='border-left:none;width:79pt'>����</td>
  <td width=105 style='border-left:none;width:79pt'>��ⷮ</td>
  <td width=91 style='border-left:none;width:68pt'>���ӱ�</td>
  <td width=91 style='border-left:none;width:68pt'>����</td>
  <td width=252 style='border-left:none;width:189pt'>��</td>
  <td width=105 style='border-left:none;width:79pt'>���ڵ�</td>
  <td width=105 style='border-left:none;width:79pt'>�Ϸù�ȣ</td>
  <td width=112 style='border-left:none;width:84pt'>������ȣ</td>
  <td width=119 style='border-left:none;width:89pt'>����������ȣ</td>
  <td width=112 style='border-left:none;width:84pt'>���ʵ����</td>
  <td width=91 style='border-left:none;width:68pt'>�������</td>
  <td width=91 style='border-left:none;width:68pt'>�Ϲݽ¿�LPG������������</td>
  <td width=126 style='border-left:none;width:95pt'>�����Һ��ڰ�</td>
  <td width=105 style='border-left:none;width:79pt'>�����ɼǰ�</td>
  <td width=91 style='border-left:none;width:68pt'>��������</td>
  <td width=112 style='border-left:none;width:84pt'>�����հ�ݾ�</td>
  <td width=105 style='border-left:none;width:79pt'>���ް�</td>
  <td width=105 style='border-left:none;width:79pt'>�ΰ���</td>
  <td width=105 style='border-left:none;width:79pt'>�鼼��</td>
  <td width=105 style='border-left:none;width:79pt'>����DC</td>
  <td width=105 style='border-left:none;width:79pt'>������</td>
  <td width=371 style='border-left:none;width:278pt'>�ɼ�</td>
  <td width=161 style='border-left:none;width:121pt'>�������</td>
  <td width=182 style='border-left:none;width:137pt'>�������</td>
  <td width=182 style='border-left:none;width:137pt'>���Ͻ�����</td>
  <td width=112 style='border-left:none;width:84pt'>��������</td>
  <td width=140 style='border-left:none;width:105pt'>����ȣ</td>
  <td width=112 style='border-left:none;width:84pt'>�����</td>
  <td width=161 style='border-left:none;width:121pt'>��ȣ</td>
  <td width=77 style='border-left:none;width:58pt'>���Ⱓ</td>
  <td width=105 style='border-left:none;width:79pt'>�����ִ��ܰ�</td>
  <td width=77 style='border-left:none;width:58pt'>���Կɼ�</td>
  <td width=112 style='border-left:none;width:84pt'>������</td>
  <td width=91 style='border-left:none;width:68pt'>��������</td>
  <td width=112 style='border-left:none;width:84pt'>������</td>
  <td width=77 style='border-left:none;width:58pt'>��������</td>
  <td width=112 style='border-left:none;width:84pt'>���ô뿩��</td>
  <td width=105 style='border-left:none;width:79pt'>���ô뿩�� ������</td>
  <td width=112 style='border-left:none;width:84pt'>��������ݾ�</td>
  <td width=105 style='border-left:none;width:79pt'>�������</td>
  <td width=112 style='border-left:none;width:84pt'>���뿩��</td>
  <td width=105 style='border-left:none;width:79pt'>���ʿ�����</td>
  <td width=91 style='border-left:none;width:68pt'>�μ���</td>
  <td width=91 style='border-left:none;width:68pt'>�������</td>
  <td width=406 style='border-left:none;width:305pt'>�����ּ�</td>
  <td width=161 style='border-left:none;width:121pt'>�����ȣ</td>
  <td width=105 style='border-left:none;width:79pt'>�����̿���</td>
  <td width=126 style='border-left:none;width:95pt'>�޴���</td>
  <td width=231 style='border-left:none;width:173pt'>�̸����ּ�</td>
  <td width=112 style='border-left:none;width:84pt'>��������Ÿ�</td>
  <td width=91 style='border-left:none;width:68pt'>����������</td>
	</tr>
	<%	for(int i = 0 ; i < jarr_size ; i++) {			
			Hashtable ht = (Hashtable)jarr.elementAt(i);%>
	<tr>
				<td><%=i+1%></td>
				<td><%=ht.get("CAR_OFF_NM")%></td>
				<td><%=ht.get("CAR_NUM")%></td>
				<td><%=ht.get("S_ST")%></td>
				<td><%=ht.get("JG_CODE")%></td>
				<td><%=ht.get("SH_CODE")%></td>
				<td><%=ht.get("CAR_NM")%></td> 
				<td><%=ht.get("CAR_Y_FORM")%></td>
				<td><%=ht.get("DPM")%></td>
				<td><%=ht.get("AUTO_YN")%></td>
				<td><%=ht.get("FUEL_KD")%></td>
				<td><%=ht.get("CAR_NAME")%></td>
				<td><%=ht.get("CAR_ID")%></td>
				<td><%=ht.get("CAR_SEQ")%></td>
				<td><%=ht.get("CAR_NO")%></td>
				<td><%=ht.get("FIRST_CAR_NO")%></td>
				<td><%=ht.get("INIT_REG_DT")%></td>
				<td><%=ht.get("DLV_DT")%></td>
				<td><%=ht.get("JG_2")%></td>
				<td><%=AddUtil.parseDecimal(ht.get("CAR_AMT"))%></td>
				<td><%=AddUtil.parseDecimal(ht.get("OPT_AMT"))%></td>
				<td><%=AddUtil.parseDecimal(ht.get("CLR_AMT"))%></td>
				<td><%=AddUtil.parseDecimal(ht.get("SUM_AMT"))%></td>
				<td><%=AddUtil.parseDecimal(ht.get("CAR_FS_AMT"))%></td>
				<td><%=AddUtil.parseDecimal(ht.get("CAR_FV_AMT"))%></td>
				<td><%=AddUtil.parseDecimal(ht.get("CAR_FSV_AMT"))%></td>
				<td><%=AddUtil.parseDecimal(ht.get("DC_AMT"))%></td>
				<td><%=AddUtil.parseDecimal(ht.get("ECAR_PUR_SUB_AMT"))%></td>		
				<td><%=ht.get("OPT")%></td>
				<td><%=ht.get("COLO")%></td>
				<td><%=ht.get("IN_COL")%></td>
				<td><%=ht.get("GARNISH_COL")%></td>
				<td><%=ht.get("PURC_GU")%></td>
				<td><%=ht.get("RENT_L_CD")%></td>
				<td><%=ht.get("RENT_DT")%></td>
				<td><%=ht.get("FIRM_NM")%></td>
				<td><%=ht.get("CON_MON")%></td>
				<td><%=ht.get("MAX_JA")%></td>
				<td><%=ht.get("OPT_PER")%></td>
				<td><%=AddUtil.parseDecimal(ht.get("GRT_AMT_S"))%></td>
				<td><%=ht.get("GUR_P_PER")%></td>
				<td><%=AddUtil.parseDecimal(ht.get("PP_AMT"))%></td>
				<td><%=ht.get("PERE_R_PER")%></td>				
				<td><%=AddUtil.parseDecimal(ht.get("IFEE_AMT"))%></td>
				<td><%=ht.get("PERE_R_MTH")%></td>
				<td><%=AddUtil.parseDecimal(ht.get("GI_AMT"))%></td>
				<td><%=ht.get("CLS_R_PER")%></td>
				<td><%=AddUtil.parseDecimal(ht.get("RENT_FEE"))%></td>				
				<td><%=ht.get("USER_NM")%></td>
				<td><%=ht.get("NM")%></td>
				<td><%=ht.get("CAR_EXT")%></td>
				<td><%=ht.get("P_ADDR")%></td>				
				<td><%=ht.get("RPT_NO")%></td>			
				<td><%=ht.get("MGR_NM")%></td>
				<td><%=ht.get("MGR_M_TEL")%></td>
				<td><%=ht.get("MGR_EMAIL")%></td>
				<td><%=AddUtil.parseDecimal(ht.get("AGREE_DIST"))%></td>
				<td><%=ht.get("CAR_COMP_ID")%></td>
	</tr>
	<%	}%>
  </table>
</body>
</html>
