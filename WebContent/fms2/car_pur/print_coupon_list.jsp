<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	String pay_dt 	= request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	String off_nm 	= request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	
	
	
	s_kd 	= "7";
	t_wd 	= off_nm;
	gubun2 	= "2";
	st_dt 	= pay_dt;
	end_dt 	= pay_dt;
	gubun3 	= "E";
	
	Vector vt = a_db.getCarPurCouPonList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
</head>

<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
<!--<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" viewastext codebase="http://www.meadroid.com/scriptx/smsx.cab#Version=6,3,435,20">-->
</object>
<center>
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>����������� ���޸���Ʈ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>		
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='20%'>���¾�ü</td>
                    <td>&nbsp;<%=off_nm%></td>
                </tr>
                <tr> 
                    <td class='title'>��������</td>
                    <td>&nbsp;<%=pay_dt%></td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td>&nbsp;</td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='5%' class='title'>����</td>
        		    <td width='20%' class='title'>�����ȣ</td>
        		    <td width="25%" class='title'>�����ȣ</td>
        		    <td width="30%" class='title'>�������</td>					
               		<td width='20%' class='title'>��������</td>					
       			</tr>		
		  		<%
					for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
		  		%>
		        <tr>
        			<td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("RPT_NO")%></td>
        		    <td align='center'><%=ht.get("CAR_NUM")%></td>
        		    <td align='center'><%=ht.get("CAR_OFF_NM")%></td>					
               		<td align='center'><%=ht.get("COM_COUPON_NM")%></td>					
       			</tr>
				<%}%>
		    </table>
	    </td>
    </tr>  		    	
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr> 
        <td style="font-size:16pt">&nbsp;&nbsp;&nbsp;&nbsp;���� ���� ���� <b><%=vt_size%>��</b>�� �����մϴ�.</td>
    </tr>	
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr> 
        <td align="right" style="font-size:16pt">(��)�Ƹ���ī&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>	
</table>
</form>
<script language="JavaScript" type="text/JavaScript">
function onprint(){
factory.printing.header 		= ""; //��������� �μ�
factory.printing.footer 		= ""; //�������ϴ� �μ�
factory.printing.portrait 		= false; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin 	= 10; //��������   
factory.printing.rightMargin 	= 10; //��������
factory.printing.topMargin 		= 10; //��ܿ���    
factory.printing.bottomMargin 	= 10; //�ϴܿ���
//factory.printing.Print(false, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
</script>
</center>
</body>
</html>
