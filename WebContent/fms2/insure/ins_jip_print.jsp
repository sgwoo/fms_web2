<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%

	InsDatabase ai_db = InsDatabase.getInstance();
	

	String s_dt = request.getParameter("s_dt")==null?"20150210":request.getParameter("s_dt");
	String s_use = request.getParameter("s_use")==null?"2":request.getParameter("s_use");
	
	Vector vt = ai_db.getJipInsureCarUseList(s_dt, s_use);
	int vt_size = vt.size();
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>
<body leftmargin="15" topmargin="1" >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
<table width='800' height="230" border="0" cellpadding="0" cellspacing="0">
    <tr> 
        <td height="30" align="center"></td>
    </tr>
    <tr> 
        <td height="50" align="center" style="font-size : 18pt;"><b><font face="����"><%=s_dt%> ���� ���� ���� ����</font></b></td>
    </tr>  
  
    
       <tr bgcolor="#000000"> 
        <td align='center' height="30"> 
	    <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="0">
                <tr bgcolor="#FFFFFF" align="center"> 
                	<td  style="font-size : 10pt;  font-weight:bold" width='30' class='title'>����</td>
		<td  style="font-size : 10pt;  font-weight:bold" width='40' class='title'>����</td>
		<td  style="font-size : 10pt;  font-weight:bold" width='100' class='title'>������ȣ</td>
		<td  style="font-size : 10pt;  font-weight:bold" width='160' class='title'>�����ȣ</td>	
		<td  style="font-size : 10pt;  font-weight:bold" width='200' class='title'>��ǥ������</td>
		<td  style="font-size : 10pt;  font-weight:bold" width='80' class='title'>���Ŵ��</td>
		<td  style="font-size : 10pt;  font-weight:bold" width='100' class='title'>���纸���</td>
		<td  style="font-size : 10pt;  font-weight:bold" width='120' class='title'>������հ�</td>				
					
                 
                </tr>
            </table>
	</td>
    </tr>
 </table>
 <table width='800' " border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#000000">
        <td width="100%" align='center'>
        	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
       
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			for(int j=0; j<1; j++){
				
						t_amt1[j] += AddUtil.parseLong(String.valueOf(ht.get("CAR_CNT")));
						t_amt2[j] += AddUtil.parseLong(String.valueOf(ht.get("INS_AMT")));
						t_amt3[j] += AddUtil.parseLong(String.valueOf(ht.get("INS_T_AMT")));
			
			}
%>
				<tr bgcolor="#FFFFFF" align="center"  height="50">
					<td  style="font-size : 10pt;"   width='30' align='center'><%=i+1%></td>
					<td  style="font-size : 10pt;"   width='40' align='center'><%=ht.get("S_ST")%></td>					
					<td   style="font-size : 10pt;"  width='100' align='center'><%=ht.get("CAR_NO")%></td>							
					<td   style="font-size : 10pt;"  width='160' align='center'><%=ht.get("CAR_NUM")%></td>
					<td   style="font-size : 10pt;"   width='200' align='center'><%=ht.get("REMARKS")%></td>
					<td   style="font-size : 10pt;"  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_CNT")))%></td>			
					<td   style="font-size : 10pt;"  width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("INS_AMT")))%></td>					
					<td   style="font-size : 10pt;"  width='120' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("INS_T_AMT")))%></td>					
					
				</tr>
<%
		}
%>		
				<tr bgcolor="#FFFFFF" align="center"  height="50">
			            <td  style="font-size : 10pt;"  class=title align="center" colspan=5> &nbsp;</td>
			            <td  style="font-size : 10pt;"  style="font-size : 10pt;"  class=title style="text-align:right"><%=Util.parseDecimal(t_amt1[0])%></td>
			            <td  style="font-size : 10pt;"  class=title style="text-align:right"></td>
			            <td style="font-size : 10pt;"   class=title style="text-align:right"><%=Util.parseDecimal(t_amt3[0])%></td>
			      
			           </tr>	  
           
		</table>
	</td>
  </tr>
  
  </table>
 
</form>
</body>
</html>
<script>

onprint();


function onprint(){
	factory.printing.header 	= ""; //��������� �μ�
	factory.printing.footer 	= ""; //�������ϴ� �μ�
	factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
	factory.printing.leftMargin 	= 12.0; //��������   
	factory.printing.rightMargin 	= 12.0; //��������
	factory.printing.topMargin 	= 30.0; //��ܿ���    
	factory.printing.bottomMargin 	= 30.0; //�ϴܿ���
	factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������	
}

</script>