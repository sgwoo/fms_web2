<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");

	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");

	String st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st");	
	String reg_dt = request.getParameter("gubun_reg_dt")==null?"":request.getParameter("gubun_reg_dt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddForfeitHanDatabase afm_db = AddForfeitHanDatabase.getInstance();
	
	Vector fines = afm_db.SFineCostList(gubun1, st_year, st_mon, reg_dt, st);
	int fine_size = fines.size();
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
<table border="0" cellspacing="0" cellpadding="0" width='1160'>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar colspan='20'>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;������ > ���·���� > <span class=style1><span class=style5>���·Ḯ��Ʈ (<%if(st.equals("1")){%>������<%}else if(st.equals("2")){%>���ΰ���<%}else{%>������<%}%>)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='30' class='title'>����</td>
                    <td width='80' class='title'>������ȣ</td>
                    <td width="120" class='title'>����</td>
                    <td width=110 class='title'>�����Ͻ�</td>
                    <td width=120 class='title'>û�����</td>
                    <td width=150 class='title'>���ݳ���</td>
                    <td width=320 class='title'>���</td>
                    <td width=50 class='title'>��ĵ<br>����</td>
                    <td width=100 class='title'>�����</td>
                    <td width=80 class='title'>�������</td>
                </tr>
				<%		for (int i = 0 ; i < fine_size ; i++){
							Hashtable fine = (Hashtable)fines.elementAt(i);
				%>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=fine.get("CAR_NO")%></td>
                    <td align='center'><%=fine.get("CAR_NM")%></td>
                    <td align='center'><%=fine.get("VIO_DT")%></td>
                    <td align='center'><%=fine.get("GOV_NM")%></td>
                    <td align='center'><%=fine.get("VIO_CONT")%></td>
                    <td align='center'><%=fine.get("NOTE")%></td>
                    <td align='center'><%=fine.get("FILE_1_CNT")%>��</td>
                    <td align='center'><%=fine.get("USER_NM")%></td>
                    <td align='center'><%=fine.get("REG_DT")%></td>                    
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
