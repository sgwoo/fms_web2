<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
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
	
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function pagesetPrint(){
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
// 		IEPageSetupX.header='';
// 		IEPageSetupX.footer='';
// 		IEPageSetupX.leftMargin=10;
// 		IEPageSetupX.rightMargin=10;
// 		IEPageSetupX.topMargin=10;
// 		IEPageSetupX.bottomMargin=10;		
// 		print();
	}

function IE_Print(){
	factory1.printing.header='';
	factory1.printing.footer='';
	factory1.printing.leftMargin=10;
	factory1.printing.rightMargin=10;
	factory1.printing.topMargin=10;
	factory1.printing.bottomMargin=10;
	factory1.printing.Print(true, window);
}
//-->
</script>
<title>���� ����</title>
<style type=text/css>
<!--
.style1 {
    font-family: dotum;
	font-size: 20pt;
	font-weight: bold;
}

.style2 {
    font-family: dotum;
	font-size: 12px;
}

.style3 {
    font-family: dotum;
	font-size: 14px;
	text-decoration: underline;
	font-weight: bold;
}
.style4 {
    font-family: dotum;
	font-size: 14px;
	font-weight: bold;
}
.style5 {
    font-family: dotum;
	font-size: 12px;
	font-weight: bold;
}
-->


</style>
</head>

<body leftmargin="0" onLoad="javascript:pagesetPrint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<% if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					Hashtable ht = (Hashtable)FineList.elementAt(i);	
%>

<table width=698 border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td height=20></td>
    </tr>
        <td>
            <table width=698 border=0 cellpadding=49 cellspacing=1 bgcolor=>
                <tr>
                    <td bgcolor=#FFFFFF>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=12></td>
                            </tr>
                            <tr>
                                <td height=50 align=center><span class=style1>ä�Ǿ絵����������</span></td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td><table width=100%  border=0 cellspacing=0 cellpadding=0>
                                    <tr>
                                        <td width=45% height=30 ><span class=style3>�ֽ�ȸ��&nbsp;&nbsp;��&nbsp;��&nbsp;��&nbsp;��&nbsp;&nbsp;���� </span></td>
                                        <td align=right>&nbsp;</td>
                                        <td width=45% align=right><span class=style4>20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</span></td>
                                    </tr>
                                </table></td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td align='right'><span class=style2><U>ä�Ǿ絵��&nbsp;&nbsp;&nbsp;&nbsp;(��)�Ƹ���ī&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)</U>
								<br>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;���￵���������ǵ��� 17-3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</td>
                            </tr>
							<tr>
                                <td height=22></td>
                            </tr>
							<tr>
                                <td align='right'><span class=style2><U>ä�Ǿ����&nbsp;&nbsp;(��)�������� �����ǵ���������(��)</U>
								<br>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;���￵���������ǵ��� 14-31&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</td>
                            </tr>
                            <tr>
                                <td height=40></td>
                            </tr>
                            <tr>
                                <td></td>
                            </tr>
                            <tr>
                                <td height=70></td>
                            </tr>
                            <tr>
                                <td height=22>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ä�Ǿ絵����&nbsp; 20&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� ä�Ǿ���ο��� ä�Ǿ絵����
								<%=ht.get("FIRM_NM")%> �� ���Ͽ� ������ ���� ä���� ���� �絵�Ͽ��¹�, �絵�� ä���� ä���ڿ� ���� ä�Ǿ絵������ ä�Ǿ���ο��� ���������ν�, ä�Ǿ������ ä�Ǿ絵���� �븮�Ͽ� �����ϰ� ä���ڿ� ���� ä�Ǿ絵������ �� �� �ִ� ������ �����մϴ�.
								</td>
                            </tr>
                            <tr>
                                <td height=100></td>
                            </tr>
                            <tr>
                                <td align=center>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td><b>�絵ä���� ǥ��</b></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td height=22>&nbsp;&nbsp;ä�Ǿ絵���� <u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;��  ä���� <%=ht.get("FIRM_NM")%>&nbsp;�� ü���� �ڵ��� �뿩�̿�
                            ��࿡ ���� ä�Ǿ絵���� 20&nbsp;&nbsp;&nbsp; �� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� ä������ �ڵ��� �뿩�̿� ��࿡ ���Ͽ� ������ �ִ� ��ü�� ä��.</td>
                            </tr>
                            <tr>
                                <td align=center></td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
							<tr>
                                <td height=60></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
</table>
 <%  if ( i == FineList.size()-1 ) {%>
   <% } else { %>
   <p style='page-break-before:always'></P>   
   <% } %>
 <% 	} %>
  <% 	} %>
</body>
 
</html>


