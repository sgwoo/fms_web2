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
<!-- MeadCo ScriptX -->

<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab" >
</object>

<body leftmargin=0 rightmargin=0 bottommargin=0 topmargin=0>
<% if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					Hashtable ht = (Hashtable)FineList.elementAt(i);	
%>

<table width=698 border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td height=20></td>
    </tr>
        <td>
            <table width=698 border=0 cellpadding=49 cellspacing=1 bgcolor=#000000>
                <tr>
                    <td bgcolor=#FFFFFF>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td height=12></td>
                            </tr>
                            <tr>
                                <td height=50 align=center><span class=style1>�뿩�� û���� �絵���� ������</span></td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td><table width=100%  border=0 cellspacing=0 cellpadding=0>
                                    <tr>
                                        <td width=45% height=30 ><span class=style3><%=ht.get("FIRM_NM")%>&nbsp;���� </span></td>
                                        <td align=right>&nbsp;</td>
                                        <td width=45% align=right><span class=style4>&nbsp&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</span></td>
                                    </tr>
                                </table></td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td><span class=style2>* <span class=style5>�뿩�� û���� �絵��</span> : &nbsp;&nbsp;����Ư���� �������� ���ǵ��� ����̾ؾ����� 8�� (��)�Ƹ���ī</span></td>
                            </tr>
                            <tr>
                                <td height=40></td>
                            </tr>
                            <tr>
                                <td><span class=style2>* <span class=style5>�뿩�� û���� �����</span> : &nbsp;&nbsp;����Ư���� �߱� ������6�� 18-12 �ֽ�ȸ�� �λ�ĳ��Ż</span></td>
                            </tr>
                            <tr>
                                <td height=70></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>�� �뿩�� û���� �絵���� &nbsp;<font color=FFFFFF>0000</font>�� &nbsp;<font color=FFFFFF>00</font>�� &nbsp;<font color=FFFFFF>00</font>�� �뿩�� û���� ����ο��� �뿩�� û���� �絵���� �ͻ�(��)�� </span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>���Ͽ� ������ ���� 1.���� �뿩�� û������ ���� �絵�Ͽ��¹�, �絵�� �뿩�� û������ ä���ڿ� ���� �뿩��</span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>û���� �絵������ �뿩�� û���� ����ο��� ���������ν�, &nbsp;�뿩�� û���� ������� �뿩�� û���� �絵���� </span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>�븮�Ͽ� �����ϰ� ä���ڿ� ���� �뿩�� û���� �絵������ �� �� �ִ� ������ �����մϴ�.</span></td>
                            </tr>
                            <tr>
                                <td height=100></td>
                            </tr>
                            <tr>
                                <td align=center><span class=style2>---------- ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ----------</span></td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td><span class=style5>[�絵 �뿩�� û������ ǥ��]</span></td>
                            </tr>
                            <tr>
                                <td height=30></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>�뿩�� û���� �絵���� �ͻ�(��)�� <font color=FFFFFF>0000</font>�� <font color=FFFFFF>00</font>�� <font color=FFFFFF>00</font>�� ü���� �Ʒ��� �뿩��࿡ ���� �뿩�� û���� �絵����</span></td>
                            </tr>
                            <tr>
                                <td height=22><span class=style2>&nbsp;<font color=FFFFFF>0000</font>�� &nbsp;<font color=FFFFFF>00</font>�� &nbsp;<font color=FFFFFF>00</font>�� ���� �ͻ�(��)�� ���Ͽ� ������ �ְų� �巡 ������ �� ��ü�� �뿩�� û����.</span></td>
                            </tr>
                            <tr>
                                <td height=100></td>
                            </tr>
                            <tr>
                                <td align=center><span class=style2>---------- ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� ----------</span></td>
                            </tr>
                            <tr>
                                <td height=60></td>
                            </tr>
                            <tr>
                                <td><span class=style2>* <span class=style5>�뿩����ȣ</span> : <span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> 
                                �� �̿� �μ��Ͽ� ü���� ��ü�� ���</span></td>
                            </tr>
                     
                            <tr>
                                <td height=22></td>
                            </tr>
                       
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
       <%  if ( i == FineList.size()-1 ) {%>
             <% } else { %>
    <tR>
        <td height=10></td>
    </tr>
      <% } %>   
</table>
 <% 	} %>
  <% 	} %>
</body>

 
</html>

<script>
onprint();

function onprint(){
factory.printing.header = ""; //��������� �μ�
factory.printing.footer = ""; //�������ϴ� �μ�
factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin = 10.0; //��������   
factory.printing.topMargin = 10.0; //��ܿ���    
factory.printing.rightMargin = 10.0; //��������
factory.printing.bottomMargin = 10.0; //�ϴܿ���
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>
