<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
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
	
	
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
// 	function pagesetPrint(){
// 		IEPageSetupX.header='';
// 		IEPageSetupX.footer='';
// 		IEPageSetupX.leftMargin=12;
// 		IEPageSetupX.rightMargin=12;
// 		IEPageSetupX.topMargin=30;
// 		IEPageSetupX.bottomMargin=30;	
<%-- 	<%if(FineDocBn.getPrint_dt().equals("")){%> --%>
// 		//print();
<%-- 	<%}%> --%>
// 	}
//-->
function onprint(){
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}

function IE_Print() {
	factory1.printing.header = ""; //��������� �μ�
	factory1.printing.footer = ""; //�������ϴ� �μ�
	factory1.printing.portrait = true; //true-�����μ�, false-�����μ�    
 	factory1.printing.leftMargin = 12.0; //��������   
 	factory1.printing.rightMargin = 12.0; //��������
 	factory1.printing.topMargin = 30.0; //��ܿ���    
 	factory1.printing.bottomMargin = 30.0; //�ϴܿ���
	factory1.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" font face="����">
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form action="" name="form1" method="POST" >
  <table width='670' border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="100%" height="40" align="center" style="font-size : 18pt;"><b><font face="����">��&nbsp;��&nbsp;��&nbsp;û&nbsp;��</font></b></td>
    </tr>
    <tr> 
      <td height="10" align="center"></td>
    </tr>
    <tr> 
      <td height="25" align="center" style="font-size : 9pt;"><font face="����">(�ҹ� ��.�������� ���·� ó��)</font></td>
    </tr>
    <tr> 
      <td height="10" align="center"></td>
    </tr>	
    <tr> 
      <td height="25" style="font-size : 10pt;">��&nbsp;������Ȳ</td>
    </tr>	
    <tr> 
      <td height="10" align="center"></td>
    </tr>	
    <tr bgcolor="#000000"> 
      <td align='center'> 
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr  bgcolor="#000000"> 
            <td> 
			  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr bgcolor="#FFFFFF" align="center">
                  <td width="10%" rowspan="3" style="font-size : 10pt;"><font face="����">����<br>������</font></td>
                  <td width="15%" rowspan="2" style="font-size : 10pt;"><font face="����">������ȣ</font></td>
                  <td width="30%" rowspan="2" style="font-size : 10pt;">&nbsp;</td>
                  <td width="15%" height="25" style="font-size : 10pt;"><font face="����">����(��ü��)</font></font></td>
                  <td width="30%" height="25" style="font-size : 10pt;">&nbsp;</td>
                </tr>
                <tr bgcolor="#FFFFFF" align="center">
                  <td height="25" style="font-size : 10pt;"><font face="����">�ֹ�(����)��ȣ</font></td>
                  <td height="25" style="font-size : 10pt;">&nbsp;</td>
                </tr>
                <tr bgcolor="#FFFFFF" align="center">
                  <td width="15%" height="25" style="font-size : 10pt;"><font face="����">�ּ�</font></td>
                  <td height="25" colspan="3" style="font-size : 10pt;">&nbsp;</td>
                </tr>
                <tr bgcolor="#FFFFFF" align="center">
                  <td width="10%" rowspan="3" style="font-size : 10pt;"><font face="����">���ݴ��<br>
                  ������</font></td>
                  <td width="15%" height="25" style="font-size : 10pt;"><font face="����">����</font></td>
                  <td height="25" style="font-size : 8pt;">&nbsp;</td>
                  <td height="25" style="font-size : 10pt;"><font face="����">�ֹε�Ϲ�ȣ</font></td>
                  <td height="25" style="font-size : 10pt;">&nbsp;</td>
                </tr>
                <tr bgcolor="#FFFFFF">
                  <td width="15%" height="25" align="center" style="font-size : 10pt;"><font face="����">�ּ�</font></td>
                  <td height="25" colspan="3" style="font-size : 8pt;">&nbsp;</td>
                </tr>
                <tr bgcolor="#FFFFFF">
                  <td width="15%" height="25" align="center" style="font-size : 10pt;"><font face="����">���ֿ��ǰ���</font></td>
                  <td width="13%" height="25" style="font-size : 8pt;">&nbsp;</td>
                  <td width="15%" height="25" align="center" bgcolor="#FFFFFF" style="font-size : 10pt;"><font face="����">����ó</font></td>
                  <td width="15%" height="25" align="center" bgcolor="#FFFFFF" style="font-size : 8pt;">&nbsp;</td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="25" align="center"></td>
    </tr>	
    <tr> 
      <td height="25" style="font-size : 10pt;">��&nbsp;���ǽ�û����(��ü������ ����)</td>
    </tr>	
    <tr> 
      <td height="25" align="center"></td>
    </tr>	
    <tr> 
      <td height="25">&nbsp;&nbsp;&nbsp;&nbsp;÷�μ��� ����</td>
    </tr>		
    <tr> 
      <td height="200" align="center">&nbsp;</td>
    </tr>	
	
    <tr> 
      <td height="25" style="font-size : 10pt;"><font face="����">�� ���·� ���ΰ������� ���� ������ 30���̳� ��û ����</font></td>
    </tr>
    <tr> 
      <td height="25" style="font-size : 10pt;"><font face="����">÷&nbsp;�� : ���·� ���ΰ�����, �����ڷ�</font></td>
    </tr>
    <tr> 
      <td height="25" align='center'>&nbsp;</td>
    </tr>
    <tr> 
      <td align='center' height="25" style="font-size : 13pt;"><font face="����"><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></font></td>
    </tr>
    <tr> 
      <td height="25" align='center'>&nbsp;</td>
    </tr>
    <tr> 
      <td align='right' height="25" style="font-size : 12pt;"><font face="����">����û�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)�Ƹ���ī&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(����)</font></td>
    </tr>
    <tr> 
      <td height="25" align='center'>&nbsp;</td>
    </tr>
    <tr> 
      <td height="25" style="font-size : 12pt;"><font face="����"><%=FineGovBn.getGov_nm()%> ����</font></td>
    </tr>
  </table>
</form>
</body>
</html>
