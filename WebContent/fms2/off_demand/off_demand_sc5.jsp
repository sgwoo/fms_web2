<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.off_demand.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
	
	String gubun = "";
	String ref_dt1 = String.valueOf(AddUtil.parseInt(save_dt.substring(0,4))-2)+"0101"; //����������-2����
	String ref_dt2 = save_dt; //����������
	
	Vector vt = dm_db.getOffDemandStat4("2", ref_dt1, ref_dt2);		
	int vt_size = vt.size();	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='off_demand_sc1.jsp' method='post' target='t_content'>
  <table border="0" cellspacing="0" cellpadding="0" width=1164>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ű����� ���� �� �Ű�����</span></td>
	  </tr>
    <tr>
        <td align=right>(����:����, õ��)</td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>	
	<tr>		
								<td class='line' > 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td class='title' rowspan='2'>����</td>
										<%for (int j = AddUtil.parseInt(save_dt.substring(0,4))-2 ; j <= AddUtil.parseInt(save_dt.substring(0,4)) ; j++){%>
										<td  class='title' colspan='2'>
											<%	if(j==AddUtil.parseInt(save_dt.substring(0,4)) && !save_dt.substring(5,7).equals("12")){%>
												<%=j%>��(<%=AddUtil.ChangeDate(AddUtil.replace(save_dt,"-",""),"MM��DD��")%>)
											<%}else{%>
												<%=j%>��
											<%}%>
										</td>
										<%} %>
										<td class='title' width:100px;" rowspan='2'>���</td>
									</tr>
									<tr>
										<%for (int j = AddUtil.parseInt(save_dt.substring(0,4))-2 ; j <= AddUtil.parseInt(save_dt.substring(0,4)) ; j++){%>
										<td  class='title'>����</td>
										<td  class='title'>��Ʈ</td>
										<%} %>
									</tr>
									<tr>											
											<td class='title' style="height:35px;width:164px;text-align:center;">����(���)</td>
											<%for(int i=0;i<vt_size;i++){
												Hashtable ht = (Hashtable)vt.elementAt(i);																													
											%>					
											<td style="height:35px;width:150px;text-align:center;"><%=ht.get("USE_MON")%></td>
											<%} %>						
											<td style="height:35px;width:100px;text-align:center;"></td>
									</tr>		
									<tr>											
											<td class='title' style="height:35px;width:164px;text-align:center;">�Ű���(���)</td>
											<%for(int i=0;i<vt_size;i++){
												Hashtable ht = (Hashtable)vt.elementAt(i);																													
											%>					
											<td style="height:35px;width:150px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("SUP_AMT")+"")%></td>
											<%} %>						
											<td style="height:35px;width:100px;text-align:center;"></td>
									</tr>	
								</table>
								</td>
							</tr>
							
  </table>
</form>
</body>
</html>
