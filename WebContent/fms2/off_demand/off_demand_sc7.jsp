<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.off_demand.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");

	
	OffDemandDatabase dm_db = OffDemandDatabase.getInstance();
	
	String gubun = "";
	String ref_dt1 = String.valueOf(AddUtil.parseInt(save_dt.substring(0,4))-3)+"0101"; //����������-3����
	String ref_dt2 = save_dt; //����������
	
	Vector vt = dm_db.getOffDemandStat7("1", ref_dt1, ref_dt2);		
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
  <table border="0" cellspacing="0" cellpadding="0" width=1000>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ä�ǰ���</span></td>
	  </tr>
    <tr>
	    <td>&nbsp;&nbsp;&nbsp;1. ��ü��Ȳ</td>	    
	  </tr>
        <tr>
        <td align=right>(����:�鸸��)</td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>	
	<tr>		
								<td class='line' > 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td class='title' colspan='2'>����</td>
										<td class='title' width:200px;" style="height:35px;">��ü�ݾ� �հ�(A)</td>
										<td class='title' width:200px;">�� �뿩��(B)</td>
										<td class='title' width:200px;">��ü��(A/Bx100)</td>		  
									</tr>
									<%for(int i=0;i<vt_size;i++){
										Hashtable ht = (Hashtable)vt.elementAt(i);																													
									%>
									<tr>
											<td class='title' rowspan='2' width:150px;><%=AddUtil.ChangeDate2(ht.get("SAVE_DT")+"")%></td>
											<td class='title' style="height:35px;width:100px;text-align:center;">�Ǽ�</td>
											<td style="height:35px;width:250px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("DLY_CNT6")+"")%></td>
											<td rowspan='2' style="height:35px;width:250px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("DLY_AMT8")+"")%></td>
											<td rowspan='2' style="height:35px;width:250px;text-align:center;"><%=ht.get("DLY_PER")%>%</td>
									</tr>		
									<tr>											
											<td class='title' style="height:35px;width:100px;text-align:center;">�ݾ�</td>
											<td style="height:35px;width:250px;text-align:center;"><%=AddUtil.parseDecimal(ht.get("DLY_AMT7")+"")%></td>
									</tr>								
									<%}%>
								</table>
								</td>
							</tr>
							
    <tr>
        <td>&nbsp;</td>
    </tr>
    <tr>
	    <td>&nbsp;&nbsp;&nbsp;2. ��ü�Ⱓ����Ȳ</td>	    
	  </tr>
        <tr>
        <td align=right>(����:��)</td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>	
	<tr>		
								<td class='line' > 
								<table border="0" cellspacing="1" cellpadding="0" width=100%>
									<tr>
										<td class='title' colspan='2' rowspan='2'>����</td>
										<td class='title' colspan='4'>��ü�Ⱓ</td>
										<td class='title' rowspan='2' style="width:150px;">�հ�</td>
									</tr>
									<tr>										
										<td class='title' style="width:150px;height:35px;">1�����̸�</td>
										<td class='title' style="width:150px;">1��~2��</td>
										<td class='title' style="width:150px;">3��~4��</td>		  
										<td class='title' style="width:150px;">4���̻�</td>
									</tr>
									<%for(int i=0;i<vt_size;i++){
										Hashtable ht = (Hashtable)vt.elementAt(i);																													
									%>
									<tr>
											<td class='title' rowspan='2' width:150px;><%=AddUtil.ChangeDate2(ht.get("SAVE_DT")+"")%></td>
											<td class='title' style="height:35px;width:100px;text-align:center;">�Ǽ�(���뿩��)</td>
											<td style="height:35px;width:150px;text-align:right;"><%=AddUtil.parseDecimal(ht.get("DLY_CNT2")+"")%></td>
											<td style="height:35px;width:150px;text-align:right;"><%=AddUtil.parseDecimal(ht.get("DLY_CNT3")+"")%></td>
											<td style="height:35px;width:150px;text-align:right;"><%=AddUtil.parseDecimal(ht.get("DLY_CNT4")+"")%></td>
											<td style="height:35px;width:150px;text-align:right;"><%=AddUtil.parseDecimal(ht.get("DLY_CNT5")+"")%></td>
											<td style="height:35px;width:150px;text-align:right;"><%=AddUtil.parseDecimal(ht.get("DLY_CNT6")+"")%></td>
									</tr>		
									<tr>											
											<td class='title' style="height:35px;width:100px;text-align:center;">�ݾ�</td>
											<td style="height:35px;width:150px;text-align:right;"><%=AddUtil.parseDecimal(ht.get("DLY_AMT2")+"")%></td>
											<td style="height:35px;width:150px;text-align:right;"><%=AddUtil.parseDecimal(ht.get("DLY_AMT3")+"")%></td>
											<td style="height:35px;width:150px;text-align:right;"><%=AddUtil.parseDecimal(ht.get("DLY_AMT4")+"")%></td>
											<td style="height:35px;width:150px;text-align:right;"><%=AddUtil.parseDecimal(ht.get("DLY_AMT5")+"")%></td>
											<td style="height:35px;width:150px;text-align:right;"><%=AddUtil.parseDecimal(ht.get("DLY_AMT6")+"")%></td>
									</tr>								
									<%}%>
								</table>
								</td>
							</tr>		
	  <tr>
	    <td>�� ��� �Ǽ��� �ŷ�ó�� �ƴ� ���뿩�� �Ǽ���.</td>	    
	  </tr>
	  <tr>
	    <td>�� ÷��(��ü���� ȭ�� ��ĵ����) ����</td>	    
	  </tr>
	  <tr>
	    <td>�� ��ü = (d+1�� �̻�)</td>	    
	  </tr>
							
  </table>
</form>
</body>
</html>
