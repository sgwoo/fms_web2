<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, java.text.*, java.util.*,jxl.*"%>
<%@ page import="acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*" %>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
		//�����û����Ʈ
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
    long t_amt4[] = new long[1];
    long t_amt5[] = new long[1];
    long t_amt6[] = new long[1];
    long t_amt7[] = new long[1];
    long t_amt8[] = new long[1];
    long t_amt9[] = new long[1];
    
    String gov_chk_id = "";
	
    Date d = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	//System.out.println("���糯¥ : "+ sdf.format(d));
	String filename = sdf.format(d)+"_�����㺸.xls";
	filename = java.net.URLEncoder.encode(filename, "UTF-8");
	response.setContentType("application/octer-stream");
	response.setHeader("Content-Transper-Encoding", "binary");
	response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
	response.setHeader("Content-Description", "JSP Generated Data");
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">	
	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 12.0; //��������   
		factory.printing.rightMargin 	= 12.0; //��������
		factory.printing.topMargin 	= 20.0; //��ܿ���    
		factory.printing.bottomMargin 	= 30.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}
</script>
</head>
<body onLoad="javascript:onprint();">
	<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30"></object>
	<form action="" name="form1" method="POST" >
		<input type='hidden' name='ck_acar_id' 	value='<%=ck_acar_id%>'>
		<table width='700' border="0" cellpadding="0" cellspacing="0">
			<tr> 
			   <td width="100%" height="30" align="left" style="font-size : 12pt;">�� �ڵ��� �����缳�� �����㺸 ���</td>
			</tr>	
		 	<tr bgcolor="#000000"> 
				<!-- td align='center'> 
					<table width="100%" border="1" cellspacing="1" cellpadding="0">
						<tr bgcolor="#000000"-->
				<td >
					<table width="100%" border="1" cellspacing="1" cellpadding="0">
						<tr bgcolor="#FFFFFF" align="center">
							<td width="10%" height="25" style="font-size: 10pt;"><font face="����">����</font></td>
							<td width="10%" height="25" style="font-size: 10pt;"><font face="����">����</font></td>
							<td width="10%" height="25" style="font-size: 10pt;"><font face="����">������ȣ</font></td>
							<td width="10%" height="25" style="font-size: 10pt;"><font face="����">ä�ǰ���</font></td>
							<td width="10%" height="25" style="font-size: 10pt;"><font face="����">������</font></td>
							<td width="10%" height="25" style="font-size: 10pt;"><font face="����">��뺻����</font></td>
							<td width="10%" height="25" style="font-size: 10pt;"><font face="����">���</font></td>
						</tr>
						<!--tr bgcolor="#FFFFFF" align="center">
							<td width="14%" height="25" style="font-size: 10pt;"><font face="����">������ڸ�</font></td>
							<td width="14%" height="25" style="font-size: 10pt;"><font face="����">���ι�ȣ</font></td>
							<td width="30%" height="25" style="font-size: 10pt;"><font face="����">�ּ�</font></td>
						</tr-->
					</table>
				</td>
			 			<!-- /tr>
					</table>
				</td-->
			</tr>
			<tr> 
		  		<td height="2" align="center"></td>
			</tr>	
			<tr bgcolor="#000000">
				<td width="100%" height="10" align='center'>
					<table width="100%" border="1" cellspacing="1" cellpadding="0">
				<% if(FineList.size()>0){
						for(int i=0; i<FineList.size(); i++){ 
							Hashtable ht = (Hashtable)FineList.elementAt(i);
							
							gov_chk_id = String.valueOf(ht.get("GOV_ID"));
						
							for(int j=0; j<1; j++){
								t_amt8[j] += AddUtil.parseLong(String.valueOf(ht.get("AMT6")));	//�㺸�� ����� �ݾ�
							}			
						
					%>
						<tr bgcolor="#FFFFFF" align="center">
							<td width="10%" height="25" style="font-size: 10pt;"><font face="����"><%=i+1%></font></td>
							<td width="10%" style="font-size: 10pt;"><font face="����">����</font></td>
							<td width="10%" style="font-size: 10pt;"><font face="����"><%=ht.get("CAR_NO")%></font></td>
							<td width="10%" style="font-size: 10pt;" align=right><font face="����"><%=Util.parseDecimal(ht.get("AMT6"))%></font></td>
							<!--td width="14%" style="font-size: 10pt;"><font face="����"><%=ht.get("NM")%></font></td>
							<td width="14%" style="font-size: 10pt;"><font face="����"><%=ht.get("APP_ST")%></font></td>
							<td width="30%" style="font-size: 10pt;"><font face="����"><%=ht.get("ADDR")%></font></td!-->
							<td width="10%" style="font-size: 10pt;"><font face="����">(��)�Ƹ���ī</font></td>
							<td width="10%" style="font-size: 10pt;"><font face="����"><%=c_db.getNameByIdCode("0032", "", String.valueOf(ht.get("CAR_EXT")))%></font></td>
							<td width="10%" style="font-size: 10pt;"><font face="����"></font></td>
						</tr>
					<%}%>
						<tr bgcolor="#FFFFFF" align="center">
							<td colspan="3" height="30"  bgcolor="#FFFFFF" style="font-size: 10pt;"><font face="����">�����ݾ� �հ�</font></td>
							<td style="font-size: 10pt;" align=right><font face="����"><%=Util.parseDecimal(t_amt8[0])%></font></td>
							<td style="font-size: 10pt;" colspan="3"><font face="����"></font></td>
						</tr>
				<%} %>
					</table>
				</td>
			</tr>
			<tr>
		 		<td height="5" align="center"></td>
		 	</tr>
		 	<!--tr bgcolor="#000000">
		 		<td width="100%" align='center'>
			 		<table width="100%" border="1" cellspacing="1" cellpadding="0">
						<tr bgcolor="#FFFFFF" align="center">
							<td colspan="4" rowspan="3"></td>
							<td height="30"  colspan="3" style="font-size: 10pt;"><font face="����">������ / ä������ ����</font></td>
							<td rowspan="2" style="font-size: 10pt;"><font face="����">���</font></td>
						</tr>	
						<tr bgcolor="#FFFFFF" align="center">
							<td height="30"  width="14%" style="font-size: 10pt;"><font face="����">������ / ä����</font></td>
							<td width="14%" style="font-size: 10pt;"><font face="����">���ι�ȣ</font></td>
							<td width="30%" style="font-size: 10pt;"><font face="����">�ּ�</font></td>
						</tr>	
						<tr bgcolor="#FFFFFF" align="center">
							<td height="40"  style="font-size: 10pt;"><font face="����" style="font-size: 10pt;">(��)�Ƹ���ī</font></td>
							<td style="font-size: 10pt;"><font face="����">115611-0019610</font></td>
							<td style="font-size: 10pt;"><font face="����">����� �������� �ǻ����8 ���E&C���� 802ȣ</font></td>
							<td width="7%">&nbsp;</td>
						</tr>	
					</table>
				</td> 
		 	</tr-->
			<tr> 
			 	<td colspan="2" height="25" style="font-size : 10pt;">
			  		<font face="����">&nbsp;
						<!--
						<% if ( gov_chk_id.equals("0018") ||  gov_chk_id.equals("0041")   ||  gov_chk_id.equals("0011")  ||  gov_chk_id.equals("0055")  ||  gov_chk_id.equals("0069")   ||  gov_chk_id.equals("0072")     ) {%>
						����ݾ��� 20% ������ ���� 
						     <% } else if ( gov_chk_id.equals("0044") ||  gov_chk_id.equals("0059")     )   { %>
						����ݾ��� 100% ������ ���� 
						  <% } else if ( gov_chk_id.equals("0058")  ||  gov_chk_id.equals("0037")  ||  gov_chk_id.equals("0011")     ||  gov_chk_id.equals("0029")   ||  gov_chk_id.equals("0033")      )   { %>
						
						<% } else { %>
						����ݾ��� 50% ������ ����
						<% } %>
						-->      
			   		</font>
			  	</td>
			</tr>	
		</table>
	</form>
</body>
</html>
