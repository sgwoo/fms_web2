<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "07", "04", "07");
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		var fm = document.form1;
		
		if(fm.filename.value == ''){				alert('������ �����Ͻʽÿ�.'); 				return; 	}
		if(fm.filename.value.indexOf('xls') == -1){		alert('���������� �ƴմϴ�.');				return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){		alert('Excel97-2003���չ���(*.xls)�� �ƴմϴ�.');	return;		}
		
		
		if(fm.gubun[0].checked == true)					fm.action = 'lc_rent_excel_var.jsp';
		else if(fm.gubun[1].checked == true)		fm.action = 'lc_rent_excel_var2.jsp';
		//else if(fm.gubun[1].checked == true)		fm.action = 'https://fms3.amazoncar.co.kr/fms2/pur_com/lc_rent_excel2_var.jsp';

		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		fm.submit();
	}
//-->
</script>
</head>

<body leftmargin="15">
<form name='form1' action='' method='post' enctype="multipart/form-data">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������� > <span class=style5>�������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>    
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���������� �̿��� Ư�ǰ�� ��� ó��</span></td>
    </tr>        
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>    
                <tr>
                    <td width="100" class='title'>����ã��</td>
                    <td>&nbsp;<input type="file" name="filename" size="70"></td>
                </tr>
                <tr>
                    <td width="100" class='title'>����</td>
                    <td>&nbsp;
                        <input type="radio" name="gubun" value="1">
            			�ű԰�� ���
            		<br>	
            		&nbsp;
            		<input type="radio" name="gubun" value="2">
            			������Ȳ - ��������, ���������ϸ�  ����
            	    </td>
                </tr>
            </table>
	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td>* Excel97-2003���չ���(*.xls)�� ����Ͻʽÿ�.</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
        <td align="center">
          <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
	</td>
    </tr>
    <%}%>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>    
    <tr>
        <td align="right">&nbsp;</td>
    </tr>    
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� ���� [�ű԰�� ���]</span></td>
    </tr>      
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>    
                <tr>
                    <td class='title'>A</td>
                    <td class='title'>B</td>
                    <td class='title'>C</td>        	    
                    <td class='title'>D</td>
                    <td class='title'>E</td>
        	    <td class='title'>F</td>
        	    <td class='title'>G</td>		          	            	    
        	    <td class='title'>H</td>
        	    <td class='title'>I</td>
        	    <td class='title'>J</td>
        	    <td class='title'>K</td>
        	    <td class='title'>L</td>
        	    <td class='title'>M</td>
        	    <td class='title'>N</td>
        	    <td class='title'>O</td>
                </tr>
                <tr>
                    <td align='center' style="font-size : 8pt;">�Ƹ���ī<br>����ȣ</td>
                    <td align='center' style="font-size : 8pt;">Ư��<br>����ȣ</td>
                    <td align='center' style="font-size : 8pt;">���������</td>        	    
                    <td align='center' style="font-size : 8pt;">�����</td>
                    <td align='center' style="font-size : 8pt;">����</td>
        	    <td align='center' style="font-size : 8pt;">���û��</td>
        	    <td align='center' style="font-size : 8pt;">����<br>(����/����)</td>		          	            	    
        	    <td align='center' style="font-size : 8pt;">��������</td>
        	    <td align='center' style="font-size : 8pt;">�鼼����</td>
        	    <td align='center' style="font-size : 8pt;">�μ���</td>
        	    <td align='center' style="font-size : 8pt;">Ź�۷�</td>
        	    <td align='center' style="font-size : 8pt;">�������Ѿ�</td>
        	    <td align='center' style="font-size : 8pt;">DC�ݾ�</td>
        	    <td align='center' style="font-size : 8pt;">�߰�D/C</td>
        	    <td align='center' style="font-size : 8pt;">DC������</td>
                </tr>
                <tr>
                    <td align='center' style="font-size : 8pt;">S112HDMR00082</td>
                    <td align='center' style="font-size : 8pt;">A3613SF000170</td>
                    <td align='center' style="font-size : 8pt;">2013-01-31</td>
        	    <td align='center' style="font-size : 8pt;">�ƻ�</td>
                    <td align='center' style="font-size : 8pt;">��Ÿ��(����) R2.0 2WD Premium(5�ν�)</td>
                    <td align='center' style="font-size : 8pt;">Convenience Pack Luxury Seat Pack </td>
                    <td align='center' style="font-size : 8pt;">�̽�ƽ������/����</td>
        	    <td align='right' style="font-size : 8pt;">30,220,000</td>
        	    <td align='right' style="font-size : 8pt;">28,904,830</td>
        	    <td align='center' style="font-size : 8pt;">����</td>
        	    <td align='right' style="font-size : 8pt;">100,000</td>
        	    <td align='right' style="font-size : 8pt;">29,004,830</td>
        	    <td align='right' style="font-size : 8pt;">100,000</td>
        	    <td align='right' style="font-size : 8pt;">300,000</td>
        	    <td align='right' style="font-size : 8pt;">28,604,830</td>
                </tr>                
            </table>
	</td>
    </tr>   
    <tr>
        <td align="right">&nbsp;</td>
    </tr>    
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������� ���� [������Ȳ - ���������� ����] : ������Ȳ���� [����] �ٿ�ε� ���� ����</span></td>
    </tr>       
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>    
                <tr>
                    <td class='title'>A</td>
                    <td class='title'>B</td>
                    <td class='title'>C</td>        	    
                    <td class='title'>D</td>
                    <td class='title'>E</td>
        	    <td class='title'>F</td>
        	    <td class='title'>G</td>		          	            	    
        	    <td class='title'>H</td>
        	    <td class='title'>I</td>
        	    <td class='title'>J</td>
        	    <td class='title'>K</td>
        	    <td class='title'>L</td>
        	    <td class='title'>M</td>
        	    <td class='title'>N</td>
        	    <td class='title'>O</td>
                    <td class='title'>P</td>
        	    <td class='title'>Q</td>
        	    <td class='title'>R</td>		          	            	    
        	    <td class='title'>S</td>
        	    <td class='title'>T</td>
        	    <td class='title'>U</td>
        	    <td class='title'>V</td>
        	    <td class='title'>W</td>
        	    <td class='title'>X</td>
                </tr>
                <tr>
                    <td align='center' style="font-size : 8pt;">����</td>
                    <td align='center' style="font-size : 8pt;">����</td>
                    <td align='center' style="font-size : 8pt;" class=is><font color=red>Ư�ǰ���ȣ</font></td>                    
                    <td align='center' style="font-size : 8pt;">�������</td>
                    <td align='center' style="font-size : 8pt;">��������</td>        	    
                    <td align='center' style="font-size : 8pt;" class=is><font color=red>��������</font></td>       		
                    <td align='center' style="font-size : 8pt;" class=is><font color=red>����������</font></td>       		
        	    <td align='center' style="font-size : 8pt;">���汸��</td>
                    <td align='center' style="font-size : 8pt;">������</td>
                    <td align='center' style="font-size : 8pt;">ó������</td>     
                    <td align='center' style="font-size : 8pt;">������</td>                    
                    <td align='center' style="font-size : 8pt;">������</td>                   
                    <td align='center' style="font-size : 8pt;">����</td>                    
        	    <td align='center' style="font-size : 8pt;">���û��</td>
        	    <td align='center' style="font-size : 8pt;">����</td>		  
        	    <td align='center' style="font-size : 8pt;">�μ���</td>
        	    <td align='center' style="font-size : 8pt;">��������</td>
        	    <td align='center' style="font-size : 8pt;">��������</td>
        	    <td align='center' style="font-size : 8pt;">DC�ݾ�</td>        	    
        	    <td align='center' style="font-size : 8pt;" class=is><font color=red>�߰�D/C</font></td>        	    
        	    <td align='center' style="font-size : 8pt;">Ź�۷�</td>        	    
        	    <td align='center' style="font-size : 8pt;">�����ݾ�</td>        	            	            	            	    
        	    <td align='center' style="font-size : 8pt;">�����</td>
        	    <td align='center' style="font-size : 8pt;">���ʿ�����</td>        	
                </tr>     
            </table>
	</td>
    </tr>       
</table>
</form>
</center>
</body>
</html>