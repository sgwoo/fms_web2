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
<title>ä�Ǿ絵 ������</title>
<style type=text/css>
<!--
.style1 {
    font-family: dotum;
	font-size: 17pt;
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

<table width='698'  border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td height=20></td>
    </tr>
        <td>
            <table width=698 border=0 cellpadding=49 cellspacing=1 >
                <tr>
                    <td bgcolor=#FFFFFF>
                        <table width=100%   border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=12></td>
                            </tr>
                            <tr>
                                <td height=50 align=center>
									<table width=100%  border=0 cellspacing=0 cellpadding=0>
										<tr>
											<td width=60% height=30 align=right colspan="2" rowspan="1"><span class=style1>ä�Ǿ絵 ������</span></td>
											<td width=1% colspan="1" rowspan="3">&nbsp;</td>
											<td align=left colspan="1" rowspan="3" >
												<table width=100% border=0 cellpadding=20 cellspacing=1 bgcolor=#000000>
													<tr>
														<td bgcolor=#FFFFFF>
															<table width=100%  border=0 cellspacing=0 cellpadding=0>
																<tr>
																	<td width= align=left><span class=style2>(<%=ht.get("O_ZIP")%>) <%=ht.get("O_ADDR")%></span></td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									    <tr>
											<td></td>
											<td></td>
										</tr>
										<tr>
											<td></td>
											<td></td>
										</tr>
									</table>
								</td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td>
									<table width=100%  border=0 cellspacing=0 cellpadding=0>
										<tr>
											<td width=45% height=30 ><span class=style3><%=ht.get("FIRM_NM")%> &nbsp;&nbsp;���� </span></td>
											<td align=right>&nbsp;</td>
											<td width=45% align=right><span class=style4>20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</span></td>
										</tr>
									</table>
								</td>
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
                                <td height=25></td>
                            </tr>
							<tr>
                                <td align='right'><span class=style2><U>ä�Ǿ����&nbsp;&nbsp;(��)�������� �����ǵ���������(��)</U>
								<br>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;���￵���������ǵ��� 14-31&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td height=22>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ä�Ǿ絵����&nbsp; 20&nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� &nbsp;&nbsp;&nbsp;�� ä�Ǿ���ο��� ä���� �㺸�� ���Ͽ� ä�Ǿ絵����
								 �ͻ翡 ���Ͽ� ������ ���� 1.���� ä���� ���� �絵�Ͽ����Ƿ� �̸� �絵��, ����ο����ν� �����մϴ�.
								</td>
                            </tr>
                            <tr>
                                <td height=23></td>
                            </tr>
                            <tr>
                                <td align=center>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
                            </tr>
                            <tr>
                                <td height=23></td>
                            </tr>
                            <tr>
                                <td height=23>
									<table width=100% border=0 cellpadding=20 cellspacing=1 bgcolor=#000000>
										<tr>
											<td bgcolor=#FFFFFF>
												<table width=100% border=0 cellspacing=0 cellpadding=0>
													<tr>
														<td>
														1. �絵ä���� ǥ��<p>
														
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1) ���ΰ�� : <%=AddUtil.getDate3((String)ht.get("RENT_DT"))%>�� �ڵ��� �뿩 �̿� ���<br>
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2) ä���Ѿ� :\<%=AddUtil.parseDecimal(AddUtil.parseLong((String)ht.get("AMT4"))+AddUtil.parseLong((String)ht.get("AMT5")))%><br>
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3) ���ޱ��� : 20&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��<br>
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4)ä����(ä�Ǿ絵��) : (��)�Ƹ���ī<br>
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5) �����(�뿩�̿���) : <%=ht.get("FIRM_NM")%><br>
														2. �������<br>
														&nbsp;&nbsp;�������� (���¹�ȣ : 140-004-023871, ������ : (��)�Ƹ���ī ���� �Ա�<br>
														 &nbsp;&nbsp;&nbsp;: ��� �Աݰ��´� ���� ä�Ǿ������ (��)�������� �����ǵ����������� ���������ÿ� ����� �� ����.
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
                            </tr>
                          
                            <tr>
                                <td height=60><span class=style2>�� ÷ : �絵ä���� ���θ�(ǰ��, ����, �ܰ� ��) - �ڵ��� �뿩�̿� ��༭</span></td>
                            </tr>
							<tr>
                                <td height=100></td>
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
 <% } %>  
<% } %>
</body>
 
</html>


